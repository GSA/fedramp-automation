import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { ValidationReport } from '@asap/shared/domain/schematron';
import { setCurrentRoute } from '.';

import type { ActionContext } from '..';
import { StateTransition } from '../state';
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
        .validateOscal(options.fileContents)
        .then(({ documentType, svrlString, validationReport, xmlString }) => {
          setValidationReport({
            documentType,
            svrlString,
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
        .validateOscalByUrl(xmlFileUrl)
        .then(({ documentType, svrlString, validationReport, xmlString }) => {
          setValidationReport({
            documentType,
            svrlString,
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
    svrlString,
    validationReport,
    xmlString,
  }: {
    documentType: OscalDocumentKey;
    svrlString: string;
    validationReport: ValidationReport;
    xmlString: string;
  }) =>
  (config: ActionContext) => {
    if (config.getState().validator.current === 'PROCESSING') {
      config.dispatch({
        machine: 'validator',
        type: 'VALIDATOR_VALIDATED',
      });
    }
    config.effects.useCases
      .annotateXML({
        xmlString,
        annotations: validationReport.failedAsserts.map(assert => {
          return {
            uniqueId: assert.uniqueId,
            xpath: assert.location,
          };
        }),
      })
      .then(annotatedXML => {
        config.dispatch({
          machine: `validationResults.${documentType}`,
          type: 'SET_RESULTS',
          data: {
            annotatedXML,
            svrlString,
            validationReport,
          },
        });
      });
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

export const showAssertionContext = ({
  assertionId,
  documentType,
}: {
  assertionId: string;
  documentType: OscalDocumentKey;
}): StateTransition => ({
  machine: `validationResults.${documentType}`,
  type: 'SET_ASSERTION_CONTEXT',
  data: {
    assertionId,
  },
});

export const clearAssertionContext = (
  documentType: OscalDocumentKey,
): StateTransition => ({
  machine: `validationResults.${documentType}`,
  type: 'CLEAR_ASSERTION_CONTEXT',
});

export const downloadSVRL =
  (documentType: OscalDocumentKey) => (config: ActionContext) => {
    const state = config.getState();
    const validationResults = state.validationResults[documentType];
    if (validationResults.current === 'HAS_RESULT') {
      var element = document.createElement('a');
      element.setAttribute(
        'href',
        'data:text/xml;charset=utf-8,' +
          encodeURIComponent(validationResults.svrlString),
      );
      element.setAttribute(
        'download',
        `${validationResults.summary.title}.svrl.xml`,
      );
      element.style.display = 'none';
      document.body.appendChild(element);
      element.click();
      document.body.removeChild(element);
    }
  };
