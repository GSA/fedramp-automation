import { it, describe, expect, vi } from 'vitest';

import { browserController } from './browser-controller';

describe('browser adapter', () => {
  it('renders the ui with hot reloading', () => {
    const importMetaHot = {
      accept: vi.fn(),
    } as unknown as ImportMetaHot;
    const renderApp = vi.fn();
    browserController({
      importMetaHot,
      renderApp,
    });
    expect(renderApp).toHaveBeenCalled();
    expect(importMetaHot.accept).toHaveBeenCalled();
  });

  it('renders the ui without hot reloading', () => {
    const renderApp = vi.fn();
    browserController({
      importMetaHot: undefined,
      renderApp,
    });
    expect(renderApp).toHaveBeenCalled();
  });
});
