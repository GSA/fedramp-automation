const fs = require('fs');
const path = require('path');
const xml2js = require('xml2js');
const yaml = require('js-yaml');
const {execSync} = require('child_process');
const inquirer = require('inquirer');
const prompt = inquirer.createPromptModule();
const constraintsDir = path.join(__dirname, '../../src', 'validations', 'constraints');
const testDir = path.join(__dirname, '../../src', 'validations', 'constraints', 'unit-tests');
const ignoreDocument = "oscal-external-constraints.xml";
const featureFile = path.join(__dirname,"../../features/", 'fedramp_extensions.feature');

async function parseXml(filePath) {
    const fileContent = fs.readFileSync(filePath, 'utf8');
    return new Promise((resolve, reject) => {
        xml2js.parseString(fileContent, (err, result) => {
            if (err) reject(err);
            else resolve(result);
        });
    });
}

function extractConstraints(xmlObject) {
    const constraints = [];

    function searchForConstraints(obj) {
        if (obj && typeof obj === 'object') {
            if (Array.isArray(obj)) {
                obj.forEach(searchForConstraints);
            } else {
                if (obj.constraints && Array.isArray(obj.constraints)) {
                    obj.constraints.forEach(constraint => {
                        Object.values(constraint).forEach(value => {
                            if (Array.isArray(value)) {
                                value.forEach(item => {
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

async function getAllConstraints() {
    const files = fs.readdirSync(constraintsDir).filter(file => file.endsWith('.xml') && file !== ignoreDocument);
    let allConstraints = [];

    for (const file of files) {
        const filePath = path.join(constraintsDir, file);
        const xmlObject = await parseXml(filePath);
        const constraints = extractConstraints(xmlObject);
        allConstraints = [...allConstraints, ...constraints];
    }

    return [...new Set(allConstraints)].sort();
}


function analyzeTestFiles() {
    const testFiles = fs.readdirSync(testDir).filter(file => file.endsWith('.yaml') || file.endsWith('.yml'));
    const testResults = {};

    for (const file of testFiles) {
        const filePath = path.join(testDir, file);
        const fileContent = fs.readFileSync(filePath, 'utf8');
        const testCase = yaml.load(fileContent);

        if (testCase['test-case'] && testCase['test-case'].expectations) {
            for (const expectation of testCase['test-case'].expectations) {
                const constraintId = expectation['constraint-id'];
                const result = expectation.result;

                if (!testResults[constraintId]) {
                    testResults[constraintId] = { pass: null, fail: null };
                }

                if (result === 'pass' || file.toUpperCase().includes('PASS')) {
                    testResults[constraintId].pass = file;
                    testResults[constraintId].pass_file = filePath.split("/").pop();                
                } else if (result === 'fail' || file.toUpperCase().includes('FAIL')) {
                    testResults[constraintId].fail = file;
                    testResults[constraintId].fail_file = filePath.split("/").pop();                
                }
            }
        }
    }

    return testResults;
}

async function scaffoldTest(constraintId) {
    const { confirm } = await prompt([
        {
            type: 'confirm',
            name: 'confirm',
            message: `Do you want to scaffold a test for ${constraintId}?`,
            default: false
        }
    ]);
    const { model } = await prompt([
        {
            type: 'string',
            name: 'model',
            message: `what is the constraint targeting?`,
            default: "ssp"
        }
    ]);


    if (!confirm) {
        console.log(`Skipping test scaffolding for ${constraintId}`);
        return;
    }

    const positivetestCase = {
        'test-case': {
            name: `Positive Test for ${constraintId}`,
            description: `This test case validates the behavior of constraint ${constraintId}`,
            content:"../content/"+ model+'-all-VALID.xml',  
            expectations: [
                {
                    'constraint-id': constraintId,
                    result: 'pass'
                }
            ]
        }
    };
    const negativetestCase = {
        'test-case': {
            name: `Negative Test for ${constraintId}`,
            description: `This test case validates the behavior of constraint ${constraintId}`,
            content:"../content/"+ model+"-all-INVALID.xml",  
            expectations: [
                {
                    'constraint-id': constraintId,
                    result: 'fail'
                }
            ]
        }
    };

    const positiveYamlContent = yaml.dump(positivetestCase);
    const negativeYamlContent = yaml.dump(negativetestCase);
    const fileNamePASS = `${constraintId.toLowerCase()}-PASS.yaml`;
    const fileNameFAIL = `${constraintId.toLowerCase()}-FAIL.yaml`;
    const positiveFilePath = path.join(testDir, fileNamePASS);
    const negativefilePath = path.join(testDir,fileNameFAIL)
    fs.writeFileSync(positiveFilePath, positiveYamlContent, 'utf8');
    fs.writeFileSync(negativefilePath, negativeYamlContent, 'utf8');
    console.log(`Scaffolded test for ${constraintId} at ${positiveFilePath}`);
    console.log(`Scaffolded test for ${constraintId} at ${negativefilePath}`);
}

async function selectConstraints(allConstraints) {    
    if (process.argv.length > 2) {
        // If a constraint ID is provided as an argument, use it
        return [process.argv[2]];
    }
     const { selectedConstraints } = await prompt([
        {
            type: 'checkbox',
            name: 'selectedConstraints',
            message: 'Select constraints to analyze:',
            choices: allConstraints,
            pageSize: 20
        }
    ]);
    return selectedConstraints;
}





function getScenarioLineNumbers(featureFile, constraintId,tests) {
    const content = fs.readFileSync(featureFile, 'utf8');
    const lines = content.split('\n');
    const scenarioLines = [];
    for (let i = 0; i < lines.length; i++) {
        if (lines[i].includes(`${tests.fail_file}`) || lines[i].includes(`${tests.pass_file}`)) {
            scenarioLines.push(i + 1); // +1 because line numbers start at 1, not 0
        }
    }

    return scenarioLines;
}


function parseFeatureFile(featureFilePath) {
    const content = fs.readFileSync(featureFilePath, 'utf8');
    const lines = content.split('\n');
    const testCases = {};
    let inExamples = false;
    let lineNumber = 0;

    for (const line of lines) {
        lineNumber++;
        if (line.trim() === 'Examples:') {
            inExamples = true;
        } else if (inExamples && line.trim().startsWith('|')) {
            const match = line.match(/\|\s*(.*?)\s*\|/);
            if (match && match[1] !== 'test_file') {
                const yamlFile = match[1].trim();
                testCases[yamlFile] = lineNumber;
            }
        }
    }

    return testCases;
}
async function runCucumberTest(constraintId, testFiles) {
    const passFile = testFiles.pass_file;
    const failFile = testFiles.fail_file;

    if (!passFile || !failFile) {
        console.log(`Skipping Cucumber test for ${constraintId}: Missing ${!passFile ? 'PASS' : 'FAIL'} test file`);
        return false;
    }

    const nodeOptions = '--loader ts-node/esm --no-warnings --experimental-specifier-resolution=node';
    const cucumberCommand = `NODE_OPTIONS="${nodeOptions}" npx cucumber-js`;

    const scenarioLines = getScenarioLineNumbers(featureFile, constraintId,testFiles);

    if (scenarioLines.length === 0) {
        console.error(`No scenarios found for constraintId: ${constraintId}`);
        console.error(`execute npm run test and try again if you haven't already`);        
        return false;
    }

    try {
        for (const line of scenarioLines) {
            const command = `${cucumberCommand} ${featureFile}:${line}`;
            execSync(command, { stdio: 'inherit' });
        }
        console.log(`Cucumber tests for ${constraintId} passed successfully.`);
        return true;
    } catch (error) {
        console.error(`Cucumber test for ${constraintId} failed:`, error.message);
        return false;
    }
}



async function main() {
    const allConstraints = await getAllConstraints();
    console.log(`Found ${allConstraints.length} constraints.`);

    const selectedConstraints = await selectConstraints(allConstraints);
    console.log(`Selected ${selectedConstraints.length} constraints for analysis.`);

    const testResults = analyzeTestFiles();

    console.log('\nConstraint Analysis and Test Execution:');
    for (const constraintId of selectedConstraints) {
        const testCoverage = testResults[constraintId];
        
        if (!testCoverage) {
            console.log(`${constraintId}: No tests found`);
            const scaffold = await scaffoldTest(constraintId);
            if (scaffold) {
                const passed = await runCucumberTest(constraintId, { pass_file: `${constraintId}-PASS.yaml`, fail_file: `${constraintId}-FAIL.yaml` });
                console.log(`${constraintId}: Test ${passed ? 'passed' : 'failed'}`);
            }
        } else if (!testCoverage.pass) {
            console.log(`${constraintId}: Missing positive test`);
        } else if (!testCoverage.fail) {
            console.log(`${constraintId}: Missing negative test`);
        } else {
            console.log(`${constraintId}: Fully covered`);
            const passed = await runCucumberTest(constraintId, testCoverage);
            console.log(`${constraintId}: Test ${passed ? 'passed' : 'failed'}`);
        }
    }
}
main().catch(console.error);