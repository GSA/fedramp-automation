import { browserController } from './browser-controller';
import { highlightXML } from '../shared/highlight-js';
import {
  SaxonJsSchematronValidatorGateway,
  XmlIndenter,
} from '../shared/saxon-js-gateway';
import { createPresenter } from './presenter';
import * as github from '../../domain/github';
import { AnnotateXMLUseCase } from '../../use-cases/annotate-xml';
import {
  ValidateSSPUseCase,
  ValidateSSPUrlUseCase,
} from '../../use-cases/validate-ssp-xml';
import { createAppRenderer } from './views';

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
  const generateSchematronValidationReport = SaxonJsSchematronValidatorGateway({
    sefUrl: `${baseUrl}/ssp.sef.json`,
    // The npm version of saxon-js is for node; currently, we load the
    // browser version via a script tag in index.html.
    SaxonJS: (window as any).SaxonJS,
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
        repositoryUrl: github.getBranchTreeUrl(githubRepository),
        sampleSSPs: github.getSampleSSPs(githubRepository),
        useCases: {
          annotateXML: AnnotateXMLUseCase({
            xml: {
              formatXML: highlightXML,
              indentXml: XmlIndenter({
                SaxonJS: (window as any).SaxonJS,
              }),
            },
            SaxonJS: (window as any).SaxonJS,
          }),
          validateSSP: ValidateSSPUseCase({
            generateSchematronValidationReport,
          }),
          validateSSPUrl: ValidateSSPUrlUseCase({
            generateSchematronValidationReport,
            fetch: window.fetch.bind(window),
          }),
        },
      }),
    ),
  });
};
