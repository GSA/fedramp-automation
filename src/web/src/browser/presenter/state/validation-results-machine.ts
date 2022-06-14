import { derived, Statemachine, statemachine } from 'overmind';

import type {
  FailedAssert,
  ValidationReport,
} from '@asap/shared/use-cases/schematron';
import { getAssertionsById } from '../lib/validator';

type States =
  | {
      current: 'NO_RESULTS';
    }
  | {
      current: 'HAS_RESULT';
      annotatedXML: string;
      validationReport: ValidationReport;
    }
  | {
      current: 'ASSERTION_CONTEXT';
      annotatedXML: string;
      assertionId: string;
      validationReport: ValidationReport;
    };

type Events =
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

type BaseState = {
  assertionsById: Record<FailedAssert['id'], FailedAssert[]> | null;
};

export type ValidationResultsMachine = Statemachine<States, Events, BaseState>;

export const validationResultsMachine = statemachine<States, Events, BaseState>(
  {
    NO_RESULTS: {
      SET_RESULTS: ({ annotatedXML, validationReport }) => {
        return {
          current: 'HAS_RESULT',
          annotatedXML,
          validationReport,
        };
      },
    },
    HAS_RESULT: {
      RESET: () => {
        return {
          current: 'NO_RESULTS',
        };
      },
      SET_ASSERTION_CONTEXT: ({ assertionId }, state) => {
        return {
          current: 'ASSERTION_CONTEXT',
          assertionId,
          annotatedXML: state.annotatedXML,
          validationReport: {
            ...state.validationReport,
          },
        };
      },
    },
    ASSERTION_CONTEXT: {
      CLEAR_ASSERTION_CONTEXT: (_, state) => {
        return {
          current: 'HAS_RESULT',
          annotatedXML: state.annotatedXML,
          validationReport: {
            ...state.validationReport,
          },
        };
      },
    },
  },
);

export const createValidationResultsMachine = () => {
  return validationResultsMachine.create(
    {
      current: 'NO_RESULTS',
    },
    {
      assertionsById: derived((state: ValidationResultsMachine) => {
        return state.current === 'HAS_RESULT'
          ? getAssertionsById({
              failedAssertions: state.validationReport.failedAsserts,
            })
          : null;
      }),
    },
  );
};
