#!/usr/bin/env -S ts-node --script-mode

// @ts-ignore
import * as SaxonJS from 'saxon-js';

import { SaxonJsSchematronValidatorGateway } from '../shared/saxon-js-gateway';
import { CommandLineController } from './cli-controller';
import { readStringFile } from './file-gateway.humble';

const controller = CommandLineController({
  readStringFile,
  validateSchematron: SaxonJsSchematronValidatorGateway({
    sefUrl: `file:///Users/dan/src/10x/fedramp-automation/resources/validations/ui/public/ssp.sef.json`,
    // The npm version of saxon-js is for node; currently, we load the
    // browser version via a script tag in index.html.
    SaxonJS: SaxonJS,
    baselinesBaseUrl: `file:///Users/dan/src/10x/fedramp-automation/baselines/rev4/xml`,
    registryBaseUrl: `file:///Users/dan/src/10x/fedramp-automation/resources/xml`,
  }),
});

controller.parse(process.argv);
console.log(controller.opts());
