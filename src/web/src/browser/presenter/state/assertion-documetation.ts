import type { XSpecScenarioSummaries } from '@asap/shared/use-cases/assertion-documentation';
import { ScenarioSummary } from '@asap/shared/domain/xspec';
import { OscalDocumentKey } from '@asap/shared/domain/oscal';

type BaseState = {
  xspecScenarioSummaries: XSpecScenarioSummaries;
  visibleScenarioSummaries: ScenarioSummary[];
  visibleAssertion: {
    assertionId: string;
    documentType: OscalDocumentKey;
  } | null;
};

export type State = BaseState &
  (
    | {
        current: 'INITIALIZED';
      }
    | {
        current: 'UNINITIALIZED';
      }
  );

export type Event =
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

export const nextState = (state: State, event: Event): State => {
  if (state.current === 'UNINITIALIZED') {
    if (event.type === 'ASSERTION_DOCUMENTATION_SUMMARIES_LOADED') {
      return {
        current: 'INITIALIZED',
        xspecScenarioSummaries: event.data.xspecScenarioSummaries,
        visibleAssertion: null,
        visibleScenarioSummaries: [],
      };
    }
  } else if (state.current === 'INITIALIZED') {
    if (event.type === 'ASSERTION_DOCUMENTATION_CLOSE') {
      return {
        current: 'INITIALIZED',
        visibleAssertion: null,
        visibleScenarioSummaries: [],
        xspecScenarioSummaries: {
          ...state.xspecScenarioSummaries,
        },
      };
    } else if (event.type === 'ASSERTION_DOCUMENTATION_SHOW') {
      const visibleAssertion = {
        assertionId: event.data.assertionId,
        documentType: event.data.documentType,
      };
      return {
        current: 'INITIALIZED',
        xspecScenarioSummaries: {
          ...state.xspecScenarioSummaries,
        },
        visibleAssertion,
        visibleScenarioSummaries:
          state.xspecScenarioSummaries[visibleAssertion.documentType][
            visibleAssertion.assertionId
          ],
      };
    }
  }
  return state;
};

export const initialState: State = {
  current: 'UNINITIALIZED',
  visibleAssertion: null,
  xspecScenarioSummaries: {
    poam: {},
    sap: {},
    sar: {},
    ssp: {},
  },
  visibleScenarioSummaries: [],
};
