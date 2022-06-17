import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { ValidationReport } from '@asap/shared/use-cases/schematron';
import { setCurrentRoute } from '.';

import type { NewPresenterConfig } from '..';
import * as metrics from './metrics';
import { getUrl, Routes } from '../state/router';

export const reset = ({ dispatch }: NewPresenterConfig) => {
  dispatch({ type: 'VALIDATOR_RESET' });
};

export const validateOscalDocument =
  (options: { fileName: string; fileContents: string }) =>
  async (config: NewPresenterConfig) => {
    reset(config);
    config.dispatch({
      type: 'VALIDATOR_PROCESSING_STRING',
      data: { fileName: options.fileName },
    });
    if (config.getState().validator.current === 'PROCESSING') {
      config.effects.useCases.oscalService
        .validateXmlOrJson(options.fileContents)
        .then(({ documentType, validationReport, xmlString }) => {
          setValidationReport({
            documentType,
            validationReport,
            xmlString,
          })(config);
        })
        .catch((error: Error) => setProcessingError(error.message)(config));
    }
  };

export const setXmlUrl =
  (xmlFileUrl: string) => async (config: NewPresenterConfig) => {
    reset(config);
    config.dispatch({
      type: 'VALIDATOR_PROCESSING_URL',
      data: { xmlFileUrl },
    });
    if (config.getState().validator.current === 'PROCESSING') {
      config.effects.useCases.oscalService
        .validateXmlOrJsonByUrl(xmlFileUrl)
        .then(({ documentType, validationReport, xmlString }) => {
          setValidationReport({
            documentType,
            validationReport,
            xmlString,
          })(config);
        })
        .catch((error: Error) => setProcessingError(error.message)(config));
    }
  };

export const setProcessingError =
  (errorMessage: string) =>
  ({ dispatch, getState }: NewPresenterConfig) => {
    if (getState().validator.current === 'PROCESSING') {
      dispatch({
        type: 'VALIDATOR_PROCESSING_ERROR',
        data: { errorMessage },
      });
    }
  };

export const setValidationReport =
  ({
    documentType,
    validationReport,
    xmlString,
  }: {
    documentType: OscalDocumentKey;
    validationReport: ValidationReport;
    xmlString: string;
  }) =>
  (config: NewPresenterConfig) => {
    if (config.getState().validator.current === 'PROCESSING') {
      config.dispatch({
        type: 'VALIDATOR_VALIDATED',
      });
      metrics.logValidationSummary(documentType)(config);
    }
    /* TODO: actions.schematron.setValidationReport({
      documentType,
      validationReport,
      xmlString,
    });*/
    config.dispatch(
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
