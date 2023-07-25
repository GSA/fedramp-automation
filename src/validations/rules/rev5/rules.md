# FedRAMP OSCAL System Security Plan Validation Rules

FedRAMP business rules have been inferred from FedRAMP documents, FedRAMP OSCAL SSP documentation, and interviews.

FedRAMP business rules are expected to undergo change over time. It is hoped, and expected, that this manner of business rule definition and elaboration can be used to maintain both business rules and the related code for automated validation thereof.

## Related Documents

### rules.xml

The [`rules.xml`](rules.xml) document defines business rules for FedRAMP SSPs. These are cast as English prose assertions. References to related FedRAMP documentation are present when possible.

### rules.xsd

The [`rules.xsd`](rules.xsd) document is an [XML Schema](https://www.w3.org/TR/xmlschema11-1/) definition
for `rules.xml` syntax.

### rules.xsl

[`rules.xsl`](rules.xsl) is an [XSL Transform](https://www.w3.org/TR/xslt-30/) which combines `rules.xml` with `ssp.sch` to produce an HTML5 document describing the structured rules and related Schematron assertions.

### rules.css

[`rules.css`](rules.css) is a companion [CSS](https://www.w3.org/Style/CSS/) document used by `rules.xsl`.

### ssp.sch

[`ssp.sch`](ssp.sch) is a document containing [Schematron](https://schematron.com/) assertions which enable automated validation of FedRAMP OSCAL System Security Plans.

The primary Schematron elements are `pattern`, `rule`, and `assert`.

A Schematron `pattern` element allows Schematron `rule` elements to be grouped together.

Schematron `rule` elements specify a context - a locus within an XML document for which subordinate assertions apply - specified in [XPath](https://www.w3.org/TR/xpath-31/).

Schematron `assert` elements specify a natural language assertion - i.e., a desired state - and a corresponding test.

fedramp-automation requires that each Schematron `assert` element specifies

- An `id` attribute which is required for related unit tests cast in the [XSpec](https://github.com/xspec/xspec) language.
- A `role` attribute specifying the relative import of a failed test: information, warning, error, fatal.
- A `test` attribute which is an [XPath](https://www.w3.org/TR/xpath-31/) statement evaluated in the context of the parent `rule`.
- The body of an `assert` contains a natural language assertion describing the **desired** (positive) outcome of the test.
- A `diagnostics` attribute identifying a diagnostic message associated with a negative assertion outcome.

fedramp-automation extends Schematron with some additional constructs.

- Additional attributes on assertions for documentation references.
- Additional attributes on the `diagnostic` element which refer to the related assertion's test and context.
- A reference to the related unit test document.

### ssp.xspec

[`ssp.xspec`](../test/ssp.xspec) contains unit tests for assertions in `ssp.sch`. The unit tests are written in [XSpec](https://github.com/xspec/xspec).

### sch.sch

[`sch.sch`](../styleguides/sch.sch) is a set of Schematron assertions which can be employed to enforce FedRAMP Schematron coding rules (such as in a schema-driven editor).
