import { Statemachine, statemachine } from 'overmind';

import type { SummariesByAssertionId } from '@asap/shared/domain/xspec';

type States =
  | {
      current: 'INITIALIZED';
    }
  | {
      current: 'UNINITIALIZED';
    };

type BaseState = {
  xspecSummariesByAssertionId: SummariesByAssertionId;
  visibleDocumentation: string | null;
};

type Events =
  | {
      type: 'SUMMARIES_LOADED';
      data: {
        xspecSummariesByAssertionId: SummariesByAssertionId;
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
    SUMMARIES_LOADED: ({ xspecSummariesByAssertionId }) => {
      return {
        current: 'INITIALIZED',
        xspecSummariesByAssertionId,
        visibleDocumentation: null,
      };
    },
  },
  INITIALIZED: {
    CLOSE: (event, state) => {
      return {
        current: 'INITIALIZED',
        xspecSummariesByAssertionId: state.xspecSummariesByAssertionId,
        visibleDocumentation: null,
      };
    },
    SHOW: ({ assertionId }, state) => {
      return {
        current: 'INITIALIZED',
        xspecSummariesByAssertionId: state.xspecSummariesByAssertionId,
        visibleDocumentation: assertionId,
      };
    },
  },
});

export const createAssertionDocumentationMachine = () => {
  return assertionDocumentationMachine.create(
    { current: 'UNINITIALIZED' },
    {
      xspecSummariesByAssertionId: {},
      visibleDocumentation: null,
    },
  );
};
