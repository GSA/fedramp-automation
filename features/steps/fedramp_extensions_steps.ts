import { Given, Then, When, setDefaultTimeout } from "@cucumber/cucumber";
import { expect } from "chai";
import { readFileSync, readdirSync, writeFileSync, unlinkSync } from "fs";
import { load } from "js-yaml";
import { executeOscalCliCommand, validateFileSarif } from "oscal";
import { validateWithSarif } from "oscal/dist/commands";
import { dirname, join } from "path";
import { fileURLToPath } from "url";
const DEFAULT_TIMEOUT = 17000;

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
  expect(result).to.equal("pass");
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
  const sarifResponse = await validateWithSarif([
    processedContentPath,
    "--sarif-include-pass",
    ...metaschemaDocuments.flatMap((x) => [
      "-c",
      "./src/validations/constraints/" + x,
    ]),
  ]);
  if (processedContentPath != contentPath) {
    unlinkSync(processedContentPath);
  }
  return checkConstraints(sarifResponse, testCase.expectations);
}

async function checkConstraints(
  sarifOutput: Log,
  constraints: [{ "constraint-id": string; result: "pass" | "fail" }],
) {
  const { runs } = sarifOutput;
  const [run] = runs;
  const { results, tool } = run;
  if (!results) {
    return "no results in sarif output";
  }
  const { driver } = tool;
  if (runs.length != 1) {
    throw "no runs found in sarif";
  }
  const { rules } = runs[0].tool.driver;
  let constraintResults = [];
  for (const expectation of constraints) {
    const constraint_id = expectation["constraint-id"];
    const expectedResult = expectation.result;
    const constraintMatch = rules.find((x) => x.name === constraint_id);
    const { id } = constraintMatch || { id: undefined };
    if (!id) {
      writeFileSync("./"+constraint_id+".sarif.json", JSON.stringify(sarifOutput));
      console.error("Sarif results written to file: ./"+constraint_id+".sarif.json");
      throw constraint_id + " rule not defined in sarif results";
    }
    const constraintResult = results.find((x) => x.ruleId === id);

    const constraintMatchesExpectation = constraintResult.kind == expectedResult;
    constraintResults.push(constraintResult ? "pass" : "fail");
    if (!constraintMatchesExpectation) {
      console.error(
        constraint_id +
          " Did not match expected " +
          result +
          " recieved " +
          constraintResult.kind,
      );
    }
  }
  if (constraintResults.includes("fail")) {
    return "fail";
  }
  return "pass";
}

// We don't need the Before hook anymore, so it's removed
