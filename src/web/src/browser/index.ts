import * as github from '@asap/shared/domain/github';
import { AnnotateXMLUseCase } from '@asap/shared/use-cases/annotate-xml';
import {
  ValidateSSPUseCase,
  ValidateSSPUrlUseCase,
} from '@asap/shared/use-cases/validate-ssp-xml';

import { highlightXML } from '@asap/shared/adapters/highlight-js';
import {
  SaxonJsJsonSspToXmlProcessor,
  SaxonJsSchematronProcessorGateway,
} from '@asap/shared/adapters/saxon-js-gateway';

import { browserController } from './browser-controller';
import { createPresenter } from './presenter';
import { createAppRenderer } from './views';

// The npm version of saxon-js is for node; currently, we load the browser
// version via a script tag in index.html.
const SaxonJS = (window as any).SaxonJS;

type BrowserContext = {
  element: HTMLElement;
  debug: boolean;
  baseUrl: string;
  importMetaHot: ImportMetaHot | undefined;
  githubRepository: github.GithubRepository;
};

export const runBrowserContext = ({
  element,
  baseUrl,
  debug,
  importMetaHot,
  githubRepository,
}: BrowserContext) => {
  // Set SaxonJS log level.
  SaxonJS.setLogLevel(2);

  const jsonSspToXml = SaxonJsJsonSspToXmlProcessor({
    sefUrl: `${baseUrl}/oscal_ssp_json-to-xml-converter.sef.json`,
    SaxonJS,
  });
  const processSchematron = SaxonJsSchematronProcessorGateway({
    sefUrl: `${baseUrl}/ssp.sef.json`,
    SaxonJS,
    baselinesBaseUrl: `${baseUrl}/baselines`,
    registryBaseUrl: `${baseUrl}/xml`,
  });
  browserController({
    importMetaHot,
    renderApp: createAppRenderer(
      element,
      createPresenter({
        debug,
        baseUrl,
        sourceRepository: {
          treeUrl: github.getBranchTreeUrl(githubRepository),
          sampleSSPs: github.getSampleSSPs(githubRepository),
          developerExampleUrl: github.getDeveloperExampleUrl(githubRepository),
        },
        location: {
          listen: (listener: (url: string) => void) => {
            window.addEventListener('hashchange', event => {
              const hashchangeEvent = event as HashChangeEvent;
              listener(`#${hashchangeEvent.newURL.split('#')[1]}`);
            });
          },
          replace: (url: string) => window.history.replaceState(null, '', url),
        },
        useCases: {
          annotateXML: AnnotateXMLUseCase({
            xml: {
              formatXML: highlightXML,
              // skip indenting the XML for now.
              indentXml: s => Promise.resolve(s),
            },
            SaxonJS,
          }),
          getAssertionViews: async () =>
            fetch(`${baseUrl}/assertion-views.json`).then(response =>
              response.json(),
            ),
          getSSPSchematronAssertions: async () =>
            fetch(`${baseUrl}/ssp.json`).then(response => response.json()),
          validateSSP: ValidateSSPUseCase({
            jsonSspToXml,
            processSchematron,
          }),
          validateSSPUrl: ValidateSSPUrlUseCase({
            processSchematron,
            jsonSspToXml,
            fetch: window.fetch.bind(window),
          }),
        },
      }),
    ),
  });
};
