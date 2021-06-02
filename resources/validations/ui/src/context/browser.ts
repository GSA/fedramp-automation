import { browserController } from '../adapters/browser-controller';
import { SaxonJsSchematronValidationReportGateway } from '../adapters/saxon-js';
import { createPresenter } from '../presenter';
import { ValidateSchematronUseCase } from '../use-cases/validate-ssp-xml';
import { createAppRenderer } from '../views';

type BrowserContext = {
  debug: boolean;
  baseUrl: string;
  importMetaHot: ImportMetaHot;
  repository: string;
};

export default ({
  baseUrl,
  debug,
  importMetaHot,
  repository,
}: BrowserContext) => {
  browserController({
    importMetaHot,
    renderApp: createAppRenderer(
      document.getElementById('root') as HTMLElement,
      createPresenter({
        debug,
        baseUrl,
        repository,
        useCases: {
          validateSchematron: ValidateSchematronUseCase({
            generateSchematronValidationReport:
              SaxonJsSchematronValidationReportGateway({
                sefUrl: `${baseUrl}/ssp.sef.json`,
                // The npm version of saxon-js is for node; currently, we load the
                // browser version via a script tag in index.html.
                SaxonJS: (window as any).SaxonJS,
              }),
          }),
        },
      }),
    ),
  });
};
