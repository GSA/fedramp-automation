import * as path from 'path';

import glob from 'glob';
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tsconfigPaths from 'vite-tsconfig-paths';

const BASEURL = process.env.BASEURL || '';
const GITHUB = {
  owner: process.env.OWNER || '18F',
  repository: process.env.REPOSITORY || 'fedramp-automation',
  branch: process.env.BRANCH || 'master',
};

const DEPLOYMENT_ID =
  process.env.NODE_ENV === 'development'
    ? 'local'
    : `${GITHUB.owner}:${GITHUB.branch}`;

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [tsconfigPaths(), react()],
  base: BASEURL,
  define: {
    'import.meta.env.DEPLOYMENT_ID': JSON.stringify(DEPLOYMENT_ID),
    'import.meta.env.GITHUB': JSON.stringify(GITHUB),
  },
  build: {
    rollupOptions: {
      // input: glob
      //   .sync(path.resolve(__dirname, 'src') + '/**/*.html')
      //   .reduce((acc, cur) => {
      //     let name = cur
      //       .replace(path.join(__dirname) + '/src/', '')
      //       .replace('/index.html', '');
      //     // If name is blank, make up a name for it, like 'home'
      //     if (name === '') {
      //       name = 'home';
      //     }
      //     acc[name] = cur;
      //     return acc;
      //   }, {}),
    },
  },
});
