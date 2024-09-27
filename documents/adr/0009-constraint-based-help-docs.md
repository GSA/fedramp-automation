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
1. Always embed help text directly into the constraints themselves for interpolation into SARIF results, in the `message` field or some other SARIF element, by use of the existing Metachema `message` element in each constraint.
1. Always embed help text directly into the constraints themselves for interpolation into SARIF results, in the `message` field or some other SARIF element, by use of a mandatory Metachema property in each constraint.
1. Allow for Metaschema properties to optionally define a URL for help information, text for help information without formatting, and/or formatted Markdown text for help information to interpolate into SARIF results.
1. Always embed a new custom Metaschema assembly, `help`, with its own custom nested fields and flags, and enhance Metaschema specification and tools to interpolate that data into SARIF results.

## Decision

What is the change that we're proposing and/or doing?

## Consequences

What becomes easier or more difficult to do because of this change?
