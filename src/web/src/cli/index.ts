#!/usr/bin/env -S ts-node --script-mode

import { promises as fs } from 'fs';
import { join } from 'path';
const xmlFormatter = require('xml-formatter');

// @ts-ignore
import * as SaxonJS from 'saxon-js';

import { highlightXML } from '@asap/shared/adapters/highlight-js-commonjs';
import {
  SaxonJsJsonSspToXmlProcessor,
  SaxonJsProcessor,
  SaxonJsSchematronProcessorGateway,
  SaxonJSXmlIndenter,
  SaxonJsXSpecParser,
  SchematronParser,
} from '@asap/shared/adapters/saxon-js-gateway';
const config = require('@asap/shared/project-config');
import { createXSpecScenarioSummaryWriter } from '@asap/shared/use-cases/assertion-documentation';
import { WriteAssertionViews } from '@asap/shared/use-cases/assertion-views';
import { ValidateSSPUseCase } from '@asap/shared/use-cases/validate-ssp-xml';

import { CommandLineController } from './cli-controller';

const readStringFile = async (fileName: string) =>
  fs.readFile(fileName, 'utf-8');
const writeStringFile = (fileName: string, data: string) =>
  fs.writeFile(fileName, data, 'utf-8');

const indentXml = SaxonJSXmlIndenter({ SaxonJS });

const controller = CommandLineController({
  readStringFile,
  writeStringFile,
  useCases: {
    parseSchematron: SchematronParser({ SaxonJS }),
    writeXSpecScenarioSummaries: createXSpecScenarioSummaryWriter({
      formatXml: (xml: string) => highlightXML(xmlFormatter(xml)),
      getSspXspec: () =>
        readStringFile(join(config.RULES_TEST_PATH, 'ssp.xspec')),
      parseXspec: SaxonJsXSpecParser({ SaxonJS }),
      writeSummary: (data: string) =>
        writeStringFile(join(config.PUBLIC_PATH, 'xspec-scenarios.json'), data),
    }),
    validateSSP: ValidateSSPUseCase({
      jsonSspToXml: SaxonJsJsonSspToXmlProcessor({
        sefUrl: `file://${join(
          config.PUBLIC_PATH,
          'oscal_ssp_json-to-xml-converter.sef.json',
        )}`,
        SaxonJS,
      }),
      processSchematron: SaxonJsSchematronProcessorGateway({
        sefUrl: `file://${join(config.PUBLIC_PATH, 'ssp.sef.json')}`,
        SaxonJS: SaxonJS,
        baselinesBaseUrl: config.BASELINES_PATH,
        registryBaseUrl: config.REGISTRY_PATH,
      }),
    }),
    writeAssertionViews: WriteAssertionViews({
      paths: {
        assertionViewSEFPath: join(
          config.PUBLIC_PATH,
          'assertion-grouping.sef.json',
        ),
        outputFilePath: join(config.PUBLIC_PATH, 'assertion-views.json'),
        schematronXMLPath: join(config.RULES_PATH, 'ssp.sch'),
      },
      processXSLT: SaxonJsProcessor({ SaxonJS }),
      readStringFile,
      writeStringFile,
    }),
  },
});

controller.parse(process.argv);
