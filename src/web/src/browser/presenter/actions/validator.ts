import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { ValidationReport } from '@asap/shared/use-cases/schematron';

import type { PresenterConfig } from '..';

export const reset = ({ state }: PresenterConfig) => {
  state.validator.send('RESET');
};

export const validateOscalDocument = async (
  { actions, state, effects }: PresenterConfig,
  options: { fileName: string; fileContents: string },
) => {
  actions.validator.reset();
  if (
    state.validator.send('PROCESSING_STRING', { fileName: options.fileName })
  ) {
    effects.useCases.oscalService
      .validateXmlOrJson(options.fileContents)
      .then(({ documentType, validationReport, xmlString }) => {
        actions.validator.setValidationReport({
          documentType,
          validationReport,
          xmlString,
        });
      })
      .catch((error: Error) =>
        actions.validator.setProcessingError(error.message),
      );
  }
};

export const setXmlUrl = async (
  { actions, effects, state }: PresenterConfig,
  xmlFileUrl: string,
) => {
  actions.validator.reset();
  if (
    state.validator.send('PROCESSING_URL', { xmlFileUrl }).matches('PROCESSING')
  ) {
    effects.useCases.oscalService
      .validateXmlOrJsonByUrl(xmlFileUrl)
      .then(({ documentType, validationReport, xmlString }) => {
        actions.validator.setValidationReport({
          documentType,
          validationReport,
          xmlString,
        });
      })
      .catch((error: Error) =>
        actions.validator.setProcessingError(error.message),
      );
  }
};

export const setProcessingError = (
  { state }: PresenterConfig,
  errorMessage: string,
) => {
  if (state.validator.matches('PROCESSING')) {
    state.validator.send('PROCESSING_ERROR', { errorMessage });
  }
};

export const setValidationReport = (
  { actions, state }: PresenterConfig,
  {
    documentType,
    validationReport,
    xmlString,
  }: {
    documentType: OscalDocumentKey;
    validationReport: ValidationReport;
    xmlString: string;
  },
) => {
  if (state.validator.matches('PROCESSING')) {
    state.validator.send('VALIDATED', {});
    actions.metrics.logValidationSummary(documentType);
  }
  actions.schematron.setValidationReport({
    documentType,
    validationReport,
    xmlString,
  });
};
