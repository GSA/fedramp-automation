import type { Action, AsyncAction } from 'overmind';

import type { Role } from './state';

export const setXmlContents: AsyncAction<string> = (
  { state, effects },
  xmlContents: string,
) => {
  state.report.loadingValidationReport = true;
  return effects.useCases
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

export const setFilterRole: Action<Role> = ({ state }, filter) => {
  state.report.filter.role = filter;
};

export const setFilterText: Action<string> = ({ state }, text) => {
  state.report.filter.text = text;
};
