import { Given, Then, When, setDefaultTimeout } from "@cucumber/cucumber";
import { expect } from "chai";
import {
  readFileSync,
  readdirSync,
  unlinkSync,
  writeFileSync,
  mkdirSync,
  existsSync,
} from "fs";
import { load } from "js-yaml";
import { executeOscalCliCommand, validateFile, validateWithSarif } from "oscal";
import { dirname, join,parse } from "path";
import { Exception, Log, Result } from "sarif";
import { fileURLToPath } from "url";
import { parseString } from "xml2js";
import { promisify } from "util";

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
let currentTestCaseFileName:string;
let processedContentPath: string;
let ignoreDocument: string = "oscal-external-constraints.xml";
let metaschemaDocuments: string[] = [];
const validationCache = new Map<string, Log>();


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
  const dynamicConstraintFiles = getConstraintFiles();

  // Replace the dynamic sections in the feature file
  featureContent = featureContent.replace(
    /#BEGIN_DYNAMIC_TEST_CASES[\s\S]*?#END_DYNAMIC_TEST_CASES/,
    `#BEGIN_DYNAMIC_TEST_CASES\n${dynamicTestCases}\n#END_DYNAMIC_TEST_CASES`
  );

  featureContent = featureContent.replace(
    /#BEGIN_DYNAMIC_CONSTRAINT_IDS[\s\S]*?#END_DYNAMIC_CONSTRAINT_IDS/,
    `#BEGIN_DYNAMIC_CONSTRAINT_IDS\n${dynamicConstraintIds}\n#END_DYNAMIC_CONSTRAINT_IDS`
  );

  featureContent = featureContent.replace(
    /#BEGIN_DYNAMIC_CONSTRAINT_FILES[\s\S]*?#END_DYNAMIC_CONSTRAINT_FILES/,
    `#BEGIN_DYNAMIC_CONSTRAINT_FILES\n${dynamicConstraintFiles}\n#END_DYNAMIC_CONSTRAINT_FILES`
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
    "unit-tests"
  );
  const files = readdirSync(constraintTestDir);
  const filteredFiles = files
    .filter((file) => file.endsWith(".yaml") || file.endsWith(".yml"))
    .map((file) => `  | ${file} |`)
    .join("\n");
  return filteredFiles;
}
async function getConstraintIds() {
  const constraintDir = join(
    __dirname,
    "..",
    "..",
    "src",
    "validations",
    "constraints"
  );
  const files = readdirSync(constraintDir);
  const xmlFiles = files
    .filter((file) => file.endsWith(".xml"))
    .filter((file) => !file.endsWith(ignoreDocument));
  let allConstraintIds = [];

  for (const file of xmlFiles) {
    const filePath = join(constraintDir, file);
    const fileContent = readFileSync(filePath, "utf8");
    const result = (await parseXmlString(fileContent)) as any;
    const fileConstraints=extractConstraints(result)
    allConstraintIds=[...allConstraintIds,...fileConstraints];
  }
  // Remove duplicates and sort
  allConstraintIds = [...new Set(allConstraintIds)].sort();

  return allConstraintIds.map((id) => `  | ${id} |`).join("\n");
}

function getConstraintFiles() {
  const constraintDir = join(
    __dirname,
    "..",
    "..",
    "src",
    "validations",
    "constraints"
  );
  const files = readdirSync(constraintDir);
  const xmlFiles = files
    .filter((file) => file.endsWith(".xml"))
    .map((file) => `  | ${file} |`)
    .join("\n");
  return xmlFiles;
}

Given("I have Metaschema extensions documents", function (dataTable) {
  const constraintDir = join(
    __dirname,
    "..",
    "..",
    "src",
    "validations",
    "constraints"
  );
  const files = readdirSync(constraintDir);
  metaschemaDocuments = files
    .filter((file) => file.endsWith(".xml"))
    .filter((x) => !x.startsWith("oscal")) //temporary
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
    "unit-tests"
  );
  const filePath = join(constraintTestDir, testFile);
  currentTestCaseFileName = testFile;
  const fileContents = readFileSync(filePath, "utf8");
  currentTestCase = load(fileContents) as any;
});

