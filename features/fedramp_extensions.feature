Feature: OSCAL Document Constraints

@style-guide
Scenario Outline: Validating OSCAL constraints with metaschema constraints
  Then I should verify that all constraints follow the style guide constraint
  
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
  | cia-impact-has-adjustment-justification-FAIL.yaml |
  | cia-impact-has-adjustment-justification-PASS.yaml |
  | cia-impact-has-selected-FAIL.yaml |
  | cia-impact-has-selected-PASS.yaml |
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
  | fedramp-version-FAIL.yaml |
  | fedramp-version-PASS.yaml |
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
  | has-data-flow-FAIL.yaml |
  | has-data-flow-PASS.yaml |
  | has-data-flow-description-FAIL.yaml |
  | has-data-flow-description-PASS.yaml |
  | has-data-flow-diagram-FAIL.yaml |
  | has-data-flow-diagram-PASS.yaml |
  | has-data-flow-diagram-caption-FAIL.yaml |
  | has-data-flow-diagram-caption-PASS.yaml |
  | has-data-flow-diagram-description-FAIL.yaml |
  | has-data-flow-diagram-description-PASS.yaml |
  | has-data-flow-diagram-link-FAIL.yaml |
  | has-data-flow-diagram-link-PASS.yaml |
  | has-data-flow-diagram-link-rel-FAIL.yaml |
  | has-data-flow-diagram-link-rel-PASS.yaml |
  | has-data-flow-diagram-link-rel-allowed-value-FAIL.yaml |
  | has-data-flow-diagram-link-rel-allowed-value-PASS.yaml |
  | has-data-flow-diagram-uuid-FAIL.yaml |
  | has-data-flow-diagram-uuid-PASS.yaml |
  | has-federation-assurance-level-FAIL.yaml |
  | has-federation-assurance-level-PASS.yaml |
  | has-identity-assurance-level-FAIL.yaml |
  | has-identity-assurance-level-PASS.yaml |
  | has-incident-response-plan-FAIL.yaml |
  | has-incident-response-plan-PASS.yaml |
  | has-information-system-contingency-plan-FAIL.yaml |
  | has-information-system-contingency-plan-PASS.yaml |
  | has-marking-FAIL.yaml |
  | has-marking-PASS.yaml |
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
  | has-security-impact-level-FAIL.yaml |
  | has-security-impact-level-PASS.yaml |
  | has-security-sensitivity-level-FAIL.yaml |
  | has-security-sensitivity-level-PASS.yaml |
  | has-separation-of-duties-matrix-FAIL.yaml |
  | has-separation-of-duties-matrix-PASS.yaml |
  | has-system-id-FAIL.yaml |
  | has-system-id-PASS.yaml |
  | has-system-name-short-FAIL.yaml |
  | has-system-name-short-PASS.yaml |
  | has-user-guide-FAIL.yaml |
  | has-user-guide-PASS.yaml |
  | import-profile-has-available-document-FAIL.yaml |
  | import-profile-has-available-document-PASS.yaml |
  | import-profile-resolves-to-fedramp-content-FAIL.yaml |
  | import-profile-resolves-to-fedramp-content-PASS.yaml |
  | information-type-has-availability-impact-FAIL.yaml |
  | information-type-has-availability-impact-PASS.yaml |
  | information-type-has-confidentiality-impact-FAIL.yaml |
  | information-type-has-confidentiality-impact-PASS.yaml |
  | information-type-has-integrity-impact-FAIL.yaml |
  | information-type-has-integrity-impact-PASS.yaml |
  | information-type-id-FAIL.yaml |
  | information-type-id-PASS.yaml |
  | information-type-system-FAIL.yaml |
  | information-type-system-PASS.yaml |
  | interconnection-direction-FAIL.yaml |
  | interconnection-direction-PASS.yaml |
  | interconnection-security-FAIL.yaml |
  | interconnection-security-PASS.yaml |
  | inventory-item-allows-authenticated-scan-FAIL.yaml |
  | inventory-item-allows-authenticated-scan-PASS.yaml |
  | inventory-item-public-FAIL.yaml |
  | inventory-item-public-PASS.yaml |
  | inventory-item-virtual-FAIL.yaml |
  | inventory-item-virtual-PASS.yaml |
  | missing-response-components-FAIL.yaml |
  | missing-response-components-PASS.yaml |
  | privilege-level-FAIL.yaml |
  | privilege-level-PASS.yaml |
  | resource-has-base64-or-rlink-FAIL.yaml |
  | resource-has-base64-or-rlink-PASS.yaml |
  | resource-has-title-FAIL.yaml |
  | resource-has-title-PASS.yaml |
  | response-point-FAIL.yaml |
  | response-point-PASS.yaml |
  | responsible-party-is-person-FAIL.yaml |
  | responsible-party-is-person-PASS.yaml |
  | role-defined-authorizing-official-poc-FAIL.yaml |
  | role-defined-authorizing-official-poc-PASS.yaml |
  | role-defined-information-system-security-officer-FAIL.yaml |
  | role-defined-information-system-security-officer-PASS.yaml |
  | role-defined-system-owner-FAIL.yaml |
  | role-defined-system-owner-PASS.yaml |
  | scan-type-FAIL.yaml |
  | scan-type-PASS.yaml |
  | security-level-FAIL.yaml |
  | security-level-PASS.yaml |
  | security-sensitivity-level-matches-security-impact-level-FAIL.yaml |
  | security-sensitivity-level-matches-security-impact-level-PASS.yaml |
  | user-has-authorized-privilege-FAIL.yaml |
  | user-has-authorized-privilege-PASS.yaml |
  | user-has-privilege-level-FAIL.yaml |
  | user-has-privilege-level-PASS.yaml |
  | user-has-role-id-FAIL.yaml |
  | user-has-role-id-PASS.yaml |
  | user-has-sensitivity-level-FAIL.yaml |
  | user-has-sensitivity-level-PASS.yaml |
  | user-has-user-type-FAIL.yaml |
  | user-has-user-type-PASS.yaml |
  | user-privilege-level-FAIL.yaml |
  | user-privilege-level-PASS.yaml |
  | user-sensitivity-level-FAIL.yaml |
  | user-sensitivity-level-PASS.yaml |
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
  | cia-impact-has-adjustment-justification |
  | cia-impact-has-selected |
  | cloud-service-model |
  | component-type |
  | control-implementation-status |
  | data-center-alternate |
  | data-center-count |
  | data-center-country-code |
  | data-center-primary |
  | data-center-us |
  | deployment-model |
  | fedramp-version |
  | has-authenticator-assurance-level |
  | has-authorization-boundary-diagram |
  | has-authorization-boundary-diagram-caption |
  | has-authorization-boundary-diagram-description |
  | has-authorization-boundary-diagram-link |
  | has-authorization-boundary-diagram-link-rel |
  | has-authorization-boundary-diagram-link-rel-allowed-value |
  | has-configuration-management-plan |
  | has-data-flow |
  | has-data-flow-description |
  | has-data-flow-diagram |
  | has-data-flow-diagram-caption |
  | has-data-flow-diagram-description |
  | has-data-flow-diagram-link |
  | has-data-flow-diagram-link-rel |
  | has-data-flow-diagram-link-rel-allowed-value |
  | has-data-flow-diagram-uuid |
  | has-federation-assurance-level |
  | has-identity-assurance-level |
  | has-incident-response-plan |
  | has-information-system-contingency-plan |
  | has-marking |
  | has-network-architecture |
  | has-network-architecture-diagram |
  | has-network-architecture-diagram-caption |
  | has-network-architecture-diagram-description |
  | has-network-architecture-diagram-link |
  | has-network-architecture-diagram-link-rel |
  | has-network-architecture-diagram-link-rel-allowed-value |
  | has-rules-of-behavior |
  | has-security-impact-level |
  | has-security-sensitivity-level |
  | has-separation-of-duties-matrix |
  | has-system-id |
  | has-system-name-short |
  | has-user-guide |
  | import-profile-has-available-document |
  | import-profile-resolves-to-fedramp-content |
  | information-type-800-60-v2r1 |
  | information-type-has-availability-impact |
  | information-type-has-confidentiality-impact |
  | information-type-has-integrity-impact |
  | information-type-system |
  | interconnection-direction |
  | interconnection-security |
  | inventory-item-allows-authenticated-scan |
  | inventory-item-public |
  | inventory-item-virtual |
  | marking |
  | missing-response-components |
  | privilege-level |
  | prop-response-point-has-cardinality-one |
  | resource-has-base64-or-rlink |
  | resource-has-title |
  | responsible-party-is-person |
  | role-defined-authorizing-official-poc |
  | role-defined-information-system-security-officer |
  | role-defined-system-owner |
  | scan-type |
  | security-level |
  | security-sensitivity-level-matches-security-impact-level |
  | user-has-authorized-privilege |
  | user-has-privilege-level |
  | user-has-role-id |
  | user-has-sensitivity-level |
  | user-has-user-type |
  | user-privilege-level |
  | user-sensitivity-level |
  | user-type |
#END_DYNAMIC_CONSTRAINT_IDS