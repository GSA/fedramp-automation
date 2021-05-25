import type { Action, AsyncAction } from 'overmind';

import type { Filter } from './state';

export const setXmlContents: AsyncAction<string> = (
  { state, effects },
  xmlContents: string,
) => {
  state.report.loadingValidationReport = true;
  return effects.report.useCases
    .validateSchematron(xmlContents)
    .then(validationReport => {
      console.log('setting validation report', validationReport);
      state.report.validationReport = validationReport;
    })
    .catch(reason => {
      console.error('error validating', reason);
      state.report.validationReport = null;
    })
    .finally(() => {
      state.report.loadingValidationReport = false;
    });
};

export const setFilterRole: Action<Filter> = ({ state }, filter) => {
  state.report.filter = filter;
};
