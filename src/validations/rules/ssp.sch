<?xml version="1.0" encoding="utf-8"?>
<sch:schema queryBinding="xslt2"
            xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
            xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
            xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <sch:ns prefix="f"
            uri="https://fedramp.gov/ns/oscal" />
    <sch:ns prefix="o"
            uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns prefix="oscal"
            uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns prefix="fedramp"
            uri="https://fedramp.gov/ns/oscal" />
    <sch:ns prefix="lv"
            uri="local-validations" />
    <sch:phase id="Phase2">
        <sch:active pattern="phase2" />
    </sch:phase>
    <sch:phase id="Phase3">
        <sch:active pattern="resources" />
        <sch:active pattern="base64" />
        <sch:active pattern="specific-attachments" />
        <sch:active pattern="policy-and-procedure" />
        <sch:active pattern="privacy1" />
        <sch:active pattern="privacy2" />
        <sch:active pattern="fips-140" />
        <sch:active pattern="fips-199" />
        <sch:active pattern="sp800-60" />
        <sch:active pattern="sp800-63" />
        <sch:active pattern="system-inventory" />
        <sch:active pattern="basic-system-characteristics" />
        <sch:active pattern="general-roles" />
        <sch:active pattern="implementation-roles" />
        <sch:active pattern="user-properties" />
        <sch:active pattern="authorization-boundary" />
        <sch:active pattern="network-architecture" />
        <sch:active pattern="data-flow" />
        <sch:active pattern="control-implementation" />
    </sch:phase>
    <sch:phase id="attachments">
        <sch:active pattern="resources" />
        <sch:active pattern="base64" />
        <sch:active pattern="specific-attachments" />
        <sch:active pattern="policy-and-procedure" />
        <sch:active pattern="authorization-boundary" />
        <sch:active pattern="network-architecture" />
        <sch:active pattern="data-flow" />
    </sch:phase>
    <sch:phase id="privacy">
        <sch:active pattern="privacy1" />
        <sch:active pattern="privacy2" />
    </sch:phase>
    <sch:phase id="inventory">
        <sch:active pattern="system-inventory" />
    </sch:phase>
    <sch:phase id="diagrams">
        <sch:active pattern="authorization-boundary" />
        <sch:active pattern="network-architecture" />
        <sch:active pattern="data-flow" />
    </sch:phase>
    <sch:phase id="roles">
        <sch:active pattern="general-roles" />
        <sch:active pattern="implementation-roles" />
        <sch:active pattern="user-properties" />
    </sch:phase>
    <doc:xspec href="../test/ssp.xspec" />
    <sch:title>FedRAMP System Security Plan Validations</sch:title>
    <xsl:output encoding="UTF-8"
                indent="yes"
                method="xml" />
    <xsl:param as="xs:string"
               name="registry-base-path"
               select="'../../content/resources/xml'" />
    <xsl:param as="xs:string"
               name="baselines-base-path"
               select="'../../../dist/content/baselines/rev4/xml'" />
    <sch:let name="registry"
             value="doc(concat($registry-base-path, '/fedramp_values.xml')) | doc(concat($registry-base-path, '/fedramp_threats.xml')) | doc(concat($registry-base-path, '/information-types.xml'))" />
    <!--xsl:variable name="registry">
        <xsl:sequence select="doc(concat($registry-base-path, '/fedramp_values.xml')) | 
                              doc(concat($registry-base-path, '/fedramp_threats.xml')) |
                              doc(concat($registry-base-path, '/information-types.xml'))"/>
    </xsl:variable-->
    <xsl:function name="lv:if-empty-default">
        <xsl:param name="item" />
        <xsl:param name="default" />
        <xsl:choose>
            <!-- Atomic types, integers, strings, et cetera. -->
            <xsl:when test="$item instance of xs:untypedAtomic or $item instance of xs:anyURI or $item instance of xs:string or $item instance of xs:QName or $item instance of xs:boolean or $item instance of xs:base64Binary or $item instance of xs:hexBinary or $item instance of xs:integer or $item instance of xs:decimal or $item instance of xs:float or $item instance of xs:double or $item instance of xs:date or $item instance of xs:time or $item instance of xs:dateTime or $item instance of xs:dayTimeDuration or $item instance of xs:yearMonthDuration or $item instance of xs:duration or $item instance of xs:gMonth or $item instance of xs:gYear or $item instance of xs:gYearMonth or $item instance of xs:gDay or $item instance of xs:gMonthDay">

                <xsl:value-of select="
                        if ($item =&gt; string() =&gt; normalize-space() = '') then
                            $default
                        else
                            $item" />
            </xsl:when>
            <!-- Any node-kind that can be a sequence type -->
            <xsl:when test="$item instance of element() or $item instance of attribute() or $item instance of text() or $item instance of node() or $item instance of document-node() or $item instance of comment() or $item instance of processing-instruction()">

                <xsl:sequence select="
                        if ($item =&gt; normalize-space() =&gt; not()) then
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
                <xsl:sequence select="()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function as="item()*"
                  name="lv:registry">
        <xsl:sequence select="$registry" />
    </xsl:function>
    <xsl:function as="xs:string"
                  name="lv:sensitivity-level">
        <xsl:param as="node()*"
                   name="context" />
        <xsl:value-of select="$context//o:security-sensitivity-level" />
    </xsl:function>
    <xsl:function as="document-node()*"
                  name="lv:profile">
        <xsl:param name="level" />
        <xsl:variable name="profile-map">
            <profile href="{concat($baselines-base-path, '/FedRAMP_rev4_LOW-baseline-resolved-profile_catalog.xml')}"
                     level="low" />
            <profile href="{concat($baselines-base-path, '/FedRAMP_rev4_MODERATE-baseline-resolved-profile_catalog.xml')}"
                     level="moderate" />
            <profile href="{concat($baselines-base-path, '/FedRAMP_rev4_HIGH-baseline-resolved-profile_catalog.xml')}"
                     level="high" />
        </xsl:variable>
        <xsl:variable name="href"
                      select="$profile-map/profile[@level = $level]/@href" />
        <xsl:sequence select="doc(resolve-uri($href))" />
    </xsl:function>
    <xsl:function name="lv:correct">
        <xsl:param as="element()*"
                   name="value-set" />
        <xsl:param as="node()*"
                   name="value" />
        <xsl:variable name="values"
                      select="$value-set/f:allowed-values/f:enum/@value" />
        <xsl:choose>
            <!-- If allow-other is set, anything is valid. -->
            <xsl:when test="$value-set/f:allowed-values/@allow-other = 'no' and $value = $values" />
            <xsl:otherwise>
                <xsl:value-of select="$values"
                              separator=", " />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="lv:analyze">
        <xsl:param as="element()*"
                   name="value-set" />
        <xsl:param as="element()*"
                   name="element" />
        <xsl:choose>
            <xsl:when test="$value-set/f:allowed-values/f:enum/@value">
                <xsl:sequence>
                    <xsl:call-template name="analysis-template">
                        <xsl:with-param name="value-set"
                                        select="$value-set" />
                        <xsl:with-param name="element"
                                        select="$element" />
                    </xsl:call-template>
                </xsl:sequence>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message expand-text="yes">error</xsl:message>
                <xsl:sequence>
                    <xsl:call-template name="analysis-template">
                        <xsl:with-param name="value-set"
                                        select="$value-set" />
                        <xsl:with-param name="element"
                                        select="$element" />
                        <xsl:with-param name="errors">
                            <error>value-set was malformed</error>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:sequence>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function as="xs:string"
                  name="lv:report">
        <xsl:param as="element()*"
                   name="analysis" />
        <xsl:variable as="xs:string"
                      name="results">
            <xsl:call-template name="report-template">
                <xsl:with-param name="analysis"
                                select="$analysis" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$results" />
    </xsl:function>
    <xsl:template as="element()"
                  name="analysis-template">
        <xsl:param as="element()*"
                   name="value-set" />
        <xsl:param as="element()*"
                   name="element" />
        <xsl:param as="node()*"
                   name="errors" />
        <xsl:variable name="ok-values"
                      select="$value-set/f:allowed-values/f:enum/@value" />
        <analysis>
            <errors>
                <xsl:if test="$errors">
                    <xsl:sequence select="$errors" />
                </xsl:if>
            </errors>
            <reports count="{count($element)}"
                     description="{$value-set/f:description}"
                     formal-name="{$value-set/f:formal-name}"
                     name="{$value-set/@name}">
                <xsl:for-each select="$ok-values">
                    <xsl:variable name="match"
                                  select="$element[@value = current()]" />
                    <report count="{count($match)}"
                            value="{current()}" />
                </xsl:for-each>
            </reports>
        </analysis>
    </xsl:template>
    <xsl:template as="xs:string"
                  name="report-template">
        <xsl:param as="element()*"
                   name="analysis" />
        <xsl:value-of>There are 
        <xsl:value-of select="$analysis/reports/@count" />  
        <xsl:value-of select="$analysis/reports/@formal-name" />
        <xsl:choose>
            <xsl:when test="$analysis/reports/report">items total, with</xsl:when>
            <xsl:otherwise>items total.</xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="$analysis/reports/report">
            <xsl:if test="position() gt 0 and not(position() eq last())">
            <xsl:value-of select="current()/@count" />set as 
            <xsl:value-of select="current()/@value" />,</xsl:if>
            <xsl:if test="position() gt 0 and position() eq last()">and 
            <xsl:value-of select="current()/@count" />set as 
            <xsl:value-of select="current()/@value" />.</xsl:if>
            <xsl:sequence select="." />
        </xsl:for-each>There are 
        <xsl:value-of select="($analysis/reports/@count - sum($analysis/reports/report/@count))" />invalid items. 
        <xsl:if test="count($analysis/errors/error) &gt; 0">
            <xsl:message expand-text="yes">hit error block</xsl:message>
            <xsl:for-each select="$analysis/errors/error">Also, 
            <xsl:value-of select="current()/text()" />, so analysis could be inaccurate or it completely failed.</xsl:for-each>
        </xsl:if></xsl:value-of>
    </xsl:template>
    <sch:pattern id="phase2">
        <sch:rule context="/o:system-security-plan">
            <sch:let name="ok-values"
                     value="$registry/f:fedramp-values/f:value-set[@name = 'security-level']" />
            <sch:let name="sensitivity-level"
                     value="/ =&gt; lv:sensitivity-level() =&gt; lv:if-empty-default('')" />
            <sch:let name="corrections"
                     value="lv:correct($ok-values, $sensitivity-level)" />
            <sch:assert diagnostics="no-registry-values-diagnostic"
                        id="no-registry-values"
                        role="fatal"
                        test="count($registry/f:fedramp-values/f:value-set) &gt; 0">The registry values are available.</sch:assert>
            <sch:assert diagnostics="no-security-sensitivity-level-diagnostic"
                        doc:checklist-reference="Section C Check 1.a"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.2"
                        doc:organizational-id="section-c.1.a"
                        id="no-security-sensitivity-level"
                        role="fatal"
                        test="$sensitivity-level != ''">[Section C Check 1.a] Sensitivity level is defined.</sch:assert>
            <sch:assert diagnostics="invalid-security-sensitivity-level-diagnostic"
                        doc:checklist-reference="Section C Check 1.a"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.2"
                        doc:organizational-id="section-c.1.a"
                        id="invalid-security-sensitivity-level"
                        role="fatal"
                        test="empty($ok-values) or not(exists($corrections))">[Section C Check 1.a] Sensitivity level has an allowed
                        value.</sch:assert>
            <sch:let name="implemented"
                     value="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement" />
            <sch:report doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5"
                        id="implemented-response-points"
                        role="information"
                        test="exists($implemented)">[Section C Check 2] A FedRAMP SSP must implement a statement for each of the following lettered
                        response points for required controls: 
            <sch:value-of select="$implemented/@statement-id" />.</sch:report>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5">
            <sch:let name="registry-ns"
                     value="$registry/f:fedramp-values/f:namespace/f:ns/@ns" />
            <sch:let name="sensitivity-level"
                     value="/ =&gt; lv:sensitivity-level()" />
            <sch:let name="ok-values"
                     value="$registry/f:fedramp-values/f:value-set[@name = 'control-implementation-status']" />
            <sch:let name="selected-profile"
                     value="$sensitivity-level =&gt; lv:profile()" />
            <sch:let name="required-controls"
                     value="$selected-profile/*//o:control" />
            <sch:let name="implemented"
                     value="o:implemented-requirement" />
            <sch:let name="all-missing"
                     value="$required-controls[not(@id = $implemented/@control-id)]" />
            <sch:let name="core-missing"
                     value="$required-controls[o:prop[@name = 'CORE' and @ns = $registry-ns] and @id = $all-missing/@id]" />
            <sch:let name="extraneous"
                     value="$implemented[not(@control-id = $required-controls/@id)]" />
            <sch:report doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5"
                        id="each-required-control-report"
                        role="information"
                        test="count($required-controls) &gt; 0">The following 
            <sch:value-of select="count($required-controls)" />
            <sch:value-of select="
                        if (count($required-controls) = 1) then
                            ' control'
                        else
                            ' controls'" />are required: 
            <sch:value-of select="$required-controls/@id" />.</sch:report>
            <sch:assert diagnostics="incomplete-core-implemented-requirements-diagnostic"
                        doc:checklist-reference="Section C Check 3"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5"
                        doc:organizational-id="section-c.3"
                        id="incomplete-core-implemented-requirements"
                        role="error"
                        test="not(exists($core-missing))">A FedRAMP SSP must implement the most important controls.</sch:assert>
            <sch:assert diagnostics="incomplete-all-implemented-requirements-diagnostic"
                        doc:checklist-reference="Section C Check 2"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5"
                        doc:organizational-id="section-c.2"
                        id="incomplete-all-implemented-requirements"
                        role="warning"
                        test="not(exists($all-missing))">[Section C Check 2] A FedRAMP SSP must implement all required controls.</sch:assert>
            <sch:assert diagnostics="extraneous-implemented-requirements-diagnostic"
                        doc:checklist-reference="Section C Check 2"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5"
                        doc:organizational-id="section-c.2"
                        id="extraneous-implemented-requirements"
                        role="warning"
                        test="not(exists($extraneous))">[Section C Check 2] A FedRAMP SSP must have no extraneous implemented controls.</sch:assert>
            <sch:let name="results"
                     value="$ok-values =&gt; lv:analyze(//o:implemented-requirement/o:prop[@name = 'implementation-status'])" />
            <sch:let name="total"
                     value="$results/reports/@count" />
            <sch:report doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5"
                        id="control-implemented-requirements-stats"
                        role="information"
                        test="count($results/errors/error) = 0">
            <sch:value-of select="$results =&gt; lv:report() =&gt; normalize-space()" />.</sch:report>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement">
            <sch:let name="sensitivity-level"
                     value="/ =&gt; lv:sensitivity-level() =&gt; lv:if-empty-default('')" />
            <sch:let name="selected-profile"
                     value="$sensitivity-level =&gt; lv:profile()" />
            <sch:let name="registry-ns"
                     value="$registry/f:fedramp-values/f:namespace/f:ns/@ns" />
            <sch:let name="status"
                     value="./o:prop[@name = 'implementation-status']/@value" />
            <sch:let name="corrections"
                     value="lv:correct($registry/f:fedramp-values/f:value-set[@name = 'control-implementation-status'], $status)" />
            <sch:let name="required-response-points"
                     value="$selected-profile/o:catalog//o:part[@name = 'item']" />
            <sch:let name="implemented"
                     value="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement" />
            <sch:let name="missing"
                     value="$required-response-points[not(@id = $implemented/@statement-id)]" />
            <sch:assert diagnostics="invalid-implementation-status-diagnostic"
                        doc:checklist-reference="Section C Check 2"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5"
                        doc:organizational-id="section-c.2"
                        id="invalid-implementation-status"
                        role="error"
                        test="not(exists($corrections))">[Section C Check 2] Implementation status is correct.</sch:assert>
            <sch:assert diagnostics="missing-response-points-diagnostic"
                        doc:checklist-reference="Section C Check 2"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5"
                        doc:organizational-id="section-c.2"
                        id="missing-response-points"
                        role="error"
                        test="not(exists($missing))">[Section C Check 2] A FedRAMP SSP must have required response points.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement">
            <sch:let name="required-components-count"
                     value="1" />
            <sch:let name="required-length"
                     value="20" />
            <sch:let name="components-count"
                     value="./o:by-component =&gt; count()" />
            <sch:let name="remarks"
                     value="./o:remarks =&gt; normalize-space()" />
            <sch:let name="remarks-length"
                     value="$remarks =&gt; string-length()" />
            <sch:assert diagnostics="missing-response-components-diagnostic"
                        doc:checklist-reference="Section D Checks"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5"
                        doc:organizational-id="section-d"
                        id="missing-response-components"
                        role="warning"
                        test="$components-count &gt;= $required-components-count">[Section D Checks] Response statements have sufficient
                        components.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:description">
            <sch:assert diagnostics="extraneous-response-description-diagnostic"
                        doc:checklist-reference="Section D Checks"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5"
                        doc:organizational-id="section-d"
                        id="extraneous-response-description"
                        role="warning"
                        test=". =&gt; empty()">[Section D Checks] Response statement does not have a description not within a component.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:remarks">
            <sch:assert diagnostics="extraneous-response-remarks-diagnostic"
                        doc:checklist-reference="Section D Checks"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5"
                        doc:organizational-id="section-d"
                        id="extraneous-response-remarks"
                        role="warning"
                        test=". =&gt; empty()">[Section D Checks] Response statement does not have remarks not within a component.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component">
            <sch:let name="component-ref"
                     value="./@component-uuid" />
            <sch:assert diagnostics="invalid-component-match-diagnostic"
                        doc:checklist-reference="Section D Checks"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5"
                        doc:organizational-id="section-d"
                        id="invalid-component-match"
                        role="warning"
                        test="/o:system-security-plan/o:system-implementation/o:component[@uuid = $component-ref] =&gt; exists()">[Section D Checks]
                        Response statement cites a component in the system implementation inventory.</sch:assert>
            <sch:assert diagnostics="missing-component-description-diagnostic"
                        doc:checklist-reference="Section D Checks"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5"
                        doc:organizational-id="section-d"
                        id="missing-component-description"
                        role="error"
                        test="./o:description =&gt; exists()">[Section D Checks] Response statement has a component which has a required description
                        node.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:description">
            <sch:let name="required-length"
                     value="20" />
            <sch:let name="description"
                     value=". =&gt; normalize-space()" />
            <sch:let name="description-length"
                     value="$description =&gt; string-length()" />
            <sch:assert diagnostics="incomplete-response-description-diagnostic"
                        doc:checklist-reference="Section D Checks"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5"
                        doc:organizational-id="section-d"
                        id="incomplete-response-description"
                        role="error"
                        test="$description-length &gt;= $required-length">[Section D Checks] Response statement component description has adequate
                        length.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:remarks">
            <sch:let name="required-length"
                     value="20" />
            <sch:let name="remarks"
                     value=". =&gt; normalize-space()" />
            <sch:let name="remarks-length"
                     value="$remarks =&gt; string-length()" />
            <sch:assert diagnostics="incomplete-response-remarks-diagnostic"
                        doc:checklist-reference="Section D Checks"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5"
                        doc:organizational-id="section-d"
                        id="incomplete-response-remarks"
                        role="warning"
                        test="$remarks-length &gt;= $required-length">[Section D Checks] Response statement component remarks have adequate
                        length.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:metadata">
            <sch:let name="parties"
                     value="o:party" />
            <sch:let name="roles"
                     value="o:role" />
            <sch:let name="responsible-parties"
                     value="./o:responsible-party" />
            <sch:let name="extraneous-roles"
                     value="$responsible-parties[not(@role-id = $roles/@id)]" />
            <sch:let name="extraneous-parties"
                     value="$responsible-parties[not(o:party-uuid = $parties/@uuid)]" />
            <sch:assert diagnostics="incorrect-role-association-diagnostic"
                        doc:checklist-reference="Section C Check 2"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                        doc:organizational-id="section-c.6"
                        id="incorrect-role-association"
                        role="error"
                        test="not(exists($extraneous-roles))">[Section C Check 2] A FedRAMP SSP must define a responsible party with no extraneous
                        roles.</sch:assert>
            <sch:assert diagnostics="incorrect-party-association-diagnostic"
                        doc:checklist-reference="Section C Check 2"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                        doc:organizational-id="section-c.6"
                        id="incorrect-party-association"
                        role="error"
                        test="not(exists($extraneous-parties))">[Section C Check 2] A FedRAMP SSP must define a responsible party with no extraneous
                        parties.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:back-matter/o:resource">
            <sch:assert diagnostics="resource-uuid-required-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6"
                        doc:organizational-id="section-b.?????"
                        id="resource-uuid-required"
                        role="error"
                        test="@uuid">Every resource has a uuid attribute.</sch:assert>
        </sch:rule>
        <!-- The following rule is commented out because doc-available does not provide the desired existence check -->
        <!--<sch:rule
            context="/o:system-security-plan/o:back-matter/o:resource/o:rlink">
            <sch:assert
                diagnostics="resource-rlink-required-diagnostic"
                doc:organizational-id="section-b.?????"
                id="resource-rlink-required"
                role="error"
                test="doc-available(./@href)">A FedRAMP SSP must references back-matter resource: <sch:value-of
                    select="./@href" /></sch:assert>
        </sch:rule>-->
        <sch:rule context="/o:system-security-plan/o:back-matter/o:resource/o:base64"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP Content §4.10">
            <sch:let name="filename"
                     value="@filename" />
            <sch:let name="media-type"
                     value="@media-type" />
            <sch:assert diagnostics="resource-base64-available-filename-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP Content §4.10"
                        doc:organizational-id="section-b.?????"
                        id="resource-base64-available-filename"
                        role="error"
                        test="./@filename">This base64 has a filename attribute.</sch:assert>
            <sch:assert diagnostics="resource-base64-available-media-type-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP Content §4.10"
                        doc:organizational-id="section-b.?????"
                        id="resource-base64-available-media-type"
                        role="error"
                        test="./@media-type">This base64 has a media-type attribute.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <!-- set $fedramp-values globally -->
    <sch:let name="fedramp-values"
             value="doc(concat($registry-base-path, '/fedramp_values.xml'))" />
    <!-- ↑ stage 2 content ↑ -->
    <!-- ↓ stage 3 content ↓ -->
    <sch:pattern id="resources">
        <sch:title>Basic resource constraints</sch:title>
        <sch:let name="attachment-types"
                 value="$fedramp-values//fedramp:value-set[@name = 'attachment-type']//fedramp:enum/@value" />
        <sch:rule context="oscal:resource"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6">
            <!-- the following assertion recapitulates the XML Schema constraint -->
            <sch:assert diagnostics="resource-has-uuid-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                        id="resource-has-uuid"
                        role="error"
                        test="@uuid">A resource must have a uuid attribute.</sch:assert>
            <sch:assert diagnostics="resource-has-title-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                        id="resource-has-title"
                        role="warning"
                        test="oscal:title">A resource should have a title.</sch:assert>
            <sch:assert diagnostics="resource-has-rlink-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                        id="resource-has-rlink"
                        role="error"
                        test="oscal:rlink">A resource must have a rlink element</sch:assert>
            <sch:assert diagnostics="resource-is-referenced-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                        id="resource-is-referenced"
                        role="information"
                        test="@uuid = (//@href[matches(., '^#')] ! substring-after(., '#'))">A resource should be referenced from within the
                        document.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:back-matter/oscal:resource/oscal:prop[@name = 'type']"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1">
            <sch:assert diagnostics="attachment-type-is-valid-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                        id="attachment-type-is-valid"
                        role="warning"
                        test="@value = $attachment-types">A resource should have an allowed attachment-type property.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:back-matter/oscal:resource/oscal:rlink">
            <sch:assert diagnostics="rlink-has-href-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                        id="rlink-has-href"
                        role="error"
                        test="@href">A resource rlink must have an href attribute.</sch:assert>
            <!-- Both doc-avail() and unparsed-text-available() are failing on arbitrary hrefs -->
            <!--<sch:assert test="unparsed-text-available(@href)">the &lt;<sch:name/>&gt; element href attribute refers to a non-existent
                document</sch:assert>-->
            <!--<sch:assert id="rlink-has-media-type"
                role="warning"
                test="$WARNING and @media-type">the &lt;<sch:name/>&gt; element should have a media-type attribute</sch:assert>-->
        </sch:rule>
        <sch:rule context="oscal:rlink | oscal:base64"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                  role="error">
            <sch:let name="media-types"
                     value="$fedramp-values//fedramp:value-set[@name = 'media-type']//fedramp:enum/@value" />
            <!--<sch:report role="information"
                        test="false()">There are 
            <sch:value-of select="count($media-types)" />media types.</sch:report>-->
            <sch:assert diagnostics="has-allowed-media-type-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                        id="has-allowed-media-type"
                        role="error"
                        test="@media-type = $media-types">A media-type attribute must have an allowed value.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                 id="base64">
        <sch:title>base64 attachments</sch:title>
        <sch:rule context="oscal:back-matter/oscal:resource"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1">
            <sch:assert diagnostics="resource-has-base64-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                        id="resource-has-base64"
                        role="warning"
                        test="oscal:base64">A resource should have a base64 element.</sch:assert>
            <sch:assert diagnostics="resource-base64-cardinality-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                        id="resource-has-base64-cardinality"
                        role="error"
                        test="not(oscal:base64[2])">A resource must have only one base64 element.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:back-matter/oscal:resource/oscal:base64"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1">
            <sch:assert diagnostics="base64-has-filename-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                        id="base64-has-filename"
                        role="error"
                        test="@filename">A base64 element must have a filename attribute.</sch:assert>
            <sch:assert diagnostics="base64-has-media-type-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                        id="base64-has-media-type"
                        role="error"
                        test="@media-type">A base64 element must have a media-type attribute.</sch:assert>
            <sch:assert diagnostics="base64-has-content-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.1"
                        id="base64-has-content"
                        role="error"
                        test="matches(normalize-space(), '^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$')">A
                        base64 element must have content.</sch:assert>
            <!-- FYI: http://expath.org/spec/binary#decode-string handles base64 but Saxon-PE or higher is necessary -->
        </sch:rule>
    </sch:pattern>
    <sch:pattern id="specific-attachments">
        <sch:title>Constraints for specific attachments</sch:title>
        <sch:rule context="oscal:back-matter"
                  doc:guide-reference="https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf"
                  see="https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf">
            <sch:assert diagnostics="has-fedramp-acronyms-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP Content §4.8"
                        doc:template-reference="System Security Plan Template §14"
                        id="has-fedramp-acronyms"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-acronyms']]">A
                        FedRAMP OSCAL SSP must have the FedRAMP Master Acronym and Glossary attached.</sch:assert>
            <sch:assert diagnostics="has-fedramp-citations-diagnostic"
                        doc:attachment="§15 Attachment 12"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP Content §4.10"
                        id="has-fedramp-citations"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-citations']]">
                        [Section B Check 3.12] A FedRAMP OSCAL SSP must have the FedRAMP Applicable Laws and Regulations attached.</sch:assert>
            <sch:assert diagnostics="has-fedramp-logo-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP Content §4.1"
                        id="has-fedramp-logo"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-logo']]">A
                        FedRAMP OSCAL SSP must have the FedRAMP Logo attached.</sch:assert>
            <sch:assert diagnostics="has-user-guide-diagnostic"
                        doc:attachment="§15 Attachment 2"
                        doc:checklist-reference="Section B Check 3.2"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6"
                        doc:template-reference="System Security Plan Template §15"
                        id="has-user-guide"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'user-guide']]">[Section
                        B Check 3.2] A FedRAMP OSCAL SSP must have a User Guide attached.</sch:assert>
            <sch:assert diagnostics="has-rules-of-behavior-diagnostic"
                        doc:attachment="§15 Attachment 5"
                        doc:checklist-reference="Section B Check 3.5"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6"
                        doc:template-reference="System Security Plan Template §15"
                        id="has-rules-of-behavior"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'rules-of-behavior']]">
                        [Section B Check 3.5] A FedRAMP OSCAL SSP must have Rules of Behavior.</sch:assert>
            <sch:assert diagnostics="has-information-system-contingency-plan-diagnostic"
                        doc:attachment="§15 Attachment 6"
                        doc:checklist-reference="Section B Check 3.6"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6"
                        doc:template-reference="System Security Plan Template §15"
                        id="has-information-system-contingency-plan"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'information-system-contingency-plan']]">
            [Section B Check 3.6] A FedRAMP OSCAL SSP must have a Contingency Plan attached.</sch:assert>
            <sch:assert diagnostics="has-configuration-management-plan-diagnostic"
                        doc:attachment="§15 Attachment 7"
                        doc:checklist-reference="Section B Check 3.7"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6"
                        doc:template-reference="System Security Plan Template §15"
                        id="has-configuration-management-plan"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'configuration-management-plan']]">
                        [Section B Check 3.7] A FedRAMP OSCAL SSP must have a Configuration Management Plan attached.</sch:assert>
            <sch:assert diagnostics="has-incident-response-plan-diagnostic"
                        doc:attachment="§15 Attachment 8"
                        doc:checklist-reference="Section B Check 3.8"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6"
                        doc:template-reference="System Security Plan Template §15"
                        id="has-incident-response-plan"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'incident-response-plan']]">
                        [Section B Check 3.8] A FedRAMP OSCAL SSP must have an Incident Response Plan attached.</sch:assert>
            <!-- Section B Check 3.9 is not used -->
            <!-- Section B Check 3.10 is not used -->
            <sch:assert diagnostics="has-separation-of-duties-matrix-diagnostic"
                        doc:attachment="§15 Attachment 11"
                        doc:checklist-reference="Section B Check 3.11"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6"
                        doc:template-reference="System Security Plan Template §15"
                        id="has-separation-of-duties-matrix"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'separation-of-duties-matrix']]">
                        [Section B Check 3.11] A FedRAMP OSCAL SSP must have a Separation of Duties Matrix attached.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6"
                 doc:template-reference="System Security Plan Template §15"
                 id="policy-and-procedure">
        <sch:title>Policy and Procedure attachments</sch:title>
        <sch:title>A FedRAMP SSP must incorporate one policy document and one procedure document for each of the 17 NIST SP 800-54 Revision 4 control
        families</sch:title>
        <!-- TODO: handle attachments declared by component (see implemented-requirement ac-1 for an example) -->
        <!-- FIXME: XSpec testing malfunctions when the following rule context is constrained to XX-1 control-ids -->
        <sch:rule context="oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')]"
                  doc:attachment="§15 Attachment 1"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6"
                  doc:template-reference="System Security Plan Template §15"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6">
            <sch:assert diagnostics="has-policy-link-diagnostic"
                        doc:checklist-reference="Section B Check 3.1"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6"
                        doc:template-reference="System Security Plan Template §15"
                        id="has-policy-link"
                        role="error"
                        test="descendant::oscal:by-component/oscal:link[@rel = 'policy']">[Section B Check 3.1] A FedRAMP SSP must incorporate a
                        policy document for each of the 17 NIST SP 800-54 Revision 4 control families.</sch:assert>
            <sch:let name="policy-hrefs"
                     value="distinct-values(descendant::oscal:by-component/oscal:link[@rel = 'policy']/@href ! substring-after(., '#'))" />
            <sch:assert diagnostics="has-policy-attachment-resource-diagnostic"
                        doc:checklist-reference="Section B Check 3.1"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6"
                        doc:template-reference="System Security Plan Template §15"
                        id="has-policy-attachment-resource"
                        role="error"
                        test="
                    every $ref in $policy-hrefs
                        satisfies exists(//oscal:resource[oscal:prop[@name = 'type' and @value = 'policy']][@uuid = $ref])">[Section B Check 3.1] A
FedRAMP SSP must incorporate a policy document for each of the 17 NIST SP 800-54 Revision 4 control families.</sch:assert>
            <!-- TODO: ensure resource has an rlink -->
            <sch:assert diagnostics="has-procedure-link-diagnostic"
                        doc:checklist-reference="Section B Check 3.1"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6"
                        doc:template-reference="System Security Plan Template §15"
                        id="has-procedure-link"
                        role="error"
                        test="descendant::oscal:by-component/oscal:link[@rel = 'procedure']">[Section B Check 3.1] A FedRAMP SSP must incorporate a
                        procedure document for each of the 17 NIST SP 800-54 Revision 4 control families.</sch:assert>
            <sch:let name="procedure-hrefs"
                     value="distinct-values(descendant::oscal:by-component/oscal:link[@rel = 'procedure']/@href ! substring-after(., '#'))" />
            <sch:assert diagnostics="has-procedure-attachment-resource-diagnostic"
                        doc:checklist-reference="Section B Check 3.1"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6"
                        doc:template-reference="System Security Plan Template §15"
                        id="has-procedure-attachment-resource"
                        role="error"
                        test="
                    (: targets of links exist in the document :)
                    every $ref in $procedure-hrefs
                        satisfies exists(//oscal:resource[oscal:prop[@name = 'type' and @value = 'procedure']][@uuid = $ref])">[Section B Check 3.1]
A FedRAMP SSP must incorporate a procedure document for each of the 17 NIST SP 800-54 Revision 4 control families.</sch:assert>
            <!-- TODO: ensure resource has an rlink -->
        </sch:rule>
        <sch:rule context="oscal:by-component/oscal:link[@rel = ('policy', 'procedure')]"
                  doc:checklist-reference="Section B Check 3.1"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6"
                  doc:template-reference="System Security Plan Template §15">
            <sch:let name="ir"
                     value="ancestor::oscal:implemented-requirement" />
            <sch:report diagnostics="has-reuse-diagnostic"
                        doc:checklist-reference="Section B Check 3.1"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6"
                        doc:template-reference="System Security Plan Template §15"
                        id="has-reuse"
                        role="error"
                        test="
                    (: the current @href is in :)
                    @href = (: all controls except the current :) (//oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')] except $ir) (: all their @hrefs :)/descendant::oscal:by-component/oscal:link[@rel = 'policy']/@href">
            [Section B Check 3.1] Policy and procedure documents must have unique per-control-family associations.</sch:report>
        </sch:rule>
    </sch:pattern>
    <sch:pattern id="privacy1">
        <sch:title>A FedRAMP OSCAL SSP must specify a Privacy Point of Contact</sch:title>
        <sch:rule context="oscal:metadata"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.2"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.2">
            <sch:assert diagnostics="has-privacy-poc-role-diagnostic"
                        doc:checklist-reference="Section B Check 3.4"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.2"
                        id="has-privacy-poc-role"
                        role="error"
                        test="/oscal:system-security-plan/oscal:metadata/oscal:role[@id = 'privacy-poc']">[Section B Check 3.4] A FedRAMP OSCAL SSP
                        must incorporate a Privacy Point of Contact role.</sch:assert>
            <sch:assert diagnostics="has-responsible-party-privacy-poc-role-diagnostic"
                        doc:checklist-reference="Section B Check 3.4"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.2"
                        id="has-responsible-party-privacy-poc-role"
                        role="error"
                        test="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']">[Section B Check 3.4] A
                        FedRAMP OSCAL SSP must declare a Privacy Point of Contact responsible party role reference.</sch:assert>
            <sch:assert diagnostics="has-responsible-privacy-poc-party-uuid-diagnostic"
                        doc:checklist-reference="Section B Check 3.4"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.2"
                        id="has-responsible-privacy-poc-party-uuid"
                        role="error"
                        test="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']/oscal:party-uuid">[Section
                        B Check 3.4] A FedRAMP OSCAL SSP must declare a Privacy Point of Contact responsible party role reference identifying the
                        party by UUID.</sch:assert>
            <sch:let name="poc-uuid"
                     value="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']/oscal:party-uuid" />
            <sch:assert diagnostics="has-privacy-poc-diagnostic"
                        doc:checklist-reference="Section B Check 3.4"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.2"
                        id="has-privacy-poc"
                        role="error"
                        test="/oscal:system-security-plan/oscal:metadata/oscal:party[@uuid = $poc-uuid]">[Section B Check 3.4] A FedRAMP OSCAL SSP
                        must define a Privacy Point of Contact.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern id="privacy2">
        <sch:title>A FedRAMP OSCAL SSP may need to incorporate a PIA and possibly a SORN</sch:title>
        <!-- The "PTA" appears to be just a few questions, not an attachment -->
        <sch:rule context="oscal:prop[@name = 'privacy-sensitive'] | oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and matches(@name, '^pta-\d$')]"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4">
            <sch:assert diagnostics="has-correct-yes-or-no-answer-diagnostic"
                        doc:checklist-reference="Section B Check 3.4"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                        id="has-correct-yes-or-no-answer"
                        role="error"
                        test="current()/@value = ('yes', 'no')">[Section B Check 3.4] A Privacy Threshold Analysis (PTA)/Privacy Impact Analysis
                        (PIA) qualifying question must have an allowed answer.</sch:assert>
        </sch:rule>
        <sch:rule context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4">
            <sch:assert diagnostics="has-privacy-sensitive-designation-diagnostic"
                        doc:checklist-reference="Section B Check 3.4"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                        id="has-privacy-sensitive-designation"
                        role="error"
                        test="oscal:prop[@name = 'privacy-sensitive']">[Section B Check 3.4] A FedRAMP OSCAL SSP must have a privacy-sensitive
                        designation.</sch:assert>
            <sch:assert diagnostics="has-pta-question-1-diagnostic"
                        doc:checklist-reference="Section B Check 3.4"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                        id="has-pta-question-1"
                        role="error"
                        test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-1']">[Section B Check 3.4] A
                        FedRAMP OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question
                        #1.</sch:assert>
            <sch:assert diagnostics="has-pta-question-2-diagnostic"
                        doc:checklist-reference="Section B Check 3.4"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                        id="has-pta-question-2"
                        role="error"
                        test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-2']">[Section B Check 3.4] A
                        FedRAMP OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question
                        #2.</sch:assert>
            <sch:assert diagnostics="has-pta-question-3-diagnostic"
                        doc:checklist-reference="Section B Check 3.4"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                        id="has-pta-question-3"
                        role="error"
                        test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-3']">[Section B Check 3.4] A
                        FedRAMP OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question
                        #3.</sch:assert>
            <sch:assert diagnostics="has-pta-question-4-diagnostic"
                        doc:checklist-reference="Section B Check 3.4"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                        id="has-pta-question-4"
                        role="error"
                        test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-4']">[Section B Check 3.4] A
                        FedRAMP OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question
                        #4.</sch:assert>
            <sch:assert diagnostics="has-all-pta-questions-diagnostic"
                        doc:checklist-reference="Section B Check 3.4"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                        id="has-all-pta-questions"
                        role="error"
                        test="
                    every $name in ('pta-1', 'pta-2', 'pta-3', 'pta-4')
                        satisfies exists(oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = $name])">[Section B Check
3.4] A FedRAMP OSCAL SSP must have all four PTA questions.</sch:assert>
            <sch:assert diagnostics="has-correct-pta-question-cardinality-diagnostic"
                        doc:checklist-reference="Section B Check 3.4"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                        id="has-correct-pta-question-cardinality"
                        role="error"
                        test="
                    not(some $name in ('pta-1', 'pta-2', 'pta-3', 'pta-4')
                        satisfies exists(oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = $name][2]))">[Section B Check
