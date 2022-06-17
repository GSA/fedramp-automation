import {
  createStateHook,
  createActionsHook,
  createEffectsHook,
  createReactionHook,
} from 'overmind-react';

import type { PresenterConfig } from '@asap/browser/presenter';
import { Reducer, useCallback, useRef, useState } from 'react';

export const useAppState = createStateHook<PresenterConfig>();
export const useActions = createActionsHook<PresenterConfig>();
export const useEffects = createEffectsHook<PresenterConfig>();
export const useReaction = createReactionHook<PresenterConfig>();

export interface ThunkDispatch<S, A, E> {
  <
    Action extends ({
      dispatch,
      getState,
      effects,
    }: {
      dispatch: ThunkDispatch<S, A, E>;
      getState: () => S;
      effects: E;
    }) => unknown,
  >(
    action: Action,
  ): ReturnType<Action>;
  (value: A): void;
}

export function useThunkReducer<State, Event, Effects>(
  reducer: Reducer<State, Event>,
  effects: Effects,
  initialState: State,
): [State, ThunkDispatch<State, Event, Effects>] {
  const [hookState, setHookState] = useState(initialState);

  const state = useRef(hookState);
  const getState = useCallback(() => state.current, [state]);
  const setState = useCallback(
    (State: State) => {
      state.current = State;
      setHookState(State);
    },
    [state, setHookState],
  );

  const reduce = useCallback(
    (event: Event) => {
      return reducer(getState(), event);
    },
    [reducer, getState],
  );

  // Augmented dispatcher.
  const dispatch: ThunkDispatch<State, Event, Effects> = useCallback(
    (event: Event) => {
      return typeof event === 'function'
        ? event({ dispatch, getState, effects })
        : setState(reduce(event));
    },
    [getState, setState, reduce],
  );

  return [hookState, dispatch];
}
