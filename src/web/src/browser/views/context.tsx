import { createContext, useContext, useState } from 'react';
import { Presenter } from '../presenter';
import { initializeApplication } from '../presenter/actions';

import { State, rootReducer, StateTransition } from '../presenter/state';
import { ThunkDispatch, useThunkReducer } from './hooks';

export type AppContextType = {
  state: State;
  dispatch: ThunkDispatch<State, StateTransition, Presenter['effects']>;
};
export const AppContext = createContext<AppContextType>({
  state: {} as State,
  dispatch: () => null,
});

export const useAppContext = () => {
  return useContext(AppContext);
};

export const AppContextProvider = ({
  children,
  effects,
  initialState,
}: {
  children: React.ReactNode;
  effects: Presenter['effects'];
  initialState: State;
}) => {
  const [appInitialized, setAppInitialized] = useState(false);
  const [state, dispatch] = useThunkReducer<
    State,
    StateTransition,
    Presenter['effects']
  >(rootReducer, effects, initialState);

  const value = {
    state,
    dispatch,
  };

  // TODO: Move somewhere else?
  if (!appInitialized) {
    dispatch(initializeApplication);
    setAppInitialized(true);
  }

  return <AppContext.Provider value={value}>{children}</AppContext.Provider>;
};
