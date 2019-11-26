<img src='./assets/FedRAMP_LOGO.png' alt="FedRAMP" width="76" height="94"><br />
# Federal Risk and Authorization Management Program (FedRAMP) Automation
### Based on the Open Security Controls Assessment Language (OSCAL)


## November 27, 2019

The FedRAMP Program Management Office (PMO) has drafted FedRAMP-specific extensions and guidance to ensure our stakeholders can fully express a FedRAMP System Security Plan (SSP) using NIST's [OSCAL SSP syntax](https://pages.nist.gov/OSCAL/documentation/schema/ssp/).


## We Want Your Feedback!
The FedRAMP PMO is releasing the following files for public review and comment:
- **FedRAMP OSCAL Registry:** This registry is the authoritative source for all FedRAMP extensions to the OSCAL syntax, FedRAMP-defined identifiers, and accepted values. The draft for public comment is available [here](https://github.com/GSA/fedramp-automation/raw/master/documents/FedRAMP_OSCAL_Registry.xlsx).
- **Guidance Document:** Modeling a FedRAMP SSP in OSCAL: This document enables tool developers to generate OSCAL-based SSP files that are fully compliant with FedRAMP’s extensions, defined identifiers, and acceptable values. The draft for public comment is available [here](https://github.com/GSA/fedramp-automation/raw/master/documents/Modeling_a_FedRAMP-SSP_in_OSCAL.pdf).
- **OSCAL-based FedRAMP SSP Template:** The template file is pre-populated with FedRAMP extensions and defined-identifiers where practical. It also includes some sample data, and is the basis for the guidance document above. The draft for public comment is available in both [XML](https://github.com/GSA/fedramp-automation/raw/master/templates/FedRAMP-SSP-OSCAL-Template.xml) and [JSON](https://github.com/GSA/fedramp-automation/raw/master/templates/FedRAMP-SSP-OSCAL-Template.json) formats.
- **FedRAMP Baselines:** The FedRAMP baselines for High, Moderate, Low, and Tailored for Low Impact-Software as a Service (LI-SaaS) in OSCAL (XML, JSON, and YAML formats) are available [here](https://github.com/usnistgov/OSCAL/tree/master/content/fedramp.gov). 

To provide feedback for the items above please create or add an [issue](https://github.com/GSA/fedramp-automation/issues), or send comments via email to [info@fedramp.gov](mailto:info@fedramp.gov).


## Dependencies

FedRAMP's work is based on NIST's [OSCAL 1.0.0-Milestone2 release](https://github.com/usnistgov/OSCAL/releases/tag/v1.0.0-milestone2), and requires an understanding of the core OSCAL syntax, as well as NIST-provided resources to functon correctly.

The following NIST resources are available:
- **NIST's Main OSCAL Site:** [https://pages.nist.gov/OSCAL/](https://pages.nist.gov/OSCAL/)
- **NIST's OSCAL GitHub Repository:** [https://github.com/usnistgov/OSCAL](https://github.com/usnistgov/OSCAL)
- **OSCAL Workshop Training Slides:** Provided at an October workshop hosted by the NIST OSCAL Team. The early portions of the deck provide an overview, with more technical details beginning on slide 52.


- **Content Converters:** The converters accurately convert OSCAL catalog, profile, and SSP content from XML to JSON format and JSON to XML. 

- **NIST’s 800-53 & 53A Revision 4:** NIST is also providing SP 800-53 and 800-53A, Revision 4 content as well as the NIST High, Moderate, and Low baselines in OSCAL (XML, JSON, and YAML formats) here. 

NIST offers a complete package containing the NIST OSCAL converters, syntax validation tools, 800-53 and FedRAMP baselines content is available for download in both [ZIP](https://github.com/usnistgov/OSCAL/releases/download/v1.0.0-milestone2/oscal-1.0.0-milestone2.zip) and [BZ2](https://github.com/usnistgov/OSCAL/releases/download/v1.0.0-milestone2/oscal-1.0.0-milestone2.tar.bz2) formats. 

Please provide questions and feedback on the above NIST dependencie either via email to [oscal@nist.gov](oscal@nist.gov), as a comment to an existing issue, or as a new issue via the [NIST OSCAL GitHub site](https://github.com/usnistgov/OSCAL/issues).


### FedRAMP looks forward to receiving your comments and sharing additional progress.




