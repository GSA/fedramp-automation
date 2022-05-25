<?xml version="1.0" encoding="utf-8"?>
<?xml-model schematypens="http://purl.oclc.org/dsdl/schematron" href="../styleguides/sch.sch" phase="basic" title="Schematron Style Guide for FedRAMP Validations" ?>
<sch:schema
    queryBinding="xslt2"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
    xmlns:feddoc="http://us.gov/documentation/federal-documentation"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:unit="http://us.gov/testing/unit-testing">

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
        prefix="array"
        uri="http://www.w3.org/2005/xpath-functions/array" />
    <sch:ns
        prefix="map"
        uri="http://www.w3.org/2005/xpath-functions/map" />
    <sch:ns
        prefix="unit"
        uri="http://us.gov/testing/unit-testing" />

    <doc:xspec
        href="../test/rules/sar.xspec" />

    <sch:title>FedRAMP Security Assessment Results Validations</sch:title>

    <sch:pattern
        id="import-ap">

        <!-- 
            NB:
            Guide to OSCAL-based FedRAMP Security Assessment Plans (SAR) §3.5 asserts
            "The SAR must import an OSCAL-based SAP, even if no OSCAL-based SSP exists."
            This means there is no accomodation for a non-OSCAL SAP.
        -->

        <sch:rule
            context="oscal:assessment-plan">

            <sch:assert
                diagnostics="has-import-ap-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAR) §3.5"
                id="has-import-ap"
                role="error"
                test="oscal:import-ap">An OSCAL SAR must have an import-ap element.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:import-ap">

            <sch:assert
                diagnostics="has-import-ap-href-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAR) §3.5"
                id="has-import-ap-href"
                role="error"
                test="exists(@href)">An OSCAL SAR import-ap element must have an href attribute.</sch:assert>

            <sch:assert
                diagnostics="has-import-ap-internal-href-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAR) §3.5"
                id="has-import-ap-internal-href"
                role="error"
                test="
                    if (: this is a relative reference :) (matches(@href, '^#'))
                    then
                        (: the reference must exist within the document :)
                        exists(//oscal:resource[@uuid eq substring-after(current()/@href, '#')])
                    else
                        (: the assertion succeeds :)
                        true()">An OSCAL SAR import-ap element href attribute which is document-relative must identify a target within
                the document. <sch:value-of
                    select="@href" />.</sch:assert>

            <sch:let
                name="import-ap-url"
                value="resolve-uri(@href, base-uri())" />

            <sch:assert
                diagnostics="has-import-ap-external-href-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAR) §3.5"
                id="has-import-ap-external-href"
                role="error"
                test="
                    if (: this is not a relative reference :) (not(starts-with(@href, '#')))
                    then
                        (: the referenced document must be available :)
                        doc-available($import-ap-url)
                    else
                        (: the assertion succeeds :)
                        true()"
                unit:override-xspec="both">An OSCAL SAR import-ap element href attribute which is an external reference must identify an available
                target.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:back-matter">

            <!-- TODO: fedramp_values does has no entry for an assessment plan resource -->
            <!-- TODO: Guide to OSCAL-based FedRAMP Security Assessment Plans (SAR) §3.5 uses the type "sap" -->

            <sch:assert
                diagnostics="has-security-assessment-plan-resource-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAR) §3.5"
                id="has-security-assessment-plan-resource"
                role="error"
                test="
                    if (matches(//oscal:import-ap/@href, '^#'))
                    then
                        (: there must be a security-assessment-plan resource :)
                        exists(oscal:resource[oscal:prop[@name eq 'type' and @value eq 'security-assessment-plan']])
                    else
                        (: the assertion succeeds :)
                        true()">An OSCAL SAR which does not directly import the SAP must declare the SAP as a back-matter
                resource.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'security-assessment-plan']]">

            <sch:assert
                diagnostics="has-sap-rlink-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAR) §3.5"
                id="has-sap-rlink"
                role="error"
                test="exists(oscal:rlink) and not(exists(oscal:rlink[2]))">An OSCAL SAR with a SAP resource declaration must have one and only one
                rlink element.</sch:assert>

        </sch:rule>


        <sch:rule
            context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'security-assessment-plan']]/oscal:rlink">

            <sch:assert
                diagnostics="has-acceptable-security-assessment-plan-rlink-media-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAR) §3.5"
                id="has-acceptable-security-assessment-plan-rlink-media-type"
                role="error"
                test="@media-type = ('text/xml', 'application/json')">An OSCAL SAR SAP rlink must have a 'text/xml' or 'application/json'
                media-type.</sch:assert>

            <!-- TODO: check document availability when $use-remote-resources is made common -->

        </sch:rule>

        <!-- TODO: 
            Guide to OSCAL-based FedRAMP Security Assessment Plans (SAR) §3.5 allows base64
            but it also uses href on base64 so may be bogus.
            Commented out base64 restriction until verified.
        -->
        
        <!--<sch:rule
            context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'security-assessment-plan']]/oscal:base64">

            <sch:assert
                diagnostics="has-no-base64-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAR) §3.5"
                id="has-no-base64"
                role="error"
                test="false()">An OSCAL SAR must not use a base64 element in a security-assessment-plan resource.</sch:assert>

        </sch:rule>-->

    </sch:pattern>

    <sch:diagnostics>

        <sch:diagnostic
            doc:assert="has-import-ap"
            doc:context="oscal:assessment-plan"
            id="has-import-ap-diagnostic">This OSCAL SAR lacks have an import-ap element.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-import-ap-href"
            doc:context="oscal:import-ap"
            id="has-import-ap-href-diagnostic">This OSCAL SAR import-ap element lacks an href attribute.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-import-ap-internal-href"
            doc:context="oscal:import-ap"
            id="has-import-ap-internal-href-diagnostic">This OSCAL SAR import-ap element href attribute which is document-relative does not identify a
            target within the document.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-import-ap-external-href"
            doc:context="oscal:import-ap"
            id="has-import-ap-external-href-diagnostic">This OSCAL SAR import-ap element href attribute which is an external reference does not
            identify an available target.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-security-assessment-plan-resource"
            doc:context="oscal:back-matter"
            id="has-security-assessment-plan-resource-diagnostic">This OSCAL SAR which does not directly import the SAP does not declare the SAP as a
            back-matter resource.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-sap-rlink"
            doc:context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'security-assessment-plan']]"
            id="has-sap-rlink-diagnostic">This OSCAL SAR with a SAP resource declaration does not have one and only one rlink
            element.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-acceptable-security-assessment-plan-rlink-media-type"
            doc:context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'security-assessment-plan']]/oscal:rlink"
            id="has-acceptable-security-assessment-plan-rlink-media-type-diagnostic">This OSCAL SAR SAP rlink does not have a 'text/xml' or
            'application/json' media-type.</sch:diagnostic>

        <!--<sch:diagnostic
            doc:assert="has-no-base64"
            doc:context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'security-assessment-plan']]/oscal:base64"
            id="has-no-base64-diagnostic">This OSCAL SAR has a base64 element in a security-assessment-plan resource.</sch:diagnostic>-->

    </sch:diagnostics>

</sch:schema>
