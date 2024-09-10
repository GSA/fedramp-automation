# 6. Test Harness and Unit Testing Framework

Date: 2024-05-14

## Status

Pending Research

## Context

The FedRAMP OSCAL automation team needs a good, light-weight, simple test harness and framework for automated unit testing.  The solution will be used for QA of developed FedRAMP OSCAL validation rules integrated into the OSCAL CLI tool.  The solution may also be used to integrate with testing of other FedRAMP OSCAL tools in the future.

### Requirements
- **Licencing** - Any leveraged automated (unit) testing frameworks must be open source.
- **Test Harness** - Must support declarative approach to defining tests (e.g., new tests can be added with no/minimal coding).  
 - Should support use of unit test templates to make it easier to create new tests.
- **Design** - Must support creating and categorizing comprehensive test scenarios covering different validation rules, rule combinations, and edge cases.
- **Configuration** - Approach should simplify configuration of test vectors
- **Language / Platform** - Preferably should be based on Node.js and Javascript/TypeScript, although other languages may be considered if there is a considerable benefit
- **Data** - Must include both valid and invalid data samples to verify rule enforcement and error detection.
- **Execution / Results** - must be able to (automate) running of tests defined in test harness and produce test results, including pass/fail status, error messages, and performance metrics.
 - Must be able to run entire test suite or subset
- **Integration** - Should integrate easily with CI/CD pipelines

## Decision

The FedRAMP OSCAL automation will implement a customized testing harness that features the following components:

- Testing harness is based on [Cucumber](https://cucumber.io/docs/guides/overview/), an open-source software testing tool that helps developers test software by running scenarios to see if they produce the intended results
- Metaschema-based constraints for FedRAMP validation rules (in the /src/validations/constraints folder)
- Declarative YAML unit tests to ensure developed constraints yield expected results (in the /src/validations/constraints/unit-tests folder).  The YAML unit tests must use the following structure:
```
test-case:
  name: {name / title for the constraint test scenario}
  description: {a description of the constraint being tested}
  content: {path to the OSCAL content the constraint will be tested on}
  pipeline: {OPTIONAL element if some pipeline action such as profile resolution needs to happen on the specified content before executing the test}
  - action: {OPTION action such as resolve-profile} 
  expectations: 
  - constraint-id: {the ID of the constraint being tested}
    result: {pass | fail}
``` 
- OSCAL content for the unit tests (in the /src/validations/constraints/contents folder)
- A Node.js script is the test driver, taking the cucumber scenarios & steps, metaschema constraints, their corresponding unit tests, and specified unit test PASS and FAIL content files, and using that to execute OSCAL-CLI validations.  

More details about the test harness, how the components integrate, and how to create or update constraints can be found in the [validations contributing](/src/validations/CONTRIBUTING.md) page.

## Consequences

- Early and consistent detection of defects
- Maintainable test suite
- Ability to automate testing
