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

export type State =
  | (BaseState & {
      current: 'INITIALIZED';
    })
  | (BaseState & {
      current: 'UNINITIALIZED';
    });

export type StateTransition =
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

const derivedState = (state: State): BaseState => {
  return {
    get failedAssertionCounts() {
      return state.validationResults.current === 'HAS_RESULT'
        ? state.validationResults.validationReport.failedAsserts.reduce<
            Record<string, number>
          >((acc, assert) => {
            acc[assert.id] = (acc[assert.id] || 0) + 1;
            return acc;
          }, {})
        : null;
    },
    get filterOptions() {
      return getFilterOptions({
        config: state.config,
        filter: state.filter,
        failedAssertionMap: state.validationResults.assertionsById,
      });
    },
    get counts() {
      return {
        fired:
          state.validationResults.current === 'HAS_RESULT'
            ? state.validationResults.validationReport.failedAsserts.length
            : null,
        total: state.config.schematronAsserts.length,
      };
    },
    get schematronReport() {
      return getSchematronReport({
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
      });
    },
  } as BaseState;
};

export const nextState = (state: State, event: StateTransition): State => {
  if (state.current === 'UNINITIALIZED') {
    if (event.type === 'CONFIG_LOADED') {
      return {
        current: 'INITIALIZED',
        ...derivedState(state),
        filter: {
          passStatus: 'all',
          role: 'all',
          text: '',
          assertionViewId: 0,
        },
        config: event.data.config,
        validationResults: state.validationResults,
      };
    }
  } else if (state.current === 'INITIALIZED') {
    if (event.type === 'FILTER_TEXT_CHANGED') {
      return {
        current: 'INITIALIZED',
        ...derivedState(state),
        config: state.config,
        filter: {
          ...state.filter,
          text: event.data.text,
        },
        validationResults: state.validationResults,
      };
    } else if (event.type === 'FILTER_ROLE_CHANGED') {
      return {
        current: 'INITIALIZED',
        ...derivedState(state),
        config: state.config,
        filter: {
          ...state.filter,
          role: event.data.role,
        },
        validationResults: state.validationResults,
      };
    } else if (event.type === 'FILTER_ASSERTION_VIEW_CHANGED') {
      return {
        current: 'INITIALIZED',
        ...derivedState(state),
        config: state.config,
        filter: {
          ...state.filter,
          assertionViewId: event.data.assertionViewId,
        },
        validationResults: state.validationResults,
      };
    } else if (event.type === 'FILTER_PASS_STATUS_CHANGED') {
      return {
        current: 'INITIALIZED',
        ...derivedState(state),
        config: state.config,
        filter: {
          ...state.filter,
          passStatus: event.data.passStatus,
        },
        validationResults: state.validationResults,
      };
    }
  }
  return state;
};

export const initialState: State = {
  current: 'UNINITIALIZED',
  config: {
    assertionViews: [],
    schematronAsserts: [],
  },
  filter: {
    passStatus: 'all',
    role: 'all',
    text: '',
    assertionViewId: 0,
  },
  get failedAssertionCounts() {
    const state = this;
    return state.validationResults.current === 'HAS_RESULT'
      ? state.validationResults.validationReport.failedAsserts.reduce<
          Record<string, number>
        >((acc, assert) => {
          acc[assert.id] = (acc[assert.id] || 0) + 1;
          return acc;
        }, {})
      : null;
  },
  get filterOptions() {
    const state = this;
    return getFilterOptions({
      config: state.config,
      filter: state.filter,
      failedAssertionMap: state.validationResults.assertionsById,
    });
  },
  get counts() {
    const state = this;
    return {
      fired:
        state.validationResults.current === 'HAS_RESULT'
          ? state.validationResults.validationReport.failedAsserts.length
          : null,
      total: state.config.schematronAsserts.length,
    };
  },
  get schematronReport() {
    const state = this;
    return getSchematronReport({
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
    });
  },
  validationResults: validationResultsMachine.initialState,
};
