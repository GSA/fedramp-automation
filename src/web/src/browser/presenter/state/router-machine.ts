import * as router from './router';

type BaseState = {
  currentRoute: router.Route;
};

export type State = BaseState & {
  current: 'VALID_PAGE';
};

export type StateTransition = {
  type: 'ROUTE_CHANGED';
  data: {
    route: router.Route;
  };
};

export const nextState = (state: State, event: StateTransition): State => {
  if (state.current === 'VALID_PAGE') {
    if (event.type === 'ROUTE_CHANGED') {
      return {
        current: 'VALID_PAGE',
        currentRoute: event.data.route,
      };
    }
  }
  return state;
};

export const initialState: State = {
  current: 'VALID_PAGE',
  currentRoute: router.Routes.home,
};
