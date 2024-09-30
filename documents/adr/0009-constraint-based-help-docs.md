# 9. Add URL Hints to Metaschema Constraints for SARIF-Based Constraint Results Output

Date: 2024-09-26

## Status

Proposed

## Context

Currently, the FedRAMP Automation Team provides [the machine-readable rules for OSCAL-based FedRAMP digital authorization packages](https://github.com/GSA/fedramp-automation/blob/2974ae32195263b5a33d641e35854b58f675e18d/src/validations/constraints/fedramp-external-constraints.xml) in [the Metaschema constraint format](https://pages.nist.gov/metaschema/specification/syntax/constraints/). They also maintain supporting documentation at [automate.fedramp.gov](https://automate.fedramp.gov) separately.

The team's developers, and the community of downstream developer and engineers building software for stakeholders in the FedRAMP ecosystem, must manually cross-reference that documentation if they wish to use the [`oscal-cli`](https://github.com/metaschema-framework/oscal-cli) and constraints' result output to inform changes to target content. This tool, using the constraints, will emit the information in [the SARIF format](https://docs.oasis-open.org/sarif/sarif/v2.1.0/sarif-v2.1.0.html) and emit a constraint's `message` element, but not additional metadata.

This decision record proposes a solution to add machine-readable metadata to FedRAMP's constraints to always complement a failing constraint's `message` field with a URL to the official documentation.

## Possible Solutions

There are multiple approaches for the team and larger community to consider.

1. Do nothing, keep the development and use of constraints as-is, encourage users to manually reference documentation to help correct or improve OSCAL-based content for FedRAMP packages.

1. Always embed help text directly into the constraints themselves for interpolation into SARIF results, in the `message` field or some other SARIF element, by use of the existing Metaschema `message` element in each constraint.

1. Always embed help text directly into the constraints themselves for interpolation into SARIF results, in the `message` field or some other SARIF element, by use of a mandatory Metaschema property in each constraint.

1. Allow for Metaschema properties to optionally define a URL for help information, text for help information without formatting, and/or formatted Markdown text (conformant with the [CommonMark specification, as required by the Metaschema specification](https://pages.nist.gov/metaschema/specification/datatypes/#markup-data-types)) for help information to interpolate into SARIF results. Require one, some, or all of these properties in a constraint style guide per [GSA/fedramp-automation#675](https://github.com/GSA/fedramp-automation/issues/675).

1. Always embed a new custom Metaschema assembly, `help`, with its own custom nested fields and flags, and enhance Metaschema specification and tools to interpolate that data into SARIF results.

## Decision

The team proposes Solution 4. To implement this solution, we will commit to steps below.

1. The FedRAMP Team will request the maintainers of [metaschema-java](https://github.com/metaschema-framework/metaschema-java) and [oscal-cli](https://github.com/metaschema-framework/oscal-cli) to implement code to map props `help-url`, `help-text`, and `help-markdown` to the SARIF `helpUri` and `help` fields for constraints result outputs. The team will tunnel formatted help text data in Markdown syntax in a `prop`'s `value` with its current `string` data type as-is. We will _not_ propose a change to change its type or request an alternate Metschema structure to support inline Markdown with a [`markup-multiline`](https://pages.nist.gov/metaschema/specification/datatypes/#markup-data-types).

2. After Step 1 is complete, A FedRAMP constraint style guide should recommend or require the use of `help-url`, `help-text`, and `help-markdown` props. Below is an example of how these properties can look in an example constraints files.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1">
                <prop namespace="https://docs.oasis-open.org/sarif/sarif/v2.1.0" name="help-url" value="https://automate.fedramp.gov/documentation/ssp/4-ssp-template-to-oscal-mapping/#data-center"/>
                <prop namespace="https://docs.oasis-open.org/sarif/sarif/v2.1.0" name="help-text" value="Data centers must have a country. Only certain countries allowed. See the list below: Country 1; Country 2; Country 3."/>
                <prop namespace="https://docs.oasis-open.org/sarif/sarif/v2.1.0" name="help-markdown" value="# Data Center Requirements\nData centers must have a country.\nOnly certain countries allowed.\nSee the list below.\n- Country 1\n - Country 2\n - Country 3\n\n"/>
                <message>Each data center address must contain a country code.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

3. The team will backport the props, as required by the style guide completed for Step 2, to existing constraints and correct and enhance documentation at [automate.fedramp.gov](https://automate.fedramp.gov) accordingly to deep-link to precise information for each constraint. New constraints will add these props to be successfully reviewed and merged in the team's normal development cycle.

## Consequences

There are positive and negative impacts to each of the five solutions above. Below is a summary analysis for each solution, weighing the pros and cons of each approach.

1. This approach has the lowest risk and effort for the FedRAMP Automation Team and maintainers of tool and data dependencies. However, it assures increased effort for developers of FedRAMP software and amplifies that same effort on downstream stakeholders who understand program requirements through those tools. This effort and friction will increase as the number of constraints increases over time. Operationally, tools will operate as they currently do at the time of this writing, so there will be no change in speed or performance characteristics of the tools.

1. This approach requires moderate effort for FedRAMP Automation Team developers maintaining constraints and developers of software for the FedRAMP ecosystem. The former will have to carefully edit new and existing constraints to track inserting additional information into the `message` field of a constraint. Downstream developers of software for the FedRAMP ecosystem will have to customize their tools to parse each message and extract different kinds of error information from the Metaschema modules or SARIF output without consistency and added complexity. It will, however, require little to no additional effort for maintainers of data and tool dependencies. Operationally, this may increase the size of constraint files and resulting results output in SARIF if guidance requires them to be output in all cases.

1. This approach requires a nominal increase in effort for FedRAMP Automation Team developers, but for certain edge cases complicates design and implementation as such a property will be required. It will also cause a nominal increase in effort developers of software for the FedRAMP ecosystem, but give them a consistent way to extract necessary help documentation without ad-hoc parsing of the message field. Operationally, this approach will increase the size of constraint files and may increase resulting results output in SARIF if guidance requires them to be output in all cases.

1. This approach requires a nominal increase in effort for FedRAMP Automation Developers, but unlike the approach in Solution 3, allows flexibility to provide help text by URL address, unformatted text, or more complex help text with Markdown formatting. For developers of software for the FedRAMP ecosystem, it provides full flexibility to consider a progressive downgrade or upgrade path to help text by looking solely at fields in the already standardized SARIF results output. For developers of tool dependencies, and to a lesser extent data, this change will not require changes for processing constraint inputs, but does require adding to likely existing functionality to map constraint inputs to fields in the SARIF standard for result output. Operationally, this approach may have a minor impact on speed and other performance characteristics of tools that process constraints and generate result output. However, this approach provides multiple options can allow for multiple approaches in constraints files to decrease size or increase them accordingly for solutions without access to help text addresses. This flexibility will benefit stakeholders using the software to understand FedRAMP requirements for different use cases.

1. This approach, although like Solution 4, does benefit FedRAMP Automation Team developers maintaining constraints, developers of software for the FedRAMP ecosystem, and downstream stakeholders using that software in similar ways, it will place more burden on dependency maintainers who make Metaschema-based constraint tooling. The Metaschema specification will also need to be updated, further delaying the delayed for design and implementation. So although it is similar to Solution 4, it will increase delay.
