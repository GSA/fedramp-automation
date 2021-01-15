<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
    xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">

<sch:ns prefix="f"     uri="https://fedramp.gov/ns/oscal"/>
<sch:ns prefix="o"     uri="http://csrc.nist.gov/ns/oscal/1.0"/>
<sch:ns prefix="oscal" uri="http://csrc.nist.gov/ns/oscal/1.0"/>
<sch:ns prefix="lv"     uri="local-validations"/>

<sch:title>FedRAMP System Security Plan Validations</sch:title>

<xsl:output method="xml" indent="yes" encoding="UTF-8"/>

<xsl:param name="registry-href" select="'../../xml?select=*.xml'"/>

<xsl:function name="lv:if-empty-default">
    <xsl:param name="item"/>
    <xsl:param name="default"/>
    <xsl:choose>
        <!-- Atomic types, integers, strings, et cetera. -->
        <xsl:when test="$item instance of xs:untypedAtomic or
                        $item instance of xs:anyURI or
                        $item instance of xs:string or
                        $item instance of xs:QName or
                        $item instance of xs:boolean or
                        $item instance of xs:base64Binary or
                        $item instance of xs:hexBinary or
                        $item instance of xs:integer or
                        $item instance of xs:decimal or
                        $item instance of xs:float or
                        $item instance of xs:double or
                        $item instance of xs:date or
                        $item instance of xs:time or
                        $item instance of xs:dateTime or
                        $item instance of xs:dayTimeDuration or
                        $item instance of xs:yearMonthDuration or
                        $item instance of xs:duration or
                        $item instance of xs:gMonth or
                        $item instance of xs:gYear or
                        $item instance of xs:gYearMonth or
                        $item instance of xs:gDay or
                        $item instance of xs:gMonthDay">
            <xsl:value-of select="if ($item => string() => normalize-space() = '') then $default else $item"/>
        </xsl:when>
        <!-- Any node-kind that can be a sequence type -->
        <xsl:when test="$item instance of element() or
                        $item instance of attribute() or
                        $item instance of text() or
                        $item instance of node() or
                        $item instance of document-node() or
                        $item instance of comment() or
                        $item instance of processing-instruction()">
            <xsl:sequence  select="if ($item => normalize-space() => not()) then $default else $item"/>
        </xsl:when>
        <xsl:otherwise>
            <!-- 
                If no suitable type found, return empty sequence, as that can
                be falsey and cast to empty string or checked for `not(exist(.))`
                later.
             -->
            <xsl:sequence select="()"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:function>

<xsl:function name="lv:registry" as="item()*">
    <xsl:param name="href"/>
    <xsl:variable name="collection" select="$href => collection()"/>
    <xsl:choose>
        <xsl:when test="$collection => exists()">
            <xsl:sequence select="$collection"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:sequence>
                <fedramp-values xmlns="https://fedramp.gov/ns/oscal"/>
                <fedramp-threats xmlns="https://fedramp.gov/ns/oscal"/>
                <information-types/>
            </xsl:sequence>
        </xsl:otherwise>
    </xsl:choose>
</xsl:function>

<xsl:function name="lv:sensitivity-level" as="xs:string">
    <xsl:param name="context" as="node()*"/>
    <xsl:value-of select="$context//o:security-sensitivity-level"/>
</xsl:function>

<xsl:function name="lv:profile" as="document-node()*">
    <xsl:param name="level" />
    <xsl:variable name="profile-map">
        <!-- 
            OSCAL releases are tagged, but updates from OSCAL CI/CD pipeline to
            github.com/usnistgov/oscal-content are not. The 0f78f05 commit is the
            most recent triggered by the OSCAL 1.0.0-rc1 release. Change this url
            accordingly if you know what you are doing.
        -->
        <profile level="low" href="https://raw.githubusercontent.com/usnistgov/oscal-content/0f78f05f0953e64f37b5cb24e0522030d82fc1fa/fedramp.gov/xml/FedRAMP_LOW-baseline-resolved-profile_catalog.xml"/>
        <profile level="moderate" href="https://raw.githubusercontent.com/usnistgov/oscal-content/0f78f05f0953e64f37b5cb24e0522030d82fc1fa/fedramp.gov/xml/FedRAMP_MODERATE-baseline-resolved-profile_catalog.xml"/>
        <profile level="high" href="https://raw.githubusercontent.com/usnistgov/oscal-content/0f78f05f0953e64f37b5cb24e0522030d82fc1fa/fedramp.gov/xml/FedRAMP_HIGH-baseline-resolved-profile_catalog.xml"/>
    </xsl:variable>
    <xsl:variable name="href" select="$profile-map/profile[@level=$level]/@href"/>
    <xsl:sequence select="doc(resolve-uri($href))"/>
