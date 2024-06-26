import { OscalCli } from './oscal-cli'
import { TestDescriptor } from './test-case';
import * as sarif from "sarif";
const cli = new OscalCli("/Users/davidawaltermire/git/david-waltermire/oscal-cli/target/cli-core-1.1.0-SNAPSHOT-oscal-cli/bin/oscal-cli");

const testCase = new TestDescriptor('../unit-tests/response-point-PASS.yaml');

testCase.execute({ oscalCli: cli});
console.log("done");

/** Run Jest tests. */
//testCases.forEach(testCase => {
  //test(testCase.description, async() => {

    /** Test is the SARIF file is valid. */
    //expect(fileSarif).toBeValidSarifLog();

    /** Test the "version" value. */
    //expect(fileSarif.version).toMatch(testCase.version);


    /** Test the "name" value. */
    //expect(fileSarif.browser.name).toMatch(testCase.browser.name);


    /** Match the entire file. */
    //expect(fileSarif).toMatch(testCase);


    //done();
  //});
//});
