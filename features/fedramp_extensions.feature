Feature: OSCAL Document Constraints

@constraints
Scenario Outline: Validating OSCAL documents with metaschema constraints
  Given I have Metaschema extensions documents
    | filename                           |
    | oscal-external-constraints.xml     |
    | fedramp-external-constraints.xml   |
  When I process the constraint unit test "<test_file>"
  Then the constraint unit test should pass

Examples:
  | test_file |
# DYNAMIC_EXAMPLES
  | response-point-PASS.yaml |