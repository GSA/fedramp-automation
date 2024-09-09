# Contributing to constraints and tests

This document guides developers through changing or extending code and data in in this folder and sub-folders. They contain the constraints to check FedRAMP requirements for OSCAL data and a test harness. The test harness includes unit tests, valid, and invalid OSCAL fixture data for those tests.

## Overview of the constraint and testing infrastructure

The diagram below highlights how different constraints, tests, fixture data with invalid and valid OSCAL documents, and dependencies function together.

```mermaid
flowchart TD
    BuildTool[make build-validations] -->|runs| NpmRunner[npm test]
    NpmRunner -->|runs| TestRunner[cucumber]
    TestRunner -->|loads test descriptions from| TestRunnerExtension(fedramp_extension.feature)
    TestRunnerExtension[fedramp_extension.feature] -->|using the helper| TestRunnerImplementation(fedramp_extension_steps.ts)
    TestRunnerImplementation -->|imports| CLIWrapper(oscal-js)
    TestRunnerImplementation-->|loads| TestConfiguration(YAML test inventory)
    TestRunnerImplementation-->|exports unit test results| UnitTestResults(reports/constraints.html)
    CLIWrapper -->|configures and runs| CLI(oscal-cli)
    CLI-->|loads| ConstraintFile(constraint XML files)
    CLI -->|validates| TestFixtures(OSCAL test content)
    CLI -->|return| CLIResult(exit code and SARIF results)
    CLIResult -->|interpreted by| CLIWrapper
    CLIWrapper -->|SARIF in memory| TestRunnerImplementation
```

## How do I install tools for development and testing?

