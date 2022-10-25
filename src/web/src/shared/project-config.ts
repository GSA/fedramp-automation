/**
 * Define project-wide configuration settings.
 * Note that this is a CommonJS module so it may be used in
 * `snowpack.config.js` as well as application code.
 */

import { join } from 'path';
import { OscalDocumentKey } from './domain/oscal';

// This should map to the directory containing the package.json.
// By convention, assume that the originating process was run from the root
// directory.
const PROJECT_ROOT = process.cwd();
const REPOSITORY_ROOT = join(PROJECT_ROOT, '../../');

export const REGISTRY_PATH = join(
  PROJECT_ROOT,
  '../../dist/content/rev4/resources/xml',
);
export const BASELINES_PATH = join(
  PROJECT_ROOT,
  '../../dist/content/rev4/baselines/xml',
);
export const PUBLIC_PATH = join(PROJECT_ROOT, 'public');
export const BUILD_PATH = join(PROJECT_ROOT, 'build');
export const RULES_PATH = join(PROJECT_ROOT, '../validations/rules');
export const RULES_TEST_PATH = join(PROJECT_ROOT, '../validations/test/rules');

export const SCHEMATRON_REPOSITORY_PATHS: Record<
  OscalDocumentKey,
  `/${string}`
> = {
  ssp: '/src/validations/rules/ssp.sch',
  sap: '/src/validations/rules/sap.sch',
  sar: '/src/validations/rules/sar.sch',
  poam: '/src/validations/rules/poam.sch',
};

export const SCHEMATRON_LOCAL_PATHS: Record<OscalDocumentKey, string> = {
  ssp: join(REPOSITORY_ROOT, SCHEMATRON_REPOSITORY_PATHS.ssp),
  sar: join(REPOSITORY_ROOT, SCHEMATRON_REPOSITORY_PATHS.sar),
  sap: join(REPOSITORY_ROOT, SCHEMATRON_REPOSITORY_PATHS.sap),
  poam: join(REPOSITORY_ROOT, SCHEMATRON_REPOSITORY_PATHS.poam),
};

export const SCHEMATRON_SUMMARY_LOCAL_PATHS: Record<OscalDocumentKey, string> =
  {
    ssp: join(REPOSITORY_ROOT, './src/web/build/ssp.json'),
    sar: join(REPOSITORY_ROOT, './src/web/build/sar.json'),
    sap: join(REPOSITORY_ROOT, './src/web/build/sap.json'),
    poam: join(REPOSITORY_ROOT, './src/web/build/poam.json'),
  };

export const XSPEC_REPOSITORY_PATHS: Record<OscalDocumentKey, `/${string}`> = {
  ssp: '/src/validations/test/rules/ssp.xspec',
  sap: '/src/validations/test/rules/sap.xspec',
  sar: '/src/validations/test/rules/sar.xspec',
  poam: '/src/validations/test/rules/poam.xspec',
};

export const XSPEC_LOCAL_PATHS: Record<OscalDocumentKey, string> = {
  ssp: join(REPOSITORY_ROOT, XSPEC_REPOSITORY_PATHS.ssp),
  sar: join(REPOSITORY_ROOT, XSPEC_REPOSITORY_PATHS.sar),
  sap: join(REPOSITORY_ROOT, XSPEC_REPOSITORY_PATHS.sap),
  poam: join(REPOSITORY_ROOT, XSPEC_REPOSITORY_PATHS.poam),
};

export const XSPEC_SUMMARY_LOCAL_PATHS: Record<OscalDocumentKey, string> = {
  ssp: join(BUILD_PATH, 'xspec-summary-ssp.json'),
  sap: join(BUILD_PATH, 'xspec-summary-sap.json'),
  sar: join(BUILD_PATH, 'xspec-summary-sar.json'),
  poam: join(BUILD_PATH, 'xspec-summary-poam.json'),
};

export const ASSERTION_VIEW_LOCAL_PATHS: Record<OscalDocumentKey, string> = {
  ssp: join(BUILD_PATH, 'assertion-views-ssp.json'),
  sap: join(BUILD_PATH, 'assertion-views-sap.json'),
  sar: join(BUILD_PATH, 'assertion-views-sar.json'),
  poam: join(BUILD_PATH, 'assertion-views-poam.json'),
};