</xsl:function>

<xsl:function name="lv:correct">
    <xsl:param name="value-set" as="element()*"/>
    <xsl:param name="value" as="node()*"/>
    <xsl:variable name="values" select="$value-set/f:allowed-values/f:enum/@value"/>
    <xsl:choose>
        <!-- If allow-other is set, anything is valid. -->
        <xsl:when test="$value-set/f:allowed-values/@allow-other='no' and $value = $values"/>
        <xsl:otherwise>
            <xsl:value-of select="$values" separator=", "/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:function>

<xsl:function name="lv:analyze">
    <xsl:param name="value-set" as="element()*"/>
    <xsl:param name="element" as="element()*"/>
    <xsl:choose>
        <xsl:when test="$value-set/f:allowed-values/f:enum/@value">
            <xsl:sequence>
                <xsl:call-template name="analysis-template">
                    <xsl:with-param name="value-set" select="$value-set"/>
                    <xsl:with-param name="element" select="$element"/>
                </xsl:call-template>
            </xsl:sequence>
        </xsl:when>
        <xsl:otherwise>
            <xsl:message expand-text="yes">error</xsl:message>
            <xsl:sequence>
                <xsl:call-template name="analysis-template">
                    <xsl:with-param name="value-set" select="$value-set"/>
                    <xsl:with-param name="element" select="$element"/>
                    <xsl:with-param name="errors">
                        <error>value-set was malformed</error>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:sequence>
        </xsl:otherwise>
    </xsl:choose>
</xsl:function>

<xsl:function name="lv:report" as="xs:string">
    <xsl:param name="analysis" as="element()*"/>
    <xsl:variable name="results" as="xs:string">
        <xsl:call-template name="report-template">
            <xsl:with-param name="analysis" select="$analysis"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$results"/>
</xsl:function>

<xsl:template name="analysis-template" as="element()">
    <xsl:param name="value-set" as="element()*"/>
    <xsl:param name="element" as="element()*"/>
    <xsl:param name="errors" as="node()*"/>
    <xsl:variable name="ok-values" select="$value-set/f:allowed-values/f:enum/@value"/>
    <analysis>
        <errors>
            <xsl:if test="$errors"><xsl:sequence select="$errors"/></xsl:if>
        </errors>
        <reports
            name="{$value-set/@name}"
            formal-name="{$value-set/f:formal-name}"
            description="{$value-set/f:description}"
            count="{count($element)}">
            <xsl:for-each select="$ok-values">
                <xsl:variable name="match" select="$element[@value=current()]"/>
                <report value="{current()}" count="{count($match)}"> 
                </report>
            </xsl:for-each>
        </reports>
    </analysis>
</xsl:template>

<xsl:template name="report-template" as="xs:string">
    <xsl:param name="analysis" as="element()*"/>
    <xsl:value-of>
        There are <xsl:value-of select="$analysis/reports/@count"/>&#xA0;<xsl:value-of select="$analysis/reports/@formal-name"/>
        <xsl:choose>
            <xsl:when test="$analysis/reports/report"> items total, with </xsl:when>
            <xsl:otherwise> items total. </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="$analysis/reports/report">
            <xsl:if test="position() gt 0 and not(position() eq last())">
                <xsl:value-of select="current()/@count"/> set as <xsl:value-of select="current()/@value"/>, </xsl:if>
            <xsl:if test="position() gt 0 and position() eq last()"
                > and <xsl:value-of select="current()/@count"/> set as <xsl:value-of select="current()/@value"/>.</xsl:if>
            <xsl:sequence select="."/>
        </xsl:for-each>
        There are <xsl:value-of select="($analysis/reports/@count - sum($analysis/reports/report/@count))"/> invalid items.
        <xsl:if test="count($analysis/errors/error) > 0">
            <xsl:message expand-text="yes">hit error block</xsl:message>
            <xsl:for-each select="$analysis/errors/error">
                Also, <xsl:value-of select="current()/text()"/>, so analysis could be inaccurate or it completely failed.
            </xsl:for-each>    
        </xsl:if>
    </xsl:value-of>
</xsl:template>

