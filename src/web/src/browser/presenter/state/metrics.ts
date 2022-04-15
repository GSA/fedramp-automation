import type { string } from 'fp-ts';
import { derived, Statemachine, statemachine } from 'overmind';

import * as router from './router';

type States =
  | {
      current: 'OPT_IN';
      userAlias: string;
    }
  | {
      current: 'OPT_OUT';
    };

type Events =
  | {
      type: 'TOGGLE';
    }
  | {
      type: 'SET_USER_ALIAS';
      data: { userAlias: string };
    };

export type MetricsMachine = Statemachine<States, Events>;

export const metricsMachine = statemachine<States, Events>({
  OPT_IN: {
    TOGGLE: () => {
      return {
        current: 'OPT_OUT',
      };
    },
    SET_USER_ALIAS: ({ userAlias }, state) => {
      return {
        current: 'OPT_IN',
        userAlias,
      };
    },
  },
  OPT_OUT: {
    TOGGLE: () => {
      return {
        current: 'OPT_IN',
        userAlias: '',
      };
    },
  },
});

export const createMetricsMachine = () => {
  return metricsMachine.create({ current: 'OPT_OUT' });
};
