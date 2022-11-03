<img src='./assets/FedRAMP_LOGO.png' alt="FedRAMP" width="76" height="94"><br />
# Federal Risk and Authorization Management Program (FedRAMP) Automation

## OSCAL Guides and Templates

The FedRAMP Program Management Office (PMO) has drafted FedRAMP-specific extensions and guidance to ensure our stakeholders can fully express a FedRAMP Security Authorization Package using NIST's [OSCAL SSP syntax](https://pages.nist.gov/OSCAL/documentation/).

To accompany these guides, the FedRAMP PMO has also drafted OSCAL files in XML and JSON formats to serve as an example and template for each major deliverable.

## Support and OSCAL Deprecation Strategy

The FedRAMP PMO has [a release strategy and versioning procedures](./documents/adr/0002-git-release-version-strategy.md). FedRAMP has a minimally supported version of OSCAL, unless explicitly noted otherwise in specific documents or source code in this repository. Baselines, guides, templates, and associated tools in this repository will only support OSCAL data with a version number no lower than specified by FedRAMP version tags. A version tag that ends in `-oscal1.0.0` will only support data with `oscal-version` equal to `1.0.0` or newer, it will not support `1.0.0-milestone3`, `1.0.0-rc1`, or `1.0.0-rc2`. A future version tag ending in `-oscal1.1.0` indicates FedRAMP source code and guides will support data with `oscal-version` equal to `1.1.0` or newer, but not `1.0.0`.

Changes to the minimally supported version and deprecation notices will be made in advance of a release.

This repository is for the development and enhancement of OSCAL artifacts only. For issues with the [Word and Excel-based templates and artifacts on the fedramp.gov site](https://www.fedramp.gov/documents-templates/), please send requests to [info@fedramp.gov](mailto:info@gfedramp.gov).

## We Want Your Feedback!

The FedRAMP PMO is releasing the following files for public review and comment:

- **FedRAMP Baselines:** The FedRAMP baselines for High, Moderate, Low, and Tailored for Low Impact-Software as a Service (LI-SaaS) in OSCAL (XML and JSON formats) are available [here](./dist/content/rev4/baselines).

- **FedRAMP OSCAL Templates:** The template files are pre-populated with FedRAMP extensions, defined-identifiers, and conformity tags where practical. They also include sample data, and are the basis for their respective guidance documents above. The drafts for public comment are available in both XML and JSON formats [here](./dist/content/rev4/templates/).

- **FedRAMP OSCAL Registry** This registry is the authoritative source for all FedRAMP extensions to the OSCAL syntax, FedRAMP-defined identifiers, and accepted values. The draft for public comment is available [here](./documents/FedRAMP_Extensions.pdf).

- **Implementation Guides:** These documents enables tool developers to generate OSCAL-based FedRAMP deliverabes that are fully compliant with FedRAMP’s extensions, defined identifiers, conformity tags, and acceptable values. The drafts for public comment are available [here](./documents/).

Please ask questions or provide feedback on the items above above either via email to [oscal@fedramp.gov](mailto:oscal@fedramp.gov), as a comment to an existing [issue](https://github.com/GSA/fedramp-automation/issues), or as a new [issue](https://github.com/GSA/fedramp-automation/issues).

## Dependencies

FedRAMP's work is based on NIST's [OSCAL 1.0.0](https://github.com/usnistgov/OSCAL/releases/tag/v1.0.0), and requires an understanding of the core OSCAL syntax, as well as NIST-provided resources to function correctly.

**IMPORTANT**: NIST has made minor syntax updates since releasing `1.0.0-rc2`, which are also reflected in these guides. Please review [the NIST OSCAL release notes](https://pages.nist.gov/OSCAL/reference/release-notes/) in addition to guides here for more information about these changes.

The following NIST resources are available:
- **NIST's Main OSCAL Site:** [https://pages.nist.gov/OSCAL/](https://pages.nist.gov/OSCAL/)

- **NIST's OSCAL GitHub Repository:** [https://github.com/usnistgov/OSCAL](https://github.com/usnistgov/OSCAL)

- **OSCAL Workshop Training Slides:** Provided at an October workshop hosted by the NIST OSCAL Team. The early portions of the deck provide an overview, with more technical details beginning on slide 52. [https://pages.nist.gov/OSCAL/downloads/OSCAL-workshop-20191105.pdf](https://pages.nist.gov/OSCAL/learn/presentations/OSCAL-workshop-20191105.pdf)

- **Content Converters:** The converters accurately convert OSCAL catalog, profile, SSP, SAP, SAR, and POA&M content from [XML to JSON](https://github.com/usnistgov/OSCAL/tree/master/json/convert) and [JSON to XML](https://github.com/usnistgov/OSCAL/tree/master/xml/convert).

- **NIST SP 800-53 & 53A Revision 4 in OSCAL:** NIST is also providing SP 800-53 and 800-53A, Revision 4 content as well as the NIST High, Moderate, and Low baselines in OSCAL (XML, JSON, and YAML formats) [here](https://github.com/usnistgov/OSCAL/tree/master/content/nist.gov/SP800-53/rev4).

NIST offers a complete package containing the NIST OSCAL converters, syntax validation tools, 800-53 and FedRAMP baselines content is available for download in both ZIP and BZ2 format. Visit the [NIST OSCAL Github releases page for more information](https://github.com/usnistgov/OSCAL/releases/latest).

Please ask questions or provide feedback on the above NIST dependencies either via email to [oscal@nist.gov](mailto:oscal@nist.gov), as a comment to an existing issue, or as a new issue via the [NIST OSCAL GitHub site](https://github.com/usnistgov/OSCAL/issues).

FedRAMP looks forward to receiving your comments and sharing additional progress.

## Rules documentation

Complete documentation for each validation rule is available, and is bundled with each official release. The documentation provides a browsable list of each validation rule, as well as the ability to validate FedRAMP OSCAL documents in-browser.

See [./src/web](./src/web) for details on how to build and run locally.

![Web documentation screenshot](./src/web/screenshot.png)

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

### Implementation details

FedRAMP automation is composed of the following implementation details:

- [Validation rules](./src/validations/README.md) are implemented in Schematron with xspec test coverage.
- [Validation rules web documentation](./src/web/README.md) provides a browser of implemented validation rules and may be used to validate FedRAMP OSCAL documents in-browser. A deployed version is available here: [FedRAMP ASAP Validation Documentation](https://federalist-b6c4d61f-facd-4833-a4a9-554523a87147.sites.pages.cloud.gov/site/gsa/fedramp-automation/)
- [Example code](./src/examples/README.md) is provided to demonstrate how to apply the validation rules using the compiled-XSLT artifact in selected languages.

### Creating a release

[ADR 0002 (git release version strategy)](./documents/adr/0002-git-release-version-strategy.md)
outlines the release and versioning system.

Releases must be tagged from the master branch of [GSA/fedramp-automation](https://github.com/GSA/fedramp-automation). If your work resides elsewhere, first merge to master via a pull-request.

To produce a release:

- [Create a Github Release](https://github.com/GSA/fedramp-automation/releases/new)
  - Ensure the tag follows the naming convention defined in [ADR 0002](./documents/adr/0002-git-release-version-strategy.md)
- [Monitor running Github Actions](https://github.com/GSA/fedramp-automation/actions) for the `build-release` workflow's completion ([./.github/workflows/create-release.yml](./.github/workflows/create-release.yml))
  - On completion, artifacts will be attached to the release.
