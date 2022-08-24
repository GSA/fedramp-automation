import { OscalDocumentKey } from '@asap/shared/domain/oscal';
import type { XSpecScenarioSummaries } from '@asap/shared/use-cases/xspec-summary';

type LoadedState = {
  xspecScenarioSummaries: XSpecScenarioSummaries;
};

export type State =
  | {
      current: 'UNINITIALIZED';
    }
  | (LoadedState & {
      current: 'INITIALIZED';
    })
  | (LoadedState & {
      current: 'SHOWING';
      visibleAssertion: {
        assertionId: string;
        documentType: OscalDocumentKey;
      } | null;
    });

export type StateTransition =
  | {
      type: 'ASSERTION_DOCUMENTATION_SUMMARIES_LOADED';
      data: {
        xspecScenarioSummaries: XSpecScenarioSummaries;
      };
    }
  | {
      type: 'ASSERTION_DOCUMENTATION_CLOSE';
    }
  | {
      type: 'ASSERTION_DOCUMENTATION_SHOW';
      data: {
        assertionId: string;
        documentType: OscalDocumentKey;
      };
    };

export const nextState = (state: State, event: StateTransition): State => {
  if (state.current === 'UNINITIALIZED') {
    if (event.type === 'ASSERTION_DOCUMENTATION_SUMMARIES_LOADED') {
      return {
        current: 'INITIALIZED',
        xspecScenarioSummaries: event.data.xspecScenarioSummaries,
      };
    }
  } else if (state.current === 'INITIALIZED') {
    if (event.type === 'ASSERTION_DOCUMENTATION_SHOW') {
      return {
        current: 'SHOWING',
        xspecScenarioSummaries: state.xspecScenarioSummaries,
        visibleAssertion: event.data,
      };
    }
  } else if (state.current === 'SHOWING') {
    if (event.type === 'ASSERTION_DOCUMENTATION_CLOSE') {
      return {
        current: 'INITIALIZED',
        xspecScenarioSummaries: state.xspecScenarioSummaries,
      };
    }
  }
  return state;
};

export const initialState: State = {
  current: 'UNINITIALIZED',
};
