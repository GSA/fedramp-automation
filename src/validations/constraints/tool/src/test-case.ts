import * as fs from 'fs';
import * as yaml from 'js-yaml';
import {OscalCli } from "./oscal-cli";

interface Pipeline {
  action: string;
}

enum Result {
  PASS = "pass",
  FAIL = "fail"
}

interface Expectation {
  'constraint-id': string;
  result: Result;
}

interface TestCase {
  name: string;
  description: string;
  content: string;
  pipeline: Pipeline[];
}

export class TestDescriptor {
  data: TestCase;

  public constructor(file: string) {
    this.data = yaml.load(fs.readFileSync(file, 'utf8')) as TestCase;
  }
  execute(options: { oscalCli: OscalCli; }) {
    options.oscalCli.validate(this.data.content);
  }
}
