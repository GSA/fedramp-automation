import { browserController } from './browser-controller';
import { SaxonJsSchematronValidatorGateway } from '../shared/saxon-js-gateway';
import { createPresenter } from './presenter';
import type { GithubRepository } from '../../domain/github';
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
  githubRepository: GithubRepository;
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
        githubRepository,
        useCases: {
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
