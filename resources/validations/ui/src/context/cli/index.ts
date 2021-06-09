#!/usr/bin/env -S ts-node --script-mode

import { commandLineController } from './cli-controller';

commandLineController({
  argv: process.argv.slice(2),
  exitProcess: true,
});
