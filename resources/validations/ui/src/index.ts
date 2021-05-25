import { SaxonJsSchematronValidationReportGateway } from './gateways/saxon-js';
import { createPresenter } from './presenter';
import { ValidateSchematronUseCase } from './use-cases/validate-ssp-xml';
import { renderApp } from './views';

const main = () => {
  const presenter = createPresenter({
    validateSchematron: ValidateSchematronUseCase({
      generateSchematronValidationReport:
        SaxonJsSchematronValidationReportGateway({
          // The npm version of saxon-js is for node; currently, we load the
          // browser version via a script tag in index.html.
          SaxonJS: (window as any).SaxonJS,
        }),
    }),
  });
  renderApp(document.getElementById('root') as HTMLElement, presenter);
};

main();
