import { Given, Then, When, setDefaultTimeout } from "@cucumber/cucumber";
import { expect } from "chai";
import { readFileSync, readdirSync, unlinkSync, writeFileSync } from "fs";
import { load } from "js-yaml";
import { executeOscalCliCommand, validateFile, validateWithSarif } from "oscal";
import { dirname, join } from "path";
import { Exception, Log, Result } from "sarif";
import { fileURLToPath } from "url";
import { parseString } from 'xml2js';
import { promisify } from 'util';

const parseXmlString = promisify(parseString);

const DEFAULT_TIMEOUT = 60000;

setDefaultTimeout(DEFAULT_TIMEOUT);

let currentTestCase: {
  name: string;
  description: string;
  content: string;
  pipelines: [];
  expectations: [{ "constraint-id": string; result: string }];
};
let processedContentPath: string;
let metaschemaDocuments: string[] = [];
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const featureFile = join(__dirname, "..", "fedramp_extensions.feature");
let featureContent = readFileSync(featureFile, "utf8");

// Update the feature file content
updateFeatureFile();

async function updateFeatureFile() {
  // Generate the dynamic content
  const dynamicTestCases = getConstraintTests();
  const dynamicConstraintIds = await getConstraintIds();
  console.log(dynamicConstraintIds,"STARTCONSTRAINTS");
  console.log(dynamicConstraintIds,"ENDCONSTRAINTS");
  // Replace the dynamic sections in the feature file
  featureContent = featureContent.replace(
    /#BEGIN_DYNAMIC_TEST_CASES[\s\S]*?#END_DYNAMIC_TEST_CASES/,
    `#BEGIN_DYNAMIC_TEST_CASES\n${dynamicTestCases}\n#END_DYNAMIC_TEST_CASES`
  );

  featureContent = featureContent.replace(
    /#BEGIN_DYNAMIC_CONSTRAINT_IDS[\s\S]*?#END_DYNAMIC_CONSTRAINT_IDS/,
    `#BEGIN_DYNAMIC_CONSTRAINT_IDS\n${dynamicConstraintIds}\n#END_DYNAMIC_CONSTRAINT_IDS`
  );

  // Write the updated content back to the file
  writeFileSync(featureFile, featureContent);
}

function getConstraintTests() {
  const constraintTestDir = join(
    __dirname,
    "..",
    "..",
    "src",
    "validations",
    "constraints",
    "unit-tests",
  );
  const files = readdirSync(constraintTestDir);
  const filteredFiles = files
    .filter((file) => file.endsWith(".yaml") || file.endsWith(".yml"))
    .map((file) => `  | ${file} |`)
    .join("\n");
  console.log("Processing ", filteredFiles);
  return filteredFiles;
}
async function getConstraintIds() {
  const constraintDir = join(
    __dirname,
    "..",
    "..",
    "src",
    "validations",
    "constraints",
  );
  const files = readdirSync(constraintDir);
  const xmlFiles = files.filter((file) => file.endsWith(".xml"));
  let allConstraintIds = [];

  for (const file of xmlFiles) {
    const filePath = join(constraintDir, file);
    const fileContent = readFileSync(filePath, "utf8");
    const result = await parseXmlString(fileContent) as any;
    
    const contexts = result['metaschema-meta-constraints']?.context || [];
    for (const context of contexts) {
      const constraints = context.constraints?.[0] || {};
      for (const constraintType in constraints) {
        if (Array.isArray(constraints[constraintType])) {
          const ids = constraints[constraintType]
            .filter(constraint => constraint.$ && constraint.$.id)
            .map(constraint => constraint.$.id);
          allConstraintIds = [...allConstraintIds, ...ids];
        }
      }
    }
  }

  // Remove duplicates and sort
  allConstraintIds = [...new Set(allConstraintIds)].sort();

  return allConstraintIds.map(id => `  | ${id} |`).join("\n");
}

Given("I have Metaschema extensions documents", function (dataTable) {
  const constraintDir = join(
    __dirname,
    "..",
    "..",
    "src",
    "validations",
    "constraints",
  );
  const files = readdirSync(constraintDir);
  metaschemaDocuments = files
    .filter((file) => file.endsWith(".xml")).filter(x=>!x.startsWith("oscal"))//temporary
    .map((file) => join(constraintDir, file));
});

When("I process the constraint unit test {string}", async function (testFile) {
  const constraintTestDir = join(
    __dirname,
    "..",
    "..",
    "src",
    "validations",
    "constraints",
    "unit-tests",
  );
  const filePath = join(constraintTestDir, testFile);
  const fileContents = readFileSync(filePath, "utf8");
  currentTestCase = load(fileContents) as any;
});

Then("the constraint unit test should pass", async function () {
  const result = await processTestCase(currentTestCase);
  expect(result.status).to.equal("pass", result.errorMessage);
});

