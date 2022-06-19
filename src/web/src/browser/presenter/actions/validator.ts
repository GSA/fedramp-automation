import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { ValidationReport } from '@asap/shared/use-cases/schematron';
import { setCurrentRoute } from '.';

import type { ActionContext } from '..';
import * as metrics from './metrics';
import * as schematron from './schematron';
import { getUrl, Routes } from '../state/router';

export const reset = ({ dispatch }: ActionContext) => {
  dispatch({
    machine: 'validator',
    type: 'VALIDATOR_RESET',
  });
};

export const validateOscalDocument =
  (options: { fileName: string; fileContents: string }) =>
  async (config: ActionContext) => {
    reset(config);
    config.dispatch({
      machine: 'validator',
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
  (xmlFileUrl: string) => async (config: ActionContext) => {
    reset(config);
    config.dispatch({
      machine: 'validator',
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
  ({ dispatch, getState }: ActionContext) => {
    if (getState().validator.current === 'PROCESSING') {
      dispatch({
        machine: 'validator',
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
  (config: ActionContext) => {
    if (config.getState().validator.current === 'PROCESSING') {
      config.dispatch({
        machine: 'validator',
        type: 'VALIDATOR_VALIDATED',
      });
      metrics.logValidationSummary(documentType)(config);
    }
    schematron.setValidationReport({
      documentType,
      validationReport,
      xmlString,
    })(config);
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
