import { derived, Statemachine, statemachine } from 'overmind';

import type { FailedAssert } from '@asap/shared/use-cases/schematron';
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
import * as validationResultsMachine from './validation-results-machine';

type States =
  | {
      current: 'INITIALIZED';
    }
  | {
      current: 'UNINITIALIZED';
    };

type BaseState = {
  config: SchematronUIConfig;
  failedAssertionCounts: Record<FailedAssert['id'], number> | null;
  filter: SchematronFilter;
  filterOptions: SchematronFilterOptions;
  counts: {
    fired: number | null;
    total: number | null;
  };
  schematronReport: SchematronReport;
  validationResults: validationResultsMachine.State;
};

type Events =
  | {
      type: 'CONFIG_LOADED';
      data: {
        config: SchematronUIConfig;
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
      config: {
        assertionViews: [],
        schematronAsserts: [],
      },
      failedAssertionCounts: derived((state: SchematronMachine) => {
        return state.validationResults.current === 'HAS_RESULT'
          ? state.validationResults.validationReport.failedAsserts.reduce<
              Record<string, number>
            >((acc, assert) => {
              acc[assert.id] = (acc[assert.id] || 0) + 1;
              return acc;
            }, {})
          : null;
      }),
      filter: {
        passStatus: 'all',
        role: 'all',
        text: '',
        assertionViewId: 0,
      },
      filterOptions: derived((state: SchematronMachine) => {
        return getFilterOptions({
          config: state.config,
          filter: state.filter,
          failedAssertionMap: state.validationResults.assertionsById,
        });
      }),
      counts: derived((state: SchematronMachine) => {
        return {
          fired:
            state.validationResults.current === 'HAS_RESULT'
              ? state.validationResults.validationReport.failedAsserts.length
              : null,
          total: state.config.schematronAsserts.length,
        };
      }),
      schematronReport: derived((state: SchematronMachine) =>
        getSchematronReport({
          config: state.config,
          filter: state.filter,
          filterOptions: state.filterOptions,
          validator: {
            failedAssertionMap: state.validationResults.assertionsById,
            title:
              state.validationResults.current === 'HAS_RESULT'
                ? state.validationResults.validationReport.title
                : 'FedRAMP Package Concerns',
          },
        }),
      ),
      validationResults: validationResultsMachine.initialState,
    },
  );
};
