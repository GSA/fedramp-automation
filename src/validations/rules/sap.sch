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
        name="ssp-import-url"
        value="
            if (starts-with(/oscal:assessment-plan/oscal:import-ssp/@href, '#'))
            then
                resolve-uri(/oscal:assessment-plan/oscal:back-matter/oscal:resource[substring-after(/oscal:assessment-plan/oscal:import-ssp/@href, '#') = @uuid]/oscal:rlink[1]/@href, base-uri())
            else
                resolve-uri(/oscal:assessment-plan/oscal:import-ssp/@href, base-uri())" />
    <sch:let
        name="ssp-available"
        value="
            if (: this is not a relative reference :) (not(starts-with($ssp-import-url, '#')))
            then
                (: the referenced document must be available :)
                doc-available($ssp-import-url)
            else
                true()" />
    <sch:let
        name="ssp-doc"
        value="
            if ($ssp-available)
            then
                doc($ssp-import-url)
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

            <sch:assert
                diagnostics="has-user-assessment-subject-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.7"
                fedramp:specific="true"
                id="has-user-assessment-subject"
                role="error"
                test="exists(oscal:assessment-subject[@type = 'user'])">A FedRAMP SAP must have an assesment-subject with a type of
                'user'.</sch:assert>

            <sch:let
                name="web-apps"
                value="
                    $ssp-doc//oscal:component[oscal:prop[@name = 'type' and @value eq 'web-application']]/@uuid |
                    $ssp-doc//oscal:inventory-item[oscal:prop[@name = 'type' and @value eq 'web-application']]/@uuid |
                    //oscal:local-definitions/oscal:activity[oscal:prop[@value eq 'web-application']]/@uuid" />
            <sch:let
                name="sap-web-tasks"
                value="//oscal:task[oscal:prop[@value = 'web-application']]/oscal:associated-activity/@activity-uuid ! xs:string(.)" />
            <sch:let
                name="missing-web-tasks"
                value="$web-apps[not(. = $sap-web-tasks)]" />
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
                fedramp:specific="true"
                id="has-location-assessment-subject"
                role="error"
                test="exists(oscal:assessment-subject[@type = 'location'])">A FedRAMP SAP must have a assessment-subject with a type of
                'location'.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:import-ssp">

            <sch:assert
                diagnostics="has-import-ssp-href-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §3.5"
                id="has-import-ssp-href"
                role="fatal"
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

            <sch:assert
                diagnostics="import-ssp-has-available-document-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans §3.5"
                id="import-ssp-has-available-document"
                role="fatal"
                test="$ssp-available = true()"
                unit:override-xspec="both">The import-ssp element href attribute references an available document.</sch:assert>

            <sch:assert
                diagnostics="import-ssp-resolves-to-ssp-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans §3.5"
                id="import-ssp-resolves-to-ssp"
                role="fatal"
                test="$ssp-doc/oscal:system-security-plan"
                unit:override-xspec="both">The import-ssp element href attribute references an available OSCAL system security plan
                document.</sch:assert>

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
                fedramp:specific="true"
                id="has-ssp-rlink"
                role="error"
                test="exists(oscal:rlink) and not(exists(oscal:rlink[2]))">A FedRAMP SAP with a SSP resource declaration must have one and only one
                rlink element.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'no-oscal-ssp']]">

            <sch:assert
                diagnostics="has-non-OSCAL-system-security-plan-resource-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §3.5.2"
                fedramp:specific="true"
                id="has-non-OSCAL-system-security-plan-resource"
                role="warning"
                test="
                    (: always warn :)
                    false()">A FedRAMP SAP which lacks an OSCAL SSP must declare a no-oscal-ssp resource.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'system-security-plan']]/oscal:rlink">

            <sch:assert
                diagnostics="has-acceptable-system-security-plan-rlink-media-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §3.5"
                fedramp:specific="true"
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
                fedramp:specific="true"
                id="has-no-base64"
                role="error"
                test="false()">A FedRAMP SAP must not use a base64 element in a system-security-plan resource.</sch:assert>

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
        id="control-selection">
        <sch:let
            name="ssp-control-ids"
            value="$ssp-doc//oscal:implemented-requirement/@control-id ! xs:string(.)" />
        <sch:rule
            context="oscal:control-selection">
            <sch:let
                name="exclude-control-ids"
                value="oscal:exclude-control/@control-id ! xs:string(.)" />
            <sch:let
                name="include-control-ids"
                value="oscal:include-control/@control-id ! xs:string(.)" />
            <sch:let
                name="matching-control-ids"
                value="$exclude-control-ids[. = $include-control-ids]" />
            <sch:assert
                diagnostics="include-all-or-include-control-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.1"
                id="include-all-or-include-control"
                role="fatal"
                test="(oscal:include-all and not(oscal:include-control)) or (oscal:include-control and not(oscal:include-all))">An OSCAL SAP control
                selection elements must have either an include-all element or include-control element(s) children.</sch:assert>
            <sch:assert
                diagnostics="duplicate-exclude-control-and-include-control-values-diagnostic"
                id="duplicate-exclude-control-and-include-control-values"
                role="error"
                test="count($matching-control-ids) = 0">The exclude-control and include-control sibling element @control-id values must be
                different.</sch:assert>
            <sch:assert
                diagnostics="duplicate-include-control-values-diagnostic"
                id="duplicate-include-control-values"
                role="error"
                test="count($include-control-ids) eq count(distinct-values($include-control-ids))">The include-control/@control-id values must not be
                duplicated.</sch:assert>
            <sch:assert
                diagnostics="duplicate-exclude-control-values-diagnostic"
                id="duplicate-exclude-control-values"
                role="error"
                test="count($exclude-control-ids) eq count(distinct-values($exclude-control-ids))">The exclude-control/@control-id values must not be
                duplicated.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:include-control">
            <sch:assert
                diagnostics="control-inclusion-values-exist-in-ssp-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.1"
                id="control-inclusion-values-exist-in-ssp"
                role="error"
                test="@control-id[. = $ssp-control-ids]"
                unit:override-xspec="both">SAP included controls are identified in the associated SSP. </sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:exclude-control">
            <sch:assert
                diagnostics="control-exclusion-values-exist-in-ssp-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.1"
                id="control-exclusion-values-exist-in-ssp"
                role="error"
                test="@control-id[. = $ssp-control-ids]"
                unit:override-xspec="both">SAP excluded controls are identified in the associated SSP. </sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern
        id="control-objective-selection">
        <sch:rule
            context="oscal:control-objective-selection">
            <sch:let
                name="exclude-control-objective-ids"
                value="oscal:exclude-objective/@objective-id ! xs:string(.)" />
            <sch:let
                name="include-control-objective-ids"
                value="oscal:include-objective/@objective-id ! xs:string(.)" />
            <sch:let
                name="matching-control-objective-ids"
                value="$exclude-control-objective-ids[. = $include-control-objective-ids]" />

            <sch:assert
                diagnostics="include-all-or-include-objective-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.24"
                id="include-all-or-include-objective"
                role="fatal"
                test="(oscal:include-all and not(oscal:include-objective)) or (oscal:include-objective and not(oscal:include-all))">An OSCAL SAP
                control objective selection element must have either an include-all element or include-control element(s) children.</sch:assert>

            <sch:assert
                diagnostics="duplicate-exclude-objective-and-include-objective-values-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.1"
                id="duplicate-exclude-objective-and-include-objective-values"
                role="error"
                test="count($matching-control-objective-ids) = 0">The exclude-control and include-control sibling element @control-id values must be
                different.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:control-objective-selection/oscal:include-objective">
            <sch:assert
                diagnostics="duplicate-include-objective-values-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.1"
                id="duplicate-include-objective-values"
                role="error"
                test="
                    if (following-sibling::oscal:include-objective)
                    then
                        if (@objective-id = following-sibling::oscal:include-objective/@objective-id)
                        then
                            false()
                        else
                            true()
                    else
                        true()">The include-objective/@objective-id values are unique.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:control-objective-selection/oscal:exclude-objective">
            <sch:assert
                diagnostics="duplicate-exclude-objective-values-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.1"
                id="duplicate-exclude-objective-values"
                role="error"
                test="
                    if (following-sibling::oscal:exclude-objective)
                    then
                        if (@objective-id = following-sibling::oscal:exclude-objective/@objective-id)
                        then
                            false()
                        else
                            true()
                    else
                        true()">The exclude-objective/@objective-id values are unique.</sch:assert>
        </sch:rule>

        <!-- This series of variables gets to the profile file to match the include and exclude asserts below -->
        <sch:let
            name="profile-href"
            value="resolve-uri($ssp-doc/oscal:system-security-plan/oscal:import-profile/@href, base-uri())" />
        <sch:let
            name="profile-available"
            value="
                if (: this is not a relative reference :) (not(starts-with(@href, '#')))
                then
                    (: the referenced document must be available :)
                    if (doc-available($profile-href))
                    then
                        exists(doc($profile-href)/oscal:profile)
                    else
                        false()
                else
                    true()" />
        <sch:let
            name="profile-doc"
            value="
                if ($profile-available)
                then
                    doc($profile-href)
                else
                    ()" />
        <sch:let
            name="profile-objective-ids"
            value="$profile-doc//oscal:add/@by-id" />
        <sch:rule
            context="oscal:assessment-plan">
            <sch:assert
                diagnostics="is-profile-document-diagnostic"
                id="is-profile-document"
                role="fatal"
                test="$profile-available eq true()"
                unit:override-xspec="both">The associated SSP must have an import-profile that references a profile document.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:include-objective">
            <sch:assert
                diagnostics="objective-inclusion-values-exist-in-profile-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.24"
                id="objective-inclusion-values-exist-in-profile"
                role="error"
                test="@objective-id[. = $profile-objective-ids]"
                unit:override-xspec="both">SAP included objectives are identified in the associated profile.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:exclude-objective">
            <sch:assert
                diagnostics="objective-exclusion-values-exist-in-profile-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.24"
                id="objective-exclusion-values-exist-in-profile"
                role="error"
                test="@objective-id[. = $profile-objective-ids]"
                unit:override-xspec="both">SAP excluded objective are identified in the associated profile.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern
        id="assessment-subject">
        <sch:let
            name="ssp-users"
            value="$ssp-doc//oscal:system-implementation//oscal:user/@uuid ! xs:string(.)" />
        <sch:let
            name="sap-users"
            value="/oscal:assessment-plan/oscal:local-definitions//oscal:user/@uuid ! xs:string(.)" />
        <sch:let
            name="ssp-user-apps"
            value="
                $ssp-doc/oscal:component[oscal:prop[@name = 'type' and @value eq 'role-based']]/@uuid ! xs:string(.) |
                $ssp-doc/oscal:inventory-item[oscal:prop[@name = 'type' and @value eq 'role-based']]/@uuid ! xs:string(.)" />
        <sch:let
            name="sap-user-apps"
            value="/oscal:assessment-plan//oscal:local-definitions/oscal:activity[oscal:prop[@value eq 'role-based']]/@uuid ! xs:string(.)" />

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
            context="oscal:include-subject[@type = 'location']">
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

        <sch:rule
            context="oscal:assessment-subject[@type = 'user']/oscal:include-subject[@type = 'user'] | oscal:assessment-subject[@type = 'user']/oscal:exclude-subject[@type = 'user']">
            <sch:assert
                diagnostics="user-uuid-matches-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.7"
                fedramp:specific="true"
                id="user-uuid-matches"
                role="error"
                test="@subject-uuid = $ssp-users or @subject-uuid = $sap-users"
                unit:override-xspec="both">Users targeted by include-subject or exclude-subject must exist in the SAP or associated SSP.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:task[oscal:prop[@value = 'role-based']]">
            <sch:assert
                diagnostics="matches-user-app-task-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.7"
                fedramp:specific="true"
                id="matches-user-app-task"
                role="error"
                test="oscal:associated-activity/@activity-uuid = $ssp-user-apps or oscal:associated-activity/@activity-uuid = $sap-user-apps"
                unit:override-xspec="both">User tasks targeted by associated activity must exist in either the SAP or SSP.</sch:assert>
            <sch:assert
                diagnostics="has-login-id-user-task-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.7"
                fedramp:specific="true"
                id="has-login-id-user-task"
                role="error"
                test="exists(oscal:prop[@name = 'login-id'])">FedRAMP SAP Role Tasks must have login-id information.</sch:assert>
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
                diagnostics="has-part-named-assumptions-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.8"
                fedramp:specific="true"
                id="has-part-named-assumptions"
                role="error"
                test="oscal:part[@name = 'assumptions']">The SAP terms and conditions must contain a part called assumptions.</sch:assert>

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

            <sch:assert
                diagnostics="has-part-named-included-activities-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.18"
                fedramp:specific="true"
                id="has-part-named-included-activities"
                role="error"
                test="oscal:part[@name = 'included-activities']">The SAP terms and conditions must contain a part called
                included-activities.</sch:assert>

            <sch:assert
                diagnostics="has-part-named-excluded-activities-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.19"
                fedramp:specific="true"
                id="has-part-named-excluded-activities"
                role="error"
                test="oscal:part[@name = 'excluded-activities']">The SAP terms and conditions must contain a part called
                excluded-activities.</sch:assert>

            <sch:assert
                diagnostics="has-part-named-liability-limitations-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.22"
                fedramp:specific="true"
                id="has-part-named-liability-limitations"
                role="error"
                test="oscal:part[@name = 'liability-limitations']">The SAP terms and conditions must contain a part called
                liability-limitations.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:terms-and-conditions/oscal:part[@name eq 'assumptions']">
            <sch:let
                name="unsorted-assumptions"
                value="oscal:part[@name eq 'assumption']/oscal:prop[@name eq 'sort-id']/@value" />
            <sch:let
                name="sorted_assumptions"
                value="sort($unsorted-assumptions)" />
            <sch:assert
                diagnostics="assumption-ordered-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.8"
                fedramp:specific="true"
                id="assumption-ordered"
                role="error"
                test="deep-equal($unsorted-assumptions, $sorted_assumptions)">The SAP terms and conditions assumptions part must have assumption parts
                that are ordered.</sch:assert>
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

            <sch:assert
                diagnostics="has-sampling-method-statement-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.9"
                fedramp:specific="true"
                id="has-sampling-method-statement"
                role="error"
                see="https://github.com/GSA/fedramp-automation-guides/issues/30"
                test="
                    if (oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'sampling' and @value eq 'no'])
                    then
                        (matches(oscal:p[position() = last()], '^.*\swill not use sampling when performing this assessment\.$'))
                    else
                        (if (oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'sampling' and @value eq 'yes'])
                        then
                            (matches(oscal:p[position() = last()], '^.*\swill use sampling when performing this assessment\.$'))
                        else
                            (false()))">The sampling methodology's final paragraph is the correct sampling statement.</sch:assert>
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

            <sch:let
                name="unsorted-dislosures"
                value="oscal:part[@name eq 'disclosure']/oscal:prop[@name eq 'sort-id']/@value" />
            <sch:let
                name="sorted-dislosures"
                value="sort($unsorted-dislosures)" />
            <sch:assert
                diagnostics="disclosure-ordered-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.17"
                fedramp:specific="true"
                id="disclosure-ordered"
                role="error"
                test="deep-equal($unsorted-dislosures, $sorted-dislosures)">The SAP terms and conditions disclosures part must have disclosure parts
                that are ordered.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:terms-and-conditions/oscal:part[@name eq 'excluded-activities']">

            <sch:assert
                diagnostics="has-roe-excluded-activity-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.19"
                fedramp:specific="true"
                id="has-roe-excluded-activity"
                role="error"
                test="oscal:part[@name eq 'excluded-activity']">The SAP Rules of Engagement (ROE) excluded activities must have one or more excluded
                activity parts.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:terms-and-conditions/oscal:part[@name eq 'liability-limitations']">

            <sch:assert
                diagnostics="has-liability-limitation-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.22"
                fedramp:specific="true"
                id="has-liability-limitation"
                role="error"
                test="oscal:part[@name eq 'liability-limitation']">The SAP terms and conditions has a part 'liability-limitations' that has one or
                more 'liability-limitation' parts.</sch:assert>

            <sch:let
                name="unsorted-limitations"
                value="oscal:part[@name eq 'liability-limitation']/oscal:prop[@name eq 'sort-id']/@value" />
            <sch:let
                name="sorted-limitations"
                value="sort($unsorted-limitations)" />
            <sch:assert
                diagnostics="liability-limitations-ordered-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.22"
                fedramp:specific="true"
                id="liability-limitations-ordered"
                role="error"
                test="deep-equal($unsorted-limitations, $sorted-limitations)">The SAP terms and conditions liability-limitations part has
                liability-limitation parts that are ordered.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:terms-and-conditions/oscal:part[@name eq 'included-activities']">

            <sch:assert
                diagnostics="has-roe-included-activity-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.18"
                fedramp:specific="true"
                id="has-roe-included-activity"
                role="error"
                test="oscal:part[@name eq 'included-activity']">The SAP Rules of Engagement (ROE) included activities must have one or more included
                activity parts.</sch:assert>

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
                fedramp:specific="true"
                id="signed-sap-resource-has-description"
                role="warning"
                test="exists(oscal:description)">An OSCAL SAP `signed-sap` resource must have a description.</sch:assert>

            <sch:assert
                diagnostics="signed-sap-resource-has-rlink-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.26"
                fedramp:specific="true"
                id="signed-sap-resource-has-rlink"
                role="error"
                test="exists(oscal:rlink)">An OSCAL SAP `signed-sap` resource must have an rlink.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:resource[oscal:prop[@name eq 'type' and @value eq 'signed-sap']]/oscal:rlink">

            <sch:assert
                diagnostics="signed-sap-rlink-has-media-type-pdf-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.26"
                fedramp:specific="true"
                id="signed-sap-rlink-has-media-type-pdf"
                role="warning"
                test="@media-type eq 'application/pdf'">An OSCAL SAP `signed-sap` resource rlink should use 'application/pdf' media-type.</sch:assert>

        </sch:rule>

        <!-- TODO: see https://github.com/GSA/fedramp-automation-guides/issues/16 regarding base64 resolution -->

    </sch:pattern>

    <sch:pattern
        id="metadata">
        <sch:rule
            context="oscal:metadata">
            <sch:assert
                diagnostics="has-metadata-role-assessor-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.10"
                fedramp:specific="true"
                id="has-metadata-role-assessor"
                role="error"
                test="oscal:role[@id = 'assessor']">This FedRAMP SAP has a role with an @id of 'assessor'.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-csp-poc-role-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.12"
                fedramp:specific="true"
                id="has-metadata-csp-poc-role"
                role="error"
                test="oscal:role[@id = 'csp-assessment-poc']">This FedRAMP SAP has a role with an @id value of 'csp-assessment-poc'.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-role-end-of-testing-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.20"
                fedramp:specific="true"
                id="has-metadata-role-end-of-testing"
                role="error"
                test="oscal:role[@id = 'csp-end-of-testing-poc']">This FedRAMP SAP has a role with an @id of 'csp-end-of-testing-poc'.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-location-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.10"
                fedramp:specific="true"
                id="has-metadata-location"
                role="error"
                test="oscal:location">This FedRAMP SAP has a location element in the metadata.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-party-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.10"
                fedramp:specific="true"
                id="has-metadata-party"
                role="error"
                test="oscal:party[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'iso-iec-17020-identifier']]">This FedRAMP SAP has a
                metadata element with a party element with a @name of the value 'iso-iec-17020-identifier'.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-correctly-formatted-party-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.10"
                fedramp:specific="true"
                id="has-metadata-correctly-formatted-party"
                role="error"
                test="oscal:party[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'iso-iec-17020-identifier' and matches(@value, '^\d{4}\.\d{2}$')]]">This
                FedRAMP SAP has a metadata/party with an @name of 'iso-iec-17020-identifier' has a correctly formatted @value.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-role-test-results-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.21"
                fedramp:specific="true"
                id="has-metadata-role-test-results"
                role="error"
                test="oscal:role[@id = 'csp-results-poc']">This FedRAMP SAP has a role with an @id of 'csp-results-poc'.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-responsible-party-test-results-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.21"
                fedramp:specific="true"
                id="has-metadata-responsible-party-test-results"
                role="error"
                test="oscal:responsible-party[@role-id = 'csp-results-poc']">This FedRAMP SAP has a responsible-party with a @role-id of
                'csp-results-poc'.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-responsible-party-end-of-testing-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.20"
                fedramp:specific="true"
                id="has-metadata-responsible-party-end-of-testing"
                role="error"
                test="oscal:responsible-party[@role-id = 'csp-end-of-testing-poc']">This FedRAMP SAP has a responsible-party with a @role-id of
                'csp-end-of-testing-poc'.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-csp-poc-responsible-party-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.12"
                fedramp:specific="true"
                id="has-metadata-csp-poc-responsible-party"
                role="error"
                test="oscal:responsible-party[@role-id = 'csp-assessment-poc']">This FedRAMP SAP has a responsible-party with an @role-id value of
                'csp-assessment-poc'.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-assessment-team-role-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.11"
                fedramp:specific="true"
                id="has-metadata-assessment-team-role"
                role="error"
                test="oscal:role[@id = 'assessment-team']">This FedRAMP SAP has a role with an @id value of 'assessment-team'.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-responsible-party-assessment-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.11"
                fedramp:specific="true"
                id="has-metadata-responsible-party-assessment"
                role="error"
                test="oscal:responsible-party[@role-id = 'assessment-team']">This FedRAMP SAP has a responsible-party with an @role-id value of
                'assessment-team'.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-responsible-party-lead-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.11"
                fedramp:specific="true"
                id="has-metadata-responsible-party-lead"
                role="error"
                test="oscal:responsible-party[@role-id = 'assessment-lead']">This FedRAMP SAP has a responsible-party with an @role-id value of
                'assessment-lead'.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-responsible-party-lead-multiple-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.11"
                fedramp:specific="true"
                id="has-metadata-responsible-party-lead-multiple"
                role="error"
                test="count(oscal:responsible-party[@role-id = 'assessment-lead']) = 1">This FedRAMP SAP has a single responsible-party with an
                @role-id value of 'assessment-lead'.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:metadata/oscal:responsible-party[@role-id = 'csp-results-poc']">
            <sch:let
                name="SAP-partyPersonResults_IDs"
                value="../oscal:party[@type = 'person']/@uuid" />
            <sch:let
                name="ssp-party-person-ids"
                value="$ssp-doc/oscal:system-security-plan/oscal:metadata/oscal:party[@type = 'person']/@uuid" />
            <sch:assert
                diagnostics="has-metadata-responsible-party-results-uuid-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.21"
                fedramp:specific="true"
                id="has-metadata-responsible-party-results-uuid"
                role="error"
                test="oscal:party-uuid">This FedRAMP SAP has a responsible-party with a @role-id of 'csp-results-poc' and a child party-uuid
                element.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-csp-results-responsible-party-matches-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.21"
                fedramp:specific="true"
                id="has-metadata-csp-results-responsible-party-matches"
                role="error"
                test="
                    if (oscal:party-uuid[. = $ssp-party-person-ids])
                    then
                        true()
                    else
                        if (oscal:party-uuid[. = $SAP-partyPersonResults_IDs])
                        then
                            true()
                        else
                            false()"
                unit:override-xspec="both">Responsible party POCs for Communication of Results have matching uuid values in either the SSP or SAP
                party/uuid elements.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:metadata/oscal:responsible-party[@role-id = 'csp-end-of-testing-poc']">
            <sch:let
                name="sap-party-person-EOT-ids"
                value="../oscal:party[@type = 'person']/@uuid" />
            <sch:let
                name="ssp-party-person-ids"
                value="$ssp-doc/oscal:system-security-plan/oscal:metadata/oscal:party[@type = 'person']/@uuid" />
            <sch:assert
                diagnostics="has-metadata-responsible-party-uuid-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.20"
                fedramp:specific="true"
                id="has-metadata-responsible-party-uuid"
                role="error"
                test="oscal:party-uuid">This FedRAMP SAP has a responsible-party with a @role-id of 'csp-end-of-testing-poc' and a child party-uuid
                element.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-csp-eot-responsible-party-matches-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.20"
                fedramp:specific="true"
                id="has-metadata-csp-eot-responsible-party-matches"
                role="error"
                test="
                    if (oscal:party-uuid[. = $ssp-party-person-ids])
                    then
                        true()
                    else
                        if (oscal:party-uuid[. = $sap-party-person-EOT-ids])
                        then
                            true()
                        else
                            false()"
                unit:override-xspec="both">Responsible party POCs for End of Testing have matching uuid values in either the SSP or SAP party/uuid
                elements.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:metadata/oscal:responsible-party[@role-id = 'assessment-team']">
            <sch:let
                name="partyPersonIDs"
                value="../oscal:party[@type = 'person']/@uuid" />
            <sch:let
                name="responsible-parties"
                value="oscal:party-uuid" />
            <sch:assert
                diagnostics="has-metadata-responsible-party-has-party-uuid-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.11"
                fedramp:specific="true"
                id="has-metadata-responsible-party-has-party-uuid"
                role="error"
                test="count($responsible-parties) gt 0">There is at least one party-uuid element as a child of
                responsible-party[@role-id='assessment-team'].</sch:assert>

            <sch:assert
                diagnostics="has-metadata-responsible-party-matches-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.11"
                fedramp:specific="true"
                id="has-metadata-responsible-party-matches"
                role="error"
                test="count($responsible-parties) eq count(distinct-values($partyPersonIDs[. = $responsible-parties]))">Each assessment team member in
                this FedRAMP SAP is described individually.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:metadata/oscal:responsible-party[@role-id = 'assessment-lead']">
            <sch:let
                name="assessment-team"
                value="../oscal:responsible-party[@role-id = 'assessment-team']/oscal:party-uuid" />
            <sch:assert
                diagnostics="has-metadata-responsible-party-lead-matches-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.11"
                fedramp:specific="true"
                id="has-metadata-responsible-party-lead-matches"
                role="error"
                test="oscal:party-uuid[. = $assessment-team]">The assessment-lead has a party-uuid that exists in the assessment-team list of
                party-uuid elements.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-responsible-party-phone-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.11"
                fedramp:specific="true"
                id="has-metadata-responsible-party-phone"
                role="error"
                test="../oscal:party[@type = 'person'][@uuid = current()/oscal:party-uuid]/oscal:telephone-number">The responsible-party with @role-id
                of 'assessment-lead' must reference a party with a telephone number.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-responsible-party-email-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.11"
                fedramp:specific="true"
                id="has-metadata-responsible-party-email"
                role="error"
                test="../oscal:party[@type = 'person'][@uuid = current()/oscal:party-uuid]/oscal:email-address">The responsible-party with @role-id of
                'assessment-lead' must reference a party with an email address.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:responsible-party[@role-id = 'csp-assessment-poc']">
            <sch:let
                name="sap-csp-assessment-poc"
                value="oscal:party-uuid" />
            <sch:let
                name="sap-party-person-ids"
                value="oscal:party[@type = 'person']/@uuid" />
            <sch:let
                name="ssp-party-person-ids"
                value="$ssp-doc/oscal:system-security-plan/oscal:metadata/oscal:party[@type = 'person']/@uuid" />
            <sch:let
                name="SAP-partyOrgIDs"
                value="oscal:party[@type = 'organization']/@uuid" />
            <sch:let
                name="ssp-party-org-ids"
                value="$ssp-doc/oscal:system-security-plan/oscal:metadata/oscal:party[@type = 'organization']/@uuid" />

            <sch:assert
                diagnostics="has-metadata-csp-poc-responsible-party-matches-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.12"
                fedramp:specific="true"
                id="has-metadata-csp-poc-responsible-party-matches"
                role="error"
                test="
                    if (oscal:party-uuid[. = $ssp-party-person-ids])
                    then
                        true()
                    else
                        if (oscal:party-uuid[. = $sap-party-person-ids])
                        then
                            true()
                        else
                            if (oscal:party-uuid[. = $ssp-party-org-ids])
                            then
                                true()
                            else
                                if (oscal:party-uuid[. = $SAP-partyOrgIDs])
                                then
                                    true()
                                else
                                    false()"
                unit:override-xspec="both">Responsible party POCs have matching uuid values in either the SSP or SAP party/uuid elements.</sch:assert>
            <sch:assert
                diagnostics="has-metadata-responsible-party-csp-poc-matches-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.12"
                fedramp:specific="true"
                id="has-metadata-responsible-party-csp-poc-matches"
                role="error"
                test="count(oscal:party-uuid) gt 2">A responsible party with a role-id of 'csp-assessment-poc' must contain at least three Points of
                Contact.</sch:assert>

            <sch:assert
                diagnostics="has-metadata-csp-poc-responsible-party-ops-center-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.12"
                fedramp:specific="true"
                id="has-metadata-csp-poc-responsible-party-ops-center"
                role="error"
                test="../oscal:responsible-party[@role-id = 'csp-operations-center']/oscal:party-uuid[. = $sap-csp-assessment-poc]">At least one of
                the Points of Contact must be an Operations Center.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern
        id="assessment-assets">
        <sch:rule
            context="oscal:assessment-assets/oscal:component[@type = 'software']">
            <sch:assert
                diagnostics="has-software-component-vendor-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.13"
                fedramp:specific="true"
                id="has-software-component-vendor"
                role="error"
                test="oscal:prop[@name = 'vendor']">A FedRAMP SAP assessment asset component must have a vendor name.</sch:assert>

            <sch:assert
                diagnostics="has-software-component-tool-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.13"
                fedramp:specific="true"
                id="has-software-component-tool"
                role="error"
                test="oscal:prop[@name = 'name']">A FedRAMP SAP assessment asset component must have a tool name.</sch:assert>

            <sch:assert
                diagnostics="has-software-component-version-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.13"
                fedramp:specific="true"
                id="has-software-component-version"
                role="error"
                test="oscal:prop[@name = 'version']">A FedRAMP SAP assessment asset component must have a version number for the tool.</sch:assert>

            <sch:assert
                diagnostics="has-software-component-status-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP) §4.13"
                fedramp:specific="true"
                id="has-software-component-status"
                role="warning"
                test="oscal:status[@state = 'operational']">A FedRAMP SAP assessment asset component has a status with a state of
                'operational'.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:assessment-platform">
            <sch:assert
                diagnostics="ipv4-has-content-diagnostic"
                id="ipv4-has-content"
                role="error"
                test="
                    if (oscal:prop[@name eq 'ipv4-address'])
                    then
                        (oscal:prop[@name eq 'ipv4-address'][matches(@value, '(^[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?\.[0-9][0-9]?[0-9]?$)')])
                    else
                        (true())"><sch:value-of
                    select="oscal:prop[@name = 'ipv4-address']/@value" />A FedRAMP SAP assessment-platform IPv4 value must be valid.</sch:assert>

            <sch:assert
                diagnostics="ipv4-has-non-placeholder-diagnostic"
                feddoc:documentation-reference="OMB Mandate M-21-07"
                fedramp:specific="true"
                id="ipv4-has-non-placeholder"
                role="error"
                test="
                    if (oscal:prop[@name eq 'ipv4-address']/@value = '0.0.0.0')
                    then
                        (false())
                    else
                        (true())"><sch:value-of
                    select="oscal:prop[@name = 'asset-id']/@value" />A FedRAMP SAP assessment-platform element must not define a placeholder IPv4
                value.</sch:assert>

            <sch:let
                name="IPv6-regex"
                value="
                    '(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:)
                {1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:)
                {1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]
                {1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:
                ((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))'" />
            <sch:assert
                diagnostics="ipv6-has-content-diagnostic"
                feddoc:documentation-reference="OMB Mandate M-21-07"
                id="ipv6-has-content"
                role="error"
                test="
                    if (oscal:prop[@name eq 'ipv6-address'])
                    then
                        (oscal:prop[@name eq 'ipv6-address'][matches(@value, $IPv6-regex)])
                    else
                        (true())"><sch:value-of
                    select="oscal:prop[@name = 'asset-id']/@value" />A FedRAMP SAP assessment-platform IPv6 value must be valid.</sch:assert>
            <sch:assert
                diagnostics="ipv6-has-non-placeholder-diagnostic"
                feddoc:documentation-reference="OMB Mandate M-21-07"
                id="ipv6-has-non-placeholder"
                role="error"
                test="
                    if (oscal:prop[@name eq 'ipv6-address']/@value eq '::')
                    then
                        (false())
                    else
                        (true())"><sch:value-of
                    select="oscal:prop[@name = 'asset-id']/@value" /> must have an appropriate IPv6 value.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:assessment-platform/oscal:uses-component">
            <sch:let
                name="SAP-assessment-assets-components"
                value="../../oscal:component/@uuid" />
            <sch:assert
                diagnostics="has-uses-component-match-diagnostic"
                fedramp:specific="true"
                id="has-uses-component-match"
                role="error"
                test="@component-uuid[. = $SAP-assessment-assets-components]">A FedRAMP SAP must have assessment platform uses-component uuid values
                that match assessment-assets component uuid values.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:diagnostics>

        <sch:diagnostic
            doc:assert="has-import-ssp"
            doc:context="oscal:assessment-plan"
            id="has-import-ssp-diagnostic">This OSCAL SAP lacks have an import-ssp element.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-user-assessment-subject"
            doc:context="oscal:assessment-plan"
            id="has-user-assessment-subject-diagnostic">This FedRAMP SAP does not have an assessment-subject with the type of 'user'.</sch:diagnostic>

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
            doc:assertion="import-ssp-has-available-document"
            doc:context="oscal:import-ssp"
            id="import-ssp-has-available-document-diagnostic">The import-ssp element has an href attribute that does not reference an available
            document.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="import-ssp-resolves-to-ssp"
            doc:context="oscal:import-ssp"
            id="import-ssp-resolves-to-ssp-diagnostic">The import-ssp element has an href attribute that does not reference an OSCAL system security
            plan document.</sch:diagnostic>

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
            doc:assert="include-all-or-include-control"
            doc:context="oscal:control-selection"
            id="include-all-or-include-control-diagnostic">A control-selection element may not have both include-all and include-control element
            children.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="include-all-or-include-objective"
            doc:context="oscal:control-objective-selection"
            id="include-all-or-include-objective-diagnostic">A control-objective-selection element may not have both include-all and include-objective
            element children.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="duplicate-exclude-objective-and-include-objective-values"
            doc:context="oscal:control-objective-selection"
            id="duplicate-exclude-objective-and-include-objective-values-diagnostic">The @control-id values <sch:value-of
                select="$matching-control-objective-ids" /> are not allowed to occur more than once in this control-objective-selection
            element.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="duplicate-include-objective-values"
            doc:context="oscal:control-objective-selection"
            id="duplicate-include-objective-values-diagnostic">Duplicate values are not allowed to occur in include-objective/@objective-id, <sch:value-of
                select="@objective-id" />, elements.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="duplicate-exclude-objective-values"
            doc:context="oscal:control-objective-selection"
            id="duplicate-exclude-objective-values-diagnostic">Duplicate values are not allowed to occur in exclude-objective/@objective-id, <sch:value-of
                select="@objective-id" />, elements.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="objective-inclusion-values-exist-in-profile"
            doc:context="oscal:included-objective"
            id="objective-inclusion-values-exist-in-profile-diagnostic">The included objective <sch:value-of
                select="@objective-id" /> does not exist in the associated profile.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="objective-exclusion-values-exist-in-profile"
            doc:context="oscal:excluded-objective"
            id="objective-exclusion-values-exist-in-profile-diagnostic">The excluded objective <sch:value-of
                select="@objective-id" /> does not exist in the associated profile.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="duplicate-exclude-control-and-include-control-values"
            doc:context="oscal:control-selection"
            id="duplicate-exclude-control-and-include-control-values-diagnostic">The @control-id values <sch:value-of
                select="$matching-control-ids" /> are not allowed to occur more than once in this control-selection element.</sch:diagnostic>
        <sch:diagnostic
            doc:assert="duplicate-include-control-values"
            doc:context="oscal:included-control"
            id="duplicate-include-control-values-diagnostic">Duplicate values are not allowed to occur in include-control/@control-id
            elements.</sch:diagnostic>
        <sch:diagnostic
            doc:assert="duplicate-exclude-control-values"
            doc:context="oscal:included-control"
            id="duplicate-exclude-control-values-diagnostic">Duplicate values are not allowed to occur in exclude-control/@control-id
            elements.</sch:diagnostic>
        <sch:diagnostic
            doc:assert="control-inclusion-values-exist-in-ssp"
            doc:context="oscal:included-control"
            id="control-inclusion-values-exist-in-ssp-diagnostic">The included control <sch:value-of
                select="@control-id" /> does not exist in the associated SSP.</sch:diagnostic>
        <sch:diagnostic
            doc:assert="control-exclusion-values-exist-in-ssp"
            doc:context="oscal:excluded-control"
            id="control-exclusion-values-exist-in-ssp-diagnostic">The excluded control <sch:value-of
                select="@control-id" /> does not exist in the associated SSP.</sch:diagnostic>

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
                select="oscal:associated-activity/@activity-uuid" />, references a non-existent (neither in the SSP nor SAP) web
            application.</sch:diagnostic>

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
            doc:assert="user-uuid-matches"
            doc:context="oscal:assessment-subject[@type='location']"
            id="user-uuid-matches-diagnostic">This include-subject, <sch:value-of
                select="@subject-uuid" />, references a non-existent (neither in the SSP nor SAP) user.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="matches-user-app-task"
            doc:context="oscal:task[oscal:prop[@name = 'type' and @value eq 'role']]"
            id="matches-user-app-task-diagnostic">This associated-activity, <sch:value-of
                select="oscal:associated-activity/@activity-uuid" />, references a non-existent (neither in the SSP nor SAP) user.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-login-id-user-task"
            doc:context="oscal:task[oscal:prop[@name = 'type' and @value eq 'web-application']]"
            id="has-login-id-user-task-diagnostic">This task, <sch:value-of
                select="@uuid" />, does not contain login-id information.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-user-applications"
            doc:context="oscal:assessment-plan"
            id="has-user-applications-diagnostic">These user testing activities, <sch:value-of
                select="$missing-user-tasks" />, do not have matching tasks in the SSP or SAP.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-terms-and-conditions-diagnostic"
            doc:context="oscal:assessment-plan"
            id="has-terms-and-conditions-diagnostic">The SAP lacks terms and conditions.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-part-named-assumptions"
            doc:context="oscal:terms-and-conditions"
            id="has-part-named-assumptions-diagnostic">The SAP lacks a part named 'assumptions'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="assumption-ordered"
            doc:context="oscal:terms-and-conditions"
            id="assumption-ordered-diagnostic">The SAP assumption parts are incorrectly ordered.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="disclosure-ordered"
            doc:context="oscal:terms-and-conditions"
            id="disclosure-ordered-diagnostic">The SAP disclosure parts are incorrectly ordered.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-methodology-diagnostic"
            doc:context="oscal:terms-and-conditions"
            id="has-methodology-diagnostic">The SAP terms and conditions lacks a description of the methodology which will be used.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-disclosures-diagnostic"
            doc:context="oscal:terms-and-conditions"
            id="has-disclosures-diagnostic">The SAP terms and conditions lacks Rules of Engagement (ROE) Disclosures.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-part-named-included-activities"
            doc:context="oscal:terms-and-conditions"
            id="has-part-named-included-activities-diagnostic">The SAP terms and conditions lacks Rules of Engagement (ROE) part of
            included-activities.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-part-named-excluded-activities"
            doc:context="oscal:terms-and-conditions"
            id="has-part-named-excluded-activities-diagnostic">The SAP terms and conditions lacks Rules of Engagement (ROE) part of
            excluded-activities.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-part-named-liability-limitations"
            doc:context="oscal:terms-and-conditions"
            id="has-part-named-liability-limitations-diagnostic">The SAP terms and conditions lacks a liability and limitations part.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-sampling-method-diagnostic"
            doc:context="oscal:terms-and-conditions/part[@name eq 'methodology']"
            id="has-sampling-method-diagnostic">The SAP lacks a sampling method.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-allowed-sampling-method-diagnostic"
            doc:context="oscal:terms-and-conditions/part[@name eq 'methodology']"
            id="has-allowed-sampling-method-diagnostic">The SAP fails to declare whether a sampling method is used.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-sampling-method-statement"
            doc:context="oscal:terms-and-conditions/part[@name eq 'methodology']"
            id="has-sampling-method-statement-diagnostic">The SAP methodology's final paragraph does not match the required string for a sampling
            property with a value of <sch:value-of
                select="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'sampling']/@value" />.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-roe-disclosure-detail-diagnostic"
            doc:context="oscal:terms-and-conditions/part[@name eq 'disclosures']"
            id="has-roe-disclosure-detail-diagnostic">The SAP Rules of Engagement (ROE) Disclosures lacks detail disclosure
            statements.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-roe-included-activity"
            doc:context="oscal:terms-and-conditions/part[@name eq 'included-activities']"
            id="has-roe-included-activity-diagnostic">The SAP Rules of Engagement (ROE) included activities lacks an included activity
            part.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-roe-excluded-activity"
            doc:context="oscal:terms-and-conditions/part[@name eq 'excluded-activities']"
            id="has-roe-excluded-activity-diagnostic">The SAP Rules of Engagement (ROE) included activities lacks an excluded activity
            part.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-liability-limitation"
            doc:context="oscal:terms-and-conditions/part[@name eq 'liability-limitations']"
            id="has-liability-limitation-diagnostic">The SAP liability and limitations does not have at least one part named
            'liability-limitation'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="liability-limitations-ordered"
            doc:context="oscal:terms-and-conditions/part[@name eq 'liability-limitations'"
            id="liability-limitations-ordered-diagnostic">The SAP liability-limitation parts are incorrectly ordered.</sch:diagnostic>

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

        <sch:diagnostic
            doc:assert="has-metadata-role-assessor"
            doc:context="oscal:metadata"
            id="has-metadata-role-assessor-diagnostic">This FedRAMP metadata does not have a role with an @id of 'assessor'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-role-test-results"
            doc:context="oscal:metadata"
            id="has-metadata-role-test-results-diagnostic">This FedRAMP metadata does not have a role with an @id of
            'csp-results-poc'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-responsible-party-test-results"
            doc:context="oscal:metadata"
            id="has-metadata-responsible-party-test-results-diagnostic">This FedRAMP metadata does not have a responsible-party with a @role-id of
            'csp-results-poc'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-responsible-party-results-uuid"
            doc:context="oscal:metadata"
            id="has-metadata-responsible-party-results-uuid-diagnostic">This FedRAMP metadata has a responsible-party with a @role-id of
            'csp-results-poc' without a child party-uuid.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-csp-results-responsible-party-matches"
            doc:context="oscal:metadata"
            id="has-metadata-csp-results-responsible-party-matches-diagnostic">This fedRAMP metadata as a responsible party POCs for Communication of
            Results without a matching person party in either the associated SSP or the SAP.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-role-end-of-testing"
            doc:context="oscal:metadata"
            id="has-metadata-role-end-of-testing-diagnostic">This FedRAMP metadata does not have a role with an @id of
            'csp-end-of-testing-poc'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-responsible-party-end-of-testing"
            doc:context="oscal:metadata"
            id="has-metadata-responsible-party-end-of-testing-diagnostic">This FedRAMP metadata does not have a responsible-party with a @role-id of
            'csp-end-of-testing-poc'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-responsible-party-uuid"
            doc:context="oscal:metadata/oscal:responsible-party[@role-id='csp-end-of-testing-poc']"
            id="has-metadata-responsible-party-uuid-diagnostic">This FedRAMP metadata has a responsible-party with a @role-id of
            'csp-end-of-testing-poc' without a child party-uuid.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-csp-eot-responsible-party-matches"
            doc:context="oscal:metadata/oscal:responsible-party[@role-id='csp-end-of-testing-poc']"
            id="has-metadata-csp-eot-responsible-party-matches-diagnostic">This fedRAMP metadata as a responsible party POCs for End of Testing
            without a matching person party in either the associated SSP or the SAP.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-location"
            doc:context="oscal:metadata"
            id="has-metadata-location-diagnostic">This FedRAMP metadata does not have a location.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-party"
            doc:context="oscal:metadata"
            id="has-metadata-party-diagnostic">This FedRAMP metadata does not have a party with a prop whose @name is
            'iso-iec-17020-identifier'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-correctly-formatted-party"
            doc:context="oscal:metadata"
            id="has-metadata-correctly-formatted-party-diagnostic">This FedRAMP metadata/party with an @name of 'iso-iec-17020-identifier' does not
            have a correctly formatted @value.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="ipv4-has-content"
            doc:context="oscal:assessment-plan[oscal:prop[@name eq 'ipv4-address']]"
            id="ipv4-has-content-diagnostic">The @value content of prop whose @name is 'ipv4-address' has incorrect content.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="ipv4-has-non-placeholder"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'ipv4-address']]"
            id="ipv4-has-non-placeholder-diagnostic">The @value content of prop whose @name is 'ipv4-address' has placeholder value of
            0.0.0.0.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="ipv6-has-non-placeholder"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'ipv6-address']]"
            id="ipv6-has-non-placeholder-diagnostic">The @value content of prop whose @name is 'ipv6-address' has placeholder value of
            ::.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="ipv6-has-content"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'ipv6-address']]"
            id="ipv6-has-content-diagnostic">The @value content of prop whose @name is 'ipv6-address' has incorrect content.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-uses-component-match"
            doc:context="oscal:assessment-platform/oscal:uses-component"
            id="has-uses-component-match-diagnostic">This assessment platform uses-component uuid value, <sch:value-of
                select="@component-uuid" /> does not have a matching assessment-assets component uuid value.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="is-profile-document"
            doc:context="oscal:assessment-plan"
            id="is-profile-document-diagnostic">The associated SSP document does not have an import-profile that references a profile
            document.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-software-component-vendor"
            doc:context="oscal:assessment-assets/oscal:component[@type='software']"
            id="has-software-component-vendor-diagnostic">This FedRAMP SAP has a assessment asset component, <sch:value-of
                select="@uuid" />, that does not identify the vendor name.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-software-component-tool"
            doc:context="oscal:assessment-assets/oscal:component[@type='software']"
            id="has-software-component-tool-diagnostic">This FedRAMP SAP has a assessment asset component, <sch:value-of
                select="@uuid" />, that does not identify the tool name.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-software-component-version"
            doc:context="oscal:assessment-assets/oscal:component[@type='software']"
            id="has-software-component-version-diagnostic">This FedRAMP SAP has a assessment asset component, <sch:value-of
                select="@uuid" />, that does not identify the version of the tool.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-software-component-status"
            doc:context="oscal:assessment-assets/oscal:component[@type='software']"
            id="has-software-component-status-diagnostic">This FedRAMP SAP has a assessment asset component, <sch:value-of
                select="@uuid" />, that does not identify the status state as 'operational'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-assessment-team-role"
            doc:context="oscal:metadata"
            id="has-metadata-assessment-team-role-diagnostic">This FedRAMP metadata does not contain a role with an @id of
            'assessment-team'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-responsible-party-assessment"
            doc:context="oscal:metadata"
            id="has-metadata-responsible-party-assessment-diagnostic">This FedRAMP metadata does not contain a responsible-party with a @role-id of
            'assessment-team'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-responsible-part-lead"
            doc:context="oscal:metadata"
            id="has-metadata-responsible-party-lead-diagnostic">This FedRAMP metadata does not contain a responsible-party with a @role-id of
            'assessment-lead'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-responsible-part-lead-multiple"
            doc:context="oscal:metadata"
            id="has-metadata-responsible-party-lead-multiple-diagnostic">This FedRAMP metadata contains more than one responsible-party element with a
            @role-id of 'assessment-lead'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-responsible-party-has-party-uuid"
            doc:context="oscal:metadata/oscal:responsible-party[@role-id='assessment-team']"
            id="has-metadata-responsible-party-has-party-uuid-diagnostic">This FedRAMP responsible-party element, <sch:value-of
                select="@role-id" /> does not have at least one party-uuid element.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-responsible-party-matches"
            doc:context="oscal:metadata"
            id="has-metadata-responsible-party-matches-diagnostic">This FedRAMP metadata does not have a matching party for every individual on the
            assessment team.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-responsible-party-lead-matches"
            doc:context="oscal:metadata"
            id="has-metadata-responsible-party-lead-matches-diagnostic">This FedRAMP metadata does not have a
            responsible-party[@role-id='assessment-lead']/party-uuid that matches a
            responsible-party[@role-id='assessment-team']/party-uuid.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-responsible-party-phone"
            doc:context="oscal:metadata"
            id="has-metadata-responsible-party-phone-diagnostic">The responsible-party with an @role-id of 'assessment-lead' does not reference a
            party with a telephone number.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-responsible-party-email"
            doc:context="oscal:metadata"
            id="has-metadata-responsible-party-email-diagnostic">The first person of the assessment team does not reference a party with an email
            address.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-csc-poc-role"
            doc:context="oscal:metadata"
            id="has-metadata-csp-poc-role-diagnostic">This FedRAMP metadata does not contain a role with an @id of
            'csp-assessment-poc'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-csp-poc-responsible-party"
            doc:context="oscal:metadata"
            id="has-metadata-csp-poc-responsible-party-diagnostic">This FedRAMP metadata does not contain a responsible-party with a @role-id of
            'csp-assessment-poc'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-csp-poc-responsible-party-matches"
            doc:context="oscal:metadata"
            id="has-metadata-csp-poc-responsible-party-matches-diagnostic">This FedRAMP SAP has a responsible-party with a role-id of
            'csp-assessment-poc' whose uuid, <sch:value-of
                select="oscal:party-uuid" /> , does not match a party in either the associated SSP or the SAP.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-responsible-party-csp-poc-matches"
            doc:context="oscal:metadata"
            id="has-metadata-responsible-party-csp-poc-matches-diagnostic">The responsible party with a role-id of 'csp-assessment-poc' does not
            contain at least three Points of Contact.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-metadata-csp-poc-responsible-party-ops-center"
            doc:context="oscal:metadata"
            id="has-metadata-csp-poc-responsible-party-ops-center-diagnostic">The responsible party with a role-id of 'csp-assessment-poc' does not
            have a POC that is a Operations Center.</sch:diagnostic>
    </sch:diagnostics>
</sch:schema>
