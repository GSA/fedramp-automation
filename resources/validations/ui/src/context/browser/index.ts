import { browserController } from './browser-controller';
import { SaxonJsSchematronValidatorGateway } from '../shared/saxon-js';
import { createPresenter } from './presenter';
import { ValidateSchematronUseCase } from '../../use-cases/validate-ssp-xml';
import { createAppRenderer } from './views';

type BrowserContext = {
  debug: boolean;
  baseUrl: string;
  importMetaHot: ImportMetaHot;
  repositoryUrl: string;
};

export const runBrowserContext = ({
  baseUrl,
  debug,
  importMetaHot,
  repositoryUrl,
}: BrowserContext) => {
  browserController({
    importMetaHot,
    renderApp: createAppRenderer(
      document.getElementById('root') as HTMLElement,
      createPresenter({
        debug,
        baseUrl,
        repositoryUrl,
        useCases: {
          validateSchematron: ValidateSchematronUseCase({
            generateSchematronValidationReport:
              SaxonJsSchematronValidatorGateway({
                sefUrl: `${baseUrl}/ssp.sef.json`,
                // The npm version of saxon-js is for node; currently, we load the
                // browser version via a script tag in index.html.
                SaxonJS: (window as any).SaxonJS,
                baselinesBaseUrl: `${baseUrl}/baselines`,
                registryBaseUrl: `${baseUrl}/xml`,
              }),
          }),
        },
      }),
    ),
  });
};
