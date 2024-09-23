Feature: OSCAL Document Constraints

@constraints
Scenario Outline: Validating OSCAL documents with metaschema constraints
  Given I have Metaschema extensions documents
    | filename                           |
#BEGIN_DYNAMIC_CONSTRAINT_FILES
  | fedramp-external-allowed-values.xml |
  | fedramp-external-constraints.xml |
  | oscal-external-constraints.xml |
#END_DYNAMIC_CONSTRAINT_FILES
  When I process the constraint unit test "<test_file>"
  Then the constraint unit test should pass

Examples:
  | test_file |
#BEGIN_DYNAMIC_TEST_CASES
  | address-type-FAIL.yaml |
  | address-type-PASS.yaml |
  | attachment-type-FAIL.yaml |
  | attachment-type-PASS.yaml |
  | authorization-type-FAIL.yaml |
  | authorization-type-PASS.yaml |
  | categorization-has-correct-system-attribute-FAIL.yaml |
  | categorization-has-correct-system-attribute-PASS.yaml |
  | categorization-has-information-type-id-FAIL.yaml |
  | categorization-has-information-type-id-PASS.yaml |
  | cloud-service-model-FAIL.yaml |
  | cloud-service-model-PASS.yaml |
  | component-type-FAIL.yaml |
  | component-type-PASS.yaml |
  | control-implementation-status-FAIL.yaml |
  | control-implementation-status-PASS.yaml |
  | data-center-alternate-FAIL.yaml |
  | data-center-alternate-PASS.yaml |
  | data-center-count-FAIL.yaml |
  | data-center-count-PASS.yaml |
  | data-center-country-code-FAIL.yaml |
  | data-center-country-code-PASS.yaml |
  | data-center-primary-FAIL.yaml |
  | data-center-primary-PASS.yaml |
  | data-center-us-FAIL.yaml |
  | data-center-us-PASS.yaml |
  | deployment-model-FAIL.yaml |
  | deployment-model-PASS.yaml |
  | has-authenticator-assurance-level-FAIL.yaml |
  | has-authenticator-assurance-level-PASS.yaml |
  | has-authorization-boundary-diagram-FAIL.yaml |
  | has-authorization-boundary-diagram-PASS.yaml |
  | has-authorization-boundary-diagram-caption-FAIL.yaml |
  | has-authorization-boundary-diagram-caption-PASS.yaml |
  | has-authorization-boundary-diagram-description-FAIL.yaml |
  | has-authorization-boundary-diagram-description-PASS.yaml |
  | has-authorization-boundary-diagram-link-FAIL.yaml |
  | has-authorization-boundary-diagram-link-PASS.yaml |
  | has-authorization-boundary-diagram-link-rel-FAIL.yaml |
  | has-authorization-boundary-diagram-link-rel-PASS.yaml |
  | has-authorization-boundary-diagram-link-rel-allowed-value-FAIL.yaml |
  | has-authorization-boundary-diagram-link-rel-allowed-value-PASS.yaml |
  | has-configuration-management-plan-FAIL.yaml |
  | has-configuration-management-plan-PASS.yaml |
  | has-federation-assurance-level-FAIL.yaml |
  | has-federation-assurance-level-PASS.yaml |
  | has-identity-assurance-level-FAIL.yaml |
  | has-identity-assurance-level-PASS.yaml |
  | has-incident-response-plan-FAIL.yaml |
  | has-incident-response-plan-PASS.yaml |
  | has-information-system-contingency-plan-FAIL.yaml |
  | has-information-system-contingency-plan-PASS.yaml |
  | has-network-architecture-FAIL.yaml |
  | has-network-architecture-PASS.yaml |
  | has-network-architecture-diagram-FAIL.yaml |
  | has-network-architecture-diagram-PASS.yaml |
  | has-network-architecture-diagram-caption-FAIL.yaml |
  | has-network-architecture-diagram-caption-PASS.yaml |
  | has-network-architecture-diagram-description-FAIL.yaml |
  | has-network-architecture-diagram-description-PASS.yaml |
  | has-network-architecture-diagram-link-FAIL.yaml |
  | has-network-architecture-diagram-link-PASS.yaml |
  | has-network-architecture-diagram-link-rel-FAIL.yaml |
  | has-network-architecture-diagram-link-rel-PASS.yaml |
  | has-network-architecture-diagram-link-rel-allowed-value-FAIL.yaml |
  | has-network-architecture-diagram-link-rel-allowed-value-PASS.yaml |
  | has-rules-of-behavior-FAIL.yaml |
  | has-rules-of-behavior-PASS.yaml |
  | has-separation-of-duties-matrix-FAIL.yaml |
  | has-separation-of-duties-matrix-PASS.yaml |
  | has-user-guide-FAIL.yaml |
  | has-user-guide-PASS.yaml |
  | information-type-system-FAIL.yaml |
  | information-type-system-PASS.yaml |
  | interconnection-direction-FAIL.yaml |
  | interconnection-direction-PASS.yaml |
  | interconnection-security-FAIL.yaml |
  | interconnection-security-PASS.yaml |
  | missing-response-components-FAIL.yaml |
  | missing-response-components-PASS.yaml |
  | missing-response-components-test-FAIL.yaml |
  | missing-response-components-test-PASS.yaml |
  | privilege-level-FAIL.yaml |
  | privilege-level-PASS.yaml |
  | resource-has-base64-or-rlink-FAIL.yaml |
  | resource-has-base64-or-rlink-PASS.yaml |
  | resource-has-title-FAIL.yaml |
  | resource-has-title-PASS.yaml |
  | response-point-FAIL.yaml |
  | response-point-PASS.yaml |
  | role-defined-authorizing-official-poc-FAIL.yaml |
  | role-defined-authorizing-official-poc-PASS.yaml |
  | role-defined-information-system-security-officer-FAIL.yaml |
  | role-defined-information-system-security-officer-PASS.yaml |
  | role-defined-system-owner-FAIL.yaml |
  | role-defined-system-owner-PASS.yaml |
  | scan-type-FAIL.yaml |
  | scan-type-PASS.yaml |
  | user-type-FAIL.yaml |
  | user-type-PASS.yaml |
