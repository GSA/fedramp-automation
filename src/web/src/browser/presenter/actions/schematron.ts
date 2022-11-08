import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import {
  SchematronRulesetKey,
  SchematronRulesetKeys,
  SCHEMATRON_RULESETS,
} from '@asap/shared/domain/schematron';

import type { ActionContext } from '..';
import type {
  FedRampSpecific,
  PassStatus,
  Role,
} from '../state/ruleset/schematron-machine';

export const initialize = (config: ActionContext) => {
  SchematronRulesetKeys.map(rulesetKey => {
    Promise.all([
      config.effects.useCases.getAssertionViews(rulesetKey),
      config.effects.useCases.getSchematronAssertions(rulesetKey),
    ]).then(([assertionViews, schematronAsserts]) => {
      config.dispatch({
        machine: `${rulesetKey}.oscalDocuments.poam`,
        type: 'CONFIG_LOADED',
        data: {
          config: {
            assertionViews: assertionViews.poam,
            schematronAsserts: schematronAsserts.poam,
          },
        },
      });
      config.dispatch({
        machine: `${rulesetKey}.oscalDocuments.sap`,
        type: 'CONFIG_LOADED',
        data: {
          config: {
            assertionViews: assertionViews.sap,
            schematronAsserts: schematronAsserts.sap,
          },
        },
      });
      config.dispatch({
        machine: `${rulesetKey}.oscalDocuments.sar`,
        type: 'CONFIG_LOADED',
        data: {
          config: {
            assertionViews: assertionViews.sar,
            schematronAsserts: schematronAsserts.sar,
          },
        },
      });
      config.dispatch({
        machine: `${rulesetKey}.oscalDocuments.ssp`,
        type: 'CONFIG_LOADED',
        data: {
          config: {
            assertionViews: assertionViews.ssp,
            schematronAsserts: schematronAsserts.ssp,
          },
        },
      });
    });
  });
};

export const setFilterFedrampOption =
  ({
    documentType,
    rulesetKey,
    fedrampFilterOption,
  }: {
    documentType: OscalDocumentKey;
    rulesetKey: SchematronRulesetKey;
    fedrampFilterOption: FedRampSpecific;
  }) =>
  (config: ActionContext) => {
    config.dispatch({
      machine: `${rulesetKey}.oscalDocuments.${documentType}`,
      type: 'FILTER_FEDRAMPSPECIFIC_CHANGED',
      data: { fedrampSpecificOption: fedrampFilterOption },
    });
  };

export const setFilterRole =
  ({
    documentType,
    role,
    rulesetKey,
  }: {
    documentType: OscalDocumentKey;
    role: Role;
    rulesetKey: SchematronRulesetKey;
  }) =>
  (config: ActionContext) => {
    config.dispatch({
      machine: `${rulesetKey}.oscalDocuments.${documentType}`,
      type: 'FILTER_ROLE_CHANGED',
      data: { role },
    });
  };

export const setFilterText =
  ({
    documentType,
    text,
    rulesetKey,
  }: {
    documentType: OscalDocumentKey;
    text: string;
    rulesetKey: SchematronRulesetKey;
  }) =>
  (config: ActionContext) => {
    config.dispatch({
      machine: `${rulesetKey}.oscalDocuments.${documentType}`,
      type: 'FILTER_TEXT_CHANGED',
      data: { text },
    });
  };

export const setFilterAssertionView =
  ({
    documentType,
    assertionViewId,
    rulesetKey,
  }: {
    documentType: OscalDocumentKey;
    assertionViewId: number;
    rulesetKey: SchematronRulesetKey;
  }) =>
  ({ dispatch }: ActionContext) => {
    dispatch({
      machine: `${rulesetKey}.oscalDocuments.${documentType}`,
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
    rulesetKey,
  }: {
    documentType: OscalDocumentKey;
    passStatus: PassStatus;
    rulesetKey: SchematronRulesetKey;
  }) =>
  (config: ActionContext) => {
    config.dispatch({
      machine: `${rulesetKey}.oscalDocuments.${documentType}`,
      type: 'FILTER_PASS_STATUS_CHANGED',
      data: { passStatus },
    });
  };
