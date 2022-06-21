import { runBrowserContext } from '@asap/browser';

runBrowserContext({
  element: document.getElementById('root') as HTMLElement,
  baseUrl: import.meta.env.BASE_URL,
  debug: false,
  deploymentId: import.meta.env.DEPLOYMENT_ID,
  githubRepository: import.meta.env.GITHUB,
});
