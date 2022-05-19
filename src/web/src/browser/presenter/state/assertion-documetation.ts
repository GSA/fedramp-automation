import { Statemachine, statemachine } from 'overmind';

import type { SummariesByAssertionId } from '@asap/shared/domain/xspec';
import type { XSpecScenarioSummaries } from '@asap/shared/use-cases/assertion-documentation';

type States =
  | {
      current: 'INITIALIZED';
    }
  | {
      current: 'UNINITIALIZED';
    };

type BaseState = {
  xspecScenarioSummaries: XSpecScenarioSummaries;
  visibleDocumentation: string | null;
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
        visibleDocumentation: null,
      };
    },
  },
  INITIALIZED: {
    CLOSE: (event, state) => {
      return {
        current: 'INITIALIZED',
        xspecScenarioSummaries: state.xspecScenarioSummaries,
        visibleDocumentation: null,
      };
    },
    SHOW: ({ assertionId }, state) => {
      return {
        current: 'INITIALIZED',
        xspecScenarioSummaries: state.xspecScenarioSummaries,
        visibleDocumentation: assertionId,
      };
    },
  },
});

export const createAssertionDocumentationMachine = () => {
  return assertionDocumentationMachine.create(
    { current: 'UNINITIALIZED' },
    {
      xspecScenarioSummaries: {
        poam: {},
        sap: {},
        sar: {},
        ssp: {},
      },
      visibleDocumentation: null,
    },
  );
};
