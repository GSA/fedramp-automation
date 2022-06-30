import { Reducer, useCallback, useRef, useState } from 'react';
import type { ActionDispatch } from '../presenter';

export const useThunkReducer = <State, Event, Effects>(
  reducer: Reducer<State, Event>,
  effects: Effects,
  initialState: State,
): [State, ActionDispatch<State, Event, Effects>] => {
  const [hookState, setHookState] = useState(initialState);

  const state = useRef(hookState);
  const getState = useCallback(() => state.current, [state]);
  const setState = useCallback(
    (newState: State) => {
      state.current = newState;
      setHookState(newState);
    },
    [state, setHookState],
  );

  const reduce = useCallback(
    (event: Event) => {
      return reducer(getState(), event);
    },
    [reducer, getState],
  );

  // Dispatcher that optionally calls a thunk
  const dispatch: ActionDispatch<State, Event, Effects> = useCallback(
    (event: Event) => {
      return typeof event === 'function'
        ? event({ dispatch, getState, effects })
        : setState(reduce(event));
    },
    [getState, setState, reduce],
  );

  return [hookState, dispatch];
};
