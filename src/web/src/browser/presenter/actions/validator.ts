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
      .initDocument(options.fileContents)
      .then(({ documentType, xmlString }) => {
        effects.useCases.oscalService
          .validateOscal({ documentType, xmlString })
          .then(validationReport =>
            actions.validator.setValidationReport({
              documentType,
              validationReport,
              xmlText: xmlString,
            }),
          )
          .then(actions.validator.annotateXml)
          .catch((error: Error) =>
            actions.validator.setProcessingError(error.message),
          );
      });
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
      .initDocumentByUrl(xmlFileUrl)
      .then(({ documentType, xmlString }) => {
        effects.useCases.oscalService
          .validateOscal({ documentType, xmlString })
          .then(validationReport =>
            actions.validator.setValidationReport({
              documentType,
              validationReport,
              xmlText: xmlString,
            }),
          )
          .then(actions.validator.annotateXml)
          .catch((error: Error) =>
            actions.validator.setProcessingError(error.message),
          );
      });
  }
};

export const annotateXml = async ({ effects, state }: PresenterConfig) => {
  if (state.validator.current === 'VALIDATED') {
    const annotatedSSP = await effects.useCases.annotateXML({
      xmlString: state.validator.xmlText,
      annotations: state.validator.validationReport.failedAsserts.map(
        assert => {
          return {
            uniqueId: assert.uniqueId,
            xpath: assert.location,
          };
        },
      ),
    });
    state.validator.annotatedSSP = annotatedSSP;
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
    xmlText,
  }: {
    documentType: OscalDocumentKey;
    validationReport: ValidationReport;
    xmlText: string;
  },
) => {
  if (state.validator.matches('PROCESSING')) {
    state.validator.send('VALIDATED', {
      validationReport,
      xmlText,
    });
    actions.metrics.logValidationSummary(documentType);
  }
};
