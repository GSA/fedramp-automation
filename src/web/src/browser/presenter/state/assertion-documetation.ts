import { Statemachine, statemachine } from 'overmind';

import type { ScenarioSummary } from '@asap/shared/domain/xspec';

type States =
  | {
      current: 'INITIALIZED';
    }
  | {
      current: 'UNINITIALIZED';
    };

type BaseState = {
  xspecSummaries: ScenarioSummary[];
};

type Events = {
  type: 'SUMMARIES_LOADED';
  data: {
    xspecSummaries: ScenarioSummary[];
  };
};

export type AssertionDocumentationMachine = Statemachine<
  States,
  Events,
  BaseState
>;

const assertionDocumentationMachine = statemachine<States, Events, BaseState>({
  UNINITIALIZED: {
    SUMMARIES_LOADED: ({ xspecSummaries }) => {
      return {
        current: 'INITIALIZED',
        xspecSummaries,
      };
    },
  },
  INITIALIZED: {},
});

export const createAssertionDocumentationMachine = () => {
  return assertionDocumentationMachine.create(
    { current: 'UNINITIALIZED' },
    {
      xspecSummaries: [],
    },
  );
};
