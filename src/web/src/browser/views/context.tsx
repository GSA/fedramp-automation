import { createContext, useContext, useState } from 'react';

import { Effects } from '../presenter';
import { initializeApplication } from '../presenter/actions';
import { State, rootReducer, StateTransition } from '../presenter/state';
import { ThunkDispatch, useThunkReducer } from './hooks';

export type AppContextType = {
  state: State;
  dispatch: ThunkDispatch<State, StateTransition, Effects>;
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
  effects: Effects;
  initialState: State;
}) => {
  const [appInitialized, setAppInitialized] = useState(false);
  const [state, dispatch] = useThunkReducer<State, StateTransition, Effects>(
    rootReducer,
    effects,
    initialState,
  );

  // TODO: Move somewhere else?
  if (!appInitialized) {
    dispatch(initializeApplication);
    setAppInitialized(true);
  }

  return (
    <AppContext.Provider
      value={{
        state,
        dispatch,
      }}
    >
      {children}
    </AppContext.Provider>
  );
};
