import { transform as validateSspXml } from './adapters/saxon-js';
import { createPresenter } from './presenter';
import { renderApp } from './views';

const main = () => {
  const presenter = createPresenter({ validateSspXml });
  renderApp(document.getElementById('root') as HTMLElement, presenter);
};

main();
