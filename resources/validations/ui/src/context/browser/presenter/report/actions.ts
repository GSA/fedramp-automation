import type { Action, AsyncAction } from 'overmind';

import type { ValidationReport } from '../../../../use-cases/schematron';
import type { Role } from './state';

export const setXmlContents: AsyncAction<string> = async (
  { actions, state, effects },
  xmlContents: string,
) => {
  if (
    state.report
      .send('VALIDATING', { xmlFileContents: xmlContents })
      .matches('VALIDATING')
  ) {
    return effects.useCases
      .validateSchematron(xmlContents)
      .then(actions.report.setValidationReport)
      .catch(actions.report.setValidationError);
  }
};

export const setValidationError: Action<string> = ({ state }, errorMessage) => {
  const validatingState = state.report.matches('VALIDATING');
  if (!validatingState) {
    return;
  }
  state.report.send('VALIDATING_ERROR', { errorMessage });
};

export const setValidationReport: Action<ValidationReport> = (
  { state },
  validationReport,
) => {
  const validatingState =
    state.report.matches('VALIDATING') || state.report.matches('UNLOADED');
  if (!validatingState) {
    return;
  }
  state.report.send('VALIDATED', { validationReport });
};

export const setFilterRole: Action<Role> = ({ state }, filter) => {
  if (state.report.current !== 'VALIDATED') {
    return;
  }
  state.report.filter.role = filter;
};

export const setFilterText: Action<string> = ({ state }, text) => {
  if (state.report.current !== 'VALIDATED') {
    return;
  }
  state.report.filter.text = text;
};
