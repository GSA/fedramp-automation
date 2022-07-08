import { runBrowserContext } from '@asap/browser';

runBrowserContext({
  element: document.getElementById('root') as HTMLElement,
  baseUrl: import.meta.env.BASE_URL as `${string}/`,
  githubRepository: import.meta.env.GITHUB,
});
