import { derived, Statemachine, statemachine } from 'overmind';

import type {
  FailedAssert,
  ValidationReport,
} from '@asap/shared/use-cases/schematron';
import {
  getFilterOptions,
  PassStatus,
  Role,
  SchematronFilter,
  SchematronFilterOptions,
  SchematronReport,
  SchematronUIConfig,
} from '../lib/schematron';
import { getSchematronReport } from '../lib/schematron';
import { getAssertionsById } from '../lib/validator';
import { createValidatorMachine, ValidatorMachine } from './validator-machine';
import { state } from 'fp-ts';

type States =
  | {
      current: 'INITIALIZED';
    }
  | {
      current: 'UNINITIALIZED';
    }
  | {
      current: 'REPORT_LOADED';
      annotatedXML: string;
      validationReport: ValidationReport;
    };

type BaseState = {
  assertionsById: Record<FailedAssert['id'], FailedAssert[]> | null;
  config: SchematronUIConfig;
  failedAssertionCounts: Record<FailedAssert['id'], number> | null;
  filter: SchematronFilter;
  filterOptions: SchematronFilterOptions;
  schematronReport: SchematronReport;
  validator: ValidatorMachine;
};

type Events =
  | {
      type: 'CONFIG_LOADED';
      data: {
        config: SchematronUIConfig;
      };
    }
  | {
      type: 'SET_VALIDATION_REPORT';
      data: {
        annotatedXML: string;
        validationReport: ValidationReport;
      };
    }
  | {
      type: 'FILTER_TEXT_CHANGED';
      data: {
        text: string;
      };
    }
  | {
      type: 'FILTER_ROLE_CHANGED';
      data: {
        role: Role;
      };
    }
  | {
      type: 'FILTER_ASSERTION_VIEW_CHANGED';
      data: {
        assertionViewId: number;
      };
    }
  | {
      type: 'FILTER_PASS_STATUS_CHANGED';
      data: {
        passStatus: PassStatus;
      };
    };

export type SchematronMachine = Statemachine<States, Events, BaseState>;

const schematronMachine = statemachine<States, Events, BaseState>({
  UNINITIALIZED: {
    CONFIG_LOADED: ({ config }) => {
      return {
        current: 'INITIALIZED',
        config,
      };
    },
  },
  INITIALIZED: {
    SET_VALIDATION_REPORT: ({ annotatedXML, validationReport }, state) => {
      return {
        current: 'REPORT_LOADED',
        config: state.config,
        annotatedXML,
        validationReport,
      };
    },
  },
  REPORT_LOADED: {
    FILTER_TEXT_CHANGED: ({ text }, state) => {
      return {
        current: 'INITIALIZED',
        config: state.config,
        filter: {
          ...state.filter,
          text,
        },
      };
    },
    FILTER_ROLE_CHANGED: ({ role }, state) => {
      return {
        current: 'INITIALIZED',
        config: state.config,
        filter: {
          ...state.filter,
          role,
        },
      };
    },
    FILTER_ASSERTION_VIEW_CHANGED: ({ assertionViewId }, state) => {
      return {
        current: 'INITIALIZED',
        config: state.config,
        filter: {
          ...state.filter,
          assertionViewId,
        },
      };
    },
    FILTER_PASS_STATUS_CHANGED: ({ passStatus }, state) => {
      return {
        current: 'INITIALIZED',
        config: state.config,
        filter: {
          ...state.filter,
          passStatus,
        },
      };
    },
  },
});

export const createSchematronMachine = () => {
  return schematronMachine.create(
    { current: 'UNINITIALIZED' },
    {
      assertionsById: derived((state: SchematronMachine) =>
        state.current === 'REPORT_LOADED'
          ? getAssertionsById({
              failedAssertions: state.validationReport.failedAsserts,
            })
          : null,
      ),
      config: {
        assertionViews: [],
        schematronAsserts: [],
      },
      failedAssertionCounts: derived((state: SchematronMachine) => {
        return state.current === 'REPORT_LOADED'
          ? state.validationReport.failedAsserts.reduce<Record<string, number>>(
              (acc, assert) => {
                acc[assert.id] = (acc[assert.id] || 0) + 1;
                return acc;
              },
              {},
            )
          : null;
      }),
      filter: {
        passStatus: 'all',
        role: 'all',
        text: '',
        assertionViewId: 0,
      },
      filterOptions: derived((state: SchematronMachine) =>
        getFilterOptions({
          config: state.config,
          filter: state.filter,
          failedAssertionMap: state.validator.matches('VALIDATED')
            ? state.assertionsById
            : null,
        }),
      ),
      schematronReport: derived((state: SchematronMachine) =>
        getSchematronReport({
          config: state.config,
          filter: state.filter,
          filterOptions: state.filterOptions,
          validator: {
            failedAssertionMap: state.assertionsById,
            title:
              state.current === 'REPORT_LOADED'
                ? state.validationReport.title
                : 'FedRAMP Package Concerns',
          },
        }),
      ),
      validator: createValidatorMachine(),
    },
  );
};
