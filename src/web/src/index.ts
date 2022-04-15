import { runBrowserContext } from '@asap/browser';

runBrowserContext({
  element: document.getElementById('root') as HTMLElement,
  baseUrl: import.meta.env.BASEURL,
  debug: false,
  deploymentId: import.meta.env.DEPLOYMENT_ID,
  importMetaHot: import.meta.hot,
  githubRepository: import.meta.env.GITHUB,
});