async function processTestCase({ "test-case": testCase }: any) {
  console.log(`Processing test case:${testCase.name}`);
  console.log(`Description: ${testCase.description}`);

  // Load the content file
  const contentPath = join(
    __dirname,
    "..",
    "..",
    "src",
    "validations",
    "constraints",
    "content",
    testCase.content,
  );
  console.log(`Loaded content from: ${contentPath}`);
  // Process the pipeline
  processedContentPath = (
    "./" +
    testCase.name.replaceAll(" ", "-") +
    ".xml"
  ).toLowerCase();
  if (testCase.pipeline) {
    for (const step of testCase.pipeline) {
      if (step.action === "resolve-profile") {
        await executeOscalCliCommand("resolve-profile", [
          contentPath,
          processedContentPath,
          "--to=XML",
          "--overwrite",
        ]);
        console.log("Profile resolved");
      }
      // Add other pipeline steps as needed
    }
  } else {
    processedContentPath = contentPath;
  }

  //Validate processed content
  // Check expectations
  try {
    const sarifResponse = await validateWithSarif([
      processedContentPath,
      "--sarif-include-pass",
      ...metaschemaDocuments.flatMap((x) => [
        "-c",
        x,
      ]),
    ]);
    if(typeof sarifResponse.runs[0].tool.driver.rules==='undefined'){
      const [result,error]=await executeOscalCliCommand("validate",[processedContentPath,...metaschemaDocuments.flatMap((x) => [
        "-c",
        x,
      ])]);
      return {status:'fail',errorMessage:error}
    }  
    if (processedContentPath != contentPath) {
      unlinkSync(processedContentPath);
    }
    return checkConstraints(sarifResponse, testCase.expectations);
  } catch(e) {
    return { status: "fail", errorMessage: e.toString() };
  }
}

async function checkConstraints(
  sarifOutput: Log,
  constraints: [{ "constraint-id": string; result: "pass" | "fail" }],
) {
  try {
    const { runs } = sarifOutput;
    if (!runs || runs.length === 0) {
      throw new Error("No runs found in SARIF output");
    }

    const [run] = runs;
    const { results, tool } = run;
    
    if (!results) {
      throw new Error("No results in SARIF output");
    }

    const { driver } = tool;
    const rules = driver.rules;
    
    if (!rules || rules.length === 0) {
      throw new Error("No rules found in SARIF output");
    }

    let constraintResults = [];
    let errors = [];

    // Detailed SARIF output for failed results
    const failedResults = results.filter(result => result.kind === "fail");
    if (failedResults.length > 0) {
      errors.push("Failed SARIF outputs:");
      failedResults.forEach(result => {
        const rule = rules.find(r => r.id === result.ruleId);
        const ruleName = rule ? rule.name : result.ruleId;
        errors.push(`- ${ruleName}:`);
        errors.push(`  Message: ${result.message.text}`);
        if (result.locations && result.locations.length > 0) {
          const location = result.locations[0];
          if (location.physicalLocation && location.physicalLocation.region) {
            const region = location.physicalLocation.region;
            errors.push(`  Location: Line ${region.startLine}, Column ${region.startColumn}`);
          }
        }
        errors.push(''); // Add a blank line for readability
      });
    }

    for (const expectation of constraints) {
      const constraint_id = expectation["constraint-id"];
      const expectedResult = expectation.result;
      console.log(`Checking status of constraint: ${constraint_id} expecting: ${expectedResult}`);
      
      const constraintMatch = rules.find((x) => x.name === constraint_id);
      if (!constraintMatch) {
        errors.push(`Constraint rule not found: ${constraint_id}. The constraint may not be applicable to this content.`);
        throw new Error("Rule not found: "+constraint_id);
      }

      const { id } = constraintMatch;
      const constraintResult = results.find((x) => x.ruleId === id);
      
      if (!constraintResult) {
        errors.push(`Rule exists for constraint: ${constraint_id}, but no result was found. The content may not trigger this constraint.`);
        continue;
      }

      console.log(`Received: ${constraintResult.kind}`);

      const constraintMatchesExpectation = constraintResult.kind === expectedResult;
      constraintResults.push(constraintMatchesExpectation ? "pass" : "fail");
      if (!constraintMatchesExpectation) {
        errors.push(
          `${constraint_id}: Rule exists, but expected ${expectedResult}, received ${constraintResult.kind}. The content may need adjustment to properly test this constraint.`
        );
        errors.push(`  Message: ${constraintResult.message.text}`);
        if (constraintResult.locations && constraintResult.locations.length > 0) {
          const location = constraintResult.locations[0];
          if (location.physicalLocation && location.physicalLocation.region) {
            const region = location.physicalLocation.region;
            errors.push(`  Location: Line ${region.startLine}, Column ${region.startColumn}`);
          }
        }
        errors.push(''); // Add a blank line for readability
      }
      if (!constraintMatchesExpectation) {
        return {
          status: "fail",
          errorMessage: "Test failed with the following errors:\n" + errors.join("\n")
        };
      }  
    }

    return { status: "pass", errorMessage: "" };
  } catch (error:any) {
    console.error("Error in checkConstraints:", error);
    return {
      status: "fail",
      errorMessage: `Error processing constraints: ${error.message}`
    };
  }
}

