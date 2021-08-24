<?xml version="1.0" encoding="utf-8"?>
<sch:schema
    queryBinding="xslt2"
    xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
    xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <sch:ns
        prefix="f"
        uri="https://fedramp.gov/ns/oscal" />
    <sch:ns
        prefix="o"
        uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns
        prefix="oscal"
        uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns
        prefix="fedramp"
        uri="https://fedramp.gov/ns/oscal" />
    <sch:ns
        prefix="lv"
        uri="local-validations" />
    <sch:phase
        id="Phase2">
        <sch:active
            pattern="phase2" />
    </sch:phase>
    <sch:phase
        id="Phase3">
        <sch:active
            pattern="resources" />
        <sch:active
            pattern="base64" />
        <sch:active
            pattern="specific-attachments" />
        <sch:active
            pattern="policy-and-procedure" />
        <sch:active
            pattern="privacy1" />
        <sch:active
            pattern="privacy2" />
        <sch:active
            pattern="fips-140" />
        <sch:active
            pattern="fips-199" />
        <sch:active
            pattern="sp800-60" />
        <sch:active
            pattern="sp800-63" />
        <sch:active
            pattern="system-inventory" />
        <sch:active
            pattern="basic-system-characteristics" />
        <sch:active
            pattern="general-roles" />
        <sch:active
            pattern="implementation-roles" />
        <sch:active
            pattern="user-properties" />
        <sch:active
            pattern="authorization-boundary" />
        <sch:active
            pattern="network-architecture" />
        <sch:active
            pattern="data-flow" />
        <sch:active
            pattern="control-implementation" />
        <sch:active
            pattern="interconnects" />
        <sch:active
            pattern="info" />
    </sch:phase>
    <sch:phase
        id="test">
        <sch:active
            pattern="interconnects" />
    </sch:phase>
    <sch:phase
        id="information">
        <sch:active
            pattern="info" />
    </sch:phase>
    <sch:phase
        id="attachments">
        <sch:active
            pattern="resources" />
        <sch:active
            pattern="base64" />
        <sch:active
            pattern="specific-attachments" />
        <sch:active
            pattern="policy-and-procedure" />
        <sch:active
            pattern="authorization-boundary" />
        <sch:active
            pattern="network-architecture" />
        <sch:active
            pattern="data-flow" />
    </sch:phase>
    <sch:phase
        id="privacy">
        <sch:active
            pattern="privacy1" />
        <sch:active
            pattern="privacy2" />
    </sch:phase>
    <sch:phase
        id="inventory">
        <sch:active
            pattern="system-inventory" />
    </sch:phase>
    <sch:phase
        id="diagrams">
        <sch:active
            pattern="authorization-boundary" />
        <sch:active
            pattern="network-architecture" />
        <sch:active
            pattern="data-flow" />
    </sch:phase>
    <sch:phase
        id="roles">
        <sch:active
            pattern="general-roles" />
        <sch:active
            pattern="implementation-roles" />
        <sch:active
            pattern="user-properties" />
    </sch:phase>
    <doc:xspec
        href="../test/ssp.xspec" />
    <sch:title>FedRAMP System Security Plan Validations</sch:title>
    <xsl:output
        encoding="UTF-8"
        indent="yes"
        method="xml" />
    <xsl:param
        as="xs:string"
        name="registry-base-path"
        select="'../../content/resources/xml'" />
    <xsl:param
        as="xs:string"
        name="baselines-base-path"
        select="'../../../dist/content/baselines/rev4/xml'" />
    <sch:let
        name="registry"
        value="doc(concat($registry-base-path, '/fedramp_values.xml')) | doc(concat($registry-base-path, '/fedramp_threats.xml')) | doc(concat($registry-base-path, '/information-types.xml'))" />
    <!--xsl:variable name="registry">
        <xsl:sequence select="doc(concat($registry-base-path, '/fedramp_values.xml')) | 
                              doc(concat($registry-base-path, '/fedramp_threats.xml')) |
                              doc(concat($registry-base-path, '/information-types.xml'))"/>
    </xsl:variable-->
    <xsl:function
        name="lv:if-empty-default">
        <xsl:param
            name="item" />
        <xsl:param
            name="default" />
        <xsl:choose>
            <!-- Atomic types, integers, strings, et cetera. -->
            <xsl:when
                test="$item instance of xs:untypedAtomic or $item instance of xs:anyURI or $item instance of xs:string or $item instance of xs:QName or $item instance of xs:boolean or $item instance of xs:base64Binary or $item instance of xs:hexBinary or $item instance of xs:integer or $item instance of xs:decimal or $item instance of xs:float or $item instance of xs:double or $item instance of xs:date or $item instance of xs:time or $item instance of xs:dateTime or $item instance of xs:dayTimeDuration or $item instance of xs:yearMonthDuration or $item instance of xs:duration or $item instance of xs:gMonth or $item instance of xs:gYear or $item instance of xs:gYearMonth or $item instance of xs:gDay or $item instance of xs:gMonthDay">

                <xsl:value-of
                    select="
                        if ($item => string() => normalize-space() eq '') then
                            $default
                        else
                            $item" />
            </xsl:when>
            <!-- Any node-kind that can be a sequence type -->
            <xsl:when
                test="$item instance of element() or $item instance of attribute() or $item instance of text() or $item instance of node() or $item instance of document-node() or $item instance of comment() or $item instance of processing-instruction()">

                <xsl:sequence
                    select="
                        if ($item => normalize-space() => not()) then
                            $default
                        else
                            $item" />
            </xsl:when>
            <xsl:otherwise>
                <!-- 
                If no suitable type found, return empty sequence, as that can
                be falsey and cast to empty string or checked for `not(exist(.))`
                later.
             -->
                <xsl:sequence
                    select="()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function
        as="item()*"
        name="lv:registry">
        <xsl:sequence
            select="$registry" />
    </xsl:function>
    <xsl:function
        as="xs:string"
        name="lv:sensitivity-level">
        <xsl:param
            as="node()*"
            name="context" />
        <xsl:value-of
            select="$context//o:security-sensitivity-level" />
    </xsl:function>
    <xsl:function
        as="document-node()*"
        name="lv:profile">
        <xsl:param
            name="level"
            required="true" />
        <xsl:variable
            name="profile-map">
            <profile
                href="{concat($baselines-base-path, '/FedRAMP_rev4_LOW-baseline-resolved-profile_catalog.xml')}"
                level="fips-199-low" />
            <profile
                href="{concat($baselines-base-path, '/FedRAMP_rev4_MODERATE-baseline-resolved-profile_catalog.xml')}"
                level="fips-199-moderate" />
            <profile
                href="{concat($baselines-base-path, '/FedRAMP_rev4_HIGH-baseline-resolved-profile_catalog.xml')}"
                level="fips-199-high" />
        </xsl:variable>
        <xsl:variable
            name="href"
            select="$profile-map/profile[@level = $level]/@href" />
        <xsl:sequence
            select="doc(resolve-uri($href))" />
    </xsl:function>
    <xsl:function
        name="lv:correct">
        <xsl:param
            as="element()*"
            name="value-set" />
        <xsl:param
            as="node()*"
            name="value" />
        <xsl:variable
            name="values"
            select="$value-set/f:allowed-values/f:enum/@value" />
        <xsl:choose>
            <!-- If allow-other is set, anything is valid. -->
            <xsl:when
                test="$value-set/f:allowed-values/@allow-other eq 'no' and $value = $values" />
            <xsl:otherwise>
                <xsl:value-of
                    select="$values"
                    separator=", " />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function
        name="lv:analyze">
        <xsl:param
            as="element()*"
            name="value-set" />
        <xsl:param
            as="element()*"
            name="element" />
        <xsl:choose>
            <xsl:when
                test="$value-set/f:allowed-values/f:enum/@value">
                <xsl:sequence>
                    <xsl:call-template
                        name="analysis-template">
                        <xsl:with-param
                            name="value-set"
                            select="$value-set" />
                        <xsl:with-param
                            name="element"
                            select="$element" />
                    </xsl:call-template>
                </xsl:sequence>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message
                    expand-text="yes">error</xsl:message>
                <xsl:sequence>
                    <xsl:call-template
                        name="analysis-template">
                        <xsl:with-param
                            name="value-set"
                            select="$value-set" />
                        <xsl:with-param
                            name="element"
                            select="$element" />
                        <xsl:with-param
                            name="errors">
                            <error>value-set was malformed</error>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:sequence>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function
        as="xs:string"
        name="lv:report">
        <xsl:param
            as="element()*"
            name="analysis" />
        <xsl:variable
            as="xs:string"
            name="results">
            <xsl:call-template
                name="report-template">
                <xsl:with-param
                    name="analysis"
                    select="$analysis" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of
            select="$results" />
    </xsl:function>
    <xsl:template
        as="element()"
        name="analysis-template">
        <xsl:param
            as="element()*"
            name="value-set" />
        <xsl:param
            as="element()*"
            name="element" />
        <xsl:param
            as="node()*"
            name="errors" />
        <xsl:variable
            name="ok-values"
            select="$value-set/f:allowed-values/f:enum/@value" />
        <analysis>
            <errors>
                <xsl:if
                    test="$errors">
                    <xsl:sequence
                        select="$errors" />
                </xsl:if>
            </errors>
            <reports
                count="{count($element)}"
                description="{$value-set/f:description}"
                formal-name="{$value-set/f:formal-name}"
                name="{$value-set/@name}">
                <xsl:for-each
                    select="$ok-values">
                    <xsl:variable
                        name="match"
                        select="$element[@value = current()]" />
                    <report
                        count="{count($match)}"
                        value="{current()}" />
                </xsl:for-each>
            </reports>
        </analysis>
    </xsl:template>
    <xsl:template
        as="xs:string"
        name="report-template">
        <xsl:param
            as="element()*"
            name="analysis" />
        <xsl:value-of>There are <xsl:value-of
                select="$analysis/reports/@count" />&#xa0; <xsl:value-of
                select="$analysis/reports/@formal-name" />
            <xsl:choose>
                <xsl:when
                    test="$analysis/reports/report"> items total, with </xsl:when>
                <xsl:otherwise> items total.</xsl:otherwise>
            </xsl:choose>
            <xsl:for-each
                select="$analysis/reports/report">
                <xsl:if
                    test="position() gt 0 and not(position() eq last())">
                    <xsl:value-of
                        select="current()/@count" /> set as <xsl:value-of
                        select="current()/@value" />, </xsl:if>
                <xsl:if
                    test="position() gt 0 and position() eq last()"> and <xsl:value-of
                        select="current()/@count" /> set as <xsl:value-of
                        select="current()/@value" />.</xsl:if>
                <xsl:sequence
                    select="." />
            </xsl:for-each>There are <xsl:value-of
                select="($analysis/reports/@count - sum($analysis/reports/report/@count))" /> invalid items. <xsl:if
                test="count($analysis/errors/error) &gt; 0">
                <xsl:message
                    expand-text="yes">hit error block</xsl:message>
                <xsl:for-each
                    select="$analysis/errors/error">Also, <xsl:value-of
                        select="current()/text()" />, so analysis could be inaccurate or it completely failed.</xsl:for-each>
            </xsl:if></xsl:value-of>
    </xsl:template>
    <sch:pattern
        id="phase2">
        <sch:rule
            context="/o:system-security-plan">
            <sch:let
                name="ok-values"
                value="$registry/f:fedramp-values/f:value-set[@name eq 'security-level']" />
            <sch:let
                name="sensitivity-level"
                value="/ => lv:sensitivity-level() => lv:if-empty-default('')" />
            <sch:let
                name="corrections"
                value="lv:correct($ok-values, $sensitivity-level)" />
            <sch:assert
                diagnostics="no-registry-values-diagnostic"
                id="no-registry-values"
                role="fatal"
                test="count($registry/f:fedramp-values/f:value-set) &gt; 0">The validation technical components are present.</sch:assert>
            <sch:assert
                diagnostics="no-security-sensitivity-level-diagnostic"
                doc:checklist-reference="Section C Check 1.a"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.2"
                doc:template-reference="System Security Plan Template §2.2"
                id="no-security-sensitivity-level"
                role="fatal"
                test="$sensitivity-level ne ''">[Section C Check 1.a] A FedRAMP SSP must define its sensitivity level.</sch:assert>
            <sch:assert
                diagnostics="invalid-security-sensitivity-level-diagnostic"
                doc:checklist-reference="Section C Check 1.a"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.2"
                doc:template-reference="System Security Plan Template §2.2"
                id="invalid-security-sensitivity-level"
                role="fatal"
                test="empty($ok-values) or not(exists($corrections))">[Section C Check 1.a] A FedRAMP SSP must have an allowed sensitivity
                level.</sch:assert>
            <sch:let
                name="implemented"
                value="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement" />
            <sch:report
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5"
                id="implemented-response-points"
                role="information"
                test="true()">A FedRAMP SSP must implement a statement for each of the following lettered response points for required controls: <sch:value-of
                    select="$implemented/@statement-id" />.</sch:report>
        </sch:rule>
        <sch:rule
            context="/o:system-security-plan/o:control-implementation"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5">
            <sch:let
                name="registry-ns"
                value="$registry/f:fedramp-values/f:namespace/f:ns/@ns" />
            <sch:let
                name="sensitivity-level"
                value="/ => lv:sensitivity-level()" />
            <sch:let
                name="ok-values"
                value="$registry/f:fedramp-values/f:value-set[@name eq 'control-implementation-status']" />
            <sch:let
                name="selected-profile"
                value="$sensitivity-level => lv:profile()" />
            <sch:let
                name="required-controls"
                value="$selected-profile/*//o:control" />
            <sch:let
                name="implemented"
                value="o:implemented-requirement" />
            <sch:let
                name="all-missing"
                value="$required-controls[not(@id = $implemented/@control-id)]" />
            <sch:let
                name="core-missing"
                value="$required-controls[o:prop[@name eq 'CORE' and @ns = $registry-ns] and @id = $all-missing/@id]" />
            <sch:let
                name="extraneous"
                value="$implemented[not(@control-id = $required-controls/@id)]" />
            <sch:report
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5"
                id="each-required-control-report"
                role="information"
                test="true()">Sensitivity-level is <sch:value-of
                    select="$sensitivity-level" />, the following <sch:value-of
                    select="count($required-controls)" />
                <sch:value-of
                    select="
                        if (count($required-controls) = 1) then
                            ' control'
                        else
                            ' controls'" /> are required: <sch:value-of
                    select="$required-controls/@id" />.</sch:report>
            <sch:assert
                diagnostics="incomplete-core-implemented-requirements-diagnostic"
                doc:checklist-reference="Section C Check 3"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5"
                id="incomplete-core-implemented-requirements"
                role="error"
                test="not(exists($core-missing))">[Section C Check 3] A FedRAMP SSP must implement the most important controls.</sch:assert>
            <sch:assert
                diagnostics="incomplete-all-implemented-requirements-diagnostic"
                doc:checklist-reference="Section C Check 2"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5"
                doc:template-reference="System Security Plan Template §13"
                id="incomplete-all-implemented-requirements"
                role="warning"
                test="not(exists($all-missing))">[Section C Check 2] A FedRAMP SSP must implement all required controls.</sch:assert>
            <sch:assert
                diagnostics="extraneous-implemented-requirements-diagnostic"
                doc:checklist-reference="Section C Check 2"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5"
                doc:template-reference="System Security Plan Template §13"
                id="extraneous-implemented-requirements"
                role="warning"
                test="not(exists($extraneous))">[Section C Check 2] A FedRAMP SSP must not include implemented controls beyond what is required for
                the applied baseline.</sch:assert>
            <sch:let
                name="results"
                value="$ok-values => lv:analyze(//o:implemented-requirement/o:prop[@name eq 'implementation-status'])" />
            <sch:let
                name="total"
                value="$results/reports/@count" />
            <sch:report
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5"
                id="control-implemented-requirements-stats"
                role="information"
                test="count($results/errors/error) = 0">
                <sch:value-of
                    select="$results => lv:report() => normalize-space()" />.</sch:report>
        </sch:rule>
        <sch:rule
            context="/o:system-security-plan/o:control-implementation/o:implemented-requirement">
            <sch:let
                name="sensitivity-level"
                value="/ => lv:sensitivity-level() => lv:if-empty-default('')" />
            <sch:let
                name="selected-profile"
                value="$sensitivity-level => lv:profile()" />
            <sch:let
                name="registry-ns"
                value="$registry/f:fedramp-values/f:namespace/f:ns/@ns" />
            <sch:let
                name="status"
                value="./o:prop[@name eq 'implementation-status']/@value" />
            <sch:let
                name="corrections"
                value="lv:correct($registry/f:fedramp-values/f:value-set[@name eq 'control-implementation-status'], $status)" />
            <sch:let
                name="required-response-points"
                value="$selected-profile/o:catalog//o:part[@name eq 'item']" />
            <sch:let
                name="implemented"
                value="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement" />
            <sch:let
                name="missing"
                value="$required-response-points[not(@id = $implemented/@statement-id)]" />
            <sch:assert
                diagnostics="invalid-implementation-status-diagnostic"
                doc:checklist-reference="Section C Check 2"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                doc:template-reference="System Security Plan Template §13"
                id="invalid-implementation-status"
                role="error"
                test="not(exists($corrections))">[Section C Check 2] Implementation status is correct.</sch:assert>
            <sch:assert
                diagnostics="missing-response-points-diagnostic"
                doc:checklist-reference="Section C Check 2"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5"
                doc:template-reference="System Security Plan Template §13"
                id="missing-response-points"
                role="error"
                test="not(exists($missing))">[Section C Check 2] A FedRAMP SSP must have required response points.</sch:assert>
        </sch:rule>
        <sch:rule
            context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement">
            <sch:let
                name="required-components-count"
                value="1" />
            <sch:let
                name="required-length"
                value="20" />
            <sch:let
                name="components-count"
                value="./o:by-component => count()" />
            <sch:let
                name="remarks"
                value="./o:remarks => normalize-space()" />
            <sch:let
                name="remarks-length"
                value="$remarks => string-length()" />
            <sch:assert
                diagnostics="missing-response-components-diagnostic"
                doc:checklist-reference="Section D Checks"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5"
                doc:template-reference="System Security Plan Template §13"
                id="missing-response-components"
                role="warning"
                test="$components-count ge $required-components-count">[Section D Checks] Response statements have sufficient components.</sch:assert>
        </sch:rule>
        <sch:rule
            context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:description">
            <sch:assert
                diagnostics="extraneous-response-description-diagnostic"
                doc:checklist-reference="Section D Checks"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5"
                doc:template-reference="System Security Plan Template §13"
                id="extraneous-response-description"
                role="warning"
                test=". => empty()">[Section D Checks] Response statement does not have a description not within a component.</sch:assert>
        </sch:rule>
        <sch:rule
            context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:remarks">
            <sch:assert
                diagnostics="extraneous-response-remarks-diagnostic"
                doc:checklist-reference="Section D Checks"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5"
                doc:template-reference="System Security Plan Template §13"
                id="extraneous-response-remarks"
                role="warning"
                test=". => empty()">[Section D Checks] Response statement does not have remarks not within a component.</sch:assert>
        </sch:rule>
        <sch:rule
            context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component">
            <sch:let
                name="component-ref"
                value="./@component-uuid" />
            <sch:assert
                diagnostics="invalid-component-match-diagnostic"
                doc:checklist-reference="Section D Checks"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5"
                doc:template-reference="System Security Plan Template §13"
                id="invalid-component-match"
                role="warning"
                test="/o:system-security-plan/o:system-implementation/o:component[@uuid eq $component-ref] => exists()">[Section D Checks] Response
                statement cites a component in the system implementation inventory.</sch:assert>
            <sch:assert
                diagnostics="missing-component-description-diagnostic"
                doc:checklist-reference="Section D Checks"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5"
                doc:template-reference="System Security Plan Template §13"
                id="missing-component-description"
                role="error"
                test="./o:description => exists()">[Section D Checks] Response statement has a component which has a required
                description.</sch:assert>
        </sch:rule>
        <sch:rule
            context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:description">
            <sch:let
                name="required-length"
                value="20" />
            <sch:let
                name="description"
                value=". => normalize-space()" />
            <sch:let
                name="description-length"
                value="$description => string-length()" />
            <sch:assert
                diagnostics="incomplete-response-description-diagnostic"
                doc:checklist-reference="Section D Checks"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5"
                doc:template-reference="System Security Plan Template §13"
                id="incomplete-response-description"
                role="error"
                test="$description-length ge $required-length">[Section D Checks] Response statement component description has adequate
                length.</sch:assert>
        </sch:rule>
        <sch:rule
            context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:remarks">
            <sch:let
                name="required-length"
                value="20" />
            <sch:let
                name="remarks"
                value=". => normalize-space()" />
            <sch:let
                name="remarks-length"
                value="$remarks => string-length()" />
            <sch:assert
                diagnostics="incomplete-response-remarks-diagnostic"
                doc:checklist-reference="Section D Checks"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5"
                doc:template-reference="System Security Plan Template §13"
                id="incomplete-response-remarks"
                role="warning"
                test="$remarks-length ge $required-length">[Section D Checks] Response statement component remarks have adequate length.</sch:assert>
        </sch:rule>
        <sch:rule
            context="/o:system-security-plan/o:metadata">
            <sch:let
                name="parties"
                value="o:party" />
            <sch:let
                name="roles"
                value="o:role" />
            <sch:let
                name="responsible-parties"
                value="./o:responsible-party" />
            <sch:let
                name="extraneous-roles"
                value="$responsible-parties[not(@role-id = $roles/@id)]" />
            <sch:let
                name="extraneous-parties"
                value="$responsible-parties[not(o:party-uuid = $parties/@uuid)]" />
            <sch:assert
                diagnostics="incorrect-role-association-diagnostic"
                doc:checklist-reference="Section C Check 2"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                doc:template-reference="System Security Plan Template §9.3"
                id="incorrect-role-association"
                role="error"
                test="not(exists($extraneous-roles))">[Section C Check 2] A FedRAMP SSP must define a responsible party with no extraneous
                roles.</sch:assert>
            <sch:assert
                diagnostics="incorrect-party-association-diagnostic"
                doc:checklist-reference="Section C Check 2"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                doc:template-reference="System Security Plan Template §9.3"
                id="incorrect-party-association"
                role="error"
                test="not(exists($extraneous-parties))">[Section C Check 2] A FedRAMP SSP must define a responsible party with no extraneous
                parties.</sch:assert>
        </sch:rule>
        <sch:rule
            context="/o:system-security-plan/o:back-matter/o:resource">
            <sch:assert
                diagnostics="resource-uuid-required-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6"
                doc:template-reference="System Security Plan Template §9.3"
                id="resource-uuid-required"
                role="error"
                test="@uuid">Every supporting artifact found in a citation has a unique identifier.</sch:assert>
        </sch:rule>
        <!-- The following rule is commented out because doc-available does not provide the desired existence check -->
        <!--<sch:rule
            context="/o:system-security-plan/o:back-matter/o:resource/o:rlink">
            <sch:assert
                diagnostics="resource-rlink-required-diagnostic"
                doc:organizational-id="section-b.?????"
                id="resource-rlink-required"
                role="error"
                test="doc-available(./@href)">A FedRAMP SSP must reference back-matter resource: <sch:value-of
                    select="./@href" /></sch:assert>
        </sch:rule>-->
        <sch:rule
            context="/o:system-security-plan/o:back-matter/o:resource/o:base64"
            doc:guide-reference="Guide to OSCAL-based FedRAMP Content §4.10">
            <sch:let
                name="filename"
                value="@filename" />
            <sch:let
                name="media-type"
                value="@media-type" />
            <sch:assert
                diagnostics="resource-base64-available-filename-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Content §4.10"
                doc:template-reference="System Security Plan Template §15"
                id="resource-base64-available-filename"
                role="error"
                test="./@filename">Every declared embedded attachment has a filename attribute.</sch:assert>
            <sch:assert
                diagnostics="resource-base64-available-media-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Content §4.10"
                doc:template-reference="System Security Plan Template §15"
                id="resource-base64-available-media-type"
                role="error"
                test="./@media-type">Every declared embedded attachment has a media type.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <!-- set $fedramp-values globally -->
    <sch:let
        name="fedramp-values"
        value="doc(concat($registry-base-path, '/fedramp_values.xml'))" />
    <!-- ↑ stage 2 content ↑ -->
    <!-- ↓ stage 3 content ↓ -->
    <sch:pattern
        id="resources">
        <sch:title>Basic resource constraints</sch:title>
        <sch:let
            name="attachment-types"
            value="$fedramp-values//fedramp:value-set[@name eq 'attachment-type']//fedramp:enum/@value" />
        <sch:rule
            context="oscal:resource"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6">
            <!-- the following assertion recapitulates the XML Schema constraint -->
            <sch:assert
                diagnostics="resource-has-uuid-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                doc:template-reference="System Security Plan Template §15"
                id="resource-has-uuid"
                role="error"
                test="@uuid">Every supporting artifact found in a citation must have a unique identifier.</sch:assert>
            <sch:assert
                diagnostics="resource-has-title-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                doc:template-reference="System Security Plan Template §15"
                id="resource-has-title"
                role="warning"
                test="oscal:title">Every supporting artifact found in a citation should have a title.</sch:assert>
            <sch:assert
                diagnostics="resource-has-rlink-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                doc:template-reference="System Security Plan Template §15"
                id="resource-has-rlink"
                role="error"
                test="oscal:rlink">Every supporting artifact found in a citation must have a rlink element.</sch:assert>
            <sch:assert
                diagnostics="resource-is-referenced-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                doc:template-reference="System Security Plan Template §15"
                id="resource-is-referenced"
                role="information"
                test="@uuid = (//@href[matches(., '^#')] ! substring-after(., '#'))">Every supporting artifact found in a citation should be
                referenced from within the document.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:back-matter/oscal:resource/oscal:prop[@name eq 'type']"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1">
            <sch:assert
                diagnostics="attachment-type-is-valid-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                doc:template-reference="System Security Plan Template §15"
                id="attachment-type-is-valid"
                role="warning"
                test="@value = $attachment-types">A supporting artifact found in a citation should have an allowed attachment type.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:back-matter/oscal:resource/oscal:rlink">
            <sch:assert
                diagnostics="rlink-has-href-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                doc:template-reference="System Security Plan Template §15"
                id="rlink-has-href"
                role="error"
                test="@href">Every supporting artifact found in a citation rlink must have a reference.</sch:assert>
            <!-- Both doc-avail() and unparsed-text-available() are failing on arbitrary hrefs -->
            <!--<sch:assert test="unparsed-text-available(@href)">the &lt;<sch:name/>&gt; element href attribute refers to a non-existent
                document</sch:assert>-->
            <!--<sch:assert id="rlink-has-media-type"
                role="warning"
                test="$WARNING and @media-type">the &lt;<sch:name/>&gt; element should have a media-type attribute</sch:assert>-->
        </sch:rule>
        <sch:rule
            context="oscal:rlink | oscal:base64"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1"
            role="error">
            <sch:let
                name="media-types"
                value="$fedramp-values//fedramp:value-set[@name eq 'media-type']//fedramp:enum/@value" />
            <!--<sch:report role="information"
                        test="false()">There are 
            <sch:value-of select="count($media-types)" />media types.</sch:report>-->
            <sch:assert
                diagnostics="has-allowed-media-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                doc:template-reference="System Security Plan Template §15"
                id="has-allowed-media-type"
                role="error"
                test="@media-type = $media-types">A media-type attribute must have an allowed value.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1"
        id="base64">
        <sch:title>base64 attachments</sch:title>
        <sch:rule
            context="oscal:back-matter/oscal:resource"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1">
            <sch:assert
                diagnostics="resource-has-base64-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                doc:template-reference="System Security Plan Template §15"
                id="resource-has-base64"
                role="warning"
                test="oscal:base64">A supporting artifact found in a citation should have an embedded attachment element.</sch:assert>
            <sch:assert
                diagnostics="resource-base64-cardinality-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                doc:template-reference="System Security Plan Template §15"
                id="resource-has-base64-cardinality"
                role="error"
                test="not(oscal:base64[2])">A supporting artifact found in a citation must have only one embedded attachment element.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:back-matter/oscal:resource/oscal:base64"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1">
            <sch:assert
                diagnostics="base64-has-filename-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                doc:template-reference="System Security Plan Template §15"
                id="base64-has-filename"
                role="error"
                test="@filename">Every embedded attachment element must have a filename attribute.</sch:assert>
            <sch:assert
                diagnostics="base64-has-media-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                doc:template-reference="System Security Plan Template §15"
                id="base64-has-media-type"
                role="error"
                test="@media-type">Every embedded attachment element must have a media type.</sch:assert>
            <sch:assert
                diagnostics="base64-has-content-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                doc:template-reference="System Security Plan Template §15"
                id="base64-has-content"
                role="error"
                test="matches(normalize-space(), '^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$')"> Every
                embedded attachment element must have content.</sch:assert>
            <!-- FYI: http://expath.org/spec/binary#decode-string handles base64 but Saxon-PE or higher is necessary -->
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        id="specific-attachments">
        <sch:title>Constraints for specific attachments</sch:title>
        <sch:rule
            context="oscal:back-matter"
            doc:guide-reference="https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf"
            see="https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf">
            <sch:assert
                diagnostics="has-fedramp-acronyms-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Content §4.8"
                doc:template-reference="System Security Plan Template §14"
                id="has-fedramp-acronyms"
                role="error"
                test="oscal:resource[oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'type' and @value eq 'fedramp-acronyms']]">A
                FedRAMP OSCAL SSP must have the FedRAMP Master Acronym and Glossary attached.</sch:assert>
            <sch:assert
                diagnostics="has-fedramp-citations-diagnostic"
                doc:checklist-reference="Section B Check 3.12"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Content §4.10"
                doc:template-reference="System Security Plan Template §15 Attachment 12"
                id="has-fedramp-citations"
                role="error"
                test="oscal:resource[oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'type' and @value eq 'fedramp-citations']]">
                [Section B Check 3.12] A FedRAMP SSP must have the FedRAMP Applicable Laws and Regulations attached.</sch:assert>
            <sch:assert
                diagnostics="has-fedramp-logo-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP Content §4.1"
                id="has-fedramp-logo"
                role="error"
                test="oscal:resource[oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'type' and @value eq 'fedramp-logo']]">A FedRAMP
                OSCAL SSP must have the FedRAMP Logo attached.</sch:assert>
            <sch:assert
                diagnostics="has-user-guide-diagnostic"
                doc:checklist-reference="Section B Check 3.2"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6"
                doc:template-reference="System Security Plan Template §15 Attachment 2"
                id="has-user-guide"
                role="error"
                test="oscal:resource[oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'type' and @value eq 'user-guide']]">[Section B
                Check 3.2] A FedRAMP SSP must have a User Guide attached.</sch:assert>
            <sch:assert
                diagnostics="has-rules-of-behavior-diagnostic"
                doc:checklist-reference="Section B Check 3.5"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6"
                doc:template-reference="System Security Plan Template §15 Attachment 5"
                id="has-rules-of-behavior"
                role="error"
                test="oscal:resource[oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'type' and @value eq 'rules-of-behavior']]">
                [Section B Check 3.5] A FedRAMP SSP must have Rules of Behavior.</sch:assert>
            <sch:assert
                diagnostics="has-information-system-contingency-plan-diagnostic"
                doc:checklist-reference="Section B Check 3.6"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6"
                doc:template-reference="System Security Plan Template §15 Attachment 6"
                id="has-information-system-contingency-plan"
                role="error"
                test="oscal:resource[oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'type' and @value eq 'information-system-contingency-plan']]">
                [Section B Check 3.6] A FedRAMP SSP must have a Contingency Plan attached.</sch:assert>
            <sch:assert
                diagnostics="has-configuration-management-plan-diagnostic"
                doc:checklist-reference="Section B Check 3.7"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6"
                doc:template-reference="System Security Plan Template §15 Attachment 7"
                id="has-configuration-management-plan"
                role="error"
                test="oscal:resource[oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'type' and @value eq 'configuration-management-plan']]">
                [Section B Check 3.7] A FedRAMP SSP must have a Configuration Management Plan attached.</sch:assert>
            <sch:assert
                diagnostics="has-incident-response-plan-diagnostic"
                doc:checklist-reference="Section B Check 3.8"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6"
                doc:template-reference="System Security Plan Template §15 Attachment 8"
                id="has-incident-response-plan"
                role="error"
                test="oscal:resource[oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'type' and @value eq 'incident-response-plan']]">
                [Section B Check 3.8] A FedRAMP SSP must have an Incident Response Plan attached.</sch:assert>
            <!-- Section B Check 3.9 is not used -->
            <!-- Section B Check 3.10 is not used -->
            <sch:assert
                diagnostics="has-separation-of-duties-matrix-diagnostic"
                doc:checklist-reference="Section B Check 3.11"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6"
                doc:template-reference="System Security Plan Template §15 Attachment 11"
                id="has-separation-of-duties-matrix"
                role="error"
                test="oscal:resource[oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'type' and @value eq 'separation-of-duties-matrix']]">
                [Section B Check 3.11] A FedRAMP SSP must have a Separation of Duties Matrix attached.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6"
        doc:template-reference="System Security Plan Template §15"
        id="policy-and-procedure">
        <sch:title>Policy and Procedure attachments</sch:title>
        <sch:title>A FedRAMP SSP must incorporate one policy document and one procedure document for each of the 17 NIST SP 800-54 Revision 4 control
            families</sch:title>
        <!-- TODO: handle attachments declared by component (see implemented-requirement ac-1 for an example) -->
        <!-- FIXME: XSpec testing malfunctions when the following rule context is constrained to XX-1 control-ids -->
        <sch:rule
            context="oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')]"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6"
            doc:template-reference="System Security Plan Template §15 Attachment 1"
            see="Guide to OSCAL-based FedRAMP System Security Plans §6">
            <sch:assert
                diagnostics="has-policy-link-diagnostic"
                doc:checklist-reference="Section B Check 3.1"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6"
                doc:template-reference="System Security Plan Template §15 Attachment 1"
                id="has-policy-link"
                role="error"
                test="descendant::oscal:by-component/oscal:link[@rel eq 'policy']">[Section B Check 3.1] A FedRAMP SSP must incorporate a policy
                document for each of the 17 NIST SP 800-54 Revision 4 control families.</sch:assert>
            <sch:let
                name="policy-hrefs"
                value="distinct-values(descendant::oscal:by-component/oscal:link[@rel eq 'policy']/@href ! substring-after(., '#'))" />
            <sch:assert
                diagnostics="has-policy-attachment-resource-diagnostic"
                doc:checklist-reference="Section B Check 3.1"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6"
                doc:template-reference="System Security Plan Template §15 Attachment 1"
                id="has-policy-attachment-resource"
                role="error"
                test="
                    every $ref in $policy-hrefs
                        satisfies exists(//oscal:resource[oscal:prop[@name eq 'type' and @value eq 'policy']][@uuid eq $ref])">[Section
                B Check 3.1] A FedRAMP SSP must incorporate a policy document for each of the 17 NIST SP 800-54 Revision 4 control
                families.</sch:assert>
            <!-- TODO: ensure resource has an rlink -->
            <sch:assert
                diagnostics="has-procedure-link-diagnostic"
                doc:checklist-reference="Section B Check 3.1"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6"
                doc:template-reference="System Security Plan Template §15"
                id="has-procedure-link"
                role="error"
                test="descendant::oscal:by-component/oscal:link[@rel eq 'procedure']">[Section B Check 3.1] A FedRAMP SSP must incorporate a procedure
                document for each of the 17 NIST SP 800-54 Revision 4 control families.</sch:assert>
            <sch:let
                name="procedure-hrefs"
                value="distinct-values(descendant::oscal:by-component/oscal:link[@rel eq 'procedure']/@href ! substring-after(., '#'))" />
            <sch:assert
                diagnostics="has-procedure-attachment-resource-diagnostic"
                doc:checklist-reference="Section B Check 3.1"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6"
                doc:template-reference="System Security Plan Template §15 Attachment 1"
                id="has-procedure-attachment-resource"
                role="error"
                test="
                    (: targets of links exist in the document :)
                    every $ref in $procedure-hrefs
                        satisfies exists(//oscal:resource[oscal:prop[@name eq 'type' and @value eq 'procedure']][@uuid eq $ref])">[Section
                B Check 3.1] A FedRAMP SSP must incorporate a procedure document for each of the 17 NIST SP 800-54 Revision 4 control
                families.</sch:assert>
            <!-- TODO: ensure resource has an rlink -->
        </sch:rule>
        <sch:rule
            context="oscal:by-component/oscal:link[@rel = ('policy', 'procedure')]"
            doc:checklist-reference="Section B Check 3.1"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6"
            doc:template-reference="System Security Plan Template §15 Attachment 1">
            <sch:let
                name="ir"
                value="ancestor::oscal:implemented-requirement" />
            <sch:assert
                diagnostics="has-unique-policy-and-procedure-diagnostic"
                doc:checklist-reference="Section B Check 3.1"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6"
                doc:template-reference="System Security Plan Template §15 Attachment 1"
                id="has-unique-policy-and-procedure"
                role="error"
                test="
                    not(
                    (: the current @href is not in :)
                    @href =
                    (: all controls except the current :) (//oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')] except $ir)
                    (: all their @hrefs :)/descendant::oscal:by-component/oscal:link[@rel eq 'policy']/@href
                    )"> [Section B Check 3.1] Policy and procedure documents must have unique per-control-family
                associations.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        id="privacy1">
        <sch:title>A FedRAMP OSCAL SSP must specify a Privacy Point of Contact</sch:title>
        <sch:rule
            context="oscal:metadata"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.2"
            see="Guide to OSCAL-based FedRAMP System Security Plans §6.2">
            <sch:assert
                diagnostics="has-privacy-poc-role-diagnostic"
                doc:checklist-reference="Section B Check 3.4"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.2"
                doc:template-reference="System Security Plan Template §15 Attachment 4"
                id="has-privacy-poc-role"
                role="error"
                test="/oscal:system-security-plan/oscal:metadata/oscal:role[@id eq 'privacy-poc']">[Section B Check 3.4] A FedRAMP SSP must
                incorporate a Privacy Point of Contact role.</sch:assert>
            <sch:assert
                diagnostics="has-responsible-party-privacy-poc-role-diagnostic"
                doc:checklist-reference="Section B Check 3.4"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.2"
                doc:template-reference="System Security Plan Template §15 Attachment 4"
                id="has-responsible-party-privacy-poc-role"
                role="error"
                test="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id eq 'privacy-poc']">[Section B Check 3.4] A FedRAMP
                OSCAL SSP must declare a Privacy Point of Contact responsible party role reference.</sch:assert>
            <sch:assert
                diagnostics="has-responsible-privacy-poc-party-uuid-diagnostic"
                doc:checklist-reference="Section B Check 3.4"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.2"
                doc:template-reference="System Security Plan Template §15 Attachment 4"
                id="has-responsible-privacy-poc-party-uuid"
                role="error"
                test="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id eq 'privacy-poc']/oscal:party-uuid">[Section B Check
                3.4] A FedRAMP SSP must declare a Privacy Point of Contact responsible party role reference identifying the party by unique
                identifier.</sch:assert>
            <sch:let
                name="poc-uuid"
                value="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id eq 'privacy-poc']/oscal:party-uuid" />
            <sch:assert
                diagnostics="has-privacy-poc-diagnostic"
                doc:checklist-reference="Section B Check 3.4"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.2"
                doc:template-reference="System Security Plan Template §15 Attachment 4"
                id="has-privacy-poc"
                role="error"
                test="/oscal:system-security-plan/oscal:metadata/oscal:party[@uuid eq $poc-uuid]">[Section B Check 3.4] A FedRAMP SSP must define a
                Privacy Point of Contact.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        id="privacy2">
        <sch:title>A FedRAMP OSCAL SSP may need to incorporate a PIA and possibly a SORN</sch:title>
        <!-- The "PTA" appears to be just a few questions, not an attachment -->
        <sch:rule
            context="oscal:prop[@name eq 'privacy-sensitive'] | oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @class eq 'pta' and matches(@name, '^pta-\d$')]"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.4"
            see="Guide to OSCAL-based FedRAMP System Security Plans §6.4">
            <sch:assert
                diagnostics="has-correct-yes-or-no-answer-diagnostic"
                doc:checklist-reference="Section B Check 3.4"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                doc:template-reference="System Security Plan Template §15 Attachment 4"
                id="has-correct-yes-or-no-answer"
                role="error"
                test="current()/@value = ('yes', 'no')">[Section B Check 3.4] A Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA)
                qualifying question must have an allowed answer.</sch:assert>
        </sch:rule>
        <sch:rule
            context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.4"
            see="Guide to OSCAL-based FedRAMP System Security Plans §6.4">
            <sch:assert
                diagnostics="has-privacy-sensitive-designation-diagnostic"
                doc:checklist-reference="Section B Check 3.4"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                doc:template-reference="System Security Plan Template §15 Attachment 4"
                id="has-privacy-sensitive-designation"
                role="error"
                test="oscal:prop[@name eq 'privacy-sensitive']">[Section B Check 3.4] A FedRAMP SSP must have a privacy-sensitive
                designation.</sch:assert>
            <sch:assert
                diagnostics="has-pta-question-1-diagnostic"
                doc:checklist-reference="Section B Check 3.4"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                doc:template-reference="System Security Plan Template §15 Attachment 4"
                id="has-pta-question-1"
                role="error"
                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @class eq 'pta' and @name eq 'pta-1']">[Section B Check 3.4] A FedRAMP
                OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #1.</sch:assert>
            <sch:assert
                diagnostics="has-pta-question-2-diagnostic"
                doc:checklist-reference="Section B Check 3.4"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                doc:template-reference="System Security Plan Template §15 Attachment 4"
                id="has-pta-question-2"
                role="error"
                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @class eq 'pta' and @name eq 'pta-2']">[Section B Check 3.4] A FedRAMP
                OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #2.</sch:assert>
            <sch:assert
                diagnostics="has-pta-question-3-diagnostic"
                doc:checklist-reference="Section B Check 3.4"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                doc:template-reference="System Security Plan Template §15 Attachment 4"
                id="has-pta-question-3"
                role="error"
                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @class eq 'pta' and @name eq 'pta-3']">[Section B Check 3.4] A FedRAMP
                OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #3.</sch:assert>
            <sch:assert
                diagnostics="has-pta-question-4-diagnostic"
                doc:checklist-reference="Section B Check 3.4"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                doc:template-reference="System Security Plan Template §15 Attachment 4"
                id="has-pta-question-4"
                role="error"
                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @class eq 'pta' and @name eq 'pta-4']">[Section B Check 3.4] A FedRAMP
                OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #4.</sch:assert>
            <sch:assert
                diagnostics="has-all-pta-questions-diagnostic"
                doc:checklist-reference="Section B Check 3.4"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                doc:template-reference="System Security Plan Template §15 Attachment 4"
                id="has-all-pta-questions"
                role="error"
                test="
                    every $name in ('pta-1', 'pta-2', 'pta-3', 'pta-4')
                        satisfies exists(oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @class eq 'pta' and @name eq $name])">[Section
                B Check 3.4] A FedRAMP SSP must have all four PTA questions.</sch:assert>
            <sch:assert
                diagnostics="has-correct-pta-question-cardinality-diagnostic"
                doc:checklist-reference="Section B Check 3.4"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                doc:template-reference="System Security Plan Template §15 Attachment 4"
                id="has-correct-pta-question-cardinality"
                role="error"
                test="
                    not(some $name in ('pta-1', 'pta-2', 'pta-3', 'pta-4')
                        satisfies exists(oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @class eq 'pta' and @name eq $name][2]))">[Section
                B Check 3.4] A FedRAMP SSP must have no duplicate PTA questions.</sch:assert>
            <sch:assert
                diagnostics="has-sorn-diagnostic"
                doc:checklist-reference="Section B Check 3.4"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                doc:template-reference="System Security Plan Template §15 Attachment 4"
                id="has-sorn"
                role="error"
                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @class eq 'pta' and @name eq 'pta-4' and @value eq 'yes'] and oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @class eq 'pta' and @name eq 'sorn-id' (: and @value ne '':)]">
                [Section B Check 3.4] A FedRAMP SSP may have a SORN ID.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:back-matter"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.4"
            see="Guide to OSCAL-based FedRAMP System Security Plans §6.4">
            <sch:assert
                diagnostics="has-pia-diagnostic"
                doc:checklist-reference="Section B Check 3.4"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                doc:template-reference="System Security Plan Template §15 Attachment 4"
                id="has-pia"
                role="error"
                test="
                    every $answer in //oscal:system-information/oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @class eq 'pta' and matches(@name, '^pta-\d$')]
                        satisfies $answer eq 'no' or oscal:resource[oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'type' and @value eq 'pia']] (: a PIA is attached :)">
                [Section B Check 3.4] This FedRAMP SSP must incorporate a Privacy Impact Analysis.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
        id="fips-140"
        see="Guide to OSCAL-based FedRAMP System Security Plans Appendix A">
        <!-- FIXME: Guide is wildly different than template -->
        <sch:title>FIPS 140 Validation</sch:title>
        <sch:rule
            context="oscal:system-implementation"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans Appendix A">
            <sch:assert
                diagnostics="has-CMVP-validation-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
                id="has-CMVP-validation"
                role="error"
                test="oscal:component[@type eq 'validation']">A FedRAMP SSP must incorporate one or more FIPS 140 validated modules.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:component[@type eq 'validation']"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans Appendix A">
            <sch:assert
                diagnostics="has-CMVP-validation-reference-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
                id="has-CMVP-validation-reference"
                role="error"
                test="oscal:prop[@name eq 'validation-reference']">Every FIPS 140 validation citation must have a validation reference.</sch:assert>
            <sch:assert
                diagnostics="has-CMVP-validation-details-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
                id="has-CMVP-validation-details"
                role="error"
                test="oscal:link[@rel eq 'validation-details']">Every FIPS 140 validation citation must have validation details.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:prop[@name eq 'validation-reference']"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans Appendix A">
            <sch:assert
                diagnostics="has-credible-CMVP-validation-reference-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
                id="has-credible-CMVP-validation-reference"
                role="error"
                test="matches(@value, '^\d{3,4}$')">A validation reference must provide a NIST Cryptographic Module Validation Program (CMVP)
                certificate number.</sch:assert>
            <sch:assert
                diagnostics="has-consonant-CMVP-validation-reference-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
                id="has-consonant-CMVP-validation-reference"
                role="error"
                test="@value = tokenize(following-sibling::oscal:link[@rel eq 'validation-details']/@href, '/')[last()]">A validation reference must
                be in accord with its sibling validation details.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:link[@rel eq 'validation-details']"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans Appendix A">
            <sch:assert
                diagnostics="has-credible-CMVP-validation-details-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
                id="has-credible-CMVP-validation-details"
                role="error"
                test="matches(@href, '^https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/\d{3,4}$')">A validation
                details must refer to a NIST Cryptographic Module Validation Program (CMVP) certificate detail page.</sch:assert>
            <sch:assert
                diagnostics="has-consonant-CMVP-validation-details-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
                id="has-consonant-CMVP-validation-details"
                role="error"
                test="tokenize(@href, '/')[last()] = preceding-sibling::oscal:prop[@name eq 'validation-reference']/@value">A validation details link
                must be in accord with its sibling validation reference.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        doc:checklist-reference="Section B Check 3.10"
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.4"
        doc:template-reference="System Security Plan Template §2"
        id="fips-199"
        see="Guide to OSCAL-based FedRAMP System Security Plans §4.4">
        <sch:title>Security Objectives Categorization (FIPS 199)</sch:title>
        <sch:rule
            context="oscal:system-characteristics"
            doc:checklist-reference="Section B Check 3.10"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.4"
            doc:template-reference="System Security Plan Template §2">
            <!-- These should also be asserted in XML Schema -->
            <sch:assert
                diagnostics="has-security-sensitivity-level-diagnostic"
                doc:checklist-reference="Section B Check 3.10"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                doc:template-reference="System Security Plan Template §2"
                id="has-security-sensitivity-level"
                role="error"
                test="oscal:security-sensitivity-level">[Section B Check 3.10] A FedRAMP SSP must specify a FIPS 199 categorization.</sch:assert>
            <sch:assert
                diagnostics="has-security-impact-level-diagnostic"
                doc:checklist-reference="Section B Check 3.10"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                id="has-security-impact-level"
                role="error"
                test="oscal:security-impact-level">[Section B Check 3.10] A FedRAMP SSP must specify a security impact level.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:security-sensitivity-level"
            doc:checklist-reference="Section B Check 3.10"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.4"
            doc:template-reference="System Security Plan Template §2">
            <sch:let
                name="security-sensitivity-levels"
                value="$fedramp-values//fedramp:value-set[@name eq 'security-level']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-security-sensitivity-level-diagnostic"
                doc:checklist-reference="Section B Check 3.10"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                doc:template-reference="System Security Plan Template §2"
                id="has-allowed-security-sensitivity-level"
                role="error"
                test="current() = $security-sensitivity-levels">[Section B Check 3.10] A FedRAMP SSP must specify an allowed security sensitivity
                level.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:security-impact-level"
            doc:checklist-reference="Section B Check 3.10"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.4"
            doc:template-reference="System Security Plan Template §2.2">
            <!-- These should also be asserted in XML Schema -->
            <sch:assert
                diagnostics="has-security-objective-confidentiality-diagnostic"
                doc:checklist-reference="Section B Check 3.10"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                doc:template-reference="System Security Plan Template §2.2"
                id="has-security-objective-confidentiality"
                role="error"
                test="oscal:security-objective-confidentiality">[Section B Check 3.10] A FedRAMP SSP must specify a confidentiality security
                objective.</sch:assert>
            <sch:assert
                diagnostics="has-security-objective-integrity-diagnostic"
                doc:checklist-reference="Section B Check 3.10"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                doc:template-reference="System Security Plan Template §2.2"
                id="has-security-objective-integrity"
                role="error"
                test="oscal:security-objective-integrity">[Section B Check 3.10] A FedRAMP SSP must specify an integrity security
                objective.</sch:assert>
            <sch:assert
                diagnostics="has-security-objective-availability-diagnostic"
                doc:checklist-reference="Section B Check 3.10"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                doc:template-reference="System Security Plan Template §2.2"
                id="has-security-objective-availability"
                role="error"
                test="oscal:security-objective-availability">[Section B Check 3.10] A FedRAMP SSP must specify an availability security
                objective.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:security-objective-confidentiality | oscal:security-objective-integrity | oscal:security-objective-availability"
            doc:checklist-reference="Section B Check 3.10"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.4"
            doc:template-reference="System Security Plan Template §2.2">
            <sch:let
                name="security-objective-levels"
                value="$fedramp-values//fedramp:value-set[@name eq 'security-level']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-security-objective-value-diagnostic"
                doc:checklist-reference="Section B Check 3.10"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                doc:template-reference="System Security Plan Template §2.2"
                id="has-allowed-security-objective-value"
                role="error"
                test="current() = $security-objective-levels">[Section B Check 3.10] A FedRAMP SSP must specify an allowed security objective
                value.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
        doc:template-reference="System Security Plan Template §2.1"
        id="sp800-60"
        see="Guide to OSCAL-based FedRAMP System Security Plans §4.3">
        <sch:title>SP 800-60v2r1 Information Types:</sch:title>
        <sch:rule
            context="oscal:system-information"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
            doc:template-reference="System Security Plan Template §2.1">
            <sch:assert
                diagnostics="system-information-has-information-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                doc:template-reference="System Security Plan Template §2"
                id="system-information-has-information-type"
                role="error"
                test="oscal:information-type">A FedRAMP SSP must specify at least one information type.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:information-type"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
            doc:template-reference="System Security Plan Template §2.1">
            <sch:assert
                diagnostics="information-type-has-title-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                doc:template-reference="System Security Plan Template §2.1"
                id="information-type-has-title"
                role="error"
                test="oscal:title">A FedRAMP SSP information type must have a title.</sch:assert>
            <sch:assert
                diagnostics="information-type-has-description-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                doc:template-reference="System Security Plan Template §2.1"
                id="information-type-has-description"
                role="error"
                test="oscal:description">A FedRAMP SSP information type must have a description.</sch:assert>
            <sch:assert
                diagnostics="information-type-has-categorization-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                doc:template-reference="System Security Plan Template §2.1"
                id="information-type-has-categorization"
                role="error"
                test="oscal:categorization">A FedRAMP SSP information type must have at least one categorization.</sch:assert>
            <sch:assert
                diagnostics="information-type-has-confidentiality-impact-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                doc:template-reference="System Security Plan Template §2.1"
                id="information-type-has-confidentiality-impact"
                role="error"
                test="oscal:confidentiality-impact">A FedRAMP SSP information type must have a confidentiality impact.</sch:assert>
            <sch:assert
                diagnostics="information-type-has-integrity-impact-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                doc:template-reference="System Security Plan Template §2.1"
                id="information-type-has-integrity-impact"
                role="error"
                test="oscal:integrity-impact">A FedRAMP SSP information type must have an integrity impact.</sch:assert>
            <sch:assert
                diagnostics="information-type-has-availability-impact-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                doc:template-reference="System Security Plan Template §2.1"
                id="information-type-has-availability-impact"
                role="error"
                test="oscal:availability-impact">A FedRAMP SSP information type must have an availability impact.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:categorization"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
            doc:template-reference="System Security Plan Template §2.1">
            <sch:assert
                diagnostics="categorization-has-system-attribute-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                doc:template-reference="System Security Plan Template §2.1"
                id="categorization-has-system-attribute"
                role="error"
                test="@system">A FedRAMP SSP information type categorization must have a system attribute.</sch:assert>
            <sch:assert
                diagnostics="categorization-has-correct-system-attribute-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                doc:template-reference="System Security Plan Template §2.1"
                id="categorization-has-correct-system-attribute"
                role="error"
                test="@system eq 'https://doi.org/10.6028/NIST.SP.800-60v2r1'">A FedRAMP SSP information type categorization must have a correct
                system attribute.</sch:assert>
            <sch:assert
                diagnostics="categorization-has-information-type-id-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                doc:template-reference="System Security Plan Template §2.1"
                id="categorization-has-information-type-id"
                role="error"
                test="oscal:information-type-id">A FedRAMP SSP information type categorization must have at least one information type
                identifier.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:information-type-id"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
            doc:template-reference="System Security Plan Template §2.1">
            <sch:let
                name="information-types"
                value="doc(concat($registry-base-path, '/information-types.xml'))//fedramp:information-type/@id" />
            <!-- note the variant namespace and associated prefix -->
            <sch:assert
                diagnostics="has-allowed-information-type-id-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                doc:template-reference="System Security Plan Template §2.1"
                id="has-allowed-information-type-id"
                role="error"
                see="https://doi.org/10.6028/NIST.SP.800-60v2r1"
                test="current()[. = $information-types]">A FedRAMP SSP information type identifier must be chosen from those found in NIST SP
                800-60v2r1.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:confidentiality-impact | oscal:integrity-impact | oscal:availability-impact"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
            doc:template-reference="System Security Plan Template §2.1">
            <sch:assert
                diagnostics="cia-impact-has-base-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                doc:template-reference="System Security Plan Template §2.1"
                id="cia-impact-has-base"
                role="error"
                test="oscal:base">A FedRAMP SSP information type confidentiality, integrity, or availability impact must specify the base
                impact.</sch:assert>
            <sch:assert
                diagnostics="cia-impact-has-selected-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                doc:template-reference="System Security Plan Template §2.1"
                id="cia-impact-has-selected"
                role="error"
                test="oscal:selected">A FedRAMP SSP information type confidentiality, integrity, or availability impact must the selected
                impact.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:base | oscal:selected"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
            doc:template-reference="System Security Plan Template §2.1">
            <sch:let
                name="fips-199-levels"
                value="$fedramp-values//fedramp:value-set[@name eq 'security-level']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="cia-impact-has-approved-fips-categorization-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                doc:template-reference="System Security Plan Template §2.1"
                id="cia-impact-has-approved-fips-categorization"
                role="error"
                test=". = $fips-199-levels">A FedRAMP SSP must indicate for its information system the appropriate categorization for the respective
                confidentiality, integrity, impact levels of its information types (per FIPS-199).</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        doc:checklist-reference="Section B Check 3.3, Section C Check 7"
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.5"
        doc:template-reference="System Security Plan Template §2.3"
        id="sp800-63"
        see="Guide to OSCAL-based FedRAMP System Security Plans §4.5">
        <sch:title>Digital Identity Determination</sch:title>
        <sch:rule
            context="oscal:system-characteristics"
            doc:checklist-reference="Section C Check 7"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.5"
            doc:template-reference="System Security Plan Template §2.3">
            <sch:assert
                diagnostics="has-security-eauth-level-diagnostic"
                doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                doc:template-reference="System Security Plan Template §2.3"
                id="has-security-eauth-level"
                role="error"
                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @class eq 'security-eauth' and @name eq 'security-eauth-level']"> [Section
                B Check 3.3, Section C Check 7] A FedRAMP SSP must have a Digital Identity Determination property.</sch:assert>
            <sch:assert
                diagnostics="has-identity-assurance-level-diagnostic"
                doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                doc:template-reference="System Security Plan Template §2.3"
                id="has-identity-assurance-level"
                role="information"
                test="oscal:prop[@name eq 'identity-assurance-level']">[Section B Check 3.3, Section C Check 7] A FedRAMP SSP may have a Digital
                Identity Determination identity assurance level property.</sch:assert>
            <sch:assert
                diagnostics="has-authenticator-assurance-level-diagnostic"
                doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                doc:template-reference="System Security Plan Template §2.3"
                id="has-authenticator-assurance-level"
                role="information"
                test="oscal:prop[@name eq 'authenticator-assurance-level']">[Section B Check 3.3, Section C Check 7] A FedRAMP SSP may have a Digital
                Identity Determination authenticator assurance level property.</sch:assert>
            <sch:assert
                diagnostics="has-federation-assurance-level-diagnostic"
                doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                doc:template-reference="System Security Plan Template §2.3"
                id="has-federation-assurance-level"
                role="information"
                test="oscal:prop[@name eq 'federation-assurance-level']">[Section B Check 3.3, Section C Check 7] A FedRAMP SSP may have a Digital
                Identity Determination federation assurance level property.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @class eq 'security-eauth' and @name eq 'security-eauth-level']"
            doc:checklist-reference="Section B Check 3.3, Section C Check 7"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.5"
            doc:template-reference="System Security Plan Template §2.3"
            role="error">
            <sch:let
                name="eauth-levels"
                value="$fedramp-values//fedramp:value-set[@name eq 'eauth-level']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-security-eauth-level-diagnostic"
                doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                doc:template-reference="System Security Plan Template §2.3"
                id="has-allowed-security-eauth-level"
                role="error"
                test="@value = $eauth-levels">[Section B Check 3.3, Section C Check 7] A FedRAMP SSP must have a Digital Identity Determination
                property with an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:prop[@name eq 'identity-assurance-level']"
            doc:checklist-reference="Section B Check 3.3, Section C Check 7"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.5"
            doc:template-reference="System Security Plan Template §2.3">
            <sch:let
                name="identity-assurance-levels"
                value="$fedramp-values//fedramp:value-set[@name eq 'identity-assurance-level']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-identity-assurance-level-diagnostic"
                doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                doc:template-reference="System Security Plan Template §2.3"
                id="has-allowed-identity-assurance-level"
                role="error"
                test="@value = $identity-assurance-levels">[Section B Check 3.3, Section C Check 7] A FedRAMP SSP should have an allowed Digital
                Identity Determination identity assurance level.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:prop[@name eq 'authenticator-assurance-level']"
            doc:checklist-reference="Section B Check 3.3, Section C Check 7"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.5"
            doc:template-reference="System Security Plan Template §2.3">
            <sch:let
                name="authenticator-assurance-levels"
                value="$fedramp-values//fedramp:value-set[@name eq 'authenticator-assurance-level']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-authenticator-assurance-level-diagnostic"
                doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                doc:template-reference="System Security Plan Template §2.3"
                id="has-allowed-authenticator-assurance-level"
                role="error"
                test="@value = $authenticator-assurance-levels">[Section B Check 3.3, Section C Check 7] A FedRAMP SSP should have an allowed Digital
                Identity Determination authenticator assurance level.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:prop[@name eq 'federation-assurance-level']"
            doc:checklist-reference="Section B Check 3.3, Section C Check 7"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.5"
            doc:template-reference="System Security Plan Template §2.3">
            <sch:let
                name="federation-assurance-levels"
                value="$fedramp-values//fedramp:value-set[@name eq 'federation-assurance-level']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-federation-assurance-level-diagnostic"
                doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                doc:template-reference="System Security Plan Template §2.3"
                id="has-allowed-federation-assurance-level"
                role="error"
                test="@value = $federation-assurance-levels">[Section B Check 3.3, Section C Check 7] A FedRAMP SSP should have an allowed Digital
                Identity Determination federation assurance level.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
        id="system-inventory"
        see="Guide to OSCAL-based FedRAMP System Security Plans §6.5">
        <sch:title>FedRAMP OSCAL System Inventory</sch:title>
        <sch:title>A FedRAMP OSCAL SSP must specify system inventory items</sch:title>
        <sch:rule
            context="/oscal:system-security-plan/oscal:system-implementation"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <!-- FIXME: determine if essential inventory items are present -->
            <doc:rule>A FedRAMP OSCAL SSP must incorporate inventory-item elements</doc:rule>
            <sch:assert
                diagnostics="has-inventory-items-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="has-inventory-items"
                role="error"
                test="oscal:inventory-item">A FedRAMP SSP must incorporate inventory items.</sch:assert>
        </sch:rule>
        <sch:title>FedRAMP SSP property constraints</sch:title>
        <sch:rule
            context="oscal:prop[@name eq 'asset-id']"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:assert
                diagnostics="has-unique-asset-id-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="has-unique-asset-id"
                role="error"
                test="count(//oscal:prop[@name eq 'asset-id'][@value eq current()/@value]) = 1">Every asset identifier must be unique.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:prop[@name eq 'asset-type']"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:let
                name="asset-types"
                value="$fedramp-values//fedramp:value-set[@name eq 'asset-type']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-asset-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="has-allowed-asset-type"
                role="warning"
                test="@value = $asset-types">An asset type must have an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:prop[@name eq 'virtual']"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:let
                name="virtuals"
                value="$fedramp-values//fedramp:value-set[@name eq 'virtual']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-virtual-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="has-allowed-virtual"
                role="error"
                test="@value = $virtuals">A virtual property must have an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:prop[@name eq 'public']"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:let
                name="publics"
                value="$fedramp-values//fedramp:value-set[@name eq 'public']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-public-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="has-allowed-public"
                role="error"
                test="@value = $publics">A public property must have an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:prop[@name eq 'allows-authenticated-scan']"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:let
                name="allows-authenticated-scans"
                value="$fedramp-values//fedramp:value-set[@name eq 'allows-authenticated-scan']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-allows-authenticated-scan-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="has-allowed-allows-authenticated-scan"
                role="error"
                test="@value = $allows-authenticated-scans">An allows-authenticated-scan property has an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:prop[@name eq 'is-scanned']"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:let
                name="is-scanneds"
                value="$fedramp-values//fedramp:value-set[@name eq 'is-scanned']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-is-scanned-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="has-allowed-is-scanned"
                role="error"
                test="@value = $is-scanneds">is-scanned property must have an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'scan-type']"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:let
                name="scan-types"
                value="$fedramp-values//fedramp:value-set[@name eq 'scan-type']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-scan-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="has-allowed-scan-type"
                role="error"
                test="@value = $scan-types">A scan-type property must have an allowed value.</sch:assert>
        </sch:rule>
        <sch:title>FedRAMP OSCAL SSP inventory components</sch:title>
        <sch:rule
            context="oscal:component"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:let
                name="component-types"
                value="$fedramp-values//fedramp:value-set[@name eq 'component-type']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="component-has-allowed-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="component-has-allowed-type"
                role="error"
                test="@type = $component-types">A component must have an allowed type.</sch:assert>
            <sch:assert
                diagnostics="component-has-asset-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="component-has-asset-type"
                role="error"
                test="
                    (: not(@uuid = //oscal:inventory-item/oscal:implemented-component/@component-uuid) or :)
                    oscal:prop[@name eq 'asset-type']">A component must have an asset type.</sch:assert>
            <sch:assert
                diagnostics="component-has-one-asset-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="component-has-one-asset-type"
                role="error"
                test="not(oscal:prop[@name eq 'asset-type'][2])">A component must have only one asset type.</sch:assert>
        </sch:rule>
        <sch:title>FedRAMP OSCAL SSP inventory items</sch:title>
        <sch:rule
            context="oscal:inventory-item"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
            see="Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:assert
                diagnostics="inventory-item-has-uuid-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-uuid"
                role="error"
                test="@uuid">An inventory item has a unique identifier.</sch:assert>
            <sch:assert
                diagnostics="has-asset-id-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="has-asset-id"
                role="error"
                test="oscal:prop[@name eq 'asset-id']">An inventory item must have an asset identifier.</sch:assert>
            <sch:assert
                diagnostics="has-one-asset-id-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="has-one-asset-id"
                role="error"
                test="not(oscal:prop[@name eq 'asset-id'][2])">An inventory item must have only one asset identifier.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-asset-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-asset-type"
                role="error"
                test="oscal:prop[@name eq 'asset-type']">An inventory item must have an asset-type.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-one-asset-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-one-asset-type"
                role="error"
                test="not(oscal:prop[@name eq 'asset-type'][2])">An inventory item must have only one asset-type.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-virtual-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-virtual"
                role="error"
                test="oscal:prop[@name eq 'virtual']">An inventory item must have a virtual property.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-one-virtual-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-one-virtual"
                role="error"
                test="not(oscal:prop[@name eq 'virtual'][2])">An inventory item must have only one virtual property.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-public-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-public"
                role="error"
                test="oscal:prop[@name eq 'public']">An inventory item must have a public property.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-one-public-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-one-public"
                role="error"
                test="not(oscal:prop[@name eq 'public'][2])">An inventory item must have only one public property.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-scan-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-scan-type"
                role="error"
                test="oscal:prop[@name eq 'scan-type']">An inventory item must have a scan-type property.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-one-scan-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-one-scan-type"
                role="error"
                test="not(oscal:prop[@name eq 'scan-type'][2])">An inventory item has only one scan-type property.</sch:assert>
            <!-- restrict the following to "infrastructure" -->
            <sch:let
                name="is-infrastructure"
                value="exists(oscal:prop[@name eq 'asset-type' and @value = ('os', 'infrastructure')])" />
            <sch:assert
                diagnostics="inventory-item-has-allows-authenticated-scan-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-allows-authenticated-scan"
                role="error"
                test="not($is-infrastructure) or oscal:prop[@name eq 'allows-authenticated-scan']">"infrastructure" inventory item has
                allows-authenticated-scan.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-one-allows-authenticated-scan-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-one-allows-authenticated-scan"
                role="error"
                test="not($is-infrastructure) or not(oscal:prop[@name eq 'allows-authenticated-scan'][2])">An inventory item has
                one-allows-authenticated-scan property.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-baseline-configuration-name-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-baseline-configuration-name"
                role="error"
                test="not($is-infrastructure) or oscal:prop[@name eq 'baseline-configuration-name']">"infrastructure" inventory item has
                baseline-configuration-name.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-one-baseline-configuration-name-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-one-baseline-configuration-name"
                role="error"
                test="not($is-infrastructure) or not(oscal:prop[@name eq 'baseline-configuration-name'][2])">"infrastructure" inventory item has only
                one baseline-configuration-name.</sch:assert>
            <!-- FIXME: Documentation says vendor name is in FedRAMP @ns -->
            <sch:assert
                diagnostics="inventory-item-has-vendor-name-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-vendor-name"
                role="error"
                test="not($is-infrastructure) or oscal:prop[(: @ns eq 'https://fedramp.gov/ns/oscal' and :)@name eq 'vendor-name']"> "infrastructure"
                inventory item has a vendor-name property.</sch:assert>
            <!-- FIXME: Documentation says vendor name is in FedRAMP @ns -->
            <sch:assert
                diagnostics="inventory-item-has-one-vendor-name-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-one-vendor-name"
                role="error"
                test="not($is-infrastructure) or not(oscal:prop[(: @ns eq 'https://fedramp.gov/ns/oscal' and :)@name eq 'vendor-name'][2])">
                "infrastructure" inventory item must have only one vendor-name property.</sch:assert>
            <!-- FIXME: perversely, hardware-model is not in FedRAMP @ns -->
            <sch:assert
                diagnostics="inventory-item-has-hardware-model-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-hardware-model"
                role="error"
                test="not($is-infrastructure) or oscal:prop[(: @ns eq 'https://fedramp.gov/ns/oscal' and :)@name eq 'hardware-model']">
                "infrastructure" inventory item must have a hardware-model property.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-one-hardware-model-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-one-hardware-model"
                role="error"
                test="not($is-infrastructure) or not(oscal:prop[(: @ns eq 'https://fedramp.gov/ns/oscal' and :)@name eq 'hardware-model'][2])">
                "infrastructure" inventory item must have only one hardware-model property.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-is-scanned-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-is-scanned"
                role="error"
                test="not($is-infrastructure) or oscal:prop[@name eq 'is-scanned']">"infrastructure" inventory item must have is-scanned
                property.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-one-is-scanned-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-one-is-scanned"
                role="error"
                test="not($is-infrastructure) or not(oscal:prop[@name eq 'is-scanned'][2])">"infrastructure" inventory item must have only one
                is-scanned property.</sch:assert>
            <!-- FIXME: vague asset categories -->
            <!-- restrict the following to "software" -->
            <sch:let
                name="is-software-and-database"
                value="exists(oscal:prop[@name eq 'asset-type' and @value = ('software', 'database')])" />
            <sch:assert
                diagnostics="inventory-item-has-software-name-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-software-name"
                role="error"
                test="not($is-software-and-database) or oscal:prop[@name eq 'software-name']">"software or database" inventory item must have a
                software-name property.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-one-software-name-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-one-software-name"
                role="error"
                test="not($is-software-and-database) or not(oscal:prop[@name eq 'software-name'][2])">"software or database" inventory item must have
                a software-name property.</sch:assert>
            <!-- FIXME: vague asset categories -->
            <sch:assert
                diagnostics="inventory-item-has-software-version-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-software-version"
                role="error"
                test="not($is-software-and-database) or oscal:prop[@name eq 'software-version']">"software or database" inventory item must have a
                software-version property.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-one-software-version-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-one-software-version"
                role="error"
                test="not($is-software-and-database) or not(oscal:prop[@name eq 'software-version'][2])">"software or database" inventory item must
                have one software-version property.</sch:assert>
            <!-- FIXME: vague asset categories -->
            <sch:assert
                diagnostics="inventory-item-has-function-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-function"
                role="error"
                test="not($is-software-and-database) or oscal:prop[@name eq 'function']">"software or database" inventory item must have a function
                property.</sch:assert>
            <sch:assert
                diagnostics="inventory-item-has-one-function-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                doc:template-reference="System Security Plan Template §15 Attachment 13"
                id="inventory-item-has-one-function"
                role="error"
                test="not($is-software-and-database) or not(oscal:prop[@name eq 'function'][2])">"software or database" inventory item must have one
                function property.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        id="basic-system-characteristics">
        <sch:rule
            context="oscal:system-implementation"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.4.6"
            see="Guide to OSCAL-based FedRAMP System Security Plans §5.4.6">
            <sch:assert
                diagnostics="has-this-system-component-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.4.6"
                id="has-this-system-component"
                role="error"
                test="exists(oscal:component[@type eq 'this-system'])">A FedRAMP SSP must have a self-referential (i.e., to the SSP itself)
                component.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:system-characteristics">
            <sch:assert
                diagnostics="has-system-id-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.1"
                doc:template-reference="System Security Plan Template §1"
                id="has-system-id"
                role="error"
                see="Guide to OSCAL-based FedRAMP System Security Plans §4.1"
                test="oscal:system-id[@identifier-type eq 'https://fedramp.gov']">A FedRAMP SSP must have a FedRAMP system identifier.</sch:assert>
            <sch:assert
                diagnostics="has-system-name-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.1"
                doc:template-reference="System Security Plan Template §1"
                id="has-system-name"
                role="error"
                see="Guide to OSCAL-based FedRAMP System Security Plans §4.1"
                test="oscal:system-name">A FedRAMP SSP must have a system name.</sch:assert>
            <sch:assert
                diagnostics="has-system-name-short-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.1"
                doc:template-reference="System Security Plan Template §1"
                id="has-system-name-short"
                role="error"
                see="Guide to OSCAL-based FedRAMP System Security Plans §4.1"
                test="oscal:system-name-short">A FedRAMP SSP must have a short system name.</sch:assert>
            <sch:assert
                diagnostics="has-fedramp-authorization-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.2"
                id="has-fedramp-authorization-type"
                role="error"
                see="Guide to OSCAL-based FedRAMP System Security Plans §4.2"
                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'authorization-type' and @value = ('fedramp-jab', 'fedramp-agency', 'fedramp-li-saas')]">
                A FedRAMP SSP must have a FedRAMP authorization type.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        id="general-roles">
        <sch:title>Roles, Locations, Parties, Responsibilities</sch:title>
        <sch:rule
            context="oscal:metadata"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.11"
            see="Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.11">
            <sch:assert
                diagnostics="role-defined-system-owner-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.6"
                doc:template-reference="System Security Plan Template §3"
                id="role-defined-system-owner"
                role="error"
                test="oscal:role[@id eq 'system-owner']">The System Owner role must be defined.</sch:assert>
            <sch:assert
                diagnostics="role-defined-authorizing-official-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.7"
                doc:template-reference="System Security Plan Template §4"
                id="role-defined-authorizing-official"
                role="error"
                test="oscal:role[@id eq 'authorizing-official']">The Authorizing Official role must be defined.</sch:assert>
            <sch:assert
                diagnostics="role-defined-system-poc-management-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.8"
                doc:template-reference="System Security Plan Template §5"
                id="role-defined-system-poc-management"
                role="error"
                test="oscal:role[@id eq 'system-poc-management']">The System Management PoC role must be defined.</sch:assert>
            <sch:assert
                diagnostics="role-defined-system-poc-technical-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.9"
                doc:template-reference="System Security Plan Template §5"
                id="role-defined-system-poc-technical"
                role="error"
                test="oscal:role[@id eq 'system-poc-technical']">The System Technical PoC role must be defined.</sch:assert>
            <sch:assert
                diagnostics="role-defined-system-poc-other-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.9"
                doc:template-reference="System Security Plan Template §5"
                id="role-defined-system-poc-other"
                role="error"
                test="oscal:role[@id eq 'system-poc-other']">The System Other PoC role must be defined.</sch:assert>
            <sch:assert
                diagnostics="role-defined-information-system-security-officer-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.10"
                doc:template-reference="System Security Plan Template §6"
                id="role-defined-information-system-security-officer"
                role="error"
                test="oscal:role[@id eq 'information-system-security-officer']">The Information System Security Officer role must be
                defined.</sch:assert>
            <sch:assert
                diagnostics="role-defined-authorizing-official-poc-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.11"
                doc:template-reference="System Security Plan Template §6"
                id="role-defined-authorizing-official-poc"
                role="error"
                test="oscal:role[@id eq 'authorizing-official-poc']">The Authorizing Official PoC role must be defined.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:role"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.11">
            <sch:assert
                diagnostics="role-has-title-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.11"
                doc:template-reference="System Security Plan Template §9.3"
                id="role-has-title"
                role="error"
                test="oscal:title">A role must have a title.</sch:assert>
            <sch:assert
                diagnostics="role-has-responsible-party-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.11"
                doc:template-reference="System Security Plan Template §9.3"
                id="role-has-responsible-party"
                role="error"
                test="//oscal:responsible-party[@role-id eq current()/@id]">One or more responsible parties must be defined for each
                role.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:responsible-party"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.11">
            <sch:assert
                diagnostics="responsible-party-has-role-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.11"
                id="responsible-party-has-role"
                role="error"
                test="exists(//oscal:role[@id eq current()/@role-id])">The role for a responsible party must exist.</sch:assert>
            <sch:assert
                diagnostics="responsible-party-has-party-uuid-diagnostic"
                id="responsible-party-has-party-uuid"
                role="error"
                test="exists(oscal:party-uuid)">One or more parties must be identified for a responsibility.</sch:assert>
            <sch:assert
                diagnostics="responsible-party-has-definition-diagnostic"
                id="responsible-party-has-definition"
                role="error"
                test="
                    every $p in oscal:party-uuid
                        satisfies exists(//oscal:party[@uuid eq $p])">Every responsible party must be defined.</sch:assert>
            <sch:assert
                diagnostics="responsible-party-is-person-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.11"
                id="responsible-party-is-person"
                role="error"
                test="
                    if (
                    current()/@role-id = (
                    'system-owner',
                    'authorizing-official',
                    'system-poc-management',
                    'system-poc-technical',
                    'system-poc-other',
                    'information-system-security-officer',
                    'authorizing-official-poc'
                    )
                    )
                    then
                        every $p in oscal:party-uuid
                            satisfies
                            exists(//oscal:party[@uuid eq $p and @type eq 'person'])
                    else
                        true()
                    ">For some roles responsible parties must be persons.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:party[@type eq 'person']"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.11">
            <sch:assert
                diagnostics="party-has-responsibility-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.11"
                id="party-has-responsibility"
                role="warning"
                test="//oscal:responsible-party[oscal:party-uuid = current()/@uuid]">Each person should have a responsibility.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.2"
        id="implementation-roles"
        see="Guide to OSCAL-based FedRAMP System Security Plans §5.2">
        <sch:title>Roles related to implemented requirements</sch:title>
        <sch:rule
            context="oscal:implemented-requirement"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.2">
            <sch:assert
                diagnostics="implemented-requirement-has-responsible-role-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.2"
                id="implemented-requirement-has-responsible-role"
                role="error"
                test="oscal:responsible-role">Each implemented control must have one or more responsible-role definitions.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:responsible-role"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.2">
            <sch:assert
                diagnostics="responsible-role-has-role-definition-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.2"
                doc:template-reference="System Security Plan Template §13"
                id="responsible-role-has-role-definition"
                role="error"
                test="//oscal:role/@id = current()/@role-id">Each responsible-role must reference a role definition.</sch:assert>
            <sch:assert
                diagnostics="responsible-role-has-user-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.2"
                doc:template-reference="System Security Plan Template §13"
                id="responsible-role-has-user"
                role="error"
                test="//oscal:role-id = current()/@role-id">Each responsible-role must be referenced in a system-implementation user
                assembly.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        doc:template-reference="System Security Plan Template §9.3"
        id="user-properties">
        <sch:rule
            context="oscal:user"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
            doc:template-reference="System Security Plan Template §9.3">
            <sch:assert
                diagnostics="user-has-role-id-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                doc:template-reference="System Security Plan Template §9.3"
                id="user-has-role-id"
                role="error"
                test="oscal:role-id">Every user has a role identifier.</sch:assert>
            <sch:assert
                diagnostics="user-has-user-type-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                doc:template-reference="System Security Plan Template §9.3"
                id="user-has-user-type"
                role="error"
                test="oscal:prop[@name eq 'type']">Every user has a user type.</sch:assert>
            <sch:assert
                diagnostics="user-has-privilege-level-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                doc:template-reference="System Security Plan Template §9.3"
                id="user-has-privilege-level"
                role="error"
                test="oscal:prop[@name eq 'privilege-level']">Every user has a privilege-level.</sch:assert>
            <sch:assert
                diagnostics="user-has-sensitivity-level-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                doc:template-reference="System Security Plan Template §9.3"
                id="user-has-sensitivity-level"
                role="error"
                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal'][@name eq 'sensitivity']">Every user has a sensitivity level.</sch:assert>
            <sch:assert
                diagnostics="user-has-authorized-privilege-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                doc:template-reference="System Security Plan Template §9.3"
                id="user-has-authorized-privilege"
                role="error"
                test="oscal:authorized-privilege">Every user has one or more authorized privileges.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:user/oscal:role-id"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
            doc:template-reference="System Security Plan Template §9.3">
            <sch:assert
                diagnostics="role-id-has-role-definition-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                doc:template-reference="System Security Plan Template §9.3"
                id="role-id-has-role-definition"
                role="error"
                test="//oscal:role[@id eq current()]">Each identified role must reference a role definition.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:user/oscal:prop[@name eq 'type']"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
            doc:template-reference="System Security Plan Template §9.3">
            <sch:let
                name="user-types"
                value="$fedramp-values//fedramp:value-set[@name eq 'user-type']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="user-user-type-has-allowed-value-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                doc:template-reference="System Security Plan Template §9.3"
                id="user-user-type-has-allowed-value"
                role="error"
                test="current()/@value = $user-types">User type property has an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:user/oscal:prop[@name eq 'privilege-level']"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
            doc:template-reference="System Security Plan Template §9.3">
            <sch:let
                name="user-privilege-levels"
                value="$fedramp-values//fedramp:value-set[@name eq 'user-privilege']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="user-privilege-level-has-allowed-value-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                doc:template-reference="System Security Plan Template §9.3"
                id="user-privilege-level-has-allowed-value"
                role="error"
                test="current()/@value = $user-privilege-levels">User privilege level has an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:user/oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal'][@name eq 'sensitivity']"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
            doc:template-reference="System Security Plan Template §9.3">
            <sch:let
                name="user-sensitivity-levels"
                value="$fedramp-values//fedramp:value-set[@name eq 'user-sensitivity-level']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="user-sensitivity-level-has-allowed-value-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                doc:template-reference="System Security Plan Template §9.3"
                id="user-sensitivity-level-has-allowed-value"
                role="error"
                test="current()/@value = $user-sensitivity-levels">User sensitivity level has an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:user/oscal:authorized-privilege"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
            doc:template-reference="System Security Plan Template §9.3">
            <sch:assert
                diagnostics="authorized-privilege-has-title-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                doc:template-reference="System Security Plan Template §9.3"
                id="authorized-privilege-has-title"
                role="error"
                test="oscal:title">Every authorized privilege has a title.</sch:assert>
            <sch:assert
                diagnostics="authorized-privilege-has-function-performed-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                doc:template-reference="System Security Plan Template §9.3"
                id="authorized-privilege-has-function-performed"
                role="error"
                test="oscal:function-performed">Every authorized privilege is associated with one or more functions performed.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:authorized-privilege/oscal:title"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
            doc:template-reference="System Security Plan Template §9.3">
            <sch:assert
                diagnostics="authorized-privilege-has-non-empty-title-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                doc:template-reference="System Security Plan Template §9.3"
                id="authorized-privilege-has-non-empty-title"
                role="error"
                test="current() ne ''">Every authorized privilege title is not empty.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:authorized-privilege/oscal:function-performed"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
            doc:template-reference="System Security Plan Template §9.3">
            <sch:assert
                diagnostics="authorized-privilege-has-non-empty-function-performed-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                doc:template-reference="System Security Plan Template §9.3"
                id="authorized-privilege-has-non-empty-function-performed"
                role="error"
                test="current() ne ''">Every authorized privilege function performed has a definition.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
        doc:template-reference="System Security Plan Template §9.2"
        id="authorization-boundary"
        see="Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram">
        <sch:title>Authorization Boundary Diagram</sch:title>
        <sch:rule
            context="oscal:system-characteristics"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
            doc:template-reference="System Security Plan Template §9.2">
            <sch:assert
                diagnostics="has-authorization-boundary-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                doc:template-reference="System Security Plan Template §9.2"
                id="has-authorization-boundary"
                role="error"
                test="oscal:authorization-boundary">A FedRAMP SSP includes an authorization boundary.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:authorization-boundary"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
            doc:template-reference="System Security Plan Template §9.2">
            <sch:assert
                diagnostics="has-authorization-boundary-description-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                doc:template-reference="System Security Plan Template §9.2"
                id="has-authorization-boundary-description"
                role="error"
                test="oscal:description">A FedRAMP SSP has an authorization boundary description.</sch:assert>
            <sch:assert
                diagnostics="has-authorization-boundary-diagram-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                doc:template-reference="System Security Plan Template §9.2"
                id="has-authorization-boundary-diagram"
                role="error"
                test="oscal:diagram">A FedRAMP SSP has at least one authorization boundary diagram.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:authorization-boundary/oscal:diagram"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
            doc:template-reference="System Security Plan Template §9.2">
            <sch:assert
                diagnostics="has-authorization-boundary-diagram-uuid-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                doc:template-reference="System Security Plan Template §9.2"
                id="has-authorization-boundary-diagram-uuid"
                role="error"
                test="@uuid">Each FedRAMP SSP authorization boundary diagram has a unique identifier.</sch:assert>
            <sch:assert
                diagnostics="has-authorization-boundary-diagram-description-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                doc:template-reference="System Security Plan Template §9.2"
                id="has-authorization-boundary-diagram-description"
                role="error"
                test="oscal:description">Each FedRAMP SSP authorization boundary diagram has a description.</sch:assert>
            <sch:assert
                diagnostics="has-authorization-boundary-diagram-link-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                doc:template-reference="System Security Plan Template §9.2"
                id="has-authorization-boundary-diagram-link"
                role="error"
                test="oscal:link">Each FedRAMP SSP authorization boundary diagram has a link.</sch:assert>
            <sch:assert
                diagnostics="has-authorization-boundary-diagram-caption-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                doc:template-reference="System Security Plan Template §9.2"
                id="has-authorization-boundary-diagram-caption"
                role="error"
                test="oscal:caption">Each FedRAMP SSP authorization boundary diagram has a caption.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:authorization-boundary/oscal:diagram/oscal:link"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
            doc:template-reference="System Security Plan Template §9.2">
            <sch:assert
                diagnostics="has-authorization-boundary-diagram-link-rel-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                doc:template-reference="System Security Plan Template §9.2"
                id="has-authorization-boundary-diagram-link-rel"
                role="error"
                test="@rel">Each FedRAMP SSP authorization boundary diagram has a link rel attribute.</sch:assert>
            <sch:assert
                diagnostics="has-authorization-boundary-diagram-link-rel-allowed-value-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                doc:template-reference="System Security Plan Template §9.2"
                id="has-authorization-boundary-diagram-link-rel-allowed-value"
                role="error"
                test="@rel eq 'diagram'">Each FedRAMP SSP authorization boundary diagram has a link rel attribute with the value
                "diagram".</sch:assert>
            <sch:assert
                diagnostics="has-authorization-boundary-diagram-link-href-target-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                doc:template-reference="System Security Plan Template §9.2"
                id="has-authorization-boundary-diagram-link-href-target"
                role="error"
                test="exists(//oscal:resource[@uuid eq substring-after(current()/@href, '#')])">A FedRAMP SSP authorization boundary diagram link
                references a back-matter resource representing the diagram document.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
        doc:template-reference="System Security Plan Template §9.4"
        id="network-architecture"
        see="Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram">
        <sch:title>Network Architecture Diagram</sch:title>
        <sch:rule
            context="oscal:system-characteristics"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
            doc:template-reference="System Security Plan Template §9.4">
            <sch:assert
                diagnostics="has-network-architecture-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                doc:template-reference="System Security Plan Template §9.4"
                id="has-network-architecture"
                role="error"
                test="oscal:network-architecture">A FedRAMP SSP includes a network architecture diagram.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:network-architecture"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
            doc:template-reference="System Security Plan Template §9.4">
            <sch:assert
                diagnostics="has-network-architecture-description-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                doc:template-reference="System Security Plan Template §9.4"
                id="has-network-architecture-description"
                role="error"
                test="oscal:description">A FedRAMP SSP has a network architecture description.</sch:assert>
            <sch:assert
                diagnostics="has-network-architecture-diagram-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                doc:template-reference="System Security Plan Template §9.4"
                id="has-network-architecture-diagram"
                role="error"
                test="oscal:diagram">A FedRAMP SSP has at least one network architecture diagram.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:network-architecture/oscal:diagram"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
            doc:template-reference="System Security Plan Template §9.4">
            <sch:assert
                diagnostics="has-network-architecture-diagram-uuid-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                doc:template-reference="System Security Plan Template §9.4"
                id="has-network-architecture-diagram-uuid"
                role="error"
                test="@uuid">Each FedRAMP SSP network architecture diagram has a unique identifier.</sch:assert>
            <sch:assert
                diagnostics="has-network-architecture-diagram-description-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                doc:template-reference="System Security Plan Template §9.4"
                id="has-network-architecture-diagram-description"
                role="error"
                test="oscal:description">Each FedRAMP SSP network architecture diagram has a description.</sch:assert>
            <sch:assert
                diagnostics="has-network-architecture-diagram-link-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                doc:template-reference="System Security Plan Template §9.4"
                id="has-network-architecture-diagram-link"
                role="error"
                test="oscal:link">Each FedRAMP SSP network architecture diagram has a link.</sch:assert>
            <sch:assert
                diagnostics="has-network-architecture-diagram-caption-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                doc:template-reference="System Security Plan Template §9.4"
                id="has-network-architecture-diagram-caption"
                role="error"
                test="oscal:caption">Each FedRAMP SSP network architecture diagram has a caption.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:network-architecture/oscal:diagram/oscal:link"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
            doc:template-reference="System Security Plan Template §9.4">
            <sch:assert
                diagnostics="has-network-architecture-diagram-link-rel-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                doc:template-reference="System Security Plan Template §9.4"
                id="has-network-architecture-diagram-link-rel"
                role="error"
                test="@rel">Each FedRAMP SSP network architecture diagram has a link rel attribute.</sch:assert>
            <sch:assert
                diagnostics="has-network-architecture-diagram-link-rel-allowed-value-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                doc:template-reference="System Security Plan Template §9.4"
                id="has-network-architecture-diagram-link-rel-allowed-value"
                role="error"
                test="@rel eq 'diagram'">Each FedRAMP SSP network architecture diagram has a link rel attribute with the value "diagram".</sch:assert>
            <sch:assert
                diagnostics="has-network-architecture-diagram-link-href-target-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                doc:template-reference="System Security Plan Template §9.4"
                id="has-network-architecture-diagram-link-href-target"
                role="error"
                test="exists(//oscal:resource[@uuid eq substring-after(current()/@href, '#')])">A FedRAMP SSP network architecture diagram link
                references a back-matter resource representing the diagram document.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
        doc:template-reference="System Security Plan Template §10.1"
        id="data-flow"
        see="Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram">
        <sch:title>Data Flow Diagram</sch:title>
        <sch:rule
            context="oscal:system-characteristics"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
            doc:template-reference="System Security Plan Template §10.1">
            <sch:assert
                diagnostics="has-data-flow-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                doc:template-reference="System Security Plan Template §10.1"
                id="has-data-flow"
                role="error"
                test="oscal:data-flow">A FedRAMP SSP includes a data flow diagram.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:data-flow"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
            doc:template-reference="System Security Plan Template §10.1">
            <sch:assert
                diagnostics="has-data-flow-description-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                doc:template-reference="System Security Plan Template §10.1"
                id="has-data-flow-description"
                role="error"
                test="oscal:description">A FedRAMP SSP has a data flow description.</sch:assert>
            <sch:assert
                diagnostics="has-data-flow-diagram-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                doc:template-reference="System Security Plan Template §10.1"
                id="has-data-flow-diagram"
                role="error"
                test="oscal:diagram">A FedRAMP SSP has at least one data flow diagram.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:data-flow/oscal:diagram"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
            doc:template-reference="System Security Plan Template §10.1">
            <sch:assert
                diagnostics="has-data-flow-diagram-uuid-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                doc:template-reference="System Security Plan Template §10.1"
                id="has-data-flow-diagram-uuid"
                role="error"
                test="@uuid">Each FedRAMP SSP data flow diagram has a unique identifier.</sch:assert>
            <sch:assert
                diagnostics="has-data-flow-diagram-description-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                doc:template-reference="System Security Plan Template §10.1"
                id="has-data-flow-diagram-description"
                role="error"
                test="oscal:description">Each FedRAMP SSP data flow diagram has a description.</sch:assert>
            <sch:assert
                diagnostics="has-data-flow-diagram-link-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                doc:template-reference="System Security Plan Template §10.1"
                id="has-data-flow-diagram-link"
                role="error"
                test="oscal:link">Each FedRAMP SSP data flow diagram has a link.</sch:assert>
            <sch:assert
                diagnostics="has-data-flow-diagram-caption-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                doc:template-reference="System Security Plan Template §10.1"
                id="has-data-flow-diagram-caption"
                role="error"
                test="oscal:caption">Each FedRAMP SSP data flow diagram has a caption.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:data-flow/oscal:diagram/oscal:link"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
            doc:template-reference="System Security Plan Template §10.1">
            <sch:assert
                diagnostics="has-data-flow-diagram-link-rel-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                doc:template-reference="System Security Plan Template §10.1"
                id="has-data-flow-diagram-link-rel"
                role="error"
                test="@rel">Each FedRAMP SSP data flow diagram has a link rel attribute.</sch:assert>
            <sch:assert
                diagnostics="has-data-flow-diagram-link-rel-allowed-value-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                doc:template-reference="System Security Plan Template §10.1"
                id="has-data-flow-diagram-link-rel-allowed-value"
                role="error"
                test="@rel eq 'diagram'">Each FedRAMP SSP data flow diagram has a link rel attribute with the value "diagram".</sch:assert>
            <sch:assert
                diagnostics="has-data-flow-diagram-link-href-target-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                doc:template-reference="System Security Plan Template §10.1"
                id="has-data-flow-diagram-link-href-target"
                role="error"
                test="exists(//oscal:resource[@uuid eq substring-after(current()/@href, '#')])">A FedRAMP SSP data flow diagram link references a
                back-matter resource representing the diagram document.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        doc:template-reference="System Security Plan Template §13"
        id="control-implementation">
        <sch:rule
            context="oscal:system-security-plan"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.1"
            doc:template-reference="System Security Plan Template §13"
            see="Guide to OSCAL-based FedRAMP System Security Plans §5.1">
            <sch:assert
                diagnostics="system-security-plan-has-import-profile-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.1"
                doc:template-reference="System Security Plan Template §13"
                id="system-security-plan-has-import-profile"
                role="error"
                test="exists(oscal:import-profile)">A FedRAMP SSP declares the related FedRAMP OSCAL Profile using an import-profile
                element.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:import-profile"
            doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.1"
            doc:template-reference="System Security Plan Template §13"
            see="Guide to OSCAL-based FedRAMP System Security Plans §5.1">
            <sch:assert
                diagnostics="import-profile-has-href-attribute-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.1"
                doc:template-reference="System Security Plan Template §13"
                id="import-profile-has-href-attribute"
                role="error"
                test="@href">The import-profile element has a reference.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:implemented-requirement"
            doc:template-reference="System Security Plan Template §13">
            <sch:assert
                diagnostics="implemented-requirement-has-implementation-status-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                doc:template-reference="System Security Plan Template §13"
                id="implemented-requirement-has-implementation-status"
                role="error"
                see="Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                test="exists(oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'implementation-status'])">Every implemented requirement
                has an implementation-status property.</sch:assert>
            <sch:assert
                diagnostics="implemented-requirement-has-planned-completion-date-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                doc:template-reference="System Security Plan Template §13"
                id="implemented-requirement-has-planned-completion-date"
                role="error"
                see="Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                test="
                    if (oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'implementation-status' and @value eq 'planned']) then
                        exists(current()/oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'planned-completion-date'])
                    else
                        true()">Planned control implementations have a planned completion date.</sch:assert>
            <sch:assert
                diagnostics="implemented-requirement-has-control-origination-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.3.1.1"
                doc:template-reference="System Security Plan Template §13"
                id="implemented-requirement-has-control-origination"
                role="error"
                see="Guide to OSCAL-based FedRAMP System Security Plans §5.3.1.1"
                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'control-origination']">Every implemented requirement has a
                control origin.</sch:assert>
            <sch:let
                name="control-originations"
                value="$fedramp-values//fedramp:value-set[@name eq 'control-origination']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="implemented-requirement-has-allowed-control-origination-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.3.1.1"
                doc:template-reference="System Security Plan Template §13"
                id="implemented-requirement-has-allowed-control-origination"
                role="error"
                see="Guide to OSCAL-based FedRAMP System Security Plans §5.3.1.1"
                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'control-origination' and @value = $control-originations]"> Every
                implemented requirement has an allowed control origination.</sch:assert>
            <sch:assert
                diagnostics="implemented-requirement-has-leveraged-authorization-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.3.1.1"
                doc:template-reference="System Security Plan Template §13"
                id="implemented-requirement-has-leveraged-authorization"
                role="error"
                see="Guide to OSCAL-based FedRAMP System Security Plans §5.3.1.1"
                test="
                    if (oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'control-origination' and @value eq 'inherited']) then (: there must be a leveraged-authorization-uuid property :)
                        exists(oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'leveraged-authorization-uuid']) and (: the referenced leveraged-authorization must exist :) exists(//oscal:leveraged-authorization[@uuid = current()/oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'leveraged-authorization-uuid']/@value])
                    else
                        true()">Every implemented requirement with a control origination of "inherited" references a leveraged
                authorization.</sch:assert>
            <sch:assert
                diagnostics="partial-implemented-requirement-has-plan-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                doc:template-reference="System Security Plan Template §13"
                id="partial-implemented-requirement-has-plan"
                role="error"
                test="
                    if (oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'implementation-status' and @value eq 'partial'])
                    then
                        exists(oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'implementation-status' and @value eq 'planned'])
                    else
                        true()">A partially implemented control must have a plan for complete implementation.</sch:assert>
            <sch:assert
                diagnostics="implemented-requirement-has-allowed-composite-implementation-status-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                doc:template-reference="System Security Plan Template §13"
                id="implemented-requirement-has-allowed-composite-implementation-status"
                role="error"
                test="
                    every $c in string-join(distinct-values((oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'implementation-status']/@value)), '-')
                        satisfies $c = ('implemented', 'planned', 'alternative', 'not-applicable', 'partial-planned', 'planned-partial')">An
                implemented control's implementation status must be implemented, partial and planned, planned, alternative, or not
                applicable.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'implementation-status']">
            <sch:let
                name="control-implementation-statuses"
                value="$fedramp-values//fedramp:value-set[@name eq 'control-implementation-status']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="implemented-requirement-has-allowed-implementation-status-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                doc:template-reference="System Security Plan Template §13"
                id="implemented-requirement-has-allowed-implementation-status"
                role="error"
                test="@value = $control-implementation-statuses">An implemented control's implementation status has an allowed value.</sch:assert>
            <sch:assert
                diagnostics="implemented-requirement-has-implementation-status-remarks-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                doc:template-reference="System Security Plan Template §13"
                id="implemented-requirement-has-implementation-status-remarks"
                role="error"
                test="
                    if (@value ne 'implemented') then
                        oscal:remarks
                    else
                        true()">Incomplete control implementations have an explanation.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'planned-completion-date']"
            doc:template-reference="System Security Plan Template §13">
            <sch:assert
                diagnostics="planned-completion-date-is-valid-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                doc:template-reference="System Security Plan Template §13"
                id="planned-completion-date-is-valid"
                role="error"
                see="Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                test="@value castable as xs:date">Planned completion date is valid.</sch:assert>
            <sch:assert
                diagnostics="planned-completion-date-is-not-past-diagnostic"
                doc:guide-reference="Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                id="planned-completion-date-is-not-past"
                role="error"
                see="Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                test="not(@value castable as xs:date) or (@value castable as xs:date and xs:date(@value) gt current-date())">Planned completion date
                is not past.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern
        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.13-14"
        id="cloud-models">
        <sch:title>Cloud Service and Deployment Models</sch:title>
        <sch:let
            name="service-models"
            value="$fedramp-values//fedramp:value-set[@name eq 'service-model']//fedramp:enum/@value" />
        <sch:let
            name="deployment-models"
            value="$fedramp-values//fedramp:value-set[@name eq 'deployment-model']//fedramp:enum/@value" />
        <sch:rule
            context="oscal:system-characteristics">
            <sch:assert
                diagnostics="has-cloud-service-model-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.13"
                doc:template-reference="System Security Plan Template §8.1"
                id="has-cloud-service-model"
                role="error"
                test="oscal:prop[@name eq 'cloud-service-model']">A FedRAMP SSP must specify a cloud service model.</sch:assert>
            <sch:assert
                diagnostics="has-allowed-cloud-service-model-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.13"
                doc:template-reference="System Security Plan Template §8.1"
                id="has-allowed-cloud-service-model"
                role="error"
                test="oscal:prop[@name eq 'cloud-service-model' and @value = $service-models]">A FedRAMP SSP must specify an allowed cloud service
                model.</sch:assert>
            <sch:assert
                diagnostics="has-cloud-service-model-remarks-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.13"
                doc:template-reference="System Security Plan Template §8.1"
                id="has-cloud-service-model-remarks"
                role="error"
                test="
                    every $p in oscal:prop[@name eq 'cloud-service-model' and @value eq 'other']
                        satisfies exists($p/oscal:remarks)
                    ">A FedRAMP SSP with a cloud service model of "other" must supply remarks.</sch:assert>
            <sch:assert
                diagnostics="has-cloud-deployment-model-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.14"
                doc:template-reference="System Security Plan Template §8.2"
                id="has-cloud-deployment-model"
                role="error"
                test="oscal:prop[@name eq 'cloud-deployment-model']">A FedRAMP SSP must specify a cloud deployment model.</sch:assert>
            <sch:assert
                diagnostics="has-allowed-cloud-deployment-model-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.14"
                doc:template-reference="System Security Plan Template §8.2"
                id="has-allowed-cloud-deployment-model"
                role="error"
                test="oscal:prop[@name eq 'cloud-deployment-model' and @value = $deployment-models]">A FedRAMP SSP must specify an allowed cloud
                deployment model.</sch:assert>
            <sch:assert
                diagnostics="has-cloud-deployment-model-remarks-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.14"
                doc:template-reference="System Security Plan Template §8.2"
                id="has-cloud-deployment-model-remarks"
                role="error"
                test="
                    every $p in oscal:prop[@name eq 'cloud-deployment-model' and @value eq 'hybrid-cloud']
                        satisfies exists($p/oscal:remarks)
                    ">A FedRAMP SSP with a cloud deployment model of "hybrid-cloud" must supply remarks.</sch:assert>
            <sch:assert
                diagnostics="has-public-cloud-deployment-model-diagnostic"
                id="has-public-cloud-deployment-model"
                role="error"
                test="
                    (: either there is no component or inventory-item tagged as 'public' :)
                    not(
                    exists(//oscal:component[oscal:prop[@name eq 'public' and @value eq 'yes']])
                    or
                    exists(//oscal:inventory-item[oscal:prop[@name eq 'public' and @value eq 'yes']])
                    )
                    or (: a 'public-cloud' deployment model is employed :)
                    exists(oscal:prop[@name eq 'cloud-deployment-model' and @value eq 'public-cloud'])
                    ">When a FedRAMP SSP has public components or inventory items, a cloud deployment model of "public-cloud" must be
                employed.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern
        id="interconnects">
        <sch:title>Interconnections</sch:title>
        <sch:rule
            context="oscal:component[@type = 'interconnection']/oscal:prop[@name eq 'interconnection-direction']">
            <sch:let
                name="interconnection-direction-values"
                value="$fedramp-values//fedramp:value-set[@name eq 'interconnection-direction']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="interconnection-has-allowed-interconnection-direction-value-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-allowed-interconnection-direction-value"
                role="error"
                test="@value = $interconnection-direction-values">A system interconnection must have an allowed
                interconnection-direction.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:component[@type = 'interconnection']/oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'interconnection-security']">
            <sch:let
                name="interconnection-security-values"
                value="$fedramp-values//fedramp:value-set[@name eq 'interconnection-security']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="interconnection-has-allowed-interconnection-security-value-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-allowed-interconnection-security-value"
                role="error"
                test="@value = $interconnection-security-values">A system interconnection must have an allowed interconnection-security
                value.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-allowed-interconnection-security-remarks-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-interconnection-security-remarks"
                role="error"
                test="@value ne 'other' or exists(oscal:remarks)">A system interconnection with an interconnection-security of &quot;other&quot; must
                have explanatory remarks.</sch:assert>
        </sch:rule>
        <sch:rule
            context="oscal:component[@type eq 'interconnection']">
            <sch:assert
                diagnostics="interconnection-has-title-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-title"
                role="error"
                test="oscal:title">A system interconnection must provide a remote system name.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-description-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-description"
                role="error"
                test="oscal:description">A system interconnection must provide a remote system description.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-direction-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-direction"
                role="error"
                test="oscal:prop[@name eq 'interconnection-direction']">A system interconnection must identify the direction of data
                flows.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-information-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-information"
                role="error"
                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'information']">A system interconnection must describe the
                information being transferred.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-protocol-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-protocol"
                role="error"
                test="oscal:protocol">A system interconnection must describe the protocols used for information transfer.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-service-processor-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-service-processor"
                role="error"
                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'service-processor']">A system interconnection must describe the
                service processor.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-local-IPv4-address-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-local-IPv4-address"
                role="error"
                test="oscal:prop[@name eq 'ipv4-address' and @class eq 'local']">A system interconnection must specify the local (CSP) IPv4
                address.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-local-IPv6-address-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-local-IPv6-address"
                role="error"
                test="oscal:prop[@name eq 'ipv6-address' and @class eq 'local']">A system interconnection must specify the local (CSP) IPv6
                address.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-remote-IPv4-address-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-remote-IPv4-address"
                role="error"
                test="oscal:prop[@name eq 'ipv4-address' and @class eq 'remote']">A system interconnection must specify the external system's IPv4
                address.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-remote-IPv6-address-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-remote-IPv6-address"
                role="error"
                test="oscal:prop[@name eq 'ipv6-address' and @class eq 'remote']">A system interconnection must specify the external system IPv6
                address.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-interconnection-security-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-interconnection-security"
                role="error"
                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'interconnection-security']">A system interconnection must specify
                how the connection is secured.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-circuit-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-circuit"
                role="information"
                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'circuit']">A system interconnection which uses a dedicated
                circuit switching network must specify the circuit number.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-isa-poc-local-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-isa-poc-local"
                role="error"
                test="oscal:responsible-role[@role-id eq 'isa-poc-local']">A system interconnection must specify a responsible local (CSP) point of
                contact.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-isa-poc-remote-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-isa-poc-remote"
                role="error"
                test="oscal:responsible-role[@role-id eq 'isa-poc-remote']">A system interconnection must specify a responsible remote point of
                contact.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-isa-authorizing-official-local-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-isa-authorizing-official-local"
                role="error"
                test="oscal:responsible-role[@role-id eq 'isa-authorizing-official-local']">A system interconnection must specify a local authorizing
                official.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-isa-authorizing-official-remote-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-isa-authorizing-official-remote"
                role="error"
                test="oscal:responsible-role[@role-id eq 'isa-authorizing-official-remote']">A system interconnection must specify a remote
                authorizing official.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-responsible-persons-diagnostic"
                id="interconnection-has-responsible-persons"
                role="error"
                test="
                    exists(oscal:responsible-role/oscal:party-uuid) and
                    (every $rp in descendant::oscal:party-uuid
                        satisfies exists(//oscal:party[@uuid eq $rp and @type eq 'person']))">Every responsible person for a system
                interconnect is defined.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-distinct-isa-local-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-distinct-isa-local"
                role="error"
                test="
                    every $p in oscal:responsible-role[matches(@role-id, 'local$')]/oscal:party-uuid
                        satisfies not($p = oscal:responsible-role[matches(@role-id, 'remote$')]/oscal:party-uuid)
                    ">A system interconnection must specify local responsible parties which are not remote responsible
                parties.</sch:assert>
            <sch:assert
                diagnostics="interconnection-has-distinct-isa-remote-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-has-distinct-isa-remote"
                role="error"
                test="
                    every $p in oscal:responsible-role[matches(@role-id, 'remote$')]/oscal:party-uuid
                        satisfies not($p = oscal:responsible-role[matches(@role-id, 'local$')]/oscal:party-uuid)">A system
                interconnection must specify remote responsible parties which are not local responsible parties.</sch:assert>
            <sch:assert
                diagnostics="interconnection-cites-interconnection-agreement-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-cites-interconnection-agreement"
                role="error"
                test="oscal:link[@rel eq 'agreement']">A system interconnection must cite an interconnection agreement.</sch:assert>
            <sch:assert
                diagnostics="interconnection-cites-interconnection-agreement-href-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-cites-interconnection-agreement-href"
                role="error"
                test="oscal:link[@rel eq 'agreement' and matches(@href, '^#')]">A system interconnection must cite an intra-document defined
                interconnection agreement.</sch:assert>
            <sch:assert
                diagnostics="interconnection-cites-attached-interconnection-agreement-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-cites-attached-interconnection-agreement"
                role="error"
                test="
                    every $href in oscal:link[@rel eq 'agreement']/@href
                        satisfies exists(//oscal:resource[@uuid eq substring-after($href, '#')])">A system interconnection must cite
                an intra-document attached interconnection agreement and that agreement must be present in the SSP.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:component[@type eq 'interconnection']/oscal:protocol">
            <sch:assert
                diagnostics="interconnection-protocol-has-name-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-protocol-has-name"
                role="error"
                test="@name">A system interconnection protocol must have a name.</sch:assert>
            <sch:assert
                diagnostics="interconnection-protocol-has-port-range-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-protocol-has-port-range"
                role="warning"
                test="oscal:port-range">A system interconnection protocol should have one or more port range declarations.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:component[@type eq 'interconnection']/oscal:protocol/oscal:port-range">
            <sch:assert
                diagnostics="interconnection-protocol-port-range-has-transport-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-protocol-port-range-has-transport"
                role="error"
                test="@transport">A system interconnection protocol port range declaration must state a transport protocol.</sch:assert>
            <sch:assert
                diagnostics="interconnection-protocol-port-range-has-start-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-protocol-port-range-has-start"
                role="error"
                test="@start">A system interconnection protocol port range declaration must state a starting port number.</sch:assert>
            <sch:assert
                diagnostics="interconnection-protocol-port-range-has-end-diagnostic"
                doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.20"
                doc:template-reference="System Security Plan Template §11"
                id="interconnection-protocol-port-range-has-end"
                role="error"
                test="@end">A system interconnection protocol port range declaration must state an ending port number. The start and end port number can be the same if there is one port number.</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern
        id="info">
        <sch:rule
            context="oscal:system-security-plan">
            <sch:report
                id="info-system-name"
                role="information"
                test="true()"><sch:value-of
                    select="oscal:system-characteristics/oscal:system-name" /></sch:report>
            <sch:report
                id="info-ssp-title"
                role="information"
                test="true()"><sch:value-of
                    select="oscal:metadata/oscal:title" /></sch:report>
        </sch:rule>
    </sch:pattern>
    <sch:diagnostics>
        <sch:diagnostic
            doc:assertion="no-registry-values"
            doc:context="/o:system-security-plan"
            id="no-registry-values-diagnostic">The validation technical components at the path '<sch:value-of
                select="$registry-base-path" />' are not present, this configuration is invalid.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="no-security-sensitivity-level"
            doc:context="/o:system-security-plan"
            id="no-security-sensitivity-level-diagnostic">No sensitivity level was found As a result, no more validation processing can
            occur.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="invalid-security-sensitivity-level"
            doc:context="/o:system-security-plan"
            id="invalid-security-sensitivity-level-diagnostic">
            <sch:value-of
                select="./name()" /> is an invalid value of '<sch:value-of
                select="lv:sensitivity-level(/)" />', not an allowed value of <sch:value-of
                select="$corrections" />. No more validation processing can occur.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="incomplete-core-implemented-requirements"
            doc:context="/o:system-security-plan/o:control-implementation"
            id="incomplete-core-implemented-requirements-diagnostic">A FedRAMP SSP must implement the most important <sch:value-of
                select="count($core-missing)" /> core <sch:value-of
                select="
                    if (count($core-missing) = 1) then
                        ' control'
                    else
                        ' controls'" />: <sch:value-of
                select="$core-missing/@id" />.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="incomplete-all-implemented-requirements"
            doc:context="/o:system-security-plan/o:control-implementation"
            id="incomplete-all-implemented-requirements-diagnostic">A FedRAMP SSP must implement <sch:value-of
                select="count($all-missing)" />
            <sch:value-of
                select="
                    if (count($all-missing) = 1) then
                        ' control'
                    else
                        ' controls'" /> overall: <sch:value-of
                select="$all-missing/@id" />.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="extraneous-implemented-requirements"
            doc:context="/o:system-security-plan/o:control-implementation"
            id="extraneous-implemented-requirements-diagnostic">A FedRAMP SSP must implement <sch:value-of
                select="count($extraneous)" /> extraneous <sch:value-of
                select="
                    if (count($extraneous) = 1) then
                        ' control'
                    else
                        ' controls'" /> not needed given the selected profile: <sch:value-of
                select="$extraneous/@control-id" />.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="invalid-implementation-status"
            doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement"
            id="invalid-implementation-status-diagnostic">Invalid implementation status '<sch:value-of
                select="$status" />' for <sch:value-of
                select="./@control-id" />, must be <sch:value-of
                select="$corrections" />.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="missing-response-points"
            doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement"
            id="missing-response-points-diagnostic">This FedRAMP SSP lacks a statement for each of the following lettered response points for required
            controls: <sch:value-of
                select="$missing/@id" />.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="missing-response-components"
            doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement"
            id="missing-response-components-diagnostic">Response statements for <sch:value-of
                select="./@statement-id" /> must have at least <sch:value-of
                select="$required-components-count" />
            <sch:value-of
                select="
                    if (count($components-count) = 1) then
                        ' component'
                    else
                        ' components'" /> with a description. There are <sch:value-of
                select="$components-count" />.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="extraneous-response-description"
            doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:description"
            id="extraneous-response-description-diagnostic">Response statement <sch:value-of
                select="../@statement-id" /> has a description not within a component. That was previously allowed, but not recommended. It will soon
            be syntactically invalid and deprecated.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="extraneous-response-remarks"
            doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:remarks"
            id="extraneous-response-remarks-diagnostic">Response statement <sch:value-of
                select="../@statement-id" /> has remarks not within a component. That was previously allowed, but not recommended. It will soon be
            syntactically invalid and deprecated.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="invalid-component-match"
            doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component"
            id="invalid-component-match-diagnostic">Response statement <sch:value-of
                select="../@statement-id" /> with component reference UUID ' <sch:value-of
                select="$component-ref" />' is not in the system implementation inventory, and cannot be used to define a control.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="missing-component-description"
            doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component"
            id="missing-component-description-diagnostic">Response statement <sch:value-of
                select="../@statement-id" /> has a component, but that component is missing a required description node.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="incomplete-response-description"
            doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:description"
            id="incomplete-response-description-diagnostic">Response statement component description for <sch:value-of
                select="../../@statement-id" /> is too short with <sch:value-of
                select="$description-length" /> characters. It must be <sch:value-of
                select="$required-length" /> characters long.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="incomplete-response-remarks"
            doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:remarks"
            id="incomplete-response-remarks-diagnostic">Response statement component remarks for <sch:value-of
                select="../../@statement-id" /> is too short with <sch:value-of
                select="$remarks-length" /> characters. It must be <sch:value-of
                select="$required-length" /> characters long.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="incorrect-role-association"
            doc:context="/o:system-security-plan/o:metadata"
            id="incorrect-role-association-diagnostic">A FedRAMP SSP must define a responsible party with <sch:value-of
                select="count($extraneous-roles)" />
            <sch:value-of
                select="
                    if (count($extraneous-roles) = 1) then
                        ' role'
                    else
                        ' roles'" /> not defined in the role: <sch:value-of
                select="$extraneous-roles/@role-id" />.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="incorrect-party-association"
            doc:context="/o:system-security-plan/o:metadata"
            id="incorrect-party-association-diagnostic">A FedRAMP SSP must define a responsible party with <sch:value-of
                select="count($extraneous-parties)" />
            <sch:value-of
                select="
                    if (count($extraneous-parties) = 1) then
                        ' party'
                    else
                        ' parties'" /> is not a defined party: <sch:value-of
                select="$extraneous-parties/o:party-uuid" />.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="resource-uuid-required"
            doc:context="/o:system-security-plan/o:back-matter/o:resource"
            id="resource-uuid-required-diagnostic">This FedRAMP SSP has a back-matter resource which lacks a UUID.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="resource-rlink-required"
            doc:context="/o:system-security-plan/o:back-matter/o:resource/o:rlink"
            id="resource-rlink-required-diagnostic">A FedRAMP SSP must reference back-matter resource: <sch:value-of
                select="./@href" />.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="resource-base64-available-filename"
            doc:context="/o:system-security-plan/o:back-matter/o:resource/o:base64"
            id="resource-base64-available-filename-diagnostic">This base64 lacks a filename attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="resource-base64-available-media-type"
            doc:context="/o:system-security-plan/o:back-matter/o:resource/o:base64"
            id="resource-base64-available-media-type-diagnostic">This base64 lacks a media-type attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="resource-has-uuid"
            doc:context="oscal:resource"
            id="resource-has-uuid-diagnostic">This resource lacks a uuid attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="resource-has-title"
            doc:context="oscal:resource"
            id="resource-has-title-diagnostic">This resource lacks a title.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="resource-has-rlink"
            doc:context="oscal:resource"
            id="resource-has-rlink-diagnostic">This resource lacks a rlink element.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="resource-is-referenced"
            doc:context="oscal:resource"
            id="resource-is-referenced-diagnostic">This resource lacks a reference within the document.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="attachment-type-is-valid"
            doc:context="oscal:back-matter/oscal:resource/oscal:prop[@name eq 'type']"
            id="attachment-type-is-valid-diagnostic">Found unknown attachment type «<sch:value-of
                select="@value" />» in <sch:value-of
                select="
                    if (parent::oscal:resource/oscal:title) then
                        concat('&#34;', parent::oscal:resource/oscal:title, '&#34;')
                    else
                        'untitled'" /> resource.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="rlink-has-href"
            doc:context="oscal:back-matter/oscal:resource/oscal:rlink"
            id="rlink-has-href-diagnostic">This rlink lacks an href attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-allowed-media-type"
            doc:context="oscal:rlink | oscal:base64"
            id="has-allowed-media-type-diagnostic">This <sch:value-of
                select="name(parent::node())" /> has a media-type="<sch:value-of
                select="current()/@media-type" />" which is not in the list of allowed media types. Allowed media types are <sch:value-of
                select="string-join($media-types, ' ∨ ')" />.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="resource-has-base64"
            doc:context="oscal:back-matter/oscal:resource"
            id="resource-has-base64-diagnostic"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">This resource lacks a base64 element.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="resource-base64-cardinality"
            doc:context="oscal:back-matter/oscal:resource"
            id="resource-base64-cardinality-diagnostic"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">This resource must not have more than one base64 element.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="base64-has-filename"
            doc:context="oscal:back-matter/oscal:resource/oscal:base64"
            id="base64-has-filename-diagnostic"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">This base64 must have a filename attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="base64-has-media-type"
            doc:context="oscal:back-matter/oscal:resource/oscal:base64"
            id="base64-has-media-type-diagnostic"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">This base64 element lacks a media-type attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="base64-has-content"
            doc:context="oscal:back-matter/oscal:resource/oscal:base64"
            id="base64-has-content-diagnostic"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">This base64 element lacks content.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-fedramp-acronyms"
            doc:context="oscal:back-matter"
            id="has-fedramp-acronyms-diagnostic">This FedRAMP OSCAL SSP lacks the FedRAMP Master Acronym and Glossary.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-fedramp-citations"
            doc:context="oscal:back-matter"
            id="has-fedramp-citations-diagnostic">This FedRAMP OSCAL SSP lacks the FedRAMP Applicable Laws and Regulations.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-fedramp-logo"
            doc:context="oscal:back-matter"
            id="has-fedramp-logo-diagnostic">This FedRAMP OSCAL SSP lacks the FedRAMP Logo.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-user-guide"
            doc:context="oscal:back-matter"
            id="has-user-guide-diagnostic">This FedRAMP OSCAL SSP lacks a User Guide.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-rules-of-behavior"
            doc:context="oscal:back-matter"
            id="has-rules-of-behavior-diagnostic">This FedRAMP OSCAL SSP lacks a Rules of Behavior.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-information-system-contingency-plan"
            doc:context="oscal:back-matter"
            id="has-information-system-contingency-plan-diagnostic">This FedRAMP OSCAL SSP lacks a Contingency Plan.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-configuration-management-plan"
            doc:context="oscal:back-matter"
            id="has-configuration-management-plan-diagnostic">This FedRAMP OSCAL SSP lacks a Configuration Management Plan.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-incident-response-plan"
            doc:context="oscal:back-matter"
            id="has-incident-response-plan-diagnostic">This FedRAMP OSCAL SSP lacks an Incident Response Plan.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-separation-of-duties-matrix"
            doc:context="oscal:back-matter"
            id="has-separation-of-duties-matrix-diagnostic">This FedRAMP OSCAL SSP lacks a Separation of Duties Matrix.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-policy-link"
            doc:context="oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')]"
            id="has-policy-link-diagnostic">
            <sch:value-of
                select="local-name()" />
            <sch:value-of
                select="@control-id" /> lacks policy reference(s) (via by-component link).</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-policy-attachment-resource"
            doc:context="oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')]"
            id="has-policy-attachment-resource-diagnostic">
            <sch:value-of
                select="local-name()" />
            <sch:value-of
                select="@control-id" /> lacks policy attachment resource(s) <sch:value-of
                select="string-join($policy-hrefs, ', ')" />.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-procedure-link"
            doc:context="oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')]"
            id="has-procedure-link-diagnostic">
            <sch:value-of
                select="local-name()" />
            <sch:value-of
                select="@control-id" /> lacks procedure reference(s) (via by-component link).</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-procedure-attachment-resource"
            doc:context="oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')]"
            id="has-procedure-attachment-resource-diagnostic">
            <sch:value-of
                select="local-name()" />
            <sch:value-of
                select="@control-id" /> lacks procedure attachment resource(s) <sch:value-of
                select="string-join($procedure-hrefs, ', ')" />.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-unique-policy-and-procedure"
            doc:context="oscal:by-component/oscal:link[@rel = ('policy', 'procedure')]"
            id="has-unique-policy-and-procedure-diagnostic">A policy or procedure reference was incorrectly re-used.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-privacy-poc-role"
            doc:context="oscal:metadata"
            id="has-privacy-poc-role-diagnostic">This FedRAMP OSCAL SSP lacks a Privacy Point of Contact role.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-responsible-party-privacy-poc-role"
            doc:context="oscal:metadata"
            id="has-responsible-party-privacy-poc-role-diagnostic">This FedRAMP OSCAL SSP lacks a Privacy Point of Contact responsible party role
            reference.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-responsible-privacy-poc-party-uuid"
            doc:context="oscal:metadata"
            id="has-responsible-privacy-poc-party-uuid-diagnostic">This FedRAMP OSCAL SSP lacks a Privacy Point of Contact responsible party role
            reference identifying the party by UUID.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-privacy-poc"
            doc:context="oscal:metadata"
            id="has-privacy-poc-diagnostic">This FedRAMP OSCAL SSP lacks a Privacy Point of Contact.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-correct-yes-or-no-answer"
            doc:context="oscal:prop[@name eq 'privacy-sensitive'] | oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @class eq 'pta' and matches(@name, '^pta-\d$')]"
            id="has-correct-yes-or-no-answer-diagnostic">This property has an incorrect value: should be "yes" or "no".</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-privacy-sensitive-designation"
            doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
            id="has-privacy-sensitive-designation-diagnostic">The privacy-sensitive designation is missing.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-pta-question-1"
            doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
            id="has-pta-question-1-diagnostic">The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #1 is
            missing.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-pta-question-2"
            doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
            id="has-pta-question-2-diagnostic">The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #2 is
            missing.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-pta-question-3"
            doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
            id="has-pta-question-3-diagnostic">The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #3 is
            missing.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-pta-question-4"
            doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
            id="has-pta-question-4-diagnostic">The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #4 is
            missing.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-all-pta-questions"
            doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
            id="has-all-pta-questions-diagnostic">One or more of the four PTA questions is missing.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-correct-pta-question-cardinality"
            doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
            id="has-correct-pta-question-cardinality-diagnostic">One or more of the four PTA questions is a duplicate.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-sorn"
            doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
            id="has-sorn-diagnostic">The SORN ID is missing.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-pia"
            doc:context="oscal:back-matter"
            id="has-pia-diagnostic">This FedRAMP OSCAL SSP lacks a Privacy Impact Analysis.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-CMVP-validation"
            doc:context="oscal:system-implementation"
            id="has-CMVP-validation-diagnostic">This FedRAMP OSCAL SSP does not declare one or more FIPS 140 validated modules.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-CMVP-validation-reference"
            doc:context="oscal:component[@type eq 'validation']"
            id="has-CMVP-validation-reference-diagnostic">This validation component or inventory-item lacks a validation-reference
            property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-CMVP-validation-details"
            doc:context="oscal:component[@type eq 'validation']"
            id="has-CMVP-validation-details-diagnostic">This validation component or inventory-item lacks a validation-details link.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-credible-CMVP-validation-reference"
            doc:context="oscal:prop[@name eq 'validation-reference']"
            id="has-credible-CMVP-validation-reference-diagnostic">This validation-reference property does not resemble a CMVP certificate
            number.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-consonant-CMVP-validation-reference"
            doc:context="oscal:prop[@name eq 'validation-reference']"
            id="has-consonant-CMVP-validation-reference-diagnostic">This validation-reference property does not match its sibling validation-details
            href.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-credible-CMVP-validation-details"
            doc:context="oscal:prop[@name eq 'validation-details']"
            id="has-credible-CMVP-validation-details-diagnostic">This validation-details link href attribute does not resemble a CMVP certificate
            URL.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-consonant-CMVP-validation-details"
            doc:context="oscal:prop[@name eq 'validation-details']"
            id="has-consonant-CMVP-validation-details-diagnostic">This validation-details link href attribute does not match its sibling
            validation-reference value.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-security-sensitivity-level"
            doc:context="oscal:system-characteristics"
            id="has-security-sensitivity-level-diagnostic">This FedRAMP OSCAL SSP lacks a FIPS 199 categorization.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-security-impact-level"
            doc:context="oscal:system-characteristics"
            id="has-security-impact-level-diagnostic">This FedRAMP OSCAL SSP lacks a security impact level.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-allowed-security-sensitivity-level"
            doc:context="oscal:security-sensitivity-level"
            id="has-allowed-security-sensitivity-level-diagnostic">Invalid security-sensitivity-level "<sch:value-of
                select="." />". It must have one of the following <sch:value-of
                select="count($security-sensitivity-levels)" /> values: <sch:value-of
                select="string-join($security-sensitivity-levels, ' ∨ ')" />.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-security-objective-confidentiality"
            doc:context="oscal:security-impact-level"
            id="has-security-objective-confidentiality-diagnostic">This FedRAMP OSCAL SSP lacks a confidentiality security objective.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-security-objective-integrity"
            doc:context="oscal:security-impact-level"
            id="has-security-objective-integrity-diagnostic">This FedRAMP OSCAL SSP lacks an integrity security objective.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-security-objective-availability"
            doc:context="oscal:security-impact-level"
            id="has-security-objective-availability-diagnostic">This FedRAMP OSCAL SSP lacks an availability security objective.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-allowed-security-objective-value"
            doc:context="oscal:security-objective-confidentiality | oscal:security-objective-integrity | oscal:security-objective-availability"
            id="has-allowed-security-objective-value-diagnostic">Invalid "<sch:value-of
                select="name()" />" <sch:value-of
                select="." />". It must have one of the following <sch:value-of
                select="count($security-objective-levels)" /> values: <sch:value-of
                select="string-join($security-objective-levels, ' ∨ ')" />.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="system-information-has-information-type"
            doc:context="oscal:system-information"
            id="system-information-has-information-type-diagnostic">A FedRAMP OSCAL SSP lacks at least one information-type.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="information-type-has-title"
            doc:context="oscal:information-type"
            id="information-type-has-title-diagnostic">A FedRAMP OSCAL SSP information-type lacks a title.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="information-type-has-description"
            doc:context="oscal:information-type"
            id="information-type-has-description-diagnostic">A FedRAMP OSCAL SSP information-type lacks a description.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="information-type-has-categorization"
            doc:context="oscal:information-type"
            id="information-type-has-categorization-diagnostic">A FedRAMP OSCAL SSP information-type lacks at least one
            categorization.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="information-type-has-confidentiality-impact"
            doc:context="oscal:information-type"
            id="information-type-has-confidentiality-impact-diagnostic">A FedRAMP OSCAL SSP information-type lacks a
            confidentiality-impact.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="information-type-has-integrity-impact"
            doc:context="oscal:information-type"
            id="information-type-has-integrity-impact-diagnostic">A FedRAMP OSCAL SSP information-type lacks a integrity-impact.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="information-type-has-availability-impact"
            doc:context="oscal:information-type"
            id="information-type-has-availability-impact-diagnostic">A FedRAMP OSCAL SSP information-type lacks a
            availability-impact.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="categorization-has-system-attribute"
            doc:context="oscal:categorization"
            id="categorization-has-system-attribute-diagnostic">A FedRAMP OSCAL SSP information-type categorization lacks a system
            attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="categorization-has-correct-system-attribute"
            doc:context="oscal:categorization"
            id="categorization-has-correct-system-attribute-diagnostic">A FedRAMP OSCAL SSP information-type categorization lacks a correct system
            attribute. The correct value is "https://doi.org/10.6028/NIST.SP.800-60v2r1".</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="categorization-has-information-type-id"
            doc:context="oscal:categorization"
            id="categorization-has-information-type-id-diagnostic">A FedRAMP OSCAL SSP information-type categorization lacks at least one
            information-type-id.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-allowed-information-type-id"
            doc:context="oscal:information-type-id"
            id="has-allowed-information-type-id-diagnostic">A FedRAMP OSCAL SSP information-type-id lacks a SP 800-60v2r1 identifier.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="cia-impact-has-base"
            doc:context="oscal:confidentiality-impact | oscal:integrity-impact | oscal:availability-impact"
            id="cia-impact-has-base-diagnostic">A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact lacks a base
            element.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="cia-impact-has-selected"
            doc:context="oscal:confidentiality-impact | oscal:integrity-impact | oscal:availability-impact"
            id="cia-impact-has-selected-diagnostic">A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact lacks a
            selected element.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="cia-impact-has-approved-fips-categorization"
            doc:context="oscal:base | oscal:selected"
            id="cia-impact-has-approved-fips-categorization-diagnostic">A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or
            availability-impact base or select element lacks an approved value.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-security-eauth-level"
            doc:context="oscal:system-characteristics"
            id="has-security-eauth-level-diagnostic">This FedRAMP OSCAL SSP lacks a Digital Identity Determination property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-identity-assurance-level"
            doc:context="oscal:system-characteristics"
            id="has-identity-assurance-level-diagnostic">A FedRAMP OSCAL SSP may lack a Digital Identity Determination identity-assurance-level
            property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-authenticator-assurance-level"
            doc:context="oscal:system-characteristics"
            id="has-authenticator-assurance-level-diagnostic">A FedRAMP OSCAL SSP may lack a Digital Identity Determination
            authenticator-assurance-level property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-federation-assurance-level"
            doc:context="oscal:system-characteristics"
            id="has-federation-assurance-level-diagnostic">A FedRAMP OSCAL SSP may lack a Digital Identity Determination federation-assurance-level
            property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-allowed-security-eauth-level"
            doc:context="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @class eq 'security-eauth' and @name eq 'security-eauth-level']"
            id="has-allowed-security-eauth-level-diagnostic">This FedRAMP OSCAL SSP lacks a Digital Identity Determination property with an allowed
            value.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-allowed-identity-assurance-level"
            doc:context="oscal:prop[@name eq 'identity-assurance-level']"
            id="has-allowed-identity-assurance-level-diagnostic">A FedRAMP OSCAL SSP may lack an allowed Digital Identity Determination
            identity-assurance-level property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-allowed-authenticator-assurance-level"
            doc:context="oscal:prop[@name eq 'authenticator-assurance-level']"
            id="has-allowed-authenticator-assurance-level-diagnostic">A FedRAMP OSCAL SSP may lack an allowed Digital Identity Determination
            authenticator-assurance-level property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-allowed-federation-assurance-level"
            doc:context="oscal:prop[@name eq 'federation-assurance-level']"
            id="has-allowed-federation-assurance-level-diagnostic">A FedRAMP OSCAL SSP may lack an allowed Digital Identity Determination
            federation-assurance-level property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-inventory-items"
            doc:context="/oscal:system-security-plan/oscal:system-implementation"
            id="has-inventory-items-diagnostic">This FedRAMP OSCAL SSP lacks inventory-item elements.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-unique-asset-id"
            doc:context="oscal:prop[@name eq 'asset-id']"
            id="has-unique-asset-id-diagnostic">This asset id <sch:value-of
                select="@asset-id" /> is not unique. An asset id must be unique within the scope of a FedRAMP OSCAL SSP document.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-allowed-asset-type"
            doc:context="oscal:prop[@name eq 'asset-type']"
            id="has-allowed-asset-type-diagnostic">
            <sch:value-of
                select="name()" /> should have a FedRAMP asset type <sch:value-of
                select="string-join($asset-types, ' ∨ ')" /> (not " <sch:value-of
                select="@value" />").</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-allowed-virtual"
            doc:context="oscal:prop[@name eq 'virtual']"
            id="has-allowed-virtual-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed value <sch:value-of
                select="string-join($virtuals, ' ∨ ')" /> (not " <sch:value-of
                select="@value" />").</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-allowed-public"
            doc:context="oscal:prop[@name eq 'public']"
            id="has-allowed-public-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed value <sch:value-of
                select="string-join($publics, ' ∨ ')" /> (not " <sch:value-of
                select="@value" />").</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-allowed-allows-authenticated-scan"
            doc:context="oscal:prop[@name eq 'allows-authenticated-scan']"
            id="has-allowed-allows-authenticated-scan-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed value <sch:value-of
                select="string-join($allows-authenticated-scans, ' ∨ ')" /> (not " <sch:value-of
                select="@value" />").</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-allowed-is-scanned"
            doc:context="oscal:prop[@name eq 'is-scanned']"
            id="has-allowed-is-scanned-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed value <sch:value-of
                select="string-join($is-scanneds, ' ∨ ')" /> (not " <sch:value-of
                select="@value" />").</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-allowed-scan-type"
            doc:context="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'scan-type']"
            id="has-allowed-scan-type-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed value <sch:value-of
                select="string-join($scan-types, ' ∨ ')" /> (not " <sch:value-of
                select="@value" />").</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="component-has-allowed-type"
            doc:context="oscal:component"
            id="component-has-allowed-type-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed component type <sch:value-of
                select="string-join($component-types, ' ∨ ')" /> (not " <sch:value-of
                select="@type" />").</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-uuid"
            doc:context="oscal:inventory-item"
            id="inventory-item-has-uuid-diagnostic">This inventory-item lacks a uuid attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-asset-id"
            doc:context="oscal:inventory-item"
            id="has-asset-id-diagnostic">This inventory-item lacks an asset-id property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-one-asset-id"
            doc:context="oscal:inventory-item"
            id="has-one-asset-id-diagnostic">This inventory-item has more than one asset-id property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-asset-type"
            doc:context="oscal:inventory-item"
            id="inventory-item-has-asset-type-diagnostic">This inventory-item lacks an asset-type property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-one-asset-type"
            doc:context="oscal:inventory-item"
            id="inventory-item-has-one-asset-type-diagnostic">This inventory-item has more than one asset-type property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-virtual"
            doc:context="oscal:inventory-item"
            id="inventory-item-has-virtual-diagnostic">This inventory-item lacks a virtual property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-one-virtual"
            doc:context="oscal:inventory-item"
            id="inventory-item-has-one-virtual-diagnostic">This inventory-item has more than one virtual property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-public"
            doc:context="oscal:inventory-item"
            id="inventory-item-has-public-diagnostic">This inventory-item lacks a public property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-one-public"
            doc:context="oscal:inventory-item"
            id="inventory-item-has-one-public-diagnostic">This inventory-item has more than one public property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-scan-type"
            doc:context="oscal:inventory-item"
            id="inventory-item-has-scan-type-diagnostic">This inventory-item lacks a scan-type property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-one-scan-type"
            doc:context="oscal:inventory-item"
            id="inventory-item-has-one-scan-type-diagnostic">This inventory-item has more than one scan-type property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-allows-authenticated-scan"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'asset-type' and @value = ('os', 'infrastructure')]]"
            id="inventory-item-has-allows-authenticated-scan-diagnostic">This inventory-item lacks allows-authenticated-scan
            property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-one-allows-authenticated-scan"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'asset-type' and @value = ('os', 'infrastructure')]]"
            id="inventory-item-has-one-allows-authenticated-scan-diagnostic">This inventory-item has more than one allows-authenticated-scan
            property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-baseline-configuration-name"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'asset-type' and @value = ('os', 'infrastructure')]]"
            id="inventory-item-has-baseline-configuration-name-diagnostic">This inventory-item lacks baseline-configuration-name
            property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-one-baseline-configuration-name"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'asset-type' and @value = ('os', 'infrastructure')]]"
            id="inventory-item-has-one-baseline-configuration-name-diagnostic">This inventory-item has more than one baseline-configuration-name
            property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-vendor-name"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'asset-type' and @value = ('os', 'infrastructure')]]"
            id="inventory-item-has-vendor-name-diagnostic">This inventory-item lacks a vendor-name property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-one-vendor-name"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'asset-type' and @value = ('os', 'infrastructure')]]"
            id="inventory-item-has-one-vendor-name-diagnostic">This inventory-item has more than one vendor-name property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-hardware-model"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'asset-type' and @value = ('os', 'infrastructure')]]"
            id="inventory-item-has-hardware-model-diagnostic">This inventory-item lacks a hardware-model property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-one-hardware-model"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'asset-type' and @value = ('os', 'infrastructure')]]"
            id="inventory-item-has-one-hardware-model-diagnostic">This inventory-item has more than one hardware-model property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-is-scanned"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'asset-type' and @value = ('os', 'infrastructure')]]"
            id="inventory-item-has-is-scanned-diagnostic">This inventory-item lacks is-scanned property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-one-is-scanned"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'asset-type' and @value = ('os', 'infrastructure')]]"
            id="inventory-item-has-one-is-scanned-diagnostic">This inventory-item has more than one is-scanned property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-software-name"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'asset-type']/@value = ('software', 'database')]"
            id="inventory-item-has-software-name-diagnostic">This inventory-item lacks software-name property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-one-software-name"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'asset-type']/@value = ('software', 'database')]"
            id="inventory-item-has-one-software-name-diagnostic">This inventory-item has more than one software-name property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-software-version"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'asset-type']/@value = ('software', 'database')]"
            id="inventory-item-has-software-version-diagnostic">This inventory-item lacks software-version property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-one-software-version"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'asset-type']/@value = ('software', 'database')]"
            id="inventory-item-has-one-software-version-diagnostic">This inventory-item has more than one software-version property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-function"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'asset-type']/@value = ('software', 'database')]"
            id="inventory-item-has-function-diagnostic">
            <sch:value-of
                select="name()" /> "<sch:value-of
                select="oscal:prop[@name eq 'asset-type']/@value" />" lacks function property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="inventory-item-has-one-function"
            doc:context="oscal:inventory-item[oscal:prop[@name eq 'asset-type']/@value = ('software', 'database')]"
            id="inventory-item-has-one-function-diagnostic">
            <sch:value-of
                select="name()" /> "<sch:value-of
                select="oscal:prop[@name eq 'asset-type']/@value" />" has more than one function property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="component-has-asset-type"
            doc:context="/oscal:system-security-plan/oscal:system-implementation/oscal:component[(: a component referenced by any inventory-item :)@uuid = //oscal:inventory-item/oscal:implemented-component/@component-uuid]"
            id="component-has-asset-type-diagnostic">
            <sch:value-of
                select="name()" /> lacks an asset-type property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="component-has-one-asset-type"
            doc:context="/oscal:system-security-plan/oscal:system-implementation/oscal:component[(: a component referenced by any inventory-item :)@uuid = //oscal:inventory-item/oscal:implemented-component/@component-uuid]"
            id="component-has-one-asset-type-diagnostic">
            <sch:value-of
                select="name()" /> has more than one asset-type property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-this-system-component"
            doc:context="oscal:system-implementation"
            id="has-this-system-component-diagnostic">This FedRAMP OSCAL SSP lacks a "this-system" component.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-system-id"
            doc:context="oscal:system-characteristics"
            id="has-system-id-diagnostic">This FedRAMP OSCAL SSP lacks a FedRAMP system-id.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-system-name"
            doc:context="oscal:system-characteristics"
            id="has-system-name-diagnostic">This FedRAMP OSCAL SSP lacks a system-name.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-system-name-short"
            doc:context="oscal:system-characteristics"
            id="has-system-name-short-diagnostic">This FedRAMP OSCAL SSP lacks a system-name-short.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-fedramp-authorization-type"
            doc:context="oscal:system-characteristics"
            id="has-fedramp-authorization-type-diagnostic">This FedRAMP OSCAL SSP lacks a FedRAMP authorization type.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="role-defined-system-owner"
            doc:context="oscal:metadata"
            id="role-defined-system-owner-diagnostic">The system-owner role is missing.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="role-defined-authorizing-official"
            doc:context="oscal:metadata"
            id="role-defined-authorizing-official-diagnostic">The authorizing-official role is missing.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="role-defined-system-poc-management"
            doc:context="oscal:metadata"
            id="role-defined-system-poc-management-diagnostic">The system-poc-management role is missing.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="role-defined-system-poc-technical"
            doc:context="oscal:metadata"
            id="role-defined-system-poc-technical-diagnostic">The system-poc-technical role is missing.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="role-defined-system-poc-other"
            doc:context="oscal:metadata"
            id="role-defined-system-poc-other-diagnostic">The system-poc-other role is missing.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="role-defined-information-system-security-officer"
            doc:context="oscal:metadata"
            id="role-defined-information-system-security-officer-diagnostic">The information-system-security-officer role is missing.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="role-defined-authorizing-official-poc"
            doc:context="oscal:metadata"
            id="role-defined-authorizing-official-poc-diagnostic">The authorizing-official-poc role is missing.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="role-has-title"
            doc:context="oscal:role"
            id="role-has-title-diagnostic">This role lacks a title.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="role-has-responsible-party"
            doc:context="oscal:role"
            id="role-has-responsible-party-diagnostic">This role has no responsible parties.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="responsible-party-has-role"
            doc:context="oscal:responsible-party"
            id="responsible-party-has-role-diagnostic">This responsible-party references a non-existent role.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="responsible-party-has-party-uuid"
            doc:context="oscal:responsible-party"
            id="responsible-party-has-party-uuid-diagnostic">This responsible-party lacks one or more party-uuid elements.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="responsible-party-has-definition"
            doc:context="oscal:responsible-party"
            id="responsible-party-has-definition-diagnostic">This responsible-party has a party-uuid for a non-existent party.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="responsible-party-is-person"
            doc:context="oscal:responsible-party"
            id="responsible-party-is-person-diagnostic">This responsible-party references a party which is not a person.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="party-has-responsibility"
            doc:context="oscal:party[@type eq 'person']"
            id="party-has-responsibility-diagnostic">This person has no responsibility.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="implemented-requirement-has-responsible-role"
            doc:context="oscal:implemented-requirement"
            id="implemented-requirement-has-responsible-role-diagnostic">This implemented-requirement lacks a responsible-role
            definition.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="responsible-role-has-role-definition"
            doc:context="oscal:responsible-role"
            id="responsible-role-has-role-definition-diagnostic">This responsible-role references a non-existent role definition.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="responsible-role-has-user"
            doc:context="oscal:responsible-role"
            id="responsible-role-has-user-diagnostic">This responsible-role lacks a system-implementation user assembly.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="distinct-responsible-role-has-user"
            doc:context="oscal:responsible-role"
            id="distinct-responsible-role-has-user-diagnostic">Some distinct responsible-role is not referenced in a system-implementation user
            assembly.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="role-id-has-role-definition"
            doc:context="oscal:role-id"
            id="role-id-has-role-definition-diagnostic">This role-id references a non-existent role definition.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="user-has-role-id"
            doc:context="oscal:user"
            id="user-has-role-id-diagnostic">This user lacks a role-id.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="user-has-user-type"
            doc:context="oscal:user"
            id="user-has-user-type-diagnostic">This user lacks a user type property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="user-has-privilege-level"
            doc:context="oscal:user"
            id="user-has-privilege-level-diagnostic">This user lacks a privilege-level property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="user-has-sensitivity-level"
            doc:context="oscal:user"
            id="user-has-sensitivity-level-diagnostic">This user lacks a sensitivity level property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="user-has-authorized-privilege"
            doc:context="oscal:user"
            id="user-has-authorized-privilege-diagnostic">This user lacks one or more authorized-privileges.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="user-user-type-has-allowed-value"
            doc:context="oscal:user/oscal:prop[@name eq 'type']"
            id="user-user-type-has-allowed-value-diagnostic">This user type property lacks an allowed value.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="user-privilege-level-has-allowed-value"
            doc:context="oscal:user/oscal:prop[@name eq 'privilege-level']"
            id="user-privilege-level-has-allowed-value-diagnostic">User privilege-level property has an allowed value.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="user-sensitivity-level-has-allowed-value"
            doc:context="oscal:user/oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal'][@name eq 'sensitivity']"
            id="user-sensitivity-level-has-allowed-value-diagnostic">This user sensitivity level property lacks an allowed value.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="authorized-privilege-has-title"
            doc:context="oscal:user/oscal:authorized-privilege"
            id="authorized-privilege-has-title-diagnostic">This authorized-privilege lacks a title.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="authorized-privilege-has-function-performed"
            doc:context="oscal:user/oscal:authorized-privilege"
            id="authorized-privilege-has-function-performed-diagnostic">This authorized-privilege lacks one or more
            function-performed.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="authorized-privilege-has-non-empty-title"
            doc:context="oscal:authorized-privilege/oscal:title"
            id="authorized-privilege-has-non-empty-title-diagnostic">This authorized-privilege title is empty.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="authorized-privilege-has-non-empty-function-performed"
            doc:context="oscal:authorized-privilege/oscal:function-performed"
            id="authorized-privilege-has-non-empty-function-performed-diagnostic">This authorized-privilege lacks a non-empty
            function-performed.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-authorization-boundary"
            doc:context="oscal:system-characteristics"
            id="has-authorization-boundary-diagnostic">This FedRAMP OSCAL SSP lacks an authorization-boundary in its
            system-characteristics.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-authorization-boundary-description"
            doc:context="oscal:authorization-boundary"
            id="has-authorization-boundary-description-diagnostic">This FedRAMP OSCAL SSP lacks an authorization-boundary
            description.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-authorization-boundary-diagram"
            doc:context="oscal:authorization-boundary"
            id="has-authorization-boundary-diagram-diagnostic">This FedRAMP OSCAL SSP lacks at least one authorization-boundary
            diagram.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-authorization-boundary-diagram-uuid"
            doc:context="oscal:authorization-boundary/oscal:diagram"
            id="has-authorization-boundary-diagram-uuid-diagnostic">This FedRAMP OSCAL SSP authorization-boundary diagram lacks a uuid
            attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-authorization-boundary-diagram-description"
            doc:context="oscal:authorization-boundary/oscal:diagram"
            id="has-authorization-boundary-diagram-description-diagnostic">This FedRAMP OSCAL SSP authorization-boundary diagram lacks a
            description.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-authorization-boundary-diagram-link"
            doc:context="oscal:authorization-boundary/oscal:diagram"
            id="has-authorization-boundary-diagram-link-diagnostic">This FedRAMP OSCAL SSP authorization-boundary diagram lacks a
            link.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-authorization-boundary-diagram-caption"
            doc:context="oscal:authorization-boundary/oscal:diagram"
            id="has-authorization-boundary-diagram-caption-diagnostic">This FedRAMP OSCAL SSP authorization-boundary diagram lacks a
            caption.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-authorization-boundary-diagram-link-rel"
            doc:context="oscal:authorization-boundary/oscal:diagram/oscal:link"
            id="has-authorization-boundary-diagram-link-rel-diagnostic">This FedRAMP OSCAL SSP authorization-boundary diagram lacks a link rel
            attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-authorization-boundary-diagram-link-rel-allowed-value"
            doc:context="oscal:authorization-boundary/oscal:diagram/oscal:link"
            id="has-authorization-boundary-diagram-link-rel-allowed-value-diagnostic">This FedRAMP OSCAL SSP authorization-boundary diagram lacks a
            link rel attribute with the value "diagram".</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-authorization-boundary-diagram-link-href-target"
            doc:context="oscal:authorization-boundary/oscal:diagram/oscal:link"
            id="has-authorization-boundary-diagram-link-href-target-diagnostic">This FedRAMP OSCAL SSP authorization-boundary diagram link does not
            reference a back-matter resource representing the diagram document.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-network-architecture"
            doc:context="oscal:system-characteristics"
            id="has-network-architecture-diagnostic">This FedRAMP OSCAL SSP lacks an network-architecture in its
            system-characteristics.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-network-architecture-description"
            doc:context="oscal:network-architecture"
            id="has-network-architecture-description-diagnostic">This FedRAMP OSCAL SSP lacks an network-architecture description.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-network-architecture-diagram"
            doc:context="oscal:network-architecture"
            id="has-network-architecture-diagram-diagnostic">This FedRAMP OSCAL SSP lacks at least one network-architecture diagram.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-network-architecture-diagram-uuid"
            doc:context="oscal:network-architecture/oscal:diagram"
            id="has-network-architecture-diagram-uuid-diagnostic">This FedRAMP OSCAL SSP network-architecture diagram lacks a uuid
            attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-network-architecture-diagram-description"
            doc:context="oscal:network-architecture/oscal:diagram"
            id="has-network-architecture-diagram-description-diagnostic">This FedRAMP OSCAL SSP network-architecture diagram lacks a
            description.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-network-architecture-diagram-link"
            doc:context="oscal:network-architecture/oscal:diagram"
            id="has-network-architecture-diagram-link-diagnostic">This FedRAMP OSCAL SSP network-architecture diagram lacks a link.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-network-architecture-diagram-caption"
            doc:context="oscal:network-architecture/oscal:diagram"
            id="has-network-architecture-diagram-caption-diagnostic">This FedRAMP OSCAL SSP network-architecture diagram lacks a
            caption.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-network-architecture-diagram-link-rel"
            doc:context="oscal:network-architecture/oscal:diagram/oscal:link"
            id="has-network-architecture-diagram-link-rel-diagnostic">This FedRAMP OSCAL SSP network-architecture diagram lacks a link rel
            attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-network-architecture-diagram-link-rel-allowed-value"
            doc:context="oscal:network-architecture/oscal:diagram/oscal:link"
            id="has-network-architecture-diagram-link-rel-allowed-value-diagnostic">This FedRAMP OSCAL SSP network-architecture diagram lacks a link
            rel attribute with the value "diagram".</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-network-architecture-diagram-link-href-target"
            doc:context="oscal:network-architecture/oscal:diagram/oscal:link"
            id="has-network-architecture-diagram-link-href-target-diagnostic">This FedRAMP OSCAL SSP network-architecture diagram link does not
            reference a back-matter resource representing the diagram document.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-data-flow"
            doc:context="oscal:system-characteristics"
            id="has-data-flow-diagnostic">This FedRAMP OSCAL SSP lacks an data-flow in its system-characteristics.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-data-flow-description"
            doc:context="oscal:data-flow"
            id="has-data-flow-description-diagnostic">This FedRAMP OSCAL SSP lacks an data-flow description.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-data-flow-diagram"
            doc:context="oscal:data-flow"
            id="has-data-flow-diagram-diagnostic">This FedRAMP OSCAL SSP lacks at least one data-flow diagram.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-data-flow-diagram-uuid"
            doc:context="oscal:data-flow/oscal:diagram"
            id="has-data-flow-diagram-uuid-diagnostic">This FedRAMP OSCAL SSP data-flow diagram lacks a uuid attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-data-flow-diagram-description"
            doc:context="oscal:data-flow/oscal:diagram"
            id="has-data-flow-diagram-description-diagnostic">This FedRAMP OSCAL SSP data-flow diagram lacks a description.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-data-flow-diagram-link"
            doc:context="oscal:data-flow/oscal:diagram"
            id="has-data-flow-diagram-link-diagnostic">This FedRAMP OSCAL SSP data-flow diagram lacks a link.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-data-flow-diagram-caption"
            doc:context="oscal:data-flow/oscal:diagram"
            id="has-data-flow-diagram-caption-diagnostic">This FedRAMP OSCAL SSP data-flow diagram lacks a caption.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-data-flow-diagram-link-rel"
            doc:context="oscal:data-flow/oscal:diagram/oscal:link"
            id="has-data-flow-diagram-link-rel-diagnostic">This FedRAMP OSCAL SSP data-flow diagram lacks a link rel attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-data-flow-diagram-link-rel-allowed-value"
            doc:context="oscal:data-flow/oscal:diagram/oscal:link"
            id="has-data-flow-diagram-link-rel-allowed-value-diagnostic">This FedRAMP OSCAL SSP data-flow diagram lacks a link rel attribute with the
            value "diagram".</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-data-flow-diagram-link-href-target"
            doc:context="oscal:data-flow/oscal:diagram/oscal:link"
            id="has-data-flow-diagram-link-href-target-diagnostic">This FedRAMP OSCAL SSP data-flow diagram link does not reference a back-matter
            resource representing the diagram document.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="system-security-plan-has-import-profile"
            doc:context="oscal:system-security-plan"
            id="system-security-plan-has-import-profile-diagnostic">This FedRAMP OSCAL SSP lacks an import-profile element.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="import-profile-has-href-attribute"
            doc:context="oscal:import-profile"
            id="import-profile-has-href-attribute-diagnostic">The import-profile element lacks an href attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="implemented-requirement-has-implementation-status"
            doc:context="oscal:implemented-requirement"
            id="implemented-requirement-has-implementation-status-diagnostic">This implemented-requirement lacks an
            implementation-status.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="implemented-requirement-has-planned-completion-date"
            doc:context="oscal:implemented-requirement"
            id="implemented-requirement-has-planned-completion-date-diagnostic">This planned control implementations lacks a planned completion
            date.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="implemented-requirement-has-control-origination"
            doc:context="oscal:implemented-requirement"
            id="implemented-requirement-has-control-origination-diagnostic">This implemented-requirement lacks a control-origination
            property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="implemented-requirement-has-allowed-control-origination"
            doc:context="oscal:implemented-requirement"
            id="implemented-requirement-has-allowed-control-origination-diagnostic">This implemented-requirement lacks an allowed control-origination
            property.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="implemented-requirement-has-leveraged-authorization"
            doc:context="oscal:implemented-requirement"
            id="implemented-requirement-has-leveraged-authorization-diagnostic">This implemented-requirement with a control-origination property of
            "inherited" does not reference a leveraged-authorization element in the same document.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="partial-implemented-requirement-has-plan"
            doc:context="oscal:implemented-requirement"
            id="partial-implemented-requirement-has-plan-diagnostic">This partially complete implemented-requirement is lacking an
            implementation-status of 'planned' and an accompanying date.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="implemented-requirement-has-allowed-composite-implementation-status"
            doc:context="oscal:implemented-requirement"
            id="implemented-requirement-has-allowed-composite-implementation-status-diagnostic">This implemented-requirement has an invalid
            implementation-status composition (<sch:value-of
                select="string-join((oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'implementation-status']/@value), ', ')" />)</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="implemented-requirement-has-allowed-implementation-status"
            doc:context="oscal:implemented-requirement"
            id="implemented-requirement-has-allowed-implementation-status-diagnostic" />
        <sch:diagnostic
            doc:assertion="implemented-requirement-has-implementation-status-remarks"
            doc:context="oscal:implemented-requirement"
            id="implemented-requirement-has-implementation-status-remarks-diagnostic">This incomplete control implementation lacks an
            explanation.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="planned-completion-date-is-valid"
            doc:context="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'planned-completion-date']"
            id="planned-completion-date-is-valid-diagnostic">This planned completion date is not valid.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="planned-completion-date-is-not-past"
            doc:context="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'planned-completion-date']"
            id="planned-completion-date-is-not-past-diagnostic">This planned completion date references a past time.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-cloud-service-model"
            doc:context="oscal:system-characteristics"
            id="has-cloud-service-model-diagnostic">A FedRAMP SSP must specify a cloud service model.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-allowed-cloud-service-model"
            doc:context="oscal:system-characteristics"
            id="has-allowed-cloud-service-model-diagnostic">A FedRAMP SSP must specify an allowed cloud service model.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-cloud-service-model-remarks"
            doc:context="oscal:system-characteristics"
            id="has-cloud-service-model-remarks-diagnostic">A FedRAMP SSP with a cloud service model of "other" must supply remarks.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-cloud-deployment-model"
            doc:context="oscal:system-characteristics"
            id="has-cloud-deployment-model-diagnostic">A FedRAMP SSP must specify a cloud deployment model.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-allowed-cloud-deployment-model"
            doc:context="oscal:system-characteristics"
            id="has-allowed-cloud-deployment-model-diagnostic">A FedRAMP SSP must specify an allowed cloud deployment model.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-cloud-deployment-model-remarks"
            doc:context="oscal:system-characteristics"
            id="has-cloud-deployment-model-remarks-diagnostic">A FedRAMP SSP with a cloud deployment model of "hybrid-cloud" must supply
            remarks.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-public-cloud-deployment-model"
            doc:context="oscal:system-characteristics"
            id="has-public-cloud-deployment-model-diagnostic">When a FedRAMP SSP has public components or inventory items, a cloud deployment model of
            "public-cloud" must be employed.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-allowed-interconnection-direction-value"
            doc:context="oscal:component[@type = 'interconnection']/oscal:prop[@name eq 'interconnection-direction']"
            id="interconnection-has-allowed-interconnection-direction-value-diagnostic">A system interconnection lacks an allowed
            interconnection-direction to explain data direction for information transmitted.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-allowed-interconnection-security-value"
            doc:context="oscal:component[@type = 'interconnection']/oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'interconnection-security']"
            id="interconnection-has-allowed-interconnection-security-value-diagnostic">A system interconnection lacks an allowed
            interconnection-security that explains what kind of methods are used to secure information transmitted while in transit.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-allowed-interconnection-security-remarks"
            doc:context="oscal:component[@type = 'interconnection']/oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'interconnection-security']"
            id="interconnection-has-allowed-interconnection-security-remarks-diagnostic">This system interconnection with an interconnection-security
            of &quot;other&quot; lacks explanatory remarks.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-title"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-title-diagnostic">This system interconnection lacks a remote system name.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-description"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-description-diagnostic">This system interconnection lacks a remote system description.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-direction"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-direction-diagnostic">This system interconnection lacks the direction of data flows.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-information"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-information-diagnostic">This system interconnection does not describe the information being
            transferred.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-protocol"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-protocol-diagnostic">A system interconnection does not describe the protocols used for information
            transfer.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-service-processor"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-service-processor-diagnostic">This system interconnection does not describe the service
            processor.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-local-IPv4-address"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-local-IPv4-address-diagnostic">This system interconnection does not specify the local (CSP) IPv4
            address.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-local-IPv6-address"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-local-IPv6-address-diagnostic">This system interconnection does not specify the local (CSP) IPv6
            address.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-remote-IPv4-address"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-remote-IPv4-address-diagnostic">This system interconnection does not specify the external system IPv4
            address.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-remote-IPv6-address"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-remote-IPv6-address-diagnostic">This system interconnection does not specify the external system IPv6
            address.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-connection-security"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-interconnection-security-diagnostic">This system interconnection does not specify how the connection is
            secured.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-circuit"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-circuit-diagnostic">This system interconnection does not specify the port or circuit used.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-isa-poc-local"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-isa-poc-local-diagnostic">This system interconnection does not specify a responsible local (CSP) point of
            contact.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-isa-poc-remote"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-isa-poc-remote-diagnostic">This system interconnection does not specify a responsible remote point of
            contact.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-isa-authorizing-official-local"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-isa-authorizing-official-local-diagnostic">This system interconnection does not specify a local authorizing
            official.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-isa-authorizing-official-remote"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-isa-authorizing-official-remote-diagnostic">This system interconnection does not specify a remote authorizing
            official.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-responsible-persons"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-responsible-persons-diagnostic">Not every responsible person for this system interconnect is
            defined.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-distinct-isa-local"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-distinct-isa-local-diagnostic">This system interconnection has local responsible parties which are also remote
            responsible parties.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-has-distinct-isa-remote"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-has-distinct-isa-remote-diagnostic">This system interconnection has remote responsible parties which are also local
            responsible parties.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-cites-interconnection-agreement"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-cites-interconnection-agreement-diagnostic">This system interconnection does not cite an interconnection
            agreement.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-cites-interconnection-agreement-href"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-cites-interconnection-agreement-href-diagnostic">This system interconnection does not cite an intra-document defined
            interconnection agreement.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-cites-attached-interconnection-agreement"
            doc:context="oscal:component[@type eq 'interconnection']"
            id="interconnection-cites-attached-interconnection-agreement-diagnostic">This system interconnection cites an absent interconnection
            agreement.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-protocol-has-name"
            doc:context="oscal:component[@type eq 'interconnection']/oscal:protocol"
            id="interconnection-protocol-has-name-diagnostic">This system interconnection protocol lacks a name.</sch:diagnostic>
        <sch:diagnostic
            doc:context="oscal:component[@type eq 'interconnection']/oscal:protocol"
            id="interconnection-protocol-has-port-range-diagnostic">This system interconnection protocol lacks one or more port range
            declarations.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-protocol-port-range-has-transport"
            doc:context="oscal:component[@type eq 'interconnection']/oscal:protocol/oscal:port-range"
            id="interconnection-protocol-port-range-has-transport-diagnostic">\his system interconnection protocol port range declaration does not
            state a transport protocol.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-protocol-port-range-has-start"
            doc:context="oscal:component[@type eq 'interconnection']/oscal:protocol/oscal:port-range"
            id="interconnection-protocol-port-range-has-start-diagnostic">A system interconnection protocol port range declaration does not state a
            starting port number.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="interconnection-protocol-port-range-has-end"
            doc:context="oscal:component[@type eq 'interconnection']/oscal:protocol/oscal:port-range"
            id="interconnection-protocol-port-range-has-end-diagnostic">A system interconnection protocol port range declaration does not state an
            ending port number.</sch:diagnostic>
    </sch:diagnostics>
</sch:schema>
