import { runBrowserContext } from './context/browser';

runBrowserContext({
  baseUrl: import.meta.env.BASEURL,
  debug: true,
  importMetaHot: import.meta.hot,
  repositoryUrl: import.meta.env.REPOSITORY,
});
