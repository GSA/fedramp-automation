import type { ValidationReport } from '@asap/shared/use-cases/schematron';
import type { OscalDocumentKey } from '@asap/shared/domain/oscal';

import type { ActionContext } from '..';
import type { PassStatus, Role } from '../lib/schematron';

export const initialize = (config: ActionContext) => {
  Promise.all([
    config.effects.useCases.getAssertionViews(),
    config.effects.useCases.getSchematronAssertions(),
  ]).then(([assertionViews, schematronAsserts]) => {
    config.dispatch({
      machine: 'oscalDocuments.poam',
      type: 'CONFIG_LOADED',
      data: {
        config: {
          assertionViews: assertionViews.poam,
          schematronAsserts: schematronAsserts.poam,
        },
      },
    });
    config.dispatch({
      machine: 'oscalDocuments.sap',
      type: 'CONFIG_LOADED',
      data: {
        config: {
          assertionViews: assertionViews.sap,
          schematronAsserts: schematronAsserts.sap,
        },
      },
    });
    config.dispatch({
      machine: 'oscalDocuments.sar',
      type: 'CONFIG_LOADED',
      data: {
        config: {
          assertionViews: assertionViews.sar,
          schematronAsserts: schematronAsserts.sar,
        },
      },
    });
    config.dispatch({
      machine: 'oscalDocuments.ssp',
      type: 'CONFIG_LOADED',
      data: {
        config: {
          assertionViews: assertionViews.ssp,
          schematronAsserts: schematronAsserts.ssp,
        },
      },
    });
  });
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
          machine: `oscalDocuments.${documentType}`,
          type: 'SET_RESULTS',
          data: {
            annotatedXML,
            validationReport,
          },
        });
      });
  };

export const setFilterRole =
  ({ documentType, role }: { documentType: OscalDocumentKey; role: Role }) =>
  (config: ActionContext) => {
    config.dispatch({
      machine: `oscalDocuments.${documentType}`,
      type: 'FILTER_ROLE_CHANGED',
      data: { role },
    });
  };

export const setFilterText =
  ({ documentType, text }: { documentType: OscalDocumentKey; text: string }) =>
  (config: ActionContext) => {
    config.dispatch({
      machine: `oscalDocuments.${documentType}`,
      type: 'FILTER_TEXT_CHANGED',
      data: { text },
    });
  };

export const setFilterAssertionView =
  ({
    documentType,
    assertionViewId,
  }: {
    documentType: OscalDocumentKey;
    assertionViewId: number;
  }) =>
  ({ dispatch }: ActionContext) => {
    dispatch({
      machine: `oscalDocuments.${documentType}`,
      type: 'FILTER_ASSERTION_VIEW_CHANGED',
      data: {
        assertionViewId,
      },
    });
  };

export const setPassStatus =
  ({
    documentType,
    passStatus,
  }: {
    documentType: OscalDocumentKey;
    passStatus: PassStatus;
  }) =>
  (config: ActionContext) => {
    config.dispatch({
      machine: `oscalDocuments.${documentType}`,
      type: 'FILTER_PASS_STATUS_CHANGED',
      data: { passStatus },
    });
  };
