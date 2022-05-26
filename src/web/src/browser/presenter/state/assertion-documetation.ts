import { Statemachine, statemachine } from 'overmind';

import type { XSpecScenarioSummaries } from '@asap/shared/use-cases/assertion-documentation';

type States =
  | {
      current: 'INITIALIZED';
    }
  | {
      current: 'UNINITIALIZED';
    };

type BaseState = {
  documentType: keyof XSpecScenarioSummaries | null;
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
        documentType: string;
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
        documentType: state.documentType,
        visibleDocumentation: null,
        xspecScenarioSummaries: state.xspecScenarioSummaries,
      };
    },
    SHOW: ({ assertionId, documentType }, state) => {
      return {
        current: 'INITIALIZED',
        documentType,
        visibleDocumentation: assertionId,
        xspecScenarioSummaries: state.xspecScenarioSummaries,
      };
    },
  },
});

export const createAssertionDocumentationMachine = () => {
  return assertionDocumentationMachine.create(
    { current: 'UNINITIALIZED' },
    {
      documentType: null,
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
