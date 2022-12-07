# How to create FedRAMP OSCAL validation constraints

FedRAMP OSCAL documents are structured XML documents. The document syntax is defined by OSCAL XML Schema. However, XML Schema cannot express many semantic constraints, and an additional schema language is employed: Schematron, which is used to create validation expressions for FedRAMP OSCAL documents (augmenting those expressed in OSCAL XML Schema).


# Technologies used

- [XML](https://www.w3.org/standards/xml/) is a structured document langauge.
- [Namespaces in XML](https://www.w3.org/TR/xml-names/) allow element (and attribute) names to be declared in distinct namespaces
- [OSCAL](https://pages.nist.gov/OSCAL/) is used to define the several FedRAMP document types in a structured data form. NIST provides XML Schema documents for the various OSCAL document types.
- [Schematron](https://schematron.com/) is used to declare assertions for documents to be validated
- [XPath](https://www.w3.org/TR/xpath-31/) is used in Schematron to define rule contexts and assertion tests
- [XSpec](https://github.com/xspec/xspec) is used to create unit tests for Schematron assertions
- [XSLT](https://www.w3.org/TR/xslt-30/) is used to manipulate XML documents, and is used to transpile Schematron documents into XSLT documents

Use of Schematron will require familiarity with XPath for context identification and assertion tests, and XSpec for creation of unit tests.

# FedRAMP OSCAL References

NIST has designed OSCAL to be flexible to the needs of different authorization and assessment frameworks, whether or not they originate from NIST's very own [Risk Management Framework](https://csrc.nist.gov/projects/risk-management/about-rmf) or not. OSCAL has a set a syntax. For required or recommended data that must be structured and organized in a specific way within this syntax, OSCAL developers use constraints. In OSCAL, constraints and the constraints model define, given syntactically correct documents, what data is required or recommended.

FedRAMP has adopted and extended NIST OSCAL document types (e.g. SSP, SAP, SAR, POA&M) in order to support FedRAMP-specific requirements. These adaptations are documented in the GSA [fedramp_automation repository](https://github.com/GSA/fedramp-automation/tree/master/documents).

The pertinent normative documents are

- [Guide to OSCAL-based FedRAMP Content](../../../documents/Guide_to_OSCAL-based_FedRAMP_Content.pdf)

- [Guide to OSCAL-based FedRAMP System Security Plans (SSP)](../../../documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf)

- [Guide to OSCAL-based FedRAMP Security Assessment Plans  (SAP)](../../../documents/Guide_to_OSCAL-based_FedRAMP_Security_Assessment_Plans_(SAP).pdf)

- [Guide to OSCAL-based FedRAMP Security Assessment Results (SAR)](../../../documents/Guide_to_OSCAL-based_FedRAMP_Security_Assessment_Results_(SAR).pdf)

- [Guide to OSCAL-based FedRAMP Plan of Action and Milestones (POA&M)](../../../documents/Guide_to_OSCAL-based_FedRAMP_Plan_of_Action_and_Milestones_(POAM).pdf)

Each describes how FedRAMP expects each OSCAL document type is to be presented in an authorization package.

# FedRAMP validation constraints

FedRAMP validation constraints extend the NIST OSCAL XML Schema constraints. The XML Schema constraints are essentially syntactic; Schematron is used to augment the former with semantic constraints which cannot be expressed using XML Schema.

Constraints define required or recommended data elements FedRAMP expects in syntactically valid OSCAL documents. When developing rules, developers will recognize in most cases there are two pieces to a rule checking the constraint: the analytical query of the OSCAL data, and cross-referencing that data with a set of known values for given data elements in a constraint. Much like other software projects, FedRAMP has opted to store the known values as external configuration that can be adapted with changing the analytical query operation of the rule. These are the FedRAMP values.

Schematron constraints have thus far been for system security plan documents. They are found in a Schematron document [`ssp.sch`](ssp.sch).

A companion document [`fedramp_values.xml`](../../dist/content/rev4/resources/xml/fedramp_values.xml) defines sets of allowed values for various FedRAMP OSCAL XML elements and their attributes.

An additional Schematron document [`sch.sch`](../styleguides/sch.sch) defines a style guide for FedRAMP Schematron to ensure developers continue to follow best practices. These augmentations provide

- References to associated unit tests ([ssp.xspec](../test/ssp.xspec))
- References to FedRAMP documentation related to the constraint
- References to associated diagnostic messages
- Forward and reverse linkages between Schematron rules (`<rule>` elements), assertions (`<assert>` elements, and diagnostic messages (`<diagnostic>` elements).

Use a validating (XML) editor with the `sch.sch` employed in order to enforce the style.

# Examples of Schematron constraints

The following examples use XML namespace prefixes declared at the root element of the Schematron document.

```xml
<sch:schema
    queryBinding="xslt2"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <sch:ns
        prefix="f"
        uri="https://fedramp.gov/ns/oscal" />
    <sch:ns
        prefix="o"
        uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns
        prefix="oscal"
        uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns
        prefix="fedramp"
        uri="https://fedramp.gov/ns/oscal" />
    <sch:ns
        prefix="lv"
        uri="local-validations" />
    <sch:ns
        prefix="array"
        uri="http://www.w3.org/2005/xpath-functions/array" />
    <sch:ns
        prefix="map"
        uri="http://www.w3.org/2005/xpath-functions/map" />
```
Namespace declarations made on the root element are for that document.

Namespace declarations via the `<sch:ns>` element are for instance documents to be validated.

## Example 1 - Existence and value checks

This example illustrates simple required element presence and value constraint checks.

Consider the following document fragment
```xml
<system-characteristics>
    <system-id identifier-type="https://fedramp.gov">F00000000</system-id>
    <system-name>System's Full Name</system-name>
    <system-name-short>System's Short Name or Acronym</system-name-short>
    <description>
        <p>Describe the purpose and functions of this system here.</p>
    </description>
    <prop ns="https://fedramp.gov/ns/oscal" name="authorization-type" value="fedramp-agency"/>
```
and the following code block
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

The `<sch:rule>` element sets the locus within the document to be used as a relative reference for the subordinate assertions (`<sch:assert>` elements). In this case, the locus is `oscal:system-characteristics`: an XPath statement identifying the context element using a (namespace-)qualified element name. Statement subordinate to `<rule>` can refer to the context implicitly or explicitly using the XPath function `current()`.

The first assertion `id="has-system-id"`has a test (an XPath statement in the `test` attribute stating `oscal:system-id[@identifier-type eq 'https://fedramp.gov']` which asserts "the `oscal:system-characteristics` element has a child element `oscal:system-id` which must have an `@identifier-type eq 'https://fedramp.gov'` with a specific value. The natural language prose equivalent "A FedRAMP SSP must have a FedRAMP system identifier." resides within the `<sch:assert>` element.

The next two assertions are similar, each stating a particular child element must be present.

A reference to the `fedramp_values.xml` document sets a variable to the allowed values found in a `<value-set>`.
```xml
<value-set name="authorization-type">
    <formal-name>Authorization Type</formal-name>
    <description>The FedRAMP Authorization Type</description>
    <binding pattern="system-characteristics/prop[@name='authorization-type'][@ns='https://fedramp.gov/ns/oscal']" />
    <allowed-values allow-other="no">
        <enum value="fedramp-jab" short-label="JAB">FedRAMP JAB P-ATO</enum>
        <enum value="fedramp-agency" short-label="Agency">FedRAMP Agency ATO</enum>
        <enum value="fedramp-li-saas" short-label="LI-SaaS">FedRAMP Tailored for LI-SaaS</enum>
    </allowed-values>
</value-set>
```

The following assertion (`id="has-fedramp-authorization-type"`) tests that a child `<oscal:prop>` element has an allowed value.

## Example 2 - intra-document references

This example illustrates intra-document references relative to the context.

Consider the following document fragment
```xml
<role id="system-owner">
    <title>Information System Owner</title>
    <description>
        <p>The individual within the CSP who is ultimately accountable for everything related to
            this system.</p>
    </description>
</role>
…
<party uuid="3360e343-9860-4bda-9dfc-ff427c3dfab6" type="person">
    <name>[SAMPLE]Person Name 1</name>
    <prop name="job-title" value="Individual's Title"/>
    <prop name="mail-stop" value="Mailstop A-1"/>
    <email-address>name@example.com</email-address>
    <telephone-number>202-000-0001</telephone-number>
    <location-uuid>27b78960-59ef-4619-82b0-ae20b9c709ac</location-uuid>
    <member-of-organization>6b286b5d-8f07-4fa7-8847-1dd0d88f73fb</member-of-organization>
</party>
…
<responsible-party role-id="system-owner">
    <party-uuid>3360e343-9860-4bda-9dfc-ff427c3dfab6</party-uuid>
    <remarks>
        <p>Exactly one</p>
    </remarks>
</responsible-party>
```
and the code block
```xml
<sch:rule
    context="oscal:responsible-party"
    doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.11">
    <sch:assert
        diagnostics="responsible-party-has-role-diagnostic"
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.11"
        id="responsible-party-has-role"
        role="error"
        test="exists(//oscal:role[@id eq current()/@role-id])">The role for a responsible party must exist.</sch:assert>
    <sch:assert
        diagnostics="responsible-party-has-party-uuid-diagnostic"
        id="responsible-party-has-party-uuid"
        role="error"
        test="exists(oscal:party-uuid)">One or more parties must be identified for a responsibility.</sch:assert>
    <sch:assert
        diagnostics="responsible-party-has-definition-diagnostic"
        id="responsible-party-has-definition"
        role="error"
        test="
        every $p in oscal:party-uuid
        satisfies exists(//oscal:party[@uuid eq $p])">Every responsible party must be defined.</sch:assert>
    <sch:assert
        diagnostics="responsible-party-is-person-diagnostic"
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.11"
        id="responsible-party-is-person"
        role="error"
        test="
        if (
        current()/@role-id = (
        'system-owner',
        'authorizing-official',
        'system-poc-management',
        'system-poc-technical',
        'system-poc-other',
        'information-system-security-officer',
        'authorizing-official-poc'
        )
        )
        then
        every $p in oscal:party-uuid
        satisfies
        exists(//oscal:party[@uuid eq $p and @type eq 'person'])
        else
        true()
        ">For some roles responsible parties must be persons.</sch:assert>
</sch:rule>
```
The `<rule>` sets the context for the subordinate assertions.


The first (`id="responsible-party-has-role"`) assertion is an existence (presence) test for a `<role>` for the `@role-id`. The use of the `//` prefix in the path `//oscal:role[@id eq current()/@role-id]` means "any `<role>` element within the document" matching the context `@role-id`.

The second (`id="responsible-party-has-party-uuid"`) assertion is just an existential test for `<party-uuid>`.

The third (`id="responsible-party-has-definition"`) assertion is an existential test that every `<party-uuid>` reference (there may be more than one subordinate to `<responsible-party>`) references a `<party>` anywhere within the ndocument.

The fourth (`id="responsible-party-is-person"`) assertion ensures that specific role types identify a responsible **person** (i.e., a `<party>` defined as a person).

## Example 3 - remote resource reference

This example uses remote HTTPS resource availability to ensure a Cryptographic Module Validation Program (CMVP) citation is actually found on the related NIST web site.

Consider the following document fragment
```xml
<component uuid="95beec7e-6f82-4aaa-8211-969cd7c1f1ab" type="validation">
    <title>[SAMPLE]Module Name</title>
    <description>
        <p>[SAMPLE]FIPS 140 Validated Module</p>
    </description>
    <prop name="validation-type" value="fips-140-2"/>
    <!-- identifies the certificate number -->
    <prop name="validation-reference" value="3928"/>
    <link rel="validation-details"
        href="https://csrc.nist.gov/projects/cryptographic-module-validation-program/Certificate/3928"/>
    <status state="operational"/>
</component>
```
and the following code block
```xml
<sch:rule
    context="oscal:link[@rel eq 'validation-details']"
    doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans Appendix A">
    <sch:assert
        diagnostics="has-credible-CMVP-validation-details-diagnostic"
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
        id="has-credible-CMVP-validation-details"
        role="error"
        test="matches(@href, '^https://csrc\.nist\.gov/projects/cryptographic-module-validation-program/[Cc]ertificate/\d{3,4}$')">A validation
        details must refer to a NIST Cryptographic Module Validation Program (CMVP) certificate detail page.</sch:assert>
    <sch:assert
        diagnostics="has-accessible-CMVP-validation-details-diagnostic"
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
        id="has-accessible-CMVP-validation-details"
        test="not($use-remote-resources) or unparsed-text-available(@href)">The NIST Cryptographic Module Validation Program (CMVP) certificate detail
        page is available.</sch:assert>
    <sch:assert
        diagnostics="has-consonant-CMVP-validation-details-diagnostic"
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
        id="has-consonant-CMVP-validation-details"
        role="error"
        test="tokenize(@href, '/')[last()] = preceding-sibling::oscal:prop[@name eq 'validation-reference']/@value">A validation details link must be
        in accord with its sibling validation reference.</sch:assert>
</sch:rule>
```

The `<sch:rule>` context is that of an OSCAL `<link>` element with `@rel eq 'validation-details'`, namely, one which references a NIST CMVP certificate.

The first (`id="has-credible-CMVP-validation-details"`) assertion uses a regular expression to sanity check the href.

The second (`id="has-accessible-CMVP-validation-details"`) assertion uses the XPath `unparsed-text-available()` function to determine if the document is available.

The third (`id="has-consonant-CMVP-validation-details"`) assertion uses the preceding-sibling axis to ensure that the certificate number in the `<link>` href matches the value found in the preceding sibling `<prop name="validation-reference">`. (The OSCAL SSP XML Schema constrains the prop to precede the link element.)

## Example 4 - Use of JSON in XPath

This example uses a network-resident JSON document to validate the FedRAMP package ID of the system security plan.

Consider the following document fragment
```xml
<system-characteristics>
    <system-id identifier-type="https://fedramp.gov">F00000000</system-id>
```
and the following code block
```xml
<sch:pattern
    id="fedramp-data">

    <sch:let
        name="fedramp_data_href"
        value="'https://raw.githubusercontent.com/18F/fedramp-data/master/data/data.json'" />

    <sch:let
        name="fedramp_data"
        value="
        if ($use-remote-resources and unparsed-text-available($fedramp_data_href)) then
        parse-json(unparsed-text($fedramp_data_href))
        else
        nilled(())" />

    <sch:rule
        context="oscal:system-characteristics/oscal:system-id[@identifier-type eq 'https://fedramp.gov']">

        <sch:assert
            diagnostics="has-active-system-id-diagnostic"
            id="has-active-system-id"
            role="error"
            test="
            not($use-remote-resources) or
            (some $p in array:flatten($fedramp_data?data?Providers)
            satisfies $p?Package_ID eq current())">A FedRAMP SSP must have an active FedRAMP system identifier.</sch:assert>

    </sch:rule>

</sch:pattern>
```

The first `<sch:let>` statement sets a variable to the URI of a FedRAMP JSON document with a list of FedRAMP packages.

The second `<sch:let>` statement conditionally sets a variable to the content of that document parsed into XPath [maps and arrays](https://www.w3.org/TR/xpath-functions-31/#maps-and-arrays). The `$use-remote-resources ` variable is set globally elsewhere in the Schematron document.

The `<sch:rule>` sets the context to that of the OSCAL `<system-id>` element (the text content of which should be the FedRAMP package identifier).

The `<sch:assert>` test fails if the package identifier is not found within the remote resource.
