import { runBrowserContext } from './context/browser';

runBrowserContext({
  baseUrl: import.meta.env.BASEURL,
  debug: true,
  importMetaHot: import.meta.hot,
  githubRepository: import.meta.env.GITHUB,
});