Then("the constraint unit test should pass", async function () {
  const result = await processTestCase(currentTestCase);
  const testType = currentTestCaseFileName.includes("FAIL") ? "Negative" : "Positive";
  
  const errorMessage = result.errorMessage 
    ? `${testType} test failed: ${result.errorMessage}`
    : `${testType} test failed without a specific error message`;

  expect(result.status).to.equal("pass", errorMessage);
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
    testCase.content
  );
  console.log(`Loaded content from: ${contentPath}`);
  const cacheKey = (typeof testCase.pipeline === 'undefined' ? "" : "resolved-") + parse(contentPath).name;


  // Process the pipeline
  processedContentPath = join(
    ".",
    `${testCase.name.replace(/\s+/g, "-").toLowerCase()}.xml`
  );
  
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
    let sarifResponse;
    
    if (validationCache.has(cacheKey)) {
      console.log("Using cached validation result from "+cacheKey);
      sarifResponse = validationCache.get(cacheKey)!;
    }else{
      let args = [];
      if(currentTestCaseFileName.includes("FAIL")){
        args.push("--disable-schema-validation")
      }
    sarifResponse = await validateWithSarif([
      processedContentPath,
      ...args,
      ...metaschemaDocuments.flatMap((x) => ["-c", x]),
    ]);
    validationCache.set(cacheKey,sarifResponse);
  }
  if (typeof sarifResponse.runs[0].tool.driver.rules === "undefined") {
      const [result, error] = await executeOscalCliCommand("validate", [
        processedContentPath,
        ...metaschemaDocuments.flatMap((x) => ["-c", x]),
      ]);
      return { status: "fail", errorMessage: error };
    }
    if (processedContentPath != contentPath) {
      unlinkSync(processedContentPath);
    }
    const sarifDir = join(__dirname, "..", "..", "sarif");
    if (!existsSync(sarifDir)) {
      mkdirSync(sarifDir, { recursive: true });
    }
    writeFileSync(
      join(
        __dirname,
        "../../sarif/",
        cacheKey.toString()+".sarif"
      ),
      JSON.stringify(sarifResponse, null,"\t")
    );
    return checkConstraints(sarifResponse, testCase.expectations);
  } catch (e) {
    return { status: "fail", errorMessage: e.toString() };
  }
}

