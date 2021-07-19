# 4. Incorporate XSLT Function Library into Schematron-based Validations

Date: 2021-05-17

## Status

Accepted

## Context

Per [ADR 2](docs/adr/0002-xml-schematron-usage.md), this team uses Schematron to validate document schema. Schematron can define and validate constraints beyond the syntactic layer of a grammar. It can analyze semantic constraints, i.e. business rules. Syntax constructs are built into a language, and lower-level validation (XSD and other lower level mechanisms) reduce boilerplate and standardize constructs. Business rule constructs are, on the other hand, often redundant and not internalized because they must be composed by syntax that cannot be defined with grammatical syntax alone. Therefore, many Schematron validations require redundant code. Additionally, Schematron is traditionally structured to separate location and test logic (because the location defined in the `context` with XPath queries and the `assert` and/or `report` statements, using the XSLT Query Language Binding are defined separately). The focus of Schematron validations in the XML document context, not comparison across multiple XML data sources and inline comparison of the XML document in context concurrently across multiple XML data sources.

Developers can improve concurrent processing of a document in Schematron against multiple XML data sources dynamically if they apply [the Don't Repeat Yourself (DRY) Principle](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself). Schematron is limited by its own domain-specific language, which is a subset of XSLT, and its requirement to support XSLT as a required Query Language Binding (per [Schematron/schematron#42](https://github.com/Schematron/schematron/issues/42)).

## Decision

This project will embed XSLT utility functions inside the Schematron definitions to support dynamic loading of configuration data at runtime and to not repeat common, repeated procedures found in FedRAMP validation business logic. This approach, although unorthodox, is supported by the Schematron specification and original Schematron "skeleton" runtime. This approach was first tested and validated in prototype work in [18F/fedramp-automation#26](https://github.com/18F/fedramp-automation/pull/26).
## Consequences

This architectural decision has several consequences.

- The Schematron specification implies this requirement, and further XSLT usage increases DRY goals without further complicating the current build process (more XSLT in, more XSLT out, no more modification needed).
- The resulting XSLT stylesheet will transpile to the same target language.
- Developers can continue to leverage familiarity with XPath and XSLT. There is no need to learn additional syntax or tooling.
- The same build output allows developers to use the same debugging techniques they were using prior.