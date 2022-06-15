import { derived, Statemachine, statemachine } from 'overmind';

import type { XSpecScenarioSummaries } from '@asap/shared/use-cases/assertion-documentation';
import { ScenarioSummary } from '@asap/shared/domain/xspec';
import { OscalDocumentKey } from '@asap/shared/domain/oscal';

type States =
  | {
      current: 'INITIALIZED';
    }
  | {
      current: 'UNINITIALIZED';
    };

type BaseState = {
  xspecScenarioSummaries: XSpecScenarioSummaries;
  visibleScenarioSummaries: ScenarioSummary[];
  visibleAssertion: {
    assertionId: string;
    documentType: OscalDocumentKey;
  } | null;
};

type Events =
  | {
      type: 'SUMMARIES_LOADED';
      data: {
        xspecScenarioSummaries: XSpecScenarioSummaries;
      };
    }
  | {
      type: 'CLOSE';
      data: {};
    }
  | {
      type: 'SHOW';
      data: {
        assertionId: string;
        documentType: OscalDocumentKey;
      };
    };

export type AssertionDocumentationMachine = Statemachine<
  States,
  Events,
  BaseState
>;

const assertionDocumentationMachine = statemachine<States, Events, BaseState>({
  UNINITIALIZED: {
    SUMMARIES_LOADED: ({ xspecScenarioSummaries }) => {
      return {
        current: 'INITIALIZED',
        xspecScenarioSummaries,
        visibleAssertion: null,
      };
    },
  },
  INITIALIZED: {
    CLOSE: (event, state) => {
      return {
        current: 'INITIALIZED',
        visibleAssertion: null,
        xspecScenarioSummaries: {
          ...state.xspecScenarioSummaries,
        },
      };
    },
    SHOW: ({ assertionId, documentType }, state) => {
      return {
        current: 'INITIALIZED',
        xspecScenarioSummaries: {
          ...state.xspecScenarioSummaries,
        },
        visibleAssertion: {
          assertionId,
          documentType,
        },
      };
    },
  },
});

export const createAssertionDocumentationMachine = () => {
  return assertionDocumentationMachine.create(
    { current: 'UNINITIALIZED' },
    {
      visibleAssertion: null,
      xspecScenarioSummaries: {
        poam: {},
        sap: {},
        sar: {},
        ssp: {},
      },
      visibleScenarioSummaries: derived(
        (state: AssertionDocumentationMachine) => {
          if (!state.visibleAssertion || !state.xspecScenarioSummaries) {
            return [];
          }
          return state.xspecScenarioSummaries[
            state.visibleAssertion.documentType
          ][state.visibleAssertion.assertionId];
        },
      ),
    },
  );
};
