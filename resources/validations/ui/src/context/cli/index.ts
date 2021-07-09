#!/usr/bin/env -S ts-node --script-mode

import * as fs from 'fs';
import { join } from 'path';

import { Schema } from 'node-schematron';
// @ts-ignore
import * as SaxonJS from 'saxon-js';

import { SaxonJsSchematronValidatorGateway } from '../shared/saxon-js-gateway';
import { CommandLineController } from './cli-controller';
import type { Schematron } from '../../use-cases/schematron';

const config = require('../shared/project-config');

const controller = CommandLineController({
  readStringFile: fileName => fs.readFileSync(fileName, 'utf-8'),
  writeStringFile: (fileName, data) =>
    fs.writeFileSync(fileName, data, 'utf-8'),
  parseSchematron: x => Schema.fromString(x) as Schematron,
  validateSSP: SaxonJsSchematronValidatorGateway({
    sefUrl: `file://${join(config.PUBLIC_PATH, 'ssp.sef.json')}`,
    SaxonJS: SaxonJS,
    baselinesBaseUrl: config.BASELINES_PATH,
    registryBaseUrl: config.REGISTRY_PATH,
  }),
});

controller.parse(process.argv);
