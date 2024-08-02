import { Given, Then, When, setDefaultTimeout } from "@cucumber/cucumber";
import { expect } from "chai";
import { readFileSync, readdirSync, unlinkSync, writeFileSync } from "fs";
import { load } from "js-yaml";
import { executeOscalCliCommand, validateFile, validateWithSarif } from "oscal";
import { dirname, join } from "path";
import { Exception, Log, Result } from "sarif";
import { fileURLToPath } from "url";
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

// Split the content on the DYNAMIC_EXAMPLES marker
const [beforeMarker, afterMarker] = featureContent.split("# DYNAMIC_EXAMPLES");

// Generate the examples
const constraintTests = getConstraintTests();

// Combine the parts with the generated examples
const newContent = beforeMarker + "# DYNAMIC_EXAMPLES\n" + constraintTests;

// Write the new content back to the file
writeFileSync(featureFile, newContent);

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

Given("I have Metaschema extensions documents", function (dataTable) {
  metaschemaDocuments = dataTable.hashes().map((row) => row.filename);
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
        "./src/validations/constraints/" + x,
      ]),
    ]);
    if(typeof sarifResponse.runs[0].tool.driver.rules==='undefined'){
      const [result,error]=await executeOscalCliCommand("validate",[processedContentPath,...metaschemaDocuments.flatMap((x) => [
        "-c",
        "./src/validations/constraints/" + x,
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
        continue;
      }

      const { id } = constraintMatch;
      const constraintResult = results.find((x) => x.ruleId === id);
      
      if (!constraintResult) {
        errors.push(`No result found for constraint: ${constraint_id}. The constraint may not be applicable to this content.`);
        continue;
      }

      console.log(`Received: ${constraintResult.kind}`);

      const constraintMatchesExpectation = constraintResult.kind === expectedResult;
      constraintResults.push(constraintMatchesExpectation ? "pass" : "fail");
      
      if (!constraintMatchesExpectation) {
        errors.push(
          `${constraint_id}: Expected ${expectedResult}, received ${constraintResult.kind}`
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
    }

    if (errors.length > 0) {
      return {
        status: "fail",
        errorMessage: "Test failed with the following errors:\n" + errors.join("\n")
      };
    }
    return { status: "pass", errorMessage: "" };
  } catch (error) {
    console.error("Error in checkConstraints:", error);
    return {
      status: "fail",
      errorMessage: `Error processing constraints: ${error.message}`
    };
  }
}