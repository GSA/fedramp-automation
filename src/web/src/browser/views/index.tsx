import 'uswds';

import React from 'react';
import ReactDOM from 'react-dom';
import Modal from 'react-modal';

import { Presenter } from '@asap/browser/presenter';

import { App } from './components/App';
import { AppContextProvider } from './context';
import './styles/index.scss';
import { State } from '../presenter/state';

export const createAppRenderer =
  (rootElement: HTMLElement, initialState: State, presenter: Presenter) =>
  () => {
    Modal.setAppElement(rootElement);
    ReactDOM.render(
      <React.StrictMode>
        <AppContextProvider
          effects={presenter.effects}
          initialState={initialState}
        >
          <App />
        </AppContextProvider>
      </React.StrictMode>,
      rootElement,
    );
  };
