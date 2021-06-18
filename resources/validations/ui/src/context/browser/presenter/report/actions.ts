import type { Action, AsyncAction } from 'overmind';

import type { ValidationReport } from '../../../../use-cases/schematron';
import type { Role } from './state';

export const setXmlContents: AsyncAction<string> = async (
  { actions, state, effects },
  xmlContents: string,
) => {
  if (
    state.report
      .send('PROCESSING_STRING', { xmlFileContents: xmlContents })
      .matches('PROCESSING_STRING')
  ) {
    return effects.useCases
      .validateSSP(xmlContents)
      .then(actions.report.setValidationReport)
      .catch(actions.report.setValidationError);
  }
};

export const setXmlUrl: AsyncAction<string> = async (
  { actions, effects, state },
  xmlFileUrl,
) => {
  if (
    state.report
      .send('PROCESSING_URL', { xmlFileUrl })
      .matches('PROCESSING_URL')
  ) {
    return effects.useCases
      .validateSSPUrl(xmlFileUrl)
      .then(actions.report.setValidationReport)
      .catch(actions.report.setValidationError);
  }
};

export const setValidationError: Action<string> = ({ state }, errorMessage) => {
  const validatingState = state.report.matches('PROCESSING_STRING');
  if (!validatingState) {
    return;
  }
  state.report.send('PROCESSING_ERROR', { errorMessage });
};

export const setValidationReport: Action<ValidationReport> = (
  { state },
  validationReport,
) => {
  const validatingState =
    state.report.matches('PROCESSING_STRING') ||
    state.report.matches('UNLOADED') ||
    state.report.matches('PROCESSING_URL');
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
