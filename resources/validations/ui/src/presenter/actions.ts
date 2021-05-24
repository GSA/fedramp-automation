import type { Action } from 'overmind';

export const setXmlContents: Action<string> = (
  { state, effects },
  xmlContents: string,
) => {
  state.loadingValidationReport = true;
  effects.useCases
    .validateSspXml(xmlContents)
    .then(validationReport => {
      state.validationReport = validationReport;
      state.loadingValidationReport = false;
    })
    .catch(reason => {
      console.error(reason);
      state.validationReport = null;
      state.loadingValidationReport = false;
    });
};
