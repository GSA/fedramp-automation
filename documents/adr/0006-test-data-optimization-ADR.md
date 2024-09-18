# 6. Test data optimization ADR 
Date: 2024-09/18

## Status
Proposed

## Context
Currently, all tests for constraints used by the constraint validation tool rely on the same 'ssp-all-VALID.xml' and 'ssp-all-INVALID.xml' test data files. This results in conflicts between many constraints, preventing the tests from failing properly when using shared test data files.

## Possible Solutions
1. When the YAML tests are scaffolded for a constraint by running 'npm run constraint', the corresponding 'valid' and 'invalid' test data files specific to that constraint should also be scaffolded with the minimum necessary content.

## Decision
No decision has currently been made. 

## Consequences
Solution 1: 
- Longer test run time. 
