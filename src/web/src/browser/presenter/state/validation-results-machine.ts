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
