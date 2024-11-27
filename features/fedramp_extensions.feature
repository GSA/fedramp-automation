Feature: OSCAL Document Constraints

@style-guide
Scenario Outline: Validating OSCAL constraints with metaschema constraints
  Then I should verify that all constraints follow the style guide constraint

@integration
Scenario Outline: Documents that should be valid are pass
  Then I should have valid results "<valid_file>"
Examples:
| valid_file     |
| ssp-all-VALID.xml |
# | ../../../content/awesome-cloud/xml/AwesomeCloudSSP1.xml |
# | ../../../content/awesome-cloud/xml/AwesomeCloudSSP2.xml |

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
  | authentication-method-has-remarks |
  | authorization-type |
  | categorization-has-correct-system-attribute |
  | categorization-has-information-type-id |
  | cia-impact-has-adjustment-justification |
  | cia-impact-has-selected |
  | cloud-service-model |
  | component-has-authentication-method |
  | component-type |
  | control-implementation-status |
  | data-center-alternate |
  | data-center-count |
  | data-center-country-code |
  | data-center-primary |
  | data-center-us |
  | deployment-model |
  | external-system-nature-of-agreement |
  | fedramp-version |
  | fully-operational-date-is-valid |
  | fully-operational-date-type |
  | has-authenticator-assurance-level |
  | has-authorization-boundary-diagram |
  | has-authorization-boundary-diagram-caption |
  | has-authorization-boundary-diagram-description |
  | has-authorization-boundary-diagram-link |
  | has-authorization-boundary-diagram-link-href-target |
  | has-authorization-boundary-diagram-link-rel |
  | has-authorization-boundary-diagram-link-rel-allowed-value |
  | has-cloud-deployment-model |
  | has-cloud-deployment-model-remarks |
  | has-cloud-service-model |
  | has-cloud-service-model-remarks |
  | has-configuration-management-plan |
  | has-data-flow |
  | has-data-flow-description |
  | has-data-flow-diagram |
  | has-data-flow-diagram-caption |
  | has-data-flow-diagram-description |
  | has-data-flow-diagram-link |
  | has-data-flow-diagram-link-href-target |
  | has-data-flow-diagram-link-rel |
  | has-data-flow-diagram-link-rel-allowed-value |
  | has-data-flow-diagram-uuid |
  | has-federation-assurance-level |
  | has-fully-operational-date |
  | has-identity-assurance-level |
  | has-incident-response-plan |
  | has-information-system-contingency-plan |
  | has-inventory-items |
  | has-network-architecture |
  | has-network-architecture-diagram |
  | has-network-architecture-diagram-caption |
  | has-network-architecture-diagram-description |
  | has-network-architecture-diagram-link |
  | has-network-architecture-diagram-link-href-target |
  | has-network-architecture-diagram-link-rel |
  | has-network-architecture-diagram-link-rel-allowed-value |
  | has-published-date |
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
  | leveraged-authorization-has-authorization-type |
  | leveraged-authorization-has-impact-level |
  | leveraged-authorization-has-system-identifier |
  | leveraged-authorization-nature-of-agreement |
  | marking |
  | missing-response-components |
  | party-has-name |
  | privilege-level |
  | prop-response-point-has-cardinality-one |
  | resource-has-base64-or-rlink |
  | resource-has-title |
  | responsible-party-is-person |
  | responsible-party-prepared-by |
  | responsible-party-prepared-by-location-valid |
  | responsible-party-prepared-for |
  | responsible-party-prepared-for-location-valid |
  | role-defined-authorizing-official-poc |
  | role-defined-information-system-security-officer |
  | role-defined-prepared-by |
  | role-defined-prepared-for |
  | role-defined-system-owner |
  | saas-has-leveraged-authorization |
  | scan-type |
  | security-level |
  | security-sensitivity-level-matches-security-impact-level |
  | unique-inventory-item-asset-id |
  | user-authentication |
  | user-has-authorized-privilege |
  | user-has-privilege-level |
  | user-has-role-id |
  | user-has-sensitivity-level |
  | user-has-user-type |
  | user-privilege-level |
  | user-sensitivity-level |
  | user-type |
