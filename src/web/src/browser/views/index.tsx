import 'uswds';

import { Provider } from 'overmind-react';
import React from 'react';
import ReactDOM from 'react-dom';
import Modal from 'react-modal';

import { Presenter } from '@asap/browser/presenter';

import { App } from './components/App';
import { AppProvider } from './context';
import './styles/index.scss';

export const createAppRenderer =
  (rootElement: HTMLElement, presenter: Presenter) => () => {
    Modal.setAppElement(rootElement);
    ReactDOM.render(
      <React.StrictMode>
        <AppProvider>
          <Provider value={presenter}>
            <App />
          </Provider>
        </AppProvider>
      </React.StrictMode>,
      rootElement,
    );
  };
