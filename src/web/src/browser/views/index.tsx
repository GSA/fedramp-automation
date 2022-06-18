import 'uswds';

import React from 'react';
import ReactDOM from 'react-dom';
import Modal from 'react-modal';

import { App } from './components/App';
import { AppContextProvider } from './context';
import './styles/index.scss';
import { State } from '../presenter/state';
import { Effects } from '../presenter';

export const createAppRenderer =
  (rootElement: HTMLElement, initialState: State, effects: Effects) => () => {
    Modal.setAppElement(rootElement);
    ReactDOM.render(
      <React.StrictMode>
        <AppContextProvider effects={effects} initialState={initialState}>
          <App />
        </AppContextProvider>
      </React.StrictMode>,
      rootElement,
    );
  };
