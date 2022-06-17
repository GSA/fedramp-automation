import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { ValidationReport } from '@asap/shared/use-cases/schematron';
import { setCurrentRoute } from '.';

import type { PresenterConfig } from '..';
import { getUrl, Routes } from '../state/router';

export const reset = ({ state }: PresenterConfig) => {
  state.newAppContext.dispatch({ type: 'VALIDATOR_RESET' });
};

export const validateOscalDocument = async (
  { actions, state, effects }: PresenterConfig,
  options: { fileName: string; fileContents: string },
) => {
  actions.validator.reset();
  state.newAppContext.dispatch({
    type: 'VALIDATOR_PROCESSING_STRING',
    data: { fileName: options.fileName },
  });
  if (state.newAppContext.state.validator.current === 'PROCESSING') {
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
  state.newAppContext.dispatch({
    type: 'VALIDATOR_PROCESSING_URL',
    data: { xmlFileUrl },
  });
  if (state.newAppContext.state.validator.current === 'PROCESSING') {
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
  if (state.newAppContext.state.validator.current === 'PROCESSING') {
    state.newAppContext.dispatch({
      type: 'VALIDATOR_PROCESSING_ERROR',
      data: { errorMessage },
    });
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
  if (state.newAppContext.state.validator.current === 'PROCESSING') {
    state.newAppContext.dispatch({
      type: 'VALIDATOR_VALIDATED',
    });
    actions.metrics.logValidationSummary(documentType);
  }
  actions.schematron.setValidationReport({
    documentType,
    validationReport,
    xmlString,
  });
  state.newAppContext.dispatch(
    setCurrentRoute(
      getUrl(
        {
          poam: Routes.documentPOAM,
          sap: Routes.documentSAP,
          sar: Routes.documentSAR,
          ssp: Routes.documentSSP,
        }[documentType],
      ),
    ),
  );
};
