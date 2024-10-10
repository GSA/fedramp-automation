<img src="https://github.com/GSA/fedramp-automation/raw/master/assets/FedRAMP_LOGO.png" alt="FedRAMP" width="76" height="94"><br />

# Federal Risk and Authorization Management Program (FedRAMP) Automation

## Overview

The FedRAMP Program Management Office (PMO), has drafted FedRAMP specific tooling and guidance to ensure our stakeholders can fully express and review their FedRAMP Security Authorization Packages using NIST’s [OSCAL SSP syntax](https://pages.nist.gov/OSCAL/documentation/).

In addition to guides and examples assisting in the production of OSCAL artifacts, the FedRAMP PMO is developing software to assist in automating the review of OSCAL (Open Security Controls Assessment Language) digital authorization packages. The primary aim is to reduce manual review efforts by validating whether submissions conform to FedRAMP’s requirements. While the project is still in development, once completed, it will help ensure that packages such as System Security Plans (SSPs) and Plans of Action and Milestones (POA&Ms) meet FedRAMP's expectations before submission, helping to streamline the review process.

## Project Components

| Component                                                       | Description                                                                        |
| ---------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| [FedRAMP OSCAL Validation Tooling](./tree/develop/src/validations/constraints) | The folder that contains the validation tooling and constraints      |
| [FedRAMP Rev 5 Releases](/tree/master/dist/content/rev5)         | The folder that contains guidance and examples related to rev5                     |

## FedRAMP OSCAL Validation Tooling

Our ongoing work is focused on developing automated validation tooling to check that all required elements are present. To learn more about installing and using our validation tooling, go [here](https://github.com/GSA/fedramp-automation/blob/develop/src/validations/constraints/README.md). 

FedRAMP OSCAL Constraints will be processed through the oscal-cli tool, which:
- Validates OSCAL documents against FedRAMP constraints.
- Identifies compliance with FedRAMP requirements.
- Outputs a SARIF report, detailing both passed and failed validations.
This tooling is intended for use by FedRAMP OSCAL implementers and practitioners, Cloud Service Providers (CSPs), OSCAL tool developers, 3rd Party Assessment Organizations (3PAOs), and federal agencies. We welcome any and all feedback. 


## FedRAMP OSCAL Rev 5 Releases:

The FedRAMP PMO has released the following OSCAL content:

- **FedRAMP Baselines:** The FedRAMP rev 5 baselines for High, Moderate, Low, and Tailored for Low Impact-Software as a Service (LI-SaaS) in OSCAL (XML and JSON formats) are available [here](./dist/content/rev5/baselines).

- **FedRAMP OSCAL Templates:** The template files are pre-populated with FedRAMP extensions, defined-identifiers, and conformity tags where practical. They also include sample data, and are the basis for their respective guidance documents above. The FedRAMP OSCAL SSP, SAP, SAR, and POA&M template are now available [here](./documents/) in XML, JSON, and YAML formats.

- **FedRAMP OSCAL Registry** This registry is the authoritative source for all FedRAMP extensions to the OSCAL syntax, FedRAMP-defined identifiers, and accepted values. The FedRAMP OSCAL Registry is now available [here](./dist/content/rev5/resources) in XML format.

- **Implementation Guides:** These documents help tool developers and content authors ensure any generated OSCAL-based FedRAMP deliverabes are fully compliant with FedRAMP’s extensions, defined identifiers, conformity tags, and acceptable values. The FedRAMP OSCAL implementation guides is now available [here](./documents/) in PDF format.

## Questions and Feedback

Please ask questions or provide feedback on the items above above either via email to [oscal@fedramp.gov](mailto:oscal@fedramp.gov), as a comment to an existing [issue](https://github.com/GSA/fedramp-automation/issues), or as a new [issue](https://github.com/GSA/fedramp-automation/issues).


## Dependencies

FedRAMP's work is based on NIST's [OSCAL 1.1.2](https://github.com/usnistgov/OSCAL/releases/tag/v1.1.2), and requires an understanding of the core OSCAL syntax, as well as NIST-provided resources to function correctly.

**IMPORTANT**: As NIST makes minor syntax updates and releases new versions, please review [the NIST OSCAL release notes](https://pages.nist.gov/OSCAL/reference/release-notes/) in addition to guides here for more information about these changes.

The following NIST resources are available:
- **NIST's Main OSCAL Site:** [https://pages.nist.gov/OSCAL/](https://pages.nist.gov/OSCAL/)

- **NIST's OSCAL GitHub Repository:** [https://github.com/usnistgov/OSCAL](https://github.com/usnistgov/OSCAL)

- **OSCAL Workshop Training Slides:** Videos and content from NIST's annual OSCAL Conference and Workshop are available at [https://pages.nist.gov/OSCAL/learn/presentations/](https://pages.nist.gov/OSCAL/learn/presentations)

- **Content Converters:** The converters accurately convert OSCAL catalog, profile, SSP, SAP, SAR, and POA&M content from [XML to JSON](https://github.com/usnistgov/OSCAL/tree/master/json/convert) and [JSON to XML](https://github.com/usnistgov/OSCAL/tree/master/xml/convert).

- **NIST SP 800-53 & 53A Revision 5 in OSCAL:** NIST is also providing SP 800-53 and 800-53A, Revision 5 content as well as the NIST High, Moderate, and Low baselines in OSCAL (XML, JSON, and YAML formats) [here](https://github.com/usnistgov/oscal-content/tree/main/nist.gov/SP800-53/rev5).

NIST offers a complete package containing the NIST OSCAL converters, syntax validation tools, 800-53 and FedRAMP baselines content is available for download in both ZIP and BZ2 format. Visit the [NIST OSCAL Github releases page for more information](https://github.com/usnistgov/OSCAL/releases/latest).

Please ask questions or provide feedback on the above NIST dependencies either via email to [oscal@nist.gov](mailto:oscal@nist.gov), as a comment to an existing issue, or as a new issue via the [NIST OSCAL GitHub site](https://github.com/usnistgov/OSCAL/issues).

FedRAMP looks forward to receiving your comments and sharing additional progress.

## Developer notes

### Build / test

A top-level Makefile is provided to simplify builds.

Build requirements are:

- gnu make
- node.js (as versioned in [./nvmrc](./.nvmrc))
- Java 8+
- Python 3.9+
- Docker

For usage information, use the default target:

```
make
```

If you are developing on Windows, [msys2](https://www.msys2.org/) may be used for the required build tools (`make` and `bash`, in particular). Follow all the suggested installation steps on the msys2 home page for a complete environment. Additionally, make sure all the build requirements (above) are available on your path.


### Creating a release

[ADR 0002 (git release version strategy)](./documents/adr/0002-git-release-version-strategy.md)
outlines the release and versioning system.

Releases must be tagged from the master branch of [GSA/fedramp-automation](https://github.com/GSA/fedramp-automation). If your work resides elsewhere, first merge to master via a pull-request.

To produce a release:

- [Create a Github Release](https://github.com/GSA/fedramp-automation/releases/new)
  - Ensure the tag follows the naming convention defined in [ADR 0002](./documents/adr/0002-git-release-version-strategy.md)
- [Monitor running Github Actions](https://github.com/GSA/fedramp-automation/actions) for the `build-release` workflow's completion ([./.github/workflows/create-release.yml](./.github/workflows/create-release.yml))
  - On completion, artifacts will be attached to the release.

## Support and OSCAL Deprecation Strategy

The FedRAMP PMO has [a release strategy and versioning procedures](./documents/adr/0002-git-release-version-strategy.md). FedRAMP has a minimally supported version of OSCAL, unless explicitly noted otherwise in specific documents or source code in this repository. Baselines, guides, templates, and associated tools in this repository will only support OSCAL data with a version number no lower than specified by FedRAMP version tags. A version tag that ends in `-oscal2.0.0` will only support data with `oscal-version` equal to `2.0.0` or newer, it will not support `1.0.1`, `1.0.2`, `1.0.3`, `1.0.4`, etc. A future version tag ending in `-oscal1.1.0` indicates FedRAMP source code and guides will support data with `oscal-version` equal to `1.1.0` or newer, but not `1.0.0`.

Changes to the minimally supported version and deprecation notices will be made in advance of a release.

This repository is for the development and enhancement of OSCAL artifacts only. For issues with the [Word and Excel-based templates and artifacts on the fedramp.gov site](https://www.fedramp.gov/documents-templates/), please send requests to [info@fedramp.gov](mailto:info@gfedramp.gov).
