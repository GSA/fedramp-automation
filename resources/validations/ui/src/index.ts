import browserContext from './context/browser';
console.log(
  import.meta.env.REPOSITORY,
  import.meta.env.OWNER,
  import.meta.env.BRANCH,
);
browserContext({
  baseUrl: import.meta.env.BASEURL,
  debug: true,
  importMetaHot: import.meta.hot,
  repository: import.meta.env.REPOSITORY,
});
