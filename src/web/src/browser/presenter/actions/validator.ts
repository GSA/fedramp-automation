import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { ValidationReport } from '@asap/shared/use-cases/schematron';

import type { PresenterConfig } from '..';
import { getUrl, Routes } from '../state/router';
import * as validatorMachine from '../state/validator-machine';

export const reset = ({ state }: PresenterConfig) => {
  state.validator = validatorMachine.nextState(state.validator, {
    type: 'RESET',
  });
};

export const validateOscalDocument = async (
  { actions, state, effects }: PresenterConfig,
  options: { fileName: string; fileContents: string },
) => {
  actions.validator.reset();
  state.validator = validatorMachine.nextState(state.validator, {
    type: 'PROCESSING_STRING',
    data: { fileName: options.fileName },
  });
  if (state.validator.current === 'PROCESSING') {
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
  state.validator = validatorMachine.nextState(state.validator, {
    type: 'PROCESSING_URL',
    data: { xmlFileUrl },
  });
  if (state.validator.current === 'PROCESSING') {
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
  if (state.validator.current === 'PROCESSING') {
    state.validator = validatorMachine.nextState(state.validator, {
      type: 'PROCESSING_ERROR',
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
  if (state.validator.current === 'PROCESSING') {
    state.validator = validatorMachine.nextState(state.validator, {
      type: 'VALIDATED',
    });
    actions.metrics.logValidationSummary(documentType);
  }
  actions.schematron.setValidationReport({
    documentType,
    validationReport,
    xmlString,
  });
  actions.setCurrentRoute(
    getUrl(
      {
        poam: Routes.documentPOAM,
        sap: Routes.documentSAP,
        sar: Routes.documentSAR,
        ssp: Routes.documentSSP,
      }[documentType],
    ),
  );
};
