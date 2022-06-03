<?xml version="1.0" encoding="utf-8"?>
<?xml-model schematypens="http://purl.oclc.org/dsdl/schematron" href="../styleguides/sch.sch" phase="basic" title="Schematron Style Guide for FedRAMP Validations" ?>
<sch:schema
    queryBinding="xslt2"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
    xmlns:feddoc="http://us.gov/documentation/federal-documentation"
    xmlns:fedramp="https://fedramp.gov/ns/oscal"
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

    <sch:pattern
        id="sar-age-checks">

        <!-- Note that there are no Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) references -->

        <sch:rule
            context="oscal:result">
            <!-- This (single) context was used to avoid Schematron implementation problems -->
            <!-- Rule contexts which differ only by predicate are mishandled -->


            <!-- the most recent result -->
            <sch:let
                name="start-uuid"
                value="//oscal:result[xs:dateTime(oscal:start) eq max(//oscal:result/oscal:start ! xs:dateTime(.))]/@uuid" />

            <!-- the most recent completed result -->
            <sch:let
                name="end-uuid"
                value="//oscal:result[xs:dateTime(oscal:end) eq max(//oscal:result/oscal:end ! xs:dateTime(.))]/@uuid" />

            <sch:assert
                diagnostics="assessment-has-ended-diagnostic"
                id="assessment-has-ended"
                role="warning"
                test="exists(oscal:end)">All assessments should be completed.</sch:assert>

            <sch:assert
                diagnostics="start-precedes-end-diagnostic"
                id="start-precedes-end"
                role="error"
                test="
                    if (exists(oscal:start) and exists(oscal:end)) then
                        xs:dateTime(oscal:start) lt xs:dateTime(oscal:end)
                    else
                        true()">Assessment start precedes assessment end.</sch:assert>

            <sch:let
                name="P365D"
                value="xs:dayTimeDuration('P365D')" />

            <sch:assert
                diagnostics="has-contemporary-assessment-diagnostic"
                id="has-contemporary-assessment"
                role="error"
                see="https://github.com/18F/fedramp-automation/issues/348"
                test="
                    if (@uuid eq $end-uuid) then
                        xs:dateTime(oscal:end) gt current-dateTime() - $P365D
                    else
                        true()">The most recently completed assessment must have been completed within the last 12
                months.</sch:assert>

            <!-- TODO: there are no intra-document indicators of currency of authorization in SSP, SAP, SAR, and POA&M -->
            <!-- Thus the 4-month assessment rule for unauthorized SSPs cannot (yet) be implemented -->

            <sch:let
                name="P180D"
                value="current-dateTime() - xs:dayTimeDuration('P180D')" />

            <sch:assert
                diagnostics="result-observations-are-recent-diagnostic"
                fedramp:specific="true"
                id="result-observations-are-recent"
                role="error"
                see="https://github.com/18F/fedramp-automation/issues/348"
                test="
                    if (@uuid eq $end-uuid) then
                        every $c in descendant::oscal:observation/oscal:collected
                            satisfies
                            $c castable as xs:dateTime and xs:dateTime($c) gt $P180D
                    else
                        true()">Every observation within this most recent result is recently collected.</sch:assert>

        </sch:rule>

        <!-- Automated tools result typification has not been defined for FedRAMP -->
        <!-- Vulnerability scan typification has not been defined for FedRAMP -->
        <!-- Thus such scans cannot be evaluated for timeliness -->

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

        <!-- age checks -->

        <sch:diagnostic
            doc:assert="start-precedes-end"
            doc:context="oscal:result"
            id="start-precedes-end-diagnostic">Assessment start date is greater than assessment end date.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="assessment-has-ended"
            doc:context="oscal:result"
            id="assessment-has-ended-diagnostic">This assessment has not ended.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-contemporary-assessment"
            doc:context="oscal:result"
            id="has-contemporary-assessment-diagnostic">The most recently completed assessment is older than 12 months.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="result-observations-are-recent"
            doc:context="oscal:result"
            id="result-observations-are-recent-diagnostic">This most recent result has observations older than <sch:value-of
                select="$P180D" /> (180 days ago).</sch:diagnostic>

    </sch:diagnostics>

</sch:schema>