<sch:pattern>
    <sch:rule context="/o:system-security-plan">
        <sch:let name="registry" value="$registry-href => lv:registry()"/>
        <sch:let name="ok-values" value="$registry/f:fedramp-values/f:value-set[@name='security-sensitivity-level']"/>
        <sch:let name="sensitivity-level" value="/ => lv:sensitivity-level() => lv:if-empty-default('')"/>
        <sch:let name="corrections" value="lv:correct($ok-values, $sensitivity-level)"/>
        <sch:assert role="fatal" id="no-registry-values" test="count($registry/f:fedramp-values/f:value-set) > 0"
            >The registry values at the path '<sch:value-of select="$registry-href"/>' are not present, this configuration is invalid.</sch:assert>
        <sch:assert role="fatal" organizational-id="section-c.1.a" id="no-security-sensitivity-level" test="$sensitivity-level != ''">[Section C Check 1.a] No sensitivty level found, no more validation processing can occur.</sch:assert>
        <sch:assert role="fatal" organizational-id="section-c.1.a" id="invalid-security-sensitivity-level" test="empty($ok-values) or not(exists($corrections))"
            >[Section C Check 1.a] <sch:value-of select="./name()"/> is an invalid value of '<sch:value-of select="lv:sensitivity-level(/)"/>', not an allowed value of <sch:value-of select="$corrections"/>. No more validation processing can occur.
        </sch:assert>
    </sch:rule>

    <sch:rule context="/o:system-security-plan/o:control-implementation">
    <sch:let name="registry" value="$registry-href => lv:registry()"/>
        <sch:let name="registry-ns" value="$registry/f:fedramp-values/f:namespace/f:ns/@ns"/>
        <sch:let name="sensitivity-level" value="/ => lv:sensitivity-level()"/>
        <sch:let name="ok-values" value="$registry/f:fedramp-values/f:value-set[@name='control-implementation-status']"/>
        <sch:let name="selected-profile" value="$sensitivity-level => lv:profile()"/>
        <sch:let name="required-controls" value="$selected-profile/*//o:control"/>
        <sch:let name="implemented" value="o:implemented-requirement"/>
        <sch:let name="all-missing" value="$required-controls[not(@id = $implemented/@control-id)]"/>
        <sch:let name="core-missing" value="$required-controls[o:prop[@name='CORE' and @ns=$registry-ns] and @id = $all-missing/@id]"/>
        <sch:let name="extraneous" value="$implemented[not(@control-id = $required-controls/@id)]"/>
        <sch:report role="positive" id="each-required-control-report" test="count($required-controls) > 0">The following <sch:value-of select="count($required-controls)"/><sch:value-of select="if (count($required-controls)=1) then ' control' else ' controls'"/> are required: <sch:value-of select="$required-controls/@id"/></sch:report>
        <sch:assert role="error" organizational-id="section-c.3" id="incomplete-core-implemented-requirements" test="not(exists($core-missing))">[Section C Check 3] This SSP has not implemented the most important <sch:value-of select="count($core-missing)"/> core<sch:value-of select="if (count($core-missing)=1) then ' control' else ' controls'"/>: <sch:value-of select="$core-missing/@id"/></sch:assert>
        <sch:assert role="warn" organizational-id="section-c.2" id="incomplete-all-implemented-requirements" test="not(exists($all-missing))">[Section C Check 2] This SSP has not implemented <sch:value-of select="count($all-missing)"/><sch:value-of select="if (count($all-missing)=1) then ' control' else ' controls'"/> overall: <sch:value-of select="$all-missing/@id"/></sch:assert>
        <sch:assert role="warn" organizational-id="section-c.2" id="extraneous-implemented-requirements" test="not(exists($extraneous))">[Section C Check 2] This SSP has implemented <sch:value-of select="count($extraneous)"/> extraneous<sch:value-of select="if (count($extraneous)=1) then ' control' else ' controls'"/> not needed given the selected profile: <sch:value-of select="$extraneous/@control-id"/></sch:assert>
        <sch:let name="results" value="$ok-values => lv:analyze(//o:implemented-requirement/o:annotation[@name='implementation-status'])"/>
        <sch:let name="total" value="$results/reports/@count"/>
        <sch:report role="positive" id="control-implemented-requirements-stats" test="count($results/errors/error) = 0"><sch:value-of select="$results => lv:report() => normalize-space()"/></sch:report>
    </sch:rule>

    <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement">
        <sch:let name="sensitivity-level" value="/ => lv:sensitivity-level() => lv:if-empty-default('')"/>
        <sch:let name="selected-profile" value="$sensitivity-level => lv:profile()"/>
        <sch:let name="registry" value="$registry-href => lv:registry()"/>
        <sch:let name="registry-ns" value="$registry/f:fedramp-values/f:namespace/f:ns/@ns"/>
        <sch:let name="status" value="./o:annotation[@name='implementation-status']/@value"/>
        <sch:let name="corrections" value="lv:correct($registry/f:fedramp-values/f:value-set[@name='control-implementation-status'], $status)"/>
        <sch:let name="required-response-points" value="$selected-profile/o:catalog//o:part[@name='item']"/>
        <sch:let name="implemented" value="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement"/>
        <sch:let name="missing" value="$required-response-points[not(@id = $implemented/@statement-id)]"/>
        <sch:assert role="error" organizational-id="section-c.2" id="invalid-implementation-status" test="not(exists($corrections))">[Section C Check 2] Invalid status '<sch:value-of select="$status"/>' for <sch:value-of select="./@control-id"/>, must be <sch:value-of select="$corrections"/></sch:assert>
        <sch:report role="positive" id="implemented-response-points" test="exists($implemented)"
            >[Section C Check 2] This SSP has implemented a statement for each of the following lettered response points for required controls: <sch:value-of select="$implemented/@statement-id"/>.</sch:report>
        <sch:assert role="error" organizational-id="section-c.2" id="missing-response-points" test="not(exists($missing))"
            >[Section C Check 2] This SSP has not implemented a statement for each of the following lettered response points for required controls: <sch:value-of select="$missing/@id"/>.</sch:assert>
    </sch:rule>

    <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement">
        <sch:let name="required-components-count" value="1"/>
        <sch:let name="required-length" value="20"/>
        <sch:let name="components-count" value="./o:by-component => count()"/>
        <sch:let name="remarks" value="./o:remarks => normalize-space()"/>
        <sch:let name="remarks-length" value="$remarks => string-length()"/>
        <sch:assert role="warning" id="missing-response-components" test="$components-count >= $required-components-count"
            >Response statements for <sch:value-of select="./@statement-id"/> must have at least <sch:value-of select="$required-components-count"/><sch:value-of select="if (count($components-count)=1) then ' component' else ' components'"/> with a description. There are <sch:value-of select="$components-count"/>.</sch:assert>
    </sch:rule>

    <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:description">
        <sch:assert role="warning" id="extraneous-response-description" test=". => empty()"
            >Response statement <sch:value-of select="../@statement-id"/> has a description not within a component. That was previously allowed, but not recommended. It will soon be syntactically invalid and deprecated.</sch:assert>
    </sch:rule>

    <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:remarks">
        <sch:assert role="warning" id="extraneous-response-remarks" test=". => empty()"
            >Response statement <sch:value-of select="../@statement-id"/> has remarks not within a component. That was previously allowed, but not recommended. It will soon be syntactically invalid and deprecated.</sch:assert>
    </sch:rule>

    <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component">
        <sch:let name="component-ref" value="./@component-uuid"/>
        <sch:assert role="warning" organizational-id="section-d" id="invalid-component-match" test="/o:system-security-plan/o:system-implementation/o:component[@uuid = $component-ref] => exists()"
            >[Section D Checks] Response statment <sch:value-of select="../@statement-id"/> with component reference UUID '<sch:value-of select="$component-ref"/>' is not in the system implementation inventory, and cannot be used to define a control.</sch:assert>
        <sch:assert role="error" organizational-id="section-d" id="missing-component-description" test="./o:description => exists()"
            >[Section D Checks] Response statement <sch:value-of select="../@statement-id"/> has a component, but that component is missing a required description node.</sch:assert>"
    </sch:rule>

    <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:description">
        <sch:let name="required-length" value="20"/>
        <sch:let name="description" value=". => normalize-space()"/>
        <sch:let name="description-length" value="$description => string-length()"/>
        <sch:assert role="error" organizational-id="section-d" id="incomplete-response-description" test="$description-length >= $required-length"
            >[Section D Checks] Response statement component description for <sch:value-of select="../../@statement-id"/> is too short with <sch:value-of select="$description-length"/> characters. It must be <sch:value-of select="$required-length"/> characters long.</sch:assert>
    </sch:rule>

    <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:remarks">
        <sch:let name="required-length" value="20"/>
        <sch:let name="remarks" value=". => normalize-space()"/>
        <sch:let name="remarks-length" value="$remarks => string-length()"/>
        <sch:assert role="warning" organizational-id="section-d" id="incomplete-response-remarks" test="$remarks-length >= $required-length"
            >[Section D Checks] Response statement component remarks for <sch:value-of select="../../@statement-id"/> is too short with <sch:value-of select="$remarks-length"/> characters. It must be <sch:value-of select="$required-length"/> characters long.</sch:assert>
    </sch:rule>

    <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement">
        <sch:let name="required-components-count" value="1"/>
        <sch:let name="required-length" value="20"/>
        <sch:let name="components-count" value="./o:by-component => count()"/>
        <sch:let name="remarks" value="./o:remarks => normalize-space()"/>
        <sch:let name="remarks-length" value="$remarks => string-length()"/>
        <sch:assert role="warning" organizational-id="section-d" id="missing-response-components" test="$components-count >= $required-components-count"
            >[Section D Checks] Response statements for <sch:value-of select="./@statement-id"/> must have at least <sch:value-of select="$required-components-count"/><sch:value-of select="if (count($components-count)=1) then ' component' else ' components'"/> with a description. There are <sch:value-of select="$components-count"/>.</sch:assert>
    </sch:rule>

    <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:description">
        <sch:assert role="warning" organizational-id="section-d" id="extraneous-response-description" test=". => empty()"
            >[Section D Checks] Response statement <sch:value-of select="../@statement-id"/> has a description not within a component. That was previously allowed, but not recommended. It will soon be syntactically invalid and deprecated.</sch:assert>
    </sch:rule>

    <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:remarks">
        <sch:assert role="warning" organizational-id="section-d" id="extraneous-response-remarks" test=". => empty()"
            >[Section D Checks] Response statement <sch:value-of select="../@statement-id"/> has remarks not within a component. That was previously allowed, but not recommended. It will soon be syntactically invalid and deprecated.</sch:assert>
    </sch:rule>

    <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component">
        <sch:let name="component-ref" value="./@component-uuid"/>
        <sch:assert role="warning" organizational-id="section-d" id="invalid-component-match" test="/o:system-security-plan/o:system-implementation/o:component[@uuid = $component-ref] => exists()"
            >[Section D Checks] Response statment <sch:value-of select="../@statement-id"/> with component reference UUID '<sch:value-of select="$component-ref"/>' is not in the system implementation inventory, and cannot be used to define a control.</sch:assert>
        <sch:assert role="error" organizational-id="section-d" id="missing-component-description" test="./o:description => exists()"
            >[Section D Checks] Response statement <sch:value-of select="../@statement-id"/> has a component, but that component is missing a required description node.</sch:assert>"
    </sch:rule>

    <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:description">
        <sch:let name="required-length" value="20"/>
        <sch:let name="description" value=". => normalize-space()"/>
        <sch:let name="description-length" value="$description => string-length()"/>
        <sch:assert role="error" organizational-id="section-d" id="incomplete-response-description" test="$description-length >= $required-length"
            >[Section D Checks] Response statement component description for <sch:value-of select="../../@statement-id"/> is too short with <sch:value-of select="$description-length"/> characters. It must be <sch:value-of select="$required-length"/> characters long.</sch:assert>
    </sch:rule>

    <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:remarks">
        <sch:let name="required-length" value="20"/>
        <sch:let name="remarks" value=". => normalize-space()"/>
        <sch:let name="remarks-length" value="$remarks => string-length()"/>
        <sch:assert role="warning" organizational-id="section-d" id="incomplete-response-remarks" test="$remarks-length >= $required-length"
            >[Section D Checks] Response statement component remarks for <sch:value-of select="../../@statement-id"/> is too short with <sch:value-of select="$remarks-length"/> characters. It must be <sch:value-of select="$required-length"/> characters long.</sch:assert>
    </sch:rule>

 
    <sch:rule context="/o:system-security-plan/o:metadata">
        <sch:let name="parties" value="o:party"/> 
        <sch:let name="roles" value="o:role"/>
        <sch:let name="responsible-parties" value="./o:responsible-party"/>
        <sch:let name="extraneous-roles" value="$responsible-parties[not(@role-id = $roles/@id)]"/>
        <sch:let name="extraneous-parties" value="$responsible-parties[not(o:party-uuid = $parties/@uuid)]"/>

        <sch:assert organizational-id="section-c.6" id="incorrect-role-association" test="not(exists($extraneous-roles))">[Section C Check 2] This SSP has defined a responsible party with <sch:value-of select="count($extraneous-roles)"/> <sch:value-of select="if (count($extraneous-roles)=1) then ' role' else ' roles'"/> not defined in the role: <sch:value-of select="$extraneous-roles/@role-id"/></sch:assert>
        <sch:assert organizational-id="section-c.6" id="incorrect-party-association" test="not(exists($extraneous-parties))">[Section C Check 2] This SSP has defined a responsible party with <sch:value-of select="count($extraneous-parties)"/> <sch:value-of select="if (count($extraneous-parties)=1) then ' party' else ' parties'"/> is not a defined party: <sch:value-of select="$extraneous-parties/o:party-uuid"/></sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