#END_DYNAMIC_TEST_CASES

@full-coverage
Scenario: Preparing constraint coverage analysis
Given I have loaded all Metaschema extensions documents
And I have collected all YAML test files in the test directory
When I extract all constraint IDs from the Metaschema extensions
And I analyze the YAML test files for each constraint ID

@full-coverage
Scenario Outline: Ensuring full test coverage for "<constraint_id>"
Then I should have both FAIL and PASS tests for constraint ID "<constraint_id>"
Examples:
| constraint_id |
#BEGIN_DYNAMIC_CONSTRAINT_IDS
  | address-type |
  | attachment-type |
  | authorization-type |
  | categorization-has-correct-system-attribute |
  | categorization-has-information-type-id |
  | cloud-service-model |
  | component-type |
  | control-implementation-status |
  | data-center-US |
  | data-center-alternate |
  | data-center-count |
  | data-center-country-code |
  | data-center-primary |
  | deployment-model |
  | has-authenticator-assurance-level |
  | has-authorization-boundary-diagram |
  | has-authorization-boundary-diagram-caption |
  | has-authorization-boundary-diagram-description |
  | has-authorization-boundary-diagram-link |
  | has-authorization-boundary-diagram-link-rel |
  | has-authorization-boundary-diagram-link-rel-allowed-value |
  | has-configuration-management-plan |
  | has-federation-assurance-level |
  | has-identity-assurance-level |
  | has-incident-response-plan |
  | has-information-system-contingency-plan |
  | has-network-architecture |
  | has-network-architecture-diagram |
  | has-network-architecture-diagram-caption |
  | has-network-architecture-diagram-description |
  | has-network-architecture-diagram-link |
  | has-network-architecture-diagram-link-rel |
  | has-network-architecture-diagram-link-rel-allowed-value |
  | has-rules-of-behavior |
  | has-separation-of-duties-matrix |
  | has-user-guide |
  | information-type-system |
  | interconnection-direction |
  | interconnection-security |
  | missing-response-components-test |
  | privilege-level |
  | prop-response-point-has-cardinality-one |
  | resource-has-base64-or-rlink |
  | resource-has-title |
  | role-defined-authorizing-official-poc |
  | role-defined-information-system-security-officer |
  | role-defined-system-owner |
  | scan-type |
  | user-type |
#END_DYNAMIC_CONSTRAINT_IDS