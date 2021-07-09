const config = require('./src/context/shared/project-config');

const BASEURL = process.env.BASEURL || '';
const GITHUB = {
  owner: process.env.OWNER || '18F',
  repository: process.env.REPOSITORY || 'fedramp-automation',
  branch: process.env.BRANCH || 'master',
};

/** @type {import("snowpack").SnowpackUserConfig } */
module.exports = {
  env: {
    BASEURL,
    GITHUB,
  },
  mount: {
    src: { url: '/dist' },
    [config.PUBLIC_PATH]: { url: '/', static: true },
    [config.REGISTRY_PATH]: { url: '/xml', static: true },
    [config.BASELINES_PATH]: {
      url: '/baselines',
      static: true,
    },
    'node_modules/uswds/dist/fonts': { url: '/uswds/fonts', static: true },
    'node_modules/uswds/dist/img': { url: '/uswds/img', static: true },
    'node_modules/uswds/dist/js': { url: '/uswds/js', static: true },
    //validations: { url: '/validations', static: true },
  },
  exclude: ['**/node_modules/**/*', '**/src/context/cli/**'],
  plugins: [
    '@snowpack/plugin-react-refresh',
    '@snowpack/plugin-dotenv',
    '@snowpack/plugin-postcss',
    [
      '@snowpack/plugin-sass',
      {
        loadPath: './node_modules/uswds/dist/scss',
      },
    ],
    '@snowpack/plugin-webpack',
    [
      '@snowpack/plugin-typescript',
      {
        /* Yarn PnP workaround: see https://www.npmjs.com/package/@snowpack/plugin-typescript */
        ...(process.versions.pnp ? { tsc: 'yarn pnpify tsc' } : {}),
      },
    ],
    [
      'snowpack-plugin-raw-file-loader',
      {
        exts: ['.txt', '.sch'],
      },
    ],
  ],
  routes: [
    /* Enable an SPA Fallback in development: */
    // {"match": "routes", "src": ".*", "dest": "/index.html"},
  ],
  optimize: {
    /* Example: Bundle your final build: */
    // "bundle": true,
  },
  packageOptions: {
    /* ... */
  },
  devOptions: {
    /* ... */
  },
  buildOptions: {
    baseUrl: BASEURL,
  },
};
