import { execSync } from 'child_process';

import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import tsconfigPaths from 'vite-tsconfig-paths';

const BASEURL = process.env.BASEURL || '/';
const GITHUB = {
  owner: process.env.OWNER || '18F',
  repository: process.env.REPOSITORY || 'fedramp-automation',
  branch: process.env.BRANCH || 'master',
  commit: execSync('git rev-parse HEAD').toString().trim(),
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
});
