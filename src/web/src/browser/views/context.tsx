import { createContext, useContext, useState } from 'react';
import { Presenter } from '../presenter';
import { initializeApplication } from '../presenter/actions';

import {
  initialState,
  NewState,
  rootReducer,
  NewEvent,
} from '../presenter/state';
import { ThunkDispatch, useThunkReducer } from './hooks';

export type AppContextType = {
  state: NewState;
  dispatch: ThunkDispatch<NewState, NewEvent, Presenter['effects']>;
};
export const AppContext = createContext<AppContextType>({
  state: initialState,
  dispatch: () => null,
});

export const useAppContext = () => {
  return useContext(AppContext);
};

export const AppContextProvider = ({
  children,
  effects,
}: {
  children: React.ReactNode;
  effects: Presenter['effects'];
}) => {
  const [appInitialized, setAppInitialized] = useState(false);
  const [state, dispatch] = useThunkReducer<
    NewState,
    NewEvent,
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
