# FedRAMP OSCAL System Security Plan Validation Rules

FedRAMP business rules have been inferred from 
FedRAMP documents, 
FedRAMP OSCAL SSP documentation, 
and interviews.

FedRAMP business rules are expected to undergo change over time. It is hoped, and expected, that this manner
of business rule definition and elaboration can be used to maintain both business rules and the
related code for automated validation thereof.

## Related Documents

### rules.xml

The [`rules.xml`](rules.xml) document defines business rules for FedRAMP SSPs.
These are cast as English prose assertions. References to related FedRAMP documentation are present when possible.

### rules.xsd

The [`rules.xsd`](rules.xsd) document defines an [XML Schema](https://www.w3.org/TR/xmlschema11-1/) definition
for `rules.xml` syntax.

### rules.xsl

[`rules.xsl`](rules.xsl) is an XSL transform which combines `rules.xml` with `ssp.sch` to produce an HTML5
document describing the structured rules and related Schematron assertions.

### rules.css

[`rules.css`](rules.css) is a companion CSS document used by `rules.xsl`.

### ssp.sch

[`ssp.sch`](ssp.sch) is a document containing Schematron assertions which enable automated validation
of FedRAMP OSCAL System Security Plans.

The primary Schematron elements are `pattern`, `rule`, and `assert`.

A Schematron `pattern` element allows Schematron `rule` elements to be grouped together.

Schematron `rule` elements specify a context - a locus within an XML document for which subordinate assertions apply.

Schematron `assert` elements specify a natural language assertion - i.e., a desired state - and a corresponding test.

fedramp-automation requires that each Schematron `assert` specifies

- An `id` attribute which is required for related unit tests cast in the XSPec language.
- A `role` attribute specifying the relative import of a failed test: information, warning, error, fatal.
- A `test` attribute which is an XPath statement evaluated in the context of the parent `rule`.
- The body of an `assert` contains a natural language assertion describing the **desired** outcome of the test.
- A `diagnostics` attribute identifying one or more messages associated with a negative assertion outcome.

fedramp-automation extends Schematron with some additional constructs.

- Documentation references.
- Additional affirmative and negative messages per `assert` appropriate for different venues of presentation, such as FedRAMP review and FedRAMP submission.

