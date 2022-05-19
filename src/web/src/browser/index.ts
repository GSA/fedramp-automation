import * as github from '@asap/shared/domain/github';
import { AnnotateXMLUseCase } from '@asap/shared/use-cases/annotate-xml';
import { AppMetrics } from '@asap/shared/use-cases/app-metrics';
import {
  ValidateSSPUseCase,
  ValidateSSPUrlUseCase,
} from '@asap/shared/use-cases/validate-ssp-xml';

import { createBrowserFingerprintMaker } from '@asap/shared/adapters/browser-fingerprint';
import { createGoogleFormMetricsLogger } from '@asap/shared/adapters/google-form';
import { highlightXML } from '@asap/shared/adapters/highlight-js';
import { AppLocalStorage } from '@asap/shared/adapters/local-storage';
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
  baseUrl: string;
  debug: boolean;
  deploymentId: string;
  importMetaHot: ImportMetaHot | undefined;
  githubRepository: github.GithubRepository;
};

export const runBrowserContext = ({
  element,
  baseUrl,
  debug,
  deploymentId,
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
  const eventLogger = createGoogleFormMetricsLogger({
    fetch: window.fetch.bind(window),
    formUrl:
      'https://docs.google.com/forms/d/e/1FAIpQLScKRI40pQlpaY9cUUnyTdz-e_NvOb0-DYnPw_6fTqbw-kO6KA/',
    fieldIds: {
      deploymentId: 'entry.2078742906',
      deviceId: 'entry.487426639',
      userAlias: 'entry.292167116',
      eventType: 'entry.172225468',
      data: 'entry.1638260679',
    },
  });
  const localStorageGateway = new AppLocalStorage(window.localStorage);
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
          appMetrics: new AppMetrics({
            deploymentId,
            eventLogger,
            getBrowserFingerprint: createBrowserFingerprintMaker(),
            optInGateway: localStorageGateway,
          }),
          getAssertionViews: async () =>
            fetch(`${baseUrl}/assertion-views.json`).then(response =>
              response.json(),
            ),
          getPOAMSchematronAssertions: async () =>
            fetch(`${baseUrl}/poam.json`).then(response => response.json()),
          getSAPSchematronAssertions: async () =>
            fetch(`${baseUrl}/sap.json`).then(response => response.json()),
          getSARSchematronAssertions: async () =>
            fetch(`${baseUrl}/sar.json`).then(response => response.json()),
          getSSPSchematronAssertions: async () =>
            fetch(`${baseUrl}/ssp.json`).then(response => response.json()),
          getXSpecScenarioSummaries: async () =>
            fetch(`${baseUrl}/xspec-scenarios.json`).then(response =>
              response.json(),
            ),
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
