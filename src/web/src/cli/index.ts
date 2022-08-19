import { promises as fs } from 'fs';
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

const readStringFile = async (fileName: string) =>
  fs.readFile(fileName, 'utf-8');
const writeStringFile = (fileName: string, data: string) =>
  fs.writeFile(fileName, data, 'utf-8');

const controller = CommandLineController({
  console,
  readStringFile,
  writeStringFile,
  useCases: {
    parseSchematron: SchematronParser({ SaxonJS }),
    writeXSpecScenarioSummaries: createXSpecScenarioSummaryWriter({
      formatXml: (xml: string) => highlightXML(xmlFormatter(xml)),
      parseXspec: SaxonJsXSpecParser({ SaxonJS }),
      readStringFile,
      writeStringFile,
    }),
    oscalService: new OscalService(
      {
        ssp: SaxonJsJsonOscalToXmlProcessor({
          console,
          sefUrl: `file://${join(
            config.BUILD_PATH,
            'oscal_ssp_json-to-xml-converter.sef.json',
          )}`,
          SaxonJS,
        }),
        sap: SaxonJsJsonOscalToXmlProcessor({
          console,
          sefUrl: `file://${join(
            config.BUILD_PATH,
            'oscal_assessment-plan_json-to-xml-converter.json',
          )}`,
          SaxonJS,
        }),
        sar: SaxonJsJsonOscalToXmlProcessor({
          console,
          sefUrl: `file://${join(
            config.BUILD_PATH,
            'oscal_assessment-results_json-to-xml-converter.sef.json',
          )}`,
          SaxonJS,
        }),
        poam: SaxonJsJsonOscalToXmlProcessor({
          console,
          sefUrl: `file://${join(
            config.BUILD_PATH,
            'oscal_poam_json-to-xml-converter.sef.json',
          )}`,
          SaxonJS,
        }),
      },
      SaxonJsSchematronProcessorGateway({
        console,
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
  },
});

controller.parseAsync(process.argv).then(() => console.log('Done'));
