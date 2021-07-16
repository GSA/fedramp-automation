import { browserController } from './browser-controller';

describe('browser adapter', () => {
  it('renders the ui with hot reloading', () => {
    const importMetaHot = {
      accept: jest.fn(),
    } as unknown as ImportMetaHot;
    const renderApp = jest.fn();
    browserController({
      importMetaHot,
      renderApp,
    });
    expect(renderApp).toHaveBeenCalled();
    expect(importMetaHot.accept).toHaveBeenCalled();
  });

  it('renders the ui without hot reloading', () => {
    const renderApp = jest.fn();
    browserController({
      importMetaHot: undefined,
      renderApp,
    });
    expect(renderApp).toHaveBeenCalled();
  });
});
