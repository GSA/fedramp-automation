_This is the template in [Documenting architecture decisions - Michael Nygard](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions).  In each ADR file, write these sections_:

# 12. Constraint Prioritization Strategy ADR 
Date: 2024-09-26

## Status

Proposed

## Context

The FedRAMP Automation Team requires a consistent mechanism for prioritizing and performing work on FedRAMP constraints. While a larger strategy document was created internally, this ADR documents the key decisions from that document in order to provide transparency to stakeholders and guide contributors to the constraint work.  

## Decision

The FedRAMP Automation Team recognizes the need to develop automation capabilities in the context of current FedRAMP policies, guidance, and review standards. 
Within this context, the Team recognizes three tiers of automation:
- **Completeness Checks**: Ensure the presence of required content and attachments within the package submission. Typically defined and performed using Metaschema constraints.
- **Integrity Checks**: Focus on data correlation and consistency checks within the OSCAL content, similar to database referential integrity checks. Some of this can be performed with Metaschema constraints; however, some may require another mechanism to fully address.
- **Reviewer Automation**: Advanced and complex digital package quality checks to that  support decision-makers in understanding the CSO’s risk posture.

This ADR focuses on Metaschema constraints related to **Completeness Checks** and **Integrity Checks**.

### Approach

1. The Team will align automation actiivity to the FedRAMP Templates and Review Checklists for FedRAMP Baselines based on NIST SP 800-53 Revision 5.
1. The Team will assess each automation activity as something that:
  1. is fully automatable via metaschema constraints or other means; or
  1. requires human judgement, thus is more suited to a workflow.
1. For each template element or review task, the Team will identify the applicable completness and integrity checks, as well as identify any reviewer automation that may be necessary to fully achieve the desired adjudication activity.
1. The Team will prioritize and logically group related constratins into Epics, defined in the FedRAMP Automation GitHub repository.
1. The Team will bundle work into milestones and releases that ensure stakeholders are able to use constraints sooner. 

### Prioritization

The Team will adhear to the following prioritization principles:
- Simple constraints over complex 
- Prioritizing higher value, lower effort constraints first
- Focus on items that apply to all impact levels (H/M/L)

### Delivery Themes 

The Team will work in the following sequence:
- Theme 1: Completeness Checks
- Theme 2: Data and Referential Integrity Checks 
- Theme 3: Reviewer Automation

All contributers to constraint development will ensure all contributions adhear to the [Definition of Done](https://github.com/GSA/fedramp-automation/wiki/Constraint-Management#definition-of-done), which includes updating the documentation in accordance with the [Documentation Standards](https://github.com/GSA/fedramp-automation/wiki/Constraint-Management#documentation-standards).

## Consequences

By focusing on completeness checks first, the Team is able to publish more constraints in a shorter period of time, exposing pilot team perticipants to as many contraints as possible in as short a time as possible. 
Further, completeness checks represent an excellent effort/value ratio in terms of stakeholders being able to validate packages prior to submission.

