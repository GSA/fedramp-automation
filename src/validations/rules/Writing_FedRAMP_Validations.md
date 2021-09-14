# How to create FedRAMP OSCAL validation constraints

FedRAMP OSCAL documents are structured XML documents. The document syntax is defined by OSCAL XML Schema. However, XML Schema cannot express many semantic constraints, and an additional schema language is employed: Schematron.

# Technologies used

- [XML](https://www.w3.org/standards/xml/) is a structered document langauge.
- [Namespaces in XML](https://www.w3.org/TR/xml-names/) are freqently encountered in structured XML documents
- [OSCAL](https://pages.nist.gov/OSCAL/) is used to define the several FedRAMP document types in a structured data form. NIST provides XML Schema documents for the various OSCAL document types.
- [Schematron](https://schematron.com/) is used to declare assertions for documents to be validated
- [XPath](https://www.w3.org/TR/xpath-31/) is used in Schematron to define rule contexts and assertion tests
- [XSpec](XSpec) is used to create unit tests for Schematron assertions
- [XSLT](https://www.w3.org/TR/xslt-30/) is used to manipulate XML documents, and is used to transpile Schematron documents into XSLT documents

# FedRAMP OSCAL References

FedRAMP has adopted and extended NIST OSCAL document types. These adaptations are documented in the GSA [fedramp_automation repository](https://github.com/GSA/fedramp-automation/tree/master/documents).

The pertinent normative documents are

-[Guide to OSCAL-based FedRAMP Content](./Guide_to_OSCAL-based_FedRAMP_Content.pdf)

-[Guide to OSCAL-based FedRAMP System Security Plans (SSP)](./Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf)

-[Guide to OSCAL-based FedRAMP Security Assessment Plans  (SAP)](./Guide_to_OSCAL-based_FedRAMP_Security_Assessment_Plans_(SAP).pdf)

-[Guide to OSCAL-based FedRAMP Security Assessment Reports (SAR)](./Guide_to_OSCAL-based_FedRAMP_Security_Assessment_Reports_(SAR).pdf)

-[Guide to OSCAL-based FedRAMP Plan of Action and Milestones (POA&M)](./Guide_to_OSCAL-based_FedRAMP_Plan_of_Action_and_Milestones_(POAM).pdf)

Each describes how FedRAMP expects each OSCAL document type is to be presented in an authorization package.

# FedRAMP validation constraints

FedRAMP validation constraints extend the NIST OSCAL XML Schema constraints. The XML Schema constraints are essentially syntactic; Schematron is used to augment the former with semantic constraints which cannot be expressed using XML Schema.

Schematron constraints have thus far been for system security plan documents. They are found in a Schematron document [`ssp.sch`](ssp.sch).

A companion document [`fedramp_values.xml`](../../dist/content/resources/xml/fedramp_values.xml) defines sets of allowed values for various FedRAMP OSCAL XML  elements and their attributes.

An additional Schmeatron document [`sch.sch`](../sch/sch.sch) defines constraints for the FedRAMP Schematron constraints themselves, guiding a FedRAMP constraint author to augment the fundamental Schematron with FedRAMP-specific constructs. These augmentations provide

- References to associated unit tests ([ssp.xspec](../test/ssp.xspec))
- References to documentation related to the constraint
- References to associated diagnostic messages
- Forward and reverse linkages between Schematron rules (`<rule>` elements), assertions (`<assert>` elements, and `<diagnostic>` elements.

# Examples of Schematron constraints

## Example 1

Consider the following code block:
```xml
<sch:rule
    context="oscal:system-characteristics">
    <sch:assert
        diagnostics="has-system-id-diagnostic"
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.1"
        doc:template-reference="System Security Plan Template §1"
        id="has-system-id"
        role="error"
        see="Guide to OSCAL-based FedRAMP System Security Plans §4.1"
        test="oscal:system-id[@identifier-type eq 'https://fedramp.gov']">A FedRAMP SSP must have a FedRAMP system identifier.</sch:assert>
    <sch:assert
        diagnostics="has-system-name-diagnostic"
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.1"
        doc:template-reference="System Security Plan Template §1"
        id="has-system-name"
        role="error"
        see="Guide to OSCAL-based FedRAMP System Security Plans §4.1"
        test="oscal:system-name">A FedRAMP SSP must have a system name.</sch:assert>
    <sch:assert
        diagnostics="has-system-name-short-diagnostic"
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.1"
        doc:template-reference="System Security Plan Template §1"
        id="has-system-name-short"
        role="error"
        see="Guide to OSCAL-based FedRAMP System Security Plans §4.1"
        test="oscal:system-name-short">A FedRAMP SSP must have a short system name.</sch:assert>
    <sch:let
        name="authorization-types"
        value="$fedramp-values//fedramp:value-set[@name eq 'authorization-type']//fedramp:enum/@value" />
    <sch:assert
        diagnostics="has-fedramp-authorization-type-diagnostic"
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.2"
        id="has-fedramp-authorization-type"
        role="error"
        see="Guide to OSCAL-based FedRAMP System Security Plans §4.2"
        test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'authorization-type' and @value = $authorization-types]">A FedRAMP
        SSP must have an allowed FedRAMP authorization type.</sch:assert>
</sch:rule>
```

The `<sch:rule>` element sets the locus within the document to be used as a relative reference for the subordinate assertions (`<sch:assert>` elements). In this case, the locus is `oscal:system-characteristics`: an XPath statement identifying the context element using a (namespace-)qualified element name.

The first assertion `id="has-system-id"`has a test (an XPath statement in the `test` attribute stating `oscal:system-id[@identifier-type eq 'https://fedramp.gov']` which asserts "the `oscal:system-characteristics` element has a child element `oscal:system-id` which must have an `@identifier-type eq 'https://fedramp.gov'` with a specific value. The natural language prose equivalent "A FedRAMP SSP must have a FedRAMP system identifier." resides within the `<sch:assert>` element.

The next two assertions are similar, each stating a particular child element must be present.

A reference to the `fedramp_values.xml` document sets a variable to the desired [`<value-set>`](https://github.com/18F/fedramp-automation/blob/develop/dist/content/resources/xml/fedramp_values.xml#L83-L92) allowed values. The following assertion (`id="has-fedramp-authorization-type"`) tests that a child `<oscal:prop>` element has the desired attributes.
