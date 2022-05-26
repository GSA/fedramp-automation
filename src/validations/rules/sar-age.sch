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
        fedramp:specific="false"
        id="sar-provenance">

        <sch:rule
            context="/">

            <sch:assert
                diagnostics="SAR-is-OSCAL-SAR-diagnostic"
                id="SAR-is-OSCAL-SAR"
                role="fatal"
                test="exists(/oscal:assessment-results)">The document is an OSCAL SAR.</sch:assert>

            <sch:let
                name="sar-uri"
                value="base-uri()" />

            <sch:report
                diagnostics="report-diagnostic"
                role="information"
                test="true()">The SAR URI is «<sch:value-of
                    select="$sar-uri" />».</sch:report>

            <sch:assert
                diagnostics="SAR-cites-SAP-diagnostic"
                id="SAR-cites-SAP"
                role="fatal"
                test="exists(//oscal:import-ap/@href)">The OSCAL SAR cites the OSCAL SAP.</sch:assert>

            <sch:let
                name="sap-uri"
                value="resolve-uri(//oscal:import-ap/@href, $sar-uri)" />

            <sch:report
                diagnostics="report-diagnostic"
                role="information"
                test="true()">The SAP URI is «<sch:value-of
                    select="$sap-uri" />».</sch:report>

            <sch:assert
                diagnostics="SAP-is-available-diagnostic"
                id="SAP-is-available"
                role="fatal"
                test="doc-available($sap-uri)"
                unit:override-xspec="both">The OSCAL SAP cited in the OSCAL SAR is available.</sch:assert>

            <sch:let
                name="SAP"
                value="doc($sap-uri)" />

            <sch:assert
                diagnostics="SAP-is-OSCAL-SAP-diagnostic"
                id="SAP-is-OSCAL-SAP"
                role="fatal"
                test="exists($SAP/oscal:assessment-plan)"
                unit:override-xspec="both">The SAP document is an OSCAL SAP.</sch:assert>

            <sch:assert
                diagnostics="SAP-cites-SSP-diagnostic"
                id="SAP-cites-SSP"
                role="fatal"
                test="$SAP//oscal:import-ssp/@href">The OSCAL SAP cites the OSCAL SSP.</sch:assert>

            <sch:let
                name="ssp-uri"
                value="resolve-uri($SAP//oscal:import-ssp/@href, $sap-uri)" />

            <sch:report
                diagnostics="report-diagnostic"
                role="information"
                test="true()">The SSP URI is «<sch:value-of
                    select="$ssp-uri" />».</sch:report>

            <sch:assert
                diagnostics="SSP-is-available-diagnostic"
                id="SSP-is-available"
                role="fatal"
                test="doc-available($ssp-uri)"
                unit:override-xspec="both">The OSCAL SSP cited in the OSCAL SAP is available.</sch:assert>

            <sch:let
                name="SSP"
                value="doc($ssp-uri)" />

            <sch:assert
                diagnostics="SSP-is-OSCAL-SSP-diagnostic"
                id="SSP-is-OSCAL-SSP"
                role="fatal"
                test="exists($SSP/oscal:system-security-plan)"
                unit:override-xspec="both">The SSP document is an OSCAL SSP.</sch:assert>

        </sch:rule>

    </sch:pattern>

    <sch:pattern
        fedramp:specific="true"
        id="sar-age-checks">

        <sch:let
            name="start-uuid"
            value="//oscal:result[xs:dateTime(oscal:start) eq max(//oscal:result/oscal:start ! xs:dateTime(.))]/@uuid" />
        <sch:let
            name="end-uuid"
            value="//oscal:result[xs:dateTime(oscal:end) eq max(//oscal:result/oscal:end ! xs:dateTime(.))]/@uuid" />

        <sch:rule
            context="oscal:result">
            <!-- This (single) context was used to avoid Schematron implementation problems -->
            <!-- Rule contexts which differ only by predicate are mishandled -->

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

            <sch:assert
                diagnostics="contemporary-assessment-diagnostic"
                id="contemporary-assessment"
                role="error"
                test="
                    if (@uuid eq $end-uuid) then
                        xs:dateTime(oscal:end) gt current-dateTime() - xs:dayTimeDuration('P365D')
                    else
                        true()">The most recently completed assessment must have been completed within the last 12
                months.</sch:assert>

            <!-- TODO: there are no intra-document indicators of currency of authorization in SSP, SAP, SAR, and POA&M -->
            <!-- Thus the 4-month assessment rule for unauthorized SSPs cannot (yet) be implemented -->

            <sch:let
                name="P60D"
                value="current-dateTime() - xs:dayTimeDuration('P60D')" />

            <sch:assert
                diagnostics="observation-is-recent-diagnostic"
                id="observation-is-recent"
                role="error"
                test="
                    if (@uuid eq $end-uuid) then
                        xs:dateTime(oscal:collected) gt $P60D
                    else
                        true()">Every observation is recently collected.</sch:assert>

            <sch:assert
                diagnostics="finding-observation-is-recent-diagnostic"
                id="finding-observation-is-recent"
                role="error"
                test="
                    if (@uuid eq $end-uuid) then
                        (every $ro in (preceding-sibling::oscal:observation[@uuid = current()/oscal:related-observation/@observation-uuid])
                            satisfies $ro/xs:dateTime(oscal:collected) gt $P60D)
                    else
                        true()">A finding has related observations which were recently collected.</sch:assert>

        </sch:rule>

        <!-- Automated tools result typification has not been defined for FedRAMP -->
        <!-- Vulnerability scan typification has not been defined for FedRAMP -->
        <!-- Thus such scans cannot be evaluated for timeliness -->

    </sch:pattern>

    <sch:diagnostics>

        <!-- provenance checks -->

        <sch:diagnostic
            id="report-diagnostic">This is an informational message (not an error).</sch:diagnostic>

        <sch:diagnostic
            id="SAR-is-OSCAL-SAR-diagnostic">The document is not an OSCAL SAR.</sch:diagnostic>

        <sch:diagnostic
            id="SAR-cites-SAP-diagnostic">The OSCAL SAR does not cite the OSCAL SAP.</sch:diagnostic>

        <sch:diagnostic
            id="SAP-is-available-diagnostic">The OSCAL SAP cited in the OSCAL SAR is not available.</sch:diagnostic>

        <sch:diagnostic
            id="SAP-is-OSCAL-SAP-diagnostic">The SAP document is not an OSCAL SAP.</sch:diagnostic>

        <sch:diagnostic
            id="SAP-cites-SSP-diagnostic">The OSCAL SAP does not cite the OSCAL SSP.</sch:diagnostic>

        <sch:diagnostic
            id="SSP-is-available-diagnostic">The OSCAL SSP cited in the OSCAL SAP is not available.</sch:diagnostic>

        <sch:diagnostic
            id="SSP-is-OSCAL-SSP-diagnostic">The SSP document is not an OSCAL SSP.</sch:diagnostic>

        <!-- age checks -->

        <sch:diagnostic
            id="start-precedes-end-diagnostic">Assessment start date is greater than assessment end date.</sch:diagnostic>

        <sch:diagnostic
            id="assessment-has-ended-diagnostic">This assessment has not ended.</sch:diagnostic>

        <sch:diagnostic
            id="contemporary-assessment-diagnostic">The most recently completed assessment is stale.</sch:diagnostic>

        <sch:diagnostic
            id="observation-is-recent-diagnostic">This observation is stale.</sch:diagnostic>

        <sch:diagnostic
            id="finding-observation-is-recent-diagnostic">This finding has a related observation which is stale.</sch:diagnostic>

    </sch:diagnostics>

</sch:schema>
