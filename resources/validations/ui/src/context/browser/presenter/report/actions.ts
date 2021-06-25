import type { Action, AsyncAction } from 'overmind';

import type { ValidationReport } from '../../../../use-cases/schematron';
import type { Role } from './state';

export const reset: Action = ({ state }) => {
  if (state.report.matches('VALIDATED')) {
    state.report.send('RESET');
  }
};

export const setXmlContents: AsyncAction<{
  fileName: string;
  xmlContents: string;
}> = async (
  { actions, state, effects },
  options: { fileName: string; xmlContents: string },
) => {
  actions.report.reset();
  if (
    state.report
      .send('PROCESSING_STRING', { fileName: options.fileName })
      .matches('PROCESSING')
  ) {
    return effects.useCases
      .validateSSP(options.xmlContents)
      .then(validationReport =>
        actions.report.setValidationReport({
          validationReport,
          xmlText: options.xmlContents,
        }),
      )
      .catch(actions.report.setProcessingError);
  }
};

export const setXmlUrl: AsyncAction<string> = async (
  { actions, effects, state },
  xmlFileUrl,
) => {
  actions.report.reset();
  if (
    state.report.send('PROCESSING_URL', { xmlFileUrl }).matches('PROCESSING')
  ) {
    return effects.useCases
      .validateSSPUrl(xmlFileUrl)
      .then(actions.report.setValidationReport)
      .catch(actions.report.setProcessingError);
  }
};

export const setProcessingError: Action<string> = ({ state }, errorMessage) => {
  if (state.report.matches('PROCESSING')) {
    state.report.send('PROCESSING_ERROR', { errorMessage });
  }
};

export const setValidationReport: Action<{
  validationReport: ValidationReport;
  xmlText: string;
}> = ({ state }, { validationReport, xmlText }) => {
  if (state.report.matches('PROCESSING')) {
    state.report.send('VALIDATED', { validationReport, xmlText });
  }
};

export const setFilterRole: Action<Role> = ({ state }, filter) => {
  if (state.report.current === 'VALIDATED') {
    state.report.filter.role = filter;
  }
};

export const setFilterText: Action<string> = ({ state }, text) => {
  if (state.report.current === 'VALIDATED') {
    state.report.filter.text = text;
  }
};
