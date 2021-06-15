#!/usr/bin/env -S ts-node --script-mode

// @ts-ignore
import * as SaxonJS from 'saxon-js';

import { SaxonJsSchematronValidatorGateway } from '../shared/saxon-js-gateway';
import { CommandLineController } from './cli-controller';
import { readStringFile } from './file-gateway.humble';

const config = require('../shared/project-config');

const controller = CommandLineController({
  readStringFile,
  validateSchematron: SaxonJsSchematronValidatorGateway({
    sefUrl: `file://${config.SEF_URL}`,
    SaxonJS: SaxonJS,
    baselinesBaseUrl: config.BASELINES_PATH,
    registryBaseUrl: config.REGISTRY_PATH,
  }),
});

controller.parse(process.argv);
