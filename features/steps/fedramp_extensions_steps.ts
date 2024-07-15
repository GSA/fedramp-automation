import { Given, Then, When } from '@cucumber/cucumber';
import yaml from 'js-yaml'; // Make sure to import js-yaml
import Ajv from 'ajv';
import addFormats from "ajv-formats";
import { expect } from 'chai';
import { existsSync, readFile, readFileSync } from 'fs';
import path, { dirname } from 'path';
import { Log } from 'sarif';
import { fileURLToPath } from 'url';
import { convert } from 'oscal';
import {
  detectOscalDocumentType,
  executeOscalCliCommand,
  installOscalCli,
  isOscalCliInstalled,
  validateWithSarif
} from 'oscal';
import { sarifSchema } from 'oscal/src/schema/sarif.js';
import { parseSarifToErrorStrings, validate, validateDefinition, validateFile } from 'oscal';
import { parseString } from 'xml2js';
import { setDefaultTimeout } from '@cucumber/cucumber';

const DEFAULT_TIMEOUT = 17000;

setDefaultTimeout(DEFAULT_TIMEOUT);


const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

let documentPath: string;
let constraintId: string;
let constraintExists: boolean;
let outputPath: string;
let metaschemaDocumentPath: string;
let metaschemaDocuments:string[];
let documentType: string;
let cliInstalled: boolean;
let executionResult: string;
let executionErrors: string;
let convertResult: string;
let definitionToValidate: string;
let exampleObject: any;
let sarifResult: Log;
let validateResult: { isValid: boolean; errors?: string[] | undefined; };
let conversionResult: string;

const ajv = new Ajv()
addFormats(ajv);



Given('I have an OSCAL document {string}', function (filename: string) {
  documentPath = path.join(__dirname, '..', '..', 'examples', filename);
});

Given('I have an Metaschema extensions document {string}', (filename: string) => {
  metaschemaDocumentPath = path.join(__dirname, '..', '..', 'extensions', filename);
  metaschemaDocuments=[metaschemaDocumentPath];
});
Given('I have a second Metaschema extensions document {string}', (filename: string) => {
  metaschemaDocuments = [metaschemaDocumentPath,path.join(__dirname, '..', '..', 'extensions', filename)];
});
When('I detect the document type', async function () {
  [documentType] = await detectOscalDocumentType(documentPath);
});

Then('the document type should be {string}', function (expectedType: string) {
  expect(documentType).to.equal(expectedType);
});

When('I check if OSCAL CLI is installed', async function () {
  cliInstalled = await isOscalCliInstalled();
});

Then('I should receive a boolean result', function () {
  expect(cliInstalled).to.be.a('boolean');
});

Given('OSCAL CLI is not installed', async function () {
  cliInstalled = await isOscalCliInstalled();
});

When('I install OSCAL CLI', async function () {
  if(!cliInstalled){
    await installOscalCli();
  }
});

Then('OSCAL CLI should be installed', async function () {
  cliInstalled = await isOscalCliInstalled();
  expect(cliInstalled).to.be.true;
});

When('I execute the OSCAL CLI command {string} on the document', async function (command: string) {
  const [cmd, ...args] = command.split(' ');
  args.push(documentPath);
  [executionResult,executionErrors] = await executeOscalCliCommand(cmd, args);
});
When('I validate with sarif output on the document', async function () {
  sarifResult = await validateWithSarif([documentPath]);
  validateResult = parseSarifToErrorStrings(sarifResult)
});

Then('I should receive the execution result', function () {
  expect(executionResult).to.exist;
});

When('I convert the document to JSON', async function () {
  outputPath = path.join(__dirname, '..', '..', 'examples', 'ssp.json');
  [conversionResult,executionErrors] = await executeOscalCliCommand('convert', [documentPath,'--to=json', outputPath, '--overwrite']);
  executionErrors&&console.error(executionErrors);
});

Then('I should receive the conversion result', function () {
  expect(existsSync(outputPath)).to.be.true;
});


When('I validate with metaschema extensions and sarif output on the document', async () => {
  sarifResult = await validateWithSarif([documentPath,"-c",metaschemaDocumentPath]);
})

Then('I should receive the sarif output', () => {
 const isValid=ajv.validate(sarifSchema,sarifResult)
  const errors = ajv.errors
  errors&&console.error(errors);
  expect(sarifResult.runs).to.exist;
  expect(sarifResult.version).to.exist;
})

Then('I should receive a validation object', () => {
expect(typeof validateResult.isValid==='boolean');
})

When('I validate with imported validate function', async () => {
  try {
    validateResult=await validateFile(documentPath,{useAjv:false,extensions:metaschemaDocuments})    
  } catch (error) {
    console.error(error);
  }
})

Then('I should receive a valid json object', async () => {
  const document=JSON.parse(readFileSync(outputPath).toString());
  const {isValid,errors}=await validate( document)
  errors&& console.error(errors);
 expect(isValid).to.be.true;
})

When('I convert it with imported convert function', async () => {
  await convert(documentPath,outputPath);
})

Given('I want an OSCAL document {string}', (filename: string) => {
  outputPath = path.join(__dirname, '..', '..', 'examples', filename);
})

Then('the validation result should be valid', () => {
  console.error(validateResult.errors);
  expect(validateResult.isValid).to.be.true;
})

When('I validate with imported validateDefinition function', () => {
  validateResult=validateDefinition(definitionToValidate as any,exampleObject)
})


Given('I have an example OSCAL definition {string}', (s: string) => {
definitionToValidate = s;
})

Given('I have an example OSCAL object {string}', (s: string) => {
if (definitionToValidate==="control"){
  exampleObject={
    id:"psych_101",
    title:"test",
    class:"awsoem",
  }

}
})

When('I convert the document to YAML', async () => {
  outputPath = path.join(__dirname, '..', '..', 'examples', 'ssp.yaml');
  [conversionResult,executionErrors] = await executeOscalCliCommand('convert', [documentPath,'--to=yaml', outputPath, '--overwrite']);
})

When('I look for a constraint by ID {string}', function (id:string) {
  // Write code here that turns the phrase above into concrete actions
  constraintId = id;
});

Then('I should Find a node in the constraint file', function (done) {
  const xmlContent = readFileSync(metaschemaDocumentPath, 'utf-8');
  
  parseString(xmlContent, (err, result) => {
    if (err) {
      done(err);
      return;
    }

    function searchForConstraint(obj: any): boolean {
      if (typeof obj !== 'object') return false;
      
      if (Array.isArray(obj)) {
        return obj.some(item => searchForConstraint(item));
      }
      
      if (obj.$ && obj.$.id === constraintId) {
        return true;
      }
      
      return Object.values(obj).some(value => searchForConstraint(value));
    }

    constraintExists = searchForConstraint(result);
    expect(constraintExists).to.be.true;
    done();
  });
});

Then('we should have errors in the sarif output', () => {
  expect(validateResult.errors).length.to.be.greaterThan(0);
})

Then('conversion result is a yaml', async () => {
  const fileContent = await readFileSync(outputPath).toString();
  let isValidYaml = false;
  
  try {
    yaml.load(fileContent);
    isValidYaml = true;
  } catch (error) {
    isValidYaml = false;
  }

  expect(isValidYaml).to.be.true;
});

Then('conversion result is a json', async () => {
  const fileContent = readFileSync(outputPath).toString();
  let isValidJson = false;
  
  try {
    JSON.parse(fileContent);
    isValidJson = true;
  } catch (error) {
    isValidJson = false;
  }

  expect(isValidJson).to.be.true;
});
