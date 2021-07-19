export type RenderApp = () => void;

type BrowserControllerContext = {
  importMetaHot: ImportMetaHot | undefined;
  renderApp: RenderApp;
};

export const browserController = ({
  importMetaHot,
  renderApp,
}: BrowserControllerContext) => {
  renderApp();

  // Hot Module Replacement (HMR) - Remove this snippet to remove HMR.
  // Learn more: https://snowpack.dev/concepts/hot-module-replacement
  if (importMetaHot) {
    importMetaHot.accept();
  }
};
