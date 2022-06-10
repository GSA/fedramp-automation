/**
 * Define project-wide configuration settings.
 * Note that this is a CommonJS module so it may be used in
 * `snowpack.config.js` as well as application code.
 */

import { join } from 'path';

// This should map to the directory containing the package.json.
// By convention, assume that the originating process was run from the root
// directory.
const PROJECT_ROOT = process.cwd();

export const REGISTRY_PATH = join(
  PROJECT_ROOT,
  '../../dist/content/resources/xml',
);
export const BASELINES_PATH = join(
  PROJECT_ROOT,
  '../../dist/content/baselines/rev4/xml',
);
export const PUBLIC_PATH = join(PROJECT_ROOT, 'public');
export const BUILD_PATH = join(PROJECT_ROOT, 'build');
export const RULES_PATH = join(PROJECT_ROOT, '../validations/rules');
export const RULES_TEST_PATH = join(PROJECT_ROOT, '../validations/test/rules');
