import fs from 'fs';
import path from 'path';
import xml2js from 'xml2js';
import yaml from 'js-yaml';
import {JSDOM} from "jsdom"
import { execSync } from 'child_process';
import inquirer from 'inquirer';
import xmlFormatter from 'xml-formatter';

const prompt = inquirer.createPromptModule();

const __dirname = new URL('.', import.meta.url).pathname;

const constraintsDir = path.join(__dirname, '../../src', 'validations', 'constraints');
const testDir = path.join(__dirname, '../../src', 'validations', 'constraints', 'unit-tests');
const featureFile = path.join(__dirname,"../../features/", 'fedramp_extensions.feature');


const ignoreDocument = "oscal-external-constraints.xml";

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
    let allContext = {};

    for (const file of files) {
        const filePath = path.join(constraintsDir, file);
        const xmlContent = fs.readFileSync(filePath, 'utf8');
        const dom = new JSDOM(xmlContent, { contentType: "text/xml" });
        const document = dom.window.document;

        // Select all elements with an 'id' attribute
        const constraintElements = document.querySelectorAll('[id]');
        
        constraintElements.forEach(constraintElement => {
            const id = constraintElement.getAttribute('id');
            
            // Find the parent 'context' element
            let contextElement = constraintElement.closest('context');
            
            if (contextElement) {
                // Find the 'metapath' element within the context
                const metapathElement = contextElement.querySelector('metapath');
                const context = metapathElement ? metapathElement.getAttribute('target') : '';

                allConstraints.push(id);
                allContext[id] = context;

                console.log(`Constraint ${id} context: ${context}`); // Debug log
            } else {
                console.log(`Warning: No context found for constraint ${id}`);
            }
        });
    }

    return { constraints: [...new Set(allConstraints)].sort(), allContext };
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
                } else if (result === 'fail' ||result ==='informational'|| file.toUpperCase().includes('FAIL')) {
                    testResults[constraintId].fail = file;
                    testResults[constraintId].fail_file = filePath.split("/").pop();                
                }
            }
        }
    }

    return testResults;
}



