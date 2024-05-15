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

TBD

## Consequences

- Early and consistent detection of defects
- Maintainable test suite
- Ability to automate testing
