import type {
  FailedAssert,
  ValidationReport,
} from '@asap/shared/domain/schematron';

type BaseState = {
  summary: {
    firedCount: null | number;
    title: string;
  };
};

type ResultState = BaseState & {
  annotatedXML: string;
  assertionsById: Record<FailedAssert['id'], FailedAssert[]> | null;
  failedAssertionCounts: Record<FailedAssert['id'], number> | null;
  svrlString: string;
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
        svrlString: string;
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

export type FailedAssertionMap = Record<FailedAssert['id'], FailedAssert[]>;

export const getAssertionsById = ({
  failedAssertions,
}: {
  failedAssertions: FailedAssert[];
}) => {
  return failedAssertions.reduce((acc, assert) => {
    if (acc[assert.id] === undefined) {
      acc[assert.id] = [];
    }
    acc[assert.id].push(assert);
    return acc;
  }, {} as FailedAssertionMap);
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
        svrlString: event.data.svrlString,
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
        svrlString: state.svrlString,
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
        svrlString: state.svrlString,
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
  summary: {
    firedCount: null,
    title: 'FedRAMP Package Concerns',
  },
};
