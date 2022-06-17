export type State =
  | {
      current: 'METRICS_OPT_IN';
      userAlias: string;
    }
  | {
      current: 'METRICS_OPT_OUT';
    };

export type StateTransition =
  | {
      type: 'METRICS_TOGGLE';
    }
  | {
      type: 'METRICS_SET_USER_ALIAS';
      userAlias: string;
    };

export const initialState: State = {
  current: 'METRICS_OPT_OUT',
};

export const nextState = (state: State, event: StateTransition): State => {
  if (state.current === 'METRICS_OPT_IN') {
    if (event.type === 'METRICS_TOGGLE') {
      return {
        current: 'METRICS_OPT_OUT',
      };
    } else if (event.type === 'METRICS_SET_USER_ALIAS') {
      return {
        current: 'METRICS_OPT_IN',
        userAlias: state.userAlias,
      };
    }
  } else if (state.current === 'METRICS_OPT_OUT') {
    if (event.type === 'METRICS_TOGGLE') {
      return {
        current: 'METRICS_OPT_IN',
        userAlias: '',
      };
    }
  }
  return state;
};
