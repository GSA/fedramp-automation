import browserContext from './context/browser';

browserContext({
  baseUrl: import.meta.env.BASEURL,
  debug: true,
  importMetaHot: import.meta.hot,
});
