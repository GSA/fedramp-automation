# 10. Replace Spock Versions with Semantic Versions in Release Strategy

Date: 2021-10-07

## Status

Accepted

## Context

In the past, the FedRAMP Automation Team [the versioning methodology of the Spock Framework](https://spockframework.org/spock/docs/2.0/known_issues.html#_groovy_version_compatibility). Staff documented this versioning methodology in [ADR #2](https://github.com/GSA/fedramp-automation/blob/247f99a0e3a2cfa6b9e78dd7c18836cf008115b2/documents/adr/0002-git-release-version-strategy.md). In 2024, the FedRAMP Automation Team received significant positive feedback from the community to transition from this methodology to [Semantic Versioning](https://semver.org/) as part of its release strategy and updated [the automate.fedramp.gov website](https://automate.fedramp.gov/about/release/) accordingly. They also socialized with the community that the update page on the website, not the previous ADR and outdated developer documentation, is the canonical source for the release strategy and other documents.

This decision record is to document the following possible solutions and implications.

### Possible Solutions

Below is a list of possible versioning solutions that will or will not support this strategy.

1. Do nothing
1. Continue Spock Versioning and revert Semantic Versioning change
1. Continue Semantic Versioning change and completely deprecate Spock versioning

#### Do Nothing

If FedRAMP does nothing, the strategy and processes will stay as-is. The documentation about the release strategy and versioning methodology and the practice of using them in releases will contradict one another. Internal staff and external stakeholders will continue to receive conflicted guidance and releases. The misalignment may cause confusion about future releases. Despite less effort, it has significant downsides in risk when compared to Options 2 and 3.

#### Continue Spock Versioning and Revert Semantic Versioning Change

FedRAMP can change the developer documentation, standard operating procedures in the wiki, and the website to continue to use Spock versioning and revert the decision to use Semantic Versioning. This option would require similar effort to Option 3. However, this option will likely alienate community stakeholders receptive to the change.

#### Continue Semantic Versioning Change and Completely Deprecate Spock Versioning

FedRAMP can change the developer documentation, standard operating procedures in the wiki, and the website to finalize the removal of Spock versioning and fully commit to the decision to use Semantic Versioning. This option would require similar effort to Option 2 but with better community support for a popular transition that is not yet complete.

## Decision

FedRAMP has decided to move forward completely with the Semantic Versioning transition and completely deprecate the Spock versioning approach.

1. FedRAMP will use Semantic Versioning, as is the preference of the community.
2. The official, normative release guidance for FedRAMP Automation data, documentation, and tools is the [release guidance on automate.fedramp.gov](https://automate.fedramp.gov/about/release/), not developer documentation in this repository.

## Consequences

What becomes easier or more difficult to do because of this change?
