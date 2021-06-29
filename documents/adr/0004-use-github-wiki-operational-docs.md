# 4. Maintain Operational Docs in Github Wiki

Date: 2021-06-29

## Status

Accepted

## Context

Currently, the FedRAMP PMO and its developers maintain documentation for the use of OSCAL in the FedRAMP assessment and authorization process, specifically for its external stakeholders, in [a sub-directory of this repository](https://github.com/GSA/fedramp-automation/tree/1445e8145109baee9c1cf5209698b712540cdcd8). It is important to document relevant policies, standards, and procedures for the day-to-day operations for internal use by the FedRAMP PMO's developers, but there is no specified location to do so. Although [Architectural Decision Records](https://github.com/GSA/fedramp-automation/tree/1445e8145109baee9c1cf5209698b712540cdcd8/documents/adr) can be internally-focused, they are not exclusively so. In many cases, they identify significant architectural changes, internal or external, with a rationale and implementation that will directly impact external stakeholders. Therefore, adding in additional internal operations documentation in the same place will likely increase confusion and decrease clarity for external stakeholders. An accessible location, albeit different and easily distinguishable from the location for external stakeholder documentation, will be beneficial.

### Possible Solutions

#### Add Operations Docs Directly into Repository Contents

Developers can commit to the less desirable option and combine the documentation for internal and external stakeholders, and accept the level of confusion it brings.

#### Do Not Add Any Operations Docs to Github

Developers can maintain the internal docs separately in GSA's Google Apps Suite, even if the operational docs are focused on developer operations and mostly focused on the Github repository itself. It is counter-intuitive, but most importantly will have some negative impacts. It will add burden for maintaining permissions for developers outside of Github's permission system and the resulting docs will be not directly adjacent to the relevant artifacts in Github itself.

#### Use Github Wiki

Using the [Github wiki feature](https://docs.github.com/en/communities/documenting-your-project-with-wikis/about-wikis) will allow developers to use documentation in an approachable format (Markdown), with version control behaviors identical to the core `git` mechanism they are familiar with, and keep it as close as possible to the core repo contents.

## Decision

We will use the Github wiki feature to store internal docs, namely standard operating procedures for developer operations, as appropriate and applicable (unless it will divulge CUI or other sensitive information not permitted by GSA information security policies).

## Consequences

- Ease of access for developers.
- Ease of use for developers to edit operational docs as needed.
- Public display of best practices by FedRAMP developers.