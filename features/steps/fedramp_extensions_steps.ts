import { Given, Then, When, setDefaultTimeout } from "@cucumber/cucumber";
import { expect } from "chai";
import { readFileSync, readdirSync, writeFileSync } from 'fs';
import { load } from 'js-yaml';
import { executeOscalCliCommand } from "oscal";
import { dirname, join } from 'path';
import { fileURLToPath } from 'url';
const DEFAULT_TIMEOUT = 17000;

setDefaultTimeout(DEFAULT_TIMEOUT);


let currentTestCase:{name:string,description:string,content:string,pipelines:[],expectations:[]};
let processedContentPath:string;
let metaschemaDocuments:string[] = [];
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const featureFile = join(__dirname, '..', 'fedramp_extensions.feature');
let featureContent = readFileSync(featureFile, 'utf8');

// Split the content on the DYNAMIC_EXAMPLES marker
const [beforeMarker, afterMarker] = featureContent.split('# DYNAMIC_EXAMPLES');

// Generate the examples
const constraintTests = getConstraintTests();

// Combine the parts with the generated examples
const newContent = beforeMarker +'# DYNAMIC_EXAMPLES\n'+ constraintTests ;

// Write the new content back to the file
writeFileSync(featureFile, newContent);

function getConstraintTests() {
  const constraintTestDir = join(__dirname, '..', '..', 'src', 'validations', 'constraints', 'unit-tests');
  const files = readdirSync(constraintTestDir);
  console.error("Files found:", files);
  return files
    .filter(file => file.endsWith('.yaml') || file.endsWith('.yml'))
    .map(file => `  | ${file} |`)
    .join('\n');
}

Given('I have Metaschema extensions documents', function (dataTable) {
  metaschemaDocuments = dataTable.hashes().map(row => row.filename);
});

When('I process the constraint unit test {string}', async function (testFile) {
  const constraintTestDir = join(__dirname, '..', '..', 'src', 'validations', 'constraints', 'unit-tests');
  const filePath = join(constraintTestDir, testFile);
  const fileContents = readFileSync(filePath, 'utf8');
  currentTestCase = load(fileContents) as any;
});

Then('the constraint unit test should pass', async function () {
  const result = await processTestCase(currentTestCase);
  expect(result).to.equal('pass');
});

async function processTestCase({"test-case":testCase}:any) {
  console.log(`Processing test case:${testCase.name}`);
  console.log(`Description: ${testCase.description}`);

  // Load the content file
  const contentPath = join(__dirname, '..', '..','src','validations','constraints','content', testCase.content);
  const content = readFileSync(contentPath, 'utf8');
  console.log(`Loaded content from: ${contentPath}`);
  // Process the pipeline
  let processedContent = content;
  processedContentPath ="./"+testCase.name.replaceAll(' ','-')+'.xml'.toLowerCase();
  for (const step of testCase.pipeline) {
    if (step.action === 'resolve-profile') {
    await executeOscalCliCommand('resolve-profile',[contentPath,processedContentPath,'--to=XML','--overwrite']);
      console.log('Profile resolved');
    }
    // Add other pipeline steps as needed
  }
  //Validate processed content
  // Check expectations
  const result = Object.entries(testCase.expectations)
  .map(([id, expectation]) => {
    return checkConstraint((expectation as any).result, id);
  })
  .reduce((acc:any, current:any) => acc && current, true);

return result?'pass' : 'fail';
}

async function checkConstraint(expectation:'pass'|'fail', constraintId) {
  // Implement constraint checking logic
  // This is a placeholder - replace with actual implementation
  const [commandResult,errors]=await executeOscalCliCommand("validate",[processedContentPath,...metaschemaDocuments.flatMap(x=>['-c',"./src/validations/constraints/"+x])])
  console.error(errors);
  console.log(commandResult);
  const validationResult = commandResult.includes("is valid")?'pass':'fail';
  return validationResult==expectation?"pass":'fail'
}

// We don't need the Before hook anymore, so it's removed