async function checkConstraints(
  sarifOutput: Log,
  constraints: Array<{
    "constraint-id": string;
    result: "pass" | "fail" | undefined;
    pass_count?: { type: "exact" | "minimum" | "maximum"; value: number };
    fail_count?: { type: "exact" | "minimum" | "maximum"; value: number };
  }>
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

    let errors = [];

    for (const expectation of constraints) {
      const constraint_id = expectation["constraint-id"];
      const expectedResult = expectation.result;
      console.log(
        `Checking status of constraint: ${constraint_id} expecting: ${
          expectedResult || "mixed"
        }`
      );

      const constraintResults = results.filter(
        (x) => x.ruleId === constraint_id
      );
      if (constraintResults.length === 0) {
        errors.push(
          `Constraint rule not found: ${constraint_id}. The constraint may not be applicable to this content.`
        );
        continue;
      }

      const kinds = constraintResults.map((c) => {
        if(c.level==='warning'||c.kind==='informational'){
          return 'fail'
        }else{
          return c.kind
      }});
      const passCount = kinds.filter((k) => k === "pass").length;
      const failCount = kinds.filter((k) => k === "fail").length;
      const warnCount = constraintResults.filter((k) => k.level === "warning").length;
      const infoCount = constraintResults.filter((k) => k.kind === "informational").length;

      const result = kinds.reduce((acc, kind) => {
        if (acc === "mixed" || (acc !== kind && acc !== "initial")) {
          return "mixed";
        }
        return kind;
      }, "initial");

      console.log(
        `Received: ${constraintResults.length} matching ${result} results (${passCount} pass, ${failCount} fail)`
      );
      if(warnCount>0)
        console.log(
          `Received: ${warnCount} warn)`
        );
        if(infoCount>0)
          console.log(
            `Received: ${infoCount} informational)`
          );
      
      if (result === "initial") {
        throw Error("Unknown Error");
      }

      let constraintMatchesExpectation = false;

      const checkCount = (
        actual: number,
        expected: { type: string; value: number } | undefined
      ) => {
        if (!expected) return true; // If count is not specified, consider it a match
        switch (expected.type) {
          case "exact":
            return actual === expected.value;
          case "minimum":
            return actual >= expected.value;
          case "maximum":
            return actual <= expected.value;
          default:
            return false;
        }
      };

      if (expectedResult === undefined) {
        // For mixed or undefined results, check pass_count and fail_count
        constraintMatchesExpectation =
          checkCount(passCount, expectation.pass_count) &&
          checkCount(failCount, expectation.fail_count);
      } else {
        // For explicit pass/fail expectations
        constraintMatchesExpectation = result === expectedResult;
      }

      if (!constraintMatchesExpectation) {
        if (result === "mixed" || expectedResult === undefined) {
          const passPercentage =
            (100 * (passCount / constraintResults.length)).toFixed(0) +
            "% passing";
          errors.push(
            `${constraint_id}: invalid results received. ${passPercentage}. ` +
              `Expected: pass_count ${JSON.stringify(
                expectation.pass_count||expectedResult==="pass"?"all":"none"
              )}, ` +
              `fail_count ${JSON.stringify(expectation.fail_count||expectedResult==="fail"?"all":"none")}. ` +
              `Actual: ${typeof passCount!=='undefined'?passCount:result==="pass"?"all":"none"} pass, ${failCount?failCount:result==="fail"?"all":"none"} fail.`
          );
        } else {
          errors.push(
            `${constraint_id}: Rule exists, but expected ${expectedResult}, received ${result}. ` +
              `The content may need adjustment to properly test this constraint.`
          );
        }
        errors.push(""); // Add a blank line for readability
      }
    }

    if (errors.length > 0) {
      return {
        status: "fail",
        errorMessage:
          "Test failed with the following errors:\n" + errors.join("\n"),
      };
    }

    return { status: "pass", errorMessage: "" };
  } catch (error: any) {
    console.error("Error in checkConstraints:", error);
    return {
      status: "fail",
      errorMessage: `Error processing constraints: ${error.message}`,
    };
  }
}

let yamlTestFiles: string[] = [];
let constraintIds: string[] = [];
let testResults: { [key: string]: { pass: boolean; fail: boolean } } = {};
Given("I have loaded all Metaschema extensions documents", function () {
  const constraintDir = join(
    __dirname,
    "..",
    "..",
    "src",
    "validations",
    "constraints"
  );
  const files = readdirSync(constraintDir);
  metaschemaDocuments = files
    .filter((file) => file.endsWith(".xml"))
    .map((file) => join(constraintDir, file));
  console.log(
    `Loaded ${metaschemaDocuments.length} Metaschema extension documents`
  );
});

When(
  "I extract all constraint IDs from the Metaschema extensions",
  async function () {
    for (const file of metaschemaDocuments) {
      if (file.endsWith(ignoreDocument)) {
        continue;
      }
      const fileContent = readFileSync(file, "utf8");
      const result = await parseXmlString(fileContent);

      const constraints = extractConstraints(result);
      constraintIds = [...constraintIds, ...constraints];
    }
    constraintIds = [...new Set(constraintIds)].sort();

    console.log(`Extracted ${constraintIds.length} unique constraint IDs`);
    console.log(`Extracted ${constraintIds.length} unique constraint IDs`);
  }
);
function extractConstraints(xmlObject: any): string[] {
  const constraints: string[] = [];

  function searchForConstraints(obj: any) {
    if (obj && typeof obj === "object") {
      if (Array.isArray(obj)) {
        obj.forEach(searchForConstraints);
      } else {
        // Check if the current object has an 'id' field
        if (obj.$ && obj.$.id) {
          constraints.push(obj.$.id);
        }
        // Recursively search all object properties
        Object.values(obj).forEach(searchForConstraints);
      }
    }
  }

  searchForConstraints(xmlObject);
  return constraints;
}

