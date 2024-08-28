# 1. About OSCAL JS
OSCAL JS is a TypeScript implementation of the Cucumber unit-test framework.

This tool enables you to
* Validate your FedRAMP OSCAL artifacts against the FedRAMP OSCAL Metaschema to ensure their compliance with FedRAMP OSCAL requirements, and  
* Create and run your own custom unit tests.

For information about Cucumber, visit [https://github.com/cucumber](https://github.com/cucumber).

For information about TypeScript, visit [https://www.typescriptlang.org](https://www.typescriptlang.org).

# 2. Who should use OSCAL JS
This tool is intended for FedRAMP OSCAL developers, including GSA FedRAMP staff (government and contractors) responsible for implementing and releasing FedRAMP OSCAL baselines, constraints, validation tooling, and documentation.

# 3. Installing OSCAL JS
This section provides instructions for installing and configuring OSCAL JS.

## 3.1. Prerequisites
To use the tool, you need the following programs and packages:
1. *Windows only:* A Linux-like shell (Visual Studio Code, WSL, MSYS2, Cygwin)  
2. JDK  
3. Java included in the shell’s PATH variable  
4. Node.js version 18 or higher
   If you already have Node.js installed, to check its version, run the following command:  
   `$ node --version`
5. `npm`   
6. `make`   
7. Git (any Git interface; for example, git bash, GitHub Desktop, VS Code, Oxygen Editor; for more information about Git, visit [https://git-scm.com/](https://git-scm.com/))

## 3.2. Installing OSCAL JS
To install and configure the tool
1. Open the terminal.  
2. If you do not have the FedRAMP Automation GitHub repository already cloned, to clone it, run the following command:  
   `$ git clone --recurse-submodules https://github.com/GSA/fedramp-automation`  
3. To change to the root directory of the cloned repository, run the following command:  
   `$ cd <cloned-repository-path>`  
4. To switch to the feature/external-constraints branch, run the following command:  
   `$ git checkout feature/external-constraints`  
5. To generate the configuration script, run the following command:  
   `$ make configure`  
6. To generate the unit-test structure, run one of the following commands:  
   * `$ make test`  
   * `$ npm run test`  
7. To verify that all artifacts have been included, run the following command:  
   `$ npm run test:coverage`  
8. To view the generated report, open the following file:  
   `<cloned-repository-path>/reports/constraints.html`

## 3.3. Updating OSCAL JS
To update OSCAL JS
1. Open the terminal.  
2. Run the following command:  
   `$ cd <cloned-repository-path>`  
3. To get the latest tool updates, run the following command:  
   `$ git pull`

# 4. Testing FedRAMP OSCAL constraints
This section describes running unit tests and analyzing test results.

## 4.1. Executing out-of-the-box unit tests
OSCAL JS comes with a large set of predefined FedRAMP OSCAL Metaschema constraints.

To execute unit tests that come with the tool
1. Open the terminal.  
2. To change to the root directory of the cloned repository, run the following command:  
   `$ cd <cloned-repository-path>`  
3. To execute  
   * All default tests, run the following command:
   `$ make test`
   * A single test, run the following command: (omitting test-id will produce a drop down)
   `$ npm run constraint <test-id>`
  If a test does not exist, the command shows prompts to help you generate the test.

## 4.2. Analyzing test results
After running unit tests, to view the generated report, open the following file:  
`<cloned-repository-path>/reports/constraints.html`

To view generated SARIF reports, browse to the following directory:  
`<cloned-repository-path>/sarif`

# 5. Creating custom unit tests
This section describes steps for creating your own OSCAL Metaschema constraints and YAML unit tests.  

## 5.1. Creating unit tests
To create FedRAMP OSCAL unit tests
1. Open the terminal.  
2. To change to the **constraints** directory, run the following command:  
   `$ cd <cloned-repository-path>/src/validations/constraints`  
3. Create your FedRAMP OSCAL Metaschema XML file.  
4. To pick up changes, run the following command:  
   `$ make test`
The tool parses your Metaschema file and generates the **pass** and **fail** YAML unit test files in the following directory:  
`<cloned-repository-path>/src/validations/constraints/unit-tests`

## 5.2. Sample FedRAMP OSCAL Metaschema and YAML files
You can find sample FedRAMP OSCAL Metaschema XML files in the following directory:  
`<cloned-repository-path>/src/validations/constraints`

Sample **pass** and **fail** YAML unit test files reside in the following directory:  
`<cloned-repository-path>/src/validations/constraints/unit-tests`

# 6\. Providing feedback
If you encounter a bug or have a feature to request, submit an issue at [https://github.com/GSA/fedramp-automation/issues/new/choose](https://github.com/GSA/fedramp-automation/issues/new/choose).  
