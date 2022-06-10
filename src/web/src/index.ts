import { runBrowserContext } from '@asap/browser';
console.log(import.meta.env);
runBrowserContext({
  element: document.getElementById('root') as HTMLElement,
  baseUrl: import.meta.env.BASE_URL,
  debug: false,
  deploymentId: import.meta.env.DEPLOYMENT_ID,
  importMetaHot: import.meta.hot,
  githubRepository: import.meta.env.GITHUB,
});
