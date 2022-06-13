type State =
  | {
      current: 'OPT_IN';
      userAlias: string;
    }
  | {
      current: 'OPT_OUT';
    };

type Event =
  | {
      type: 'TOGGLE';
    }
  | {
      type: 'SET_USER_ALIAS';
      userAlias: string;
    };

export const createMetricsMachine = (): State => {
  return {
    current: 'OPT_OUT',
  };
};

export const nextState = (state: State, event: Event): State => {
  if (state.current === 'OPT_IN') {
    if (event.type === 'TOGGLE') {
      return {
        current: 'OPT_OUT',
      };
    } else if (event.type === 'SET_USER_ALIAS') {
      return {
        current: 'OPT_IN',
        userAlias: state.userAlias,
      };
    }
  } else if (state.current === 'OPT_OUT') {
    if (event.type === 'TOGGLE') {
      return {
        current: 'OPT_IN',
        userAlias: '',
      };
    }
  }
  return state;
};
