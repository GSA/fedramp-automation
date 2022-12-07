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

    <!-- Global Variables -->
    <sch:let
        name="sap-import-url"
        value="
            if (starts-with(/oscal:assessment-results/oscal:import-ap/@href, '#'))
            then
                resolve-uri(/oscal:assessment-results/oscal:back-matter/oscal:resource[substring-after(/oscal:assessment-results/oscal:import-ap/@href, '#') = @uuid]/oscal:rlink/@href, base-uri())
            else
                resolve-uri(/oscal:assessment-results/oscal:import-ap/@href, base-uri())" />
    <sch:let
        name="sap-available"
        value="doc-available($sap-import-url)" />
    <sch:let
        name="sap-doc"
        value="
            if ($sap-available)
            then
                doc($sap-import-url)
            else
                ()" />
    <sch:let
        name="ssp-import-url"
        value="
            if (starts-with($sap-doc/oscal:assessment-plan/oscal:import-ssp/@href, '#'))
            then
                resolve-uri($sap-doc/oscal:assessment-plan/oscal:back-matter/oscal:resource[substring-after($sap-doc/oscal:assessment-plan/oscal:import-ssp/@href, '#') = @uuid]/oscal:rlink/@href, base-uri())
            else
                resolve-uri($sap-doc/oscal:assessment-plan/oscal:import-ssp/@href, base-uri())" />
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
        name="resolved-profile-import-url"
        value="
            if (starts-with($ssp-doc/oscal:system-security-plan/oscal:import-profile/@href, '#'))
            then
                resolve-uri($ssp-doc/oscal:system-security-plan/oscal:back-matter/oscal:resource[substring-after($ssp-doc/oscal:system-security-plan/oscal:import-profile/@href, '#') = @uuid]/oscal:rlink/@href, base-uri())
            else
                resolve-uri($ssp-doc/oscal:system-security-plan/oscal:import-profile/@href, base-uri())" />
    <sch:let
        name="resolved-profile-available"
        value="doc-available($resolved-profile-import-url)" />
    <sch:let
        name="resolved-profile-doc"
        value="
            if ($resolved-profile-available)
            then
                doc($resolved-profile-import-url)
            else
                ()" />

    <xsl:param
        as="xs:string"
        name="registry-base-path"
        select="'../../content/rev4/resources/xml'" />
    <sch:let
        name="fedramp-values"
        value="doc(concat($registry-base-path, '/fedramp_values.xml'))" />

    <sch:let
        name="ssp-parties"
        value="$ssp-doc/oscal:system-security-plan/oscal:metadata/oscal:party/@uuid" />
    <!-- When combining due to conflict, move the *-parties out of oscal:actor rule and into direct child of results pattern -->
    <!-- Also lowercase all instances of sap, sar, ssp in variables -->
    <sch:let
        name="sap-parties"
        value="$sap-doc/oscal:assessment-plan/oscal:metadata/oscal:party/@uuid" />
    <sch:let
        name="sar-parties"
        value="/oscal:assessment-results/oscal:metadata/oscal:party/@uuid" />

    <sch:pattern
        id="import-ap">

        <!--
            NB:
            Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §3.5 asserts
            "The SAR must import an OSCAL-based SAP, even if no OSCAL-based SSP exists."
            This means there is no accommodation for a non-OSCAL SAP.
        -->

        <sch:rule
            context="oscal:assessment-results">

            <sch:assert
                diagnostics="has-import-ap-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §3.5"
                id="has-import-ap"
                role="error"
                test="oscal:import-ap">An OSCAL SAR must have an import-ap element.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:import-ap">

            <sch:assert
                diagnostics="has-import-ap-href-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §3.5"
                id="has-import-ap-href"
                role="fatal"
                test="exists(@href)">An OSCAL SAR import-ap element must have an href attribute.</sch:assert>

            <sch:assert
                diagnostics="has-import-ap-internal-href-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §3.5"
                id="has-import-ap-internal-href"
                role="fatal"
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

            <sch:assert
                diagnostics="sap-document-available-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §3.5"
                id="sap-document-available"
                role="fatal"
                test="$sap-doc/oscal:assessment-plan"
                unit:override-xspec="both">An OSCAL SAR import-ap element must reference an available SAP document.</sch:assert>

            <sch:assert
                diagnostics="ssp-document-available-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.2"
                id="ssp-document-available"
                role="fatal"
                test="$ssp-doc/oscal:system-security-plan"
                unit:override-xspec="both">An OSCAL SAR import-ap element must reference an available SAP document that has an import-ssp element that
                references an available SSP document.</sch:assert>

            <sch:assert
                diagnostics="resolved-profile-catalog-document-available-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.2"
                id="resolved-profile-catalog-document-available"
                role="fatal"
                test="$resolved-profile-doc/oscal:catalog"
                unit:override-xspec="both">An OSCAL SAR import-ap element must reference an available SAP document that has an import-ssp element that
                references an available SSP document that has a import-profile element that references a resolved profile catalog
                document.</sch:assert>

            <sch:assert
                diagnostics="has-import-ap-external-href-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §3.5"
                id="has-import-ap-external-href"
                role="fatal"
                test="
                    if (: this is not a relative reference :) (not(starts-with(@href, '#')))
                    then
                        (: the referenced document must be available :)
                        doc-available($sap-import-url)
                    else
                        (: the assertion succeeds :)
                        true()"
                unit:override-xspec="both">An OSCAL SAR import-ap element href attribute which is an external reference must identify an available
                target.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:back-matter">

            <!-- TODO: fedramp_values does has no entry for an assessment plan resource -->
            <!-- TODO: Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §3.5 uses the type "sap" -->

            <sch:assert
                diagnostics="has-security-assessment-plan-resource-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §3.5"
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
            context="oscal:resource[oscal:prop[@name = 'type' and @value = 'evidence']] | oscal:resource[oscal:prop[@name = 'type' and @value = 'artifact']]">
            <sch:let
                name="relevant-evidence-href"
                value="//oscal:observation/oscal:relevant-evidence/substring-after(@href, '#')" />
            <sch:let
                name="subject-UUID"
                value="//oscal:observation/oscal:subject/@subject-uuid" />
            <sch:assert
                diagnostics="has-type-artifact-evidence-resource-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.4.4"
                fedramp:specific="true"
                id="has-type-artifact-evidence-resource"
                role="error"
                test="
                    if (@uuid[. = $relevant-evidence-href])
                    then
                        true()
                    else
                        if (@uuid[. = $subject-UUID])
                        then
                            true()
                        else
                            false()">Resources of type 'evidence' or 'artifact' must have a matching relevant-evidence or subject
                UUID.</sch:assert>
            <sch:assert
                diagnostics="has-type-artifact-evidence-rlink-base64-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.4.4"
                fedramp:specific="true"
                id="has-type-artifact-evidence-rlink-base64"
                role="error"
                test="oscal:rlink or oscal:base64">An observation of type 'evidence' or 'artifact' must have at least one rlink and/or base64
                element.</sch:assert>
            <sch:assert
                diagnostics="has-type-artifact-evidence-rlink-relative-path-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.4.4"
                fedramp:specific="true"
                id="has-type-artifact-evidence-rlink-relative-path"
                role="error"
                test="oscal:rlink[not(matches(@href, '^/'))]">If an observation of type 'evidence' or 'artifact' has an rlink the @href value must be
                a relative path.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'security-assessment-plan']]">

            <sch:assert
                diagnostics="has-sap-rlink-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §3.5"
                fedramp:specific="true"
                id="has-sap-rlink"
                role="error"
                test="exists(oscal:rlink) and not(exists(oscal:rlink[2]))">An OSCAL SAR with a SAP resource declaration must have one and only one
                rlink element.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'security-assessment-plan']]/oscal:rlink">

            <sch:assert
                diagnostics="has-acceptable-security-assessment-plan-rlink-media-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §3.5"
                fedramp:specific="true"
                id="has-acceptable-security-assessment-plan-rlink-media-type"
                role="error"
                test="@media-type = ('text/xml', 'application/json')">An OSCAL SAR SAP rlink must have a 'text/xml' or 'application/json'
                media-type.</sch:assert>

            <!-- TODO: check document availability when $use-remote-resources is made common -->

        </sch:rule>

        <!-- TODO:
            Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §3.5 allows base64
            but it also uses href on base64 so may be bogus.
            Commented out base64 restriction until verified.
        -->

        <!--<sch:rule
            context="oscal:resource[oscal:prop[@name = 'type' and @value eq 'security-assessment-plan']]/oscal:base64">

            <sch:assert
                diagnostics="has-no-base64-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §3.5"
                id="has-no-base64"
                role="error"
                test="false()">An OSCAL SAR must not use a base64 element in a security-assessment-plan resource.</sch:assert>

        </sch:rule>-->

    </sch:pattern>

    <sch:pattern
        id="results">

        <sch:rule
            context="oscal:result">

            <sch:let
                name="excluded-controls"
                value="oscal:reviewed-controls/oscal:control-selection/oscal:exclude-control/@control-id" />
            <sch:let
                name="included-controls"
                value="
                    if (oscal:reviewed-controls/oscal:control-selection/oscal:include-all)
                    then
                        $resolved-profile-doc//oscal:control/@id
                    else
                        oscal:reviewed-controls/oscal:control-selection/oscal:include-control/@control-id" />
            <sch:let
                name="in-scope-controls"
                value="$included-controls[not(. = $excluded-controls)]" />
            <sch:let
                name="matching-response-point-ids"
                value="
                    for $i in $in-scope-controls
                    return
                        $resolved-profile-doc//oscal:control[@id = $i]//oscal:part[@name = 'objective'][oscal:prop[@name = 'response-point']]/@id" />
            <sch:let
                name="finding-target-IDs"
                value="oscal:finding/oscal:target[@type = 'objective-id']/@target-id" />
            <sch:let
                name="finding-not-matches-with-response-points"
                value="$matching-response-point-ids[not(. = $finding-target-IDs)]" />

            <sch:assert
                diagnostics="objectives-match-response-points-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.2"
                fedramp:specific="true"
                id="objectives-match-response-points"
                role="error"
                test="$finding-not-matches-with-response-points = ''"
                unit:override-xspec="both">All in scope controls in the resolved baseline profile must have objectives that match a
                finding/target/@target-id in the current result assembly.</sch:assert>

            <sch:assert
                diagnostics="has-attestation-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.12"
                fedramp:specific="true"
                id="has-attestation"
                role="error"
                test="oscal:attestation[oscal:part[@name = 'authorization-statements']/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'recommend-authorization']]">
                There must exist an attestation with a part containing a property with a name of 'recommend-authorization'.</sch:assert>

            <sch:let
                name="pl-2-other-than-satisfied-findings"
                value="oscal:finding/oscal:target[@type = 'objective-id'][oscal:status ne 'satisfied'][matches(@target-id, '^pl-2\.')]/@target-id" />

            <sch:let
                name="pl-2-profile-objectives"
                value="$resolved-profile-doc/oscal:catalog//oscal:part[@name eq 'objective'][ancestor::oscal:control[@id eq 'pl-2']]/@id" />

            <sch:let
                name="pl-2-not-matches-other-than-satisfied-findings"
                value="$pl-2-other-than-satisfied-findings[not(. = $pl-2-profile-objectives)]" />

            <sch:assert
                diagnostics="matching-control-PL-2-objectives-diagnostic"
                fedramp:specific="true"
                id="matching-control-PL-2-objectives"
                role="error"
                test="count($pl-2-other-than-satisfied-findings) gt 0"
                unit:override-xspec="both">Within a SAR, every unsatisfied PL-2 objective must have a matching resolved baseline profile catalog
                part.</sch:assert>

            <sch:assert
                diagnostics="minimal-control-PL-2-findings-diagnostic"
                fedramp:specific="true"
                id="minimal-control-PL-2-findings"
                role="error"
                test="count(oscal:finding[oscal:target[@type = 'objective-id' and oscal:status/@state ne 'statisfied' and matches(@target-id, '^pl-2\.')]]) lt 2">Every
                result must contain no more than one unsatisfied finding for the control PL-2.</sch:assert>

            <!-- Unclear Guide instructions. -->
            <!-- See https://github.com/GSA/fedramp-automation-guides/issues/41 -->
            <!--<sch:rule
            context="oscal:relevant-evidence">
            <sch:let name="sap-resources" value="/oscal:assessment-results/oscal:back-matter/oscal:resource/@uuid"/>
            <sch:assert
                diagnostics="has-relevant-evidence-matching-resource-uuid-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.4.2"
                fedramp:specific="true"
                id="has-relevant-evidence-matching-resource-uuid"
                role="error"
                test="substring-after(@href, '#') or  oscal:link/@href[substring-after(., '#') = sap-resources]">A relevant-evidence href has a matching resource uuid in the SAR back-matter.</sch:assert>
        </sch:rule>-->
        </sch:rule>

        <sch:rule
            context="oscal:actor">
            <sch:assert
                diagnostics="has-matching-SAP-party-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.3"
                fedramp:specific="true"
                id="has-matching-SAP-party"
                role="error"
                test="
                    if (../../oscal:target[@type = 'objective-id'])
                    then
                        (@actor-uuid[. = $sap-parties]) or (@actor-uuid[. = $sar-parties])
                    else
                        true()"
                unit:override-xspec="both">A finding must have an actor who is described in a SAP or SAR party assembly.</sch:assert>
            <sch:assert
                diagnostics="has-matching-historic-party-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.4.5"
                fedramp:specific="true"
                id="has-matching-historic-party"
                role="error"
                test="
                    if (../../oscal:type = 'historic')
                    then
                        if (@actor-uuid[. = $sap-parties])
                        then
                            true()
                        else
                            if (@actor-uuid[. = $sar-parties])
                            then
                                true()
                            else
                                false()
                    else
                        true()"
                unit:override-xspec="both">A historic observation must have an actor that is described in either the SAP or the SAR party
                assemblies.</sch:assert>
            <sch:let
                name="actorTypes"
                value="'tool', 'party', 'assessment-platform'" />
            <sch:assert
                diagnostics="has-correct-actor-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.4.1"
                fedramp:specific="true"
                id="has-correct-actor-type"
                role="error"
                test="@type[. = $actorTypes]">The actor @type must have one of the following as string content: 'tool', 'party', or
                'assessment-platform'.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:target">
            <sch:let
                name="implementation-status"
                value="$fedramp-values/f:fedramp-values/f:value-set[@name = 'control-implementation-status']/f:allowed-values/f:enum/@value" />

            <sch:assert
                diagnostics="has-implementation-status-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.3"
                fedramp:specific="true"
                id="has-implementation-status"
                role="error"
                test="
                    if (current()[@type = 'objective-id'])
                    then
                        oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'implementation-status']
                    else
                        true()">A target of objective-id type must have a property of 'implementation-status'.</sch:assert>

            <sch:assert
                diagnostics="implementation-status-value-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.3"
                fedramp:specific="true"
                id="implementation-status-value"
                role="error"
                test="
                    if (current()[@type = 'objective-id']/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'implementation-status'])
                    then
                        oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'implementation-status']/@value[. = $implementation-status]
                    else
                        true()"
                unit:override-xspec="both">The target's implementation-status property must be properly identified.</sch:assert>

            <sch:let
                name="satisfaction-status"
                value="'satisfied', 'other-than-satisfied'" />
            <sch:assert
                diagnostics="has-satisfaction-status-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.3"
                fedramp:specific="true"
                id="has-satisfaction-status"
                role="error"
                test="
                    if (current()[@type = 'objective-id'])
                    then
                        oscal:status
                    else
                        true()">A target of objective-id type must have a status.</sch:assert>

            <sch:assert
                diagnostics="satisfaction-status-value-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.3"
                fedramp:specific="true"
                id="satisfaction-status-value"
                role="error"
                test="
                    if (current()[@type = 'objective-id']/oscal:status)
                    then
                        oscal:status/@state[. = $satisfaction-status]
                    else
                        true()">The target's status element must be properly identified.</sch:assert>

            <sch:assert
                diagnostics="no-duplicate-target-id-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.3"
                fedramp:specific="true"
                id="no-duplicate-target-id"
                role="error"
                test="count(ancestor::oscal:result//oscal:target/@target-id[. eq current()/@target-id]) eq 1">Every finding target must be unique
                within a result.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:subject">
            <sch:assert
                diagnostics="has-subject-matching-party-uuid-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.4.2"
                fedramp:specific="true"
                id="has-subject-matching-party-uuid"
                role="error"
                test="
                    if (../oscal:type = 'control-objective' and ../oscal:method = 'INTERVIEW')
                    then
                        if (@subject-uuid[. = $ssp-parties])
                        then
                            true()
                        else
                            if (@subject-uuid[. = $sap-parties])
                            then
                                true()
                            else
                                if (@subject-uuid[. = $sar-parties])
                                then
                                    true()
                                else
                                    false()
                    else
                        true()"
                unit:override-xspec="both">A subject uuid within an observation of type 'control-objective' must have a matching party @uuid in the
                metadata.</sch:assert>
            <sch:let
                name="SAR-backmatter-resources"
                value="/oscal:assessment-results/oscal:back-matter/oscal:resource/@uuid" />
            <sch:let
                name="subject-values"
                value="'component', 'inventory-item', 'location', 'party', 'user'" />

            <sch:assert
                diagnostics="has-correct-subject-values-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.4.1"
                fedramp:specific="true"
                id="has-correct-subject-values"
                role="error"
                test="@type[. = $subject-values]">A subject element type attribute must contain one of the following as string content: 'component',
                'inventory-item', 'location', 'party', or 'user'.</sch:assert>

            <sch:assert
                diagnostics="has-subject-matching-resource-uuid-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.4.1"
                fedramp:specific="true"
                id="has-subject-matching-resource-uuid"
                role="error"
                test="
                    if (../oscal:type = 'control-objective' and ../oscal:method = 'EXAMINE')
                    then
                        @subject-uuid[. = $SAR-backmatter-resources]
                    else
                        true()">A subject uuid within an observation of type 'control-objective' must have a matching resource @uuid
                in the back-matter.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:method">
            <sch:let
                name="method-values"
                value="'EXAMINE', 'INTERVIEW', 'TEST'" />
            <sch:assert
                diagnostics="has-correct-method-values-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.4.1"
                fedramp:specific="true"
                id="has-correct-method-values"
                role="error"
                test=". = $method-values">A method element must contain one of the following strings: 'EXAMINE', 'INTERVIEW', or 'TEST'.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:related-task">
            <sch:let
                name="sap-tasks"
                value="$sap-doc/oscal:assessment-plan/oscal:task/@uuid" />
            <sch:assert
                diagnostics="has-matching-SAP-tasks-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.4.1"
                fedramp:specific="true"
                id="has-matching-SAP-tasks"
                role="error"
                test="@task-uuid[. = $sap-tasks]"
                unit:override-xspec="both">A related-task element's uuid attribute must match a task @uuid value in the associated SAP.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:observation">
            <sch:let
                name="related-observations"
                value="/oscal:assessment-results/oscal:result/oscal:finding/oscal:related-observation/@observation-uuid" />
            <sch:let
                name="resourceUUIDs"
                value="/oscal:assessment-results/oscal:back-matter/oscal:resource/@uuid" />

            <sch:assert
                diagnostics="has-risk-adjustment-observation-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.10.3"
                fedramp:specific="true"
                id="has-risk-adjustment-observation"
                role="error"
                test="
                    if (oscal:type = 'risk-adjustment')
                    then
                        if (@uuid[. = $related-observations])
                        then
                            true()
                        else
                            false()
                    else
                        true()">An observation with a type of 'risk-adjustment' must have a @uuid that matches a
                finding/related-observation/@observation-uuid.</sch:assert>

            <sch:assert
                diagnostics="has-operational-requirement-observation-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.10.2"
                fedramp:specific="true"
                id="has-operational-requirement-observation"
                role="error"
                test="
                    if (oscal:type = 'operational-requirement')
                    then
                        if (@uuid[. = $related-observations])
                        then
                            true()
                        else
                            false()
                    else
                        true()">An observation with a type of 'operational-requirement' must have a @uuid that matches a
                finding/related-observation/@observation-uuid.</sch:assert>

            <sch:assert
                diagnostics="has-risk-adjustment-relevant-evidence-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.10.3"
                fedramp:specific="true"
                id="has-risk-adjustment-relevant-evidence"
                role="error"
                test="
                    if (oscal:type = 'risk-adjustment')
                    then
                        if (oscal:relevant-evidence/oscal:link[substring-after(@href, '#')[. = $resourceUUIDs]])
                        then
                            true()
                        else
                            false()
                    else
                        true()">An observation with a type of 'risk-adjustment' must have a relevant-evidence/link/@href, whose value
                after the '#', matches a back-matter/resource/@uuid.</sch:assert>

            <sch:assert
                diagnostics="has-operational-requirement-relevant-evidence-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.10.2"
                fedramp:specific="true"
                id="has-operational-requirement-relevant-evidence"
                role="error"
                test="
                    if (oscal:type = 'operational-requirement')
                    then
                        if (oscal:relevant-evidence[substring-after(@href, '#') = /oscal:assessment-results/oscal:back-matter/oscal:resource/@uuid])
                        then
                            true()
                        else
                            false()
                    else
                        true()">An observation with a type of 'operational-requirement' must have a relevant-evidence/@href, whose
                value after the '#', matches a back-matter/resource/@uuid.</sch:assert>

            <sch:assert
                diagnostics="has-method-MIXED-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.4.5"
                fedramp:specific="true"
                id="has-method-MIXED"
                role="error"
                test="oscal:type = 'historic' and oscal:method = 'MIXED'">An observation of type 'historic' must also have a method of
                'MIXED'.</sch:assert>

            <sch:assert
                diagnostics="has-type-ssp-statement-issue-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.5"
                fedramp:specific="true"
                id="has-type-ssp-statement-issue"
                role="error"
                test="
                    if (oscal:type = 'ssp-statement-issue')
                    then
                        oscal:method = 'EXAMINE'
                    else
                        true()">An observation with a type of 'ssp-statement-issue' must also have a method of 'EXAMINE'.</sch:assert>

            <sch:assert
                diagnostics="has-type-ssp-statement-issue-matches-related-observation-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.5"
                fedramp:specific="true"
                id="has-type-ssp-statement-issue-matches-related-observation"
                role="error"
                test="
                    if (oscal:type = 'ssp-statement-issue')
                    then
                        @uuid[. = $related-observations]
                    else
                        true()">An observation with a type of 'ssp-statement-issue' must have a matching
                finding/related-observation/@observation-uuid value.</sch:assert>

            <sch:let
                name="ssp-statement-uuids"
                value="$ssp-doc//oscal:statement/@uuid" />
            <sch:assert
                diagnostics="has-implementation-statement-uuid-matches-ssp-statement-uuid-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.5"
                fedramp:specific="true"
                id="has-implementation-statement-uuid-matches-ssp-statement-uuid"
                role="error"
                test="
                    if (oscal:type = 'ssp-statement-issue')
                    then
                        if (@uuid[. = $related-observations])
                        then
                            ../oscal:finding[oscal:related-observation/@observation-uuid = current()/@uuid]/oscal:implementation-statement-uuid[. = $ssp-statement-uuids]
                        else
                            true()
                    else
                        true()"
                unit:override-xspec="both">The finding that has a related-observation/observation-uuid that matches an observation/@uuid, must also
                have a implementation-statement-uuid value that matches a statement/@uuid in the associated SSP.</sch:assert>

            <sch:assert
                diagnostics="has-false-positive-observation-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.10.1"
                fedramp:specific="true"
                id="has-false-positive-observation"
                role="error"
                test="
                    if (oscal:type = 'false-positive')
                    then
                        if (@uuid[. = $related-observations])
                        then
                            true()
                        else
                            false()
                    else
                        true()">An observation with a type of 'false-positive' must have a @uuid that matches a
                finding/related-observation/@observation-uuid.</sch:assert>
            <sch:assert
                diagnostics="has-pen-test-finding-resource-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.8"
                fedramp:specific="true"
                id="has-pen-test-finding-resource"
                role="error"
                test="
                    if (oscal:type = 'finding' and oscal:method = 'TEST')
                    then
                        if (oscal:relevant-evidence[substring-after(@href, '#') = /oscal:assessment-results/oscal:back-matter/oscal:resource[
                        oscal:prop[@value = 'penetration-test-report']]/@uuid])
                        then
                            true()
                        else
                            false()
                    else
                        true()">An observation must have a relevant-evidence href that matches the penetration-test-report back-matter
                resource @uuid value.</sch:assert>

            <sch:let
                name="pen-test-team"
                value="/oscal:assessment-results/oscal:metadata/oscal:responsible-party[@role-id = 'penetration-test-lead']/oscal:party-uuid | /oscal:assessment-results/oscal:metadata/oscal:responsible-party[@role-id = 'penetration-test-team']/oscal:party-uuid" />
            <sch:assert
                diagnostics="has-pen-test-team-match-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.8"
                fedramp:specific="true"
                id="has-pen-test-team-match"
                role="error"
                test="
                    if (oscal:type = 'finding' and oscal:method = 'TEST' and not(oscal:subject/@type = 'component') and oscal:relevant-evidence[substring-after(@href, '#') = /oscal:assessment-results/oscal:back-matter/oscal:resource[
                    oscal:prop[@value = 'penetration-test-report']]/@uuid])
                    then
                        if (oscal:origin/oscal:actor[@type = 'party']/@actor-uuid[. = $pen-test-team])
                        then
                            true()
                        else
                            false()
                    else
                        true()">A penetration test observation must have actors that are described in the responsible-party assemblies
                for 'penetration-test-lead' or 'penetration-test-team'.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:related-observation">
            <sch:let
                name="false-positive-observations"
                value="/oscal:assessment-results/oscal:result/oscal:observation[oscal:type = 'false-positive']/@uuid" />
            <sch:let
                name="false-positive-risks"
                value="/oscal:assessment-results/oscal:result/oscal:risk/@uuid" />

            <sch:assert
                diagnostics="has-false-positive-related-related-observation-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.10.1"
                fedramp:specific="true"
                id="has-false-positive-related-related-observation"
                role="error"
                test="
                    if (@observation-uuid[. = $false-positive-observations])
                    then
                        if (../oscal:associated-risk/@risk-uuid[. = $false-positive-risks])
                        then
                            true()
                        else
                            false()
                    else
                        true()">A related-observation that has an @observation-uuid that matches an observation/@uuid with a type of
                'false-positive' must have an associated-risk/@risk-uuid that matches a risk/@uuid.</sch:assert>
        </sch:rule>

        <sch:let
            name="ssp-statement-uuids"
            value="$ssp-doc//oscal:statement/@uuid" />

        <sch:rule
            context="oscal:risk">
            <sch:assert
                diagnostics="has-risk-adjustment-matching-control-implementation-statement-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.10.3"
                fedramp:specific="true"
                id="has-risk-adjustment-matching-control-implementation-statement"
                role="warning"
                test="
                    if (oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'risk-adjustment'])
                    then
                        if (@uuid[. = $ssp-statement-uuids])
                        then
                            true()
                        else
                            false()
                    else
                        true()"
                unit:override-xspec="both">A risk with an @ns of 'https://fedramp.gov/ns/oscal' and an @name of 'risk-adjustment' should have a
                matching statement in the associated SSP.</sch:assert>

            <sch:assert
                diagnostics="has-risk-log-status-closed-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.11"
                fedramp:specific="true"
                id="has-risk-log-status-closed"
                role="error"
                test="
                    if (oscal:status = 'closed')
                    then
                        if (oscal:risk-log/oscal:entry/oscal:status-change = 'closed')
                        then
                            true()
                        else
                            false()
                    else
                        true()">A risk with a status of 'closed' must have a risk-log/entry with a status-change of
                'closed'.</sch:assert>

            <sch:assert
                diagnostics="has-duplicate-priority-value-diagnostic"
                fedramp:specific="true"
                id="has-duplicate-priority-value"
                role="error"
                test="
                    if (oscal:prop[@name = 'priority'])
                    then
                        if (normalize-space($risk-priority-values) = '')
                        then
                            true()
                        else
                            if (oscal:prop[@name = 'priority']/@value[. ne $risk-priority-values])
                            then
                                true()
                            else
                                false()
                    else
                        true()">Risks with priority properties must have unique priority values.</sch:assert>

            <sch:assert
                diagnostics="has-lifecycle-recommendation-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.6.1"
                fedramp:specific="true"
                id="has-lifecycle-recommendation"
                role="error"
                see="https://github.com/GSA/fedramp-automation-guides/issues/45"
                test="oscal:response[@lifecycle = 'recommendation']">A risk must have a response of lifecycle with a value of
                recommendation.</sch:assert>
        </sch:rule>

        <sch:let
            name="risk-priority-values"
            value="distinct-values(//oscal:risk/oscal:prop[@name = 'priority']/@value[. = following::oscal:risk/oscal:prop[@name = 'priority']/@value])" />

        <sch:rule
            context="oscal:attestation/oscal:part[@name = 'authorization-statements'][oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'recommend-authorization']]">
            <sch:assert
                diagnostics="has-attestation-value-no-diagnostic"
                fedramp:specific="true"
                id="has-attestation-value-no"
                role="error"
                see="Guide to OSCAL-based FedRAMP Security Assessment Results - Section 4.12"
                test="
                    if (oscal:prop/@value ne 'yes')
                    then
                        if (matches(normalize-space(oscal:part[1]/oscal:p[1]), 'A total of \w+ system risk(s?) were identified for .+, including .* High risk(s?), \w+ Moderate risk(s?), \w+ Low risk(s?), and \w+ of operationally required risk(s?).'))
                        then
                            true()
                        else
                            false()
                    else
                        true()">The recommend-authorization attestation with a non-yes value must have a first part with a first
                paragraph that matches the text in the Guide.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:finding">
            <sch:assert
                diagnostics="has-finding-target-status-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.5"
                fedramp:specific="true"
                id="has-finding-target-status-issue"
                role="error"
                test="
                    if (oscal:target/oscal:status/@state = 'not-satisfied')
                    then
                        exists(oscal:associated-risk)
                    else
                        true()">A finding with a target/status of 'not-satisfied must have an associated-risk element.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:associated-risk">
            <sch:let
                name="SAR-risk-uuids"
                value="/oscal:assessment-results/oscal:result/oscal:risk/@uuid" />
            <sch:assert
                diagnostics="has-associated-risk-matching-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.6"
                fedramp:specific="true"
                id="has-associated-risk-matching"
                role="error"
                test="@risk-uuid[. = $SAR-risk-uuids]">An associated-risk/@risk-uuid must have a matching risk/@uuid in the SAR.</sch:assert>
        </sch:rule>

        <!-- It is not clear from the current SAR Guide how to handle multiple facet elements with differing prop[@name='state']/@value values. -->
        <!--<sch:rule
            context="oscal:characterization">
            <sch:assert
                diagnostics="has-likelihood-and-impact-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.6"
                id="has-likelihood-and-impact"
                role="error"
                see="https://github.com/GSA/fedramp-automation-guides/issues/44"
                test="">Each characterization must have pairs of facet elements where the @name is 'likelihood' or 'impact' and the child prop[@name='state'] have the same @value values.</sch:assert>
        </sch:rule>-->

        <sch:rule
            context="oscal:characterization">
            <sch:assert
                diagnostics="has-facet-likelihood-and-impact-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.6"
                fedramp:specific="true"
                id="has-facet-likelihood-and-impact"
                role="error"
                test="oscal:facet[@name = 'likelihood' and @system = 'https://fedramp.gov'] and oscal:facet[@name = 'impact' and @system = 'https://fedramp.gov']">Facets
                with @name of 'likelihood' and @name='impact' must exist in the characterization.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:facet">
            <sch:assert
                diagnostics="has-facet-correct-values-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.6"
                fedramp:specific="true"
                id="has-facet-correct-values"
                role="error"
                test="
                    if ((@name = 'likelihood') and @system = 'https://fedramp.gov' or (@name = 'impact') and @system = 'https://fedramp.gov')
                    then
                        @value = ('low', 'moderate', 'high')
                    else
                        true()">A facet with @name = 'likelihood' or @name='impact' must have an @value of either 'low', 'moderate',
                or 'high'.</sch:assert>
        </sch:rule>
        <!-- It is not clear from the current SAR Guide where the Risk Exposure Level is recorded. -->
    </sch:pattern>

    <sch:pattern
        id="automated-tools">
        <sch:rule
            context="oscal:observation[oscal:origin/oscal:actor/@type = 'tool']">
            <sch:assert
                diagnostics="has-method-TEST-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.7"
                fedramp:specific="true"
                id="has-method-TEST"
                role="error"
                test="oscal:type = 'finding' and oscal:method = 'TEST'">An observation of actor type 'tool' must have a type of 'finding' and a method
                of 'TEST'.</sch:assert>

            <sch:let
                name="assessment-assets-components"
                value="../oscal:local-definitions/oscal:assessment-assets/oscal:component/@uuid" />
            <sch:assert
                diagnostics="has-matching-assessment-asset-component-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.7"
                fedramp:specific="true"
                id="has-matching-assessment-asset-component"
                role="error"
                test="@uuid[. = $assessment-assets-components]">An observation with an actor of type 'tool' must have a matching
                assessment-assets/component.</sch:assert>

            <sch:let
                name="related-observation-UUIDs"
                value="../oscal:finding/oscal:related-observation/@observation-uuid" />
            <sch:assert
                diagnostics="has-related-observation-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.7"
                fedramp:specific="true"
                id="has-related-observation"
                role="error"
                test="@uuid[. = $related-observation-UUIDs]">The observation UUID must be cited by (at least) one of the parent result's finding
                related observations.</sch:assert>

            <sch:assert
                diagnostics="has-relevant-evidence-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.7"
                fedramp:specific="true"
                id="has-relevant-evidence"
                role="error"
                test="
                    (: there is a raw-tool-output resource with the UUID referenced by the context item's relevant-evidence :)
                    //oscal:resource[oscal:prop[@name eq 'type' and @value eq 'raw-tool-output'] and @uuid eq current()/oscal:relevant-evidence[substring-after(@href, '#')]]">This
                observation has a relevant-evidence href that references a raw-tool-output back-matter resource.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:observation[oscal:origin/oscal:actor/@type = 'tool']/oscal:subject">
            <sch:let
                name="local-definition-subjects"
                value="../../oscal:local-definitions/oscal:component/@uuid | ../../oscal:local-definitions/oscal:inventory-item/@uuid" />
            <sch:assert
                diagnostics="observation-subject-is-locally-defined-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.7"
                fedramp:specific="true"
                id="observation-subject-is-locally-defined"
                role="error"
                test="@subject-uuid[. = $local-definition-subjects]">Each subject of an automated tool must correspond to one of the locally defined
                components or inventory-items.</sch:assert>
        </sch:rule>
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
                fedramp:specific="true"
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
                fedramp:specific="true"
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

    <sch:pattern
        id="metadata">
        <sch:rule
            context="oscal:metadata">
            <sch:assert
                diagnostics="has-pen-test-lead-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Security Assessment Results (SAR) §4.8"
                fedramp:specific="true"
                id="has-pen-test-lead"
                role="error"
                test="exists(oscal:responsible-party[@role-id = 'penetration-test-lead']/oscal:party-uuid) and not(exists(oscal:responsible-party[@role-id = 'penetration-test-lead']/oscal:party-uuid[2]))">The
                count of party-uuid elements of a responsible-party of role-id 'penetration-test-lead' must be one.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:diagnostics>

        <sch:diagnostic
            doc:assert="has-import-ap"
            doc:context="oscal:assessment-results"
            id="has-import-ap-diagnostic">This OSCAL SAR lacks an import-ap element.</sch:diagnostic>

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
            doc:assert="sap-document-available"
            doc:context="oscal:import-ap"
            id="sap-document-available-diagnostic">This OSCAL SAR import-ap element does not reference an available SAP document.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="ssp-document-available"
            doc:context="oscal:import-ap"
            id="ssp-document-available-diagnostic">This OSCAL SAR import-ap element does not reference an available SAP document that has an
            import-ssp element that references an available SSP document.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="resolved-profile-catalog-document-available"
            doc:context="oscal:import-ap"
            id="resolved-profile-catalog-document-available-diagnostic">This OSCAL SAR import-ap element does not reference an available SAP document
            that has an import-ssp element that references an available SSP document that has a import-profile element that references a resolved
            profile catalog document.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-security-assessment-plan-resource"
            doc:context="oscal:back-matter"
            id="has-security-assessment-plan-resource-diagnostic">This OSCAL SAR which does not directly import the SAP does not declare the SAP as a
            back-matter resource.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-type-artifact-evidence-resource"
            doc:context="oscal:resource"
            id="has-type-artifact-evidence-resource-diagnostic">The resource, <sch:value-of
                select="@uuid" />, of type 'evidence' or 'artifact' does not have a matching relevant-evidence or subject UUID.</sch:diagnostic>
        <sch:diagnostic
            doc:assert="has-type-artifact-evidence-rlink-base64"
            doc:context="oscal:resource"
            id="has-type-artifact-evidence-rlink-base64-diagnostic">The resource, <sch:value-of
                select="@uuid" />, of type 'evidence' or 'artifact' does not have at least one rlink or base64 child element.</sch:diagnostic>
        <sch:diagnostic
            doc:assert="has-type-artifact-evidence-rlink-relative-path"
            doc:context="oscal:resource"
            id="has-type-artifact-evidence-rlink-relative-path-diagnostic">A resource, <sch:value-of
                select="@uuid" />, of type 'evidence' or 'artifact' has an rlink where the @href value is not a relative path.</sch:diagnostic>

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

        <!-- results -->
        <sch:diagnostic
            doc:assert="not-in-resolved-baseline-controls"
            doc:context="oscal:finding"
            id="not-in-resolved-baseline-controls-diagnostic">The control(s) <sch:value-of
                select="$not-in-resolved-baseline-controls" /> do not exist in the resolved baseline profile document.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="objectives-match-response-points"
            doc:context="oscal:finding"
            id="objectives-match-response-points-diagnostic">In the result, <sch:value-of
                select="@uuid" />, the following response points do not have matching finding/target/@target-id values: <sch:value-of
                select="$finding-not-matches-with-response-points" />.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-lifecycle-recommendation"
            doc:context="oscal:risk"
            id="has-lifecycle-recommendation-diagnostic">This risk, <sch:value-of
                select="@uuid" />, does not have a response element with a lifecycle of 'recommendation'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-finding-target-status"
            doc:context="oscal:finding"
            id="has-finding-target-status-diagnostic">This finding, <sch:value-of
                select="@uuid" />, has a target/status of the value 'not-satisfied' but does not have an associated-risk element.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-associated-risk-matching"
            doc:context="oscal:finding"
            id="has-associated-risk-matching-diagnostic">This associated-risk, <sch:value-of
                select="@risk-uuid" />, does not match any risk uuid values in the SAR.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-facet-correct-values"
            doc:context="oscal:finding"
            id="has-facet-correct-values-diagnostic">This risk, <sch:value-of
                select="../../@uuid" />, has a characterization/facet element with the @name of either 'likelihood' or 'impact' whose @value is not
            'low', 'moderate' or 'high'..</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-facet-likelihood-and-impact"
            doc:context="oscal:finding"
            id="has-facet-likelihood-and-impact-diagnostic">Within a characterization in the risk assembly, <sch:value-of
                select="../@uuid" />, there is not a facet[@name='likelihood'] and a facet[@name='impact'].</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-subject-matching-party-uuid"
            doc:context="oscal:subject"
            id="has-subject-matching-party-uuid-diagnostic">The observation, <sch:value-of
                select="../@uuid" />, has a subject uuid, <sch:value-of
                select="@subject-uuid" />, that does not match a party @uuid in the SSP, SAP, or SAR metadata assembly.</sch:diagnostic>

        <!--<sch:diagnostic
            doc:assert="has-relevant-evidence-matching-resource-uuid"
            doc:context="oscal:relevant-evidence"
            id="has-relevant-evidence-matching-resource-uuid-diagnostic">The observation, <sch:value-of
                select="../@uuid" />, has a relevant-evidence href, <sch:value-of
                    select="@href" />, that does not match a resource @uuid in the SAR back-matter assembly.</sch:diagnostic>-->

        <sch:diagnostic
            doc:assert="has-matching-SAP-party"
            doc:context="oscal:finding"
            id="has-matching-SAP-party-diagnostic">The <sch:value-of
                select="../../local-name()" />, <sch:value-of
                select="../../@uuid" />, has a party, <sch:value-of
                select="@actor-uuid" />, that does not match a SAP or SAR party assembly.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-type-ssp-statement-issue"
            doc:context="oscal:observation"
            id="has-type-ssp-statement-issue-diagnostic">The observation, <sch:value-of
                select="@uuid" />, has a type of 'ssp-statement-issue' but does not have a method of 'EXAMINE'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-type-ssp-statement-issue-matches-related-observation"
            doc:context="oscal:observation"
            id="has-type-ssp-statement-issue-matches-related-observation-diagnostic">The observation, <sch:value-of
                select="@uuid" />, does not have a matching finding/related-observation/@observation-uuid in the SAR.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-implementation-statement-uuid-matches-ssp-statement-uuid"
            doc:context="oscal:observation"
            id="has-implementation-statement-uuid-matches-ssp-statement-uuid-diagnostic">The finding, <sch:value-of
                select="../oscal:finding[oscal:related-observation/@observation-uuid = current()/@uuid]/@uuid" />, that has a
            related-observation/observation-uuid that matches an observation/@uuid, also has a implementation-statement-uuid value that matches a
            statement/@uuid in the associated SSP.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="no-duplicate-target-id"
            doc:context="oscal:result"
            id="no-duplicate-target-id-diagnostic">At least one objective target in the most recent result assembly is duplicated.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-implementation-status"
            doc:context="oscal:target"
            id="has-implementation-status-diagnostic">The target, <sch:value-of
                select="@target-id" />, does not have a property of 'implementation-status'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="implementation-status-value"
            doc:context="oscal:target"
            id="implementation-status-value-diagnostic">The implementation-status of the target, <sch:value-of
                select="@target-id" />, does not match acceptable FedRAMP values.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-satisfaction-status"
            doc:context="oscal:target"
            id="has-satisfaction-status-diagnostic">The target, <sch:value-of
                select="@target-id" />, does not have a status child element.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="satisfaction-status-value"
            doc:context="oscal:target"
            id="satisfaction-status-value-diagnostic">The satisfaction status of the target, <sch:value-of
                select="@target-id" />, does not match acceptable FedRAMP values.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-false-positive-observation"
            doc:context="oscal:observation"
            id="has-false-positive-observation-diagnostic">An observation, <sch:value-of
                select="@uuid" />, with a type of 'false-positive' does not have a @uuid that matches a
            finding/related-observation/@observation-uuid.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-false-positive-related-related-observation"
            doc:context="oscal:observation"
            id="has-false-positive-related-related-observation-diagnostic">A related-observation, within the finding <sch:value-of
                select="../@uuid" />, that has an @observation-uuid that matches an observation/@uuid with a type of 'false-positive' does not have an
            associated-risk/@risk-uuid that matches a risk/@uuid.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-subject-matching-resource-uuid"
            doc:context="oscal:subject"
            id="has-subject-matching-resource-uuid-diagnostic">The observation, <sch:value-of
                select="../@uuid" />, has a subject uuid, <sch:value-of
                select="@subject-uuid" />, that does not match a resource @uuid in the SAR back-matter assembly.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-correct-method-values"
            doc:context="oscal:method"
            id="has-correct-method-values-diagnostic">A method element in <sch:value-of
                select="../local-name()" />, does not contain one of the following strings: 'EXAMINE', 'INTERVIEW', or 'TEST'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-correct-subject-values"
            doc:context="oscal:subject"
            id="has-correct-subject-values-diagnostic">A subject element's type attribute in <sch:value-of
                select="../local-name()" />
            <sch:value-of
                select="../@uuid" />, does not contain one of the following strings: 'component', 'inventory-item', 'location', 'party', or
            'user'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-matching-historic-party"
            doc:context="oscal:result"
            id="has-matching-historic-party-diagnostic">The historic observation, <sch:value-of
                select="../../@uuid" />, has an actor that is not described in either the SAP or the SAR party assemblies.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-method-MIXED"
            doc:context="oscal:result"
            id="has-method-MIXED-diagnostic">The historic observation, <sch:value-of
                select="@uuid" />, does not have a method of 'MIXED'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-correct-actor-type"
            doc:context="oscal:subject"
            id="has-correct-actor-type-diagnostic">An actor element's type attribute in <sch:value-of
                select="../../local-name()" />
            <sch:value-of
                select="../../@uuid" />, does not contain one of the following strings: 'tool', 'party', or 'assessment-platform'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-matching-SAP-tasks"
            doc:context="oscal:subject"
            id="has-matching-SAP-tasks-diagnostic">A related-task element's uuid attribute in <sch:value-of
                select="../../local-name()" />
            <sch:value-of
                select="../../@uuid" />, does not match any task @uuid value in the associated SAP.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-pen-test-finding-resource"
            doc:context="oscal:observation"
            id="has-pen-test-finding-resource-diagnostic">An observation has a relevant-evidence href that does not matches the
            penetration-test-report back-matter resource @uuid value.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-pen-test-team-match"
            doc:context="oscal:observation"
            id="has-pen-test-team-match-diagnostic">A penetration test observation, <sch:value-of
                select="@uuid" /> has actors that are not described in the responsible-party assemblies for 'penetration-test-lead' or
            'penetration-test-team'.</sch:diagnostic>

        <!-- automated-tools -->
        <sch:diagnostic
            doc:assert="has-related-observation"
            doc:context="oscal:observation"
            id="has-related-observation-diagnostic">An observation, <sch:value-of
                select="@uuid" />, is not cited by (at least) one of the parent result's finding related observations.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-method-TEST"
            doc:context="oscal:observation"
            id="has-method-TEST-diagnostic">The finding observation, <sch:value-of
                select="@uuid" />, of actor type 'tool' does not have a type of 'finding' and a method of 'TEST'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-matching-assessment-asset-component"
            doc:context="oscal:observation"
            id="has-matching-assessment-asset-component-diagnostic">An observation with an actor of type 'tool' does not have a matching
            assessment-assets/component.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="observation-subject-is-locally-defined"
            doc:context="oscal:subject"
            id="observation-subject-is-locally-defined-diagnostic">The subject, <sch:value-of
                select="@subject-uuid" />, does not correspond to one of the locally defined components or inventory-items.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-relevant-evidence"
            doc:context="oscal:observation"
            id="has-relevant-evidence-diagnostic">The observation, <sch:value-of
                select="@uuid" />, has a relevant-evidence href that does not reference any raw-tool-output back-matter resource @uuid
            value.</sch:diagnostic>

        <!-- metadata -->
        <sch:diagnostic
            doc:assert="has-pen-test-lead"
            doc:context="oscal:observation"
            id="has-pen-test-lead-diagnostic">The count of party-uuid elements of a responsible-party of role-id 'penetration-test-lead' is not
            one.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-risk-adjustment-observation"
            doc:context="oscal:observation"
            id="has-risk-adjustment-observation-diagnostic">An observation, <sch:value-of
                select="@uuid" />, with a type of 'risk-adjustment' does not have a @uuid that matches a
            finding/related-observation/@observation-uuid.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-risk-adjustmentt-relevant-evidence"
            doc:context="oscal:observation"
            id="has-risk-adjustment-relevant-evidence-diagnostic">An observation, <sch:value-of
                select="@uuid" />, with a type of 'risk-adjustment' does not have a relevant-evidence/link/@href, whose value after the '#', matches a
            back-matter/resource/@uuid.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-risk-adjustment-matching-control-implementation-statement"
            doc:context="oscal:risk"
            id="has-risk-adjustment-matching-control-implementation-statement-diagnostic">A risk, <sch:value-of
                select="@uuid" />, with a type of 'risk-adjustment' does not have a matching statement @uuid in the associated SSP.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-risk-log-status-closed"
            doc:context="oscal:risk"
            id="has-risk-log-status-closed-diagnostic">A risk, <sch:value-of
                select="@uuid" />, with a status of 'closed' does not have a risk-log/entry with a status-change of 'closed'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-operational-requirement-observation"
            doc:context="oscal:observation"
            id="has-operational-requirement-observation-diagnostic">An observation, <sch:value-of
                select="@uuid" />, with a type of 'operational-requirement' does not have a @uuid that matches a
            finding/related-observation/@observation-uuid.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-operational-requirement-relevant-evidence"
            doc:context="oscal:observation"
            id="has-operational-requirement-relevant-evidence-diagnostic">An observation, <sch:value-of
                select="@uuid" />, with a type of 'operational-requirement' does not have a relevant-evidence/@href, whose value after the '#',
            matches a back-matter/resource/@uuid.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-attestation"
            doc:context="oscal:result"
            id="has-attestation-diagnostic">The result, <sch:value-of
                select="@uuid" />, does not contain an attestation/part with a property of 'recommend-authorization'.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="matching-control-PL-2-objectives"
            doc:context="oscal:result"
            id="matching-control-PL-2-objectives-diagnostic">Within a SAR, the PL-2 unsatisfied objectives, <sch:value-of
                select="$pl-2-not-matches-other-than-satisfied-findings" />, do not have a matching part in the resolved profile
            catalog.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="minimal-control-PL-2-findings"
            doc:context="oscal:result"
            id="minimal-control-PL-2-findings-diagnostic">Within a SAR, the result, <sch:value-of
                select="@uuid" />, contains more than one finding for the control PL-2.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-attestation-value-no"
            doc:context="oscal:attestation"
            id="has-attestation-value-no-diagnostic">The recommend-authorization attestation with a non-yes value does not have a first part with a
            first paragraph that matches the text in the Guide.</sch:diagnostic>

        <sch:diagnostic
            doc:assert="has-duplicate-priority-value"
            doc:context="oscal:result"
            id="has-duplicate-priority-value-diagnostic">The risk, <sch:value-of
                select="@uuid" /> has a priority property that is not a unique priority value.</sch:diagnostic>

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
