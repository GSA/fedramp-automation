import { createContext, useContext, useReducer } from 'react';

import {
  initialState,
  NewState,
  rootReducer,
  NewEvent,
} from '../presenter/state';

export const AppContext = createContext<{
  state: NewState;
  dispatch: React.Dispatch<NewEvent>;
}>({
  state: initialState,
  dispatch: () => null,
});

export const useAppReducer = () => {
  return useReducer(rootReducer, initialState);
};

export const useAppContext = () => {
  const { state, dispatch } = useContext(AppContext);
  return { state, dispatch };
};
export type NewAppContext = ReturnType<typeof useAppContext>;

export const AppProvider: React.FC = ({ children }) => {
  const [state, dispatch] = useAppReducer();
  return (
    <AppContext.Provider value={{ state, dispatch }}>
      {children}
    </AppContext.Provider>
  );
};