#END_DYNAMIC_CONSTRAINT_IDS

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
  | authentication-method-has-remarks-FAIL.yaml |
  | authentication-method-has-remarks-PASS.yaml |
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
  | component-has-authentication-method-FAIL.yaml |
  | component-has-authentication-method-PASS.yaml |
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
  | external-system-nature-of-agreement-FAIL.yaml |
  | external-system-nature-of-agreement-PASS.yaml |
  | fedramp-version-FAIL.yaml |
  | fedramp-version-PASS.yaml |
  | fully-operational-date-is-valid-FAIL.yaml |
  | fully-operational-date-is-valid-PASS.yaml |
  | fully-operational-date-type-FAIL.yaml |
  | fully-operational-date-type-PASS.yaml |
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
  | has-authorization-boundary-diagram-link-href-target-FAIL.yaml |
  | has-authorization-boundary-diagram-link-href-target-PASS.yaml |
  | has-authorization-boundary-diagram-link-rel-FAIL.yaml |
  | has-authorization-boundary-diagram-link-rel-PASS.yaml |
  | has-authorization-boundary-diagram-link-rel-allowed-value-FAIL.yaml |
  | has-authorization-boundary-diagram-link-rel-allowed-value-PASS.yaml |
  | has-cloud-deployment-model-FAIL.yaml |
  | has-cloud-deployment-model-PASS.yaml |
  | has-cloud-deployment-model-remarks-FAIL.yaml |
  | has-cloud-deployment-model-remarks-PASS.yaml |
  | has-cloud-service-model-FAIL.yaml |
  | has-cloud-service-model-PASS.yaml |
  | has-cloud-service-model-remarks-FAIL.yaml |
  | has-cloud-service-model-remarks-PASS.yaml |
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
  | has-data-flow-diagram-link-href-target-FAIL.yaml |
  | has-data-flow-diagram-link-href-target-PASS.yaml |
  | has-data-flow-diagram-link-rel-FAIL.yaml |
  | has-data-flow-diagram-link-rel-PASS.yaml |
  | has-data-flow-diagram-link-rel-allowed-value-FAIL.yaml |
  | has-data-flow-diagram-link-rel-allowed-value-PASS.yaml |
  | has-data-flow-diagram-uuid-FAIL.yaml |
  | has-data-flow-diagram-uuid-PASS.yaml |
  | has-federation-assurance-level-FAIL.yaml |
  | has-federation-assurance-level-PASS.yaml |
  | has-fully-operational-date-FAIL.yaml |
  | has-fully-operational-date-PASS.yaml |
  | has-identity-assurance-level-FAIL.yaml |
  | has-identity-assurance-level-PASS.yaml |
  | has-incident-response-plan-FAIL.yaml |
  | has-incident-response-plan-PASS.yaml |
  | has-information-system-contingency-plan-FAIL.yaml |
  | has-information-system-contingency-plan-PASS.yaml |
  | has-inventory-items-FAIL.yaml |
  | has-inventory-items-PASS.yaml |
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
  | has-network-architecture-diagram-link-href-target-FAIL.yaml |
  | has-network-architecture-diagram-link-href-target-PASS.yaml |
  | has-network-architecture-diagram-link-rel-FAIL.yaml |
  | has-network-architecture-diagram-link-rel-PASS.yaml |
  | has-network-architecture-diagram-link-rel-allowed-value-FAIL.yaml |
  | has-network-architecture-diagram-link-rel-allowed-value-PASS.yaml |
  | has-published-date-FAIL.yaml |
  | has-published-date-PASS.yaml |
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
  | leveraged-authorization-has-authorization-type-FAIL.yaml |
  | leveraged-authorization-has-authorization-type-PASS.yaml |
  | leveraged-authorization-has-impact-level-FAIL.yaml |
  | leveraged-authorization-has-impact-level-PASS.yaml |
  | leveraged-authorization-has-system-identifier-FAIL.yaml |
  | leveraged-authorization-has-system-identifier-PASS.yaml |
  | leveraged-authorization-nature-of-agreement-FAIL.yaml |
  | leveraged-authorization-nature-of-agreement-PASS.yaml |
  | marking-FAIL.yaml |
  | marking-PASS.yaml |
  | missing-response-components-FAIL.yaml |
  | missing-response-components-PASS.yaml |
  | party-has-name-FAIL.yaml |
  | party-has-name-PASS.yaml |
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
  | responsible-party-prepared-by-FAIL.yaml |
  | responsible-party-prepared-by-PASS.yaml |
  | responsible-party-prepared-by-location-valid-FAIL.yaml |
  | responsible-party-prepared-by-location-valid-PASS.yaml |
  | responsible-party-prepared-for-FAIL.yaml |
  | responsible-party-prepared-for-PASS.yaml |
  | responsible-party-prepared-for-location-valid-FAIL.yaml |
  | responsible-party-prepared-for-location-valid-PASS.yaml |
  | role-defined-authorizing-official-poc-FAIL.yaml |
  | role-defined-authorizing-official-poc-PASS.yaml |
  | role-defined-information-system-security-officer-FAIL.yaml |
  | role-defined-information-system-security-officer-PASS.yaml |
  | role-defined-prepared-by-FAIL.yaml |
  | role-defined-prepared-by-PASS.yaml |
  | role-defined-prepared-for-FAIL.yaml |
  | role-defined-prepared-for-PASS.yaml |
  | role-defined-system-owner-FAIL.yaml |
  | role-defined-system-owner-PASS.yaml |
  | saas-has-leveraged-authorization-FAIL.yaml |
  | saas-has-leveraged-authorization-PASS.yaml |
  | scan-type-FAIL.yaml |
  | scan-type-PASS.yaml |
  | security-level-FAIL.yaml |
  | security-level-PASS.yaml |
  | security-sensitivity-level-matches-security-impact-level-FAIL.yaml |
  | security-sensitivity-level-matches-security-impact-level-PASS.yaml |
  | unique-inventory-item-asset-id-FAIL.yaml |
  | unique-inventory-item-asset-id-PASS.yaml |
  | user-authentication-FAIL.yaml |
  | user-authentication-PASS.yaml |
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