Then(
  "I should have both FAIL and PASS tests for each constraint ID:",
  function (dataTable) {
    const reportedConstraints = dataTable
      .hashes()
      .map((row) => row["Constraint ID"]);

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

      expect(reportedConstraints).to.include(
        constraintId,
        `Constraint ${constraintId} is not reported in the data table`
      );
    }

    // Check if there are any extra constraints in the data table that are not in our extracted constraints
    for (const reportedConstraint of reportedConstraints) {
      expect(constraintIds).to.include(
        reportedConstraint,
        `Reported constraint ${reportedConstraint} is not in the extracted constraints list`
      );
    }
  }
);

Then(
  "I should report the coverage status for each constraint:",
  function (dataTable) {
    const reportedConstraints = dataTable
      .hashes()
      .map((row) => row["Constraint ID"]);

    for (const constraintId of constraintIds) {
      console.log(`${constraintId}: Status to be determined`);
      expect(reportedConstraints).to.include(constraintId);
    }
  }
);

Given(
  "I have collected all YAML test files in the test directory",
  function () {
    const testDir = join(
      __dirname,
      "..",
      "..",
      "src",
      "validations",
      "constraints",
      "unit-tests"
    );
    yamlTestFiles = readdirSync(testDir)
      .filter((file) => file.endsWith(".yaml") || file.endsWith(".yml"))
      .map((file) => join(testDir, file));
    console.log(`Collected ${yamlTestFiles.length} YAML test files`);
  }
);

When("I analyze the YAML test files for each constraint ID", function () {
  for (const file of yamlTestFiles) {
    const fileContent = readFileSync(file, "utf8");
    const testCase = load(fileContent) as any;
    try {
      if (testCase["test-case"] && testCase["test-case"].expectations) {
        for (const expectation of testCase["test-case"].expectations) {
          const constraintId = expectation["constraint-id"];
          const result = expectation.result;
          const pass_count = expectation.pass_count;
          const fail_count = expectation.fail_count;

          if (!testResults[constraintId]) {
            testResults[constraintId] = { pass: false, fail: false };
          }

          function isPositiveTest(
            count: { type: string; value: number } | undefined
          ) {
            return (
              count &&
              (count.type === "minimum" ||
                (count.type === "exact" && count.value > 0))
            );
          }

          function isNegativeTest(
            count: { type: string; value: number } | undefined
          ) {
            return (
              count &&
              (count.type === "maximum" ||
                (count.type === "exact" && count.value === 0))
            );
          }

          if (result === "pass") {
            testResults[constraintId].pass = true;
          } else if (result === "fail") {
            testResults[constraintId].fail = true;
          } else if (result === undefined || result === "mixed") {
            // Handle cases where only pass_count or fail_count is specified
            if (pass_count || fail_count) {
              if (isPositiveTest(pass_count) || isNegativeTest(fail_count)) {
                testResults[constraintId].pass = true;
              }
              if (isNegativeTest(pass_count) || isPositiveTest(fail_count)) {
                testResults[constraintId].fail = true;
              }
            } else {
              // If neither pass_count nor fail_count is specified for a mixed result,
              // consider it as both a positive and negative test
              testResults[constraintId].pass = true;
              testResults[constraintId].fail = true;
            }
          }
        }
      }
    } catch (error) {
      console.error(error);
      console.error("Error running " + file);
      throw error;
    }
  }

  console.log(`Analyzed ${yamlTestFiles.length} YAML test files`);
  console.log("Test results:", testResults);
});

// New step definition for the "Ensuring full test coverage for "<constraint_id>"" scenario
Then("I should have both FAIL and PASS tests for constraint ID {string}", function (constraintId) {
  const testCoverage = testResults[constraintId];

  if (!testCoverage) {
    console.log(`${constraintId}: No tests found`);
    expect.fail(`Constraint ${constraintId} has no tests`);
  } else if (!testCoverage.pass) {
    console.log(`${constraintId}: Missing at least one positive test`);
    expect.fail(`Constraint ${constraintId} is missing a positive test`);
  } else if (!testCoverage.fail) {
    console.log(`${constraintId}: Missing at least one negative test`);
    expect.fail(`Constraint ${constraintId} is missing a negative test`);
  } else {
    console.log(`${constraintId}: Has minimal required coverage`);
  }

  expect(constraintIds).to.include(
    constraintId,
    `Constraint ${constraintId} is not in the extracted constraints list`
  );
});