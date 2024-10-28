<img src="https://github.com/GSA/fedramp-automation/raw/master/assets/FedRAMP_LOGO.png" alt="FedRAMP" width="76" height="94"><br />

# Federal Risk and Authorization Management Program (FedRAMP) Automation

## Overview


**If you are interested in [an overview about OSCAL](https://automate.fedramp.gov/about/) and [extensive documentation](https://automate.fedramp.gov/documentation/) on how to use it for FedRAMP's specific requirements, please visit our [Developer Hub](https://automate.fedramp.gov/).**

FedRAMP maintains this repository with data, software, and documentation to review digital authorization packages for FedRAMP authorizations using [OSCAL](https://pages.nist.gov/OSCAL/documentation/). Our primary aim is to reduce manual review efforts and timeframes by validating whether submissions conform to FedRAMP’s requirements. Once complete, our tooling will help ensure that packages such as System Security Plans (SSPs) and Plans of Action and Milestones (POA&Ms) meet FedRAMP's expectations before submission, streamlining the review process.

## FedRAMP OSCAL Validation Tooling

Our current focus is developing validation constraints to use with the oscal-cli to automatically check that all parts of a FedRAMP digital authorization package (such as System Security Plan) meet FedRAMP's requirements before staff start a formal review.  

As a part of this project, we are continuing to release "constraints," or automated "checks" of FedRAMP's digital authorization package requirements, to expand the coverage of our tooling and further automate the review of security artifacts. To learn more about installing and using our validation tooling, go [here](./blob/develop/src/validations/constraints/README.md). 

Our tooling:
- Validates OSCAL documents against FedRAMP constraints.
- Identifies compliance with FedRAMP requirements.
- Outputs a SARIF report, detailing both passed and failed validations.

This tooling is intended for use by FedRAMP OSCAL implementers and practitioners, Cloud Service Providers (CSPs), OSCAL tool developers, 3rd Party Assessment Organizations (3PAOs), and federal agencies. We welcome any and all feedback. 


## Questions and Feedback

Please ask questions or provide feedback on the items above above either via email to [oscal@fedramp.gov](mailto:oscal@fedramp.gov), as a comment to an existing [issue](https://github.com/GSA/fedramp-automation/issues), or as a new [issue](https://github.com/GSA/fedramp-automation/issues).


## Dependencies and OSCAL resources

FedRAMP's work is based on NIST's [OSCAL 1.1.2](https://github.com/usnistgov/OSCAL/releases/tag/v1.1.2), and requires an understanding of the core OSCAL syntax, as well as NIST-provided resources to function correctly. As such, we have provided NIST-produced OSCAL resources below. 

**IMPORTANT**: As NIST makes minor syntax updates and releases new versions, please review [the NIST OSCAL release notes](https://pages.nist.gov/OSCAL/reference/release-notes/) in addition to guides here for more information about these changes.

## Developer notes

This section is for prospective contributors to our automation efforts. As an open source project, fedramp-automation welcomes contributions. To see a detailed guide for contributors, go [here](./CONTRIBUTING.md)
<details>
<summary>How to build/test our tools</summary>

### Build / test

A top-level Makefile is provided to simplify builds.

Build requirements are:

- gnu make
- node.js (as versioned in [./nvmrc](./.nvmrc))
- Java 11+
- Docker

For usage information, use the default target:

```
make
```

If you are developing on Windows, [msys2](https://www.msys2.org/) may be used for the required build tools (`make` and `bash`, in particular). Follow all the suggested installation steps on the msys2 home page for a complete environment. Additionally, make sure all the build requirements (above) are available on your path.
</details>


## OSCAL Deprecation Strategy

This section details the version of OSCAL our tooling supports. 
<details>

FedRAMP has [a release strategy and versioning procedure](./documents/adr/0002-git-release-version-strategy.md). FedRAMP has a minimally supported version of OSCAL, unless explicitly noted otherwise in specific documents or source code in this repository. Data, software, and documentation in this repository will only support digital authorization package documents with a version number no lower than specified by FedRAMP version tags. A version tag that ends in `-oscal2.0.0` will only support data with `oscal-version` equal to `2.0.0` or newer, it will not support `1.0.1`, `1.0.2`, `1.0.3`, `1.0.4`, etc. A future version tag ending in `-oscal1.1.0` indicates FedRAMP source code and guides will support data with `oscal-version` equal to `1.1.0` or newer, but not `1.0.0`.

Changes to the minimally supported version and deprecation notices will be made in advance of a release.

This repository is for the development and enhancement of OSCAL artifacts only. For issues with the [Word and Excel-based templates and artifacts on the fedramp.gov site](https://www.fedramp.gov/documents-templates/), please send requests to [info@fedramp.gov](mailto:info@gfedramp.gov).

</details>