<?xml version="1.0" encoding="utf-8"?>
<?xml-model schematypens="http://purl.oclc.org/dsdl/schematron" href="../styleguides/sch.sch" phase="basic" title="Schematron Style Guide for FedRAMP Validations" ?>
<sch:schema
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
    xmlns:feddoc="http://us.gov/documentation/federal-documentation"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:unit="http://us.gov/testing/unit-testing"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <sch:ns
        prefix="f"
        uri="https://fedramp.gov/ns/oscal" />
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
    <sch:ns
        prefix="unit"
        uri="http://us.gov/testing/unit-testing" />

    <sch:phase
        id="Root">
        <sch:active
            pattern="root" />
    </sch:phase>

    <doc:xspec
        href="../test/rules/sar.xspec" />
    
    <sch:title>FedRAMP Security Assessment Results Validations</sch:title>
    <xsl:output
        encoding="UTF-8"
        indent="yes"
        method="xml" />

    <sch:pattern id="root">
        <sch:rule
            context="/oscal:assessment-results">
            <sch:assert 
                diagnostics="metadata-element-exists-diagnostic"
                id="metadata-element-exists"
                role="fatal"
                test="oscal:metadata">The oscal:metadata element exists.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:diagnostics>
        <sch:diagnostic
            doc:assertion="metadata-element-exists"
            doc:context="/oscal:assessment-results"
            id="metadata-element-exists-diagnostic">A oscal:metadata element child of oscal:assessment-results does not exist.</sch:diagnostic>
    </sch:diagnostics>
</sch:schema>
