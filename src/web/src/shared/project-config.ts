/**
 * Define project-wide configuration settings.
 * Note that this is a CommonJS module so it may be used in
 * `snowpack.config.js` as well as application code.
 */

import { join } from 'path';
import { OscalDocumentKey } from './domain/oscal';
import {
  SchematronRulesetKey,
  SchematronRulesetKeys,
} from './domain/schematron';

// This should map to the directory containing the package.json.
// By convention, assume that the originating process was run from the root
// directory.
const PROJECT_ROOT = process.cwd();
export const REPOSITORY_ROOT = join(PROJECT_ROOT, '../../');

export const PUBLIC_PATH = join(PROJECT_ROOT, 'public');
export const BUILD_PATH = join(PUBLIC_PATH, 'rules');
export const RULES_PATH = join(PROJECT_ROOT, '../validations/rules');
export const RULES_TEST_PATH = join(PROJECT_ROOT, '../validations/test/rules');

export const getRepositoryPaths = (rulesetKey: SchematronRulesetKey) => ({
  SCHEMATRON: {
    ssp: `/src/validations/rules/${rulesetKey}/ssp.sch`,
    sap: `/src/validations/rules/${rulesetKey}/sap.sch`,
    sar: `/src/validations/rules/${rulesetKey}/sar.sch`,
    poam: `/src/validations/rules/${rulesetKey}/poam.sch`,
  } as Record<OscalDocumentKey, `/${string}`>,
  XSPEC: {
    ssp: `/src/validations/test/rules/${rulesetKey}/ssp.xspec`,
    sap: `/src/validations/test/rules/${rulesetKey}/sap.xspec`,
    sar: `/src/validations/test/rules/${rulesetKey}/sar.xspec`,
    poam: `/src/validations/test/rules/${rulesetKey}/poam.xspec`,
  } as Record<OscalDocumentKey, `/${string}`>,
});

export const REPOSITORY_PATHS = Object.fromEntries(
  SchematronRulesetKeys.map(rulesetKey => [
    rulesetKey,
    getRepositoryPaths(rulesetKey),
  ]),
) as Record<SchematronRulesetKey, ReturnType<typeof getRepositoryPaths>>;

export const getLocalPaths = (rulesetKey: SchematronRulesetKey) => ({
  REPOSITORY_ROOT,
  REGISTRY_PATH: join(
    REPOSITORY_ROOT,
    `dist/content/${rulesetKey}/resources/xml`,
  ),
  BASELINES_PATH: join(
    REPOSITORY_ROOT,
    `dist/content/${rulesetKey}/baselines/xml`,
  ),
  SCHEMATRON: {
    ssp: join(REPOSITORY_ROOT, REPOSITORY_PATHS[rulesetKey].SCHEMATRON.ssp),
    sar: join(REPOSITORY_ROOT, REPOSITORY_PATHS[rulesetKey].SCHEMATRON.sar),
    sap: join(REPOSITORY_ROOT, REPOSITORY_PATHS[rulesetKey].SCHEMATRON.sap),
    poam: join(REPOSITORY_ROOT, REPOSITORY_PATHS[rulesetKey].SCHEMATRON.poam),
  } as Record<OscalDocumentKey, string>,
  SCHEMATRON_SUMMARY: {
    ssp: join(BUILD_PATH, `./${rulesetKey}/ssp.json`),
    sar: join(BUILD_PATH, `./${rulesetKey}/sar.json`),
    sap: join(BUILD_PATH, `./${rulesetKey}/sap.json`),
    poam: join(BUILD_PATH, `./${rulesetKey}/poam.json`),
  } as Record<OscalDocumentKey, string>,
  XSPEC: {
    ssp: join(REPOSITORY_ROOT, REPOSITORY_PATHS[rulesetKey].XSPEC.ssp),
    sar: join(REPOSITORY_ROOT, REPOSITORY_PATHS[rulesetKey].XSPEC.sar),
    sap: join(REPOSITORY_ROOT, REPOSITORY_PATHS[rulesetKey].XSPEC.sap),
    poam: join(REPOSITORY_ROOT, REPOSITORY_PATHS[rulesetKey].XSPEC.poam),
  } as Record<OscalDocumentKey, string>,
  XSPEC_SUMMARY: {
    ssp: join(BUILD_PATH, `./${rulesetKey}/xspec-summary-ssp.json`),
    sar: join(BUILD_PATH, `./${rulesetKey}/xspec-summary-sar.json`),
    sap: join(BUILD_PATH, `./${rulesetKey}/xspec-summary-sap.json`),
    poam: join(BUILD_PATH, `./${rulesetKey}/xspec-summary-poam.json`),
  } as Record<OscalDocumentKey, string>,
  ASSERTION_VIEW: {
    ssp: join(BUILD_PATH, `./${rulesetKey}/assertion-views-ssp.json`),
    sap: join(BUILD_PATH, `./${rulesetKey}/assertion-views-sap.json`),
    sar: join(BUILD_PATH, `./${rulesetKey}/assertion-views-sar.json`),
    poam: join(BUILD_PATH, `./${rulesetKey}/assertion-views-poam.json`),
  } as Record<OscalDocumentKey, string>,
});
export const SCHEMATRON_SUMMARY_LOCAL_PATHS: Record<OscalDocumentKey, string> =
  {
    ssp: join(REPOSITORY_ROOT, './src/web/public/rules/ssp.json'),
    sar: join(REPOSITORY_ROOT, './src/web/public/rules/sar.json'),
    sap: join(REPOSITORY_ROOT, './src/web/public/rules/sap.json'),
    poam: join(REPOSITORY_ROOT, './src/web/public/rules/poam.json'),
  };

export const LOCAL_PATHS = Object.fromEntries(
  SchematronRulesetKeys.map(rulesetKey => [
    rulesetKey,
    getLocalPaths(rulesetKey),
  ]),
) as Record<SchematronRulesetKey, ReturnType<typeof getLocalPaths>>;
