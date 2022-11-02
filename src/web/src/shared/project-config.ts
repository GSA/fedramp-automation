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

export const PUBLIC_PATH = join(PROJECT_ROOT, 'public');
export const BUILD_PATH = join(PROJECT_ROOT, 'build');
export const RULES_PATH = join(PROJECT_ROOT, '../validations/rules');
export const RULES_TEST_PATH = join(PROJECT_ROOT, '../validations/test/rules');

export const REPOSITORY_PATHS = {
  SCHEMATRON: {
    ssp: '/src/validations/rules/rev4/ssp.sch',
    sap: '/src/validations/rules/rev4/sap.sch',
    sar: '/src/validations/rules/rev4/sar.sch',
    poam: '/src/validations/rules/rev4/poam.sch',
  } as Record<OscalDocumentKey, `/${string}`>,
  XSPEC: {
    ssp: '/src/validations/test/rules/rev4/ssp.xspec',
    sap: '/src/validations/test/rules/rev4/sap.xspec',
    sar: '/src/validations/test/rules/rev4/sar.xspec',
    poam: '/src/validations/test/rules/rev4/poam.xspec',
  } as Record<OscalDocumentKey, `/${string}`>,
};

export const LOCAL_PATHS = {
  REPOSITORY_ROOT,
  REGISTRY_PATH: join(REPOSITORY_ROOT, 'dist/content/rev4/resources/xml'),
  BASELINES_PATH: join(REPOSITORY_ROOT, 'dist/content/rev4/baselines/xml'),
  SCHEMATRON: {
    ssp: join(REPOSITORY_ROOT, REPOSITORY_PATHS.SCHEMATRON.ssp),
    sar: join(REPOSITORY_ROOT, REPOSITORY_PATHS.SCHEMATRON.sar),
    sap: join(REPOSITORY_ROOT, REPOSITORY_PATHS.SCHEMATRON.sap),
    poam: join(REPOSITORY_ROOT, REPOSITORY_PATHS.SCHEMATRON.poam),
  } as Record<OscalDocumentKey, string>,
  SCHEMATRON_SUMMARY: {
    ssp: join(REPOSITORY_ROOT, './src/web/build/ssp.json'),
    sar: join(REPOSITORY_ROOT, './src/web/build/sar.json'),
    sap: join(REPOSITORY_ROOT, './src/web/build/sap.json'),
    poam: join(REPOSITORY_ROOT, './src/web/build/poam.json'),
  } as Record<OscalDocumentKey, string>,
  XSPEC: {
    ssp: join(REPOSITORY_ROOT, REPOSITORY_PATHS.XSPEC.ssp),
    sar: join(REPOSITORY_ROOT, REPOSITORY_PATHS.XSPEC.sar),
    sap: join(REPOSITORY_ROOT, REPOSITORY_PATHS.XSPEC.sap),
    poam: join(REPOSITORY_ROOT, REPOSITORY_PATHS.XSPEC.poam),
  } as Record<OscalDocumentKey, string>,
  XSPEC_SUMMARY: {
    ssp: join(BUILD_PATH, 'xspec-summary-ssp.json'),
    sap: join(BUILD_PATH, 'xspec-summary-sap.json'),
    sar: join(BUILD_PATH, 'xspec-summary-sar.json'),
    poam: join(BUILD_PATH, 'xspec-summary-poam.json'),
  } as Record<OscalDocumentKey, string>,
  ASSERTION_VIEW: {
    ssp: join(BUILD_PATH, 'assertion-views-ssp.json'),
    sap: join(BUILD_PATH, 'assertion-views-sap.json'),
    sar: join(BUILD_PATH, 'assertion-views-sar.json'),
    poam: join(BUILD_PATH, 'assertion-views-poam.json'),
  } as Record<OscalDocumentKey, string>,
};
