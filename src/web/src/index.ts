import { runBrowserContext } from '@asap/browser';

runBrowserContext({
  element: document.getElementById('root') as HTMLElement,
  baseUrl: import.meta.env.BASEURL,
  debug: false,
  importMetaHot: import.meta.hot,
  githubRepository: import.meta.env.GITHUB,
});
