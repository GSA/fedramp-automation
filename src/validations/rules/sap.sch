<?xml version="1.0" encoding="utf-8"?>
<?xml-model schematypens="http://purl.oclc.org/dsdl/schematron" href="../styleguides/sch.sch" phase="advanced" title="Schematron Style Guide for FedRAMP Validations" ?>
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
        href="../test/rules/sap.xspec" />

    <sch:title>FedRAMP Security Assessment Plan Validations</sch:title>
    <!-- Global Variables -->
    <sch:let
        name="ssp-href"
        value="resolve-uri(/oscal:assessment-plan/oscal:import-ssp/@href, base-uri())" />
    <sch:let
        name="ssp-available"
        value="
        if (: this is not a relative reference :) (not(starts-with(@href, '#')))
        then
        (: the referenced document must be available :)
        doc-available($ssp-href)
        else
        true()" />
    <sch:let
        name="ssp-doc"
        value="
            if ($ssp-available)
            then
                doc($ssp-href)
            else
                ()" />
    <sch:let
        name="no-oscal-ssp"
        value="boolean(/oscal:assessment-plan/oscal:back-matter/oscal:resource/oscal:prop[@name = 'type' and @value eq 'no-oscal-ssp'])" />

<!-- Patterns -->
    <sch:pattern
        id="import-ssp">

        <sch:rule
            context="oscal:assessment-plan">

            <sch:assert
                diagnostics="has-import-ssp-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §3.5"
                id="has-import-ssp"
                role="error"
                test="oscal:import-ssp">An OSCAL SAP must have an import-ssp element.</sch:assert>

            <sch:let
                name="web-apps"
                value="
                $ssp-doc//oscal:component[oscal:prop[@name = 'type' and @value eq 'web-application']]/@uuid  |
                $ssp-doc//oscal:inventory-item[oscal:prop[@name = 'type' and @value eq 'web-application']]/@uuid |
                //oscal:local-definitions/oscal:activity[oscal:prop[@value eq 'web-application']]/@uuid" />
            <sch:let name="sap-web-tasks"
                value="//oscal:task[oscal:prop[@value='web-application']]/oscal:associated-activity/@activity-uuid ! xs:string(.)"/>
            <sch:let name="missing-web-tasks"
                value="$web-apps[not(. = $sap-web-tasks)]"/>
            <sch:assert
                diagnostics="has-web-applications-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.5"
                fedramp:specific="true()"
                id="has-web-applications"
                role="error"
                see="https://github.com/GSA/fedramp-automation-guides/issues/31"
                test="count($web-apps[not(. = $sap-web-tasks)]) = 0"
                unit:override-xspec="both">For every web interface to be tested there must be a matching task entry.</sch:assert>
            
            <sch:assert
                diagnostics="has-location-assessment-subject-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.3"
                id="has-location-assessment-subject"
                role="error"
                test="exists(oscal:assessment-subject[@type='location'])">A FedRAMP SAP must have a assesment-subject with a type of 'location'.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:import-ssp">

            <sch:assert
                diagnostics="has-import-ssp-href-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §3.5"
                id="has-import-ssp-href"
                role="error"
                test="exists(@href)">An OSCAL SAP import-ssp element must have an href attribute.</sch:assert>

            <sch:assert
                diagnostics="has-import-ssp-internal-href-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §3.5"
                id="has-import-ssp-internal-href"
                role="error"
                test="
                    if (: this is a relative reference :) (matches(@href, '^#'))
                    then
                        (: the reference must exist within the document :)
                        exists(//oscal:resource[@uuid eq substring-after(current()/@href, '#')])
                    else
                        (: the assertion succeeds :)
                        true()">An OSCAL SAP import-ssp element href attribute which is document-relative must identify a target
                within the document. <sch:value-of
                    select="@href" />.</sch:assert>

            <sch:let
                name="import-ssp-url"
                value="resolve-uri(@href, base-uri())" />

            <sch:assert
                diagnostics="has-import-ssp-external-href-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §3.5"
                id="has-import-ssp-external-href"
                role="error"
                test="
                    if (: this is not a relative reference :) (not(starts-with(@href, '#')))
                    then
                        (: the referenced document must be available :)
                        doc-available($import-ssp-url)
                    else
                        (: the assertion succeeds :)
                        true()"
                unit:override-xspec="both">An OSCAL SAP import-ssp element href attribute which is an external reference must identify an available
                target.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:back-matter">

            <sch:assert
                diagnostics="has-system-security-plan-resource-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §3.5"
                id="has-system-security-plan-resource"
                role="error"
                test="
                    if (matches(//oscal:import-ssp/@href, '^#'))
                    then
                        (: there must be a system-security-plan resource :)
                        exists(oscal:resource[oscal:prop[@name eq 'type' and @value eq 'system-security-plan']])
                    else
                        (: the assertion succeeds :)
                        true()">An OSCAL SAP which does not directly import the SSP must declare the SSP as a back-matter
                resource.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'system-security-plan']]">

            <sch:assert
                diagnostics="has-ssp-rlink-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §3.5"
                id="has-ssp-rlink"
                role="error"
                test="exists(oscal:rlink) and not(exists(oscal:rlink[2]))">An OSCAL SAP with a SSP resource declaration must have one and only one
                rlink element.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'no-oscal-ssp']]">

            <sch:assert
                diagnostics="has-non-OSCAL-system-security-plan-resource-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §3.5.2"
                id="has-non-OSCAL-system-security-plan-resource"
                role="warning"
                test="
                    (: always warn :)
                    false()">An OSCAL SAP which lacks an OSCAL SSP must declare a no-oscal-ssp resource.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'system-security-plan']]/oscal:rlink">

            <sch:assert
                diagnostics="has-acceptable-system-security-plan-rlink-media-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §3.5"
                id="has-acceptable-system-security-plan-rlink-media-type"
                role="error"
                test="@media-type = ('text/xml', 'application/json')">An OSCAL SAP SSP rlink must have a 'text/xml' or 'application/json'
                media-type.</sch:assert>

            <!-- TODO: check document availability when $use-remote-resources is made common -->

        </sch:rule>

        <sch:rule
            context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'system-security-plan']]/oscal:base64">

            <sch:assert
                diagnostics="has-no-base64-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §3.5"
                id="has-no-base64"
                role="error"
                test="false()">An OSCAL SAP must not use a base64 element in a system-security-plan resource.</sch:assert>

        </sch:rule>
        
        <sch:rule
            context="oscal:task[oscal:prop[@value = 'web-application']]">
            <sch:let
                name="ssp-web-apps"
                value="
                    $ssp-doc/oscal:component[oscal:prop[@name = 'type' and @value eq 'web-application']]/@uuid ! xs:string(.) |
                    $ssp-doc/oscal:inventory-item[oscal:prop[@name = 'type' and @value eq 'web-application']]/@uuid ! xs:string(.)" />
            <sch:let
                name="sap-web-apps"
                value="/oscal:assessment-plan//oscal:local-definitions/oscal:activity[oscal:prop[@value eq 'web-application']]/@uuid ! xs:string(.)" />
            <sch:assert
                diagnostics="matches-web-app-task-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.5"
                fedramp:specific="true"
                id="matches-web-app-task"
                role="error"
                test="oscal:associated-activity/@activity-uuid = $ssp-web-apps or oscal:associated-activity/@activity-uuid = $sap-web-apps"
                unit:override-xspec="both">Web applications targeted by associated activity must exist in either the SAP or SSP.</sch:assert>
            <sch:assert
                diagnostics="has-login-url-task-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.5"
                fedramp:specific="true"
                id="has-login-url-task"
                role="error"
                test="exists(oscal:prop[@name = 'login-url'])">FedRAMP SAP Web Application Tasks must have login-url information.</sch:assert>
            <sch:assert
                diagnostics="has-login-id-task-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.5"
                fedramp:specific="true"
                id="has-login-id-task"
                role="error"
                test="exists(oscal:prop[@name = 'login-id'])">FedRAMP SAP Web Application Tasks must have login-id information.</sch:assert>
        </sch:rule>

    </sch:pattern>

    <sch:pattern
        id="assessment-subject">
        <sch:rule
            context="oscal:include-subject[@type = 'component'] | oscal:exclude-subject[@type = 'component']">
            <sch:assert
                diagnostics="component-uuid-matches-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.4, §4.4.1"
                fedramp:specific="true"
                id="component-uuid-matches"
                role="error"
                test="
                    @subject-uuid[. = $ssp-doc//oscal:component[@type = 'subnet']/@uuid ! xs:string(.)] or
                    @subject-uuid[. = //oscal:local-definitions//oscal:inventory-item/@uuid ! xs:string(.)]"
                unit:override-xspec="both">Component targeted by include or exclude subject must exist in the SAP or SSP.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:assessment-subject[@type = 'location']">
            <sch:assert
                diagnostics="location-not-include-all-element-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.3"
                fedramp:specific="true"
                id="location-not-include-all-element"
                role="error"
                test="not(exists(oscal:include-all))">The FedRAMP SAP references locations individually.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:include-subject[@type='location']">
            <sch:let
                name="ssp-locations"
                value="$ssp-doc/oscal:system-security-plan/oscal:metadata//oscal:location/@uuid ! xs:string(.)" />
            <sch:let
                name="sap-locations"
                value="/oscal:assessment-plan/oscal:metadata//oscal:location/@uuid ! xs:string(.)" />
            <sch:assert
                diagnostics="location-uuid-matches-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.3, §4.3.1"
                fedramp:specific="true"
                id="location-uuid-matches"
                role="error"
                test="@subject-uuid = $ssp-locations or @subject-uuid = $sap-locations"
                unit:override-xspec="both">Locations targeted by include subject must exist in the SAP or SSP.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        id="pentest">

        <sch:rule
            context="oscal:assessment-plan">

            <sch:assert
                diagnostics="has-terms-and-conditions-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.8"
                fedramp:specific="true"
                id="has-terms-and-conditions"
                role="error"
                test="oscal:terms-and-conditions">The SAP contains terms and conditions.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:terms-and-conditions">

            <sch:assert
                diagnostics="has-methodology-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.9"
                fedramp:specific="true"
                id="has-methodology"
                role="error"
                test="oscal:part[@name eq 'methodology']">The SAP terms and conditions must contain a description of the methodology which will be
                used.</sch:assert>

            <sch:assert
                diagnostics="has-disclosures-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.17"
                fedramp:specific="true"
                id="has-disclosures"
                role="error"
                test="oscal:part[@name eq 'disclosures']">The SAP terms and conditions must contain Rules of Engagement (ROE)
                Disclosures.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:terms-and-conditions/oscal:part[@name eq 'methodology']">

            <sch:assert
                diagnostics="has-sampling-method-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.9"
                fedramp:specific="true"
                id="has-sampling-method"
                role="error"
                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'sampling']">The SAP declares a sampling method.</sch:assert>

            <sch:assert
                diagnostics="has-allowed-sampling-method-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.9"
                fedramp:specific="true"
                id="has-allowed-sampling-method"
                role="error"
                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'sampling' and @value = ('yes', 'no')]">The SAP declares whether a
                sampling method is used.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:terms-and-conditions/oscal:part[@name eq 'disclosures']">

            <sch:assert
                diagnostics="has-roe-disclosure-detail-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.17"
                fedramp:specific="true"
                id="has-roe-disclosure-detail"
                role="error"
                test="oscal:part[@name eq 'disclosure']">The SAP Rules of Engagement (ROE) Disclosures have one or more detail disclosure
                statements.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:back-matter">

            <sch:assert
                diagnostics="has-penetration-test-plan-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.26"
                fedramp:specific="true"
                id="has-penetration-test-plan"
                role="warning"
                test="oscal:resource[oscal:prop[@name eq 'type' and @value eq 'penetration-test-plan']]">The penetration test plan methodology
                attachment should be present.</sch:assert>

        </sch:rule>

    </sch:pattern>

    <sch:pattern
        id="signed-sap">

        <sch:rule
            context="oscal:back-matter">

            <sch:assert
                diagnostics="has-signed-sap-resource-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.26"
                id="has-signed-sap-resource"
                role="error"
                test="exists(oscal:resource[oscal:prop[@name eq 'type' and @value eq 'signed-sap']])">An OSCAL SAP must have a `signed-sap`
                resource.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:resource[oscal:prop[@name eq 'type' and @value eq 'signed-sap']]">

            <sch:assert
                diagnostics="signed-sap-resource-has-description-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.26"
                id="signed-sap-resource-has-description"
                role="warning"
                test="exists(oscal:description)">An OSCAL SAP `signed-sap` resource must have a description.</sch:assert>

            <sch:assert
                diagnostics="signed-sap-resource-has-rlink-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.26"
                id="signed-sap-resource-has-rlink"
                role="error"
                test="exists(oscal:rlink)">An OSCAL SAP `signed-sap` resource must have an rlink.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:resource[oscal:prop[@name eq 'type' and @value eq 'signed-sap']]/oscal:rlink">

            <sch:assert
                diagnostics="signed-sap-rlink-has-media-type-pdf-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.26"
                id="signed-sap-rlink-has-media-type-pdf"
                role="warning"
                test="@media-type eq 'application/pdf'">An OSCAL SAP `signed-sap` resource rlink should use 'application/pdf' media-type.</sch:assert>

        </sch:rule>

        <!-- TODO: see https://github.com/GSA/fedramp-automation-guides/issues/16 regarding base64 resolution -->

    </sch:pattern>

    <sch:diagnostics>

        <sch:diagnostic
            doc:assert="has-import-ssp"
            doc:context="oscal:assessment-plan"
            id="has-import-ssp-diagnostic">This OSCAL SAP lacks have an import-ssp element.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-location-assessment-subject"
            doc:context="oscal:assessment-plan"
            id="has-location-assessment-subject-diagnostic">This FedRAMP SAP does not have an assessment-subject with the type of
            'location'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-import-ssp-href"
            doc:context="oscal:import-ssp"
            id="has-import-ssp-href-diagnostic">This OSCAL SAP import-ssp element lacks an href attribute.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-import-ssp-internal-href"
            doc:context="oscal:import-ssp"
            id="has-import-ssp-internal-href-diagnostic">This OSCAL SAP import-ssp element href attribute which is document-relative does not identify
            a target within the document.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-import-ssp-external-href"
            doc:context="oscal:import-ssp"
            id="has-import-ssp-external-href-diagnostic">This OSCAL SAP import-ssp element href attribute which is an external reference does not
            identify an available target.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-system-security-plan-resource"
            doc:context="oscal:back-matter"
            id="has-system-security-plan-resource-diagnostic">This OSCAL SAP which does not directly import the SSP does not declare the SSP as a
            back-matter resource.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-ssp-rlink"
            doc:context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'system-security-plan']]"
            id="has-ssp-rlink-diagnostic">This OSCAL SAP with a SSP resource declaration does not have one and only one rlink
            element.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-non-OSCAL-system-security-plan-resource"
            doc:context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'no-oscal-ssp]]"
            id="has-non-OSCAL-system-security-plan-resource-diagnostic">This OSCAL SAP has a non-OSCAL SSP.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-acceptable-system-security-plan-rlink-media-type"
            doc:context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'system-security-plan']]/oscal:rlink"
            id="has-acceptable-system-security-plan-rlink-media-type-diagnostic">This OSCAL SAP SSP rlink does not have a 'text/xml' or
            'application/json' media-type.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-no-base64"
            doc:context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'system-security-plan']]/oscal:base64"
            id="has-no-base64-diagnostic">This OSCAL SAP has a base64 element in a system-security-plan resource.</sch:diagnostic>
        <sch:diagnostic
            doc:assert="location-not-include-all-element"
            doc:context="oscal:assessment-subject[@type='location']"
            id="location-not-include-all-element-diagnostic">This FedRAMP SAP assessment-subject[@type='location'] cannot have an include-all
            child.</sch:diagnostic>
        <sch:diagnostic
            doc:assert="location-uuid-matches"
            doc:context="oscal:assessment-subject[@type='location']"
            id="location-uuid-matches-diagnostic">This include-subject, <sch:value-of
                select="@subject-uuid" />, references a non-existent (neither in the SSP nor SAP) location.</sch:diagnostic>
        <sch:diagnostic
            doc:assert="component-uuid-matches-diagnostic"
            doc:context="oscal:assessment-subject[@type='location']"
            id="component-uuid-matches-diagnostic">This include or exclude subject, <sch:value-of
                select="@subject-uuid" />, does not have a matching SSP component or SAP inventory-item.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="matches-web-app-task"
            doc:context="oscal:task[oscal:prop[@name = 'type' and @value eq 'web-application']]"
            id="matches-web-app-task-diagnostic">This associated-activity, <sch:value-of
                select="oscal:associated-activity/@activity-uuid" />, references a non-existent (neither in the SSP nor SAP) web application.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-login-url-task"
            doc:context="oscal:task[oscal:prop[@name = 'type' and @value eq 'web-application']]"
            id="has-login-url-task-diagnostic">This task, <sch:value-of
                select="../@uuid" />, does not contain login-url information.</sch:diagnostic>
        
        <sch:diagnostic
            doc:assert="has-login-id-task"
            doc:context="oscal:task[oscal:prop[@name = 'type' and @value eq 'web-application']]"
            id="has-login-id-task-diagnostic">This task, <sch:value-of
                select="../@uuid" />, does not contain login-id information.</sch:diagnostic>
        
        <sch:diagnostic
            doc:assert="has-web-applications"
            doc:context="oscal:assessment-plan"
            id="has-web-applications-diagnostic">These web testing activities, <sch:value-of
                select="$missing-web-tasks" />, do not have matching tasks in the SSP or SAP.</sch:diagnostic>
        
        <sch:diagnostic
            doc:assert="has-terms-and-conditions-diagnostic"
            doc:context="oscal:assessment-plan"
            id="has-terms-and-conditions-diagnostic">The SAP lacks terms and conditions.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-methodology-diagnostic"
            doc:context="oscal:terms-and-conditions"
            id="has-methodology-diagnostic">The SAP terms and conditions lacks a description of the methodology which will be used.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-disclosures-diagnostic"
            doc:context="oscal:terms-and-conditions"
            id="has-disclosures-diagnostic">The SAP terms and conditions lacks Rules of Engagement (ROE) Disclosures.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-sampling-method-diagnostic"
            doc:context="oscal:terms-and-conditions/part[@name eq 'methodology']"
            id="has-sampling-method-diagnostic">The SAP lacks a sampling method.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-allowed-sampling-method-diagnostic"
            doc:context="oscal:terms-and-conditions/part[@name eq 'methodology']"
            id="has-allowed-sampling-method-diagnostic">The SAP fails to declare whether a sampling method is used.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-roe-disclosure-detail-diagnostic"
            doc:context="oscal:terms-and-conditions/part[@name eq 'disclosures']"
            id="has-roe-disclosure-detail-diagnostic">The SAP Rules of Engagement (ROE) Disclosures lacks detail disclosure
            statements.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-penetration-test-plan"
            doc:context="oscal:back-matter"
            id="has-penetration-test-plan-diagnostic">The penetration test plan methodology attachment is not present.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-signed-sap-resource"
            doc:context="oscal:back-matter"
            id="has-signed-sap-resource-diagnostic">This OSCAL SAP lacks a `signed-sap` resource.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="signed-sap-resource-has-description"
            doc:context="oscal:resource[oscal:prop[@name eq 'type' and @value eq 'signed-sap']]"
            id="signed-sap-resource-has-description-diagnostic">This OSCAL SAP `signed-sap` resource lacks a description.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="signed-sap-resource-has-rlink"
            doc:context="oscal:resource[oscal:prop[@name eq 'type' and @value eq 'signed-sap']]"
            id="signed-sap-resource-has-rlink-diagnostic">This OSCAL SAP `signed-sap` resource lacks an rlink.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="signed-sap-rlink-has-media-type-pdf"
            doc:context="oscal:resource[oscal:prop[@name eq 'type' and @value eq 'signed-sap']]/oscal:rlink"
            id="signed-sap-rlink-has-media-type-pdf-diagnostic">This OSCAL SAP `signed-sap` resource rlink does not use 'application/pdf'
            media-type.</sch:diagnostic>

    </sch:diagnostics>

</sch:schema>
