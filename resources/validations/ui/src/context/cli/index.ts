#!/usr/bin/env -S ts-node --script-mode

import * as path from 'path';

// @ts-ignore
import * as SaxonJS from 'saxon-js';

import { SaxonJsSchematronValidatorGateway } from '../shared/saxon-js-gateway';
import { CommandLineController } from './cli-controller';
import { readStringFile } from './file-gateway.humble';

const PROJECT_ROOT = process.cwd();

const controller = CommandLineController({
  readStringFile,
  validateSchematron: SaxonJsSchematronValidatorGateway({
    sefUrl: `file://${path.join(PROJECT_ROOT, 'public/ssp.sef.json')}`,
    // The npm version of saxon-js is for node; currently, we load the
    // browser version via a script tag in index.html.
    SaxonJS: SaxonJS,
    baselinesBaseUrl: `file://${path.join(
      PROJECT_ROOT,
      '../../../baselines/rev4/xml',
    )}`,
    registryBaseUrl: `file://${path.join(
      PROJECT_ROOT,
      '../../../resources/xml',
    )}`,
  }),
});

controller.parse(process.argv);