3.4] A FedRAMP OSCAL SSP must have no duplicate PTA questions.</sch:assert>
            <sch:assert diagnostics="has-sorn-diagnostic"
                        doc:checklist-reference="Section B Check 3.4"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                        id="has-sorn"
                        role="error"
                        test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-4' and @value = 'yes'] and oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'sorn-id' (: and @value != '':)]">
            [Section B Check 3.4] A FedRAMP OSCAL SSP may have a SORN ID.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:back-matter"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4">
            <sch:assert diagnostics="has-pia-diagnostic"
                        doc:checklist-reference="Section B Check 3.4"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4"
                        id="has-pia"
                        role="error"
                        test="
                    every $answer in //oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and matches(@name, '^pta-\d$')]
                        satisfies $answer = 'no' or oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'pia']] (: a PIA is attached :)">
            [Section B Check 3.4] This FedRAMP OSCAL SSP must incorporate a Privacy Impact Analysis.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
                 id="fips-140"
                 see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans Appendix A">
        <!-- FIXME: Draft guide is wildly different than template -->
        <sch:title>FIPS 140 Validation</sch:title>
        <sch:rule context="oscal:system-implementation"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans Appendix A">
            <sch:assert diagnostics="has-CMVP-validation-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
                        id="has-CMVP-validation"
                        role="error"
                        test="oscal:component[@type = 'validation']">A FedRAMP OSCAL SSP must incorporate one or more FIPS 140 validated
                        modules.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:component[@type = 'validation']"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans Appendix A">
            <sch:assert diagnostics="has-CMVP-validation-reference-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
                        id="has-CMVP-validation-reference"
                        role="error"
                        test="oscal:prop[@name = 'validation-reference']">A validation component or inventory-item must have a validation-reference
                        property.</sch:assert>
            <sch:assert diagnostics="has-CMVP-validation-details-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
                        id="has-CMVP-validation-details"
                        role="error"
                        test="oscal:link[@rel = 'validation-details']">A validation component or inventory-item must have a validation-details
                        link.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'validation-reference']"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans Appendix A">
            <sch:assert diagnostics="has-credible-CMVP-validation-reference-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
                        id="has-credible-CMVP-validation-reference"
                        role="error"
                        test="matches(@value, '^\d{3,4}$')">A validation-reference property must provide a CMVP certificate number.</sch:assert>
            <sch:assert diagnostics="has-consonant-CMVP-validation-reference-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
                        id="has-consonant-CMVP-validation-reference"
                        role="error"
                        test="@value = tokenize(following-sibling::oscal:link[@rel = 'validation-details']/@href, '/')[last()]">A
                        validation-reference property must be in accord with its sibling validation-details href.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:link[@rel = 'validation-details']"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans Appendix A">
            <sch:assert diagnostics="has-credible-CMVP-validation-details-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
                        id="has-credible-CMVP-validation-details"
                        role="error"
                        test="matches(@href, '^https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/\d{3,4}$')">A
                        validation-details link must refer to a NIST CMVP certificate detail page.</sch:assert>
            <sch:assert diagnostics="has-consonant-CMVP-validation-details-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans Appendix A"
                        id="has-consonant-CMVP-validation-details"
                        role="error"
                        test="tokenize(@href, '/')[last()] = preceding-sibling::oscal:prop[@name = 'validation-reference']/@value">A
                        validation-details link must be in accord with its sibling validation-reference.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                 doc:template-reference="System Security Plan Template §2"
                 id="fips-199"
                 see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.4">
        <sch:title>Security Objectives Categorization (FIPS 199)</sch:title>
        <sch:rule context="oscal:system-characteristics"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                  doc:template-reference="System Security Plan Template §2">
            <!-- These should also be asserted in XML Schema -->
            <sch:assert diagnostics="has-security-sensitivity-level-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                        doc:template-reference="System Security Plan Template §2"
                        id="has-security-sensitivity-level"
                        role="error"
                        test="oscal:security-sensitivity-level">A FedRAMP OSCAL SSP must specify a FIPS 199 categorization.</sch:assert>
            <sch:assert diagnostics="has-security-impact-level-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                        id="has-security-impact-level"
                        role="error"
                        test="oscal:security-impact-level">A FedRAMP OSCAL SSP must specify a security impact level.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:security-sensitivity-level"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                  doc:template-reference="System Security Plan Template §2">
            <sch:let name="security-sensitivity-levels"
                     value="$fedramp-values//fedramp:value-set[@name = 'security-level']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-security-sensitivity-level-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                        doc:template-reference="System Security Plan Template §2"
                        id="has-allowed-security-sensitivity-level"
                        role="error"
                        test="current() = $security-sensitivity-levels">A FedRAMP OSCAL SSP must specify an allowed
                        security-sensitivity-level.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:security-impact-level"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                  doc:template-reference="System Security Plan Template §2.2">
            <!-- These should also be asserted in XML Schema -->
            <sch:assert diagnostics="has-security-objective-confidentiality-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                        doc:template-reference="System Security Plan Template §2.2"
                        id="has-security-objective-confidentiality"
                        role="error"
                        test="oscal:security-objective-confidentiality">A FedRAMP OSCAL SSP must specify a confidentiality security
                        objective.</sch:assert>
            <sch:assert diagnostics="has-security-objective-integrity-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                        doc:template-reference="System Security Plan Template §2.2"
                        id="has-security-objective-integrity"
                        role="error"
                        test="oscal:security-objective-integrity">A FedRAMP OSCAL SSP must specify an integrity security objective.</sch:assert>
            <sch:assert diagnostics="has-security-objective-availability-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                        doc:template-reference="System Security Plan Template §2.2"
                        id="has-security-objective-availability"
                        role="error"
                        test="oscal:security-objective-availability">A FedRAMP OSCAL SSP must specify an availability security
                        objective.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:security-objective-confidentiality | oscal:security-objective-integrity | oscal:security-objective-availability"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                  doc:template-reference="System Security Plan Template §2.2">
            <sch:let name="security-objective-levels"
                     value="$fedramp-values//fedramp:value-set[@name = 'security-level']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-security-objective-value-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.4"
                        doc:template-reference="System Security Plan Template §2.2"
                        id="has-allowed-security-objective-value"
                        role="error"
                        test="current() = $security-objective-levels">A FedRAMP OSCAL SSP must specify an allowed security objective
                        value.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                 doc:template-reference="System Security Plan Template §2.1"
                 id="sp800-60"
                 see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3">
        <sch:title>SP 800-60v2r1 Information Types:</sch:title>
        <sch:rule context="oscal:system-information"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                  doc:template-reference="System Security Plan Template §2.1">
            <sch:assert diagnostics="system-information-has-information-type-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                        doc:template-reference="System Security Plan Template §2"
                        id="system-information-has-information-type"
                        role="error"
                        test="oscal:information-type">A FedRAMP OSCAL SSP must specify at least one information-type.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:information-type"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                  doc:template-reference="System Security Plan Template §2.1">
            <sch:assert diagnostics="information-type-has-title-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                        doc:template-reference="System Security Plan Template §2.1"
                        id="information-type-has-title"
                        role="error"
                        test="oscal:title">A FedRAMP OSCAL SSP information-type must have a title.</sch:assert>
            <sch:assert diagnostics="information-type-has-description-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                        doc:template-reference="System Security Plan Template §2.1"
                        id="information-type-has-description"
                        role="error"
                        test="oscal:description">A FedRAMP OSCAL SSP information-type must have a description.</sch:assert>
            <sch:assert diagnostics="information-type-has-categorization-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                        doc:template-reference="System Security Plan Template §2.1"
                        id="information-type-has-categorization"
                        role="error"
                        test="oscal:categorization">A FedRAMP OSCAL SSP information-type must have at least one categorization.</sch:assert>
            <sch:assert diagnostics="information-type-has-confidentiality-impact-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                        doc:template-reference="System Security Plan Template §2.1"
                        id="information-type-has-confidentiality-impact"
                        role="error"
                        test="oscal:confidentiality-impact">A FedRAMP OSCAL SSP information-type must have a confidentiality-impact.</sch:assert>
            <sch:assert diagnostics="information-type-has-integrity-impact-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                        doc:template-reference="System Security Plan Template §2.1"
                        id="information-type-has-integrity-impact"
                        role="error"
                        test="oscal:integrity-impact">A FedRAMP OSCAL SSP information-type must have a integrity-impact.</sch:assert>
            <sch:assert diagnostics="information-type-has-availability-impact-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                        doc:template-reference="System Security Plan Template §2.1"
                        id="information-type-has-availability-impact"
                        role="error"
                        test="oscal:availability-impact">A FedRAMP OSCAL SSP information-type must have a availability-impact.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:categorization"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                  doc:template-reference="System Security Plan Template §2.1">
            <sch:assert diagnostics="categorization-has-system-attribute-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                        doc:template-reference="System Security Plan Template §2.1"
                        id="categorization-has-system-attribute"
                        role="error"
                        test="@system">A FedRAMP OSCAL SSP information-type categorization must have a system attribute.</sch:assert>
            <sch:assert diagnostics="categorization-has-correct-system-attribute-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                        doc:template-reference="System Security Plan Template §2.1"
                        id="categorization-has-correct-system-attribute"
                        role="error"
                        test="@system = 'https://doi.org/10.6028/NIST.SP.800-60v2r1'">A FedRAMP OSCAL SSP information-type categorization must have a
                        correct system attribute.</sch:assert>
            <sch:assert diagnostics="categorization-has-information-type-id-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                        doc:template-reference="System Security Plan Template §2.1"
                        id="categorization-has-information-type-id"
                        role="error"
                        test="oscal:information-type-id">A FedRAMP OSCAL SSP information-type categorization must have at least one
                        information-type-id.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:information-type-id"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                  doc:template-reference="System Security Plan Template §2.1">
            <sch:let name="information-types"
                     value="doc(concat($registry-base-path, '/information-types.xml'))//fedramp:information-type/@id" />
            <!-- note the variant namespace and associated prefix -->
            <sch:assert diagnostics="has-allowed-information-type-id-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                        doc:template-reference="System Security Plan Template §2.1"
                        id="has-allowed-information-type-id"
                        role="error"
                        test="current()[. = $information-types]">A FedRAMP OSCAL SSP information-type-id must have a SP 800-60v2r1
                        identifier.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:confidentiality-impact | oscal:integrity-impact | oscal:availability-impact"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                  doc:template-reference="System Security Plan Template §2.1">
            <sch:assert diagnostics="cia-impact-has-base-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                        doc:template-reference="System Security Plan Template §2.1"
                        id="cia-impact-has-base"
                        role="error"
                        test="oscal:base">A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact must have a base
                        element.</sch:assert>
            <sch:assert diagnostics="cia-impact-has-selected-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                        doc:template-reference="System Security Plan Template §2.1"
                        id="cia-impact-has-selected"
                        role="error"
                        test="oscal:selected">A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact must have a
                        selected element.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:base | oscal:selected"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                  doc:template-reference="System Security Plan Template §2.1">
            <sch:let name="fips-199-levels"
                     value="$fedramp-values//fedramp:value-set[@name = 'security-level']//fedramp:enum/@value" />
            <sch:assert diagnostics="cia-impact-has-approved-fips-categorization-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3"
                        doc:template-reference="System Security Plan Template §2.1"
                        id="cia-impact-has-approved-fips-categorization"
                        role="error"
                        test=". = $fips-199-levels">A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact base or
                        select element must have an approved value.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                 doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                 doc:template-reference="System Security Plan Template §2.3"
                 id="sp800-63"
                 see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.5">
        <sch:title>Digital Identity Determination</sch:title>
        <sch:rule context="oscal:system-characteristics"
                  doc:checklist-reference="Section C Check 7"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                  doc:template-reference="System Security Plan Template §2.3">
            <sch:assert diagnostics="has-security-eauth-level-diagnostic"
                        doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                        doc:template-reference="System Security Plan Template §2.3"
                        id="has-security-eauth-level"
                        role="error"
                        test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'security-eauth' and @name = 'security-eauth-level']">
                        [Section B Check 3.3] A FedRAMP OSCAL SSP must have a Digital Identity Determination property.</sch:assert>
            <sch:assert diagnostics="has-identity-assurance-level-diagnostic"
                        doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                        doc:template-reference="System Security Plan Template §2.3"
                        id="has-identity-assurance-level"
                        role="information"
                        test="oscal:prop[@name = 'identity-assurance-level']">[Section B Check 3.3] A FedRAMP OSCAL SSP may have a Digital Identity
                        Determination identity-assurance-level property.</sch:assert>
            <sch:assert diagnostics="has-authenticator-assurance-level-diagnostic"
                        doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                        doc:template-reference="System Security Plan Template §2.3"
                        id="has-authenticator-assurance-level"
                        role="information"
                        test="oscal:prop[@name = 'authenticator-assurance-level']">[Section B Check 3.3] A FedRAMP OSCAL SSP may have a Digital
                        Identity Determination authenticator-assurance-level property.</sch:assert>
            <sch:assert diagnostics="has-federation-assurance-level-diagnostic"
                        doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                        doc:template-reference="System Security Plan Template §2.3"
                        id="has-federation-assurance-level"
                        role="information"
                        test="oscal:prop[@name = 'federation-assurance-level']">[Section B Check 3.3] A FedRAMP OSCAL SSP may have a Digital Identity
                        Determination federation-assurance-level property.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'security-eauth' and @name = 'security-eauth-level']"
                  doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                  doc:template-reference="System Security Plan Template §2.3"
                  role="error">
            <sch:let name="eauth-levels"
                     value="$fedramp-values//fedramp:value-set[@name = 'eauth-level']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-security-eauth-level-diagnostic"
                        doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                        doc:template-reference="System Security Plan Template §2.3"
                        id="has-allowed-security-eauth-level"
                        role="error"
                        test="@value = $eauth-levels">[Section B Check 3.3] A FedRAMP OSCAL SSP must have a Digital Identity Determination property
                        with an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'identity-assurance-level']"
                  doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                  doc:template-reference="System Security Plan Template §2.3">
            <sch:let name="identity-assurance-levels"
                     value="$fedramp-values//fedramp:value-set[@name = 'identity-assurance-level']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-identity-assurance-level-diagnostic"
                        doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                        doc:template-reference="System Security Plan Template §2.3"
                        id="has-allowed-identity-assurance-level"
                        role="error"
                        test="@value = $identity-assurance-levels">[Section B Check 3.3] A FedRAMP OSCAL SSP should have an allowed Digital Identity
                        Determination identity-assurance-level property.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'authenticator-assurance-level']"
                  doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                  doc:template-reference="System Security Plan Template §2.3">
            <sch:let name="authenticator-assurance-levels"
                     value="$fedramp-values//fedramp:value-set[@name = 'authenticator-assurance-level']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-authenticator-assurance-level-diagnostic"
                        doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                        doc:template-reference="System Security Plan Template §2.3"
                        id="has-allowed-authenticator-assurance-level"
                        role="error"
                        test="@value = $authenticator-assurance-levels">[Section B Check 3.3] A FedRAMP OSCAL SSP should have an allowed Digital
                        Identity Determination authenticator-assurance-level property.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'federation-assurance-level']"
                  doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                  doc:template-reference="System Security Plan Template §2.3">
            <sch:let name="federation-assurance-levels"
                     value="$fedramp-values//fedramp:value-set[@name = 'federation-assurance-level']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-federation-assurance-level-diagnostic"
                        doc:checklist-reference="Section B Check 3.3, Section C Check 7"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.5"
                        doc:template-reference="System Security Plan Template §2.3"
                        id="has-allowed-federation-assurance-level"
                        role="error"
                        test="@value = $federation-assurance-levels">[Section B Check 3.3] A FedRAMP OSCAL SSP should have an allowed Digital
                        Identity Determination federation-assurance-level property.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                 id="system-inventory"
                 see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5">
        <sch:title>FedRAMP OSCAL System Inventory</sch:title>
        <sch:title>A FedRAMP OSCAL SSP must specify system inventory items</sch:title>
        <sch:rule context="/oscal:system-security-plan/oscal:system-implementation"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <!-- FIXME: determine if essential inventory items are present -->
            <doc:rule>A FedRAMP OSCAL SSP must incorporate inventory-item elements</doc:rule>
            <sch:assert diagnostics="has-inventory-items-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="has-inventory-items"
                        role="error"
                        test="oscal:inventory-item">A FedRAMP OSCAL SSP must incorporate inventory-item elements.</sch:assert>
        </sch:rule>
        <sch:title>FedRAMP SSP property constraints</sch:title>
        <sch:rule context="oscal:prop[@name = 'asset-id']"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:assert diagnostics="has-unique-asset-id-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="has-unique-asset-id"
                        role="error"
                        test="count(//oscal:prop[@name = 'asset-id'][@value = current()/@value]) = 1">An asset-id must be unique.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'asset-type']"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:let name="asset-types"
                     value="$fedramp-values//fedramp:value-set[@name = 'asset-type']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-asset-type-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="has-allowed-asset-type"
                        role="warning"
                        test="@value = $asset-types">An asset-type property must have an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'virtual']"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:let name="virtuals"
                     value="$fedramp-values//fedramp:value-set[@name = 'virtual']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-virtual-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="has-allowed-virtual"
                        role="error"
                        test="@value = $virtuals">A virtual property must have an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'public']"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:let name="publics"
                     value="$fedramp-values//fedramp:value-set[@name = 'public']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-public-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="has-allowed-public"
                        role="error"
                        test="@value = $publics">A public property must have an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'allows-authenticated-scan']"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:let name="allows-authenticated-scans"
                     value="$fedramp-values//fedramp:value-set[@name = 'allows-authenticated-scan']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-allows-authenticated-scan-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="has-allowed-allows-authenticated-scan"
                        role="error"
                        test="@value = $allows-authenticated-scans">An allows-authenticated-scan property has an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'is-scanned']"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:let name="is-scanneds"
                     value="$fedramp-values//fedramp:value-set[@name = 'is-scanned']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-is-scanned-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="has-allowed-is-scanned"
                        role="error"
                        test="@value = $is-scanneds">is-scanned property must have an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'scan-type']"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:let name="scan-types"
                     value="$fedramp-values//fedramp:value-set[@name = 'scan-type']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-scan-type-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="has-allowed-scan-type"
                        role="error"
                        test="@value = $scan-types">A scan-type property must have an allowed value.</sch:assert>
        </sch:rule>
        <sch:title>FedRAMP OSCAL SSP inventory components</sch:title>
        <sch:rule context="oscal:component"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:let name="component-types"
                     value="$fedramp-values//fedramp:value-set[@name = 'component-type']//fedramp:enum/@value" />
            <sch:assert diagnostics="component-has-allowed-type-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="component-has-allowed-type"
                        role="error"
                        test="@type = $component-types">A component must have an allowed type.</sch:assert>
            <sch:assert diagnostics="component-has-asset-type-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="component-has-asset-type"
                        role="error"
                        test="
                    (: not(@uuid = //oscal:inventory-item/oscal:implemented-component/@component-uuid) or :)
                    oscal:prop[@name = 'asset-type']">A component must have an asset type.</sch:assert>
            <sch:assert diagnostics="component-has-one-asset-type-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="component-has-one-asset-type"
                        role="error"
                        test="not(oscal:prop[@name = 'asset-type'][2])">A component must have only one asset type.</sch:assert>
        </sch:rule>
        <sch:title>FedRAMP OSCAL SSP inventory items</sch:title>
        <sch:rule context="oscal:inventory-item"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5">
            <sch:assert diagnostics="inventory-item-has-uuid-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-uuid"
                        role="error"
                        test="@uuid">An inventory-item has a uuid.</sch:assert>
            <sch:assert diagnostics="has-asset-id-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="has-asset-id"
                        role="error"
                        test="oscal:prop[@name = 'asset-id']">An inventory-item must have an asset-id.</sch:assert>
            <sch:assert diagnostics="has-one-asset-id-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="has-one-asset-id"
                        role="error"
                        test="not(oscal:prop[@name = 'asset-id'][2])">An inventory-item must have only one asset-id.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-asset-type-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-asset-type"
                        role="error"
                        test="oscal:prop[@name = 'asset-type']">An inventory-item must have an asset-type.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-asset-type-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-one-asset-type"
                        role="error"
                        test="not(oscal:prop[@name = 'asset-type'][2])">An inventory-item must have only one asset-type.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-virtual-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-virtual"
                        role="error"
                        test="oscal:prop[@name = 'virtual']">An inventory-item must have a virtual property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-virtual-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-one-virtual"
                        role="error"
                        test="not(oscal:prop[@name = 'virtual'][2])">An inventory-item must have only one virtual property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-public-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-public"
                        role="error"
                        test="oscal:prop[@name = 'public']">An inventory-item must have a public property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-public-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-one-public"
                        role="error"
                        test="not(oscal:prop[@name = 'public'][2])">An inventory-item must have only one public property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-scan-type-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-scan-type"
                        role="error"
                        test="oscal:prop[@name = 'scan-type']">An inventory-item must have a scan-type property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-scan-type-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-one-scan-type"
                        role="error"
                        test="not(oscal:prop[@name = 'scan-type'][2])">An inventory-item has only one scan-type property.</sch:assert>
            <!-- restrict the following to "infrastructure" -->
            <sch:let name="is-infrastructure"
                     value="exists(oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')])" />
            <sch:assert diagnostics="inventory-item-has-allows-authenticated-scan-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-allows-authenticated-scan"
                        role="error"
                        test="not($is-infrastructure) or oscal:prop[@name = 'allows-authenticated-scan']">"infrastructure" inventory-item has
                        allows-authenticated-scan.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-allows-authenticated-scan-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-one-allows-authenticated-scan"
                        role="error"
                        test="not($is-infrastructure) or not(oscal:prop[@name = 'allows-authenticated-scan'][2])">An inventory-item has
                        one-allows-authenticated-scan property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-baseline-configuration-name-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-baseline-configuration-name"
                        role="error"
                        test="not($is-infrastructure) or oscal:prop[@name = 'baseline-configuration-name']">"infrastructure" inventory-item has
                        baseline-configuration-name.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-baseline-configuration-name-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-one-baseline-configuration-name"
                        role="error"
                        test="not($is-infrastructure) or not(oscal:prop[@name = 'baseline-configuration-name'][2])">"infrastructure" inventory-item
                        has only one baseline-configuration-name.</sch:assert>
            <!-- FIXME: Documentation says vendor name is in FedRAMP @ns -->
            <sch:assert diagnostics="inventory-item-has-vendor-name-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-vendor-name"
                        role="error"
                        test="not($is-infrastructure) or oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'vendor-name']">
                        "infrastructure" inventory-item has a vendor-name property.</sch:assert>
            <!-- FIXME: Documentation says vendor name is in FedRAMP @ns -->
            <sch:assert diagnostics="inventory-item-has-one-vendor-name-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-one-vendor-name"
                        role="error"
                        test="not($is-infrastructure) or not(oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'vendor-name'][2])">
                        "infrastructure" inventory-item must have only one vendor-name property.</sch:assert>
            <!-- FIXME: perversely, hardware-model is not in FedRAMP @ns -->
            <sch:assert diagnostics="inventory-item-has-hardware-model-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-hardware-model"
                        role="error"
                        test="not($is-infrastructure) or oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'hardware-model']">
                        "infrastructure" inventory-item must have a hardware-model property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-hardware-model-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-one-hardware-model"
                        role="error"
                        test="not($is-infrastructure) or not(oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'hardware-model'][2])">
                        "infrastructure" inventory-item must have only one hardware-model property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-is-scanned-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-is-scanned"
                        role="error"
                        test="not($is-infrastructure) or oscal:prop[@name = 'is-scanned']">"infrastructure" inventory-item must have is-scanned
                        property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-is-scanned-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-one-is-scanned"
                        role="error"
                        test="not($is-infrastructure) or not(oscal:prop[@name = 'is-scanned'][2])">"infrastructure" inventory-item must have only one
                        is-scanned property.</sch:assert>
            <!-- FIXME: vague asset categories -->
            <!-- restrict the following to "software" -->
            <sch:let name="is-software-and-database"
                     value="exists(oscal:prop[@name = 'asset-type' and @value = ('software', 'database')])" />
            <sch:assert diagnostics="inventory-item-has-software-name-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-software-name"
                        role="error"
                        test="not($is-software-and-database) or oscal:prop[@name = 'software-name']">"software or database" inventory-item must have
                        a software-name property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-software-name-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-one-software-name"
                        role="error"
                        test="not($is-software-and-database) or not(oscal:prop[@name = 'software-name'][2])">"software or database" inventory-item
                        must have a software-name property.</sch:assert>
            <!-- FIXME: vague asset categories -->
            <sch:assert diagnostics="inventory-item-has-software-version-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-software-version"
                        role="error"
                        test="not($is-software-and-database) or oscal:prop[@name = 'software-version']">"software or database" inventory-item must
                        have a software-version property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-software-version-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-one-software-version"
                        role="error"
                        test="not($is-software-and-database) or not(oscal:prop[@name = 'software-version'][2])">"software or database" inventory-item
                        must have one software-version property.</sch:assert>
            <!-- FIXME: vague asset categories -->
            <sch:assert diagnostics="inventory-item-has-function-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-function"
                        role="error"
                        test="not($is-software-and-database) or oscal:prop[@name = 'function']">"software or database" inventory-item must have a
                        function property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-function-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5"
                        id="inventory-item-has-one-function"
                        role="error"
                        test="not($is-software-and-database) or not(oscal:prop[@name = 'function'][2])">"software or database" inventory-item must
                        have one function property.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern id="basic-system-characteristics">
        <sch:rule context="oscal:system-implementation"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.4.6"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.4.6">
            <sch:assert diagnostics="has-this-system-component-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.4.6"
                        id="has-this-system-component"
                        role="error"
                        test="exists(oscal:component[@type = 'this-system'])">A FedRAMP OSCAL SSP must have a "this-system" component.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:system-characteristics">
            <sch:assert diagnostics="has-system-id-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.1"
                        doc:template-reference="System Security Plan Template §1"
                        id="has-system-id"
                        role="error"
                        see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.1"
                        test="oscal:system-id[@identifier-type = 'https://fedramp.gov']">A FedRAMP OSCAL SSP must have a FedRAMP
                        system-id.</sch:assert>
            <sch:assert diagnostics="has-system-name-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.1"
                        doc:template-reference="System Security Plan Template §1"
                        id="has-system-name"
                        role="error"
                        see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.1"
                        test="oscal:system-name">A FedRAMP OSCAL SSP must have a system-name.</sch:assert>
            <sch:assert diagnostics="has-system-name-short-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.1"
                        doc:template-reference="System Security Plan Template §1"
                        id="has-system-name-short"
                        role="error"
                        see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.1"
                        test="oscal:system-name-short">A FedRAMP OSCAL SSP must have a system-name-short.</sch:assert>
            <sch:assert diagnostics="has-fedramp-authorization-type-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.2"
                        id="has-fedramp-authorization-type"
                        role="error"
                        see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.2"
                        test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'authorization-type' and @value = ('fedramp-jab', 'fedramp-agency', 'fedramp-li-saas')]">
            A FedRAMP OSCAL SSP must have a FedRAMP authorization type.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern id="general-roles">
        <sch:title>Roles, Locations, Parties, Responsibilities</sch:title>
        <sch:rule context="oscal:metadata"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.10"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.10">
            <sch:assert diagnostics="role-defined-system-owner-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.6"
                        doc:template-reference="System Security Plan Template §3"
                        id="role-defined-system-owner"
                        role="error"
                        test="oscal:role[@id = 'system-owner']">The system-owner role must be defined.</sch:assert>
            <sch:assert diagnostics="role-defined-authorizing-official-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.7"
                        doc:template-reference="System Security Plan Template §4"
                        id="role-defined-authorizing-official"
                        role="error"
                        test="oscal:role[@id = 'authorizing-official']">The authorizing-official role must be defined.</sch:assert>
            <sch:assert diagnostics="role-defined-system-poc-management-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.8"
                        doc:template-reference="System Security Plan Template §5"
                        id="role-defined-system-poc-management"
                        role="error"
                        test="oscal:role[@id = 'system-poc-management']">The system-poc-management role must be defined.</sch:assert>
            <sch:assert diagnostics="role-defined-system-poc-technical-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.9"
                        doc:template-reference="System Security Plan Template §5"
                        id="role-defined-system-poc-technical"
                        role="error"
                        test="oscal:role[@id = 'system-poc-technical']">The system-poc-technical role must be defined.</sch:assert>
            <sch:assert diagnostics="role-defined-system-poc-other-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.9"
                        doc:template-reference="System Security Plan Template §5"
                        id="role-defined-system-poc-other"
                        role="error"
                        test="oscal:role[@id = 'system-poc-other']">The system-poc-other role must be defined.</sch:assert>
            <sch:assert diagnostics="role-defined-information-system-security-officer-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.10"
                        doc:template-reference="System Security Plan Template §6"
                        id="role-defined-information-system-security-officer"
                        role="error"
                        test="oscal:role[@id = 'information-system-security-officer']">The information-system-security-officer role must be
                        defined.</sch:assert>
            <sch:assert diagnostics="role-defined-authorizing-official-poc-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.11"
                        doc:template-reference="System Security Plan Template §6"
                        id="role-defined-authorizing-official-poc"
                        role="error"
                        test="oscal:role[@id = 'authorizing-official-poc']">The authorizing-official-poc role must be defined.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:role"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.10">
            <sch:assert diagnostics="role-has-title-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.10"
                        id="role-has-title"
                        role="error"
                        test="oscal:title">A role must have a title.</sch:assert>
            <sch:assert diagnostics="role-has-responsible-party-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.10"
                        id="role-has-responsible-party"
                        role="error"
                        test="//oscal:responsible-party[@role-id = current()/@id]">One or more responsible parties must be defined for each
                        role.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:responsible-party"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.10">
            <sch:assert diagnostics="responsible-party-has-person-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.10"
                        id="responsible-party-has-person"
                        role="error"
                        test="//oscal:party[@uuid = current()/oscal:party-uuid and @type = 'person']">Each responsible-party party-uuid must identify
                        a person.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:party[@type = 'person']"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.10">
            <sch:assert diagnostics="party-has-responsibility-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.10"
                        id="party-has-responsibility"
                        role="warning"
                        test="//oscal:responsible-party[oscal:party-uuid = current()/@uuid]">Each person should have a responsibility.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2"
                 id="implementation-roles"
                 see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2">
        <sch:title>Roles related to implemented requirements</sch:title>
        <sch:rule context="oscal:implemented-requirement"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2">
            <sch:assert diagnostics="implemented-requirement-has-responsible-role-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2"
                        id="implemented-requirement-has-responsible-role"
                        role="error"
                        test="oscal:responsible-role">Each implemented-requirement must have one or more responsible-role definitions.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:responsible-role"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2">
            <sch:assert diagnostics="responsible-role-has-role-definition-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2"
                        id="responsible-role-has-role-definition"
                        role="error"
                        test="//oscal:role/@id = current()/@role-id">Each responsible-role must reference a role definition.</sch:assert>
            <sch:assert diagnostics="responsible-role-has-user-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2"
                        id="responsible-role-has-user"
                        role="error"
                        test="//oscal:role-id = current()/@role-id">Each responsible-role must be referenced in a system-implementation user
                        assembly.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern doc:template-reference="System Security Plan Template §9.3"
                 id="user-properties">
        <sch:rule context="oscal:user"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                  doc:template-reference="System Security Plan Template §9.3">
            <sch:assert diagnostics="user-has-role-id-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                        doc:template-reference="System Security Plan Template §9.3"
                        id="user-has-role-id"
                        role="error"
                        test="oscal:role-id">Every user has a role-id.</sch:assert>
            <sch:assert diagnostics="user-has-user-type-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                        doc:template-reference="System Security Plan Template §9.3"
                        id="user-has-user-type"
                        role="error"
                        test="oscal:prop[@name = 'type']">Every user has a user type property.</sch:assert>
            <sch:assert diagnostics="user-has-privilege-level-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                        doc:template-reference="System Security Plan Template §9.3"
                        id="user-has-privilege-level"
                        role="error"
                        test="oscal:prop[@name = 'privilege-level']">Every user has a privilege-level property.</sch:assert>
            <sch:assert diagnostics="user-has-sensitivity-level-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                        doc:template-reference="System Security Plan Template §9.3"
                        id="user-has-sensitivity-level"
                        role="error"
                        test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal'][@name = 'sensitivity']">Every user has a sensitivity level
                        property.</sch:assert>
            <sch:assert diagnostics="user-has-authorized-privilege-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                        doc:template-reference="System Security Plan Template §9.3"
                        id="user-has-authorized-privilege"
                        role="error"
                        test="oscal:authorized-privilege">Every user has one or more authorized-privileges.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:user/oscal:role-id"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                  doc:template-reference="System Security Plan Template §9.3">
            <sch:assert diagnostics="role-id-has-role-definition-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                        doc:template-reference="System Security Plan Template §9.3"
                        id="role-id-has-role-definition"
                        role="error"
                        test="//oscal:role[@id = current()]">Each role-id must reference a role definition.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:user/oscal:prop[@name = 'type']"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                  doc:template-reference="System Security Plan Template §9.3">
            <sch:let name="user-types"
                     value="$fedramp-values//fedramp:value-set[@name = 'user-type']//fedramp:enum/@value" />
            <sch:assert diagnostics="user-user-type-has-allowed-value-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                        doc:template-reference="System Security Plan Template §9.3"
                        id="user-user-type-has-allowed-value"
                        role="error"
                        test="current()/@value = $user-types">User type property has an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:user/oscal:prop[@name = 'privilege-level']"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                  doc:template-reference="System Security Plan Template §9.3">
            <sch:let name="user-privilege-levels"
                     value="$fedramp-values//fedramp:value-set[@name = 'user-privilege']//fedramp:enum/@value" />
            <sch:assert diagnostics="user-privilege-level-has-allowed-value-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                        doc:template-reference="System Security Plan Template §9.3"
                        id="user-privilege-level-has-allowed-value"
                        role="error"
                        test="current()/@value = $user-privilege-levels">User privilege-level property has an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:user/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal'][@name = 'sensitivity']"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                  doc:template-reference="System Security Plan Template §9.3">
            <sch:let name="user-sensitivity-levels"
                     value="$fedramp-values//fedramp:value-set[@name = 'user-sensitivity-level']//fedramp:enum/@value" />
            <sch:assert diagnostics="user-sensitivity-level-has-allowed-value-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                        doc:template-reference="System Security Plan Template §9.3"
                        id="user-sensitivity-level-has-allowed-value"
                        role="error"
                        test="current()/@value = $user-sensitivity-levels">User sensitivity level property has an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:user/oscal:authorized-privilege"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                  doc:template-reference="System Security Plan Template §9.3">
            <sch:assert diagnostics="authorized-privilege-has-title-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                        doc:template-reference="System Security Plan Template §9.3"
                        id="authorized-privilege-has-title"
                        role="error"
                        test="oscal:title">Every authorized-privilege has a title.</sch:assert>
            <sch:assert diagnostics="authorized-privilege-has-function-performed-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                        doc:template-reference="System Security Plan Template §9.3"
                        id="authorized-privilege-has-function-performed"
                        role="error"
                        test="oscal:function-performed">Every authorized-privilege has one or more function-performed.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:authorized-privilege/oscal:title"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                  doc:template-reference="System Security Plan Template §9.3">
            <sch:assert diagnostics="authorized-privilege-has-non-empty-title-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                        id="authorized-privilege-has-non-empty-title"
                        role="error"
                        test="current() ne ''">Every authorized-privilege title is non-empty.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:authorized-privilege/oscal:function-performed"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                  doc:template-reference="System Security Plan Template §9.3">
            <sch:assert diagnostics="authorized-privilege-has-non-empty-function-performed-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18"
                        id="authorized-privilege-has-non-empty-function-performed"
                        role="error"
                        test="current() ne ''">Every authorized-privilege has a non-empty function-performed.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                 doc:template-reference="System Security Plan Template §9.2"
                 id="authorization-boundary"
                 see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram">
        <sch:title>Authorization Boundary Diagram</sch:title>
        <sch:rule context="oscal:system-characteristics"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                  doc:template-reference="System Security Plan Template §9.2">
            <sch:assert diagnostics="has-authorization-boundary-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                        doc:template-reference="System Security Plan Template §9.2"
                        id="has-authorization-boundary"
                        role="error"
                        test="oscal:authorization-boundary">A FedRAMP OSCAL SSP includes an authorization-boundary in its
                        system-characteristics.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:authorization-boundary"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                  doc:template-reference="System Security Plan Template §9.2">
            <sch:assert diagnostics="has-authorization-boundary-description-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                        doc:template-reference="System Security Plan Template §9.2"
                        id="has-authorization-boundary-description"
                        role="error"
                        test="oscal:description">A FedRAMP OSCAL SSP has an authorization-boundary description.</sch:assert>
            <sch:assert diagnostics="has-authorization-boundary-diagram-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                        doc:template-reference="System Security Plan Template §9.2"
                        id="has-authorization-boundary-diagram"
                        role="error"
                        test="oscal:diagram">A FedRAMP OSCAL SSP has at least one authorization-boundary diagram.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:authorization-boundary/oscal:diagram"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                  doc:template-reference="System Security Plan Template §9.2">
            <sch:assert diagnostics="has-authorization-boundary-diagram-uuid-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                        doc:template-reference="System Security Plan Template §9.2"
                        id="has-authorization-boundary-diagram-uuid"
                        role="error"
                        test="@uuid">Each FedRAMP OSCAL SSP authorization-boundary diagram has a uuid attribute.</sch:assert>
            <sch:assert diagnostics="has-authorization-boundary-diagram-description-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                        doc:template-reference="System Security Plan Template §9.2"
                        id="has-authorization-boundary-diagram-description"
                        role="error"
                        test="oscal:description">Each FedRAMP OSCAL SSP authorization-boundary diagram has a description.</sch:assert>
            <sch:assert diagnostics="has-authorization-boundary-diagram-link-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                        doc:template-reference="System Security Plan Template §9.2"
                        id="has-authorization-boundary-diagram-link"
                        role="error"
                        test="oscal:link">Each FedRAMP OSCAL SSP authorization-boundary diagram has a link.</sch:assert>
            <sch:assert diagnostics="has-authorization-boundary-diagram-caption-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                        doc:template-reference="System Security Plan Template §9.2"
                        id="has-authorization-boundary-diagram-caption"
                        role="error"
                        test="oscal:caption">Each FedRAMP OSCAL SSP authorization-boundary diagram has a caption.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:authorization-boundary/oscal:diagram/oscal:link"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                  doc:template-reference="System Security Plan Template §9.2">
            <sch:assert diagnostics="has-authorization-boundary-diagram-link-rel-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                        doc:template-reference="System Security Plan Template §9.2"
                        id="has-authorization-boundary-diagram-link-rel"
                        role="error"
                        test="@rel">Each FedRAMP OSCAL SSP authorization-boundary diagram has a link rel attribute.</sch:assert>
            <sch:assert diagnostics="has-authorization-boundary-diagram-link-rel-allowed-value-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                        doc:template-reference="System Security Plan Template §9.2"
                        id="has-authorization-boundary-diagram-link-rel-allowed-value"
                        role="error"
                        test="@rel = 'diagram'">Each FedRAMP OSCAL SSP authorization-boundary diagram has a link rel attribute with the value
                        "diagram".</sch:assert>
            <sch:assert diagnostics="has-authorization-boundary-diagram-link-href-target-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram"
                        doc:template-reference="System Security Plan Template §9.2"
                        id="has-authorization-boundary-diagram-link-href-target"
                        role="error"
                        test="exists(//oscal:resource[@uuid = substring-after(current()/@href, '#')])">A FedRAMP OSCAL SSP authorization-boundary
                        diagram link references a back-matter resource representing the diagram document.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                 doc:template-reference="System Security Plan Template §9.4"
                 id="network-architecture"
                 see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram">
        <sch:title>Network Architecture Diagram</sch:title>
        <sch:rule context="oscal:system-characteristics"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                  doc:template-reference="System Security Plan Template §9.4">
            <sch:assert diagnostics="has-network-architecture-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                        doc:template-reference="System Security Plan Template §9.4"
                        id="has-network-architecture"
                        role="error"
                        test="oscal:network-architecture">A FedRAMP OSCAL SSP includes a network-architecture in its
                        system-characteristics.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:network-architecture"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                  doc:template-reference="System Security Plan Template §9.4">
            <sch:assert diagnostics="has-network-architecture-description-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                        doc:template-reference="System Security Plan Template §9.4"
                        id="has-network-architecture-description"
                        role="error"
                        test="oscal:description">A FedRAMP OSCAL SSP has a network-architecture description.</sch:assert>
            <sch:assert diagnostics="has-network-architecture-diagram-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                        doc:template-reference="System Security Plan Template §9.4"
                        id="has-network-architecture-diagram"
                        role="error"
                        test="oscal:diagram">A FedRAMP OSCAL SSP has at least one network-architecture diagram.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:network-architecture/oscal:diagram"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                  doc:template-reference="System Security Plan Template §9.4">
            <sch:assert diagnostics="has-network-architecture-diagram-uuid-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                        doc:template-reference="System Security Plan Template §9.4"
                        id="has-network-architecture-diagram-uuid"
                        role="error"
                        test="@uuid">Each FedRAMP OSCAL SSP network-architecture diagram has a uuid attribute.</sch:assert>
            <sch:assert diagnostics="has-network-architecture-diagram-description-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                        doc:template-reference="System Security Plan Template §9.4"
                        id="has-network-architecture-diagram-description"
                        role="error"
                        test="oscal:description">Each FedRAMP OSCAL SSP network-architecture diagram has a description.</sch:assert>
            <sch:assert diagnostics="has-network-architecture-diagram-link-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                        doc:template-reference="System Security Plan Template §9.4"
                        id="has-network-architecture-diagram-link"
                        role="error"
                        test="oscal:link">Each FedRAMP OSCAL SSP network-architecture diagram has a link.</sch:assert>
            <sch:assert diagnostics="has-network-architecture-diagram-caption-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                        doc:template-reference="System Security Plan Template §9.4"
                        id="has-network-architecture-diagram-caption"
                        role="error"
                        test="oscal:caption">Each FedRAMP OSCAL SSP network-architecture diagram has a caption.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:network-architecture/oscal:diagram/oscal:link"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                  doc:template-reference="System Security Plan Template §9.4">
            <sch:assert diagnostics="has-network-architecture-diagram-link-rel-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                        doc:template-reference="System Security Plan Template §9.4"
                        id="has-network-architecture-diagram-link-rel"
                        role="error"
                        test="@rel">Each FedRAMP OSCAL SSP network-architecture diagram has a link rel attribute.</sch:assert>
            <sch:assert diagnostics="has-network-architecture-diagram-link-rel-allowed-value-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                        doc:template-reference="System Security Plan Template §9.4"
                        id="has-network-architecture-diagram-link-rel-allowed-value"
                        role="error"
                        test="@rel = 'diagram'">Each FedRAMP OSCAL SSP network-architecture diagram has a link rel attribute with the value
                        "diagram".</sch:assert>
            <sch:assert diagnostics="has-network-architecture-diagram-link-href-target-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram"
                        doc:template-reference="System Security Plan Template §9.4"
                        id="has-network-architecture-diagram-link-href-target"
                        role="error"
                        test="exists(//oscal:resource[@uuid = substring-after(current()/@href, '#')])">A FedRAMP OSCAL SSP network-architecture
                        diagram link references a back-matter resource representing the diagram document.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                 doc:template-reference="System Security Plan Template §10.1"
                 id="data-flow"
                 see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram">
        <sch:title>Data Flow Diagram</sch:title>
        <sch:rule context="oscal:system-characteristics"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                  doc:template-reference="System Security Plan Template §10.1">
            <sch:assert diagnostics="has-data-flow-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                        doc:template-reference="System Security Plan Template §10.1"
                        id="has-data-flow"
                        role="error"
                        test="oscal:data-flow">A FedRAMP OSCAL SSP includes a data-flow in its system-characteristics.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:data-flow"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                  doc:template-reference="System Security Plan Template §10.1">
            <sch:assert diagnostics="has-data-flow-description-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                        doc:template-reference="System Security Plan Template §10.1"
                        id="has-data-flow-description"
                        role="error"
                        test="oscal:description">A FedRAMP OSCAL SSP has a data-flow description.</sch:assert>
            <sch:assert diagnostics="has-data-flow-diagram-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                        doc:template-reference="System Security Plan Template §10.1"
                        id="has-data-flow-diagram"
                        role="error"
                        test="oscal:diagram">A FedRAMP OSCAL SSP has at least one data-flow diagram.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:data-flow/oscal:diagram"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                  doc:template-reference="System Security Plan Template §10.1">
            <sch:assert diagnostics="has-data-flow-diagram-uuid-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                        doc:template-reference="System Security Plan Template §10.1"
                        id="has-data-flow-diagram-uuid"
                        role="error"
                        test="@uuid">Each FedRAMP OSCAL SSP data-flow diagram has a uuid attribute.</sch:assert>
            <sch:assert diagnostics="has-data-flow-diagram-description-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                        doc:template-reference="System Security Plan Template §10.1"
                        id="has-data-flow-diagram-description"
                        role="error"
                        test="oscal:description">Each FedRAMP OSCAL SSP data-flow diagram has a description.</sch:assert>
            <sch:assert diagnostics="has-data-flow-diagram-link-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                        doc:template-reference="System Security Plan Template §10.1"
                        id="has-data-flow-diagram-link"
                        role="error"
                        test="oscal:link">Each FedRAMP OSCAL SSP data-flow diagram has a link.</sch:assert>
            <sch:assert diagnostics="has-data-flow-diagram-caption-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                        doc:template-reference="System Security Plan Template §10.1"
                        id="has-data-flow-diagram-caption"
                        role="error"
                        test="oscal:caption">Each FedRAMP OSCAL SSP data-flow diagram has a caption.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:data-flow/oscal:diagram/oscal:link"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                  doc:template-reference="System Security Plan Template §10.1">
            <sch:assert diagnostics="has-data-flow-diagram-link-rel-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                        doc:template-reference="System Security Plan Template §10.1"
                        id="has-data-flow-diagram-link-rel"
                        role="error"
                        test="@rel">Each FedRAMP OSCAL SSP data-flow diagram has a link rel attribute.</sch:assert>
            <sch:assert diagnostics="has-data-flow-diagram-link-rel-allowed-value-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                        doc:template-reference="System Security Plan Template §10.1"
                        id="has-data-flow-diagram-link-rel-allowed-value"
                        role="error"
                        test="@rel = 'diagram'">Each FedRAMP OSCAL SSP data-flow diagram has a link rel attribute with the value
                        "diagram".</sch:assert>
            <sch:assert diagnostics="has-data-flow-diagram-link-href-target-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram"
                        doc:template-reference="System Security Plan Template §10.1"
                        id="has-data-flow-diagram-link-href-target"
                        role="error"
                        test="exists(//oscal:resource[@uuid = substring-after(current()/@href, '#')])">A FedRAMP OSCAL SSP data-flow diagram link
                        references a back-matter resource representing the diagram document.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern doc:template-reference="System Security Plan Template §13"
                 id="control-implementation">
        <sch:rule context="oscal:system-security-plan"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.1"
                  doc:template-reference="System Security Plan Template §13"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.1">
            <sch:assert diagnostics="system-security-plan-has-import-profile-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.1"
                        doc:template-reference="System Security Plan Template §13"
                        id="system-security-plan-has-import-profile"
                        role="error"
                        test="exists(oscal:import-profile)">A FedRAMP OSCAL SSP declares the related FedRAMP OSCAL Profile using an import-profile
                        element.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:import-profile"
                  doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.1"
                  doc:template-reference="System Security Plan Template §13"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.1">
            <sch:assert diagnostics="import-profile-has-href-attribute-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.1"
                        doc:template-reference="System Security Plan Template §13"
                        id="import-profile-has-href-attribute"
                        role="error"
                        test="@href">The import-profile element has an href attribute.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:implemented-requirement"
                  doc:template-reference="System Security Plan Template §13">
            <sch:assert diagnostics="implemented-requirement-has-implementation-status-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                        doc:template-reference="System Security Plan Template §13"
                        id="implemented-requirement-has-implementation-status"
                        role="error"
                        see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                        test="exists(oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'implementation-status'])">Every
                        implemented-requirement has an implementation-status property.</sch:assert>
            <sch:assert diagnostics="implemented-requirement-has-planned-completion-date-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                        doc:template-reference="System Security Plan Template §13"
                        id="implemented-requirement-has-planned-completion-date"
                        role="error"
                        see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                        test="
                    if (oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'implementation-status' and @value eq 'planned']) then
                        exists(current()/oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'planned-completion-date' and @value castable as xs:date])
                    else
                        true()">Planned control implementations have a planned completion date.</sch:assert>
            <sch:assert diagnostics="implemented-requirement-has-control-origination-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3.1.1"
                        doc:template-reference="System Security Plan Template §13"
                        id="implemented-requirement-has-control-origination"
                        role="error"
                        see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3.1.1"
                        test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'control-origination']">Every implemented-requirement has
                        a control-origination property.</sch:assert>
            <sch:let name="control-originations"
                     value="$fedramp-values//fedramp:value-set[@name eq 'control-origination']//fedramp:enum/@value" />
            <sch:assert diagnostics="implemented-requirement-has-allowed-control-origination-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3.1.1"
                        doc:template-reference="System Security Plan Template §13"
                        id="implemented-requirement-has-allowed-control-origination"
                        role="error"
                        see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3.1.1"
                        test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'control-origination' and @value = $control-originations]">
                        Every implemented-requirement has an allowed control-origination property.</sch:assert>
            <sch:assert diagnostics="implemented-requirement-has-leveraged-authorization-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3.1.1"
                        doc:template-reference="System Security Plan Template §13"
                        id="implemented-requirement-has-leveraged-authorization"
                        role="error"
                        see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3.1.1"
                        test="
                    if (oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'control-origination' and @value eq 'inherited'])
                    then (: there must be a leveraged-authorization-uuid property :)
                        exists(oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'leveraged-authorization-uuid'])
                        and
                        (: the referenced leveraged-authorization must exist :)
                        exists(//oscal:leveraged-authorization[@uuid = current()/oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'leveraged-authorization-uuid']/@value])
                    else
                        true()">Every implemented-requirement with a control-origination property of "inherited" references a
leveraged-authorization.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'implementation-status' and @value ne 'implemented']"
                  doc:template-reference="System Security Plan Template §13">
            <sch:assert diagnostics="implemented-requirement-has-implementation-status-remarks-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                        doc:template-reference="System Security Plan Template §13"
                        id="implemented-requirement-has-implementation-status-remarks"
                        role="error"
                        test="oscal:remarks">Incomplete control implementations have an explanation.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'planned-completion-date']"
                  doc:template-reference="System Security Plan Template §13">
            <sch:assert diagnostics="planned-completion-date-is-valid-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                        doc:template-reference="System Security Plan Template §13"
                        id="planned-completion-date-is-valid"
                        role="error"
                        see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                        test="@value castable as xs:date">Planned completion date is valid.</sch:assert>
            <sch:assert diagnostics="planned-completion-date-is-not-past-diagnostic"
                        doc:guide-reference="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                        id="planned-completion-date-is-not-past"
                        role="error"
                        see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3"
                        test="@value castable as xs:date and xs:date(@value) gt current-date()">Planned completion date is not past.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:diagnostics>
        <sch:diagnostic doc:assertion="no-registry-values"
                        doc:context="/o:system-security-plan"
                        id="no-registry-values-diagnostic">The registry values at the path ' 
        <sch:value-of select="$registry-base-path" />' are not present, this configuration is invalid.</sch:diagnostic>
        <sch:diagnostic doc:assertion="no-security-sensitivity-level"
                        doc:context="/o:system-security-plan"
                        id="no-security-sensitivity-level-diagnostic">[Section C Check 1.a] No sensitivity level was found As a result, no more
                        validation processing can occur.</sch:diagnostic>
        <sch:diagnostic doc:assertion="invalid-security-sensitivity-level"
                        doc:context="/o:system-security-plan"
                        id="invalid-security-sensitivity-level-diagnostic">[Section C Check 1.a] 
        <sch:value-of select="./name()" />is an invalid value of ' 
        <sch:value-of select="lv:sensitivity-level(/)" />', not an allowed value of 
        <sch:value-of select="$corrections" />. No more validation processing can occur.</sch:diagnostic>
        <sch:diagnostic doc:assertion="incomplete-core-implemented-requirements"
                        doc:context="/o:system-security-plan/o:control-implementation"
                        id="incomplete-core-implemented-requirements-diagnostic">[Section C Check 3] A FedRAMP SSP must implement the most important 
        <sch:value-of select="count($core-missing)" />core 
        <sch:value-of select="
                    if (count($core-missing) = 1) then
                        ' control'
                    else
                        ' controls'" />: 
        <sch:value-of select="$core-missing/@id" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="incomplete-all-implemented-requirements"
                        doc:context="/o:system-security-plan/o:control-implementation"
                        id="incomplete-all-implemented-requirements-diagnostic">[Section C Check 2] A FedRAMP SSP must implement 
        <sch:value-of select="count($all-missing)" />
        <sch:value-of select="
                    if (count($all-missing) = 1) then
                        ' control'
                    else
                        ' controls'" />overall: 
        <sch:value-of select="$all-missing/@id" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="extraneous-implemented-requirements"
                        doc:context="/o:system-security-plan/o:control-implementation"
                        id="extraneous-implemented-requirements-diagnostic">[Section C Check 2] A FedRAMP SSP must implement 
        <sch:value-of select="count($extraneous)" />extraneous 
        <sch:value-of select="
                    if (count($extraneous) = 1) then
                        ' control'
                    else
                        ' controls'" />not needed given the selected profile: 
        <sch:value-of select="$extraneous/@control-id" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="invalid-implementation-status"
                        doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement"
                        id="invalid-implementation-status-diagnostic">[Section C Check 2] Invalid status ' 
        <sch:value-of select="$status" />' for 
        <sch:value-of select="./@control-id" />, must be 
        <sch:value-of select="$corrections" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="missing-response-points"
                        doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement"
                        id="missing-response-points-diagnostic">[Section C Check 2] A FedRAMP SSP must implement a statement for each of the
                        following lettered response points for required controls: 
        <sch:value-of select="$missing/@id" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="missing-response-components"
                        doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement"
                        id="missing-response-components-diagnostic">[Section D Checks] Response statements for 
        <sch:value-of select="./@statement-id" />must have at least 
        <sch:value-of select="$required-components-count" />
        <sch:value-of select="
                    if (count($components-count) = 1) then
                        ' component'
                    else
                        ' components'" />with a description. There are 
        <sch:value-of select="$components-count" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="extraneous-response-description"
                        doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:description"
                        id="extraneous-response-description-diagnostic">[Section D Checks] Response statement 
        <sch:value-of select="../@statement-id" />has a description not within a component. That was previously allowed, but not recommended. It will
        soon be syntactically invalid and deprecated.</sch:diagnostic>
        <sch:diagnostic doc:assertion="extraneous-response-remarks"
                        doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:remarks"
                        id="extraneous-response-remarks-diagnostic">[Section D Checks] Response statement 
        <sch:value-of select="../@statement-id" />has remarks not within a component. That was previously allowed, but not recommended. It will soon
        be syntactically invalid and deprecated.</sch:diagnostic>
        <sch:diagnostic doc:assertion="invalid-component-match"
                        doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component"
                        id="invalid-component-match-diagnostic">[Section D Checks] Response statement 
        <sch:value-of select="../@statement-id" />with component reference UUID ' 
        <sch:value-of select="$component-ref" />' is not in the system implementation inventory, and cannot be used to define a
        control.</sch:diagnostic>
        <sch:diagnostic doc:assertion="missing-component-description"
                        doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component"
                        id="missing-component-description-diagnostic">[Section D Checks] Response statement 
        <sch:value-of select="../@statement-id" />has a component, but that component is missing a required description node.</sch:diagnostic>
        <sch:diagnostic doc:assertion="incomplete-response-description"
                        doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:description"
                        id="incomplete-response-description-diagnostic">[Section D Checks] Response statement component description for 
        <sch:value-of select="../../@statement-id" />is too short with 
        <sch:value-of select="$description-length" />characters. It must be 
        <sch:value-of select="$required-length" />characters long.</sch:diagnostic>
        <sch:diagnostic doc:assertion="incomplete-response-remarks"
                        doc:context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:remarks"
                        id="incomplete-response-remarks-diagnostic">[Section D Checks] Response statement component remarks for 
        <sch:value-of select="../../@statement-id" />is too short with 
        <sch:value-of select="$remarks-length" />characters. It must be 
        <sch:value-of select="$required-length" />characters long.</sch:diagnostic>
        <sch:diagnostic doc:assertion="incorrect-role-association"
                        doc:context="/o:system-security-plan/o:metadata"
                        id="incorrect-role-association-diagnostic">[Section C Check 2] A FedRAMP SSP must define a responsible party with 
        <sch:value-of select="count($extraneous-roles)" />
        <sch:value-of select="
                    if (count($extraneous-roles) = 1) then
                        ' role'
                    else
                        ' roles'" />not defined in the role: 
        <sch:value-of select="$extraneous-roles/@role-id" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="incorrect-party-association"
                        doc:context="/o:system-security-plan/o:metadata"
                        id="incorrect-party-association-diagnostic">[Section C Check 2] A FedRAMP SSP must define a responsible party with 
        <sch:value-of select="count($extraneous-parties)" />
        <sch:value-of select="
                    if (count($extraneous-parties) = 1) then
                        ' party'
                    else
                        ' parties'" />is not a defined party: 
        <sch:value-of select="$extraneous-parties/o:party-uuid" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="resource-uuid-required"
                        doc:context="/o:system-security-plan/o:back-matter/o:resource"
                        id="resource-uuid-required-diagnostic">A FedRAMP SSP must include back-matter resource missing a UUID.</sch:diagnostic>
        <sch:diagnostic doc:assertion="resource-rlink-required"
                        doc:context="/o:system-security-plan/o:back-matter/o:resource/o:rlink"
                        id="resource-rlink-required-diagnostic">A FedRAMP SSP must reference back-matter resource: 
        <sch:value-of select="./@href" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="resource-base64-available-filename"
                        doc:context="/o:system-security-plan/o:back-matter/o:resource/o:base64"
                        id="resource-base64-available-filename-diagnostic">This base64 lacks a filename attribute.</sch:diagnostic>
        <sch:diagnostic doc:assertion="resource-base64-available-media-type"
                        doc:context="/o:system-security-plan/o:back-matter/o:resource/o:base64"
                        id="resource-base64-available-media-type-diagnostic">This base64 lacks a media-type attribute.</sch:diagnostic>
        <sch:diagnostic doc:assertion="resource-has-uuid"
                        doc:context="oscal:resource"
                        id="resource-has-uuid-diagnostic">This resource lacks a uuid attribute.</sch:diagnostic>
        <sch:diagnostic doc:assertion="resource-has-title"
                        doc:context="oscal:resource"
                        id="resource-has-title-diagnostic">This resource lacks a title.</sch:diagnostic>
        <sch:diagnostic doc:assertion="resource-has-rlink"
                        doc:context="oscal:resource"
                        id="resource-has-rlink-diagnostic">This resource lacks a rlink element.</sch:diagnostic>
        <sch:diagnostic doc:assertion="resource-is-referenced"
                        doc:context="oscal:resource"
                        id="resource-is-referenced-diagnostic">This resource lacks a reference within the document (but does not).</sch:diagnostic>
        <sch:diagnostic doc:assertion="attachment-type-is-valid"
                        doc:context="oscal:back-matter/oscal:resource/oscal:prop[@name = 'type']"
                        id="attachment-type-is-valid-diagnostic">Found unknown attachment type « 
        <sch:value-of select="@value" />» in 
        <sch:value-of select="
                    if (parent::oscal:resource/oscal:title) then
                        concat('&#34;', parent::oscal:resource/oscal:title, '&#34;')
                    else
                        'untitled'" />resource.</sch:diagnostic>
        <sch:diagnostic doc:assertion="rlink-has-href"
                        doc:context="oscal:back-matter/oscal:resource/oscal:rlink"
                        id="rlink-has-href-diagnostic">This rlink lacks an href attribute.</sch:diagnostic>
        <sch:diagnostic doc:context=""
                        id="has-allowed-media-type-diagnostic">This 
        <sch:value-of select="name(parent::node())" />has a media-type=" 
        <sch:value-of select="current()/@media-type" />" which is not in the list of allowed media types. Allowed media types are 
        <sch:value-of select="string-join($media-types, ' ∨ ')" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="resource-has-base64"
                        doc:context="oscal:back-matter/oscal:resource"
                        id="resource-has-base64-diagnostic"
                        xmlns="http://csrc.nist.gov/ns/oscal/1.0">This resource should have a base64 element.</sch:diagnostic>
        <sch:diagnostic doc:assertion="resource-base64-cardinality"
                        doc:context="oscal:back-matter/oscal:resource"
                        id="resource-base64-cardinality-diagnostic"
                        xmlns="http://csrc.nist.gov/ns/oscal/1.0">This resource must not have more than one base64 element.</sch:diagnostic>
        <sch:diagnostic doc:assertion="base64-has-filename"
                        doc:context="oscal:back-matter/oscal:resource/oscal:base64"
                        id="base64-has-filename-diagnostic"
                        xmlns="http://csrc.nist.gov/ns/oscal/1.0">This base64 must have a filename attribute.</sch:diagnostic>
        <sch:diagnostic doc:assertion="base64-has-media-type"
                        doc:context="oscal:back-matter/oscal:resource/oscal:base64"
                        id="base64-has-media-type-diagnostic"
                        xmlns="http://csrc.nist.gov/ns/oscal/1.0">This base64 must have a media-type attribute.</sch:diagnostic>
        <sch:diagnostic doc:assertion="base64-has-content"
                        doc:context="oscal:back-matter/oscal:resource/oscal:base64"
                        id="base64-has-content-diagnostic"
                        xmlns="http://csrc.nist.gov/ns/oscal/1.0">This base64 must have content.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-fedramp-acronyms"
                        doc:context="oscal:back-matter"
                        id="has-fedramp-acronyms-diagnostic">This FedRAMP OSCAL SSP lacks the FedRAMP Master Acronym and Glossary.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-fedramp-citations"
                        doc:context="oscal:back-matter"
                        id="has-fedramp-citations-diagnostic">This FedRAMP OSCAL SSP lacks the FedRAMP Applicable Laws and
                        Regulations.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-fedramp-logo"
                        doc:context="oscal:back-matter"
                        id="has-fedramp-logo-diagnostic">This FedRAMP OSCAL SSP lacks the FedRAMP Logo.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-user-guide"
                        doc:context="oscal:back-matter"
                        id="has-user-guide-diagnostic">This FedRAMP OSCAL SSP lacks a User Guide.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-rules-of-behavior"
                        doc:context="oscal:back-matter"
                        id="has-rules-of-behavior-diagnostic">This FedRAMP OSCAL SSP lacks a Rules of Behavior.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-information-system-contingency-plan"
                        doc:context="oscal:back-matter"
                        id="has-information-system-contingency-plan-diagnostic">This FedRAMP OSCAL SSP lacks a Contingency Plan.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-configuration-management-plan"
                        doc:context="oscal:back-matter"
                        id="has-configuration-management-plan-diagnostic">This FedRAMP OSCAL SSP lacks a Configuration Management
                        Plan.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-incident-response-plan"
                        doc:context="oscal:back-matter"
                        id="has-incident-response-plan-diagnostic">This FedRAMP OSCAL SSP lacks an Incident Response Plan.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-separation-of-duties-matrix"
                        doc:context="oscal:back-matter"
                        id="has-separation-of-duties-matrix-diagnostic">This FedRAMP OSCAL SSP lacks a Separation of Duties Matrix.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-policy-link"
                        doc:context="oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')]"
                        id="has-policy-link-diagnostic">
        <sch:value-of select="local-name()" />
        <sch:value-of select="@control-id" />
        <sch:span class="message">lacks policy reference(s) (via by-component link)</sch:span>.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-policy-attachment-resource"
                        doc:context="oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')]"
                        id="has-policy-attachment-resource-diagnostic">
        <sch:value-of select="local-name()" />
        <sch:value-of select="@control-id" />
        <sch:span class="message">lacks policy attachment resource(s)</sch:span>
        <sch:value-of select="string-join($policy-hrefs, ', ')" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-procedure-link"
                        doc:context="oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')]"
                        id="has-procedure-link-diagnostic">
        <sch:value-of select="local-name()" />
        <sch:value-of select="@control-id" />
        <sch:span class="message">lacks procedure reference(s) (via by-component link)</sch:span>.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-procedure-attachment-resource"
                        doc:context="oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')]"
                        id="has-procedure-attachment-resource-diagnostic">
        <sch:value-of select="local-name()" />
        <sch:value-of select="@control-id" />
        <sch:span class="message">lacks procedure attachment resource(s)</sch:span>
        <sch:value-of select="string-join($procedure-hrefs, ', ')" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-reuse"
                        doc:context="oscal:by-component/oscal:link[@rel = ('policy', 'procedure')]"
                        id="has-reuse-diagnostic">A policy or procedure reference was incorrectly re-used.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-privacy-poc-role"
                        doc:context="oscal:metadata"
                        id="has-privacy-poc-role-diagnostic">This FedRAMP OSCAL SSP lacks a Privacy Point of Contact role.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-responsible-party-privacy-poc-role"
                        doc:context="oscal:metadata"
                        id="has-responsible-party-privacy-poc-role-diagnostic">This FedRAMP OSCAL SSP lacks a Privacy Point of Contact responsible
                        party role reference.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-responsible-privacy-poc-party-uuid"
                        doc:context="oscal:metadata"
                        id="has-responsible-privacy-poc-party-uuid-diagnostic">This FedRAMP OSCAL SSP lacks a Privacy Point of Contact responsible
                        party role reference identifying the party by UUID.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-privacy-poc"
                        doc:context="oscal:metadata"
                        id="has-privacy-poc-diagnostic">This FedRAMP OSCAL SSP lacks a Privacy Point of Contact.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-correct-yes-or-no-answer"
                        doc:context="oscal:prop[@name = 'privacy-sensitive'] | oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and matches(@name, '^pta-\d$')]"
                        id="has-correct-yes-or-no-answer-diagnostic">This property has an incorrect value: should be "yes" or "no".</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-privacy-sensitive-designation"
                        doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
                        id="has-privacy-sensitive-designation-diagnostic">The privacy-sensitive designation is missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-pta-question-1"
                        doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
                        id="has-pta-question-1-diagnostic">The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #1
                        is missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-pta-question-2"
                        doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
                        id="has-pta-question-2-diagnostic">The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #2
                        is missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-pta-question-3"
                        doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
                        id="has-pta-question-3-diagnostic">The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #3
                        is missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-pta-question-4"
                        doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
                        id="has-pta-question-4-diagnostic">The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #4
                        is missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-all-pta-questions"
                        doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
                        id="has-all-pta-questions-diagnostic">One or more of the four PTA questions is missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-correct-pta-question-cardinality"
                        doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
                        id="has-correct-pta-question-cardinality-diagnostic">One or more of the four PTA questions is a duplicate.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-sorn"
                        doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
                        id="has-sorn-diagnostic">The SORN ID is missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-pia"
                        doc:context="oscal:back-matter"
                        id="has-pia-diagnostic">This FedRAMP OSCAL SSP lacks a Privacy Impact Analysis.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-CMVP-validation"
                        doc:context="oscal:system-implementation"
                        id="has-CMVP-validation-diagnostic">This FedRAMP OSCAL SSP does not declare one or more FIPS 140 validated
                        modules.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-CMVP-validation-reference"
                        doc:context="oscal:component[@type = 'validation']"
                        id="has-CMVP-validation-reference-diagnostic">This validation component or inventory-item lacks a validation-reference
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-CMVP-validation-details"
                        doc:context="oscal:component[@type = 'validation']"
                        id="has-CMVP-validation-details-diagnostic">This validation component or inventory-item lacks a validation-details
                        link.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-credible-CMVP-validation-reference"
                        doc:context="oscal:prop[@name = 'validation-reference']"
                        id="has-credible-CMVP-validation-reference-diagnostic">This validation-reference property does not resemble a CMVP
                        certificate number.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-consonant-CMVP-validation-reference"
                        doc:context="oscal:prop[@name = 'validation-reference']"
                        id="has-consonant-CMVP-validation-reference-diagnostic">This validation-reference property does not match its sibling
                        validation-details href.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-credible-CMVP-validation-details"
                        doc:context="oscal:prop[@name = 'validation-details']"
                        id="has-credible-CMVP-validation-details-diagnostic">This validation-details link href attribute does not resemble a CMVP
                        certificate URL.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-consonant-CMVP-validation-details"
                        doc:context="oscal:prop[@name = 'validation-details']"
                        id="has-consonant-CMVP-validation-details-diagnostic">This validation-details link href attribute does not match its sibling
                        validation-reference value.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-security-sensitivity-level"
                        doc:context="oscal:system-characteristics"
                        id="has-security-sensitivity-level-diagnostic">This FedRAMP OSCAL SSP lacks a FIPS 199 categorization.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-security-impact-level"
                        doc:context="oscal:system-characteristics"
                        id="has-security-impact-level-diagnostic">This FedRAMP OSCAL SSP lacks a security impact level.</sch:diagnostic>
        <sch:diagnostic doc:context=""
                        id="has-allowed-security-sensitivity-level-diagnostic">Invalid security-sensitivity-level " 
        <sch:value-of select="." />". It must have one of the following 
        <sch:value-of select="count($security-sensitivity-levels)" />values: 
        <sch:value-of select="string-join($security-sensitivity-levels, ' ∨ ')" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-security-objective-confidentiality"
                        doc:context="oscal:security-impact-level"
                        id="has-security-objective-confidentiality-diagnostic">This FedRAMP OSCAL SSP lacks a confidentiality security
                        objective.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-security-objective-integrity"
                        doc:context="oscal:security-impact-level"
                        id="has-security-objective-integrity-diagnostic">This FedRAMP OSCAL SSP lacks an integrity security
                        objective.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-security-objective-availability"
                        doc:context="oscal:security-impact-level"
                        id="has-security-objective-availability-diagnostic">This FedRAMP OSCAL SSP lacks an availability security
                        objective.</sch:diagnostic>
        <sch:diagnostic doc:context=""
                        id="has-allowed-security-objective-value-diagnostic">Invalid 
        <sch:value-of select="name()" />" 
        <sch:value-of select="." />". It must have one of the following 
        <sch:value-of select="count($security-objective-levels)" />values: 
        <sch:value-of select="string-join($security-objective-levels, ' ∨ ')" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="system-information-has-information-type"
                        doc:context="oscal:system-information"
                        id="system-information-has-information-type-diagnostic">A FedRAMP OSCAL SSP lacks at least one
                        information-type.</sch:diagnostic>
        <sch:diagnostic doc:assertion="information-type-has-title"
                        doc:context="oscal:information-type"
                        id="information-type-has-title-diagnostic">A FedRAMP OSCAL SSP information-type lacks a title.</sch:diagnostic>
        <sch:diagnostic doc:assertion="information-type-has-description"
                        doc:context="oscal:information-type"
                        id="information-type-has-description-diagnostic">A FedRAMP OSCAL SSP information-type lacks a description.</sch:diagnostic>
        <sch:diagnostic doc:assertion="information-type-has-categorization"
                        doc:context="oscal:information-type"
                        id="information-type-has-categorization-diagnostic">A FedRAMP OSCAL SSP information-type lacks at least one
                        categorization.</sch:diagnostic>
        <sch:diagnostic doc:assertion="information-type-has-confidentiality-impact"
                        doc:context="oscal:information-type"
                        id="information-type-has-confidentiality-impact-diagnostic">A FedRAMP OSCAL SSP information-type lacks a
                        confidentiality-impact.</sch:diagnostic>
        <sch:diagnostic doc:assertion="information-type-has-integrity-impact"
                        doc:context="oscal:information-type"
                        id="information-type-has-integrity-impact-diagnostic">A FedRAMP OSCAL SSP information-type lacks a
                        integrity-impact.</sch:diagnostic>
        <sch:diagnostic doc:assertion="information-type-has-availability-impact"
                        doc:context="oscal:information-type"
                        id="information-type-has-availability-impact-diagnostic">A FedRAMP OSCAL SSP information-type lacks a
                        availability-impact.</sch:diagnostic>
        <sch:diagnostic doc:assertion="categorization-has-system-attribute"
                        doc:context="oscal:categorization"
                        id="categorization-has-system-attribute-diagnostic">A FedRAMP OSCAL SSP information-type categorization lacks a system
                        attribute.</sch:diagnostic>
        <sch:diagnostic doc:assertion="categorization-has-correct-system-attribute"
                        doc:context="oscal:categorization"
                        id="categorization-has-correct-system-attribute-diagnostic">A FedRAMP OSCAL SSP information-type categorization lacks a
                        correct system attribute. The correct value is "https://doi.org/10.6028/NIST.SP.800-60v2r1".</sch:diagnostic>
        <sch:diagnostic doc:assertion="categorization-has-information-type-id"
                        doc:context="oscal:categorization"
                        id="categorization-has-information-type-id-diagnostic">A FedRAMP OSCAL SSP information-type categorization lacks at least one
                        information-type-id.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-allowed-information-type-id"
                        doc:context="oscal:information-type-id"
                        id="has-allowed-information-type-id-diagnostic">A FedRAMP OSCAL SSP information-type-id lacks a SP 800-60v2r1
                        identifier.</sch:diagnostic>
        <sch:diagnostic doc:assertion="cia-impact-has-base"
                        doc:context="oscal:confidentiality-impact | oscal:integrity-impact | oscal:availability-impact"
                        id="cia-impact-has-base-diagnostic">A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact
                        lacks a base element.</sch:diagnostic>
        <sch:diagnostic doc:assertion="cia-impact-has-selected"
                        doc:context="oscal:confidentiality-impact | oscal:integrity-impact | oscal:availability-impact"
                        id="cia-impact-has-selected-diagnostic">A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or
                        availability-impact lacks a selected element.</sch:diagnostic>
        <sch:diagnostic doc:assertion="cia-impact-has-approved-fips-categorization"
                        doc:context="oscal:base | oscal:selected"
                        id="cia-impact-has-approved-fips-categorization-diagnostic">A FedRAMP OSCAL SSP information-type confidentiality-,
                        integrity-, or availability-impact base or select element lacks an approved value.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-security-eauth-level"
                        doc:context="oscal:system-characteristics"
                        id="has-security-eauth-level-diagnostic">This FedRAMP OSCAL SSP lacks a Digital Identity Determination
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-identity-assurance-level"
                        doc:context="oscal:system-characteristics"
                        id="has-identity-assurance-level-diagnostic">A FedRAMP OSCAL SSP may lack a Digital Identity Determination
                        identity-assurance-level property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-authenticator-assurance-level"
                        doc:context="oscal:system-characteristics"
                        id="has-authenticator-assurance-level-diagnostic">A FedRAMP OSCAL SSP may lack a Digital Identity Determination
                        authenticator-assurance-level property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-federation-assurance-level"
                        doc:context="oscal:system-characteristics"
                        id="has-federation-assurance-level-diagnostic">A FedRAMP OSCAL SSP may lack a Digital Identity Determination
                        federation-assurance-level property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-allowed-security-eauth-level"
                        doc:context="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'security-eauth' and @name = 'security-eauth-level']"
                        id="has-allowed-security-eauth-level-diagnostic">This FedRAMP OSCAL SSP lacks a Digital Identity Determination property with
                        an allowed value.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-allowed-identity-assurance-level"
                        doc:context="oscal:prop[@name = 'identity-assurance-level']"
                        id="has-allowed-identity-assurance-level-diagnostic">A FedRAMP OSCAL SSP may lack an allowed Digital Identity Determination
                        identity-assurance-level property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-allowed-authenticator-assurance-level"
                        doc:context="oscal:prop[@name = 'authenticator-assurance-level']"
                        id="has-allowed-authenticator-assurance-level-diagnostic">A FedRAMP OSCAL SSP may lack an allowed Digital Identity
                        Determination authenticator-assurance-level property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-allowed-federation-assurance-level"
                        doc:context="oscal:prop[@name = 'federation-assurance-level']"
                        id="has-allowed-federation-assurance-level-diagnostic">A FedRAMP OSCAL SSP may lack an allowed Digital Identity Determination
                        federation-assurance-level property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-inventory-items"
                        doc:context="/oscal:system-security-plan/oscal:system-implementation"
                        id="has-inventory-items-diagnostic">This FedRAMP OSCAL SSP lacks inventory-item elements.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-unique-asset-id"
                        doc:context="oscal:prop[@name = 'asset-id']"
                        id="has-unique-asset-id-diagnostic">This asset id 
        <sch:value-of select="@asset-id" />is not unique. An asset id must be unique within the scope of a FedRAMP OSCAL SSP
        document.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-allowed-asset-type"
                        doc:context="oscal:prop[@name = 'asset-type']"
                        id="has-allowed-asset-type-diagnostic">
        <sch:value-of select="name()" />should have a FedRAMP asset type 
        <sch:value-of select="string-join($asset-types, ' ∨ ')" />(not " 
        <sch:value-of select="@value" />").</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-allowed-virtual"
                        doc:context="oscal:prop[@name = 'virtual']"
                        id="has-allowed-virtual-diagnostic">
        <sch:value-of select="name()" />must have an allowed value 
        <sch:value-of select="string-join($virtuals, ' ∨ ')" />(not " 
        <sch:value-of select="@value" />").</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-allowed-public"
                        doc:context="oscal:prop[@name = 'public']"
                        id="has-allowed-public-diagnostic">
        <sch:value-of select="name()" />must have an allowed value 
        <sch:value-of select="string-join($publics, ' ∨ ')" />(not " 
        <sch:value-of select="@value" />").</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-allowed-allows-authenticated-scan"
                        doc:context="oscal:prop[@name = 'allows-authenticated-scan']"
                        id="has-allowed-allows-authenticated-scan-diagnostic">
        <sch:value-of select="name()" />must have an allowed value 
        <sch:value-of select="string-join($allows-authenticated-scans, ' ∨ ')" />(not " 
        <sch:value-of select="@value" />").</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-allowed-is-scanned"
                        doc:context="oscal:prop[@name = 'is-scanned']"
                        id="has-allowed-is-scanned-diagnostic">
        <sch:value-of select="name()" />must have an allowed value 
        <sch:value-of select="string-join($is-scanneds, ' ∨ ')" />(not " 
        <sch:value-of select="@value" />").</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-allowed-scan-type"
                        doc:context="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'scan-type']"
                        id="has-allowed-scan-type-diagnostic">
        <sch:value-of select="name()" />must have an allowed value 
        <sch:value-of select="string-join($scan-types, ' ∨ ')" />(not " 
        <sch:value-of select="@value" />").</sch:diagnostic>
        <sch:diagnostic doc:assertion="component-has-allowed-type"
                        doc:context="oscal:component"
                        id="component-has-allowed-type-diagnostic">
        <sch:value-of select="name()" />must have an allowed component type 
        <sch:value-of select="string-join($component-types, ' ∨ ')" />(not " 
        <sch:value-of select="@type" />").</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-uuid"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-uuid-diagnostic">This inventory-item lacks a uuid attribute.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-asset-id"
                        doc:context="oscal:inventory-item"
                        id="has-asset-id-diagnostic">This inventory-item lacks an asset-id property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-one-asset-id"
                        doc:context="oscal:inventory-item"
                        id="has-one-asset-id-diagnostic">This inventory-item has more than one asset-id property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-asset-type"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-asset-type-diagnostic">This inventory-item lacks an asset-type property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-asset-type"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-one-asset-type-diagnostic">This inventory-item has more than one asset-type property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-virtual"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-virtual-diagnostic">This inventory-item lacks a virtual property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-virtual"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-one-virtual-diagnostic">This inventory-item has more than one virtual property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-public"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-public-diagnostic">This inventory-item lacks a public property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-public"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-one-public-diagnostic">This inventory-item has more than one public property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-scan-type"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-scan-type-diagnostic">This inventory-item lacks a scan-type property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-scan-type"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-one-scan-type-diagnostic">This inventory-item has more than one scan-type property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-allows-authenticated-scan"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-allows-authenticated-scan-diagnostic">This inventory-item lacks allows-authenticated-scan
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-allows-authenticated-scan"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-one-allows-authenticated-scan-diagnostic">This inventory-item has more than one
                        allows-authenticated-scan property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-baseline-configuration-name"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-baseline-configuration-name-diagnostic">This inventory-item lacks baseline-configuration-name
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-baseline-configuration-name"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-one-baseline-configuration-name-diagnostic">This inventory-item has more than one
                        baseline-configuration-name property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-vendor-name"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-vendor-name-diagnostic">This inventory-item lacks a vendor-name property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-vendor-name"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-one-vendor-name-diagnostic">This inventory-item has more than one vendor-name
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-hardware-model"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-hardware-model-diagnostic">This inventory-item lacks a hardware-model property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-hardware-model"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-one-hardware-model-diagnostic">This inventory-item has more than one hardware-model
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-is-scanned"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-is-scanned-diagnostic">This inventory-item lacks is-scanned property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-is-scanned"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-one-is-scanned-diagnostic">This inventory-item has more than one is-scanned property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-software-name"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('software', 'database')]"
                        id="inventory-item-has-software-name-diagnostic">This inventory-item lacks software-name property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-software-name"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('software', 'database')]"
                        id="inventory-item-has-one-software-name-diagnostic">This inventory-item has more than one software-name
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-software-version"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('software', 'database')]"
                        id="inventory-item-has-software-version-diagnostic">This inventory-item lacks software-version property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-software-version"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('software', 'database')]"
                        id="inventory-item-has-one-software-version-diagnostic">This inventory-item has more than one software-version
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-function"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('software', 'database')]"
                        id="inventory-item-has-function-diagnostic">
        <sch:value-of select="name()" />" 
        <sch:value-of select="oscal:prop[@name = 'asset-type']/@value" />" lacks function property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-function"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('software', 'database')]"
                        id="inventory-item-has-one-function-diagnostic">
        <sch:value-of select="name()" />" 
        <sch:value-of select="oscal:prop[@name = 'asset-type']/@value" />" has more than one function property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="component-has-asset-type"
                        doc:context="/oscal:system-security-plan/oscal:system-implementation/oscal:component[(: a component referenced by any inventory-item :)@uuid = //oscal:inventory-item/oscal:implemented-component/@component-uuid]"
                        id="component-has-asset-type-diagnostic">
        <sch:value-of select="name()" />lacks an asset-type property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="component-has-one-asset-type"
                        doc:context="/oscal:system-security-plan/oscal:system-implementation/oscal:component[(: a component referenced by any inventory-item :)@uuid = //oscal:inventory-item/oscal:implemented-component/@component-uuid]"
                        id="component-has-one-asset-type-diagnostic">
        <sch:value-of select="name()" />has more than one asset-type property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-this-system-component"
                        doc:context="oscal:system-implementation"
                        id="has-this-system-component-diagnostic">This FedRAMP OSCAL SSP lacks a "this-system" component.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-system-id"
                        doc:context="oscal:system-characteristics"
                        id="has-system-id-diagnostic">This FedRAMP OSCAL SSP lacks a FedRAMP system-id.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-system-name"
                        doc:context="oscal:system-characteristics"
                        id="has-system-name-diagnostic">This FedRAMP OSCAL SSP lacks a system-name.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-system-name-short"
                        doc:context="oscal:system-characteristics"
                        id="has-system-name-short-diagnostic">This FedRAMP OSCAL SSP lacks a system-name-short.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-fedramp-authorization-type"
                        doc:context="oscal:system-characteristics"
                        id="has-fedramp-authorization-type-diagnostic">This FedRAMP OSCAL SSP lacks a FedRAMP authorization type.</sch:diagnostic>
        <sch:diagnostic doc:assertion="role-defined-system-owner"
                        doc:context="oscal:metadata"
                        id="role-defined-system-owner-diagnostic">The system-owner role is missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="role-defined-authorizing-official"
                        doc:context="oscal:metadata"
                        id="role-defined-authorizing-official-diagnostic">The authorizing-official role is missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="role-defined-system-poc-management"
                        doc:context="oscal:metadata"
                        id="role-defined-system-poc-management-diagnostic">The system-poc-management role is missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="role-defined-system-poc-technical"
                        doc:context="oscal:metadata"
                        id="role-defined-system-poc-technical-diagnostic">The system-poc-technical role is missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="role-defined-system-poc-other"
                        doc:context="oscal:metadata"
                        id="role-defined-system-poc-other-diagnostic">The system-poc-other role is missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="role-defined-information-system-security-officer"
                        doc:context="oscal:metadata"
                        id="role-defined-information-system-security-officer-diagnostic">The information-system-security-officer role is
                        missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="role-defined-authorizing-official-poc"
                        doc:context="oscal:metadata"
                        id="role-defined-authorizing-official-poc-diagnostic">The authorizing-official-poc role is missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="role-has-title"
                        doc:context="oscal:role"
                        id="role-has-title-diagnostic">This role lacks a title.</sch:diagnostic>
        <sch:diagnostic doc:assertion="role-has-responsible-party"
                        doc:context="oscal:role"
                        id="role-has-responsible-party-diagnostic">This role has no responsible parties.</sch:diagnostic>
        <sch:diagnostic doc:assertion="responsible-party-has-person"
                        doc:context="oscal:responsible-party"
                        id="responsible-party-has-person-diagnostic">This responsible-party party-uuid does not identify a person.</sch:diagnostic>
        <sch:diagnostic doc:assertion="party-has-responsibility"
                        doc:context="oscal:party[@type = 'person']"
                        id="party-has-responsibility-diagnostic">This person has no responsibility.</sch:diagnostic>
        <sch:diagnostic doc:assertion="implemented-requirement-has-responsible-role"
                        doc:context="oscal:implemented-requirement"
                        id="implemented-requirement-has-responsible-role-diagnostic">This implemented-requirement lacks a responsible-role
                        definition.</sch:diagnostic>
        <sch:diagnostic doc:assertion="responsible-role-has-role-definition"
                        doc:context="oscal:responsible-role"
                        id="responsible-role-has-role-definition-diagnostic">This responsible-role references a non-existent role
                        definition.</sch:diagnostic>
        <sch:diagnostic doc:assertion="responsible-role-has-user"
                        doc:context="oscal:responsible-role"
                        id="responsible-role-has-user-diagnostic">This responsible-role lacks a system-implementation user assembly.</sch:diagnostic>
        <sch:diagnostic doc:assertion="distinct-responsible-role-has-user"
                        doc:context="oscal:responsible-role"
                        id="distinct-responsible-role-has-user-diagnostic">Some distinct responsible-role is not referenced in a
                        system-implementation user assembly.</sch:diagnostic>
        <sch:diagnostic doc:assertion="role-id-has-role-definition"
                        doc:context="oscal:role-id"
                        id="role-id-has-role-definition-diagnostic">This role-id references a non-existent role definition.</sch:diagnostic>
        <sch:diagnostic doc:assertion="user-has-role-id"
                        doc:context="oscal:user"
                        id="user-has-role-id-diagnostic">This user lacks a role-id.</sch:diagnostic>
        <sch:diagnostic doc:assertion="user-has-user-type"
                        doc:context="oscal:user"
                        id="user-has-user-type-diagnostic">This user lacks a user type property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="user-has-privilege-level"
                        doc:context="oscal:user"
                        id="user-has-privilege-level-diagnostic">This user lacks a privilege-level property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="user-has-sensitivity-level"
                        doc:context="oscal:user"
                        id="user-has-sensitivity-level-diagnostic">This user lacks a sensitivity level property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="user-has-authorized-privilege"
                        doc:context="oscal:user"
                        id="user-has-authorized-privilege-diagnostic">This user lacks one or more authorized-privileges.</sch:diagnostic>
        <sch:diagnostic doc:assertion="user-user-type-has-allowed-value"
                        doc:context="oscal:user/oscal:prop[@name = 'type']"
                        id="user-user-type-has-allowed-value-diagnostic">This user type property lacks an allowed value.</sch:diagnostic>
        <sch:diagnostic doc:assertion="user-privilege-level-has-allowed-value"
                        doc:context="oscal:user/oscal:prop[@name = 'privilege-level']"
                        id="user-privilege-level-has-allowed-value-diagnostic">User privilege-level property has an allowed value.</sch:diagnostic>
        <sch:diagnostic doc:assertion="user-sensitivity-level-has-allowed-value"
                        doc:context="oscal:user/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal'][@name = 'sensitivity']"
                        id="user-sensitivity-level-has-allowed-value-diagnostic">This user sensitivity level property lacks an allowed
                        value.</sch:diagnostic>
        <sch:diagnostic doc:assertion="authorized-privilege-has-title"
                        doc:context="oscal:user/oscal:authorized-privilege"
                        id="authorized-privilege-has-title-diagnostic">This authorized-privilege lacks a title.</sch:diagnostic>
        <sch:diagnostic doc:assertion="authorized-privilege-has-function-performed"
                        doc:context="oscal:user/oscal:authorized-privilege"
                        id="authorized-privilege-has-function-performed-diagnostic">This authorized-privilege lacks one or more
                        function-performed.</sch:diagnostic>
        <sch:diagnostic doc:assertion="authorized-privilege-has-non-empty-title"
                        doc:context="oscal:authorized-privilege/oscal:title"
                        id="authorized-privilege-has-non-empty-title-diagnostic">This authorized-privilege title is empty.</sch:diagnostic>
        <sch:diagnostic doc:assertion="authorized-privilege-has-non-empty-function-performed"
                        doc:context="oscal:authorized-privilege/oscal:function-performed"
                        id="authorized-privilege-has-non-empty-function-performed-diagnostic">This authorized-privilege lacks a non-empty
                        function-performed.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-authorization-boundary"
                        doc:context="oscal:system-characteristics"
                        id="has-authorization-boundary-diagnostic">This FedRAMP OSCAL SSP lacks an authorization-boundary in its
                        system-characteristics.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-authorization-boundary-description"
                        doc:context="oscal:authorization-boundary"
                        id="has-authorization-boundary-description-diagnostic">This FedRAMP OSCAL SSP lacks an authorization-boundary
                        description.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-authorization-boundary-diagram"
                        doc:context="oscal:authorization-boundary"
                        id="has-authorization-boundary-diagram-diagnostic">This FedRAMP OSCAL SSP lacks at least one authorization-boundary
                        diagram.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-authorization-boundary-diagram-uuid"
                        doc:context="oscal:authorization-boundary/oscal:diagram"
                        id="has-authorization-boundary-diagram-uuid-diagnostic">This FedRAMP OSCAL SSP authorization-boundary diagram lacks a uuid
                        attribute.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-authorization-boundary-diagram-description"
                        doc:context="oscal:authorization-boundary/oscal:diagram"
                        id="has-authorization-boundary-diagram-description-diagnostic">This FedRAMP OSCAL SSP authorization-boundary diagram lacks a
                        description.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-authorization-boundary-diagram-link"
                        doc:context="oscal:authorization-boundary/oscal:diagram"
                        id="has-authorization-boundary-diagram-link-diagnostic">This FedRAMP OSCAL SSP authorization-boundary diagram lacks a
                        link.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-authorization-boundary-diagram-caption"
                        doc:context="oscal:authorization-boundary/oscal:diagram"
                        id="has-authorization-boundary-diagram-caption-diagnostic">This FedRAMP OSCAL SSP authorization-boundary diagram lacks a
                        caption.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-authorization-boundary-diagram-link-rel"
                        doc:context="oscal:authorization-boundary/oscal:diagram/oscal:link"
                        id="has-authorization-boundary-diagram-link-rel-diagnostic">This FedRAMP OSCAL SSP authorization-boundary diagram lacks a
                        link rel attribute.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-authorization-boundary-diagram-link-rel-allowed-value"
                        doc:context="oscal:authorization-boundary/oscal:diagram/oscal:link"
                        id="has-authorization-boundary-diagram-link-rel-allowed-value-diagnostic">This FedRAMP OSCAL SSP authorization-boundary
                        diagram lacks a link rel attribute with the value "diagram".</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-authorization-boundary-diagram-link-href-target"
                        doc:context="oscal:authorization-boundary/oscal:diagram/oscal:link"
                        id="has-authorization-boundary-diagram-link-href-target-diagnostic">This FedRAMP OSCAL SSP authorization-boundary diagram
                        link does not reference a back-matter resource representing the diagram document.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-network-architecture"
                        doc:context="oscal:system-characteristics"
                        id="has-network-architecture-diagnostic">This FedRAMP OSCAL SSP lacks an network-architecture in its
                        system-characteristics.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-network-architecture-description"
                        doc:context="oscal:network-architecture"
                        id="has-network-architecture-description-diagnostic">This FedRAMP OSCAL SSP lacks an network-architecture
                        description.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-network-architecture-diagram"
                        doc:context="oscal:network-architecture"
                        id="has-network-architecture-diagram-diagnostic">This FedRAMP OSCAL SSP lacks at least one network-architecture
                        diagram.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-network-architecture-diagram-uuid"
                        doc:context="oscal:network-architecture/oscal:diagram"
                        id="has-network-architecture-diagram-uuid-diagnostic">This FedRAMP OSCAL SSP network-architecture diagram lacks a uuid
                        attribute.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-network-architecture-diagram-description"
                        doc:context="oscal:network-architecture/oscal:diagram"
                        id="has-network-architecture-diagram-description-diagnostic">This FedRAMP OSCAL SSP network-architecture diagram lacks a
                        description.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-network-architecture-diagram-link"
                        doc:context="oscal:network-architecture/oscal:diagram"
                        id="has-network-architecture-diagram-link-diagnostic">This FedRAMP OSCAL SSP network-architecture diagram lacks a
                        link.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-network-architecture-diagram-caption"
                        doc:context="oscal:network-architecture/oscal:diagram"
                        id="has-network-architecture-diagram-caption-diagnostic">This FedRAMP OSCAL SSP network-architecture diagram lacks a
                        caption.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-network-architecture-diagram-link-rel"
                        doc:context="oscal:network-architecture/oscal:diagram/oscal:link"
                        id="has-network-architecture-diagram-link-rel-diagnostic">This FedRAMP OSCAL SSP network-architecture diagram lacks a link
                        rel attribute.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-network-architecture-diagram-link-rel-allowed-value"
                        doc:context="oscal:network-architecture/oscal:diagram/oscal:link"
                        id="has-network-architecture-diagram-link-rel-allowed-value-diagnostic">This FedRAMP OSCAL SSP network-architecture diagram
                        lacks a link rel attribute with the value "diagram".</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-network-architecture-diagram-link-href-target"
                        doc:context="oscal:network-architecture/oscal:diagram/oscal:link"
                        id="has-network-architecture-diagram-link-href-target-diagnostic">This FedRAMP OSCAL SSP network-architecture diagram link
                        does not reference a back-matter resource representing the diagram document.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-data-flow"
                        doc:context="oscal:system-characteristics"
                        id="has-data-flow-diagnostic">This FedRAMP OSCAL SSP lacks an data-flow in its system-characteristics.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-data-flow-description"
                        doc:context="oscal:data-flow"
                        id="has-data-flow-description-diagnostic">This FedRAMP OSCAL SSP lacks an data-flow description.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-data-flow-diagram"
                        doc:context="oscal:data-flow"
                        id="has-data-flow-diagram-diagnostic">This FedRAMP OSCAL SSP lacks at least one data-flow diagram.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-data-flow-diagram-uuid"
                        doc:context="oscal:data-flow/oscal:diagram"
                        id="has-data-flow-diagram-uuid-diagnostic">This FedRAMP OSCAL SSP data-flow diagram lacks a uuid attribute.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-data-flow-diagram-description"
                        doc:context="oscal:data-flow/oscal:diagram"
                        id="has-data-flow-diagram-description-diagnostic">This FedRAMP OSCAL SSP data-flow diagram lacks a
                        description.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-data-flow-diagram-link"
                        doc:context="oscal:data-flow/oscal:diagram"
                        id="has-data-flow-diagram-link-diagnostic">This FedRAMP OSCAL SSP data-flow diagram lacks a link.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-data-flow-diagram-caption"
                        doc:context="oscal:data-flow/oscal:diagram"
                        id="has-data-flow-diagram-caption-diagnostic">This FedRAMP OSCAL SSP data-flow diagram lacks a caption.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-data-flow-diagram-link-rel"
                        doc:context="oscal:data-flow/oscal:diagram/oscal:link"
                        id="has-data-flow-diagram-link-rel-diagnostic">This FedRAMP OSCAL SSP data-flow diagram lacks a link rel
                        attribute.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-data-flow-diagram-link-rel-allowed-value"
                        doc:context="oscal:data-flow/oscal:diagram/oscal:link"
                        id="has-data-flow-diagram-link-rel-allowed-value-diagnostic">This FedRAMP OSCAL SSP data-flow diagram lacks a link rel
                        attribute with the value "diagram".</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-data-flow-diagram-link-href-target"
                        doc:context="oscal:data-flow/oscal:diagram/oscal:link"
                        id="has-data-flow-diagram-link-href-target-diagnostic">This FedRAMP OSCAL SSP data-flow diagram link does not reference a
                        back-matter resource representing the diagram document.</sch:diagnostic>
        <sch:diagnostic doc:assertion="system-security-plan-has-import-profile"
                        doc:context="oscal:system-security-plan"
                        id="system-security-plan-has-import-profile-diagnostic">This FedRAMP OSCAL SSP lacks an import-profile
                        element.</sch:diagnostic>
        <sch:diagnostic doc:assertion="import-profile-has-href-attribute"
                        doc:context="oscal:import-profile"
                        id="import-profile-has-href-attribute-diagnostic">The import-profile element lacks an href attribute.</sch:diagnostic>
        <sch:diagnostic doc:assertion="implemented-requirement-has-implementation-status"
                        doc:context="oscal:implemented-requirement"
                        id="implemented-requirement-has-implementation-status-diagnostic">This implemented-requirement lacks an
                        implementation-status.</sch:diagnostic>
        <sch:diagnostic doc:assertion="implemented-requirement-has-implementation-status-remarks"
                        doc:context="oscal:implemented-requirement"
                        id="implemented-requirement-has-implementation-status-remarks-diagnostic">This incomplete control implementation lacks an
                        explanation.</sch:diagnostic>
        <sch:diagnostic doc:assertion="implemented-requirement-has-planned-completion-date"
                        doc:context="oscal:implemented-requirement"
                        id="implemented-requirement-has-planned-completion-date-diagnostic">This planned control implementations lacks a planned
                        completion date.</sch:diagnostic>
        <sch:diagnostic doc:assertion="implemented-requirement-has-control-origination"
                        doc:context="oscal:implemented-requirement"
                        id="implemented-requirement-has-control-origination-diagnostic">This implemented-requirement lacks a control-origination
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="implemented-requirement-has-allowed-control-origination"
                        doc:context="oscal:implemented-requirement"
                        id="implemented-requirement-has-allowed-control-origination-diagnostic">This implemented-requirement lacks an allowed
                        control-origination property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="implemented-requirement-has-leveraged-authorization"
                        doc:context="oscal:implemented-requirement"
                        id="implemented-requirement-has-leveraged-authorization-diagnostic">This implemented-requirement with a control-origination
                        property of "inherited" does not reference a leveraged-authorization element in the same document.</sch:diagnostic>
        <sch:diagnostic doc:assertion="planned-completion-date-is-valid"
                        doc:context="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'planned-completion-date']"
                        id="planned-completion-date-is-valid-diagnostic">This planned completion date is not valid.</sch:diagnostic>
        <sch:diagnostic doc:assertion="planned-completion-date-is-not-past"
                        doc:context="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'planned-completion-date']"
                        id="planned-completion-date-is-not-past-diagnostic">This planned completion date references a past time.</sch:diagnostic>
    </sch:diagnostics>
    <messages xmlns="https://fedramp.gov/oscal/fedramp-automation-messages">
        <message id="no-registry-values">
            <persona id="reviewer">
                <affirmative>The registry values are available.</affirmative>
                <diagnostic>The registry values at the path ' 
                <sch:value-of select="$registry-base-path" />' are not present, this configuration is invalid.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>The registry values are available.</affirmative>
                <diagnostic>The registry values at the path ' 
                <sch:value-of select="$registry-base-path" />' are not present, this configuration is invalid.</diagnostic>
            </persona>
        </message>
        <message id="no-security-sensitivity-level">
            <persona id="reviewer">
                <affirmative>[Section C Check 1.a] Sensitivity level is defined.</affirmative>
                <diagnostic>[Section C Check 1.a] No sensitivity level was found As a result, no more validation processing can occur.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section C Check 1.a] Sensitivity level is defined.</affirmative>
                <diagnostic>[Section C Check 1.a] No sensitivity level was found As a result, no more validation processing can occur.</diagnostic>
            </persona>
        </message>
        <message id="invalid-security-sensitivity-level">
            <persona id="reviewer">
                <affirmative>[Section C Check 1.a] Sensitivity level has an allowed value.</affirmative>
                <diagnostic>[Section C Check 1.a] 
                <sch:value-of select="./name()" />is an invalid value of ' 
                <sch:value-of select="lv:sensitivity-level(/)" />', not an allowed value of 
                <sch:value-of select="$corrections" />. No more validation processing can occur.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section C Check 1.a] Sensitivity level has an allowed value.</affirmative>
                <diagnostic>[Section C Check 1.a] 
                <sch:value-of select="./name()" />is an invalid value of ' 
                <sch:value-of select="lv:sensitivity-level(/)" />', not an allowed value of 
                <sch:value-of select="$corrections" />. No more validation processing can occur.</diagnostic>
            </persona>
        </message>
        <message id="implemented-response-points">
            <persona id="reviewer">
                <affirmative>[Section C Check 2] A FedRAMP SSP must implement a statement for each of the following lettered response points for
                required controls: 
                <sch:value-of select="$implemented/@statement-id" />.</affirmative>
                <diagnostic />
            </persona>
            <persona id="submitter">
                <affirmative>[Section C Check 2] A FedRAMP SSP must implement a statement for each of the following lettered response points for
                required controls: 
                <sch:value-of select="$implemented/@statement-id" />.</affirmative>
                <diagnostic />
            </persona>
        </message>
        <message id="each-required-control-report">
            <persona id="reviewer">
                <affirmative>The following 
                <sch:value-of select="count($required-controls)" />
                <sch:value-of select="
                            if (count($required-controls) = 1) then
                                ' control'
                            else
                                ' controls'" />are required: 
                <sch:value-of select="$required-controls/@id" />.</affirmative>
                <diagnostic />
            </persona>
            <persona id="submitter">
                <affirmative>The following 
                <sch:value-of select="count($required-controls)" />
                <sch:value-of select="
                            if (count($required-controls) = 1) then
                                ' control'
                            else
                                ' controls'" />are required: 
                <sch:value-of select="$required-controls/@id" />.</affirmative>
                <diagnostic />
            </persona>
        </message>
        <message id="incomplete-core-implemented-requirements">
            <persona id="reviewer">
                <affirmative>A FedRAMP SSP must implement the most important controls.</affirmative>
                <diagnostic>[Section C Check 3] A FedRAMP SSP must implement the most important 
                <sch:value-of select="count($core-missing)" />core 
                <sch:value-of select="
                            if (count($core-missing) = 1) then
                                ' control'
                            else
                                ' controls'" />: 
                <sch:value-of select="$core-missing/@id" />.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP SSP must implement the most important controls.</affirmative>
                <diagnostic>[Section C Check 3] A FedRAMP SSP must implement the most important 
                <sch:value-of select="count($core-missing)" />core 
                <sch:value-of select="
                            if (count($core-missing) = 1) then
                                ' control'
                            else
                                ' controls'" />: 
                <sch:value-of select="$core-missing/@id" />.</diagnostic>
            </persona>
        </message>
        <message id="incomplete-all-implemented-requirements">
            <persona id="reviewer">
                <affirmative>[Section C Check 2] A FedRAMP SSP must implement all required controls.</affirmative>
                <diagnostic>[Section C Check 2] A FedRAMP SSP must implement 
                <sch:value-of select="count($all-missing)" />
                <sch:value-of select="
                            if (count($all-missing) = 1) then
                                ' control'
                            else
                                ' controls'" />overall: 
                <sch:value-of select="$all-missing/@id" />.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section C Check 2] A FedRAMP SSP must implement all required controls.</affirmative>
                <diagnostic>[Section C Check 2] A FedRAMP SSP must implement 
                <sch:value-of select="count($all-missing)" />
                <sch:value-of select="
                            if (count($all-missing) = 1) then
                                ' control'
                            else
                                ' controls'" />overall: 
                <sch:value-of select="$all-missing/@id" />.</diagnostic>
            </persona>
        </message>
        <message id="extraneous-implemented-requirements">
            <persona id="reviewer">
                <affirmative>[Section C Check 2] A FedRAMP SSP must have no extraneous implemented controls.</affirmative>
                <diagnostic>[Section C Check 2] A FedRAMP SSP must implement 
                <sch:value-of select="count($extraneous)" />extraneous 
                <sch:value-of select="
                            if (count($extraneous) = 1) then
                                ' control'
                            else
                                ' controls'" />not needed given the selected profile: 
                <sch:value-of select="$extraneous/@control-id" />.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section C Check 2] A FedRAMP SSP must have no extraneous implemented controls.</affirmative>
                <diagnostic>[Section C Check 2] A FedRAMP SSP must implement 
                <sch:value-of select="count($extraneous)" />extraneous 
                <sch:value-of select="
                            if (count($extraneous) = 1) then
                                ' control'
                            else
                                ' controls'" />not needed given the selected profile: 
                <sch:value-of select="$extraneous/@control-id" />.</diagnostic>
            </persona>
        </message>
        <message id="control-implemented-requirements-stats">
            <persona id="reviewer">
                <affirmative>
                <sch:value-of select="$results =&gt; lv:report() =&gt; normalize-space()" />.</affirmative>
                <diagnostic />
            </persona>
            <persona id="submitter">
                <affirmative>
                <sch:value-of select="$results =&gt; lv:report() =&gt; normalize-space()" />.</affirmative>
                <diagnostic />
            </persona>
        </message>
        <message id="invalid-implementation-status">
            <persona id="reviewer">
                <affirmative>[Section C Check 2] Implementation status is correct.</affirmative>
                <diagnostic>[Section C Check 2] Invalid status ' 
                <sch:value-of select="$status" />' for 
                <sch:value-of select="./@control-id" />, must be 
                <sch:value-of select="$corrections" />.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section C Check 2] Implementation status is correct.</affirmative>
                <diagnostic>[Section C Check 2] Invalid status ' 
                <sch:value-of select="$status" />' for 
                <sch:value-of select="./@control-id" />, must be 
                <sch:value-of select="$corrections" />.</diagnostic>
            </persona>
        </message>
        <message id="missing-response-points">
            <persona id="reviewer">
                <affirmative>[Section C Check 2] A FedRAMP SSP must have required response points.</affirmative>
                <diagnostic>[Section C Check 2] A FedRAMP SSP must implement a statement for each of the following lettered response points for
                required controls: 
                <sch:value-of select="$missing/@id" />.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section C Check 2] A FedRAMP SSP must have required response points.</affirmative>
                <diagnostic>[Section C Check 2] A FedRAMP SSP must implement a statement for each of the following lettered response points for
                required controls: 
                <sch:value-of select="$missing/@id" />.</diagnostic>
            </persona>
        </message>
        <message id="missing-response-components">
            <persona id="reviewer">
                <affirmative>[Section D Checks] Response statements have sufficient components.</affirmative>
                <diagnostic>[Section D Checks] Response statements for 
                <sch:value-of select="./@statement-id" />must have at least 
                <sch:value-of select="$required-components-count" />
                <sch:value-of select="
                            if (count($components-count) = 1) then
                                ' component'
                            else
                                ' components'" />with a description. There are 
                <sch:value-of select="$components-count" />.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section D Checks] Response statements have sufficient components.</affirmative>
                <diagnostic>[Section D Checks] Response statements for 
                <sch:value-of select="./@statement-id" />must have at least 
                <sch:value-of select="$required-components-count" />
                <sch:value-of select="
                            if (count($components-count) = 1) then
                                ' component'
                            else
                                ' components'" />with a description. There are 
                <sch:value-of select="$components-count" />.</diagnostic>
            </persona>
        </message>
        <message id="extraneous-response-description">
            <persona id="reviewer">
                <affirmative>[Section D Checks] Response statement does not have a description not within a component.</affirmative>
                <diagnostic>[Section D Checks] Response statement 
                <sch:value-of select="../@statement-id" />has a description not within a component. That was previously allowed, but not recommended.
                It will soon be syntactically invalid and deprecated.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section D Checks] Response statement does not have a description not within a component.</affirmative>
                <diagnostic>[Section D Checks] Response statement 
                <sch:value-of select="../@statement-id" />has a description not within a component. That was previously allowed, but not recommended.
                It will soon be syntactically invalid and deprecated.</diagnostic>
            </persona>
        </message>
        <message id="extraneous-response-remarks">
            <persona id="reviewer">
                <affirmative>[Section D Checks] Response statement does not have remarks not within a component.</affirmative>
                <diagnostic>[Section D Checks] Response statement 
                <sch:value-of select="../@statement-id" />has remarks not within a component. That was previously allowed, but not recommended. It
                will soon be syntactically invalid and deprecated.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section D Checks] Response statement does not have remarks not within a component.</affirmative>
                <diagnostic>[Section D Checks] Response statement 
                <sch:value-of select="../@statement-id" />has remarks not within a component. That was previously allowed, but not recommended. It
                will soon be syntactically invalid and deprecated.</diagnostic>
            </persona>
        </message>
        <message id="invalid-component-match">
            <persona id="reviewer">
                <affirmative>[Section D Checks] Response statement cites a component in the system implementation inventory.</affirmative>
                <diagnostic>[Section D Checks] Response statement 
                <sch:value-of select="../@statement-id" />with component reference UUID ' 
                <sch:value-of select="$component-ref" />' is not in the system implementation inventory, and cannot be used to define a
                control.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section D Checks] Response statement cites a component in the system implementation inventory.</affirmative>
                <diagnostic>[Section D Checks] Response statement 
                <sch:value-of select="../@statement-id" />with component reference UUID ' 
                <sch:value-of select="$component-ref" />' is not in the system implementation inventory, and cannot be used to define a
                control.</diagnostic>
            </persona>
        </message>
        <message id="missing-component-description">
            <persona id="reviewer">
                <affirmative>[Section D Checks] Response statement has a component which has a required description node.</affirmative>
                <diagnostic>[Section D Checks] Response statement 
                <sch:value-of select="../@statement-id" />has a component, but that component is missing a required description node.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section D Checks] Response statement has a component which has a required description node.</affirmative>
                <diagnostic>[Section D Checks] Response statement 
                <sch:value-of select="../@statement-id" />has a component, but that component is missing a required description node.</diagnostic>
            </persona>
        </message>
        <message id="incomplete-response-description">
            <persona id="reviewer">
                <affirmative>[Section D Checks] Response statement component description has adequate length.</affirmative>
                <diagnostic>[Section D Checks] Response statement component description for 
                <sch:value-of select="../../@statement-id" />is too short with 
                <sch:value-of select="$description-length" />characters. It must be 
                <sch:value-of select="$required-length" />characters long.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section D Checks] Response statement component description has adequate length.</affirmative>
                <diagnostic>[Section D Checks] Response statement component description for 
                <sch:value-of select="../../@statement-id" />is too short with 
                <sch:value-of select="$description-length" />characters. It must be 
                <sch:value-of select="$required-length" />characters long.</diagnostic>
            </persona>
        </message>
        <message id="incomplete-response-remarks">
            <persona id="reviewer">
                <affirmative>[Section D Checks] Response statement component remarks have adequate length.</affirmative>
                <diagnostic>[Section D Checks] Response statement component remarks for 
                <sch:value-of select="../../@statement-id" />is too short with 
                <sch:value-of select="$remarks-length" />characters. It must be 
                <sch:value-of select="$required-length" />characters long.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section D Checks] Response statement component remarks have adequate length.</affirmative>
                <diagnostic>[Section D Checks] Response statement component remarks for 
                <sch:value-of select="../../@statement-id" />is too short with 
                <sch:value-of select="$remarks-length" />characters. It must be 
                <sch:value-of select="$required-length" />characters long.</diagnostic>
            </persona>
        </message>
        <message id="incorrect-role-association">
            <persona id="reviewer">
                <affirmative>[Section C Check 2] A FedRAMP SSP must define a responsible party with no extraneous roles.</affirmative>
                <diagnostic>[Section C Check 2] A FedRAMP SSP must define a responsible party with 
                <sch:value-of select="count($extraneous-roles)" />
                <sch:value-of select="
                            if (count($extraneous-roles) = 1) then
                                ' role'
                            else
                                ' roles'" />not defined in the role: 
                <sch:value-of select="$extraneous-roles/@role-id" />.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section C Check 2] A FedRAMP SSP must define a responsible party with no extraneous roles.</affirmative>
                <diagnostic>[Section C Check 2] A FedRAMP SSP must define a responsible party with 
                <sch:value-of select="count($extraneous-roles)" />
                <sch:value-of select="
                            if (count($extraneous-roles) = 1) then
                                ' role'
                            else
                                ' roles'" />not defined in the role: 
                <sch:value-of select="$extraneous-roles/@role-id" />.</diagnostic>
            </persona>
        </message>
        <message id="incorrect-party-association">
            <persona id="reviewer">
                <affirmative>[Section C Check 2] A FedRAMP SSP must define a responsible party with no extraneous parties.</affirmative>
                <diagnostic>[Section C Check 2] A FedRAMP SSP must define a responsible party with 
                <sch:value-of select="count($extraneous-parties)" />
                <sch:value-of select="
                            if (count($extraneous-parties) = 1) then
                                ' party'
                            else
                                ' parties'" />is not a defined party: 
                <sch:value-of select="$extraneous-parties/o:party-uuid" />.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section C Check 2] A FedRAMP SSP must define a responsible party with no extraneous parties.</affirmative>
                <diagnostic>[Section C Check 2] A FedRAMP SSP must define a responsible party with 
                <sch:value-of select="count($extraneous-parties)" />
                <sch:value-of select="
                            if (count($extraneous-parties) = 1) then
                                ' party'
                            else
                                ' parties'" />is not a defined party: 
                <sch:value-of select="$extraneous-parties/o:party-uuid" />.</diagnostic>
            </persona>
        </message>
        <message id="resource-uuid-required">
            <persona id="reviewer">
                <affirmative>Every resource has a uuid attribute.</affirmative>
                <diagnostic>A FedRAMP SSP must include back-matter resource missing a UUID.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Every resource has a uuid attribute.</affirmative>
                <diagnostic>A FedRAMP SSP must include back-matter resource missing a UUID.</diagnostic>
            </persona>
        </message>
        <message id="resource-base64-available-filename">
            <persona id="reviewer">
                <affirmative>This base64 has a filename attribute.</affirmative>
                <diagnostic>This base64 lacks a filename attribute.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>This base64 has a filename attribute.</affirmative>
                <diagnostic>This base64 lacks a filename attribute.</diagnostic>
            </persona>
        </message>
        <message id="resource-base64-available-media-type">
            <persona id="reviewer">
                <affirmative>This base64 has a media-type attribute.</affirmative>
                <diagnostic>This base64 lacks a media-type attribute.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>This base64 has a media-type attribute.</affirmative>
                <diagnostic>This base64 lacks a media-type attribute.</diagnostic>
            </persona>
        </message>
        <message id="resource-has-uuid">
            <persona id="reviewer">
                <affirmative>A resource must have a uuid attribute.</affirmative>
                <diagnostic>This resource lacks a uuid attribute.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A resource must have a uuid attribute.</affirmative>
                <diagnostic>This resource lacks a uuid attribute.</diagnostic>
            </persona>
        </message>
        <message id="resource-has-title">
            <persona id="reviewer">
                <affirmative>A resource should have a title.</affirmative>
                <diagnostic>This resource lacks a title.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A resource should have a title.</affirmative>
                <diagnostic>This resource lacks a title.</diagnostic>
            </persona>
        </message>
        <message id="resource-has-rlink">
            <persona id="reviewer">
                <affirmative>A resource must have a rlink element</affirmative>
                <diagnostic>This resource lacks a rlink element.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A resource must have a rlink element</affirmative>
                <diagnostic>This resource lacks a rlink element.</diagnostic>
            </persona>
        </message>
        <message id="resource-is-referenced">
            <persona id="reviewer">
                <affirmative>A resource should be referenced from within the document.</affirmative>
                <diagnostic>This resource lacks a reference within the document (but does not).</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A resource should be referenced from within the document.</affirmative>
                <diagnostic>This resource lacks a reference within the document (but does not).</diagnostic>
            </persona>
        </message>
        <message id="attachment-type-is-valid">
            <persona id="reviewer">
                <affirmative>A resource should have an allowed attachment-type property.</affirmative>
                <diagnostic>Found unknown attachment type « 
                <sch:value-of select="@value" />» in 
                <sch:value-of select="
                            if (parent::oscal:resource/oscal:title) then
                                concat('&#34;', parent::oscal:resource/oscal:title, '&#34;')
                            else
                                'untitled'" />resource.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A resource should have an allowed attachment-type property.</affirmative>
                <diagnostic>Found unknown attachment type « 
                <sch:value-of select="@value" />» in 
                <sch:value-of select="
                            if (parent::oscal:resource/oscal:title) then
                                concat('&#34;', parent::oscal:resource/oscal:title, '&#34;')
                            else
                                'untitled'" />resource.</diagnostic>
            </persona>
        </message>
        <message id="rlink-has-href">
            <persona id="reviewer">
                <affirmative>A resource rlink must have an href attribute.</affirmative>
                <diagnostic>This rlink lacks an href attribute.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A resource rlink must have an href attribute.</affirmative>
                <diagnostic>This rlink lacks an href attribute.</diagnostic>
            </persona>
        </message>
        <message id="has-allowed-media-type">
            <persona id="reviewer">
                <affirmative>A media-type attribute must have an allowed value.</affirmative>
                <diagnostic>This 
                <sch:value-of select="name(parent::node())" />has a media-type=" 
                <sch:value-of select="current()/@media-type" />" which is not in the list of allowed media types. Allowed media types are 
                <sch:value-of select="string-join($media-types, ' ∨ ')" />.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A media-type attribute must have an allowed value.</affirmative>
                <diagnostic>This 
                <sch:value-of select="name(parent::node())" />has a media-type=" 
                <sch:value-of select="current()/@media-type" />" which is not in the list of allowed media types. Allowed media types are 
                <sch:value-of select="string-join($media-types, ' ∨ ')" />.</diagnostic>
            </persona>
        </message>
        <message id="resource-has-base64">
            <persona id="reviewer">
                <affirmative>A resource should have a base64 element.</affirmative>
                <diagnostic>This resource should have a base64 element.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A resource should have a base64 element.</affirmative>
                <diagnostic>This resource should have a base64 element.</diagnostic>
            </persona>
        </message>
        <message id="resource-has-base64-cardinality">
            <persona id="reviewer">
                <affirmative>A resource must have only one base64 element.</affirmative>
                <diagnostic>This resource must not have more than one base64 element.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A resource must have only one base64 element.</affirmative>
                <diagnostic>This resource must not have more than one base64 element.</diagnostic>
            </persona>
        </message>
        <message id="base64-has-filename">
            <persona id="reviewer">
                <affirmative>A base64 element must have a filename attribute.</affirmative>
                <diagnostic>This base64 must have a filename attribute.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A base64 element must have a filename attribute.</affirmative>
                <diagnostic>This base64 must have a filename attribute.</diagnostic>
            </persona>
        </message>
        <message id="base64-has-media-type">
            <persona id="reviewer">
                <affirmative>A base64 element must have a media-type attribute.</affirmative>
                <diagnostic>This base64 must have a media-type attribute.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A base64 element must have a media-type attribute.</affirmative>
                <diagnostic>This base64 must have a media-type attribute.</diagnostic>
            </persona>
        </message>
        <message id="base64-has-content">
            <persona id="reviewer">
                <affirmative>A base64 element must have content.</affirmative>
                <diagnostic>This base64 must have content.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A base64 element must have content.</affirmative>
                <diagnostic>This base64 must have content.</diagnostic>
            </persona>
        </message>
        <message id="has-fedramp-acronyms">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must have the FedRAMP Master Acronym and Glossary attached.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks the FedRAMP Master Acronym and Glossary.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must have the FedRAMP Master Acronym and Glossary attached.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks the FedRAMP Master Acronym and Glossary.</diagnostic>
            </persona>
        </message>
        <message id="has-fedramp-citations">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.12] A FedRAMP OSCAL SSP must have the FedRAMP Applicable Laws and Regulations attached.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks the FedRAMP Applicable Laws and Regulations.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.12] A FedRAMP OSCAL SSP must have the FedRAMP Applicable Laws and Regulations attached.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks the FedRAMP Applicable Laws and Regulations.</diagnostic>
            </persona>
        </message>
        <message id="has-fedramp-logo">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must have the FedRAMP Logo attached.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks the FedRAMP Logo.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must have the FedRAMP Logo attached.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks the FedRAMP Logo.</diagnostic>
            </persona>
        </message>
        <message id="has-user-guide">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.2] A FedRAMP OSCAL SSP must have a User Guide attached.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a User Guide.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.2] A FedRAMP OSCAL SSP must have a User Guide attached.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a User Guide.</diagnostic>
            </persona>
        </message>
        <message id="has-rules-of-behavior">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.5] A FedRAMP OSCAL SSP must have Rules of Behavior.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Rules of Behavior.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.5] A FedRAMP OSCAL SSP must have Rules of Behavior.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Rules of Behavior.</diagnostic>
            </persona>
        </message>
        <message id="has-information-system-contingency-plan">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.6] A FedRAMP OSCAL SSP must have a Contingency Plan attached.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Contingency Plan.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.6] A FedRAMP OSCAL SSP must have a Contingency Plan attached.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Contingency Plan.</diagnostic>
            </persona>
        </message>
        <message id="has-configuration-management-plan">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.7] A FedRAMP OSCAL SSP must have a Configuration Management Plan attached.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Configuration Management Plan.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.7] A FedRAMP OSCAL SSP must have a Configuration Management Plan attached.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Configuration Management Plan.</diagnostic>
            </persona>
        </message>
        <message id="has-incident-response-plan">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.8] A FedRAMP OSCAL SSP must have an Incident Response Plan attached.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an Incident Response Plan.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.8] A FedRAMP OSCAL SSP must have an Incident Response Plan attached.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an Incident Response Plan.</diagnostic>
            </persona>
        </message>
        <message id="has-separation-of-duties-matrix">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.11] A FedRAMP OSCAL SSP must have a Separation of Duties Matrix attached.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Separation of Duties Matrix.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.11] A FedRAMP OSCAL SSP must have a Separation of Duties Matrix attached.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Separation of Duties Matrix.</diagnostic>
            </persona>
        </message>
        <message id="has-policy-link">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.1] A FedRAMP SSP must incorporate a policy document for each of the 17 NIST SP 800-54 Revision 4
                control families.</affirmative>
                <diagnostic>
                <sch:value-of select="local-name()" />
                <sch:value-of select="@control-id" />
                <sch:span class="message">lacks policy reference(s) (via by-component link)</sch:span>.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.1] A FedRAMP SSP must incorporate a policy document for each of the 17 NIST SP 800-54 Revision 4
                control families.</affirmative>
                <diagnostic>
                <sch:value-of select="local-name()" />
                <sch:value-of select="@control-id" />
                <sch:span class="message">lacks policy reference(s) (via by-component link)</sch:span>.</diagnostic>
            </persona>
        </message>
        <message id="has-policy-attachment-resource">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.1] A FedRAMP SSP must incorporate a policy document for each of the 17 NIST SP 800-54 Revision 4
                control families.</affirmative>
                <diagnostic>
                <sch:value-of select="local-name()" />
                <sch:value-of select="@control-id" />
                <sch:span class="message">lacks policy attachment resource(s)</sch:span>
                <sch:value-of select="string-join($policy-hrefs, ', ')" />.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.1] A FedRAMP SSP must incorporate a policy document for each of the 17 NIST SP 800-54 Revision 4
                control families.</affirmative>
                <diagnostic>
                <sch:value-of select="local-name()" />
                <sch:value-of select="@control-id" />
                <sch:span class="message">lacks policy attachment resource(s)</sch:span>
                <sch:value-of select="string-join($policy-hrefs, ', ')" />.</diagnostic>
            </persona>
        </message>
        <message id="has-procedure-link">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.1] A FedRAMP SSP must incorporate a procedure document for each of the 17 NIST SP 800-54 Revision 4
                control families.</affirmative>
                <diagnostic>
                <sch:value-of select="local-name()" />
                <sch:value-of select="@control-id" />
                <sch:span class="message">lacks procedure reference(s) (via by-component link)</sch:span>.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.1] A FedRAMP SSP must incorporate a procedure document for each of the 17 NIST SP 800-54 Revision 4
                control families.</affirmative>
                <diagnostic>
                <sch:value-of select="local-name()" />
                <sch:value-of select="@control-id" />
                <sch:span class="message">lacks procedure reference(s) (via by-component link)</sch:span>.</diagnostic>
            </persona>
        </message>
        <message id="has-procedure-attachment-resource">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.1] A FedRAMP SSP must incorporate a procedure document for each of the 17 NIST SP 800-54 Revision 4
                control families.</affirmative>
                <diagnostic>
                <sch:value-of select="local-name()" />
                <sch:value-of select="@control-id" />
                <sch:span class="message">lacks procedure attachment resource(s)</sch:span>
                <sch:value-of select="string-join($procedure-hrefs, ', ')" />.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.1] A FedRAMP SSP must incorporate a procedure document for each of the 17 NIST SP 800-54 Revision 4
                control families.</affirmative>
                <diagnostic>
                <sch:value-of select="local-name()" />
                <sch:value-of select="@control-id" />
                <sch:span class="message">lacks procedure attachment resource(s)</sch:span>
                <sch:value-of select="string-join($procedure-hrefs, ', ')" />.</diagnostic>
            </persona>
        </message>
        <message id="has-reuse">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.1] Policy and procedure documents must have unique per-control-family associations.</affirmative>
                <diagnostic>A policy or procedure reference was incorrectly re-used.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.1] Policy and procedure documents must have unique per-control-family associations.</affirmative>
                <diagnostic>A policy or procedure reference was incorrectly re-used.</diagnostic>
            </persona>
        </message>
        <message id="has-privacy-poc-role">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must incorporate a Privacy Point of Contact role.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Privacy Point of Contact role.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must incorporate a Privacy Point of Contact role.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Privacy Point of Contact role.</diagnostic>
            </persona>
        </message>
        <message id="has-responsible-party-privacy-poc-role">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must declare a Privacy Point of Contact responsible party role
                reference.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Privacy Point of Contact responsible party role reference.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must declare a Privacy Point of Contact responsible party role
                reference.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Privacy Point of Contact responsible party role reference.</diagnostic>
            </persona>
        </message>
        <message id="has-responsible-privacy-poc-party-uuid">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must declare a Privacy Point of Contact responsible party role reference
                identifying the party by UUID.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Privacy Point of Contact responsible party role reference identifying the party by
                UUID.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must declare a Privacy Point of Contact responsible party role reference
                identifying the party by UUID.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Privacy Point of Contact responsible party role reference identifying the party by
                UUID.</diagnostic>
            </persona>
        </message>
        <message id="has-privacy-poc">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must define a Privacy Point of Contact.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Privacy Point of Contact.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must define a Privacy Point of Contact.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Privacy Point of Contact.</diagnostic>
            </persona>
        </message>
        <message id="has-correct-yes-or-no-answer">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.4] A Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question must have an
                allowed answer.</affirmative>
                <diagnostic>This property has an incorrect value: should be "yes" or "no".</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.4] A Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question must have an
                allowed answer.</affirmative>
                <diagnostic>This property has an incorrect value: should be "yes" or "no".</diagnostic>
            </persona>
        </message>
        <message id="has-privacy-sensitive-designation">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must have a privacy-sensitive designation.</affirmative>
                <diagnostic>The privacy-sensitive designation is missing.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must have a privacy-sensitive designation.</affirmative>
                <diagnostic>The privacy-sensitive designation is missing.</diagnostic>
            </persona>
        </message>
        <message id="has-pta-question-1">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA)
                qualifying question #1.</affirmative>
                <diagnostic>The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #1 is missing.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA)
                qualifying question #1.</affirmative>
                <diagnostic>The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #1 is missing.</diagnostic>
            </persona>
        </message>
        <message id="has-pta-question-2">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA)
                qualifying question #2.</affirmative>
                <diagnostic>The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #2 is missing.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA)
                qualifying question #2.</affirmative>
                <diagnostic>The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #2 is missing.</diagnostic>
            </persona>
        </message>
        <message id="has-pta-question-3">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA)
                qualifying question #3.</affirmative>
                <diagnostic>The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #3 is missing.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA)
                qualifying question #3.</affirmative>
                <diagnostic>The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #3 is missing.</diagnostic>
            </persona>
        </message>
        <message id="has-pta-question-4">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA)
                qualifying question #4.</affirmative>
                <diagnostic>The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #4 is missing.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA)
                qualifying question #4.</affirmative>
                <diagnostic>The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #4 is missing.</diagnostic>
            </persona>
        </message>
        <message id="has-all-pta-questions">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must have all four PTA questions.</affirmative>
                <diagnostic>One or more of the four PTA questions is missing.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must have all four PTA questions.</affirmative>
                <diagnostic>One or more of the four PTA questions is missing.</diagnostic>
            </persona>
        </message>
        <message id="has-correct-pta-question-cardinality">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must have no duplicate PTA questions.</affirmative>
                <diagnostic>One or more of the four PTA questions is a duplicate.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP must have no duplicate PTA questions.</affirmative>
                <diagnostic>One or more of the four PTA questions is a duplicate.</diagnostic>
            </persona>
        </message>
        <message id="has-sorn">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP may have a SORN ID.</affirmative>
                <diagnostic>The SORN ID is missing.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.4] A FedRAMP OSCAL SSP may have a SORN ID.</affirmative>
                <diagnostic>The SORN ID is missing.</diagnostic>
            </persona>
        </message>
        <message id="has-pia">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.4] This FedRAMP OSCAL SSP must incorporate a Privacy Impact Analysis.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Privacy Impact Analysis.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.4] This FedRAMP OSCAL SSP must incorporate a Privacy Impact Analysis.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Privacy Impact Analysis.</diagnostic>
            </persona>
        </message>
        <message id="has-CMVP-validation">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must incorporate one or more FIPS 140 validated modules.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP does not declare one or more FIPS 140 validated modules.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must incorporate one or more FIPS 140 validated modules.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP does not declare one or more FIPS 140 validated modules.</diagnostic>
            </persona>
        </message>
        <message id="has-CMVP-validation-reference">
            <persona id="reviewer">
                <affirmative>A validation component or inventory-item must have a validation-reference property.</affirmative>
                <diagnostic>This validation component or inventory-item lacks a validation-reference property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A validation component or inventory-item must have a validation-reference property.</affirmative>
                <diagnostic>This validation component or inventory-item lacks a validation-reference property.</diagnostic>
            </persona>
        </message>
        <message id="has-CMVP-validation-details">
            <persona id="reviewer">
                <affirmative>A validation component or inventory-item must have a validation-details link.</affirmative>
                <diagnostic>This validation component or inventory-item lacks a validation-details link.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A validation component or inventory-item must have a validation-details link.</affirmative>
                <diagnostic>This validation component or inventory-item lacks a validation-details link.</diagnostic>
            </persona>
        </message>
        <message id="has-credible-CMVP-validation-reference">
            <persona id="reviewer">
                <affirmative>A validation-reference property must provide a CMVP certificate number.</affirmative>
                <diagnostic>This validation-reference property does not resemble a CMVP certificate number.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A validation-reference property must provide a CMVP certificate number.</affirmative>
                <diagnostic>This validation-reference property does not resemble a CMVP certificate number.</diagnostic>
            </persona>
        </message>
        <message id="has-consonant-CMVP-validation-reference">
            <persona id="reviewer">
                <affirmative>A validation-reference property must be in accord with its sibling validation-details href.</affirmative>
                <diagnostic>This validation-reference property does not match its sibling validation-details href.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A validation-reference property must be in accord with its sibling validation-details href.</affirmative>
                <diagnostic>This validation-reference property does not match its sibling validation-details href.</diagnostic>
            </persona>
        </message>
        <message id="has-credible-CMVP-validation-details">
            <persona id="reviewer">
                <affirmative>A validation-details link must refer to a NIST CMVP certificate detail page.</affirmative>
                <diagnostic>This validation-details link href attribute does not resemble a CMVP certificate URL.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A validation-details link must refer to a NIST CMVP certificate detail page.</affirmative>
                <diagnostic>This validation-details link href attribute does not resemble a CMVP certificate URL.</diagnostic>
            </persona>
        </message>
        <message id="has-consonant-CMVP-validation-details">
            <persona id="reviewer">
                <affirmative>A validation-details link must be in accord with its sibling validation-reference.</affirmative>
                <diagnostic>This validation-details link href attribute does not match its sibling validation-reference value.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A validation-details link must be in accord with its sibling validation-reference.</affirmative>
                <diagnostic>This validation-details link href attribute does not match its sibling validation-reference value.</diagnostic>
            </persona>
        </message>
        <message id="has-security-sensitivity-level">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must specify a FIPS 199 categorization.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a FIPS 199 categorization.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must specify a FIPS 199 categorization.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a FIPS 199 categorization.</diagnostic>
            </persona>
        </message>
        <message id="has-security-impact-level">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must specify a security impact level.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a security impact level.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must specify a security impact level.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a security impact level.</diagnostic>
            </persona>
        </message>
        <message id="has-allowed-security-sensitivity-level">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must specify an allowed security-sensitivity-level.</affirmative>
                <diagnostic>Invalid security-sensitivity-level " 
                <sch:value-of select="." />". It must have one of the following 
                <sch:value-of select="count($security-sensitivity-levels)" />values: 
                <sch:value-of select="string-join($security-sensitivity-levels, ' ∨ ')" />.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must specify an allowed security-sensitivity-level.</affirmative>
                <diagnostic>Invalid security-sensitivity-level " 
                <sch:value-of select="." />". It must have one of the following 
                <sch:value-of select="count($security-sensitivity-levels)" />values: 
                <sch:value-of select="string-join($security-sensitivity-levels, ' ∨ ')" />.</diagnostic>
            </persona>
        </message>
        <message id="has-security-objective-confidentiality">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must specify a confidentiality security objective.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a confidentiality security objective.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must specify a confidentiality security objective.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a confidentiality security objective.</diagnostic>
            </persona>
        </message>
        <message id="has-security-objective-integrity">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must specify an integrity security objective.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an integrity security objective.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must specify an integrity security objective.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an integrity security objective.</diagnostic>
            </persona>
        </message>
        <message id="has-security-objective-availability">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must specify an availability security objective.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an availability security objective.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must specify an availability security objective.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an availability security objective.</diagnostic>
            </persona>
        </message>
        <message id="has-allowed-security-objective-value">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must specify an allowed security objective value.</affirmative>
                <diagnostic>Invalid 
                <sch:value-of select="name()" />" 
                <sch:value-of select="." />". It must have one of the following 
                <sch:value-of select="count($security-objective-levels)" />values: 
                <sch:value-of select="string-join($security-objective-levels, ' ∨ ')" />.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must specify an allowed security objective value.</affirmative>
                <diagnostic>Invalid 
                <sch:value-of select="name()" />" 
                <sch:value-of select="." />". It must have one of the following 
                <sch:value-of select="count($security-objective-levels)" />values: 
                <sch:value-of select="string-join($security-objective-levels, ' ∨ ')" />.</diagnostic>
            </persona>
        </message>
        <message id="system-information-has-information-type">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must specify at least one information-type.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP lacks at least one information-type.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must specify at least one information-type.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP lacks at least one information-type.</diagnostic>
            </persona>
        </message>
        <message id="information-type-has-title">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP information-type must have a title.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type lacks a title.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP information-type must have a title.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type lacks a title.</diagnostic>
            </persona>
        </message>
        <message id="information-type-has-description">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP information-type must have a description.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type lacks a description.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP information-type must have a description.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type lacks a description.</diagnostic>
            </persona>
        </message>
        <message id="information-type-has-categorization">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP information-type must have at least one categorization.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type lacks at least one categorization.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP information-type must have at least one categorization.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type lacks at least one categorization.</diagnostic>
            </persona>
        </message>
        <message id="information-type-has-confidentiality-impact">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP information-type must have a confidentiality-impact.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type lacks a confidentiality-impact.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP information-type must have a confidentiality-impact.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type lacks a confidentiality-impact.</diagnostic>
            </persona>
        </message>
        <message id="information-type-has-integrity-impact">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP information-type must have a integrity-impact.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type lacks a integrity-impact.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP information-type must have a integrity-impact.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type lacks a integrity-impact.</diagnostic>
            </persona>
        </message>
        <message id="information-type-has-availability-impact">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP information-type must have a availability-impact.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type lacks a availability-impact.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP information-type must have a availability-impact.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type lacks a availability-impact.</diagnostic>
            </persona>
        </message>
        <message id="categorization-has-system-attribute">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP information-type categorization must have a system attribute.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type categorization lacks a system attribute.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP information-type categorization must have a system attribute.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type categorization lacks a system attribute.</diagnostic>
            </persona>
        </message>
        <message id="categorization-has-correct-system-attribute">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP information-type categorization must have a correct system attribute.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type categorization lacks a correct system attribute. The correct value is
                "https://doi.org/10.6028/NIST.SP.800-60v2r1".</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP information-type categorization must have a correct system attribute.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type categorization lacks a correct system attribute. The correct value is
                "https://doi.org/10.6028/NIST.SP.800-60v2r1".</diagnostic>
            </persona>
        </message>
        <message id="categorization-has-information-type-id">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP information-type categorization must have at least one information-type-id.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type categorization lacks at least one information-type-id.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP information-type categorization must have at least one information-type-id.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type categorization lacks at least one information-type-id.</diagnostic>
            </persona>
        </message>
        <message id="has-allowed-information-type-id">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP information-type-id must have a SP 800-60v2r1 identifier.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type-id lacks a SP 800-60v2r1 identifier.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP information-type-id must have a SP 800-60v2r1 identifier.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type-id lacks a SP 800-60v2r1 identifier.</diagnostic>
            </persona>
        </message>
        <message id="cia-impact-has-base">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact must have a base
                element.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact lacks a base
                element.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact must have a base
                element.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact lacks a base
                element.</diagnostic>
            </persona>
        </message>
        <message id="cia-impact-has-selected">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact must have a selected
                element.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact lacks a selected
                element.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact must have a selected
                element.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact lacks a selected
                element.</diagnostic>
            </persona>
        </message>
        <message id="cia-impact-has-approved-fips-categorization">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact base or select element must
                have an approved value.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact base or select element lacks an
                approved value.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact base or select element must
                have an approved value.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact base or select element lacks an
                approved value.</diagnostic>
            </persona>
        </message>
        <message id="has-security-eauth-level">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.3] A FedRAMP OSCAL SSP must have a Digital Identity Determination property.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Digital Identity Determination property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.3] A FedRAMP OSCAL SSP must have a Digital Identity Determination property.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Digital Identity Determination property.</diagnostic>
            </persona>
        </message>
        <message id="has-identity-assurance-level">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.3] A FedRAMP OSCAL SSP may have a Digital Identity Determination identity-assurance-level
                property.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP may lack a Digital Identity Determination identity-assurance-level property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.3] A FedRAMP OSCAL SSP may have a Digital Identity Determination identity-assurance-level
                property.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP may lack a Digital Identity Determination identity-assurance-level property.</diagnostic>
            </persona>
        </message>
        <message id="has-authenticator-assurance-level">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.3] A FedRAMP OSCAL SSP may have a Digital Identity Determination authenticator-assurance-level
                property.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP may lack a Digital Identity Determination authenticator-assurance-level property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.3] A FedRAMP OSCAL SSP may have a Digital Identity Determination authenticator-assurance-level
                property.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP may lack a Digital Identity Determination authenticator-assurance-level property.</diagnostic>
            </persona>
        </message>
        <message id="has-federation-assurance-level">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.3] A FedRAMP OSCAL SSP may have a Digital Identity Determination federation-assurance-level
                property.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP may lack a Digital Identity Determination federation-assurance-level property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.3] A FedRAMP OSCAL SSP may have a Digital Identity Determination federation-assurance-level
                property.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP may lack a Digital Identity Determination federation-assurance-level property.</diagnostic>
            </persona>
        </message>
        <message id="has-allowed-security-eauth-level">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.3] A FedRAMP OSCAL SSP must have a Digital Identity Determination property with an allowed
                value.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Digital Identity Determination property with an allowed value.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.3] A FedRAMP OSCAL SSP must have a Digital Identity Determination property with an allowed
                value.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a Digital Identity Determination property with an allowed value.</diagnostic>
            </persona>
        </message>
        <message id="has-allowed-identity-assurance-level">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.3] A FedRAMP OSCAL SSP should have an allowed Digital Identity Determination identity-assurance-level
                property.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP may lack an allowed Digital Identity Determination identity-assurance-level property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.3] A FedRAMP OSCAL SSP should have an allowed Digital Identity Determination identity-assurance-level
                property.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP may lack an allowed Digital Identity Determination identity-assurance-level property.</diagnostic>
            </persona>
        </message>
        <message id="has-allowed-authenticator-assurance-level">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.3] A FedRAMP OSCAL SSP should have an allowed Digital Identity Determination
                authenticator-assurance-level property.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP may lack an allowed Digital Identity Determination authenticator-assurance-level
                property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.3] A FedRAMP OSCAL SSP should have an allowed Digital Identity Determination
                authenticator-assurance-level property.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP may lack an allowed Digital Identity Determination authenticator-assurance-level
                property.</diagnostic>
            </persona>
        </message>
        <message id="has-allowed-federation-assurance-level">
            <persona id="reviewer">
                <affirmative>[Section B Check 3.3] A FedRAMP OSCAL SSP should have an allowed Digital Identity Determination
                federation-assurance-level property.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP may lack an allowed Digital Identity Determination federation-assurance-level property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>[Section B Check 3.3] A FedRAMP OSCAL SSP should have an allowed Digital Identity Determination
                federation-assurance-level property.</affirmative>
                <diagnostic>A FedRAMP OSCAL SSP may lack an allowed Digital Identity Determination federation-assurance-level property.</diagnostic>
            </persona>
        </message>
        <message id="has-inventory-items">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must incorporate inventory-item elements.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks inventory-item elements.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must incorporate inventory-item elements.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks inventory-item elements.</diagnostic>
            </persona>
        </message>
        <message id="has-unique-asset-id">
            <persona id="reviewer">
                <affirmative>An asset-id must be unique.</affirmative>
                <diagnostic>This asset id 
                <sch:value-of select="@asset-id" />is not unique. An asset id must be unique within the scope of a FedRAMP OSCAL SSP
                document.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>An asset-id must be unique.</affirmative>
                <diagnostic>This asset id 
                <sch:value-of select="@asset-id" />is not unique. An asset id must be unique within the scope of a FedRAMP OSCAL SSP
                document.</diagnostic>
            </persona>
        </message>
        <message id="has-allowed-asset-type">
            <persona id="reviewer">
                <affirmative>An asset-type property must have an allowed value.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />should have a FedRAMP asset type 
                <sch:value-of select="string-join($asset-types, ' ∨ ')" />(not " 
                <sch:value-of select="@value" />").</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>An asset-type property must have an allowed value.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />should have a FedRAMP asset type 
                <sch:value-of select="string-join($asset-types, ' ∨ ')" />(not " 
                <sch:value-of select="@value" />").</diagnostic>
            </persona>
        </message>
        <message id="has-allowed-virtual">
            <persona id="reviewer">
                <affirmative>A virtual property must have an allowed value.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />must have an allowed value 
                <sch:value-of select="string-join($virtuals, ' ∨ ')" />(not " 
                <sch:value-of select="@value" />").</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A virtual property must have an allowed value.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />must have an allowed value 
                <sch:value-of select="string-join($virtuals, ' ∨ ')" />(not " 
                <sch:value-of select="@value" />").</diagnostic>
            </persona>
        </message>
        <message id="has-allowed-public">
            <persona id="reviewer">
                <affirmative>A public property must have an allowed value.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />must have an allowed value 
                <sch:value-of select="string-join($publics, ' ∨ ')" />(not " 
                <sch:value-of select="@value" />").</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A public property must have an allowed value.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />must have an allowed value 
                <sch:value-of select="string-join($publics, ' ∨ ')" />(not " 
                <sch:value-of select="@value" />").</diagnostic>
            </persona>
        </message>
        <message id="has-allowed-allows-authenticated-scan">
            <persona id="reviewer">
                <affirmative>An allows-authenticated-scan property has an allowed value.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />must have an allowed value 
                <sch:value-of select="string-join($allows-authenticated-scans, ' ∨ ')" />(not " 
                <sch:value-of select="@value" />").</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>An allows-authenticated-scan property has an allowed value.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />must have an allowed value 
                <sch:value-of select="string-join($allows-authenticated-scans, ' ∨ ')" />(not " 
                <sch:value-of select="@value" />").</diagnostic>
            </persona>
        </message>
        <message id="has-allowed-is-scanned">
            <persona id="reviewer">
                <affirmative>is-scanned property must have an allowed value.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />must have an allowed value 
                <sch:value-of select="string-join($is-scanneds, ' ∨ ')" />(not " 
                <sch:value-of select="@value" />").</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>is-scanned property must have an allowed value.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />must have an allowed value 
                <sch:value-of select="string-join($is-scanneds, ' ∨ ')" />(not " 
                <sch:value-of select="@value" />").</diagnostic>
            </persona>
        </message>
        <message id="has-allowed-scan-type">
            <persona id="reviewer">
                <affirmative>A scan-type property must have an allowed value.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />must have an allowed value 
                <sch:value-of select="string-join($scan-types, ' ∨ ')" />(not " 
                <sch:value-of select="@value" />").</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A scan-type property must have an allowed value.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />must have an allowed value 
                <sch:value-of select="string-join($scan-types, ' ∨ ')" />(not " 
                <sch:value-of select="@value" />").</diagnostic>
            </persona>
        </message>
        <message id="component-has-allowed-type">
            <persona id="reviewer">
                <affirmative>A component must have an allowed type.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />must have an allowed component type 
                <sch:value-of select="string-join($component-types, ' ∨ ')" />(not " 
                <sch:value-of select="@type" />").</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A component must have an allowed type.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />must have an allowed component type 
                <sch:value-of select="string-join($component-types, ' ∨ ')" />(not " 
                <sch:value-of select="@type" />").</diagnostic>
            </persona>
        </message>
        <message id="component-has-asset-type">
            <persona id="reviewer">
                <affirmative>A component must have an asset type.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />lacks an asset-type property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A component must have an asset type.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />lacks an asset-type property.</diagnostic>
            </persona>
        </message>
        <message id="component-has-one-asset-type">
            <persona id="reviewer">
                <affirmative>A component must have only one asset type.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />has more than one asset-type property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A component must have only one asset type.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />has more than one asset-type property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-uuid">
            <persona id="reviewer">
                <affirmative>An inventory-item has a uuid.</affirmative>
                <diagnostic>This inventory-item lacks a uuid attribute.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>An inventory-item has a uuid.</affirmative>
                <diagnostic>This inventory-item lacks a uuid attribute.</diagnostic>
            </persona>
        </message>
        <message id="has-asset-id">
            <persona id="reviewer">
                <affirmative>An inventory-item must have an asset-id.</affirmative>
                <diagnostic>This inventory-item lacks an asset-id property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>An inventory-item must have an asset-id.</affirmative>
                <diagnostic>This inventory-item lacks an asset-id property.</diagnostic>
            </persona>
        </message>
        <message id="has-one-asset-id">
            <persona id="reviewer">
                <affirmative>An inventory-item must have only one asset-id.</affirmative>
                <diagnostic>This inventory-item has more than one asset-id property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>An inventory-item must have only one asset-id.</affirmative>
                <diagnostic>This inventory-item has more than one asset-id property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-asset-type">
            <persona id="reviewer">
                <affirmative>An inventory-item must have an asset-type.</affirmative>
                <diagnostic>This inventory-item lacks an asset-type property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>An inventory-item must have an asset-type.</affirmative>
                <diagnostic>This inventory-item lacks an asset-type property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-one-asset-type">
            <persona id="reviewer">
                <affirmative>An inventory-item must have only one asset-type.</affirmative>
                <diagnostic>This inventory-item has more than one asset-type property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>An inventory-item must have only one asset-type.</affirmative>
                <diagnostic>This inventory-item has more than one asset-type property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-virtual">
            <persona id="reviewer">
                <affirmative>An inventory-item must have a virtual property.</affirmative>
                <diagnostic>This inventory-item lacks a virtual property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>An inventory-item must have a virtual property.</affirmative>
                <diagnostic>This inventory-item lacks a virtual property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-one-virtual">
            <persona id="reviewer">
                <affirmative>An inventory-item must have only one virtual property.</affirmative>
                <diagnostic>This inventory-item has more than one virtual property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>An inventory-item must have only one virtual property.</affirmative>
                <diagnostic>This inventory-item has more than one virtual property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-public">
            <persona id="reviewer">
                <affirmative>An inventory-item must have a public property.</affirmative>
                <diagnostic>This inventory-item lacks a public property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>An inventory-item must have a public property.</affirmative>
                <diagnostic>This inventory-item lacks a public property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-one-public">
            <persona id="reviewer">
                <affirmative>An inventory-item must have only one public property.</affirmative>
                <diagnostic>This inventory-item has more than one public property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>An inventory-item must have only one public property.</affirmative>
                <diagnostic>This inventory-item has more than one public property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-scan-type">
            <persona id="reviewer">
                <affirmative>An inventory-item must have a scan-type property.</affirmative>
                <diagnostic>This inventory-item lacks a scan-type property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>An inventory-item must have a scan-type property.</affirmative>
                <diagnostic>This inventory-item lacks a scan-type property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-one-scan-type">
            <persona id="reviewer">
                <affirmative>An inventory-item has only one scan-type property.</affirmative>
                <diagnostic>This inventory-item has more than one scan-type property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>An inventory-item has only one scan-type property.</affirmative>
                <diagnostic>This inventory-item has more than one scan-type property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-allows-authenticated-scan">
            <persona id="reviewer">
                <affirmative>"infrastructure" inventory-item has allows-authenticated-scan.</affirmative>
                <diagnostic>This inventory-item lacks allows-authenticated-scan property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>"infrastructure" inventory-item has allows-authenticated-scan.</affirmative>
                <diagnostic>This inventory-item lacks allows-authenticated-scan property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-one-allows-authenticated-scan">
            <persona id="reviewer">
                <affirmative>An inventory-item has one-allows-authenticated-scan property.</affirmative>
                <diagnostic>This inventory-item has more than one allows-authenticated-scan property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>An inventory-item has one-allows-authenticated-scan property.</affirmative>
                <diagnostic>This inventory-item has more than one allows-authenticated-scan property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-baseline-configuration-name">
            <persona id="reviewer">
                <affirmative>"infrastructure" inventory-item has baseline-configuration-name.</affirmative>
                <diagnostic>This inventory-item lacks baseline-configuration-name property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>"infrastructure" inventory-item has baseline-configuration-name.</affirmative>
                <diagnostic>This inventory-item lacks baseline-configuration-name property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-one-baseline-configuration-name">
            <persona id="reviewer">
                <affirmative>"infrastructure" inventory-item has only one baseline-configuration-name.</affirmative>
                <diagnostic>This inventory-item has more than one baseline-configuration-name property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>"infrastructure" inventory-item has only one baseline-configuration-name.</affirmative>
                <diagnostic>This inventory-item has more than one baseline-configuration-name property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-vendor-name">
            <persona id="reviewer">
                <affirmative>"infrastructure" inventory-item has a vendor-name property.</affirmative>
                <diagnostic>This inventory-item lacks a vendor-name property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>"infrastructure" inventory-item has a vendor-name property.</affirmative>
                <diagnostic>This inventory-item lacks a vendor-name property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-one-vendor-name">
            <persona id="reviewer">
                <affirmative>"infrastructure" inventory-item must have only one vendor-name property.</affirmative>
                <diagnostic>This inventory-item has more than one vendor-name property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>"infrastructure" inventory-item must have only one vendor-name property.</affirmative>
                <diagnostic>This inventory-item has more than one vendor-name property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-hardware-model">
            <persona id="reviewer">
                <affirmative>"infrastructure" inventory-item must have a hardware-model property.</affirmative>
                <diagnostic>This inventory-item lacks a hardware-model property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>"infrastructure" inventory-item must have a hardware-model property.</affirmative>
                <diagnostic>This inventory-item lacks a hardware-model property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-one-hardware-model">
            <persona id="reviewer">
                <affirmative>"infrastructure" inventory-item must have only one hardware-model property.</affirmative>
                <diagnostic>This inventory-item has more than one hardware-model property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>"infrastructure" inventory-item must have only one hardware-model property.</affirmative>
                <diagnostic>This inventory-item has more than one hardware-model property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-is-scanned">
            <persona id="reviewer">
                <affirmative>"infrastructure" inventory-item must have is-scanned property.</affirmative>
                <diagnostic>This inventory-item lacks is-scanned property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>"infrastructure" inventory-item must have is-scanned property.</affirmative>
                <diagnostic>This inventory-item lacks is-scanned property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-one-is-scanned">
            <persona id="reviewer">
                <affirmative>"infrastructure" inventory-item must have only one is-scanned property.</affirmative>
                <diagnostic>This inventory-item has more than one is-scanned property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>"infrastructure" inventory-item must have only one is-scanned property.</affirmative>
                <diagnostic>This inventory-item has more than one is-scanned property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-software-name">
            <persona id="reviewer">
                <affirmative>"software or database" inventory-item must have a software-name property.</affirmative>
                <diagnostic>This inventory-item lacks software-name property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>"software or database" inventory-item must have a software-name property.</affirmative>
                <diagnostic>This inventory-item lacks software-name property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-one-software-name">
            <persona id="reviewer">
                <affirmative>"software or database" inventory-item must have a software-name property.</affirmative>
                <diagnostic>This inventory-item has more than one software-name property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>"software or database" inventory-item must have a software-name property.</affirmative>
                <diagnostic>This inventory-item has more than one software-name property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-software-version">
            <persona id="reviewer">
                <affirmative>"software or database" inventory-item must have a software-version property.</affirmative>
                <diagnostic>This inventory-item lacks software-version property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>"software or database" inventory-item must have a software-version property.</affirmative>
                <diagnostic>This inventory-item lacks software-version property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-one-software-version">
            <persona id="reviewer">
                <affirmative>"software or database" inventory-item must have one software-version property.</affirmative>
                <diagnostic>This inventory-item has more than one software-version property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>"software or database" inventory-item must have one software-version property.</affirmative>
                <diagnostic>This inventory-item has more than one software-version property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-function">
            <persona id="reviewer">
                <affirmative>"software or database" inventory-item must have a function property.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />" 
                <sch:value-of select="oscal:prop[@name = 'asset-type']/@value" />" lacks function property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>"software or database" inventory-item must have a function property.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />" 
                <sch:value-of select="oscal:prop[@name = 'asset-type']/@value" />" lacks function property.</diagnostic>
            </persona>
        </message>
        <message id="inventory-item-has-one-function">
            <persona id="reviewer">
                <affirmative>"software or database" inventory-item must have one function property.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />" 
                <sch:value-of select="oscal:prop[@name = 'asset-type']/@value" />" has more than one function property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>"software or database" inventory-item must have one function property.</affirmative>
                <diagnostic>
                <sch:value-of select="name()" />" 
                <sch:value-of select="oscal:prop[@name = 'asset-type']/@value" />" has more than one function property.</diagnostic>
            </persona>
        </message>
        <message id="has-this-system-component">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must have a "this-system" component.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a "this-system" component.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must have a "this-system" component.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a "this-system" component.</diagnostic>
            </persona>
        </message>
        <message id="has-system-id">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must have a FedRAMP system-id.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a FedRAMP system-id.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must have a FedRAMP system-id.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a FedRAMP system-id.</diagnostic>
            </persona>
        </message>
        <message id="has-system-name">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must have a system-name.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a system-name.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must have a system-name.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a system-name.</diagnostic>
            </persona>
        </message>
        <message id="has-system-name-short">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must have a system-name-short.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a system-name-short.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must have a system-name-short.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a system-name-short.</diagnostic>
            </persona>
        </message>
        <message id="has-fedramp-authorization-type">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP must have a FedRAMP authorization type.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a FedRAMP authorization type.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP must have a FedRAMP authorization type.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks a FedRAMP authorization type.</diagnostic>
            </persona>
        </message>
        <message id="role-defined-system-owner">
            <persona id="reviewer">
                <affirmative>The system-owner role must be defined.</affirmative>
                <diagnostic>The system-owner role is missing.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>The system-owner role must be defined.</affirmative>
                <diagnostic>The system-owner role is missing.</diagnostic>
            </persona>
        </message>
        <message id="role-defined-authorizing-official">
            <persona id="reviewer">
                <affirmative>The authorizing-official role must be defined.</affirmative>
                <diagnostic>The authorizing-official role is missing.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>The authorizing-official role must be defined.</affirmative>
                <diagnostic>The authorizing-official role is missing.</diagnostic>
            </persona>
        </message>
        <message id="role-defined-system-poc-management">
            <persona id="reviewer">
                <affirmative>The system-poc-management role must be defined.</affirmative>
                <diagnostic>The system-poc-management role is missing.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>The system-poc-management role must be defined.</affirmative>
                <diagnostic>The system-poc-management role is missing.</diagnostic>
            </persona>
        </message>
        <message id="role-defined-system-poc-technical">
            <persona id="reviewer">
                <affirmative>The system-poc-technical role must be defined.</affirmative>
                <diagnostic>The system-poc-technical role is missing.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>The system-poc-technical role must be defined.</affirmative>
                <diagnostic>The system-poc-technical role is missing.</diagnostic>
            </persona>
        </message>
        <message id="role-defined-system-poc-other">
            <persona id="reviewer">
                <affirmative>The system-poc-other role must be defined.</affirmative>
                <diagnostic>The system-poc-other role is missing.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>The system-poc-other role must be defined.</affirmative>
                <diagnostic>The system-poc-other role is missing.</diagnostic>
            </persona>
        </message>
        <message id="role-defined-information-system-security-officer">
            <persona id="reviewer">
                <affirmative>The information-system-security-officer role must be defined.</affirmative>
                <diagnostic>The information-system-security-officer role is missing.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>The information-system-security-officer role must be defined.</affirmative>
                <diagnostic>The information-system-security-officer role is missing.</diagnostic>
            </persona>
        </message>
        <message id="role-defined-authorizing-official-poc">
            <persona id="reviewer">
                <affirmative>The authorizing-official-poc role must be defined.</affirmative>
                <diagnostic>The authorizing-official-poc role is missing.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>The authorizing-official-poc role must be defined.</affirmative>
                <diagnostic>The authorizing-official-poc role is missing.</diagnostic>
            </persona>
        </message>
        <message id="role-has-title">
            <persona id="reviewer">
                <affirmative>A role must have a title.</affirmative>
                <diagnostic>This role lacks a title.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A role must have a title.</affirmative>
                <diagnostic>This role lacks a title.</diagnostic>
            </persona>
        </message>
        <message id="role-has-responsible-party">
            <persona id="reviewer">
                <affirmative>One or more responsible parties must be defined for each role.</affirmative>
                <diagnostic>This role has no responsible parties.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>One or more responsible parties must be defined for each role.</affirmative>
                <diagnostic>This role has no responsible parties.</diagnostic>
            </persona>
        </message>
        <message id="responsible-party-has-person">
            <persona id="reviewer">
                <affirmative>Each responsible-party party-uuid must identify a person.</affirmative>
                <diagnostic>This responsible-party party-uuid does not identify a person.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each responsible-party party-uuid must identify a person.</affirmative>
                <diagnostic>This responsible-party party-uuid does not identify a person.</diagnostic>
            </persona>
        </message>
        <message id="party-has-responsibility">
            <persona id="reviewer">
                <affirmative>Each person should have a responsibility.</affirmative>
                <diagnostic>This person has no responsibility.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each person should have a responsibility.</affirmative>
                <diagnostic>This person has no responsibility.</diagnostic>
            </persona>
        </message>
        <message id="implemented-requirement-has-responsible-role">
            <persona id="reviewer">
                <affirmative>Each implemented-requirement must have one or more responsible-role definitions.</affirmative>
                <diagnostic>This implemented-requirement lacks a responsible-role definition.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each implemented-requirement must have one or more responsible-role definitions.</affirmative>
                <diagnostic>This implemented-requirement lacks a responsible-role definition.</diagnostic>
            </persona>
        </message>
        <message id="responsible-role-has-role-definition">
            <persona id="reviewer">
                <affirmative>Each responsible-role must reference a role definition.</affirmative>
                <diagnostic>This responsible-role references a non-existent role definition.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each responsible-role must reference a role definition.</affirmative>
                <diagnostic>This responsible-role references a non-existent role definition.</diagnostic>
            </persona>
        </message>
        <message id="responsible-role-has-user">
            <persona id="reviewer">
                <affirmative>Each responsible-role must be referenced in a system-implementation user assembly.</affirmative>
                <diagnostic>This responsible-role lacks a system-implementation user assembly.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each responsible-role must be referenced in a system-implementation user assembly.</affirmative>
                <diagnostic>This responsible-role lacks a system-implementation user assembly.</diagnostic>
            </persona>
        </message>
        <message id="user-has-role-id">
            <persona id="reviewer">
                <affirmative>Every user has a role-id.</affirmative>
                <diagnostic>This user lacks a role-id.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Every user has a role-id.</affirmative>
                <diagnostic>This user lacks a role-id.</diagnostic>
            </persona>
        </message>
        <message id="user-has-user-type">
            <persona id="reviewer">
                <affirmative>Every user has a user type property.</affirmative>
                <diagnostic>This user lacks a user type property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Every user has a user type property.</affirmative>
                <diagnostic>This user lacks a user type property.</diagnostic>
            </persona>
        </message>
        <message id="user-has-privilege-level">
            <persona id="reviewer">
                <affirmative>Every user has a privilege-level property.</affirmative>
                <diagnostic>This user lacks a privilege-level property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Every user has a privilege-level property.</affirmative>
                <diagnostic>This user lacks a privilege-level property.</diagnostic>
            </persona>
        </message>
        <message id="user-has-sensitivity-level">
            <persona id="reviewer">
                <affirmative>Every user has a sensitivity level property.</affirmative>
                <diagnostic>This user lacks a sensitivity level property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Every user has a sensitivity level property.</affirmative>
                <diagnostic>This user lacks a sensitivity level property.</diagnostic>
            </persona>
        </message>
        <message id="user-has-authorized-privilege">
            <persona id="reviewer">
                <affirmative>Every user has one or more authorized-privileges.</affirmative>
                <diagnostic>This user lacks one or more authorized-privileges.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Every user has one or more authorized-privileges.</affirmative>
                <diagnostic>This user lacks one or more authorized-privileges.</diagnostic>
            </persona>
        </message>
        <message id="role-id-has-role-definition">
            <persona id="reviewer">
                <affirmative>Each role-id must reference a role definition.</affirmative>
                <diagnostic>This role-id references a non-existent role definition.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each role-id must reference a role definition.</affirmative>
                <diagnostic>This role-id references a non-existent role definition.</diagnostic>
            </persona>
        </message>
        <message id="user-user-type-has-allowed-value">
            <persona id="reviewer">
                <affirmative>User type property has an allowed value.</affirmative>
                <diagnostic>This user type property lacks an allowed value.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>User type property has an allowed value.</affirmative>
                <diagnostic>This user type property lacks an allowed value.</diagnostic>
            </persona>
        </message>
        <message id="user-privilege-level-has-allowed-value">
            <persona id="reviewer">
                <affirmative>User privilege-level property has an allowed value.</affirmative>
                <diagnostic>User privilege-level property has an allowed value.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>User privilege-level property has an allowed value.</affirmative>
                <diagnostic>User privilege-level property has an allowed value.</diagnostic>
            </persona>
        </message>
        <message id="user-sensitivity-level-has-allowed-value">
            <persona id="reviewer">
                <affirmative>User sensitivity level property has an allowed value.</affirmative>
                <diagnostic>This user sensitivity level property lacks an allowed value.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>User sensitivity level property has an allowed value.</affirmative>
                <diagnostic>This user sensitivity level property lacks an allowed value.</diagnostic>
            </persona>
        </message>
        <message id="authorized-privilege-has-title">
            <persona id="reviewer">
                <affirmative>Every authorized-privilege has a title.</affirmative>
                <diagnostic>This authorized-privilege lacks a title.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Every authorized-privilege has a title.</affirmative>
                <diagnostic>This authorized-privilege lacks a title.</diagnostic>
            </persona>
        </message>
        <message id="authorized-privilege-has-function-performed">
            <persona id="reviewer">
                <affirmative>Every authorized-privilege has one or more function-performed.</affirmative>
                <diagnostic>This authorized-privilege lacks one or more function-performed.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Every authorized-privilege has one or more function-performed.</affirmative>
                <diagnostic>This authorized-privilege lacks one or more function-performed.</diagnostic>
            </persona>
        </message>
        <message id="authorized-privilege-has-non-empty-title">
            <persona id="reviewer">
                <affirmative>Every authorized-privilege title is non-empty.</affirmative>
                <diagnostic>This authorized-privilege title is empty.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Every authorized-privilege title is non-empty.</affirmative>
                <diagnostic>This authorized-privilege title is empty.</diagnostic>
            </persona>
        </message>
        <message id="authorized-privilege-has-non-empty-function-performed">
            <persona id="reviewer">
                <affirmative>Every authorized-privilege has a non-empty function-performed.</affirmative>
                <diagnostic>This authorized-privilege lacks a non-empty function-performed.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Every authorized-privilege has a non-empty function-performed.</affirmative>
                <diagnostic>This authorized-privilege lacks a non-empty function-performed.</diagnostic>
            </persona>
        </message>
        <message id="has-authorization-boundary">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP includes an authorization-boundary in its system-characteristics.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an authorization-boundary in its system-characteristics.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP includes an authorization-boundary in its system-characteristics.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an authorization-boundary in its system-characteristics.</diagnostic>
            </persona>
        </message>
        <message id="has-authorization-boundary-description">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP has an authorization-boundary description.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an authorization-boundary description.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP has an authorization-boundary description.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an authorization-boundary description.</diagnostic>
            </persona>
        </message>
        <message id="has-authorization-boundary-diagram">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP has at least one authorization-boundary diagram.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks at least one authorization-boundary diagram.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP has at least one authorization-boundary diagram.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks at least one authorization-boundary diagram.</diagnostic>
            </persona>
        </message>
        <message id="has-authorization-boundary-diagram-uuid">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP authorization-boundary diagram has a uuid attribute.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP authorization-boundary diagram lacks a uuid attribute.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP authorization-boundary diagram has a uuid attribute.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP authorization-boundary diagram lacks a uuid attribute.</diagnostic>
            </persona>
        </message>
        <message id="has-authorization-boundary-diagram-description">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP authorization-boundary diagram has a description.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP authorization-boundary diagram lacks a description.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP authorization-boundary diagram has a description.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP authorization-boundary diagram lacks a description.</diagnostic>
            </persona>
        </message>
        <message id="has-authorization-boundary-diagram-link">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP authorization-boundary diagram has a link.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP authorization-boundary diagram lacks a link.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP authorization-boundary diagram has a link.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP authorization-boundary diagram lacks a link.</diagnostic>
            </persona>
        </message>
        <message id="has-authorization-boundary-diagram-caption">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP authorization-boundary diagram has a caption.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP authorization-boundary diagram lacks a caption.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP authorization-boundary diagram has a caption.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP authorization-boundary diagram lacks a caption.</diagnostic>
            </persona>
        </message>
        <message id="has-authorization-boundary-diagram-link-rel">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP authorization-boundary diagram has a link rel attribute.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP authorization-boundary diagram lacks a link rel attribute.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP authorization-boundary diagram has a link rel attribute.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP authorization-boundary diagram lacks a link rel attribute.</diagnostic>
            </persona>
        </message>
        <message id="has-authorization-boundary-diagram-link-rel-allowed-value">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP authorization-boundary diagram has a link rel attribute with the value "diagram".</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP authorization-boundary diagram lacks a link rel attribute with the value "diagram".</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP authorization-boundary diagram has a link rel attribute with the value "diagram".</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP authorization-boundary diagram lacks a link rel attribute with the value "diagram".</diagnostic>
            </persona>
        </message>
        <message id="has-authorization-boundary-diagram-link-href-target">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP authorization-boundary diagram link references a back-matter resource representing the diagram
                document.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP authorization-boundary diagram link does not reference a back-matter resource representing the
                diagram document.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP authorization-boundary diagram link references a back-matter resource representing the diagram
                document.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP authorization-boundary diagram link does not reference a back-matter resource representing the
                diagram document.</diagnostic>
            </persona>
        </message>
        <message id="has-network-architecture">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP includes a network-architecture in its system-characteristics.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an network-architecture in its system-characteristics.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP includes a network-architecture in its system-characteristics.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an network-architecture in its system-characteristics.</diagnostic>
            </persona>
        </message>
        <message id="has-network-architecture-description">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP has a network-architecture description.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an network-architecture description.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP has a network-architecture description.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an network-architecture description.</diagnostic>
            </persona>
        </message>
        <message id="has-network-architecture-diagram">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP has at least one network-architecture diagram.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks at least one network-architecture diagram.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP has at least one network-architecture diagram.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks at least one network-architecture diagram.</diagnostic>
            </persona>
        </message>
        <message id="has-network-architecture-diagram-uuid">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP network-architecture diagram has a uuid attribute.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP network-architecture diagram lacks a uuid attribute.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP network-architecture diagram has a uuid attribute.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP network-architecture diagram lacks a uuid attribute.</diagnostic>
            </persona>
        </message>
        <message id="has-network-architecture-diagram-description">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP network-architecture diagram has a description.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP network-architecture diagram lacks a description.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP network-architecture diagram has a description.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP network-architecture diagram lacks a description.</diagnostic>
            </persona>
        </message>
        <message id="has-network-architecture-diagram-link">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP network-architecture diagram has a link.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP network-architecture diagram lacks a link.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP network-architecture diagram has a link.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP network-architecture diagram lacks a link.</diagnostic>
            </persona>
        </message>
        <message id="has-network-architecture-diagram-caption">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP network-architecture diagram has a caption.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP network-architecture diagram lacks a caption.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP network-architecture diagram has a caption.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP network-architecture diagram lacks a caption.</diagnostic>
            </persona>
        </message>
        <message id="has-network-architecture-diagram-link-rel">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP network-architecture diagram has a link rel attribute.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP network-architecture diagram lacks a link rel attribute.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP network-architecture diagram has a link rel attribute.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP network-architecture diagram lacks a link rel attribute.</diagnostic>
            </persona>
        </message>
        <message id="has-network-architecture-diagram-link-rel-allowed-value">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP network-architecture diagram has a link rel attribute with the value "diagram".</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP network-architecture diagram lacks a link rel attribute with the value "diagram".</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP network-architecture diagram has a link rel attribute with the value "diagram".</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP network-architecture diagram lacks a link rel attribute with the value "diagram".</diagnostic>
            </persona>
        </message>
        <message id="has-network-architecture-diagram-link-href-target">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP network-architecture diagram link references a back-matter resource representing the diagram
                document.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP network-architecture diagram link does not reference a back-matter resource representing the
                diagram document.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP network-architecture diagram link references a back-matter resource representing the diagram
                document.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP network-architecture diagram link does not reference a back-matter resource representing the
                diagram document.</diagnostic>
            </persona>
        </message>
        <message id="has-data-flow">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP includes a data-flow in its system-characteristics.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an data-flow in its system-characteristics.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP includes a data-flow in its system-characteristics.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an data-flow in its system-characteristics.</diagnostic>
            </persona>
        </message>
        <message id="has-data-flow-description">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP has a data-flow description.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an data-flow description.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP has a data-flow description.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an data-flow description.</diagnostic>
            </persona>
        </message>
        <message id="has-data-flow-diagram">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP has at least one data-flow diagram.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks at least one data-flow diagram.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP has at least one data-flow diagram.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks at least one data-flow diagram.</diagnostic>
            </persona>
        </message>
        <message id="has-data-flow-diagram-uuid">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP data-flow diagram has a uuid attribute.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP data-flow diagram lacks a uuid attribute.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP data-flow diagram has a uuid attribute.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP data-flow diagram lacks a uuid attribute.</diagnostic>
            </persona>
        </message>
        <message id="has-data-flow-diagram-description">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP data-flow diagram has a description.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP data-flow diagram lacks a description.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP data-flow diagram has a description.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP data-flow diagram lacks a description.</diagnostic>
            </persona>
        </message>
        <message id="has-data-flow-diagram-link">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP data-flow diagram has a link.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP data-flow diagram lacks a link.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP data-flow diagram has a link.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP data-flow diagram lacks a link.</diagnostic>
            </persona>
        </message>
        <message id="has-data-flow-diagram-caption">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP data-flow diagram has a caption.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP data-flow diagram lacks a caption.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP data-flow diagram has a caption.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP data-flow diagram lacks a caption.</diagnostic>
            </persona>
        </message>
        <message id="has-data-flow-diagram-link-rel">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP data-flow diagram has a link rel attribute.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP data-flow diagram lacks a link rel attribute.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP data-flow diagram has a link rel attribute.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP data-flow diagram lacks a link rel attribute.</diagnostic>
            </persona>
        </message>
        <message id="has-data-flow-diagram-link-rel-allowed-value">
            <persona id="reviewer">
                <affirmative>Each FedRAMP OSCAL SSP data-flow diagram has a link rel attribute with the value "diagram".</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP data-flow diagram lacks a link rel attribute with the value "diagram".</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Each FedRAMP OSCAL SSP data-flow diagram has a link rel attribute with the value "diagram".</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP data-flow diagram lacks a link rel attribute with the value "diagram".</diagnostic>
            </persona>
        </message>
        <message id="has-data-flow-diagram-link-href-target">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP data-flow diagram link references a back-matter resource representing the diagram
                document.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP data-flow diagram link does not reference a back-matter resource representing the diagram
                document.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP data-flow diagram link references a back-matter resource representing the diagram
                document.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP data-flow diagram link does not reference a back-matter resource representing the diagram
                document.</diagnostic>
            </persona>
        </message>
        <message id="system-security-plan-has-import-profile">
            <persona id="reviewer">
                <affirmative>A FedRAMP OSCAL SSP declares the related FedRAMP OSCAL Profile using an import-profile element.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an import-profile element.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>A FedRAMP OSCAL SSP declares the related FedRAMP OSCAL Profile using an import-profile element.</affirmative>
                <diagnostic>This FedRAMP OSCAL SSP lacks an import-profile element.</diagnostic>
            </persona>
        </message>
        <message id="import-profile-has-href-attribute">
            <persona id="reviewer">
                <affirmative>The import-profile element has an href attribute.</affirmative>
                <diagnostic>The import-profile element lacks an href attribute.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>The import-profile element has an href attribute.</affirmative>
                <diagnostic>The import-profile element lacks an href attribute.</diagnostic>
            </persona>
        </message>
        <message id="implemented-requirement-has-implementation-status">
            <persona id="reviewer">
                <affirmative>Every implemented-requirement has an implementation-status property.</affirmative>
                <diagnostic>This implemented-requirement lacks an implementation-status.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Every implemented-requirement has an implementation-status property.</affirmative>
                <diagnostic>This implemented-requirement lacks an implementation-status.</diagnostic>
            </persona>
        </message>
        <message id="implemented-requirement-has-planned-completion-date">
            <persona id="reviewer">
                <affirmative>Planned control implementations have a planned completion date.</affirmative>
                <diagnostic>This planned control implementations lacks a planned completion date.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Planned control implementations have a planned completion date.</affirmative>
                <diagnostic>This planned control implementations lacks a planned completion date.</diagnostic>
            </persona>
        </message>
        <message id="implemented-requirement-has-control-origination">
            <persona id="reviewer">
                <affirmative>Every implemented-requirement has a control-origination property.</affirmative>
                <diagnostic>This implemented-requirement lacks a control-origination property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Every implemented-requirement has a control-origination property.</affirmative>
                <diagnostic>This implemented-requirement lacks a control-origination property.</diagnostic>
            </persona>
        </message>
        <message id="implemented-requirement-has-allowed-control-origination">
            <persona id="reviewer">
                <affirmative>Every implemented-requirement has an allowed control-origination property.</affirmative>
                <diagnostic>This implemented-requirement lacks an allowed control-origination property.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Every implemented-requirement has an allowed control-origination property.</affirmative>
                <diagnostic>This implemented-requirement lacks an allowed control-origination property.</diagnostic>
            </persona>
        </message>
        <message id="implemented-requirement-has-leveraged-authorization">
            <persona id="reviewer">
                <affirmative>Every implemented-requirement with a control-origination property of "inherited" references a
                leveraged-authorization.</affirmative>
                <diagnostic>This implemented-requirement with a control-origination property of "inherited" does not reference a
                leveraged-authorization element in the same document.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Every implemented-requirement with a control-origination property of "inherited" references a
                leveraged-authorization.</affirmative>
                <diagnostic>This implemented-requirement with a control-origination property of "inherited" does not reference a
                leveraged-authorization element in the same document.</diagnostic>
            </persona>
        </message>
        <message id="implemented-requirement-has-implementation-status-remarks">
            <persona id="reviewer">
                <affirmative>Incomplete control implementations have an explanation.</affirmative>
                <diagnostic>This incomplete control implementation lacks an explanation.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Incomplete control implementations have an explanation.</affirmative>
                <diagnostic>This incomplete control implementation lacks an explanation.</diagnostic>
            </persona>
        </message>
        <message id="planned-completion-date-is-valid">
            <persona id="reviewer">
                <affirmative>Planned completion date is valid.</affirmative>
                <diagnostic>This planned completion date is not valid.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Planned completion date is valid.</affirmative>
                <diagnostic>This planned completion date is not valid.</diagnostic>
            </persona>
        </message>
        <message id="planned-completion-date-is-not-past">
            <persona id="reviewer">
                <affirmative>Planned completion date is not past.</affirmative>
                <diagnostic>This planned completion date references a past time.</diagnostic>
            </persona>
            <persona id="submitter">
                <affirmative>Planned completion date is not past.</affirmative>
                <diagnostic>This planned completion date references a past time.</diagnostic>
            </persona>
        </message>
    </messages>
</sch:schema>
