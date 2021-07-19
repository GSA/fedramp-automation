#!/usr/bin/env -S ts-node --script-mode

import * as fs from 'fs';
import { join } from 'path';

// @ts-ignore
import * as SaxonJS from 'saxon-js';

import {
  SaxonJsSchematronValidatorGateway,
  SchematronParser,
} from '../shared/saxon-js-gateway';
import { CommandLineController } from './cli-controller';

const config = require('../shared/project-config');

const controller = CommandLineController({
  readStringFile: fileName => fs.readFileSync(fileName, 'utf-8'),
  writeStringFile: (fileName, data) =>
    fs.writeFileSync(fileName, data, 'utf-8'),
  parseSchematron: SchematronParser({ SaxonJS }),
  validateSSP: SaxonJsSchematronValidatorGateway({
    sefUrl: `file://${join(config.PUBLIC_PATH, 'ssp.sef.json')}`,
    SaxonJS: SaxonJS,
    baselinesBaseUrl: config.BASELINES_PATH,
    registryBaseUrl: config.REGISTRY_PATH,
  }),
});

controller.parse(process.argv);
