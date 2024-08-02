Feature: OSCAL Document Constraints

@constraints
Scenario Outline: Validating OSCAL documents with metaschema constraints
  Given I have Metaschema extensions documents
    | filename                           |
    | oscal-external-constraints.xml     |
    | fedramp-external-constraints.xml   |
    | fedramp-external-allowed-values-DZ.xml   |
  When I process the constraint unit test "<test_file>"
  Then the constraint unit test should pass

Examples:
  | test_file |
# DYNAMIC_EXAMPLES
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
  | response-point-PASS.yaml |
  | scan-type-FAIL.yaml |
  | scan-type-PASS.yaml |
  | virtual-FAIL.yaml |
  | virtual-PASS.yaml |