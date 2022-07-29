import { execSync } from 'child_process';
import { promises as fs, write } from 'fs';
import { join } from 'path';
import xmlFormatter from 'xml-formatter';

// @ts-ignore
import SaxonJS from 'saxon-js';

import { highlightXML } from '@asap/shared/adapters/highlight-js';
import {
  SaxonJsJsonOscalToXmlProcessor,
  SaxonJsProcessor,
  SaxonJsSchematronProcessorGateway,
  SaxonJsXSpecParser,
  SchematronParser,
} from '@asap/shared/adapters/saxon-js-gateway';
import * as config from '@asap/shared/project-config';
import { createXSpecScenarioSummaryWriter } from '@asap/shared/use-cases/assertion-documentation';
import { WriteAssertionViews } from '@asap/shared/use-cases/assertion-views';

import { CommandLineController } from './cli-controller';
import { OscalService } from '@asap/shared/use-cases/oscal';
import { SchematronSummary } from '@asap/shared/use-cases/schematron-summary';

const readStringFile = async (fileName: string) =>
  fs.readFile(fileName, 'utf-8');
const writeStringFile = (fileName: string, data: string) =>
  fs.writeFile(fileName, data, 'utf-8');

const GITHUB = {
  owner: process.env.OWNER || '18F',
  repository: process.env.REPOSITORY || 'fedramp-automation',
  branch: process.env.BRANCH || 'master',
  commit: execSync('git rev-parse HEAD').toString(),
};

const controller = CommandLineController({
  console,
  readStringFile,
  writeStringFile,
  useCases: {
    oscalService: new OscalService(
      SaxonJsJsonOscalToXmlProcessor({
        sefUrl: `file://${join(
          config.BUILD_PATH,
          'oscal_complete_json-to-xml-converter.sef.json',
        )}`,
        SaxonJS,
      }),
      SaxonJsSchematronProcessorGateway({
        sefUrls: {
          poam: `file://${join(config.BUILD_PATH, 'poam.sef.json')}`,
          sap: `file://${join(config.BUILD_PATH, 'sap.sef.json')}`,
          sar: `file://${join(config.BUILD_PATH, 'sar.sef.json')}`,
          ssp: `file://${join(config.BUILD_PATH, 'ssp.sef.json')}`,
        },
        SaxonJS: SaxonJS,
        baselinesBaseUrl: config.BASELINES_PATH,
        registryBaseUrl: config.REGISTRY_PATH,
      }),
      null as unknown as typeof fetch,
    ),
    schematronSummary: new SchematronSummary(
      SchematronParser({ SaxonJS }),
      readStringFile,
      writeStringFile,
    ),
    writeAssertionViews: WriteAssertionViews({
      paths: {
        assertionViewSEFPath: join(
          config.BUILD_PATH,
          'assertion-grouping.sef.json',
        ),
      },
      processXSLT: SaxonJsProcessor({ SaxonJS }),
      readStringFile,
      writeStringFile,
    }),
    writeXSpecScenarioSummaries: createXSpecScenarioSummaryWriter({
      formatXml: (xml: string) => highlightXML(xmlFormatter(xml)),
      github: GITHUB,
      parseXspec: SaxonJsXSpecParser({ SaxonJS }),
      readStringFile,
      writeStringFile,
    }),
  },
});

controller.parseAsync(process.argv).then(() => console.log('Done'));
