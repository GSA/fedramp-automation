<?xml version="1.0" encoding="utf-8"?>
<?xml-model schematypens="http://purl.oclc.org/dsdl/schematron" href="../styleguides/sch.sch" phase="basic" title="Schematron Style Guide for FedRAMP Validations" ?>
<sch:schema
    queryBinding="xslt2"
    xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
    xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <sch:ns
        prefix="oscal"
        uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns
        prefix="doc"
        uri="https://fedramp.gov/oscal/fedramp-automation-documentation" />
    <sch:ns
        prefix="fedramp"
        uri="https://fedramp.gov/ns/oscal" />

    <sch:phase
        id="Root">
        <sch:active
            pattern="root" />
    </sch:phase>

    <doc:xspec
        href="../test/sar.xspec" />
    
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
