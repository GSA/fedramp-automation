import type { ValidationReport } from '../../../../use-cases/schematron';
import type { Role } from '../machines/validator';
import type { PresenterConfig } from '..';

export const reset = ({ state }: PresenterConfig) => {
  if (state.schematron.validator.matches('VALIDATED')) {
    state.schematron.validator.send('RESET');
  }
};

export const setXmlContents = async (
  { actions, state, effects }: PresenterConfig,
  options: { fileName: string; xmlContents: string },
) => {
  actions.validator.reset();
  if (
    state.schematron.validator
      .send('PROCESSING_STRING', { fileName: options.fileName })
      .matches('PROCESSING')
  ) {
    return effects.useCases
      .validateSSP(options.xmlContents)
      .then(validationReport =>
        actions.validator.setValidationReport({
          validationReport,
          xmlText: options.xmlContents,
        }),
      )
      .then(actions.validator.annotateXml)
      .catch(actions.validator.setProcessingError);
  }
};

export const setXmlUrl = async (
  { actions, effects, state }: PresenterConfig,
  xmlFileUrl: string,
) => {
  actions.validator.reset();
  if (
    state.schematron.validator
      .send('PROCESSING_URL', { xmlFileUrl })
      .matches('PROCESSING')
  ) {
    return effects.useCases
      .validateSSPUrl(xmlFileUrl)
      .then(actions.validator.setValidationReport)
      .then(actions.validator.annotateXml)
      .catch(actions.validator.setProcessingError);
  }
};

export const annotateXml = async ({ effects, state }: PresenterConfig) => {
  if (state.schematron.validator.current === 'VALIDATED') {
    const annotatedSSP = await effects.useCases.annotateXML({
      xmlString: state.schematron.validator.xmlText,
      annotations:
        state.schematron.validator.validationReport.failedAsserts.map(
          assert => {
            return {
              uniqueId: assert.uniqueId,
              xpath: assert.location,
            };
          },
        ),
    });
    state.schematron.validator.annotatedSSP = annotatedSSP;
  }
};

export const setProcessingError = (
  { state }: PresenterConfig,
  errorMessage: string,
) => {
  if (state.schematron.validator.matches('PROCESSING')) {
    state.schematron.validator.send('PROCESSING_ERROR', { errorMessage });
  }
};

export const setValidationReport = (
  { state }: PresenterConfig,
  {
    validationReport,
    xmlText,
  }: {
    validationReport: ValidationReport;
    xmlText: string;
  },
) => {
  if (state.schematron.validator.matches('PROCESSING')) {
    state.schematron.validator.send('VALIDATED', { validationReport, xmlText });
  }
};
