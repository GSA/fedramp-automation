import { Statemachine, statemachine } from 'overmind';

import type {
  ScenarioSummary,
  SummariesByAssertionId,
} from '@asap/shared/domain/xspec';

type States =
  | {
      current: 'INITIALIZED';
    }
  | {
      current: 'UNINITIALIZED';
    };

type BaseState = {
  xspecSummariesByAssertionId: SummariesByAssertionId;
};

type Events = {
  type: 'SUMMARIES_LOADED';
  data: {
    xspecSummariesByAssertionId: SummariesByAssertionId;
  };
};

export type AssertionDocumentationMachine = Statemachine<
  States,
  Events,
  BaseState
>;

const assertionDocumentationMachine = statemachine<States, Events, BaseState>({
  UNINITIALIZED: {
    SUMMARIES_LOADED: ({ xspecSummariesByAssertionId }) => {
      return {
        current: 'INITIALIZED',
        xspecSummariesByAssertionId,
      };
    },
  },
  INITIALIZED: {},
});

export const createAssertionDocumentationMachine = () => {
  return assertionDocumentationMachine.create(
    { current: 'UNINITIALIZED' },
    {
      xspecSummariesByAssertionId: {},
    },
  );
};
