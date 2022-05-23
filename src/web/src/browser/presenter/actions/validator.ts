import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { ValidationReport } from '@asap/shared/use-cases/schematron';

import type { PresenterConfig } from '..';

export const reset = (
  { state }: PresenterConfig,
  documentType: OscalDocumentKey,
) => {
  state.schematron[documentType].validator.send('RESET');
};

export const validateOscalDocument = async (
  { actions, state, effects }: PresenterConfig,
  options: { fileName: string; fileContents: string },
) => {
  effects.useCases.oscalService
    .initDocument(options.fileContents)
    .then(({ documentType, xmlString }) => {
      actions.validator.reset(documentType);
      if (
        state.schematron[documentType].validator
          .send('PROCESSING_STRING', { fileName: options.fileName })
          .matches('PROCESSING')
      ) {
        effects.useCases.oscalService
          .validateOscal({ documentType, xmlString })
          .then(validationReport =>
            actions.validator.setValidationReport({
              validationReport,
              xmlText: xmlString,
            }),
          )
          .then(actions.validator.annotateXml)
          .catch((error: Error) =>
            actions.validator.setProcessingError(error.message),
          );
      }
    });
};

export const setXmlUrl = async (
  { actions, effects, state }: PresenterConfig,
  xmlFileUrl: string,
) => {
  effects.useCases.oscalService
    .initDocumentByUrl(xmlFileUrl)
    .then(({ documentType, xmlString }) => {
      actions.validator.reset(documentType);
      if (
        state.schematron[documentType].validator
          .send('PROCESSING_URL', { xmlFileUrl })
          .matches('PROCESSING')
      ) {
        effects.useCases.oscalService
          .validateOscal({ documentType, xmlString })
          .then(validationReport =>
            actions.validator.setValidationReport({
              validationReport,
              xmlText: xmlString,
            }),
          )
          .then(actions.validator.annotateXml)
          .catch((error: Error) =>
            actions.validator.setProcessingError(error.message),
          );
      }
    });
};

export const annotateXml = async ({ effects, state }: PresenterConfig) => {
  if (state.schematron.ssp.validator.current === 'VALIDATED') {
    const annotatedSSP = await effects.useCases.annotateXML({
      xmlString: state.schematron.ssp.validator.xmlText,
      annotations:
        state.schematron.ssp.validator.validationReport.failedAsserts.map(
          assert => {
            return {
              uniqueId: assert.uniqueId,
              xpath: assert.location,
            };
          },
        ),
    });
    state.schematron.ssp.validator.annotatedSSP = annotatedSSP;
  }
};

export const setProcessingError = (
  { state }: PresenterConfig,
  errorMessage: string,
) => {
  if (state.schematron.ssp.validator.matches('PROCESSING')) {
    state.schematron.ssp.validator.send('PROCESSING_ERROR', { errorMessage });
  }
};

export const setValidationReport = (
  { actions, state }: PresenterConfig,
  {
    validationReport,
    xmlText,
  }: {
    validationReport: ValidationReport;
    xmlText: string;
  },
) => {
  if (state.schematron.ssp.validator.matches('PROCESSING')) {
    state.schematron.ssp.validator.send('VALIDATED', {
      validationReport,
      xmlText,
    });
    actions.metrics.logValidationSummary();
  }
};
