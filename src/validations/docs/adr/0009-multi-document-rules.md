# 9. Multi-document validation rules

Date: 2021-09-14

## Status

Proposed

## Context

The ASAP Development Team has, through 10x phase 3 funding, engaged in the development of validation rules for FedRAMP OSCAL System Security Plan (SSP) documents. Subsequent effort will extend the coverage of validation rules to additional documents, including System Assessment Report (SAR), Security Assessment Plan (SAP), and Plan of Action and Milestones (POA&M) documents.

This extended rule coverage will entail decisions on the following:

- An manner of organizing rules for each document type
- A mechanism for evaluating cross-document validation rules

## Considerations

- Invasiveness on rule writing process
- Performance of rule evaluation
- Level-of-effort required for integrations (third-party and the ASAP UI)
- Ability of third-parties to augment the rule set with custom rules

### Package Manifest

A manifest document that references all documents in a given FedRAMP submission package could serve two mutually exclusive purposes:

1) Provide document paths to the integrating application, which would then validate each document using appropriate Schematron rules
2) Serve as the target document of Schematron rule evaluation. Ancillary documents would then need to be loaded via Schematron or XSLT constructs.

These two manifest use cases are mutually exclusive, but each could be served by a similar manifest.

### Cross-document rules

There are two high-level approaches to cross-document rules:

1) Separate Schematron rulesets for each document type, each parametized on ancillary document paths. Each ancillary document would then be separately loaded via Schematron or XSLT constructs.
2) A single Schematron ruleset that validates a manifest document. Each document referenced in the manifest would be loaded separately via Schematron or XSLT constructs.

#1 is most compatible with schema-driven editing. #2 provides easier integration points with third-party integrators, but may not be achievable with Schematron.

## Decision

A manifest document will be defined. Minimally, this document will include relative paths to each document included in a FedRAMP OSCAL Package Submission.

Separate Schematron documents for each document type appears to be the most straight-forward from a rule-writing perspective. Follow-up work will determine how to structure multi-document validation rules, and move this ADR from "proposed" to "accepted."
