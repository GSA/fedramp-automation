import type { Action } from 'overmind';

export const setXmlContents: Action<string> = (
  { state, effects },
  xmlContents: string,
) => {
  state.report.loadingValidationReport = true;
  effects.report.useCases
    .validateSchematron(xmlContents)
    .then(validationReport => {
      state.report.validationReport = validationReport;
      state.report.loadingValidationReport = false;
    })
    .catch(reason => {
      console.error(reason);
      state.report.validationReport = null;
      state.report.loadingValidationReport = false;
    });
};
