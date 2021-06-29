# 3. Manage Github with Github Teams

Date: 2021-06-29

## Status

Accepted

## Context

Previously, one individual developer maintained resources in this repository. The developer, as a single individual, was configured to have certain roles and permissions in the repository. When off-boarding, this approach led to delays during staff turnover, and explicitly adding user IDs requires manual checking in multiple locations for this repository's Github configuration. To reduce burden for the off-boarding and on-boarding new staff, an alternative approach should be used.

### Possible Solutions

#### Make No Changes

We can continue to just explicitly add individual users and accept the risk of coverage gaps in repository ownership.

#### Follow GSA TTS Github Recommendations on Team Organization

[GSA's Technology Transformation Services has published guidance](https://handbook.tts.gsa.gov/github/) regarding the use of [Github's organizations and teams feature](https://docs.github.com/en/organizations) for the management of roles, their permissions, issue triage, and pull request review. Per this guidance, separate teams in the GSA organization ought to be configured to administer the repo, and the administrators maintain a separate team for partner developers (other federal agency teams and contractors for active projects).

#### Define a Custom Procedure for Management of Github Organizations and Teams

We, with the consent of the FedRAMP PMO, can decline to follow the GSA TTS guidance and design our own standard operating procedures.

## Decision

We will apply GSA TTS guidance, using [the GSA organization](https://github.com/orgs/GSA) and create the different teams accordingly.

## Consequences

- Improved continuity of operations.
- More investment in documentation for operational procedure documents for FedRAMP staff. 