# Developer Style Guide for FedRAMP OSCAL Constraints

## Summary

This document is to instruct FedRAMP developers and community members on mandatory or recommended style for the structure, format, and organization of constraints. Each requirement will be given an identifier, guidance text, and examples that either do or do not conform to the best practices.  Following the guidance in this document will improve (external constraint) code readability and consistency, and make it easier to maintain.

## Requirements

### FCSR-1

ID: `fcsr-1`

Formal Name: FedRAMP Requires External Constraints

State: Required

Guidance: FedRAMP OSCAL constraints MUST be in an external file or URL. OSCAL model in-line constraints should be avoided and only implemented by NIST for generalized, non-FedRAMP specific constraints.

**NOTE:** At this time, the FedRAMP Automation Team maintains a set of constraints for the core NIST-maintained OSCAL models, not specific to FedRAMP, in the the [`oscal-external-constraints.xml`](./oscal-external-constraints.xml) file. The team intends intends to upstream these changes to the NIST-maintained models and their supporting code based, as proposed in [usnistgov/OSCAL#2050)](https://github.com/usnistgov/OSCAL/issues/2050). Currently, FedRAMP developers implement externalized constraints in this separate file, as this guidance requires and is the only feasible interim solution. However, the test infrastructure purposely ignores this file and does not process its constraints for explicit continuous integration testing. This approach MAY change given the result of the proposal to NIST maintainers or other decisions by FedRAMP's technical leadership, but they are not explicitly within the scope of FedRAMP developer's constraint roadmap and they follow this guidance when reasonable. FedRAMP developers did not design or implement these constraints as a permanent collection in the constraints inventory.

#### FCSR-1 Conformant Example <a id='fcsr-1-conformant'></a>

Below is a conformant example for FCSR-1.

```xml
<!-- 
    This constraint definition is in a file fedramp-external-constraints.xml, separate of the model below.
-->
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <!-- truncated -->
    <context>
        <metapath target="/system-security-plan"/>
        <constraints>
            <expect id="resource-has-title" target="back-matter/resource" test="title" level="WARNING">
                <message>Every supporting artifact found in a citation should have a title.</message>
            </expect>
    </context>
    <!-- truncated -->
</metaschema-meta-constraints>
```

```xml
<!--
     Below is a truncated example from the core NIST OSCAL constraints in v1.1.2.
    See URL below for full context:

    https://github.com/usnistgov/OSCAL/blob/v1.1.2/src/metaschema/oscal_metadata_metaschema.xml#L497-L514

    All the definitions below are in the same file. This file is oscal_metadata_metaschema.xml.
-->
<?xml version="1.0" encoding="UTF-8"?>
<METASCHEMA xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0" abstract="yes">
    <schema-name>OSCAL Document Metadata Description</schema-name>
    <schema-version>1.1.2</schema-version>
    <short-name>oscal-metadata</short-name>
    <namespace>http://csrc.nist.gov/ns/oscal/1.0</namespace>
    <json-base-uri>http://csrc.nist.gov/ns/oscal</json-base-uri>
    <!-- truncated -->
    <define-assembly name="back-matter">
        <formal-name>Back matter</formal-name>
        <description>A collection of resources that may be referenced from within the OSCAL document instance.</description>
        <model>
            <define-assembly name="resource" max-occurs="unbounded">
                <formal-name>Resource</formal-name>
                <!-- truncated -->
                <model>
                    <define-field name="title" as-type="markup-line">
                        <formal-name>Resource Title</formal-name>
                        <description>An optional name given to the resource, which may be used by a tool for display and navigation.</description>
                    </define-field>
                    <!-- truncated -->
```

#### FCSR-1 Non-conformant Example

Below is a non-conformant example for FCSR-1.

```xml
<!-- 
    Below is a truncated example from the core NIST OSCAL constraints in v1.1.2.
    See URL below for full context:

    https://github.com/usnistgov/OSCAL/blob/v1.1.2/src/metaschema/oscal_ssp_metaschema.xml#L1044-L1049

    All the definitions below are in the same file. This file is oscal_ssp_metaschema.xml.
-->
<METASCHEMA xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
  <schema-name>OSCAL System Security Plan (SSP) Model</schema-name>
  <schema-version>1.1.2</schema-version>
  <short-name>oscal-ssp</short-name>
  <namespace>http://csrc.nist.gov/ns/oscal/1.0</namespace>
  <json-base-uri>http://csrc.nist.gov/ns/oscal</json-base-uri>
  <remarks><!-- truncated --></remarks>
  <import href="oscal_metadata_metaschema.xml"/>
  <import href="oscal_implementation-common_metaschema.xml"/>
  <define-assembly name="system-security-plan">
    <formal-name>System Security Plan (SSP)</formal-name>
    <description>A system security plan, such as those described in NIST SP 800-18.</description>
    <root-name>system-security-plan</root-name>
    <define-flag name="uuid" as-type="uuid" required="yes">
      <formal-name>System Security Plan Universally Unique Identifier</formal-name>
    </define-flag>
    <model><!-- truncated --></model>
    <!-- This constraint definition below is inline, within the module for its related module. -->
    <constraint>
      <index name="by-component-uuid" target="control-implementation/implemented-requirement//by-component|doc(system-implementation/leveraged-authorization/link[@rel='system-security-plan']/@href)/system-security-plan/control-implementation/implemented-requirement//by-component">
        <key-field target="@uuid"/>
      </index>
    </constraint>
    <!-- truncated -->
</METASCHEMA>    
```

### FCSR-2

ID: `fcsr-2`

Formal Name: FedRAMP Requires Constraints Sorted by Metatapath Target from Least to Most Specific

State: Required

Guidance: Developers MUST sort OSCAL constraint definitions in the file by `metapath/@target` from the most to least specific. In a `context`, the least specific `metapath/@target` is one with the path addressing some or all of the roots of an OSCAL model. More or most specific targets address specific nested fields, flags, or assemblies deeply embedded in the model as close to the location of the constraint's target for data in the instance of the model as possible.

#### FCSR-2 Conformant Example

Below is a conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/catalog//control"/>
        <constraints>
            <expect id="prop-response-point-has-cardinality-one" target=".//part" test="count(prop[@ns='https://fedramp.gov/ns/oscal' and @name='response-point']) &lt;= 1">
                <message>Duplicate response point at '{ path(.) }'.</message>
            </expect>
            <remarks>
                <p>This appears in FedRAMP profiles and resolved profile catalogs.</p>
                <p>For control statements, it signals to the CSP which statements require a response in the SSP.</p>
                <p>For control objectives, it signals to the assessor which control objectives must appear in the assessment results, which aligns with the FedRAMP test case workbook.</p>
             </remarks>
        </constraints>
    </context>
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1">
                <message>Each data center address must contain a country code.</message>
            </expect>
            <expect id="data-center-US" target="." test="address/country eq 'US'">
                <message>Each data center must have an address that is within the United States.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

#### FCSR-2 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <!--
            The target(s)  of this context's metapath are more specific.
            They MUST come later in a document.
        -->
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1">
                <message>Each data center address must contain a country code.</message>
            </expect>
            <expect id="data-center-US" target="." test="address/country eq 'US'">
                <message>Each data center must have an address that is within the United States.</message>
            </expect>
        </constraints>
    </context>    
    <context>
        <!--
            The target(s)  of this context's metapath are more specific.
            They MUST come earlier in a document.
        -->        
        <metapath target="/catalog//control"/>
        <constraints>
            <expect id="prop-response-point-has-cardinality-one" target=".//part" test="count(prop[@ns='https://fedramp.gov/ns/oscal' and @name='response-point']) &lt;= 1">
                <message>Duplicate response point at '{ path(.) }'.</message>
            </expect>
            <remarks>
                <p>This appears in FedRAMP profiles and resolved profile catalogs.</p>
                <p>For control statements, it signals to the CSP which statements require a response in the SSP.</p>
                <p>For control objectives, it signals to the assessor which control objectives must appear in the assessment results, which aligns with the FedRAMP test case workbook.</p>
             </remarks>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

### FCSR-3

ID: `fcsr-3`

Formal Name: FedRAMP Requires Constraints in the Context Alphabetically by ID

State: Required

Guidance: Developers MUST sort OSCAL constraint definitions in a file for each context by each of their `@id`s alphabetically, from upper case and then lower case respectively.

#### FCSR-3 Conformant Example

Below is a conformant example:

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="A" target="." test="count(address/country) eq 1">
                <message>Example of sorting.</message>
            </expect>            
            <expect id="a" target="." test="count(address/country) eq 2">
                <message>Example of sorting.</message>
            </expect>
            <expect id="b" target="." test="count(address/country) eq 3">
                <message>Example of sorting.</message>
            </expect>
            <expect id="c" target="." test="count(address/country) eq 4">
                <message>Example of sorting.</message>
            </expect>            
        </constraints>
    </context>
</metaschema-meta-constraints>
```

#### FCSR-3 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <!-- Constraints MUST be sorted alphabetically by @id, these are not.  -->
            <expect id="c" target="." test="count(address/country) eq 4">
                <message>Example of sorting.</message>
            </expect>
            <expect id="A" target="." test="count(address/country) eq 1">
                <message>Example of sorting.</message>
            </expect>
            <expect id="b" target="." test="count(address/country) eq 3">
                <message>Example of sorting.</message>
            </expect>                      
            <expect id="a" target="." test="count(address/country) eq 2">
                <message>Example of sorting.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

### FCSR-4

ID: `fcsr-4`

Formal Name: FedRAMP Requires Constraints Have a Help URL Property

State: Required

Guidance: Developers MUST define a Metaschema constraint property with a namespace of `https://docs.oasis-open.org/sarif/sarif/v2.1.0`,  name `help-url`, and `value` with a URL to an official, meaningful, and specific explanation to the OSCAL syntax and semantics that motivate that OSCAL constraint definition in a file.

#### FCSR-4 Conformant Example

Below is a conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1">
                <prop namespace="https://docs.oasis-open.org/sarif/sarif/v2.1.0" name="help-url" value="https://automate.fedramp.gov/documentation/ssp/4-ssp-template-to-oscal-mapping/#data-center"/>
                <message>Each data center address must contain a country code.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

#### FCSR-4 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1">
                <!-- This constraint MUST have a help-url prop. It is missing and non-conformant. -->
                <message>Each data center address must contain a country code.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

### FCSR-5

ID: `fcsr-5`

Formal Name: FedRAMP Requires Constraints Have a Unique ID

State: Required

Guidance: Developers MUST define a Metaschema constraint with an `id` flag that is unique to all those FedRAMP maintains across all constraint documents.

#### FCSR-5 Conformant Example

Below is a conformant example.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/catalog//control"/>
        <constraints>
            <expect id="prop-response-point-has-cardinality-one" target=".//part" test="count(prop[@ns='https://fedramp.gov/ns/oscal' and @name='response-point']) &lt;= 1">
                <message>Duplicate response point at '{ path(.) }'.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

#### FCSR-5 Non-conformant Example

Below is a non-conformant example.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/catalog//control"/>
        <constraints>
            <!-- This constraint is missing an @id flag, it does not meet FedRAMP developer style requirements. -->
            <expect target=".//part" test="count(prop[@ns='https://fedramp.gov/ns/oscal' and @name='response-point']) &lt;= 1">
                <message>Duplicate response point at '{ path(.) }'.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

### FCSR-6

ID: `fcsr-6`

Formal Name: FedRAMP Requires Constraints Have a Severity Level

State: Required

Guidance: Developers MUST define a Metaschema constraint with a `level` flag with [a valid value](https://pages.nist.gov/metaschema/specification/syntax/constraints/#level) to indicate to downstream developers and/or users the potential impact of the data instance not meeting its requirements.

#### FCSR-6 Conformant Example

Below is a conformant example.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/catalog//control"/>
        <constraints>
            <expect id="duplicate-response-point" target=".//part" test="count(prop[@ns='https://fedramp.gov/ns/oscal' and @name='response-point']) &lt;= 1" level="ERROR">
                <message>Duplicate response point at '{ path(.) }'.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

#### FCSR-6 Non-conformant Example

Below is a non-conformant example.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/catalog//control"/>
        <constraints>
            <!-- This constraint is missing an @level flag, it does not meet FedRAMP developer style requirements. -->
            <expect target=".//part" test="count(prop[@ns='https://fedramp.gov/ns/oscal' and @name='response-point']) &lt;= 1">
                <message>Duplicate response point at '{ path(.) }'.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

### FCSR-7

ID: `fcsr-7`

Formal Name: FedRAMP Requires Developers Use Constraints with Critical Severity Level for Runtime Failures

State: Required

Guidance: Developers MUST only define a Metaschema constraint with a `level` flag with a value of `CRITICAL` if and only if the violation of the constraint will lead to an irrecoverable runtime failure (e.g. a SSP's `import-profile` references a catalog or profile with no valid controls) or undefined behavior in a conformant processor in a consistent way for the majority of use cases.

#### FCSR-7 Conformant Example

Below is a conformant example.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan"/>
        <constraints>
            <matches id="ssp-needs-valid-control-source" target="./import-profile" test="@href" datatype="uri-reference" level="CRITICAL">
                <message>A FedRAMP SSP MUST define a valid URL to the catalog that identifies the controls' requirements it implements. This error indicates the referenced catalog or profile is invalid, so many constraints are unable to process. The resulting validations from constraint check are inaccurate, incomplete, or both.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

#### FCSR-7 Non-conformant Example

Below is a non-conformant example.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/catalog//control"/>
        <constraints>
            <!-- This constraint defines a CRITICAL severity level for a violation that does not cause an irrecoverable error or undefined behavior. This example does not conform with the FedRAMP developer's guide. -->
            <expect target=".//part" test="count(prop[@ns='https://fedramp.gov/ns/oscal' and @name='response-point']) &lt;= 1" level="CRITICAL">
                <message>Duplicate response point at '{ path(.) }'.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

### FCSR-8

ID: `fcsr-8`

Formal Name: FedRAMP Requires Constraints Have a Message When Constraints Are Violated

State: Required

Guidance: Developers MUST only define a Metaschema constraint with a `message` field with a description of the positive requirement (i.e. what an OSCAL document must define and encode for FedRAMP's use case; why it matters; and other relevant details technical leads and developer team, if applicable).

#### FCSR-8 Conformant Example

Below is a conformant example.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan"/>
        <constraints>
            <matches id="ssp-needs-valid-control-source" target="./import-profile" test="@href" datatype="uri-reference" level="CRITICAL">
                <message>A FedRAMP SSP MUST define a valid URL to the catalog that identifies the controls' requirements it implements. This error indicates the referenced catalog or profile is invalid, so many constraints are unable to process. The resulting validations from constraint check are inaccurate, incomplete, or both.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

#### FCSR-8 Non-conformant Example

Below is a non-conformant example.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan"/>
        <constraints>
            <matches id="ssp-needs-valid-control-source" target="./import-profile" test="@href" datatype="uri-reference" level="CRITICAL">
                <!-- This constraint does not provide a meaningful message for data violates the constraint. It is not conformant with the developer guide. -->
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

### FCSR-9

ID: `fcsr-9`

Formal Name: FedRAMP Recommends Constraints Have Remarks for Requirements Too Complex for Description in the Message

State: Recommended

Guidance: Developers SHOULD only define a Metaschema constraint with a `remarks` field when the requirement is complex enough that a full explanation of the positive requirement exceeds a sentence of reasonable length conforming to all requirements in this guide.

#### FCSR-9 Conformant Example

Below is a conformant example.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan"/>
        <constraints>
            <matches id="ssp-needs-valid-control-source" target="./import-profile" test="@href" datatype="uri-reference" level="CRITICAL">
                <message>A FedRAMP SSP MUST define a valid URL to the catalog that identifies the controls' requirements it implements.</message>
                <remarks>
                    <p>The control requirements a SSP must implement and support are defined in the profile or catalog referenced in b a URL to a file on a computer's filesystem or remote URL.</p>
                    <p>More than other constraints, a valid profile URL is integral for processing of other constraints in this document.</p>
                    <p>Users and intervening software developers should clearly mark that validation failed if this constraint is violated regardless of all others.</p>
                </remarks>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

#### FCSR-9 Non-conformant Example

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan"/>
        <constraints>
            <!-- This constraint has too long of an explanation of the positive requirement for a message. This example does not conform with the developer guide. -->
            <matches id="ssp-needs-valid-control-source" target="./import-profile" test="@href" datatype="uri-reference" level="CRITICAL">
                <message>A FedRAMP SSP MUST define a valid URL to the catalog that identifies the controls' requirements it implements. The control requirements a SSP must implement and support are defined in the profile or catalog referenced in b a URL to a file on a computer's filesystem or remote URL. More than other constraints, a valid profile URL is integral for processing of other constraints in this document. Users and intervening software developers should clearly mark that validation failed if this constraint is violated regardless of all others.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

### FCSR-10

ID: `fcsr-10`

Formal Name: FedRAMP Recommends Constraints Use Messages with Sentences in Active Voice

State: Recommended

Guidance: Developers SHOULD define a Metaschema constraint with a `message` field with one sentence with active voice, not passive voice. The subject SHOULD be the document name or abbreviation for the OSCAL model in question. For general constraints (e.g. `metadata`; `back-matter/resources`), the sentence should begin with the subject as "FedRAMP documents require."

#### FCSR-10 Conformant Example

Below is a conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1">
                <prop namespace="https://docs.oasis-open.org/sarif/sarif/v2.1.0" name="help-url" value="https://automate.fedramp.gov/documentation/ssp/4-ssp-template-to-oscal-mapping/#data-center"/>
                <message>A FedRAMP document MUST define a data center location with an explicit country code.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

#### FCSR-10 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1">
                <prop namespace="https://docs.oasis-open.org/sarif/sarif/v2.1.0" name="help-url" value="https://automate.fedramp.gov/documentation/ssp/4-ssp-template-to-oscal-mapping/#data-center"/>
                <!-- The message for this constraint is written in passive voice. It does not conform to the developer guide. -->
                <message>An explicit country code must be defined here.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

### FCSR-11

ID: `fcsr-11`

Formal Name: FedRAMP Requires Constraints Use Messages IETF BCP14 Keywords

State: Required

Guidance: Developers MUST define a Metaschema constraint with a `message` sentence that conforms with IETF standards regarding capitalized requirement keywords per [BCP14](https://datatracker.ietf.org/doc/bcp14/). The sentence will use MUST," "MUST NOT," "REQUIRED," "SHALL," "SHALL NOT,", "SHOULD," "SHOULD NOT," "RECOMMENDED,"  "MAY," and "OPTIONAL" according to BCP14 requirements.

#### FCSR-11 Conformant Example

#### FCSR-11 Non-conformant Example

### FCSR-10

ID: `fcsr-10`

Formal Name: FedRAMP Recommends Constraints Use Messages with Sentences in Active Voice

State: Recommended

Guidance: Developers SHOULD define a Metaschema constraint with a `message` field with one sentence with active voice, not passive voice. The subject SHOULD be the document name or abbreviation for the OSCAL model in question. For general constraints (e.g. `metadata`; `back-matter/resources`), the sentence should begin with the subject as "FedRAMP documents require."

#### FCSR-11 Conformant Example

Below is a conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1">
                <prop namespace="https://docs.oasis-open.org/sarif/sarif/v2.1.0" name="help-url" value="https://automate.fedramp.gov/documentation/ssp/4-ssp-template-to-oscal-mapping/#data-center"/>
                <message>A FedRAMP document MUST define a data center location with an explicit country code.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

#### FCSR-11 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1">
                <prop namespace="https://docs.oasis-open.org/sarif/sarif/v2.1.0" name="help-url" value="https://automate.fedramp.gov/documentation/ssp/4-ssp-template-to-oscal-mapping/#data-center"/>
                <!-- The message for this constraint is written without BCP14 keywords. It does not conform to the developer guide. -->
                <message>Gotta have a country code.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

### FCSR-12

ID: `fcsr-12`

Formal Name: FedRAMP Requires Constraints Use Messages without Metaschema and OSCAL Jargon

State: Required

Guidance: Developers MUST define a Metaschema constraint with a `message` field with one sentence that describes the positive requirements for the artifact of the security process without using jargon or terminology from the [Metaschema](https://pages.nist.gov/metaschema) and [OSCAL](https://pages.nist.gov/OSCAL) projects. Messages MUST NOT use this jargon.

#### FCSR-12 Conformant Example

Below is a conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1">
                <prop namespace="https://docs.oasis-open.org/sarif/sarif/v2.1.0" name="help-url" value="https://automate.fedramp.gov/documentation/ssp/4-ssp-template-to-oscal-mapping/#data-center"/>
                <message>A FedRAMP document MUST define a data center location with an explicit country code.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

#### FCSR-12 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1">
                <prop namespace="https://docs.oasis-open.org/sarif/sarif/v2.1.0" name="help-url" value="https://automate.fedramp.gov/documentation/ssp/4-ssp-template-to-oscal-mapping/#data-center"/>
                <!-- The message for this constraint is written with Metaschema and OSCAL jargon. It does not conform to the developer guide. -->
                <message>The value of this field in the address assembly within the abstract metadta module, with a cardinality of 0 to 1, must result with a value of 1 when evaluated by the Metapath function count.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```
