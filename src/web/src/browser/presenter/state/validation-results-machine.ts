import type {
  FailedAssert,
  ValidationReport,
} from '@asap/shared/use-cases/schematron';
import { getAssertionsById } from '../lib/validator';

type BaseState = {
  assertionsById: Record<FailedAssert['id'], FailedAssert[]> | null;
};

export type State =
  | (BaseState & {
      current: 'NO_RESULTS';
    })
  | (BaseState & {
      current: 'HAS_RESULT';
      annotatedXML: string;
      validationReport: ValidationReport;
    })
  | (BaseState & {
      current: 'ASSERTION_CONTEXT';
      annotatedXML: string;
      assertionId: string;
      validationReport: ValidationReport;
    });

type Event =
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

export const nextState = (state: State, event: Event): State => {
  if (state.current === 'NO_RESULTS') {
    if (event.type === 'SET_RESULTS') {
      return {
        current: 'HAS_RESULT',
        assertionsById: getAssertionsById({
          failedAssertions: event.data.validationReport.failedAsserts,
        }),
        annotatedXML: event.data.annotatedXML,
        validationReport: event.data.validationReport,
      };
    }
  } else if (state.current === 'HAS_RESULT') {
    if (event.type === 'RESET') {
      return {
        current: 'NO_RESULTS',
        assertionsById: state.assertionsById,
      };
    } else if (event.type === 'SET_ASSERTION_CONTEXT') {
      return {
        current: 'ASSERTION_CONTEXT',
        assertionsById: state.assertionsById,
        assertionId: event.data.assertionId,
        annotatedXML: state.annotatedXML,
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
        validationReport: {
          ...state.validationReport,
        },
      };
    }
  }
  return state;
};

export const createValidationResultsMachine = (): State => ({
  current: 'NO_RESULTS',
  assertionsById: null,
});
