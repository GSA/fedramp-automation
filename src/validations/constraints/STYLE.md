# Style Guide for FedRAMP OSCAL Constraints

## Summary

This document is to instruct FedRAMP developers and community members on mandatory or recommended style  for the structure, format, and organization of constraints. Each requirement will be given an identifier, guidance text, and examples that either do or do not conform to the best practices.

## Requirements

### FCSR-1 External Constraints <a id='fcsr-1'></a>

ID: `fcsr-1`
State: Recommended
Guidance: For FedRAMP OSCAL constraints, it is not recommended to define the constraints inline (i.e. the constraint definition is internal to a Metaschema module). The definition of all constraints SHOULD be in an external file or URL.

#### Conformant Example <a id='fcsr-1-conformant'></a>

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

#### Non-conformant Example <a id='fcsr-1-non-conformant'></a>

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