async function scaffoldTest(constraintId,context) {
    const { confirm } = await prompt([
        {
            type: 'confirm',
            name: 'confirm',
            message: `Do you want to scaffold a test for ${constraintId}?`,
            default: true
        }
    ]);

    if (!confirm) {
        console.log(`Skipping test scaffolding for ${constraintId}`);
        return;
    }

    const { model } = await prompt([
        {
            type: 'string',
            name: 'model',
            message: `What is the constraint targeting?`,
            default: "ssp"
        }
    ]);

    console.log(`Context for ${constraintId}:\n${context}`);

    const { useTemplate } = await prompt([
        {
            type: 'list',
            name: 'useTemplate',
            message: `Choose the content for the negative test:`,
            choices: [
                { name: `Create new ${constraintId}-INVALID.xml`, value: 'new' },
                { name: 'Select an existing content file to copy', value: 'select' }
            ]
        }
    ]);

    let invalidContent;
    if (useTemplate === 'new') {
        const templatePath = path.join(__dirname, '..', '..', 'src', 'validations', 'constraints', 'content', `${model}-all-VALID.xml`);
        const newInvalidPath = path.join(__dirname, '..', '..', 'src', 'validations', 'constraints', 'content', `${model}-${constraintId}-INVALID.xml`);
        
        try {
            // Read the template XML
            const templateXml = fs.readFileSync(templatePath, 'utf8');
            const dom = new JSDOM(templateXml, { contentType: "text/xml" });
            const document = dom.window.document;

            console.log(`Context for ${constraintId}: ${context}`); // Debug log

            if (!context || typeof context !== 'string' || context.trim() === '') {
                throw new Error('Invalid or empty context');
            }

            // Prepare the XPath
            const contextParts = context.split('/').filter(part => part !== '');
            let xpathExpression = '//' + contextParts[contextParts.length - 1];

            console.log(`Attempting to evaluate XPath: ${xpathExpression}`);

            // Use XPath to select the nodes specified by the context
            const xpathResult = document.evaluate(
                xpathExpression, 
                document, 
                null, 
                dom.window.XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, 
                null
            );

            if (xpathResult.snapshotLength > 0) {
                // Create a new document
                const newDoc = document.implementation.createDocument(null, null, null);
                
                // Function to recursively clone nodes and their ancestors while preserving namespaces
                function cloneWithAncestors(node, newParent) {
                    if (node.parentNode && node.parentNode.nodeType === dom.window.Node.ELEMENT_NODE) {
                        // Clone the parent node, ensuring we carry over the namespace
                        const parentClone = newDoc.createElementNS(
                            node.parentNode.namespaceURI, 
                            node.parentNode.nodeName
                        );
                        
                        // Clone the attributes (except schema declaration)
                        Array.from(node.parentNode.attributes).forEach(attr => {
                            if (!attr.name.includes('schemaLocation')) {
                                parentClone.setAttributeNS(attr.namespaceURI, attr.name, attr.value);
                            }
                        });

                        // Recursively clone its ancestors
                        cloneWithAncestors(node.parentNode, parentClone);
                        parentClone.appendChild(newParent);
                    } else {
                        newDoc.appendChild(newParent);
                    }
                }

                // Clone only the first matching node and its ancestors
                const relevantNode = xpathResult.snapshotItem(0);
                const relevantClone = newDoc.importNode(relevantNode, true);
                cloneWithAncestors(relevantNode, relevantClone);

                // Serialize the new document
                const serializer = new dom.window.XMLSerializer();
                let filteredXml = serializer.serializeToString(newDoc);

                // Format the XML with indentation
                filteredXml = xmlFormatter(filteredXml, {
                    indentation: '  ', // Two spaces for indentation
                    collapseContent: true,
                    lineSeparator: '\n'
                });
                // Write the new invalid XML file
                fs.writeFileSync(newInvalidPath, filteredXml, 'utf8');
                console.log(`Created new ${model}-${constraintId}-INVALID.xml file`);
                invalidContent = `../content/${model}-${constraintId}-INVALID.xml`;
            } else {
                throw new Error('Could not find the specified context in the template.');
            }
        } catch (error) {
            console.log(`Warning: ${error.message}. Using the full template.`);
            console.log(`Error details:`, error);
            fs.copyFileSync(templatePath, newInvalidPath);
            invalidContent = `../content/${model}-${constraintId}-INVALID.xml`;
        }
    } else {
        const contentDir = path.join(__dirname, '..', '..', 'src', 'validations', 'constraints', 'content');
        const contentFiles = fs.readdirSync(contentDir).filter(file => file.endsWith('.xml'));
        const { selectedContent } = await prompt([
            {
                type: 'list',
                name: 'selectedContent',
                message: 'Select an existing content file to copy:',
                choices: contentFiles
            }
        ]);

        // Create a new invalid XML file based on the selected content
        const selectedContentPath = path.join(contentDir, selectedContent);
        const newInvalidPath = path.join(contentDir, `${model}-${constraintId}-INVALID.xml`);
        
        // Copy the selected content to the new file
        fs.copyFileSync(selectedContentPath, newInvalidPath);
        console.log(`Created new ${model}-${constraintId}-INVALID.xml file based on ${selectedContent}`);
        
        invalidContent = `../content/${model}-${constraintId}-INVALID.xml`;
    }

    const positivetestCase = {
        'test-case': {
            name: `Positive Test for ${constraintId}`,
            description: `This test case validates the behavior of constraint ${constraintId}`,
            content: `../content/${model}-all-VALID.xml`,  
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
            content: invalidContent,  
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
    const negativefilePath = path.join(testDir, fileNameFAIL);
    fs.writeFileSync(positiveFilePath, positiveYamlContent, 'utf8');
    fs.writeFileSync(negativefilePath, negativeYamlContent, 'utf8');
    console.log(`Scaffolded test for ${constraintId} at ${positiveFilePath}`);
    console.log(`Scaffolded test for ${constraintId} at ${negativefilePath}`);

    return true;
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

    let scenarioLines = getScenarioLineNumbers(featureFile, constraintId,testFiles);

    if (scenarioLines.length === 0) {
        console.error(`No scenarios found for constraintId: ${constraintId}`);
        execSync("npm run test:coverage",{stdio:'ignore'});
        scenarioLines = getScenarioLineNumbers(featureFile, constraintId,testFiles);
        if(scenarioLines.length===0){
        return false;
        }
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
    const {constraints:allConstraints,allContext} = await getAllConstraints();
    console.log(`Found ${allConstraints.length} constraints.`);
    const selectedConstraints = await selectConstraints(allConstraints);
    console.log(`Selected ${selectedConstraints.length} constraints for analysis.`);

    const testResults = analyzeTestFiles();

    console.log('\nConstraint Analysis and Test Execution:');
    for (const constraintId of selectedConstraints) {
        const testCoverage = testResults[constraintId];
        
        if (!testCoverage) {
            console.log(`${constraintId}: No tests found`);
            var context = allContext[constraintId]
            console.log(`${context}: constraint context`);
            const scaffold = await scaffoldTest(constraintId,context);
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