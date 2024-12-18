# Developer Style Guide for FedRAMP OSCAL Constraints

## Summary

This document is to instruct FedRAMP developers and community members on mandatory or recommended style for the structure, format, and organization of constraints. Each requirement MUST have an identifier, guidance text, and examples that either do or do not conform to the best practices.  The FedRAMP Automation Team maintains this guidance in this format to  improve external constraints for code readability, consistency, and quality with minimal effort and less manual review.

## Requirements

| ID              | Formal Name             | Required or Recommended | Category    |
|-----------------|-------------------------|-------------------------|-------------|
| [FRR101](#frr101) | Separate OSCAL External Constraints  | Required | ID |
| [FRR102](#frr102) | Constraints Sorted from Broadest to Narrowest Metapath Target | Required | Metapath; Sorting |
| [FRR103](#frr103) | Constraints in the Context Sorted Alphabetically by ID | Required | ID; Sorting |
| [FRR104](#frr104) | Constraints Have a Help URL Property | Required | Structure; Metadata |
| [FRR105](#frr105) | Constraints Have a Unique ID | Required | ID; Metadata |
| [FRR106](#frr106) | Constraints Have IDs with Lower Case Letters, Numbers, and Dashes | Required | ID |
| [FRR107](#frr107) | Constraints Have an Explicit Severity Level | Required | Structure; Metadata |
| [FRR108](#frr108) | Constraints with Critical Severity Level Used only for Runtime Failures | Required | Structure; Metadata |
| [FRR109](#frr109) | Expect Constraint Message Field Required | Required | Structure; Metadata |
| [FR110](#frr110) | Constraint Has a Remark When Overly Complex | Recommended | Structure; Metadata |
| [FRR111](#frr111) | Constraint Message is Sentence in Active Voice | Recommended | Style |
| [FRR112](#frr112) | IETF BCP14 Keywords in Constraint Messages | Required | Style |
| [FRR113](#frr113) | Constraints Use Messages without Metaschema and OSCAL Jargon | Required | Style |
| [FRR114](#frr114) | Constraints Tests and Messages Have Single Item Focus | Recommended | Sequences; Style |
| [FRR115](#frr115) | Constraint Messages Have Single Item Hints |  Recommended | Sequences; Style |
| [FRR116](#frr116) | Constraints Formal Names Required | Required | Structure; Metadata |
| [FRR117](#frr117) | Limit Informational Constraint Usage | Recommended| Structure; Metadata |
| [FRR118](#frr118) | Keep Let Bindings Adjacent to Their Constraints | Recommended| Structure; Sorting |

### FRR101

ID: `frr101`

Formal Name: Separate OSCAL External Constraints

State: Required

Categories: ID

Guidance: FedRAMP OSCAL constraints MUST be in an external file or URL. OSCAL model in-line constraints should be avoided and only implemented by NIST for generalized, non-FedRAMP specific constraints.

<details>
<summary>Click for important background:</summary>

**NOTE:** At this time, the FedRAMP Automation Team maintains a set of constraints for the core NIST-maintained OSCAL models, not specific to FedRAMP, in the the [`oscal-external-constraints.xml`](./oscal-external-constraints.xml) file. The team intends intends to upstream these changes to the NIST-maintained models and their supporting code base, as proposed in [usnistgov/OSCAL#2050)](https://github.com/usnistgov/OSCAL/issues/2050). Currently, FedRAMP developers implement externalized constraints in this separate file, as this guidance requires and is the only feasible interim solution. However, the test infrastructure purposely ignores this file and does not process its constraints for explicit continuous integration testing. This approach MAY change given the result of the proposal to NIST maintainers or other decisions by FedRAMP's technical leadership, but they are not explicitly within the scope of FedRAMP developer's constraint roadmap and they follow this guidance _only_ when reasonable. FedRAMP developers did not design or implement these constraints as a permanent collection in the constraints inventory.
</details>
<br/>

[back to top](#summary)

#### FRR101 Conformant Example

Below is a conformant example for FRR1.

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

[back to top](#summary)

#### FRR101 Non-conformant Example

Below is a non-conformant example for FRR1.

```xml
<!--
    This example does not conform to the developer guide.

    Below is a truncated example from the core NIST OSCAL constraints in v1.1.2. See URL below for full context:

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

[back to top](#summary)

### FRR102

ID: `frr102`

Formal Name: Constraints Sorted from Broadest to Narrowest Metapath Target

State: Required

Categories: Metapath; Sorting

Guidance: Developers MUST sort OSCAL constraint definitions in the file from broadest to narrowest `metapath/@target`. In a `context`, the broadest `metapath/@target` is one where the target path is as close as possible to the root of the respective model (`target="/system-security-plan"`) or models (`target="//*/metadata"`) of a given OSCAL document. Targets that address specific nested fields, flags, or assemblies are more narrowly focused.

This approach provides a predictable ordering for readers and maintainers of the constraint set. It is intended to allow a reader to quickly find the constraints for a given context and to know where to place new constraints based on the constraint's context.

[back to top](#summary)

#### FRR102 Conformant Example

Below is a conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/catalog//control"/>
        <constraints>
            <expect id="prop-response-point-has-cardinality-one" target=".//part" test="count(prop[@ns='http://fedramp.gov/ns/oscal' and @name='response-point']) &lt;= 1" level="WARNING">
                <message>Duplicate response point at '{ path(.) }'.</message>
            </expect>
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

[back to top](#summary)

#### FRR102 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <!--
            The target(s)  of this context's metapath are more specific.
            To be conformant to the developer guide this context MUST
            come after the second context in the example, not before it.
        -->
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1" level="WARNING">
                <message>Each data center address must contain a country code.</message>
            </expect>
            <expect id="data-center-US" target="." test="address/country eq 'US'">
                <message>Each data center must have an address that is within the United States.</message>
            </expect>
        </constraints>
    </context>    
    <context>
        <!--
            The target(s)  of this context's metapath is less specific
            than the other. To be conformant to the developer guide this
            context MUST come before the first context in the example, not
            after it.
        -->
        <metapath target="/catalog//control"/>
        <constraints>
            <expect id="prop-response-point-has-cardinality-one" target=".//part" test="count(prop[@ns='http://fedramp.gov/ns/oscal' and @name='response-point']) &lt;= 1" level="WARNING">
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

[back to top](#summary)

### FRR103

ID: `frr103`

Formal Name: Constraints in the Context Sorted Alphabetically by ID

State: Required

Categories: ID; Sorting

Guidance: Within a given constraint file, developers MUST sort constraint definitions within a given context so that each constraint is ordered alphabetically by the constraint's `@id`, where upper case letters are sorted before lower case letters.

[back to top](#summary)

#### FRR103 Conformant Example

Below is a conformant example:

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="A" target="." test="count(address/country) eq 1" level="WARNING">
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

[back to top](#summary)

#### FRR103 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <!-- Constraints MUST be sorted alphabetically by @id, these are not.  -->
            <expect id="c" target="." test="count(address/country) eq 4" level="WARNING">
                <message>Example of sorting.</message>
            </expect>
            <expect id="A" target="." test="count(address/country) eq 1" level="WARNING">
                <message>Example of sorting.</message>
            </expect>
            <expect id="b" target="." test="count(address/country) eq 3" level="WARNING">
                <message>Example of sorting.</message>
            </expect>                      
            <expect id="a" target="." test="count(address/country) eq 2" level="WARNING">
                <message>Example of sorting.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

### FRR104

ID: `frr104`

Formal Name: Constraints Have a Help URL Property

State: Required

Categories: Structure; Metadata

Guidance: Developers MUST define only one Metaschema constraint property with a namespace of `https://docs.oasis-open.org/sarif/sarif/v2.1.0`,  name `help-url`, and `value` with a URL to an official, meaningful, and specific explanation to the OSCAL syntax and semantics (from [automate.fedramp.gov/documentation](https://automate.fedramp.gov/documentation/)) that motivate that OSCAL constraint definition in a file.

<details>

<summary>Click for important background:</summary>

**NOTE:** Although Metaschema can support multiple properties for different URLs, the explicit goal of this FedRAMP design and approach is to emit the relevant URL in SARIF output for constraint violations. The SARIF 2.1.0 specification and schema support one and only one URL in the relevant SARIF structure.
</details>
<br/>

[back to top](#summary)

#### FRR104 Conformant Example

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

[back to top](#summary)

#### FRR104 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1" level="WARNING">
                <!-- This constraint MUST have a help-url prop. It is missing and non-conformant. -->
                <message>Each data center address must contain a country code.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

### FRR105

ID: `frr105`

Formal Name: Constraints Have a Unique ID

State: Required

Categories: ID; Metadata

Guidance: Developers MUST define a Metaschema constraint with an `id` flag, and the value of that `id` flag must be unique from all other constraint IDs across all constraint documents FedRAMP and NIST define in core OSCAL.

[back to top](#summary)

#### FRR105 Conformant Example

Below is a conformant example.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/catalog//control"/>
        <constraints>
            <expect id="prop-response-point-has-cardinality-one" target=".//part" test="count(prop[@ns='http://fedramp.gov/ns/oscal' and @name='response-point']) &lt;= 1" level="WARNING">
                <message>Duplicate response point at '{ path(.) }'.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

#### FRR105 Non-conformant Example

Below is a non-conformant example.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/catalog//control"/>
        <constraints>
            <!-- This constraint is missing an @id flag, it does not meet FedRAMP developer style requirements. -->
            <expect target=".//part" test="count(prop[@ns='http://fedramp.gov/ns/oscal' and @name='response-point']) &lt;= 1" level="WARNING">
                <message>Duplicate response point at '{ path(.) }'.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

### FRR106

ID: `frr106`

Formal Name: Constraints Have IDs with Lower Case Letters, Numbers, and Dashes

State: Required

Categories: ID

Guidance: Developers MUST define a Metaschema constraint with an `id` flag with the following structure.

1. all lowercase letters (`a-z`) and numbers (`0-9`)
1. dashes (`-`) separating words and phrases of letters and numbers above

[back to top](#summary)

#### FRR106 Conformant Example

Below is a conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code-us" target="." test="count(address/country) eq 'US'" level="WARNING">
                <formal-name>Data Center Locations in the United States</formal-name>
                <message>A FedRAMP SSP must define locations for data centers that are explicitly in the United States.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

#### FRR106 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <!-- 
                This constraint's @id does not use lowercase letters, numbers, and dashes only.
                This example does not conform to the developer guide.
            -->
            <expect id="DataCenterUSOnly" target="." test="count(address/country) eq 'US'" level="WARNING">
                <formal-name>Data Center Locations in the United States</formal-name>
                <message>A FedRAMP SSP must define locations for data centers that are explicitly in the United States.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

### FRR107

ID: `frr107`

Formal Name: Constraints Have an Explicit Severity Level

State: Required

Categories: Structure; Metadata

Guidance: Developers MUST define a Metaschema constraint with a `level` flag with [a valid value](https://pages.nist.gov/metaschema/specification/syntax/constraints/#level) to indicate to downstream developers and/or users the potential impact of the data instance not meeting its requirements.

[back to top](#summary)

#### FRR107 Conformant Example

Below is a conformant example.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/catalog//control"/>
        <constraints>
            <expect id="duplicate-response-point" target=".//part" test="count(prop[@ns='http://fedramp.gov/ns/oscal' and @name='response-point']) &lt;= 1" level="ERROR">
                <message>Duplicate response point at '{ path(.) }'.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

#### FRR107 Non-conformant Example

Below is a non-conformant example.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/catalog//control"/>
        <constraints>
            <!-- This constraint is missing an @level flag, it does not meet FedRAMP developer style requirements. -->
            <expect target=".//part" test="count(prop[@ns='http://fedramp.gov/ns/oscal' and @name='response-point']) &lt;= 1">
                <message>Duplicate response point at '{ path(.) }'.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

### FRR108

ID: `frr108`

Formal Name: Constraints with Critical Severity Level Used only for Runtime Failures

State: Required

Categories: Structure; Metadata

Guidance: Developers MUST only define a Metaschema constraint with a `level` flag with a value of `CRITICAL` if and only if the violation of the constraint will lead to an irrecoverable runtime failure (e.g. a SSP's `import-profile` references a catalog or profile with no valid controls) or undefined behavior in a conformant processor in a consistent way for the majority of use cases.

[back to top](#summary)

#### FRR108 Conformant Example

Below is a conformant example.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan"/>
        <constraints>
            <expect id="ssp-needs-valid-control-source" target="./import-profile" test="@href" level="CRITICAL">
                <message>A FedRAMP SSP MUST define a valid URL to the catalog that identifies the controls' requirements it implements. This error indicates the referenced catalog or profile is invalid, so many constraints are unable to process. The resulting validations from constraint check are inaccurate, incomplete, or both.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

#### FRR108 Non-conformant Example

Below is a non-conformant example.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/catalog//control"/>
        <constraints>
            <!-- This constraint defines a CRITICAL severity level for a violation that does not cause an irrecoverable error or undefined behavior. This example does not conform with the FedRAMP developer's guide. -->
            <expect target=".//part" test="count(prop[@ns='http://fedramp.gov/ns/oscal' and @name='response-point']) &lt;= 1" level="CRITICAL">
                <message>Duplicate response point at '{ path(.) }'.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

### FRR109

ID: `frr109`

Formal Name: Expect Constraint Message Field Required

State: Required

Categories: Structure; Metadata

Guidance: A developer MUST define a `message` field with a description of the positive requirement (i.e. what an OSCAL document must define and encode for FedRAMP's use case; why it matters; and other relevant details technical leads and developer team, if applicable) only in an `expect`  Metaschema constraint.

[back to top](#summary)

#### FRR109 Conformant Example

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

[back to top](#summary)

#### FRR109 Non-conformant Example

Below is a non-conformant example.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan"/>
        <constraints>
            <expect id="ssp-needs-valid-control-source" target="./import-profile" test="@href" level="CRITICAL">
                <!-- This constraint does not provide a meaningful message for data violates the constraint. It is not conformant with the developer guide. -->
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

### FR110

ID: `frr110`

Formal Name: Constraint Has a Remark When Overly Complex

State: Recommended

Categories: Structure; Metadata

Guidance: Developers SHOULD only define a Metaschema constraint with a `remarks` field when an explanation of the positive requirement is too long to fix in the `message` field. It is too long for the `message` when it is more than sentence or the sentence(s) are so complex they do not meet other style guide requirements for a `message`.

[back to top](#summary)

#### FR110 Conformant Example

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

[back to top](#summary)

#### FR110 Non-conformant Example

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

[back to top](#summary)

### FRR111

ID: `frr111`

Formal Name: Constraint Message is Sentence in Active Voice

State: Recommended

Categories: Style

Guidance: Developers SHOULD define a Metaschema constraint with a `message` field with one sentence with active voice, not passive voice. The subject SHOULD be the document name or abbreviation for the OSCAL model in question. For general constraints (e.g. `metadata`; `back-matter/resources`), the sentence should begin with the subject as "A FedRAMP document requires."

[back to top](#summary)

#### FRR111 Conformant Example

Below is a conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <!-- This message begins with 'A FedRAMP document ...' because the metadata assembly is in all OSCAL models. -->
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1" level="WARNING">
                <prop namespace="https://docs.oasis-open.org/sarif/sarif/v2.1.0" name="help-url" value="https://automate.fedramp.gov/documentation/ssp/4-ssp-template-to-oscal-mapping/#data-center"/>
                <message>A FedRAMP document MUST define a data center location with an explicit country code.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

#### FRR111 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1" level="WARNING">
                <prop namespace="https://docs.oasis-open.org/sarif/sarif/v2.1.0" name="help-url" value="https://automate.fedramp.gov/documentation/ssp/4-ssp-template-to-oscal-mapping/#data-center"/>
                <!-- The message for this constraint is written in passive voice. It does not conform to the developer guide. -->
                <message>An explicit country code must be defined here.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

### FRR112

ID: `frr112`

Formal Name: IETF BCP14 Keywords in Constraint Messages

State: Required

Categories: Style

Guidance: Developers MUST define a Metaschema constraint with a `message` sentence that conforms with IETF standards regarding capitalized requirement keywords per [BCP14](https://datatracker.ietf.org/doc/bcp14/). The sentence will use MUST," "MUST NOT," "REQUIRED," "SHALL," "SHALL NOT,", "SHOULD," "SHOULD NOT," "RECOMMENDED,"  "MAY," and "OPTIONAL" according to BCP14 requirements.

[back to top](#summary)

#### FRR112 Conformant Example

Below is a conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1" level="WARNING">
                <prop namespace="https://docs.oasis-open.org/sarif/sarif/v2.1.0" name="help-url" value="https://automate.fedramp.gov/documentation/ssp/4-ssp-template-to-oscal-mapping/#data-center"/>
                <message>A FedRAMP document MUST define a data center location with an explicit country code.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

#### FRR112 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1" level="WARNING">
                <prop namespace="https://docs.oasis-open.org/sarif/sarif/v2.1.0" name="help-url" value="https://automate.fedramp.gov/documentation/ssp/4-ssp-template-to-oscal-mapping/#data-center"/>
                <message>What's wrong with you, no country code for data center!?</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

### FRR113

ID: `frr113`

Formal Name: Constraints Use Messages without Metaschema and OSCAL Jargon

State: Required

Categories: Style

Guidance: Developers MUST define a Metaschema constraint with a `message` field with one sentence that describes the positive requirements for the artifact of the security process without using jargon or terminology from the [Metaschema](https://pages.nist.gov/metaschema) and [OSCAL](https://pages.nist.gov/OSCAL) projects. Messages MUST NOT use this jargon.

[back to top](#summary)

#### FRR113 Conformant Example

Below is a conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1" level="WARNING">
                <prop namespace="https://docs.oasis-open.org/sarif/sarif/v2.1.0" name="help-url" value="https://automate.fedramp.gov/documentation/ssp/4-ssp-template-to-oscal-mapping/#data-center"/>
                <message>A FedRAMP document MUST define a data center location with an explicit country code.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

#### FRR113 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1" level="WARNING">
                <prop namespace="https://docs.oasis-open.org/sarif/sarif/v2.1.0" name="help-url" value="https://automate.fedramp.gov/documentation/ssp/4-ssp-template-to-oscal-mapping/#data-center"/>
                <!-- The message for this constraint is written with Metaschema and OSCAL jargon. It does not conform to the developer guide. -->
                <message>The value of this field in the address assembly within the abstract metadata module, with a cardinality of 0 to 1, must result with a value of 1 when evaluated by the Metapath function count.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

### FRR114

ID: `frr114`

Formal Name: Constraints Tests and Messages Have Single Item Focus

Categories: Sequences; Style

State: Recommended

Guidance: Developers SHOULD define a Metaschema constraint with `target`, `test`, and `message` fields that test and explain a positive requirement in the singular for an individual item of a sequence (i.e. occurrences of a flag, field, or assembly have a `max-occurs` greater than 1) that conforms to an OSCAL model. Violation paths and messages should discuss an individual item in the singular. The only exception is for quantitative or qualitative analysis of the whole sequence. The development team and community contributors can make a determination, meaning if the constraint is within that exceptional category, on a case-by-case basis, as this is a recommendation and not a requirement.

[back to top](#summary)

#### FRR114 Conformant Example

Below is a conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code" target="." test="count(address/country) eq 1" level="WARNING">
                <message>A FedRAMP SSP must define a location for a data center with an explicit country code.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

#### FRR114 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata"/>
        <constraints>
            <!--
                This constraint queries a document higher in the document to analyze and report on a sequence, not an item. This is not conformant with the developer guide.
            -->
            <expect id="data-center-country-code" target="." test="count(location/address/country) eq count(location)" level="WARNING">
                <message>A FedRAMP SSP needs data centers to indicate a country code.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

### FRR115

ID: `frr115`

Formal Name: Constraint Messages Have Single Item Hints

Categories: Sequences; Style

State: Recommended

Guidance: Developers SHOULD define a Metaschema constraint with a `message` field that provides contextual hints when it is for an individual item of a sequence (i.e. occurrences of a flag, field, or assembly have a `max-occurs` greater than 1) that conforms to an OSCAL model. If there is an identifier, name, or brief label (of five words or less) as applicable. Messages SHOULD NOT provide hints with machine-oriented data (i.e. fields or flags of [type UUID](https://pages.nist.gov/metaschema/specification/datatypes/#uuid)). Instead, message hints should dereference machine-oriented data to provide human-oriented clues as recommended above.

[back to top](#summary)

#### FRR115 Conformant Example

Below is a conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code-us" target="." test="count(address/country) eq 'US'" level="WARNING">
                <message>A FedRAMP SSP must define a location for a data center with the country code US for the United States, not {if empty(.) then 'not an empty value' else string(.)}.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

#### FRR115 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <!-- This constraint does not provide a contextual hint when it can. It does not conform with the developer guide. -->
            <expect id="data-center-country-code-us" target="." test="count(address/country) eq 'US'" level="WARNING">
                <message>Bad country code, pick the right one next time, fool!</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

### FRR116

ID: `frr116`

Formal Name: Constraints Formal Names Required

State: Required

Categories: Structure; Metadata

Guidance: Developers MUST define a Metaschema constraint with a `formal-name` field that provides a name for the constraint to use in documentation and tool output.

[back to top](#summary)

#### FRR116 Conformant Example

Below is a conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <expect id="data-center-country-code-us" target="." test="count(address/country) eq 'US'" level="WARNING">
                <formal-name>Data Center Locations in the United States</formal-name>
                <message>A FedRAMP SSP must define locations for data centers that are explicitly in the United States.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

#### FRR116 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <!-- This constraint does not have a formal name. It does not conform with the developer guide. -->
            <expect id="data-center-country-code-us" target="." test="count(address/country) eq 'US'" level="WARNING">
                <message>Bad country code, pick the right one next time, fool!</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

### FRR117

ID: `frr117`

Formal Name: Limit Informational Constraint Usage

State: Recommended

Categories: Structure; Metadata

Guidance: Developers SHOULD only define Metaschema constraints with a severity `level="INFORMATIONAL"` (a.k.a. informational constraints) if and only if the FedRAMP developers clearly document a specific use case where a FedRAMP package reviewer SHOULD review the analysis reported in its `message` field. The constraint SHOULD report an analytical result of processing one or more OSCAL data elements and emitting novel information for that use case. The constraint's `message`, `target`, `test` fields SHOULD NOT only be the inverse of the opposite condition of a `CRITICAL`, `ERROR`, or `WARNING` constraint.

Developers MAY use informational constraints for development and ad-hoc debugging, but such a constraint MUST NOT be merged into a branch for release to downstream stakeholders without project technical leads' approval during code review. That review SHOULD include a review of a documented use case for how FedRAMP package review or alternative stakeholder will act upon this information.

[back to top](#summary)

#### FRR117 Conformant Example

Below is a conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata"/>
        <constraints>
            <!-- 
                This example conforms because to the developer guide because it analyzes one or more data elements.
                For the purpose of this example, presume an issue at github.com/GSA/fedramp-automation/issues/XYZ justifies the need.
            -->
            <let var="data-centers-us-count" expression="count(location/prop[@name = 'data-center'])"/>
            <expect id="data-center-country-code-us" target="." test="$data-centers-us-count = 0" level="INFORMATIONAL">
                <message>This FedRAMP SSP has {$data-centers-us-count} {if $data-centers-us-count = 1 then 'data center' else 'data centers' }. This notional example assumes is important for a reviewer to know for XYZ reason.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

#### FRR117 Non-conformant Example

Below is a non-conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <!-- 
                This constraint is a simple informational constraint that inverts an expect constraint. 
                It does not conform to the developer guide.
            -->
            <expect id="data-center-country-code-us" target="./address/country" test=". != 'US'" level="INFORMATIONAL">
                <message>This informational constraint is in the report because it is in the United States.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

### FRR118

ID: `frr118`

Formal Name: Sort Let Bindings in Logical Order Before Constraints

State: Recommended

Categories: Sorting; Structure

Guidance: Developers MUST define `let` bindings before any given constraint in a `context`. Developers SHOULD define the `let` binding(s) adjacent to its dependencies in a logical order. A logical order is when developers sort the bindings in order of their dependency, where an `expression` of a later binding evaluates a `var` reference to a previous expression's value. If there are multiple `let` bindings with no dependency relationship between them, developers MAY sort the `let` bindings alphabetically by `var` value (where upper case letters are sorted before lower case letters).

[back to top](#summary)

#### FRR118 Conformant Example

Below is a conformant example.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <let var="one" expression="1"/>
            <let var="two" expression="$one + 1"/>
            <let var="three" expression="3"/>
            <let var="four" expression="4"/>           
            <expect id="A" target="." test="count(address/country) eq $one" level="WARNING">
                <message>Example of sorting.</message>
            </expect>
            <expect id="a" target="." test="count(address/country) eq $two">
                <message>Example of sorting.</message>
            </expect>
            <expect id="b" target="." test="count(address/country) eq $three">
                <message>Example of sorting.</message>
            </expect>
            <expect id="c" target="." test="count(address/country) eq $four">
                <message>Example of sorting.</message>
            </expect>            
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)

#### FRR118 Non-conformant Example

Below are non-conformant examples.

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <!--
                The let binding below cannot evaluate its expression because
                the value of one is not defined before its evaluation. This
                binding does not conform to the developer guide.
            -->
            <let var="two" expression="$one + 1"/>
            <let var="one" expression="1"/>
            <let var="three" expression="3"/>
            <let var="four" expression="4"/>           
            <expect id="A" target="." test="count(address/country) eq $one" level="WARNING">
                <message>Example of sorting.</message>
            </expect>
            <expect id="a" target="." test="count(address/country) eq $two">
                <message>Example of sorting.</message>
            </expect>
            <expect id="b" target="." test="count(address/country) eq $three">
                <message>Example of sorting.</message>
            </expect>
            <expect id="c" target="." test="count(address/country) eq $four">
                <message>Example of sorting.</message>
            </expect>            
        </constraints>
    </context>
</metaschema-meta-constraints>
```

```xml
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/system-security-plan/metadata/location"/>
        <constraints>
            <let var="one" expression="1"/>
            <let var="three" expression="3"/>
            <let var="four" expression="4"/>
            <!--
                The let binding below can evaluate its expression, but the
                separation between it and its logical depdendency makes this
                context difficult to read. This binding does not conform to the
                developer guide.
            -->            
            <let var="two" expression="$one + 1"/>
            <expect id="A" target="." test="count(address/country) eq $one" level="WARNING">
                <message>Example of sorting.</message>
            </expect>
            <expect id="a" target="." test="count(address/country) eq $two">
                <message>Example of sorting.</message>
            </expect>
            <expect id="b" target="." test="count(address/country) eq $three">
                <message>Example of sorting.</message>
            </expect>
            <expect id="c" target="." test="count(address/country) eq $four">
                <message>Example of sorting.</message>
            </expect>            
        </constraints>
    </context>
</metaschema-meta-constraints>
```

[back to top](#summary)
