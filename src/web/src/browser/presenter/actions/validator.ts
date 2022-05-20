import type { ValidationReport } from '@asap/shared/use-cases/schematron';

import type { PresenterConfig } from '..';

export const reset = ({ state }: PresenterConfig) => {
  state.schematron.ssp.validator.send('RESET');
};

export const setSspFile = async (
  { actions, state, effects }: PresenterConfig,
  options: { fileName: string; fileContents: string },
) => {
  actions.validator.reset();
  if (
    state.schematron.ssp.validator
      .send('PROCESSING_STRING', { fileName: options.fileName })
      .matches('PROCESSING')
  ) {
    return effects.useCases
      .validateSSP(options.fileContents)
      .then(validationReport =>
        actions.validator.setValidationReport({
          validationReport,
          xmlText: options.fileContents,
        }),
      )
      .then(actions.validator.annotateXml)
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
    state.schematron.ssp.validator
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
