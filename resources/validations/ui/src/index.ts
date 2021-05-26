import browserContext from './context/browser';

browserContext({ debug: true, baseUrl: import.meta.env.BASEURL });
