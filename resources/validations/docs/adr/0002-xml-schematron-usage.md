# 2. Use Schematron DSL for rule development

Date: 2021-05-16

## Status

Accepted

## Context

At the onset of the project, FedRAMP technical staff collaborated with the NIST OSCAL developers to assess the viability and methods to validate OSCAL system security plans (and other objects) against FedRAMP standards. Developers performed proof-of-concept development activites in spikes in 

- [usnistgov/OSCAL#271](https://github.com/usnistgov/OSCAL/issues/271)
- [usnistgov/OSCAL#272](https://github.com/usnistgov/OSCAL/issues/271)
- [GSA/fedramp-automation#56](https://github.com/GSA/fedramp-automation/issues/56)

The OSCAL information models are serialized into JSON, XML, and YAML data models, but the core NIST OSCAL developer team and early community adopters were most comfortable and familiar with the XML ecosystem. In addition to the XSLT unit test suite, the OSCAL code base has limited, targeted use of [Schematron](https://github.com/Schematron/schematron) for core syntax validation of OSCAL primitives. Additionally, it is used for [the Metaschema toolchain](https://pages.nist.gov/metaschema/) that underlies the OSCAL development pipeline.

Due to said familiarity of the NIST developers with XML ecosystem, the NIST and FedRAMP teams committed to prototype development in time-boxed spikes in early 2019. The teams exchanged XSLT stylesheets and explored the viability of Schematron, but the FedRAMP and NIST developers stopped development on MVP prototypes as other priorities arose in core OSCAL development.

Following this exploratory development, the FedRAMP team briefed the [10x](10x.gsa.gov) research team assigned to work [on the second phase of their pitch idea, RPA for SSPs](https://trello.com/c/2be80rHb/89-automated-security-authorization-processing-asap). The FedRAMP team recommended the 10x developers review previous work and recommendations on XML and Schematron-based validations given initial prototyping.

## Decision

The 10x team reviewed previous prototype efforts and recommendations. They prototyped their own Schematron validation pipeline. The development team will continue using Schematron and XSLT for their development of the FedRAMP validations. 

## Consequences

- The FedRAMP validations will easy integrate and inter-operate with the OSCAL XML development toolchain.
- FedRAMP will need to refine a consistent structuring of informational, warning, and error messaging in validation output in [the Schematron Validation Reporting Language data format](https://github.com/schematron/schema).
- Downstream developers and consumers of the validations must rely to the round-tripping JSON to XML converters (as the JSON data models are more popular based on developer community feedback).
