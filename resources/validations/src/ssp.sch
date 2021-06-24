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
    <doc:xspec href="../test/ssp.xspec" />
    <sch:title>FedRAMP System Security Plan Validations</sch:title>
    <xsl:output encoding="UTF-8"
                indent="yes"
                method="xml" />
    <xsl:param as="xs:string"
               name="registry-base-path"
               select="'../../xml'" />
    <xsl:param as="xs:string"
               name="baselines-base-path"
               select="'../../../baselines/rev4/xml'" />
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
            <!-- 
            OSCAL releases are tagged, but updates from OSCAL CI/CD pipeline to
            github.com/usnistgov/oscal-content are not. The 0f78f05 commit is the
            most recent triggered by the OSCAL 1.0.0-rc1 release. Change this url
            accordingly if you know what you are doing.
            -->
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
    <sch:pattern>
        <sch:rule context="/o:system-security-plan">
            <sch:let name="ok-values"
                     value="$registry/f:fedramp-values/f:value-set[@name = 'security-sensitivity-level']" />
            <sch:let name="sensitivity-level"
                     value="/ =&gt; lv:sensitivity-level() =&gt; lv:if-empty-default('')" />
            <sch:let name="corrections"
                     value="lv:correct($ok-values, $sensitivity-level)" />
            <sch:assert diagnostics="no-registry-values-diagnostic"
                        id="no-registry-values"
                        role="fatal"
                        test="count($registry/f:fedramp-values/f:value-set) &gt; 0">The registry values at the path ' 
            <sch:value-of select="$registry-base-path" />' are not present, this configuration is invalid.</sch:assert>
            <sch:assert diagnostics="no-security-sensitivity-level-diagnostic"
                        doc:organizational-id="section-c.1.a"
                        id="no-security-sensitivity-level"
                        role="fatal"
                        test="$sensitivity-level != ''">[Section C Check 1.a] No sensitivty level found, no more validation processing can
                        occur.</sch:assert>
            <sch:assert diagnostics="invalid-security-sensitivity-level-diagnostic"
                        doc:organizational-id="section-c.1.a"
                        id="invalid-security-sensitivity-level"
                        role="fatal"
                        test="empty($ok-values) or not(exists($corrections))">[Section C Check 1.a] 
            <sch:value-of select="./name()" />is an invalid value of ' 
            <sch:value-of select="lv:sensitivity-level(/)" />', not an allowed value of 
            <sch:value-of select="$corrections" />. No more validation processing can occur.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation">
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
            <sch:report id="each-required-control-report"
                        role="positive"
                        test="count($required-controls) &gt; 0">The following 
            <sch:value-of select="count($required-controls)" />
            <sch:value-of select="
                        if (count($required-controls) = 1) then
                            ' control'
                        else
                            ' controls'" />are required: 
            <sch:value-of select="$required-controls/@id" />.</sch:report>
            <sch:assert diagnostics="incomplete-core-implemented-requirements-diagnostic"
                        doc:organizational-id="section-c.3"
                        id="incomplete-core-implemented-requirements"
                        role="error"
                        test="not(exists($core-missing))">[Section C Check 3] This SSP has not implemented the most important 
            <sch:value-of select="count($core-missing)" />core 
            <sch:value-of select="
                        if (count($core-missing) = 1) then
                            ' control'
                        else
                            ' controls'" />: 
            <sch:value-of select="$core-missing/@id" /></sch:assert>
            <sch:assert diagnostics="incomplete-all-implemented-requirements-diagnostic"
                        doc:organizational-id="section-c.2"
                        id="incomplete-all-implemented-requirements"
                        role="warn"
                        test="not(exists($all-missing))">[Section C Check 2] This SSP has not implemented 
            <sch:value-of select="count($all-missing)" />
            <sch:value-of select="
                        if (count($all-missing) = 1) then
                            ' control'
                        else
                            ' controls'" />overall: 
            <sch:value-of select="$all-missing/@id" /></sch:assert>
            <sch:assert diagnostics="extraneous-implemented-requirements-diagnostic"
                        doc:organizational-id="section-c.2"
                        id="extraneous-implemented-requirements"
                        role="warn"
                        test="not(exists($extraneous))">[Section C Check 2] This SSP has implemented 
            <sch:value-of select="count($extraneous)" />extraneous 
            <sch:value-of select="
                        if (count($extraneous) = 1) then
                            ' control'
                        else
                            ' controls'" />not needed given the selected profile: 
            <sch:value-of select="$extraneous/@control-id" /></sch:assert>
            <sch:let name="results"
                     value="$ok-values =&gt; lv:analyze(//o:implemented-requirement/o:prop[@name = 'implementation-status'])" />
            <sch:let name="total"
                     value="$results/reports/@count" />
            <sch:report id="control-implemented-requirements-stats"
                        role="positive"
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
                        doc:organizational-id="section-c.2"
                        id="invalid-implementation-status"
                        role="error"
                        test="not(exists($corrections))">[Section C Check 2] Invalid status ' 
            <sch:value-of select="$status" />' for 
            <sch:value-of select="./@control-id" />, must be 
            <sch:value-of select="$corrections" /></sch:assert>
            <sch:report id="implemented-response-points"
                        role="positive"
                        test="exists($implemented)">[Section C Check 2] This SSP has implemented a statement for each of the following lettered
                        response points for required controls: 
            <sch:value-of select="$implemented/@statement-id" />.</sch:report>
            <sch:assert diagnostics="missing-response-points-diagnostic"
                        doc:organizational-id="section-c.2"
                        id="missing-response-points"
                        role="error"
                        test="not(exists($missing))">[Section C Check 2] This SSP has not implemented a statement for each of the following lettered
                        response points for required controls: 
            <sch:value-of select="$missing/@id" />.</sch:assert>
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
                        doc:organizational-id="section-d"
                        id="missing-response-components"
                        role="warning"
                        test="$components-count &gt;= $required-components-count">[Section D Checks] Response statements for 
            <sch:value-of select="./@statement-id" />must have at least 
            <sch:value-of select="$required-components-count" />
            <sch:value-of select="
                        if (count($components-count) = 1) then
                            ' component'
                        else
                            ' components'" />with a description. There are 
            <sch:value-of select="$components-count" />.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:description">
            <sch:assert diagnostics="extraneous-response-description-diagnostic"
                        doc:organizational-id="section-d"
                        id="extraneous-response-description"
                        role="warning"
                        test=". =&gt; empty()">[Section D Checks] Response statement 
            <sch:value-of select="../@statement-id" />has a description not within a component. That was previously allowed, but not recommended. It
            will soon be syntactically invalid and deprecated.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:remarks">
            <sch:assert diagnostics="extraneous-response-remarks-diagnostic"
                        doc:organizational-id="section-d"
                        id="extraneous-response-remarks"
                        role="warning"
                        test=". =&gt; empty()">[Section D Checks] Response statement 
            <sch:value-of select="../@statement-id" />has remarks not within a component. That was previously allowed, but not recommended. It will
            soon be syntactically invalid and deprecated.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component">
            <sch:let name="component-ref"
                     value="./@component-uuid" />
            <sch:assert diagnostics="invalid-component-match-diagnostic"
                        doc:organizational-id="section-d"
                        id="invalid-component-match"
                        role="warning"
                        test="/o:system-security-plan/o:system-implementation/o:component[@uuid = $component-ref] =&gt; exists()">[Section D Checks]
                        Response statment 
            <sch:value-of select="../@statement-id" />with component reference UUID ' 
            <sch:value-of select="$component-ref" />' is not in the system implementation inventory, and cannot be used to define a
            control.</sch:assert>
            <sch:assert diagnostics="missing-component-description-diagnostic"
                        doc:organizational-id="section-d"
                        id="missing-component-description"
                        role="error"
                        test="./o:description =&gt; exists()">[Section D Checks] Response statement 
            <sch:value-of select="../@statement-id" />has a component, but that component is missing a required description node.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:description">
            <sch:let name="required-length"
                     value="20" />
            <sch:let name="description"
                     value=". =&gt; normalize-space()" />
            <sch:let name="description-length"
                     value="$description =&gt; string-length()" />
            <sch:assert diagnostics="incomplete-response-description-diagnostic"
                        doc:organizational-id="section-d"
                        id="incomplete-response-description"
                        role="error"
                        test="$description-length &gt;= $required-length">[Section D Checks] Response statement component description for 
            <sch:value-of select="../../@statement-id" />is too short with 
            <sch:value-of select="$description-length" />characters. It must be 
            <sch:value-of select="$required-length" />characters long.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:remarks">
            <sch:let name="required-length"
                     value="20" />
            <sch:let name="remarks"
                     value=". =&gt; normalize-space()" />
            <sch:let name="remarks-length"
                     value="$remarks =&gt; string-length()" />
            <sch:assert diagnostics="incomplete-response-remarks-diagnostic"
                        doc:organizational-id="section-d"
                        id="incomplete-response-remarks"
                        role="warning"
                        test="$remarks-length &gt;= $required-length">[Section D Checks] Response statement component remarks for 
            <sch:value-of select="../../@statement-id" />is too short with 
            <sch:value-of select="$remarks-length" />characters. It must be 
            <sch:value-of select="$required-length" />characters long.</sch:assert>
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
                        doc:organizational-id="section-c.6"
                        id="incorrect-role-association"
                        role="error"
                        test="not(exists($extraneous-roles))">[Section C Check 2] This SSP has defined a responsible party with 
            <sch:value-of select="count($extraneous-roles)" />
            <sch:value-of select="
                        if (count($extraneous-roles) = 1) then
                            ' role'
                        else
                            ' roles'" />not defined in the role: 
            <sch:value-of select="$extraneous-roles/@role-id" /></sch:assert>
            <sch:assert diagnostics="incorrect-party-association-diagnostic"
                        doc:organizational-id="section-c.6"
                        id="incorrect-party-association"
                        role="error"
                        test="not(exists($extraneous-parties))">[Section C Check 2] This SSP has defined a responsible party with 
            <sch:value-of select="count($extraneous-parties)" />
            <sch:value-of select="
                        if (count($extraneous-parties) = 1) then
                            ' party'
                        else
                            ' parties'" />is not a defined party: 
            <sch:value-of select="$extraneous-parties/o:party-uuid" /></sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:back-matter/o:resource">
            <sch:assert diagnostics="resource-uuid-required-diagnostic"
                        doc:organizational-id="section-b.?????"
                        id="resource-uuid-required"
                        role="error"
                        test="./@uuid">[Section B Check ????] This SSP includes back-matter resource missing a UUID</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:back-matter/o:resource/o:rlink">
            <sch:assert diagnostics="resource-rlink-required-diagnostic"
                        doc:organizational-id="section-b.?????"
                        id="resource-rlink-required"
                        role="error"
                        test="doc-available(./@href)">[Section B Check ????] This SSP references back-matter resource: 
            <sch:value-of select="./@href" /></sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:back-matter/o:resource/o:base64">
            <sch:let name="filename"
                     value="@filename" />
            <sch:let name="media-type"
                     value="@media-type" />
            <sch:assert diagnostics="resource-base64-available-filenamne-diagnostic"
                        doc:organizational-id="section-b.?????"
                        id="resource-base64-available-filenamne"
                        role="error"
                        test="./@filename">[Section B Check ????] This SSP has file name: 
            <sch:value-of select="./@filename" /></sch:assert>
            <sch:assert diagnostics="resource-base64-available-media-type-diagnostic"
                        doc:organizational-id="section-b.?????"
                        id="resource-base64-available-media-type"
                        role="error"
                        test="./@filename">[Section B Check ????] This SSP has media type: 
            <sch:value-of select="./@media-type" /></sch:assert>
        </sch:rule>
    </sch:pattern>
    <!-- set $fedramp-values globally -->
    <sch:let name="fedramp-values"
             value="doc(concat($registry-base-path, '/fedramp_values.xml'))" />
    <!-- ↑ stage 2 content ↑ -->
    <!-- ↓ stage 3 content ↓ -->
    <sch:pattern>
        <sch:title>Basic resource constraints</sch:title>
        <sch:let name="attachment-types"
                 value="$fedramp-values//fedramp:value-set[@name = 'attachment-type']//fedramp:enum/@value" />
        <sch:rule context="oscal:resource">
            <!-- the following assertion recapitulates the XML Schema constraint -->
            <sch:assert diagnostics="resource-has-uuid-diagnostic"
                        id="resource-has-uuid"
                        role="error"
                        test="@uuid">A resource must have a uuid attribute.</sch:assert>
            <sch:assert diagnostics="resource-has-title-diagnostic"
                        id="resource-has-title"
                        role="warning"
                        test="oscal:title">A resource should have a title.</sch:assert>
            <sch:assert diagnostics="resource-has-rlink-diagnostic"
                        id="resource-has-rlink"
                        role="error"
                        test="oscal:rlink">A resource must have a rlink element</sch:assert>
            <sch:assert diagnostics="resource-is-referenced-diagnostic"
                        id="resource-is-referenced"
                        role="info"
                        test="@uuid = (//@href[matches(., '^#')] ! substring-after(., '#'))">A resource should be referenced from within the
                        document.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:back-matter/oscal:resource/oscal:prop[@name = 'type']">
            <sch:assert diagnostics="attachment-type-is-valid-diagnostic"
                        id="attachment-type-is-valid"
                        role="warning"
                        test="@value = $attachment-types">A resource should have an allowed attachment-type property.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:back-matter/oscal:resource/oscal:rlink">
            <sch:assert diagnostics="rlink-has-href-diagnostic"
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
        <sch:rule context="@media-type"
                  role="error">
            <sch:let name="media-types"
                     value="$fedramp-values//fedramp:value-set[@name = 'media-type']//fedramp:enum/@value" />
            <sch:report role="information"
                        test="false()">There are 
            <sch:value-of select="count($media-types)" />media types.</sch:report>
            <sch:assert diagnostics="has-allowed-media-type-diagnostic"
                        id="has-allowed-media-type"
                        role="error"
                        test="current() = $media-types">A media-type attribute must have an allowed value.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:title>base64 attachments</sch:title>
        <sch:rule context="oscal:back-matter/oscal:resource">
            <sch:assert diagnostics="resource-has-base64-diagnostic"
                        id="resource-has-base64"
                        role="warning"
                        test="oscal:base64">A resource should have a base64 element.</sch:assert>
            <sch:assert diagnostics="resource-base64-cardinality-diagnostic"
                        id="resource-base64-cardinality"
                        role="error"
                        test="not(oscal:base64[2])">A resource must have only one base64 element.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:back-matter/oscal:resource/oscal:base64">
            <sch:assert diagnostics="base64-has-filename-diagnostic"
                        id="base64-has-filename"
                        role="error"
                        test="@filename">A base64 element must have a filename attribute.</sch:assert>
            <sch:assert diagnostics="base64-has-media-type-diagnostic"
                        id="base64-has-media-type"
                        role="error"
                        test="@media-type">A base64 element must have a media-type attribute.</sch:assert>
            <sch:assert diagnostics="base64-has-content-diagnostic"
                        id="base64-has-content"
                        role="error"
                        test="matches(normalize-space(), '^[A-Za-z0-9+/]+$')">A base64 element must have content.</sch:assert>
            <!-- FYI: http://expath.org/spec/binary#decode-string handles base64 but Saxon-PE or higher is necessary -->
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:title>Constraints for specific attachments</sch:title>
        <sch:rule context="oscal:back-matter"
                  see="https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf">
            <sch:assert diagnostics="has-fedramp-acronyms-diagnostic"
                        id="has-fedramp-acronyms"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-acronyms']]">A
                        FedRAMP OSCAL SSP must attach the FedRAMP Master Acronym and Glossary.</sch:assert>
            <sch:assert diagnostics="has-fedramp-citations-diagnostic"
                        doc:attachment="§15 Attachment 12"
                        id="has-fedramp-citations"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-citations']]">A
                        FedRAMP OSCAL SSP must attach the FedRAMP Applicable Laws and Regulations.</sch:assert>
            <sch:assert diagnostics="has-fedramp-logo-diagnostic"
                        id="has-fedramp-logo"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-logo']]">A
                        FedRAMP OSCAL SSP must attach the FedRAMP Logo.</sch:assert>
            <sch:assert diagnostics="has-user-guide-diagnostic"
                        doc:attachment="§15 Attachment 2"
                        id="has-user-guide"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'user-guide']]">A
                        FedRAMP OSCAL SSP must attach a User Guide.</sch:assert>
            <sch:assert diagnostics="has-rules-of-behavior-diagnostic"
                        doc:attachment="§15 Attachment 5"
                        id="has-rules-of-behavior"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'rules-of-behavior']]">A
                        FedRAMP OSCAL SSP must attach Rules of Behavior.</sch:assert>
            <sch:assert diagnostics="has-information-system-contingency-plan-diagnostic"
                        doc:attachment="§15 Attachment 6"
                        id="has-information-system-contingency-plan"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'information-system-contingency-plan']]">
            A FedRAMP OSCAL SSP must attach a Contingency Plan</sch:assert>
            <sch:assert diagnostics="has-configuration-management-plan-diagnostic"
                        doc:attachment="§15 Attachment 7"
                        id="has-configuration-management-plan"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'configuration-management-plan']]">
                        A FedRAMP OSCAL SSP must attach a Configuration Management Plan.</sch:assert>
            <sch:assert diagnostics="has-incident-response-plan-diagnostic"
                        doc:attachment="§15 Attachment 8"
                        id="has-incident-response-plan"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'incident-response-plan']]">
                        A FedRAMP OSCAL SSP must attach an Incident Response Plan.</sch:assert>
            <sch:assert diagnostics="has-separation-of-duties-matrix-diagnostic"
                        doc:attachment="§15 Attachment 11"
                        id="has-separation-of-duties-matrix"
                        role="error"
                        test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'separation-of-duties-matrix']]">
                        A FedRAMP OSCAL SSP must attach a Separation of Duties Matrix.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:title>Policy and Procedure attachments</sch:title>
        <sch:title>A FedRAMP SSP must incorporate one policy document and one procedure document for each of the 17 NIST SP 800-54 Revision 4 control
        families</sch:title>
        <!-- TODO: handle attachments declared by component (see implemented-requirement ac-1 for an example) -->
        <!-- FIXME: XSpec testing malfunctions when the following rule context is constrained to XX-1 control-ids -->
        <sch:rule context="oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')]"
                  doc:attachment="§15 Attachment 1"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 48">
            <sch:assert diagnostics="has-policy-link-diagnostic"
                        id="has-policy-link"
                        role="error"
                        test="descendant::oscal:by-component/oscal:link[@rel = 'policy']">A FedRAMP SSP must incorporate a policy document for each
                        of the 17 NIST SP 800-54 Revision 4 control families.</sch:assert>
            <sch:let name="policy-hrefs"
                     value="distinct-values(descendant::oscal:by-component/oscal:link[@rel = 'policy']/@href ! substring-after(., '#'))" />
            <sch:assert diagnostics="has-policy-attachment-resource-diagnostic"
                        id="has-policy-attachment-resource"
                        role="error"
                        test="
                    every $ref in $policy-hrefs
                        satisfies exists(//oscal:resource[oscal:prop[@name = 'type' and @value = 'policy']][@uuid = $ref])">A FedRAMP SSP must
incorporate a policy document for each of the 17 NIST SP 800-54 Revision 4 control families.</sch:assert>
            <!-- TODO: ensure resource has an rlink -->
            <sch:assert diagnostics="has-procedure-link-diagnostic"
                        id="has-procedure-link"
                        role="error"
                        test="descendant::oscal:by-component/oscal:link[@rel = 'procedure']">A FedRAMP SSP must incorporate a procedure document for
                        each of the 17 NIST SP 800-54 Revision 4 control families.</sch:assert>
            <sch:let name="procedure-hrefs"
                     value="distinct-values(descendant::oscal:by-component/oscal:link[@rel = 'procedure']/@href ! substring-after(., '#'))" />
            <sch:assert diagnostics="has-procedure-attachment-resource-diagnostic"
                        id="has-procedure-attachment-resource"
                        role="error"
                        test="
                    (: targets of links exist in the document :)
                    every $ref in $procedure-hrefs
                        satisfies exists(//oscal:resource[oscal:prop[@name = 'type' and @value = 'procedure']][@uuid = $ref])">A FedRAMP SSP must
incorporate a procedure document for each of the 17 NIST SP 800-54 Revision 4 control families.</sch:assert>
            <!-- TODO: ensure resource has an rlink -->
        </sch:rule>
        <sch:rule context="oscal:by-component/oscal:link[@rel = ('policy', 'procedure')]">
            <sch:let name="ir"
                     value="ancestor::oscal:implemented-requirement" />
            <sch:report diagnostics="has-reuse-diagnostic"
                        id="has-reuse"
                        role="error"
                        test="
                    (: the current @href is in :)
                    @href = (: all controls except the current :) (//oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')] except $ir) (: all their @hrefs :)/descendant::oscal:by-component/oscal:link[@rel = 'policy']/@href">
            Policy and procedure documents must have unique per-control-family associations.</sch:report>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:title>A FedRAMP OSCAL SSP must specify a Privacy Point of Contact</sch:title>
        <sch:rule context="oscal:metadata"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 49">
            <sch:assert diagnostics="has-privacy-poc-role-diagnostic"
                        id="has-privacy-poc-role"
                        role="error"
                        test="/oscal:system-security-plan/oscal:metadata/oscal:role[@id = 'privacy-poc']">A FedRAMP OSCAL SSP must incorporate a
                        Privacy Point of Contact role</sch:assert>
            <sch:assert diagnostics="has-responsible-party-privacy-poc-role-diagnostic"
                        id="has-responsible-party-privacy-poc-role"
                        role="error"
                        test="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']">A FedRAMP OSCAL SSP must
                        declare a Privacy Point of Contact responsible party role reference</sch:assert>
            <sch:assert diagnostics="has-responsible-privacy-poc-party-uuid-diagnostic"
                        id="has-responsible-privacy-poc-party-uuid"
                        role="error"
                        test="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']/oscal:party-uuid">A
                        FedRAMP OSCAL SSP must declare a Privacy Point of Contact responsible party role reference identifying the party by
                        UUID</sch:assert>
            <sch:let name="poc-uuid"
                     value="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']/oscal:party-uuid" />
            <sch:assert diagnostics="has-privacy-poc-diagnostic"
                        id="has-privacy-poc"
                        role="error"
                        test="/oscal:system-security-plan/oscal:metadata/oscal:party[@uuid = $poc-uuid]">A FedRAMP OSCAL SSP must define a Privacy
                        Point of Contact</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:title>A FedRAMP OSCAL SSP may need to incorporate a PIA and possibly a SORN</sch:title>
        <!-- The "PTA" appears to be just a few questions, not an attachment -->
        <sch:rule context="oscal:prop[@name = 'privacy-sensitive'] | oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and matches(@name, '^pta-\d$')]"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 51">
            <sch:assert diagnostics="has-correct-yes-or-no-answer-diagnostic"
                        id="has-correct-yes-or-no-answer"
                        role="error"
                        test="current()/@value = ('yes', 'no')">A PTA/PIA qualifying question must have an allowed answer.</sch:assert>
        </sch:rule>
        <sch:rule context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 51">
            <sch:assert diagnostics="has-privacy-sensitive-designation-diagnostic"
                        id="has-privacy-sensitive-designation"
                        role="error"
                        test="oscal:prop[@name = 'privacy-sensitive']">A FedRAMP OSCAL SSP must have a privacy-sensitive designation</sch:assert>
            <sch:assert diagnostics="has-pta-question-1-diagnostic"
                        id="has-pta-question-1"
                        role="error"
                        test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-1']">A FedRAMP OSCAL SSP must have
                        PTA/PIA qualifying question #1.</sch:assert>
            <sch:assert diagnostics="has-pta-question-2-diagnostic"
                        id="has-pta-question-2"
                        role="error"
                        test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-2']">A FedRAMP OSCAL SSP must have
                        PTA/PIA qualifying question #2.</sch:assert>
            <sch:assert diagnostics="has-pta-question-3-diagnostic"
                        id="has-pta-question-3"
                        role="error"
                        test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-3']">A FedRAMP OSCAL SSP must have
                        PTA/PIA qualifying question #3.</sch:assert>
            <sch:assert diagnostics="has-pta-question-4-diagnostic"
                        id="has-pta-question-4"
                        role="error"
                        test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-4']">A FedRAMP OSCAL SSP must have
                        PTA/PIA qualifying question #4.</sch:assert>
            <sch:assert diagnostics="has-all-pta-questions-diagnostic"
                        id="has-all-pta-questions"
                        role="error"
                        test="
                    every $name in ('pta-1', 'pta-2', 'pta-3', 'pta-4')
                        satisfies exists(oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = $name])">A FedRAMP OSCAL SSP
must have all four PTA questions.</sch:assert>
            <sch:assert diagnostics="has-correct-pta-question-cardinality-diagnostic"
                        id="has-correct-pta-question-cardinality"
                        role="error"
                        test="
                    not(some $name in ('pta-1', 'pta-2', 'pta-3', 'pta-4')
                        satisfies exists(oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = $name][2]))">A FedRAMP OSCAL
SSP must have duplicate PTA questions.</sch:assert>
        </sch:rule>
        <sch:rule context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 51">
            <sch:assert diagnostics="has-sorn-diagnostic"
                        id="has-sorn"
                        role="error"
                        test="/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-4' and @value = 'yes'] and oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'sorn-id' and @value != '']">
            A FedRAMP OSCAL SSP may have a SORN ID</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:back-matter"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 51">
            <sch:assert diagnostics="has-pia-diagnostic"
                        id="has-pia"
                        role="error"
                        test="
                    every $answer in //oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and matches(@name, '^pta-\d$')]
                        satisfies $answer = 'no' or oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'pia']] (: a PIA is attached :)">
            This FedRAMP OSCAL SSP must incorporate a Privacy Impact Analysis.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 58">
        <!-- FIXME: Draft guide is wildly different than template -->
        <sch:title>FIPS 140 Validation</sch:title>
        <sch:rule context="oscal:system-implementation">
            <sch:assert diagnostics="has-CMVP-validation-diagnostic"
                        id="has-CMVP-validation"
                        role="error"
                        test="oscal:component[@type = 'validation'] or oscal:inventory-item[@type = 'validation']">A FedRAMP OSCAL SSP must
                        incorporate one or more FIPS 140 validated modules.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:component[@type = 'validation'] | oscal:inventory-item[@type = 'validation']">
            <sch:assert diagnostics="has-CMVP-validation-reference-diagnostic"
                        id="has-CMVP-validation-reference"
                        role="error"
                        test="oscal:prop[@name = 'validation-reference']">A validation component or inventory-item must have a validation-reference
                        property.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern see="https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf page 12">

        <sch:title>Security Objectives Categorization (FIPS 199)</sch:title>
        <sch:rule context="oscal:system-characteristics">
            <!-- These should also be asserted in XML Schema -->
            <sch:assert diagnostics="has-security-sensitivity-level-diagnostic"
                        id="has-security-sensitivity-level"
                        role="error"
                        test="oscal:security-sensitivity-level">A FedRAMP OSCAL SSP must specify a FIPS 199 categorization.</sch:assert>
            <sch:assert diagnostics="has-security-impact-level-diagnostic"
                        id="has-security-impact-level"
                        role="error"
                        test="oscal:security-impact-level">A FedRAMP OSCAL SSP must specify a security impact level.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:security-sensitivity-level">
            <!--<sch:let
                name="security-sensitivity-levels"
                value="$fedramp-values//fedramp:value-set[@name = 'security-sensitivity-level']//fedramp:enum/@value" />-->
            <sch:let name="security-sensitivity-levels"
                     value="('Low', 'Moderate', 'High')" />
            <sch:assert diagnostics="has-allowed-security-sensitivity-level-diagnostic"
                        id="has-allowed-security-sensitivity-level"
                        role="error"
                        test="current() = $security-sensitivity-levels">A FedRAMP OSCAL SSP must specify an allowed
                        security-sensitivity-level.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:security-impact-level">
            <!-- These should also be asserted in XML Schema -->
            <sch:assert diagnostics="has-security-objective-confidentiality-diagnostic"
                        id="has-security-objective-confidentiality"
                        role="error"
                        test="oscal:security-objective-confidentiality">A FedRAMP OSCAL SSP must specify a confidentiality security
                        objective.</sch:assert>
            <sch:assert diagnostics="has-security-objective-integrity-diagnostic"
                        id="has-security-objective-integrity"
                        role="error"
                        test="oscal:security-objective-integrity">A FedRAMP OSCAL SSP must specify an integrity security objective.</sch:assert>
            <sch:assert diagnostics="has-security-objective-availability-diagnostic"
                        id="has-security-objective-availability"
                        role="error"
                        test="oscal:security-objective-availability">A FedRAMP OSCAL SSP must specify an availability security
                        objective.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:security-objective-confidentiality | oscal:security-objective-integrity | oscal:security-objective-availability">
            <!--<sch:let
                name="security-objective-levels"
                value="$fedramp-values//fedramp:value-set[@name = 'security-objective-level']//fedramp:enum/@value" />-->
            <sch:let name="security-objective-levels"
                     value="('Low', 'Moderate', 'High')" />
            <sch:report role="information"
                        test="false()">There are 
            <sch:value-of select="count($security-objective-levels)" />security-objective-levels: 
            <sch:value-of select="string-join($security-objective-levels, ' ∨ ')" />.</sch:report>
            <sch:assert diagnostics="has-allowed-security-objective-value-diagnostic"
                        id="has-allowed-security-objective-value"
                        role="error"
                        test="current() = $security-objective-levels">A FedRAMP OSCAL SSP must specify an allowed security objective
                        value.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern see="https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf page 11">

        <sch:title>SP 800-60v2r1 Information Types:</sch:title>
        <sch:rule context="oscal:system-information">
            <sch:assert diagnostics="system-information-has-information-type-diagnostic"
                        id="system-information-has-information-type"
                        role="error"
                        test="oscal:information-type">A FedRAMP OSCAL SSP must specify at least one information-type.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:information-type">
            <sch:assert diagnostics="information-type-has-title-diagnostic"
                        id="information-type-has-title"
                        role="error"
                        test="oscal:title">A FedRAMP OSCAL SSP information-type must have a title.</sch:assert>
            <sch:assert diagnostics="information-type-has-description-diagnostic"
                        id="information-type-has-description"
                        role="error"
                        test="oscal:description">A FedRAMP OSCAL SSP information-type must have a description.</sch:assert>
            <sch:assert diagnostics="information-type-has-categorization-diagnostic"
                        id="information-type-has-categorization"
                        role="error"
                        test="oscal:categorization">A FedRAMP OSCAL SSP information-type must have at least one categorization.</sch:assert>
            <sch:assert diagnostics="information-type-has-confidentiality-impact-diagnostic"
                        id="information-type-has-confidentiality-impact"
                        role="error"
                        test="oscal:confidentiality-impact">A FedRAMP OSCAL SSP information-type must have a confidentiality-impact.</sch:assert>
            <sch:assert diagnostics="information-type-has-integrity-impact-diagnostic"
                        id="information-type-has-integrity-impact"
                        role="error"
                        test="oscal:integrity-impact">A FedRAMP OSCAL SSP information-type must have a integrity-impact.</sch:assert>
            <sch:assert diagnostics="information-type-has-availability-impact-diagnostic"
                        id="information-type-has-availability-impact"
                        role="error"
                        test="oscal:availability-impact">A FedRAMP OSCAL SSP information-type must have a availability-impact.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:categorization">
            <sch:assert diagnostics="categorization-has-system-attribute-diagnostic"
                        id="categorization-has-system-attribute"
                        role="error"
                        test="@system">A FedRAMP OSCAL SSP information-type categorization must have a system attribute.</sch:assert>
            <sch:assert diagnostics="categorization-has-correct-system-attribute-diagnostic"
                        id="categorization-has-correct-system-attribute"
                        role="error"
                        test="@system = 'https://doi.org/10.6028/NIST.SP.800-60v2r1'">A FedRAMP OSCAL SSP information-type categorization must have a
                        correct system attribute. The correct value is "https://doi.org/10.6028/NIST.SP.800-60v2r1".</sch:assert>
            <sch:assert diagnostics="categorization-has-information-type-id-diagnostic"
                        id="categorization-has-information-type-id"
                        role="error"
                        test="oscal:information-type-id">A FedRAMP OSCAL SSP information-type categorization must have at least one
                        information-type-id.</sch:assert>
            <!-- FIXME: https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf page 11 has schema error -->
            <!--        confidentiality-impact, integrity-impact, availability-impact are children of <information-type> -->
        </sch:rule>
        <sch:rule context="oscal:information-type-id">
            <sch:let name="information-types"
                     value="doc(concat($registry-base-path, '/information-types.xml'))//fedramp:information-type/@id" />
            <!-- note the variant namespace and associated prefix -->
            <sch:assert diagnostics="has-allowed-information-type-id-diagnostic"
                        id="has-allowed-information-type-id"
                        role="error"
                        test="current()[. = $information-types]">A FedRAMP OSCAL SSP information-type-id must have a SP 800-60v2r1
                        identifier.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:confidentiality-impact | oscal:integrity-impact | oscal:availability-impact">
            <sch:assert diagnostics="cia-impact-has-base-diagnostic"
                        id="cia-impact-has-base"
                        role="error"
                        test="oscal:base">A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact must have a base
                        element.</sch:assert>
            <sch:assert diagnostics="cia-impact-has-selected-diagnostic"
                        id="cia-impact-has-selected"
                        role="error"
                        test="oscal:selected">A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact must have a
                        selected element.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:base | oscal:selected">
            <sch:let name="fips-levels"
                     value="('fips-199-low', 'fips-199-moderate', 'fips-199-high')" />
            <sch:assert diagnostics="cia-impact-has-approved-fips-categorization-diagnostic"
                        id="cia-impact-has-approved-fips-categorization"
                        role="error"
                        test=". = $fips-levels">A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact base or
                        select element must have an approved value.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 13">
        <sch:title>Digital Identity Determination</sch:title>
        <sch:rule context="oscal:system-characteristics">
            <sch:assert diagnostics="has-security-eauth-level-diagnostic"
                        id="has-security-eauth-level"
                        role="error"
                        test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'security-eauth' and @name = 'security-eauth-level']">A
                        FedRAMP OSCAL SSP must have a Digital Identity Determination property.</sch:assert>
            <sch:assert diagnostics="has-identity-assurance-level-diagnostic"
                        id="has-identity-assurance-level"
                        role="information"
                        test="oscal:prop[@name = 'identity-assurance-level']">A FedRAMP OSCAL SSP may have a Digital Identity Determination
                        identity-assurance-level property.</sch:assert>
            <sch:assert diagnostics="has-authenticator-assurance-level-diagnostic"
                        id="has-authenticator-assurance-level"
                        role="information"
                        test="oscal:prop[@name = 'authenticator-assurance-level']">A FedRAMP OSCAL SSP may have a Digital Identity Determination
                        authenticator-assurance-level property.</sch:assert>
            <sch:assert diagnostics="has-federation-assurance-level-diagnostic"
                        id="has-federation-assurance-level"
                        role="information"
                        test="oscal:prop[@name = 'federation-assurance-level']">A FedRAMP OSCAL SSP may have a Digital Identity Determination
                        federation-assurance-level property.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'security-eauth' and @name = 'security-eauth-level']"
                  role="error">
            <sch:let name="security-eauth-levels"
                     value="('1', '2', '3')" />
            <sch:assert diagnostics="has-allowed-security-eauth-level-diagnostic"
                        id="has-allowed-security-eauth-level"
                        role="error"
                        test="@value = $security-eauth-levels">A FedRAMP OSCAL SSP must have a Digital Identity Determination property with an
                        allowed value.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'identity-assurance-level']">
            <!--<sch:let
            name="identity-assurance-levels"
            value="('IAL1', 'IAL2', 'IAL3')" />-->
            <sch:let name="identity-assurance-levels"
                     value="('1', '2', '3')" />
            <sch:assert diagnostics="has-allowed-identity-assurance-level-diagnostic"
                        id="has-allowed-identity-assurance-level"
                        role="error"
                        test="@value = $identity-assurance-levels">A FedRAMP OSCAL SSP should have an allowed Digital Identity Determination
                        identity-assurance-level property.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'authenticator-assurance-level']">
            <!--<sch:let
            name="authenticator-assurance-levels"
            value="('AAL1', 'AAL2', 'AAL3')" />-->
            <sch:let name="authenticator-assurance-levels"
                     value="('1', '2', '3')" />
            <sch:assert diagnostics="has-allowed-authenticator-assurance-level-diagnostic"
                        id="has-allowed-authenticator-assurance-level"
                        role="error"
                        test="@value = $authenticator-assurance-levels">A FedRAMP OSCAL SSP should have an allowed Digital Identity Determination
                        authenticator-assurance-level property.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'federation-assurance-level']">
            <!--<sch:let
            name="federation-assurance-levels"
            value="('FAL1', 'FAL2', 'FAL3')" />-->
            <sch:let name="federation-assurance-levels"
                     value="('1', '2', '3')" />
            <sch:assert diagnostics="has-allowed-federation-assurance-level-diagnostic"
                        id="has-allowed-federation-assurance-level"
                        role="error"
                        test="@value = $federation-assurance-levels">A FedRAMP OSCAL SSP should have an allowed Digital Identity Determination
                        federation-assurance-level property.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:title>A FedRAMP OSCAL SSP must specify system inventory items</sch:title>
        <sch:rule context="/oscal:system-security-plan/oscal:system-implementation"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans pp52-60">
            <!-- FIXME: determine if essential items are present -->
            <doc:rule>A FedRAMP OSCAL SSP must incorporate inventory-item elements</doc:rule>
            <sch:assert diagnostics="has-inventory-items-diagnostic"
                        id="has-inventory-items"
                        role="error"
                        test="oscal:inventory-item">A FedRAMP OSCAL SSP must incorporate inventory-item elements.</sch:assert>
        </sch:rule>
        <sch:title>FedRAMP SSP value constraints</sch:title>
        <sch:rule context="oscal:prop[@name = 'asset-id']">
            <sch:assert diagnostics="has-unique-asset-id-diagnostic"
                        id="has-unique-asset-id"
                        role="error"
                        test="count(//oscal:prop[@name = 'asset-id'][@value = current()/@value]) = 1">An asset-id must be unique.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'asset-type']">
            <sch:let name="asset-types"
                     value="$fedramp-values//fedramp:value-set[@name = 'asset-type']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-asset-type-diagnostic"
                        id="has-allowed-asset-type"
                        role="warning"
                        test="@value = $asset-types">asset-type property must have an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'virtual']">
            <sch:let name="virtuals"
                     value="$fedramp-values//fedramp:value-set[@name = 'virtual']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-virtual-diagnostic"
                        id="has-allowed-virtual"
                        role="error"
                        test="@value = $virtuals">virtual property must have an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'public']">
            <sch:let name="publics"
                     value="$fedramp-values//fedramp:value-set[@name = 'public']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-public-diagnostic"
                        id="has-allowed-public"
                        role="error"
                        test="@value = $publics">public property must have an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'allows-authenticated-scan']">
            <sch:let name="allows-authenticated-scans"
                     value="$fedramp-values//fedramp:value-set[@name = 'allows-authenticated-scan']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-allows-authenticated-scan-diagnostic"
                        id="has-allowed-allows-authenticated-scan"
                        role="error"
                        test="@value = $allows-authenticated-scans">allows-authenticated-scan property has an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@name = 'is-scanned']">
            <sch:let name="is-scanneds"
                     value="$fedramp-values//fedramp:value-set[@name = 'is-scanned']//fedramp:enum/@value" />
            <sch:assert diagnostics="has-allowed-is-scanned-diagnostic"
                        id="has-allowed-is-scanned"
                        role="error"
                        test="@value = $is-scanneds">is-scanned property must have an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'scan-type']">
            <sch:let name="scan-types"
                     value="$fedramp-values//fedramp:value-set[@name = 'scan-type']//fedramp:enum/@value" />
            <sch:assert diagnostics="inventory-item-has-allowed-scan-type-diagnostic"
                        id="inventory-item-has-allowed-scan-type"
                        role="error"
                        test="@value = $scan-types">scan-type property must have an allowed value.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:component">
            <sch:let name="component-types"
                     value="$fedramp-values//fedramp:value-set[@name = 'component-type']//fedramp:enum/@value" />
            <sch:assert diagnostics="component-has-allowed-type-diagnostic"
                        id="component-has-allowed-type"
                        role="error"
                        test="@type = $component-types">A component must have an allowed type.</sch:assert>
        </sch:rule>
        <sch:title>FedRAMP OSCAL SSP inventory items</sch:title>
        <sch:rule context="oscal:inventory-item"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans pp52-60">
            <sch:assert diagnostics="inventory-item-has-uuid-diagnostic"
                        id="inventory-item-has-uuid"
                        role="error"
                        test="@uuid">An inventory-item has a uuid.</sch:assert>
            <sch:assert diagnostics="has-asset-id-diagnostic"
                        id="has-asset-id"
                        role="error"
                        test="oscal:prop[@name = 'asset-id']">An inventory-item must have an asset-id.</sch:assert>
            <sch:assert diagnostics="has-one-asset-id-diagnostic"
                        id="has-one-asset-id"
                        role="error"
                        test="count(oscal:prop[@name = 'asset-id']) = 1">An inventory-item must have only one asset-id.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-asset-type-diagnostic"
                        id="inventory-item-has-asset-type"
                        role="error"
                        test="oscal:prop[@name = 'asset-type']">An inventory-item must have an asset-type.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-asset-type-diagnostic"
                        id="inventory-item-has-one-asset-type"
                        role="error"
                        test="count(oscal:prop[@name = 'asset-type']) = 1">An inventory-item must have only one asset-type.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-virtual-diagnostic"
                        id="inventory-item-has-virtual"
                        role="error"
                        test="oscal:prop[@name = 'virtual']">An inventory-item must have a virtual property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-virtual-diagnostic"
                        id="inventory-item-has-one-virtual"
                        role="error"
                        test="count(oscal:prop[@name = 'virtual']) = 1">An inventory-item must have only one virtual property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-public-diagnostic"
                        id="inventory-item-has-public"
                        role="error"
                        test="oscal:prop[@name = 'public']">An inventory-item must have a public property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-public-diagnostic"
                        id="inventory-item-has-one-public"
                        role="error"
                        test="count(oscal:prop[@name = 'public']) = 1">An inventory-item must have only one public property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-scan-type-diagnostic"
                        id="inventory-item-has-scan-type"
                        role="error"
                        test="oscal:prop[@name = 'scan-type']">An inventory-item must have a scan-type property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-scan-type-diagnostic"
                        id="inventory-item-has-one-scan-type"
                        role="error"
                        test="count(oscal:prop[@name = 'scan-type']) = 1">An inventory-item has only one scan-type property.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]">
            <sch:assert diagnostics="inventory-item-has-allows-authenticated-scan-diagnostic"
                        id="inventory-item-has-allows-authenticated-scan"
                        role="error"
                        test="oscal:prop[@name = 'allows-authenticated-scan']">"infrastructure" inventory-item has
                        allows-authenticated-scan.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-allows-authenticated-scan-diagnostic"
                        id="inventory-item-has-one-allows-authenticated-scan"
                        role="error"
                        test="not(oscal:prop[@name = 'allows-authenticated-scan'][2])">An inventory-item has one-allows-authenticated-scan
                        property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-baseline-configuration-name-diagnostic"
                        id="inventory-item-has-baseline-configuration-name"
                        role="error"
                        test="oscal:prop[@name = 'baseline-configuration-name']">"infrastructure" inventory-item has
                        baseline-configuration-name.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-baseline-configuration-name-diagnostic"
                        id="inventory-item-has-one-baseline-configuration-name"
                        role="error"
                        test="count(oscal:prop[@name = 'baseline-configuration-name']) = 1">"infrastructure" inventory-item has only one
                        baseline-configuration-name.</sch:assert>
            <!-- FIXME: Documentation says vendor name is in FedRAMP @ns -->
            <sch:assert diagnostics="inventory-item-has-vendor-name-diagnostic"
                        id="inventory-item-has-vendor-name"
                        role="error"
                        test="oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'vendor-name']">"infrastructure" inventory-item has a
                        vendor-name property.</sch:assert>
            <!-- FIXME: Documentation says vendor name is in FedRAMP @ns -->
            <sch:assert diagnostics="inventory-item-has-one-vendor-name-diagnostic"
                        id="inventory-item-has-one-vendor-name"
                        role="error"
                        test="not(oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'vendor-name'][2])">"infrastructure"
                        inventory-item must have only one vendor-name property.</sch:assert>
            <!-- FIXME: perversely, hardware-model is not in FedRAMP @ns -->
            <sch:assert diagnostics="inventory-item-has-hardware-model-diagnostic"
                        id="inventory-item-has-hardware-model"
                        role="error"
                        test="oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'hardware-model']">"infrastructure" inventory-item
                        must have a hardware-model property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-hardware-model-diagnostic"
                        id="inventory-item-has-one-hardware-model"
                        role="error"
                        test="not(oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'hardware-model'][2])">"infrastructure"
                        inventory-item must have only one hardware-model property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-is-scanned-diagnostic"
                        id="inventory-item-has-is-scanned"
                        role="error"
                        test="oscal:prop[@name = 'is-scanned']">"infrastructure" inventory-item must have is-scanned property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-is-scanned-diagnostic"
                        id="inventory-item-has-one-is-scanned"
                        role="error"
                        test="not(oscal:prop[@name = 'is-scanned'][2])">"infrastructure" inventory-item must have only one is-scanned
                        property.</sch:assert>
            <!-- FIXME: DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 53 has typo -->
        </sch:rule>
        <sch:rule context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('software', 'database')]">
            <!-- FIXME: Software/Database Vendor -->
            <!-- FIXME: vague asset categories -->
            <sch:assert diagnostics="inventory-item-has-software-name-diagnostic"
                        id="inventory-item-has-software-name"
                        role="error"
                        test="oscal:prop[@name = 'software-name']">"software or database" inventory-item must have a software-name
                        property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-software-name-diagnostic"
                        id="inventory-item-has-one-software-name"
                        role="error"
                        test="not(oscal:prop[@name = 'software-name'][2])">"software or database" inventory-item must have a software-name
                        property.</sch:assert>
            <!-- FIXME: vague asset categories -->
            <sch:assert diagnostics="inventory-item-has-software-version-diagnostic"
                        id="inventory-item-has-software-version"
                        role="error"
                        test="oscal:prop[@name = 'software-version']">"software or database" inventory-item must have a software-version
                        property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-software-version-diagnostic"
                        id="inventory-item-has-one-software-version"
                        role="error"
                        test="not(oscal:prop[@name = 'software-version'][2])">"software or database" inventory-item must have one software-version
                        property.</sch:assert>
            <!-- FIXME: vague asset categories -->
            <sch:assert diagnostics="inventory-item-has-function-diagnostic"
                        id="inventory-item-has-function"
                        role="error"
                        test="oscal:prop[@name = 'function']">"software or database" inventory-item must have a function property.</sch:assert>
            <sch:assert diagnostics="inventory-item-has-one-function-diagnostic"
                        id="inventory-item-has-one-function"
                        role="error"
                        test="not(oscal:prop[@name = 'function'][2])">"software or database" inventory-item must have one function
                        property.</sch:assert>
        </sch:rule>
        <sch:title>FedRAMP OSCAL SSP components</sch:title>
        <sch:rule context="/oscal:system-security-plan/oscal:system-implementation/oscal:component[(: a component referenced by any inventory-item :)@uuid = //oscal:inventory-item/oscal:implemented-component/@component-uuid]"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 54">
            <sch:assert diagnostics="component-has-asset-type-diagnostic"
                        id="component-has-asset-type"
                        role="error"
                        test="oscal:prop[@name = 'asset-type']">A component must have an asset type.</sch:assert>
            <sch:assert diagnostics="component-has-one-asset-type-diagnostic"
                        id="component-has-one-asset-type"
                        role="error"
                        test="oscal:prop[@name = 'asset-type']">A component must have one asset type.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:rule context="oscal:system-implementation"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 62">
            <sch:assert diagnostics="has-system-component-diagnostic"
                        id="has-system-component"
                        role="error"
                        test="oscal:component[@type = 'system']">A FedRAMP OSCAL SSP must have a system component.</sch:assert>
            <!-- required @uuid is defined in XML Schema -->
        </sch:rule>
        <sch:rule context="oscal:system-characteristics"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 9">
            <sch:assert diagnostics="has-system-id-diagnostic"
                        id="has-system-id"
                        role="error"
                        test="oscal:system-id[@identifier-type = 'https://fedramp.gov/']">A FedRAMP OSCAL SSP must have a system-id.</sch:assert>
            <sch:assert diagnostics="has-system-name-diagnostic"
                        id="has-system-name"
                        role="error"
                        test="oscal:system-name">A FedRAMP OSCAL SSP must have a system-name.</sch:assert>
            <sch:assert diagnostics="has-system-name-short-diagnostic"
                        id="has-system-name-short"
                        role="error"
                        test="oscal:system-name-short">A FedRAMP OSCAL SSP must have a system-name-short.</sch:assert>
        </sch:rule>
        <sch:rule context="oscal:system-characteristics"
                  see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 10">
            <sch:assert diagnostics="has-fedramp-authorization-type-diagnostic"
                        id="has-fedramp-authorization-type"
                        role="error"
                        test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'authorization-type' and @value = ('fedramp-jab', 'fedramp-agency', 'fedramp-li-saas')]">
            A FedRAMP OSCAL SSP must have a FedRAMP authorization type.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:diagnostics>
        <sch:diagnostic doc:assertion="no-registry-values"
                        doc:context="/o:system-security-plan"
                        id="no-registry-values-diagnostic">The registry values at the path ' 
        <sch:value-of select="$registry-base-path" />' are not present, this configuration is invalid.</sch:diagnostic>
        <sch:diagnostic doc:assertion="no-security-sensitivity-level"
                        doc:context="/o:system-security-plan"
                        id="no-security-sensitivity-level-diagnostic">[Section C Check 1.a] No sensitivty level found, no more validation processing
                        can occur.</sch:diagnostic>
        <sch:diagnostic doc:assertion="invalid-security-sensitivity-level"
                        doc:context="/o:system-security-plan"
                        id="invalid-security-sensitivity-level-diagnostic">[Section C Check 1.a] 
        <sch:value-of select="./name()" />is an invalid value of ' 
        <sch:value-of select="lv:sensitivity-level(/)" />', not an allowed value of 
        <sch:value-of select="$corrections" />. No more validation processing can occur.</sch:diagnostic>
        <sch:diagnostic doc:assertion="incomplete-core-implemented-requirements"
                        doc:context="/o:system-security-plan/o:control-implementation"
                        id="incomplete-core-implemented-requirements-diagnostic">[Section C Check 3] This SSP has not implemented the most important 
        <sch:value-of select="count($core-missing)" />core 
        <sch:value-of select="
                    if (count($core-missing) = 1) then
                        ' control'
                    else
                        ' controls'" />: 
        <sch:value-of select="$core-missing/@id" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="incomplete-all-implemented-requirements"
                        doc:context="/o:system-security-plan/o:control-implementation"
                        id="incomplete-all-implemented-requirements-diagnostic">[Section C Check 2] This SSP has not implemented 
        <sch:value-of select="count($all-missing)" />
        <sch:value-of select="
                    if (count($all-missing) = 1) then
                        ' control'
                    else
                        ' controls'" />overall: 
        <sch:value-of select="$all-missing/@id" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="extraneous-implemented-requirements"
                        doc:context="/o:system-security-plan/o:control-implementation"
                        id="extraneous-implemented-requirements-diagnostic">[Section C Check 2] This SSP has implemented 
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
                        id="missing-response-points-diagnostic">[Section C Check 2] This SSP has not implemented a statement for each of the
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
                        id="invalid-component-match-diagnostic">[Section D Checks] Response statment 
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
                        id="incorrect-role-association-diagnostic">[Section C Check 2] This SSP has defined a responsible party with 
        <sch:value-of select="count($extraneous-roles)" />
        <sch:value-of select="
                    if (count($extraneous-roles) = 1) then
                        ' role'
                    else
                        ' roles'" />not defined in the role: 
        <sch:value-of select="$extraneous-roles/@role-id" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="incorrect-party-association"
                        doc:context="/o:system-security-plan/o:metadata"
                        id="incorrect-party-association-diagnostic">[Section C Check 2] This SSP has defined a responsible party with 
        <sch:value-of select="count($extraneous-parties)" />
        <sch:value-of select="
                    if (count($extraneous-parties) = 1) then
                        ' party'
                    else
                        ' parties'" />is not a defined party: 
        <sch:value-of select="$extraneous-parties/o:party-uuid" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="resource-uuid-required"
                        doc:context="/o:system-security-plan/o:back-matter/o:resource"
                        id="resource-uuid-required-diagnostic">[Section B Check ????] This SSP includes back-matter resource missing a
                        UUID.</sch:diagnostic>
        <sch:diagnostic doc:assertion="resource-rlink-required"
                        doc:context="/o:system-security-plan/o:back-matter/o:resource/o:rlink"
                        id="resource-rlink-required-diagnostic">[Section B Check ????] This SSP references back-matter resource: 
        <sch:value-of select="./@href" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="resource-base64-available-filenamne"
                        doc:context="/o:system-security-plan/o:back-matter/o:resource/o:base64"
                        id="resource-base64-available-filenamne-diagnostic">[Section B Check ????] This SSP has file name: 
        <sch:value-of select="./@filename" />.</sch:diagnostic>
        <sch:diagnostic doc:assertion="resource-base64-available-media-type"
                        doc:context="/o:system-security-plan/o:back-matter/o:resource/o:base64"
                        id="resource-base64-available-media-type-diagnostic">[Section B Check ????] This SSP has media type: 
        <sch:value-of select="./@media-type" />.</sch:diagnostic>
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
        <sch:value-of select="current()" />" which is not in the list of allowed media types. Allowed media types are 
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
                        doc:contect="oscal:by-component/oscal:link[@rel = ('policy', 'procedure')]"
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
                        id="has-pta-question-1-diagnostic">The PTA/PIA qualifying question #1 is missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-pta-question-2"
                        doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
                        id="has-pta-question-2-diagnostic">The PTA/PIA qualifying question #2 is missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-pta-question-3"
                        doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
                        id="has-pta-question-3-diagnostic">The PTA/PIA qualifying question #3 is missing.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-pta-question-4"
                        doc:context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
                        id="has-pta-question-4-diagnostic">The PTA/PIA qualifying question #4 is missing.</sch:diagnostic>
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
                        id="has-CMVP-validation-diagnostic">A FedRAMP OSCAL SSP does not declare one or more FIPS 140 validated
                        modules.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-CMVP-validation-reference"
                        doc:context="oscal:component[@type = 'validation'] | oscal:inventory-item[@type = 'validation']"
                        id="has-CMVP-validation-reference-diagnostic">A validation component or inventory-item lacks a validation-reference
                        property.</sch:diagnostic>
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
        <sch:diagnostic doc:assertion="inventory-item-has-allowed-scan-type"
                        doc:context="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'scan-type']"
                        id="inventory-item-has-allowed-scan-type-diagnostic">
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
                        id="inventory-item-has-uuid-diagnostic">This inventory-item must have a uuid attribute.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-asset-id"
                        doc:context="oscal:inventory-item"
                        id="has-asset-id-diagnostic">This inventory-item must have an asset-id property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-one-asset-id"
                        doc:context="oscal:inventory-item"
                        id="has-one-asset-id-diagnostic">This inventory-item must have only one asset-id property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-asset-type"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-asset-type-diagnostic">This inventory-item must have an asset-type property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-asset-type"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-one-asset-type-diagnostic">This inventory-item must have only one asset-type
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-virtual"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-virtual-diagnostic">This inventory-item must have virtual property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-virtual"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-one-virtual-diagnostic">This inventory-item must have only one virtual property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-public"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-public-diagnostic">This inventory-item must have public property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-public"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-one-public-diagnostic">This inventory-item must have only one public property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-scan-type"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-scan-type-diagnostic">This inventory-item must have scan-type property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-scan-type"
                        doc:context="oscal:inventory-item"
                        id="inventory-item-has-one-scan-type-diagnostic">This inventory-item must have only one scan-type property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-allows-authenticated-scan"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-allows-authenticated-scan-diagnostic">This inventory-item must have allows-authenticated-scan
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-allows-authenticated-scan"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-one-allows-authenticated-scan-diagnostic">This inventory-item must have only one
                        allows-authenticated-scan property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-baseline-configuration-name"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-baseline-configuration-name-diagnostic">This inventory-item must have baseline-configuration-name
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-baseline-configuration-name"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-one-baseline-configuration-name-diagnostic">This inventory-item must have only one
                        baseline-configuration-name property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-vendor-name"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-vendor-name-diagnostic">This inventory-item must have a vendor-name property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-vendor-name"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-one-vendor-name-diagnostic">This inventory-item must have only one vendor-name
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-hardware-model"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-hardware-model-diagnostic">This inventory-item must have a hardware-model property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-hardware-model"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-one-hardware-model-diagnostic">This inventory-item must have only one hardware-model
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-is-scanned"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-is-scanned-diagnostic">This inventory-item must have is-scanned property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-is-scanned"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]"
                        id="inventory-item-has-one-is-scanned-diagnostic">This inventory-item must have only one is-scanned
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-software-name"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('software', 'database')]"
                        id="inventory-item-has-software-name-diagnostic">This inventory-item must have software-name property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-software-name"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('software', 'database')]"
                        id="inventory-item-has-one-software-name-diagnostic">This inventory-item must have only one software-name
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-software-version"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('software', 'database')]"
                        id="inventory-item-has-software-version-diagnostic">This inventory-item must have software-version property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-software-version"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('software', 'database')]"
                        id="inventory-item-has-one-software-version-diagnostic">This inventory-item must have only one software-version
                        property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-function"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('software', 'database')]"
                        id="inventory-item-has-function-diagnostic">
        <sch:value-of select="name()" />" 
        <sch:value-of select="oscal:prop[@name = 'asset-type']/@value" />" must have function property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="inventory-item-has-one-function"
                        doc:context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('software', 'database')]"
                        id="inventory-item-has-one-function-diagnostic">
        <sch:value-of select="name()" />" 
        <sch:value-of select="oscal:prop[@name = 'asset-type']/@value" />" must have only one function property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="component-has-asset-type"
                        doc:context="/oscal:system-security-plan/oscal:system-implementation/oscal:component[(: a component referenced by any inventory-item :)@uuid = //oscal:inventory-item/oscal:implemented-component/@component-uuid]"
                        id="component-has-asset-type-diagnostic">
        <sch:value-of select="name()" />must have an asset-type property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="component-has-one-asset-type"
                        doc:context="/oscal:system-security-plan/oscal:system-implementation/oscal:component[(: a component referenced by any inventory-item :)@uuid = //oscal:inventory-item/oscal:implemented-component/@component-uuid]"
                        id="component-has-one-asset-type-diagnostic">
        <sch:value-of select="name()" />must have only one asset-type property.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-system-component"
                        doc:context="oscal:system-implementation"
                        id="has-system-component-diagnostic">This FedRAMP OSCAL SSP lacks a system component.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-system-id"
                        doc:context="oscal:system-characteristics"
                        id="has-system-id-diagnostic">This FedRAMP OSCAL SSP lacks a system-id.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-system-name"
                        doc:context="oscal:system-characteristics"
                        id="has-system-name-diagnostic">This FedRAMP OSCAL SSP lacks a system-name.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-system-name-short"
                        doc:context="oscal:system-characteristics"
                        id="has-system-name-short-diagnostic">This FedRAMP OSCAL SSP lacks a system-name-short.</sch:diagnostic>
        <sch:diagnostic doc:assertion="has-fedramp-authorization-type"
                        doc:context="oscal:system-characteristics"
                        id="has-fedramp-authorization-type-diagnostic">This FedRAMP OSCAL SSP lacks a FedRAMP authorization type.</sch:diagnostic>
    </sch:diagnostics>
</sch:schema>