After you [install the prerequisites](./README.md#31-prerequisites), you can use `make` to properly configure tools and their dependencies.

```sh
cd path/to/fedramp-automation
make init
```

## How do I run the tests?

To run the existing tests as-is, you can use `make` or `npm` directly.

```sh
cd path/to/fedramp-automation
# use make
make test
# or use npm from the top-level directory
npm test
# or use it from within this directory
cd src/validations/constraints
npm test
```

## How do I add a constraint and test?

You can add a constraint and test to this repository by following these high-level steps.

1. Create a new constraint in [the appropriate constraints file](#which-constraint-file-do-i-edit). Note the `id`, you will use it later.
2. Add the necessary, correct data to [`./content/ssp-all-VALID.xml`](./content/ssp-all-VALID.xml) for a positive test of the constraint.
3. Add the YAML metadata for the positive test in [`./unit-tests`](./unit-tests/). The name of the file should start with the name of the assembly, field, or flag, and end with `-PASS.yaml`. For example, a new constraint and test for a [`//metadata/party/prop`](https://pages.nist.gov/OSCAL-Reference/models/v1.1.2/system-security-plan/json-reference/#/system-security-plan/metadata/parties) assembly should be `party-PASS.yaml`. The content should be like the example below.

```yaml
# ./unit-tests/party-PASS.yaml
test-case:
  name: Positive Test for party
  description: This test case validates the behavior of constraint party
  content: ../content/ssp-all-VALID.xml
  expectations:
    - constraint-id: party
      result: pass
```

4. Add the necessary, incorrect data to [`./content/ssp-all-INVALID.xml`](./content/ssp-all-INVALID.xml) for a positive test of the constraint.
5. Add the YAML metadata for the negative test in [`./unit-tests`](./unit-tests/). The name of the file should start with the name of the assembly, field, or flag, and end with `-FAIL.yaml`. For example, a new constraint and test for a `//metadata/party/prop` assembly should be `party-FAIL.yaml`. The content should be like the example below.

```yaml
# ./unit-tests/party-FAIL.yaml
test-case:
  name: Negative Test for party
  description: This test case validates the behavior of constraint party
  content: ../content/ssp-all-INVALID.xml
  expectations:
    - constraint-id: party
      result: fail
```

6. Update the test descriptions in [Cucumber feature file](https://cucumber.io/docs/gherkin/reference/), [`../../../features/fedramp_extensions.feature`](../../../features/fedramp_extensions.feature). Add the file names between `#BEGIN_DYNAMIC_TEST_CASES` and `#END_DYNAMIC_TEST_CASES` blocks in alphabetical order so the test runner discovers them. Add the constraint ID between the `#BEGIN_DYNAMIC_CONSTRAINT_IDS` and `#END_DYNAMIC_CONSTRAINT_IDS` in alphabetical order so the test runner can perform code coverage analysis. The updated content should like the example below.

```yaml
# Beginning of file truncated
#BEGIN_DYNAMIC_TEST_CASES
# There will be existing test case files, you are adding these below
  | party-FAIL.yaml |
  | party-PASS.yaml |
#END_DYNAMIC_TEST_CASES
# Middle of file truncated
#BEGIN_DYNAMIC_CONSTRAINT_IDS
# There will be existing constraint IDs, you are adding this one below
  | party |
#END_DYNAMIC_CONSTRAINT_IDS
# End of file truncated
```

7. You can now [run the test harness](#how-do-i-run-the-tests) and confirm the new tests are correct.
8. Update the files with [`git add`](https://git-scm.com/docs/git-add) and [`git commit`](https://git-scm.com/docs/git-commit) to a branch for a pull request.

## How do I modify a test?

To modify a test, you may possibly need to change the constraint, valid test data, invalid test data, the test case YAML file(s), and the Cucumber inventory.

To change the test data for a test developers [previously added with the correct steps](#how-do-i-add-a-constraint-and-test), you only need to modify the valid or invalid data in [`./content`](./content).

To change the `test` or `target` of a constraint developers [previously added with the correct steps](#how-do-i-add-a-constraint-and-test), you may only need to adjust the constraint [in the appropriate constraint file](#which-constraint-file-do-i-edit), the valid data, and/or invalid data, but not other files. What and why you will change determines if some or all those files need a modification.

To change the `id` of a constraint developers [previously added with the correct steps](#how-do-i-add-a-constraint-and-test), you must make more changes.

1. You must update the `id` [in the appropriate constraint file](#which-constraint-file-do-i-edit).
1. You must use [`git mv`](https://git-scm.com/docs/git-mv) to rename the test case files in [`./unit-tests`](./unit-tests) with relevant changes to the assembly, field, or flag and ID.
1. You must update the files names and constraint ID in [`../../../features/fedramp_extensions.feature`](../../../features/fedramp_extensions.feature) accordingly.
8. Update the files with [`git add`](https://git-scm.com/docs/git-add) and [`git commit`](https://git-scm.com/docs/git-commit) to a branch for a pull request.

## How do I delete a constraint and test?

## Which constraint file do I edit?

### `fedramp-external-allowed-values.xml`

The [`fedramp-external-allowed-values.xml`](./fedramp-external-allowed-values.xml) file contains [Metaschema constraints](#how-do-i-learn-more-about-metaschema-and-metapath) specific to FedRAMP use cases and requirements for data in the OSCAL information model. Specifically, developers only maintain constraints in this file if they are simple [`allowed-values` checks](https://pages.nist.gov/metaschema/specification/syntax/constraints/#allowed-values-constraints). FedRAMP developers maintain constraints of all types in the [`fedramp-external-constraints.xml`](#fedramp-external-constraintsxml) file.

### `fedramp-external-constraints.xml`

The [`fedramp-external-constraints.xml`](./fedramp-external-constraints.xml) file contains [Metaschema constraints](#how-do-i-learn-more-about-metaschema-and-metapath) specific to FedRAMP use cases and requirements for data in the OSCAL information model. Specifically, developers maintain all constraints in this file that are *not* simple [`allowed-values` checks](https://pages.nist.gov/metaschema/specification/syntax/constraints/#allowed-values-constraints).

### `oscal-external-constraints.xml`

The [`oscal-external-constraints.xml`](./oscal-external-constraints.xml) file contains [Metaschema constraints](#how-do-i-learn-more-about-metaschema-and-metapath) that can complement the existing constraints [embedded directly into the official upstream NIST OSCAL models](https://github.com/usnistgov/OSCAL/tree/v1.1.2/src/metaschema). The proposed constraints in this file support improved long-term maintenance and extensibility with the intent to merge upstream. Therefore, FedRAMP developers do *not* use this file for any constraint specific to FedRAMP use cases or requirements in the OSCAL information model.

**NOTE**: The FedRAMP Automation Team will make a best effort attempt to collaborate with NIST maintainers to merge them upstream and deprecate from this repository accordingly. Until further notice, the FedRAMP Automation Team maintains them here for testing and evaluation until they are sufficiently mature to contribute them upstream.

## How do I learn more about Metaschema and Metapath?

To add or modify constraints and their tests, it is important to understand Metaschema syntax, particularly constraint syntax and Metapath syntax for `@test` and `@target` in the constraints. You can review these pages for more information.

- [Metaschema constraint syntax](https://pages.nist.gov/metaschema/specification/syntax/constraints/)
- [Metapath expression language](https://pages.nist.gov/metaschema/specification/syntax/metapath/)
- [Metaschema tutorials for modeling and constraints](https://pages.nist.gov/metaschema/tutorials/)
- [Metaschema complete syntax reference](https://pages.nist.gov/metaschema/specification/syntax/)
