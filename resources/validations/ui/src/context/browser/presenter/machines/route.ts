import { statemachine, Statemachine } from 'overmind';
import type { reportMachine, ReportMachine } from '../report/state';

import * as router from '../router';

type States =
  | {
      current: router.HomeRoute['type'];
    }
  | {
      current: router.SummaryRoute['type'];
    }
  | {
      current: router.AssertionRoute['type'];
    };

type BaseState = {
  route: router.RouteType;
  report: ReportMachine;
};

type Events = {
  type: 'ROUTE_NAVIGATED';
  data: router.Route;
};

export type AppMachine = Statemachine<States, Events, BaseState>;

export const appMachine = statemachine<States, Events, BaseState>({
  Home: {
    ROUTE_NAVIGATED: (route, state) => {
      console.log(route.type);
    },
  },
  Viewer: {
    ROUTE_NAVIGATED: (route, state) => {
      if (state.report.matches('VALIDATED')) {
        return {
          current: route.type,
        };
      } else {
        return {
          current: 'Home',
        };
      }
    },
  },
  Assertion: {
    ROUTE_NAVIGATED: (route, state) => {
      if (state.report.matches('VALIDATED')) {
        return {
          current: route.type,
        };
      } else {
        return {
          current: 'Home',
        };
      }
    },
  },
});

export const createAppMachine = () => {
  return appMachine.create(
    {
      current: router.homeRoute.type,
    },
    {},
  );
};
