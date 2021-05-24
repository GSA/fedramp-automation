import 'uswds';

import { Provider } from 'overmind-react';
import React from 'react';
import ReactDOM from 'react-dom';

import type { Presenter } from '../presenter';
import { App } from './components/App';
import './index.scss';

export const renderApp = (rootElement: HTMLElement, presenter: Presenter) => {
  ReactDOM.render(
    <React.StrictMode>
      <Provider value={presenter}>
        <App />
      </Provider>
    </React.StrictMode>,
    rootElement,
  );
  // Hot Module Replacement (HMR) - Remove this snippet to remove HMR.
  // Learn more: https://snowpack.dev/concepts/hot-module-replacement
  if (import.meta.hot) {
    import.meta.hot.accept();
  }
};
