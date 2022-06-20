import type {
  FailedAssert,
  ValidationReport,
} from '@asap/shared/use-cases/schematron';

import { getAssertionsById } from '../lib/validator';

type BaseState = {
  assertionsById: Record<FailedAssert['id'], FailedAssert[]> | null;
};

type ResultState = BaseState & {
  annotatedXML: string;
  failedAssertionCounts: Record<FailedAssert['id'], number> | null;
  summary: {
    firedCount: number;
    title: string;
  };
  validationReport: ValidationReport;
};

export type State =
  | (BaseState & {
      current: 'NO_RESULTS';
      summary: {
        firedCount: null;
        title: string;
      };
    })
  | (ResultState & {
      current: 'HAS_RESULT';
    })
  | (ResultState & {
      current: 'ASSERTION_CONTEXT';
      assertionId: string;
    });

export type StateTransition =
  | {
      type: 'SET_RESULTS';
      data: {
        annotatedXML: string;
        validationReport: ValidationReport;
      };
    }
  | {
      type: 'SET_ASSERTION_CONTEXT';
      data: {
        assertionId: string;
      };
    }
  | {
      type: 'CLEAR_ASSERTION_CONTEXT';
    }
  | {
      type: 'RESET';
    };

export const nextState = (state: State, event: StateTransition): State => {
  if (state.current === 'NO_RESULTS') {
    if (event.type === 'SET_RESULTS') {
      return {
        current: 'HAS_RESULT',
        annotatedXML: event.data.annotatedXML,
        assertionsById: getAssertionsById({
          failedAssertions: event.data.validationReport.failedAsserts,
        }),
        failedAssertionCounts: (() => {
          return event.data.validationReport.failedAsserts.reduce<
            Record<string, number>
          >((acc, assert) => {
            acc[assert.id] = (acc[assert.id] || 0) + 1;
            return acc;
          }, {});
        })(),
        summary: {
          firedCount: event.data.validationReport.failedAsserts.length,
          title: event.data.validationReport.title,
        },
        validationReport: event.data.validationReport,
      };
    }
  } else if (state.current === 'HAS_RESULT') {
    if (event.type === 'RESET') {
      return initialState;
    } else if (event.type === 'SET_ASSERTION_CONTEXT') {
      return {
        current: 'ASSERTION_CONTEXT',
        assertionsById: state.assertionsById,
        assertionId: event.data.assertionId,
        annotatedXML: state.annotatedXML,
        failedAssertionCounts: state.failedAssertionCounts,
        summary: state.summary,
        validationReport: {
          ...state.validationReport,
        },
      };
    }
  } else if (state.current === 'ASSERTION_CONTEXT') {
    if (event.type === 'CLEAR_ASSERTION_CONTEXT') {
      return {
        current: 'HAS_RESULT',
        assertionsById: state.assertionsById,
        annotatedXML: state.annotatedXML,
        failedAssertionCounts: state.failedAssertionCounts,
        summary: state.summary,
        validationReport: {
          ...state.validationReport,
        },
      };
    }
  }
  return state;
};

export const initialState: State = {
  current: 'NO_RESULTS',
  assertionsById: null,
  summary: {
    firedCount: null,
    title: 'FedRAMP Package Concerns',
  },
};
