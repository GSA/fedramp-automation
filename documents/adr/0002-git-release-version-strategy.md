# 2. Release and Version Strategy Used for Github Tagging

Date: 2021-06-03

## Status

Accepted

## Context

Currently, this repository has no release strategy. Moreover, engineers do not version all artifacts in it as one cohesive collection. Some individual artifacts have their own respective version numbers. Whether or not FedRAMP uses [native tooling Github has for releases and tagging](https://docs.github.com/en/github/administering-a-repository/releasing-projects-on-github/managing-releases-in-a-repository), the collective artifacts in this repository need a release strategy.

The NIST OSCAL development team has recently formalized [their own release strategy and versioning procedures](https://github.com/usnistgov/OSCAL/blob/91084cdad37e88a5fcaf05e5a80c3a81e72a62c5/versioning-and-branching.md). They [release finalized and evaluation versions](https://github.com/usnistgov/oscal/releases) via Github's release feature for the community to evaluate and provide feedback. FedRAMP Automation initiatives heavily rely on these versioned OSCAL artifacts. Therefore, FedRAMP doing so, and indicating how it relates to these NIST OSCAL versions, is useful.

The FedRAMP PMO discussed the strategy, and it is preferable to:

1. clearly identify the version of the bundled artifacts provided by FedRAMP.
2. clearly identify how those bundled artifacts relate to supported NIST OSCAL release(s). 

### Possible Solutions

Below is a list of possible versioning solutions that will or will not support this strategy.

#### Do Nothing

We continue code and content changes in Github, force third-party developers to manually review changes of all modified files using `git` or other diffing tools. This approach is especially complex with respect to complex, binary formats like PDF and Microsoft Office artifacts.

#### Calendar Versioning

[CalVer](https://calver.org/) allows FedRAMP to encode historical information about the release date, but none of its variants semantically useful information that alternative version procedures.

Examples:

- `21.01` (FedRAMP release in January 2021)
- `20210101` (FedRAMP release on specifically 1 January 2021))

#### Debian Versioning

[This complex format](https://man7.org/linux/man-pages/man7/deb-version.7.html) can show upstream changes (e.g. NIST OSCAL) and distinguish between upstream versions and revision versions (e.g. FedRAMP). This versioning strategy is from one of the best-known Linux distributions known for its stability guarantees, [Debian Linux](https://www.debian.org).

Examples:

- `1.0.0+fedramp1.1.2` (OSCAL version 1.0.0 supported by FedRAMP docs and tools in the 1.1.2 release)

#### Semantic Versioning

This is the [most popular open-source standard to date](https://semver.org/spec/v2.0.0.html), with a series of 3 numbers: `X.Y.Z`, where `X` is for major version changes for large, incompatible changes, `Y` is minor version for small changes to add features that are backwards compatible, and `Z`, the patch version, to indicate bug fixes that do not add new features and are backward compatible.

This approach will encode some semantic information about the stability and backwards compatibility of FedRAMP artifacts, but no information about how it pertains to NIST OSCAL versions. Developers will need to continually review documentation carefully, and FedRAMP engineering staff will need to focus additional effort on structuring that information throughout all the artifacts in the repo.

Examples:

- `1.1.2` (FedRAMP version is 1.1.2, but no indication of OSCAL version but in our docs).

#### Spock Versioning

We name this versioning procedure thusly because of [the  open-source test framework, Spock](https://spockframework.org/spock/docs/2.0/known_issues.html#_groovy_version_compatibility). Each version of this testing library is dependent on a specific version of the Groovy programming language, so they have versions such as `spock2.0-groovy2.5`. The internal numbering scheme can embed semantic versioning information with the numbering `X.Y.Z` pattern internally, but 

Examples:
- `fedramp1.1.2-oscal1.0.0` (A FedRAMP release with version 1.1.2 fixes things but still only works for OSCAL 1.0.0)

## Decision

The FedRAMP PMO will commit to one release and versioning strategy and not defer this decision until after NIST OSCAL’s 1.0.0 release. 

FedRAMP will use the Spock versioning procedure for its release strategy. 

## Consequences

- FedRAMP will use Github releases and maintain tagged release branches.
- FedRAMP will track ongoing development and [resolution of support issues](github.com/GSA/fedramp-automation/issues) in Agile sprint fashion.
  - [Github milestones](https://github.com/GSA/fedramp-automation/milestone/) can be used to track release processes.
  - This approach will expedite and [streamline collaboration with the 10x ASAP Team on releasing automated validations rules from their fork of the repository](https://github.com/18F/fedramp-automation).
- FedRAMP will need to continue review of strategies, methods, and means for securing releases and attesting to their origin. There has been much interest in the NIST OSCAL community on this topic, and formal GSA TTS guidance is, [per discussions with staff](https://gsa-tts.slack.com/archives/C02A920NB/p1622741218003800), cursory at this time.