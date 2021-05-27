const BASEURL = process.env.BASEURL || '';

/** @type {import("snowpack").SnowpackUserConfig } */
module.exports = {
  env: {
    BASEURL,
  },
  mount: {
    public: { url: '/', static: true },
    src: { url: '/dist' },
    'node_modules/uswds/dist/fonts': { url: '/uswds/fonts', static: true },
    'node_modules/uswds/dist/img': { url: '/uswds/img', static: true },
    'node_modules/uswds/dist/js': { url: '/uswds/js', static: true },
    validations: { url: '/validations', static: true },
  },
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
