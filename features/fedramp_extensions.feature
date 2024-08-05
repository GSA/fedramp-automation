Feature: OSCAL Document Constraints

@constraints
Scenario Outline: Validating OSCAL documents with metaschema constraints
  Given I have Metaschema extensions documents
    | filename                           |
    | fedramp-external-constraints.xml   |
    | fedramp-external-allowed-values-DZ.xml   |
  When I process the constraint unit test "<test_file>"
  Then the constraint unit test should pass

Examples:
  | test_file |
#BEGIN_DYNAMIC_TEST_CASES
  | allows-authenticated-scan-FAIL.yaml |
  | allows-authenticated-scan-PASS.yaml |
  | attachment-type-FAIL.yaml |
  | attachment-type-PASS.yaml |
  | component-type-FAIL.yaml |
  | component-type-PASS.yaml |
  | control-implementation-status-FAIL.yaml |
  | control-implementation-status-PASS.yaml |
  | control-origination-FAIL.yaml |
  | control-origination-PASS.yaml |
  | interconnection-direction-FAIL.yaml |
  | interconnection-direction-PASS.yaml |
  | interconnection-security-FAIL.yaml |
  | interconnection-security-PASS.yaml |
  | public-FAIL.yaml |
  | public-PASS.yaml |
  | response-point-FAIL.yaml |
  | response-point-PASS.yaml |
  | scan-type-FAIL.yaml |
  | scan-type-PASS.yaml |
  | virtual-FAIL.yaml |
  | virtual-PASS.yaml |
#END_DYNAMIC_TEST_CASES

@full-coverage
Scenario: Ensuring full test coverage for each constraint
  Given I have loaded all Metaschema extensions documents
  And I have collected all YAML test files in the test directory
  When I extract all constraint IDs from the Metaschema extensions
  And I analyze the YAML test files for each constraint ID
  Then I should have both FAIL and PASS tests for each constraint ID:
    | Constraint ID  |
#BEGIN_DYNAMIC_CONSTRAINT_IDS
  | attachment-type |
  | component-type |
  | control-implementation-status |
  | interconnection-direction |
  | interconnection-security |
  | prop-response-point-has-cardinality-one |
  | prop-response-point-matches-string |
  | scan-type |
#END_DYNAMIC_CONSTRAINT_IDS