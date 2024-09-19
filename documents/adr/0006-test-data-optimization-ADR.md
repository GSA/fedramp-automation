# 6. Test data optimization ADR 
Date: 2024-09-19

## Status
Proposed

## Context
Currently, all tests for constraints used by the constraint validation tool rely on the same invalid test data file (`ssp-all-INVALID.xml`). This results in conflicts between many constraints, preventing the tests from failing properly when using a shared invalid test data file. An example of this conflict is:
```xml
<categorization system="https://doi.org/10.6028/NIST.SP.800-60v2r1">
  <information-type-id>C.2.8.12</information-type-id>
</categorization>
```
We have one constraint, `information-type-has-categorization`, that checks the existence of the `categorization` element. In the fail case, we need to remove this `categorization` block from the invalid test data file entirely in order to make the fail case fail successfully (categorization element doesn't exist). We have another constraint, `information-type-system`, that checks if the `system` attribute is a valid value. In the fail case, the `information-type-system` constraint cannot check the `system` attribute because the entire `categorization` element is removed to satisfy the `information-type-has-categorization` constraint fail case. This conflict makes it impossible for both of these constraints to share the same invalid test data file when validating the constraints.

## Possible Solutions
1. Currently, the test runner has a feature where the positive (`-PASS.yaml`) and negative (`-FAIL.yaml`) tests are scaffolded for a given constraint by running `npm run constraint` in a terminal window. These yaml test files reference the corresponding test data files that the constraint should be validated against. We can add functionality to this existing feature to prompt a user if they would like to generate new invalid test data (`-all-INVALID.xml`) as well, or use the existing invalid test data file for that model (e.g., ssp-all-INVALID.xml). If a user chooses to generate new invalid test data, we can scaffold a new invalid test data file, specific to the constraint, that uses a lean template. This template would contain only the necessary context to validate the constraint, and schema validation would be disabled to ensure that the invalid test data is as lean as possible. The yaml test files can then automatically reference the newly generated invalid test data file to validate the constraint. If a user chooses to use the existing invalid test data file for that model, then the yaml test files will reference the existing invalid test data file for that model to validate the constraint. Adding this functionality to the `npm run constraint` command would make sure that all necessary content to validate a constraint is generated at the same time, and that the yaml test files reference the correct test data file. This solution would solve the problem of constraints not successfully passing the fail case when referencing the same invalid test data file by adding the flexbility to isolate the testing of a constraint by scaffolding a new invalid test data file specific to the constraint. The current method of validating the pass case of all constraints in the same valid test data file (`ssp-all-VALID.xml`) will not be changed or impacted by this solution.

## Decision
No decision has currently been made. 

## Consequences
Solution 1: 
- Longer test run time. 