let yamlTestFiles: string[] = [];
let constraintIds: string[] = [];
let testResults: { [key: string]: { pass: boolean, fail: boolean } } = {};
Given('I have loaded all Metaschema extensions documents', function () {
  const constraintDir = join(__dirname, '..', '..', 'src', 'validations', 'constraints');
  const files = readdirSync(constraintDir);
  metaschemaDocuments = files
    .filter((file) => file.endsWith('.xml'))
    .map((file) => join(constraintDir, file));
  console.log(`Loaded ${metaschemaDocuments.length} Metaschema extension documents`);
});

When('I extract all constraint IDs from the Metaschema extensions', async function () {
  for (const file of metaschemaDocuments) {
    const fileContent = readFileSync(file, 'utf8');
    const result = await parseXmlString(fileContent);
    
    const constraints = extractConstraints(result);
    constraintIds = [...constraintIds, ...constraints];
  }
  constraintIds = [...new Set(constraintIds)].sort();
  console.log(`Extracted ${constraintIds.length} unique constraint IDs`);
});

function extractConstraints(xmlObject: any): string[] {
  const constraints: string[] = [];

  function searchForConstraints(obj: any) {
    if (obj && typeof obj === 'object') {
      if (Array.isArray(obj)) {
        obj.forEach(searchForConstraints);
      } else {
        if (obj.constraints && Array.isArray(obj.constraints)) {
          obj.constraints.forEach((constraint: any) => {
            Object.values(constraint).forEach((value: any) => {
              if (Array.isArray(value)) {
                value.forEach((item: any) => {
                  if (item.$ && item.$.id) {
                    constraints.push(item.$.id);
                  }
                });
              }
            });
          });
        }
        Object.values(obj).forEach(searchForConstraints);
      }
    }
  }

  searchForConstraints(xmlObject);
  return constraints;
}

Then('I should have both FAIL and PASS tests for each constraint ID:', function (dataTable) {
  const reportedConstraints = dataTable.hashes().map(row => row['Constraint ID']);
  
  for (const constraintId of constraintIds) {
    const testCoverage = testResults[constraintId];
    
    if (!testCoverage) {
      console.log(`${constraintId}: No tests found`);
      expect.fail(`Constraint ${constraintId} has no tests`);
    } else if (!testCoverage.pass) {
      console.log(`${constraintId}: Missing positive test`);
      expect.fail(`Constraint ${constraintId} is missing a positive test`);
    } else if (!testCoverage.fail) {
      console.log(`${constraintId}: Missing negative test`);
      expect.fail(`Constraint ${constraintId} is missing a negative test`);
    } else {
      console.log(`${constraintId}: Fully covered`);
    }
    
    expect(reportedConstraints).to.include(constraintId, `Constraint ${constraintId} is not reported in the data table`);
  }
  
  // Check if there are any extra constraints in the data table that are not in our extracted constraints
  for (const reportedConstraint of reportedConstraints) {
    expect(constraintIds).to.include(reportedConstraint, `Reported constraint ${reportedConstraint} is not in the extracted constraints list`);
  }});

Then('I should report the coverage status for each constraint:', function (dataTable) {
  const reportedConstraints = dataTable.hashes().map(row => row['Constraint ID']);
  
  for (const constraintId of constraintIds) {
    console.log(`${constraintId}: Status to be determined`);
    expect(reportedConstraints).to.include(constraintId);
  }
});

Given('I have collected all YAML test files in the test directory', function () {
  const testDir = join(__dirname, '..', '..', 'src', 'validations', 'constraints', 'unit-tests');
  yamlTestFiles = readdirSync(testDir)
    .filter((file) => file.endsWith('.yaml') || file.endsWith('.yml'))
    .map((file) => join(testDir, file));
  console.log(`Collected ${yamlTestFiles.length} YAML test files`);
});

When('I analyze the YAML test files for each constraint ID', function () {
  for (const file of yamlTestFiles) {
    const fileContent = readFileSync(file, 'utf8');
    const testCase = load(fileContent) as any;
    
    if (testCase['test-case'] && testCase['test-case'].expectations) {
      for (const expectation of testCase['test-case'].expectations) {
        const constraintId = expectation['constraint-id'];
        const result = expectation.result;
        
        if (!testResults[constraintId]) {
          testResults[constraintId] = { pass: false, fail: false };
        }
        
        if (result === 'pass') {
          testResults[constraintId].pass = true;
        } else if (result === 'fail') {
          testResults[constraintId].fail = true;
        }
      }
    }
  }
  
  console.log(`Analyzed ${yamlTestFiles.length} YAML test files`);
  console.log('Test results:', testResults);
});

