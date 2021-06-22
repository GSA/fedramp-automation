<sch:schema queryBinding="xslt2"
            xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
            xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
            xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            >
    <sch:ns prefix="f"
            uri="https://fedramp.gov/ns/oscal" />
    <sch:ns prefix="o"
            uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns prefix="oscal"
            uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns
        prefix="fedramp"
        uri="https://fedramp.gov/ns/oscal" />
    <sch:ns prefix="lv"
            uri="local-validations" />
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
             value="doc(concat($registry-base-path, '/fedramp_values.xml')) |
                              doc(concat($registry-base-path, '/fedramp_threats.xml')) |
                              doc(concat($registry-base-path, '/information-types.xml'))" />
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
                <xsl:value-of select="if ($item =&gt; string() =&gt; normalize-space() = '') then $default else $item" />
            </xsl:when>
            <!-- Any node-kind that can be a sequence type -->
            <xsl:when test="$item instance of element() or
                        $item instance of attribute() or
                        $item instance of text() or
                        $item instance of node() or
                        $item instance of document-node() or
                        $item instance of comment() or
                        $item instance of processing-instruction()">
                <xsl:sequence select="if ($item =&gt; normalize-space() =&gt; not()) then $default else $item" />
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
                      select="$profile-map/profile[@level=$level]/@href" />
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
            <xsl:when test="$value-set/f:allowed-values/@allow-other='no' and $value = $values" />
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
                                  select="$element[@value=current()]" />
                    <report count="{count($match)}"
                            value="{current()}"></report>
                </xsl:for-each>
            </reports>
        </analysis>
    </xsl:template>
    <xsl:template as="xs:string"
                  name="report-template">
        <xsl:param as="element()*"
                   name="analysis" />
        <xsl:value-of>There are 
        <xsl:value-of select="$analysis/reports/@count" />&#xA0; 
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
                     value="$registry/f:fedramp-values/f:value-set[@name='security-sensitivity-level']" />
            <sch:let name="sensitivity-level"
                     value="/ =&gt; lv:sensitivity-level() =&gt; lv:if-empty-default('')" />
            <sch:let name="corrections"
                     value="lv:correct($ok-values, $sensitivity-level)" />
            <sch:assert id="no-registry-values"
                        role="fatal"
                        test="count($registry/f:fedramp-values/f:value-set) &gt; 0">The registry values at the path ' 
            <sch:value-of select="$registry-base-path" />' are not present, this configuration is invalid.</sch:assert>
            <sch:assert id="no-security-sensitivity-level"
                        doc:organizational-id="section-c.1.a"
                        role="fatal"
                        test="$sensitivity-level != ''">[Section C Check 1.a] No sensitivty level found, no more validation processing can
                        occur.</sch:assert>
            <sch:assert id="invalid-security-sensitivity-level"
                        doc:organizational-id="section-c.1.a"
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
                     value="$registry/f:fedramp-values/f:value-set[@name='control-implementation-status']" />
            <sch:let name="selected-profile"
                     value="$sensitivity-level =&gt; lv:profile()" />
            <sch:let name="required-controls"
                     value="$selected-profile/*//o:control" />
            <sch:let name="implemented"
                     value="o:implemented-requirement" />
            <sch:let name="all-missing"
                     value="$required-controls[not(@id = $implemented/@control-id)]" />
            <sch:let name="core-missing"
                     value="$required-controls[o:prop[@name='CORE' and @ns=$registry-ns] and @id = $all-missing/@id]" />
            <sch:let name="extraneous"
                     value="$implemented[not(@control-id = $required-controls/@id)]" />
            <sch:report id="each-required-control-report"
                        role="positive"
                        test="count($required-controls) &gt; 0">The following 
            <sch:value-of select="count($required-controls)" />
            <sch:value-of select="if (count($required-controls)=1) then ' control' else ' controls'" />are required: 
            <sch:value-of select="$required-controls/@id" /></sch:report>
            <sch:assert id="incomplete-core-implemented-requirements"
                        doc:organizational-id="section-c.3"
                        role="error"
                        test="not(exists($core-missing))">[Section C Check 3] This SSP has not implemented the most important 
            <sch:value-of select="count($core-missing)" />core 
            <sch:value-of select="if (count($core-missing)=1) then ' control' else ' controls'" />: 
            <sch:value-of select="$core-missing/@id" /></sch:assert>
            <sch:assert id="incomplete-all-implemented-requirements"
                        doc:organizational-id="section-c.2"
                        role="warn"
                        test="not(exists($all-missing))">[Section C Check 2] This SSP has not implemented 
            <sch:value-of select="count($all-missing)" />
            <sch:value-of select="if (count($all-missing)=1) then ' control' else ' controls'" />overall: 
            <sch:value-of select="$all-missing/@id" /></sch:assert>
            <sch:assert id="extraneous-implemented-requirements"
                        doc:organizational-id="section-c.2"
                        role="warn"
                        test="not(exists($extraneous))">[Section C Check 2] This SSP has implemented 
            <sch:value-of select="count($extraneous)" />extraneous 
            <sch:value-of select="if (count($extraneous)=1) then ' control' else ' controls'" />not needed given the selected profile: 
            <sch:value-of select="$extraneous/@control-id" /></sch:assert>
            <sch:let name="results"
                     value="$ok-values =&gt; lv:analyze(//o:implemented-requirement/o:prop[@name='implementation-status'])" />
            <sch:let name="total"
                     value="$results/reports/@count" />
            <sch:report id="control-implemented-requirements-stats"
                        role="positive"
                        test="count($results/errors/error) = 0">
                <sch:value-of select="$results =&gt; lv:report() =&gt; normalize-space()" />
            </sch:report>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement">
            <sch:let name="sensitivity-level"
                     value="/ =&gt; lv:sensitivity-level() =&gt; lv:if-empty-default('')" />
            <sch:let name="selected-profile"
                     value="$sensitivity-level =&gt; lv:profile()" />
            <sch:let name="registry-ns"
                     value="$registry/f:fedramp-values/f:namespace/f:ns/@ns" />
            <sch:let name="status"
                     value="./o:prop[@name='implementation-status']/@value" />
            <sch:let name="corrections"
                     value="lv:correct($registry/f:fedramp-values/f:value-set[@name='control-implementation-status'], $status)" />
            <sch:let name="required-response-points"
                     value="$selected-profile/o:catalog//o:part[@name='item']" />
            <sch:let name="implemented"
                     value="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement" />
            <sch:let name="missing"
                     value="$required-response-points[not(@id = $implemented/@statement-id)]" />
            <sch:assert id="invalid-implementation-status"
                        doc:organizational-id="section-c.2"
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
            <sch:assert id="missing-response-points"
                        doc:organizational-id="section-c.2"
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
            <sch:assert id="missing-response-components"
                        doc:organizational-id="section-d"
                        role="warning"
                        test="$components-count &gt;= $required-components-count">[Section D Checks] Response statements for 
            <sch:value-of select="./@statement-id" />must have at least 
            <sch:value-of select="$required-components-count" />
            <sch:value-of select="if (count($components-count)=1) then ' component' else ' components'" />with a description. There are 
            <sch:value-of select="$components-count" />.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:description">
            <sch:assert id="extraneous-response-description"
                        doc:organizational-id="section-d"
                        role="warning"
                        test=". =&gt; empty()">[Section D Checks] Response statement 
            <sch:value-of select="../@statement-id" />has a description not within a component. That was previously allowed, but not recommended. It
            will soon be syntactically invalid and deprecated.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:remarks">
            <sch:assert id="extraneous-response-remarks"
                        doc:organizational-id="section-d"
                        role="warning"
                        test=". =&gt; empty()">[Section D Checks] Response statement 
            <sch:value-of select="../@statement-id" />has remarks not within a component. That was previously allowed, but not recommended. It will
            soon be syntactically invalid and deprecated.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component">
        <sch:let name="component-ref"
                 value="./@component-uuid" />
        <sch:assert id="invalid-component-match"
                    doc:organizational-id="section-d"
                    role="warning"
                    test="/o:system-security-plan/o:system-implementation/o:component[@uuid = $component-ref] =&gt; exists()">[Section D Checks]
                    Response statment 
        <sch:value-of select="../@statement-id" />with component reference UUID ' 
        <sch:value-of select="$component-ref" />' is not in the system implementation inventory, and cannot be used to define a control.</sch:assert>
        <sch:assert id="missing-component-description"
                    doc:organizational-id="section-d"
                    role="error"
                    test="./o:description =&gt; exists()">[Section D Checks] Response statement 
        <sch:value-of select="../@statement-id" />has a component, but that component is missing a required description
        node.</sch:assert></sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:description">
            <sch:let name="required-length"
                     value="20" />
            <sch:let name="description"
                     value=". =&gt; normalize-space()" />
            <sch:let name="description-length"
                     value="$description =&gt; string-length()" />
            <sch:assert id="incomplete-response-description"
                        doc:organizational-id="section-d"
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
            <sch:assert id="incomplete-response-remarks"
                        doc:organizational-id="section-d"
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
            <sch:assert id="incorrect-role-association"
                        doc:organizational-id="section-c.6"
                        test="not(exists($extraneous-roles))">[Section C Check 2] This SSP has defined a responsible party with 
            <sch:value-of select="count($extraneous-roles)" />
            <sch:value-of select="if (count($extraneous-roles)=1) then ' role' else ' roles'" />not defined in the role: 
            <sch:value-of select="$extraneous-roles/@role-id" /></sch:assert>
            <sch:assert id="incorrect-party-association"
                        doc:organizational-id="section-c.6"
                        test="not(exists($extraneous-parties))">[Section C Check 2] This SSP has defined a responsible party with 
            <sch:value-of select="count($extraneous-parties)" />
            <sch:value-of select="if (count($extraneous-parties)=1) then ' party' else ' parties'" />is not a defined party: 
            <sch:value-of select="$extraneous-parties/o:party-uuid" /></sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:back-matter/o:resource">
            <sch:assert id="resource-uuid-required"
                        doc:organizational-id="section-b.?????"
                        test="./@uuid">[Section B Check ????] This SSP includes back-matter resource missing a UUID</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:back-matter/o:resource/o:rlink">
            <sch:assert id="resource-rlink-required"
                        doc:organizational-id="section-b.?????"
                        test="doc-available(./@href)">[Section B Check ????] This SSP references back-matter resource: 
            <sch:value-of select="./@href" /></sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:back-matter/o:resource/o:base64">
            <sch:let name="filename"
                     value="@filename" />
            <sch:let name="media-type"
                     value="@media-type" />
            <sch:assert id="resource-base64-available-filenamne"
                        doc:organizational-id="section-b.?????"
                        test="./@filename">[Section B Check ????] This SSP has file name: 
            <sch:value-of select="./@filename" /></sch:assert>
            <sch:assert id="resource-base64-available-media-type"
                        doc:organizational-id="section-b.?????"
                        test="./@filename">[Section B Check ????] This SSP has media type: 
            <sch:value-of select="./@media-type" /></sch:assert>
        </sch:rule>
    </sch:pattern>
        <sch:pattern>

        <sch:title>Basic resource constraints</sch:title>

        <sch:let
            name="attachment-types"
            value="doc('file:../../xml/fedramp_values.xml')//fedramp:value-set[@name = 'attachment-type']//fedramp:enum/@value" />
        <sch:rule
            context="oscal:resource">
            <!-- create a "path" to the context -->
            <sch:let
                name="path"
                value="concat(string-join(ancestor-or-self::* ! name(), '/'), ' ', @uuid, ' &#34;', oscal:title, '&#34;')" />
            <!-- the following assertion recapitulates the XML Schema constraint -->
            <sch:assert
                id="resource-has-uuid"
                role="error"
                test="@uuid">A &lt;<sch:name />&gt; element must have a uuid attribute</sch:assert>
            <sch:assert
                id="resource-has-title"
                role="warning"
                test="oscal:title">&lt; <sch:name /> uuid=" <sch:value-of
                    select="@uuid" />"&gt; SHOULD have a title</sch:assert>
            <sch:assert
                id="resource-has-rlink"
                role="error"
                test="oscal:rlink">&lt; <sch:name /> uuid=" <sch:value-of
                    select="@uuid" />"&gt; must have an &lt;rlink&gt; element</sch:assert>
            <sch:assert
                diagnostics="resource-is-referenced-diagnostic"
                id="resource-is-referenced"
                role="info"
                test="@uuid = (//@href[matches(., '^#')] ! substring-after(., '#'))">
                <sch:value-of
                    select="$path" /> is referenced from within the document.</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:back-matter/oscal:resource/oscal:prop[@name = 'type']">
            <sch:assert
                id="attachment-type-is-valid"
                test="@value = $attachment-types">Found unknown attachment type « <sch:value-of
                    select="@value" />» in <sch:value-of
                    select="
                        if (parent::oscal:resource/oscal:title) then
                            concat('&#34;', parent::oscal:resource/oscal:title, '&#34;')
                        else
                            'untitled'" />resource</sch:assert>
        </sch:rule>

        <sch:rule
            context="oscal:back-matter/oscal:resource/oscal:rlink">
            <sch:assert
                id="rlink-has-href"
                role="error"
                test="@href">A &lt; <sch:name />&gt; element must have an href attribute</sch:assert>
            <!-- Both doc-avail() and unparsed-text-available() are failing on arbitrary hrefs -->
            <!--<sch:assert test="unparsed-text-available(@href)">the &lt;<sch:name/>&gt; element href attribute refers to a non-existent
                document</sch:assert>-->
            <!--<sch:assert id="rlink-has-media-type"
                role="warning"
                test="$WARNING and @media-type">the &lt;<sch:name/>&gt; element SHOULD have a media-type attribute</sch:assert>-->
        </sch:rule>

        <sch:rule
            context="@media-type"
            role="error">

            <sch:let
                name="media-types"
                value="doc('file:../../xml/fedramp_values.xml')//fedramp:value-set[@name = 'media-type']//fedramp:enum/@value" />
            <sch:report
                role="information"
                test="false()">There are <sch:value-of
                    select="count($media-types)" /> media types.</sch:report>
            <sch:assert
                diagnostics="has-allowed-media-type-diagnostic"
                id="has-allowed-media-type"
                role="error"
                test="current() = $media-types">A media-type attribute must have an allowed value.</sch:assert>

        </sch:rule>

    </sch:pattern>
    <sch:pattern>
        <sch:title>base64 attachments</sch:title>
        <sch:rule
            context="oscal:back-matter/oscal:resource">
            <sch:assert
                diagnostics="resource-has-base64-diagnostic "
                id="resource-has-base64"
                role="warning"
                test="oscal:base64">A resource should have a base64 element.</sch:assert>
            <doc:original-assertion>
                <sch:name /> should have a base64 element.</doc:original-assertion>
            <sch:assert
                diagnostics="resource-base64-cardinality-diagnostic "
                id="resource-base64-cardinality"
                role="error"
                test="not(oscal:base64[2])">A resource must have only one base64 element.</sch:assert>
            <doc:original-assertion>
                <sch:name /> must not have more than one base64 element.</doc:original-assertion>
        </sch:rule>
        <sch:rule
            context="oscal:back-matter/oscal:resource/oscal:base64">
            <sch:assert
                diagnostics="base64-has-filename-diagnostic "
                id="base64-has-filename"
                role="error"
                test="@filename">A base64 element has a filename attribute</sch:assert>
            <doc:original-assertion>
                <sch:name /> must have filename attribute.</doc:original-assertion>
            <sch:assert
                diagnostics="base64-has-media-type-diagnostic "
                id="base64-has-media-type"
                role="error"
                test="@media-type">A base64 element has a media-type attribute</sch:assert>
            <doc:original-assertion>
                <sch:name /> must have media-type attribute.</doc:original-assertion>
            <!-- TODO: add IANA media type check using https://www.iana.org/assignments/media-types/media-types.xml-->
            <!-- TODO: decide whether to use the IANA resource directly, or cache a local copy -->
            <!-- TODO: determine what media types will be acceptable for FedRAMP SSP submissions -->
            <sch:assert
                diagnostics="base64-has-content-diagnostic "
                id="base64-has-content"
                role="error"
                test="matches(normalize-space(), '^[A-Za-z0-9+/]+$')">A base64 element has content.</sch:assert>
            <doc:original-assertion>base64 element must have text content.</doc:original-assertion>
            <!-- FYI: http://expath.org/spec/binary#decode-string handles base64 but Saxon-PE or higher is necessary -->
        </sch:rule>
    </sch:pattern>
    <sch:pattern>
        <sch:title>Constraints for specific attachments</sch:title>
        <sch:rule
            context="oscal:back-matter"
            see="https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf">
            <sch:assert
                id="has-fedramp-acronyms"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-acronyms']]">A FedRAMP
                OSCAL SSP must attach the FedRAMP Master Acronym and Glossary.</sch:assert>
            <sch:assert
                doc:attachment="§15 Attachment 12"
                id="has-fedramp-citations"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-citations']]">A FedRAMP
                OSCAL SSP must attach the FedRAMP Applicable Laws and Regulations.</sch:assert>
            <sch:assert
                id="has-fedramp-logo"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-logo']]">A FedRAMP OSCAL
                SSP must attach the FedRAMP Logo.</sch:assert>
            <sch:assert
                doc:attachment="§15 Attachment 2"
                id="has-user-guide"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'user-guide']]">A FedRAMP OSCAL
                SSP must attach a User Guide.</sch:assert>
            <sch:assert
                doc:attachment="§15 Attachment 5"
                id="has-rules-of-behavior"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'rules-of-behavior']]">A FedRAMP
                OSCAL SSP must attach Rules of Behavior.</sch:assert>
            <sch:assert
                doc:attachment="§15 Attachment 6"
                id="has-information-system-contingency-plan"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'information-system-contingency-plan']]">
                A FedRAMP OSCAL SSP must attach a Contingency Plan</sch:assert>
            <sch:assert
                doc:attachment="§15 Attachment 7"
                id="has-configuration-management-plan"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'configuration-management-plan']]">
                A FedRAMP OSCAL SSP must attach a Configuration Management Plan.</sch:assert>
            <sch:assert
                doc:attachment="§15 Attachment 8"
                id="has-incident-response-plan"
                role="error"
                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'incident-response-plan']]"> A
                FedRAMP OSCAL SSP must attach an Incident Response Plan.</sch:assert>
            <sch:assert
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
        <sch:rule
            context="oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')]"
            doc:attachment="§15 Attachment 1"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 48">

            <sch:assert
                id="has-policy-link"
                role="error"
                test="descendant::oscal:by-component/oscal:link[@rel = 'policy']">
                <sch:value-of
                    select="local-name()" />
                <sch:value-of
                    select="@control-id" />
                <sch:span
                    class="message"> lacks policy reference(s) (via by-component link)</sch:span>
            </sch:assert>

            <sch:let
                name="policy-hrefs"
                value="distinct-values(descendant::oscal:by-component/oscal:link[@rel = 'policy']/@href ! substring-after(., '#'))" />

            <sch:assert
                id="has-policy-attachment-resource"
                role="error"
                test="
                    every $ref in $policy-hrefs
                        satisfies exists(//oscal:resource[oscal:prop[@name = 'type' and @value = 'policy']][@uuid = $ref])">
                <sch:value-of
                    select="local-name()" />
                <sch:value-of
                    select="@control-id" />
                <sch:span
                    class="message"> lacks policy attachment resource(s) </sch:span>
                <sch:value-of
                    select="string-join($policy-hrefs, ', ')" />
            </sch:assert>

            <!-- TODO: ensure resource has an rlink -->

            <sch:assert
                id="has-procedure-link"
                role="error"
                test="descendant::oscal:by-component/oscal:link[@rel = 'procedure']">
                <sch:value-of
                    select="local-name()" />
                <sch:value-of
                    select="@control-id" />
                <sch:span
                    class="message"> lacks procedure reference(s) (via by-component link)</sch:span>
            </sch:assert>

            <sch:let
                name="procedure-hrefs"
                value="distinct-values(descendant::oscal:by-component/oscal:link[@rel = 'procedure']/@href ! substring-after(., '#'))" />

            <sch:assert
                id="has-procedure-attachment-resource"
                role="error"
                test="
                    (: targets of links exist in the document :)
                    every $ref in $procedure-hrefs
                        satisfies exists(//oscal:resource[oscal:prop[@name = 'type' and @value = 'procedure']][@uuid = $ref])">
                <sch:value-of
                    select="local-name()" />
                <sch:value-of
                    select="@control-id" />
                <sch:span
                    class="message"> lacks procedure attachment resource(s) </sch:span>
                <sch:value-of
                    select="string-join($procedure-hrefs, ', ')" />
            </sch:assert>

            <!-- TODO: ensure resource has an rlink -->

        </sch:rule>

        <sch:rule
            context="oscal:by-component/oscal:link[@rel = ('policy', 'procedure')]">

            <sch:p>Each SP 800-53 control family must have unique policy and unique procedure documents</sch:p>

            <sch:let
                name="ir"
                value="ancestor::oscal:implemented-requirement" />

            <sch:report
                id="has-reuse"
                role="error"
                test="
                    (: the current @href is in :)
                    @href = (: all controls except the current :) (//oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')] except $ir) (: all their @hrefs :)/descendant::oscal:by-component/oscal:link[@rel = 'policy']/@href"><sch:value-of
                    select="@rel" /> document <sch:value-of
                    select="substring-after(@href, '#')" /> is used in other controls (i.e., it is not unique to implemented-requirement <sch:value-of
                    select="$ir/@control-id" />)</sch:report>

        </sch:rule>

    </sch:pattern>
    <sch:pattern>

        <sch:title>A FedRAMP OSCAL SSP must specify a Privacy Point of Contact</sch:title>

        <sch:rule
            context="oscal:metadata"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 49">

            <sch:assert
                id="has-privacy-poc-role"
                role="error"
                test="/oscal:system-security-plan/oscal:metadata/oscal:role[@id = 'privacy-poc']">A FedRAMP OSCAL SSP must incorporate a Privacy Point
                of Contact role</sch:assert>

            <sch:assert
                id="has-responsible-party-privacy-poc-role"
                role="error"
                test="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']">A FedRAMP OSCAL SSP must declare a
                Privacy Point of Contact responsible party role reference</sch:assert>

            <sch:assert
                id="has-responsible-privacy-poc-party-uuid"
                role="error"
                test="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']/oscal:party-uuid">A FedRAMP OSCAL
                SSP must declare a Privacy Point of Contact responsible party role reference identifying the party by UUID</sch:assert>

            <sch:let
                name="poc-uuid"
                value="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']/oscal:party-uuid" />

            <sch:assert
                id="has-privacy-poc"
                role="error"
                test="/oscal:system-security-plan/oscal:metadata/oscal:party[@uuid = $poc-uuid]">A FedRAMP OSCAL SSP must define a Privacy Point of
                Contact</sch:assert>

        </sch:rule>

    </sch:pattern>
    <sch:pattern>

        <sch:title>A FedRAMP OSCAL SSP may need to incorporate a PIA and possibly a SORN</sch:title>

        <!-- The "PTA" appears to be just a few questions, not an attachment -->

        <sch:rule
            context="oscal:prop[@name = 'privacy-sensitive'] | oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and matches(@name, '^pta-\d$')]"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 51">

            <sch:assert
                id="has-correct-yes-or-no-answer"
                test="current()/@value = ('yes', 'no')">incorrect value: should be "yes" or "no"</sch:assert>

        </sch:rule>

        <sch:rule
            context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 51">

            <sch:assert
                id="has-privacy-sensitive-designation"
                role="error"
                test="oscal:prop[@name = 'privacy-sensitive']">Lacks privacy-sensitive designation</sch:assert>

            <sch:assert
                id="has-pta-question-1"
                role="error"
                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-1']">Missing PTA/PIA qualifying question
                #1.</sch:assert>

            <sch:assert
                id="has-pta-question-2"
                role="error"
                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-2']">Missing PTA/PIA qualifying question
                #2.</sch:assert>

            <sch:assert
                id="has-pta-question-3"
                role="error"
                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-3']">Missing PTA/PIA qualifying question
                #3.</sch:assert>

            <sch:assert
                id="has-pta-question-4"
                role="error"
                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-4']">Missing PTA/PIA qualifying question
                #4.</sch:assert>

            <sch:assert
                id="has-all-pta-questions"
                test="
                    every $name in ('pta-1', 'pta-2', 'pta-3', 'pta-4')
                        satisfies exists(oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = $name])">One
                or more of the four PTA questions is missing</sch:assert>

            <sch:assert
                id="has-correct-pta-question-cardinality"
                test="
                    not(some $name in ('pta-1', 'pta-2', 'pta-3', 'pta-4')
                        satisfies exists(oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = $name][2]))">One
                or more of the four PTA questions is a duplicate</sch:assert>

        </sch:rule>

        <sch:rule
            context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 51">

            <sch:assert
                id="has-sorn"
                role="error"
                test="/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-4' and @value = 'yes'] and oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'sorn-id' and @value != '']">Missing
                SORN ID</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:back-matter"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 51">

            <sch:assert
                id="has-pia"
                role="error"
                test="
                    every $answer in //oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and matches(@name, '^pta-\d$')]
                        satisfies $answer = 'no' or oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'pia']] (: a PIA is attached :)">This
                FedRAMP OSCAL SSP must incorporate a Privacy Impact Analysis</sch:assert>

        </sch:rule>
    </sch:pattern>

    <sch:pattern
        see="https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf page 12">

        <sch:title>Security Objectives Categorization (FIPS 199)</sch:title>

        <sch:rule
            context="oscal:system-characteristics">

            <!-- These should also be asserted in XML Schema -->

            <sch:assert
                id="has-security-sensitivity-level"
                role="error"
                test="oscal:security-sensitivity-level">A FedRAMP OSCAL SSP must specify a FIPS 199 categorization.</sch:assert>

            <sch:assert
                id="has-security-impact-level"
                role="error"
                test="oscal:security-impact-level">A FedRAMP OSCAL SSP must specify a security impact level.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:security-sensitivity-level">

            <!--<sch:let
                name="security-sensitivity-levels"
                value="doc('file:../../xml/fedramp_values.xml')//fedramp:value-set[@name = 'security-sensitivity-level']//fedramp:enum/@value" />-->
            <sch:let
                name="security-sensitivity-levels"
                value="('Low', 'Moderate', 'High')" />

            <sch:assert
                diagnostics="has-allowed-security-sensitivity-level-diagnostic"
                id="has-allowed-security-sensitivity-level"
                role="error"
                test="current() = $security-sensitivity-levels">A FedRAMP OSCAL SSP must specify an allowed security-sensitivity-level.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:security-impact-level">

            <!-- These should also be asserted in XML Schema -->

            <sch:assert
                id="has-security-objective-confidentiality"
                role="error"
                test="oscal:security-objective-confidentiality">A FedRAMP OSCAL SSP must specify a confidentiality security objective.</sch:assert>

            <sch:assert
                id="has-security-objective-integrity"
                role="error"
                test="oscal:security-objective-integrity">A FedRAMP OSCAL SSP must specify an integrity security objective.</sch:assert>

            <sch:assert
                id="has-security-objective-availability"
                role="error"
                test="oscal:security-objective-availability">A FedRAMP OSCAL SSP must specify an availability security objective.</sch:assert>


        </sch:rule>

        <sch:rule
            context="oscal:security-objective-confidentiality | oscal:security-objective-integrity | oscal:security-objective-availability">

            <!--<sch:let
                name="security-objective-levels"
                value="doc('file:../../xml/fedramp_values.xml')//fedramp:value-set[@name = 'security-objective-level']//fedramp:enum/@value" />-->
            <sch:let
                name="security-objective-levels"
                value="('Low', 'Moderate', 'High')" />
            <sch:report
                role="information"
                test="false()">There are <sch:value-of
                    select="count($security-objective-levels)" /> security-objective-levels: <sch:value-of
                    select="string-join($security-objective-levels, ' ∨ ')" /></sch:report>

            <sch:assert
                diagnostics="has-allowed-security-objective-value-diagnostic"
                id="has-allowed-security-objective-value"
                role="error"
                test="current() = $security-objective-levels">A FedRAMP OSCAL SSP must specify an allowed security objective value.</sch:assert>

        </sch:rule>
    </sch:pattern>

    <sch:pattern
        see="https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf page 11">

        <sch:title>SP 800-60v2r1 Information Types:</sch:title>

        <sch:rule
            context="oscal:system-information">

            <sch:assert
                id="system-information-has-information-type"
                role="error"
                test="oscal:information-type">A FedRAMP OSCAL SSP must specify at least one information-type.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:information-type">

            <sch:assert
                id="information-type-has-title"
                role="error"
                test="oscal:title">A FedRAMP OSCAL SSP information-type must have a title.</sch:assert>

            <sch:assert
                id="information-type-has-description"
                role="error"
                test="oscal:description">A FedRAMP OSCAL SSP information-type must have a description.</sch:assert>

            <sch:assert
                id="information-type-has-categorization"
                role="error"
                test="oscal:categorization">A FedRAMP OSCAL SSP information-type must have at least one categorization.</sch:assert>

            <sch:assert
                id="information-type-has-confidentiality-impact"
                role="error"
                test="oscal:confidentiality-impact">A FedRAMP OSCAL SSP information-type must have a confidentiality-impact.</sch:assert>

            <sch:assert
                id="information-type-has-integrity-impact"
                role="error"
                test="oscal:integrity-impact">A FedRAMP OSCAL SSP information-type must have a integrity-impact.</sch:assert>

            <sch:assert
                id="information-type-has-availability-impact"
                role="error"
                test="oscal:availability-impact">A FedRAMP OSCAL SSP information-type must have a availability-impact.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:categorization">

            <sch:assert
                id="categorization-has-system-attribute"
                role="error"
                test="@system">A FedRAMP OSCAL SSP information-type categorization must have a system attribute.</sch:assert>

            <sch:assert
                id="categorization-has-correct-system-attribute"
                role="error"
                test="@system = 'https://doi.org/10.6028/NIST.SP.800-60v2r1'">A FedRAMP OSCAL SSP information-type categorization must have a correct
                system attribute. The correct value is "https://doi.org/10.6028/NIST.SP.800-60v2r1".</sch:assert>

            <sch:assert
                id="categorization-has-information-type-id"
                role="error"
                test="oscal:information-type-id">A FedRAMP OSCAL SSP information-type categorization must have at least one
                information-type-id.</sch:assert>

            <!-- FIXME: https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf page 11 has schema error -->
            <!--        confidentiality-impact, integrity-impact, availability-impact are children of <information-type> -->

        </sch:rule>

        <sch:rule
            context="oscal:information-type-id">

            <sch:p>Information Types</sch:p>

            <sch:let
                name="information-types"
                value="doc('file:../../xml/information-types.xml')//fedramp:information-type/@id" />

            <!-- note the variant namespace and associated prefix -->
            <sch:assert
                id="has-allowed-information-type-id"
                test="current()[. = $information-types]">A FedRAMP OSCAL SSP information-type-id must have a SP 800-60v2r1 identifier.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:confidentiality-impact | oscal:integrity-impact | oscal:availability-impact">

            <sch:assert
                id="cia-impact-has-base"
                role="error"
                test="oscal:base">A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact must have a base
                element.</sch:assert>

            <sch:assert
                id="cia-impact-has-selected"
                role="error"
                test="oscal:selected">A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact must have a selected
                element.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:base | oscal:selected">

            <sch:let
                name="fips-levels"
                value="('fips-199-low', 'fips-199-moderate', 'fips-199-high')" />
            <sch:assert
                id="cia-impact-has-approved-fips-categorization"
                role="error"
                test=". = $fips-levels">A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact base or select
                element must have an approved value.</sch:assert>
        </sch:rule>

    </sch:pattern>

    <sch:pattern>

        <sch:let
            name="fedramp-values"
            value="doc('file:../../xml/fedramp_values.xml')" />

        <sch:title>A FedRAMP OSCAL SSP must specify system inventory items</sch:title>

        <sch:rule
            context="/oscal:system-security-plan/oscal:system-implementation"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans pp52-60">

            <sch:p>A FedRAMP OSCAL SSP must populate the system inventory</sch:p>

            <!-- FIXME: determine if essential items are present -->
            <doc:rule>A FedRAMP OSCAL SSP must incorporate inventory-item elements</doc:rule>

            <sch:assert
                diagnostics="has-inventory-items-diagnostic"
                id="has-inventory-items"
                role="error"
                test="oscal:inventory-item">A FedRAMP OSCAL SSP must incorporate inventory-item elements.</sch:assert>

        </sch:rule>

        <sch:title>FedRAMP SSP value constraints</sch:title>

        <sch:rule
            context="oscal:prop[@name = 'asset-id']">
            <sch:p>asset-id property is unique</sch:p>
            <sch:assert
                diagnostics="has-unique-asset-id-diagnostic"
                id="has-unique-asset-id"
                role="error"
                test="count(//oscal:prop[@name = 'asset-id'][@value = current()/@value]) = 1">asset-id must be unique.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:prop[@name = 'asset-type']">
            <sch:p>asset-type property has an allowed value</sch:p>
            <sch:let
                name="asset-types"
                value="$fedramp-values//fedramp:value-set[@name = 'asset-type']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-asset-type-diagnostic"
                id="has-allowed-asset-type"
                role="warning"
                test="@value = $asset-types">asset-type property has an allowed value.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:prop[@name = 'virtual']">
            <sch:p>virtual property has an allowed value</sch:p>
            <sch:let
                name="virtuals"
                value="$fedramp-values//fedramp:value-set[@name = 'virtual']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-virtual-diagnostic"
                id="has-allowed-virtual"
                role="error"
                test="@value = $virtuals">virtual property has an allowed value.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:prop[@name = 'public']">
            <sch:p>public property has an allowed value</sch:p>
            <sch:let
                name="publics"
                value="$fedramp-values//fedramp:value-set[@name = 'public']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-public-diagnostic"
                id="has-allowed-public"
                role="error"
                test="@value = $publics">public property has an allowed value.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:prop[@name = 'allows-authenticated-scan']">
            <sch:p>allows-authenticated-scan property has an allowed value</sch:p>
            <sch:let
                name="allows-authenticated-scans"
                value="$fedramp-values//fedramp:value-set[@name = 'allows-authenticated-scan']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-allows-authenticated-scan-diagnostic"
                id="has-allowed-allows-authenticated-scan"
                role="error"
                test="@value = $allows-authenticated-scans">allows-authenticated-scan property has an allowed value.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:prop[@name = 'is-scanned']">
            <sch:p>is-scanned property has an allowed value</sch:p>
            <sch:let
                name="is-scanneds"
                value="$fedramp-values//fedramp:value-set[@name = 'is-scanned']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="has-allowed-is-scanned-diagnostic"
                id="has-allowed-is-scanned"
                role="error"
                test="@value = $is-scanneds">is-scanned property has an allowed value.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'scan-type']">
            <sch:p>scan-type property has an allowed value</sch:p>
            <sch:let
                name="scan-types"
                value="$fedramp-values//fedramp:value-set[@name = 'scan-type']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="inventory-item-has-allowed-scan-type-diagnostic"
                id="inventory-item-has-allowed-scan-type"
                role="error"
                test="@value = $scan-types">scan-type property has an allowed value.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:component">
            <sch:p>component has an allowed type</sch:p>
            <sch:let
                name="component-types"
                value="$fedramp-values//fedramp:value-set[@name = 'component-type']//fedramp:enum/@value" />
            <sch:assert
                diagnostics="component-has-allowed-type-diagnostic"
                id="component-has-allowed-type"
                role="error"
                test="@type = $component-types">component has an allowed type.</sch:assert>

        </sch:rule>

        <sch:title>FedRAMP OSCAL SSP inventory items</sch:title>

        <sch:rule
            context="oscal:inventory-item"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans pp52-60">

            <sch:p>All FedRAMP OSCAL SSP inventory-item elements</sch:p>

            <sch:p>inventory-item has a uuid</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-uuid-diagnostic"
                id="inventory-item-has-uuid"
                role="error"
                test="@uuid">inventory-item has a uuid.</sch:assert>

            <sch:p>inventory-item has an asset-id</sch:p>
            <sch:assert
                diagnostics="has-asset-id-diagnostic"
                id="has-asset-id"
                role="error"
                test="oscal:prop[@name = 'asset-id']">inventory-item has an asset-id.</sch:assert>

            <sch:p>inventory-item has only one asset-id</sch:p>
            <sch:assert
                diagnostics="has-one-asset-id-diagnostic"
                id="has-one-asset-id"
                role="error"
                test="count(oscal:prop[@name = 'asset-id']) = 1">inventory-item has only one asset-id.</sch:assert>

            <sch:p>inventory-item has an asset-type</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-asset-type-diagnostic"
                id="inventory-item-has-asset-type"
                role="error"
                test="oscal:prop[@name = 'asset-type']">inventory-item has an asset-type.</sch:assert>

            <sch:p>inventory-item has only one asset-type</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-one-asset-type-diagnostic"
                id="inventory-item-has-one-asset-type"
                role="error"
                test="count(oscal:prop[@name = 'asset-type']) = 1">inventory-item has only one asset-type.</sch:assert>

            <sch:p>inventory-item has virtual property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-virtual-diagnostic"
                id="inventory-item-has-virtual"
                role="error"
                test="oscal:prop[@name = 'virtual']">inventory-item has virtual property.</sch:assert>

            <sch:p>inventory-item has only one virtual property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-one-virtual-diagnostic"
                id="inventory-item-has-one-virtual"
                role="error"
                test="count(oscal:prop[@name = 'virtual']) = 1">inventory-item has only one virtual property.</sch:assert>

            <sch:p>inventory-item has public property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-public-diagnostic"
                id="inventory-item-has-public"
                role="error"
                test="oscal:prop[@name = 'public']">inventory-item has public property.</sch:assert>

            <sch:p>inventory-item has only one public property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-one-public-diagnostic"
                id="inventory-item-has-one-public"
                role="error"
                test="count(oscal:prop[@name = 'public']) = 1">inventory-item has only one public property.</sch:assert>

            <sch:p>inventory-item has scan-type property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-scan-type-diagnostic"
                id="inventory-item-has-scan-type"
                role="error"
                test="oscal:prop[@name = 'scan-type']">inventory-item has scan-type property.</sch:assert>

            <sch:p>inventory-item has only one scan-type property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-one-scan-type-diagnostic"
                id="inventory-item-has-one-scan-type"
                role="error"
                test="count(oscal:prop[@name = 'scan-type']) = 1">inventory-item has only one scan-type property.</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:inventory-item[oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')]]">

            <sch:p>"infrastructure" inventory-item has allows-authenticated-scan</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-allows-authenticated-scan-diagnostic"
                id="inventory-item-has-allows-authenticated-scan"
                role="error"
                test="oscal:prop[@name = 'allows-authenticated-scan']">"infrastructure" inventory-item has allows-authenticated-scan.</sch:assert>

            <sch:p>"infrastructure" inventory-item has only one allows-authenticated-scan property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-one-allows-authenticated-scan-diagnostic"
                id="inventory-item-has-one-allows-authenticated-scan"
                role="error"
                test="count(oscal:prop[@name = 'allows-authenticated-scan']) = 1">inventory-item has only one one-allows-authenticated-scan
                property.</sch:assert>

            <sch:p>"infrastructure" inventory-item has baseline-configuration-name</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-baseline-configuration-name-diagnostic"
                id="inventory-item-has-baseline-configuration-name"
                role="error"
                test="oscal:prop[@name = 'baseline-configuration-name']">"infrastructure" inventory-item has baseline-configuration-name.</sch:assert>

            <sch:p>"infrastructure" inventory-item has only one baseline-configuration-name</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-one-baseline-configuration-name-diagnostic"
                id="inventory-item-has-one-baseline-configuration-name"
                role="error"
                test="count(oscal:prop[@name = 'baseline-configuration-name']) = 1">"infrastructure" inventory-item has only one
                baseline-configuration-name.</sch:assert>

            <sch:p>"infrastructure" inventory-item has a vendor-name property</sch:p>
            <!-- FIXME: Documentation says vendor name is in FedRAMP @ns -->
            <sch:assert
                diagnostics="inventory-item-has-vendor-name-diagnostic"
                id="inventory-item-has-vendor-name"
                role="error"
                test="oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'vendor-name']">"infrastructure" inventory-item has a
                vendor-name property.</sch:assert>

            <sch:p>"infrastructure" inventory-item has a vendor-name property</sch:p>
            <!-- FIXME: Documentation says vendor name is in FedRAMP @ns -->
            <sch:assert
                diagnostics="inventory-item-has-one-vendor-name-diagnostic"
                id="inventory-item-has-one-vendor-name"
                role="error"
                test="not(oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'vendor-name'][2])">"infrastructure" inventory-item has
                only one vendor-name property.</sch:assert>

            <sch:p>"infrastructure" inventory-item has a hardware-model property</sch:p>
            <!-- FIXME: perversely, hardware-model is not in FedRAMP @ns -->
            <sch:assert
                diagnostics="inventory-item-has-hardware-model-diagnostic"
                id="inventory-item-has-hardware-model"
                role="error"
                test="oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'hardware-model']">"infrastructure" inventory-item has a
                hardware-model property.</sch:assert>

            <sch:p>"infrastructure" inventory-item has one hardware-model property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-one-hardware-model-diagnostic"
                id="inventory-item-has-one-hardware-model"
                role="error"
                test="not(oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'hardware-model'][2])">"infrastructure" inventory-item has
                only one hardware-model property.</sch:assert>

            <sch:p>"infrastructure" inventory-item has is-scanned property</sch:p>
            <sch:assert
                diagnostics="inventory-item-has-is-scanned-diagnostic"
                id="inventory-item-has-is-scanned"
                role="error"
                test="oscal:prop[@name = 'is-scanned']">"infrastructure" inventory-item has is-scanned property.</sch:assert>

            <sch:assert
                diagnostics="inventory-item-has-one-is-scanned-diagnostic"
                id="inventory-item-has-one-is-scanned"
                role="error"
                test="not(oscal:prop[@name = 'is-scanned'][2])">"infrastructure" inventory-item has only one is-scanned property.</sch:assert>

            <sch:p>has a scan-type property</sch:p>
            <!-- FIXME: DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 53 has typo -->
        </sch:rule>

        <sch:rule
            context="oscal:inventory-item[oscal:prop[@name = 'asset-type']/@value = ('software', 'database')]">
            <!-- FIXME: Software/Database Vendor -->

            <sch:p>"software or database" inventory-item has software-name property</sch:p>
            <!-- FIXME: vague asset categories -->

            <sch:assert
                diagnostics="inventory-item-has-software-name-diagnostic"
                id="inventory-item-has-software-name"
                role="error"
                test="oscal:prop[@name = 'software-name']">"software or database" inventory-item has software-name property.</sch:assert>

            <sch:assert
                diagnostics="inventory-item-has-one-software-name-diagnostic"
                id="inventory-item-has-one-software-name"
                role="error"
                test="not(oscal:prop[@name = 'software-name'][2])">"software or database" inventory-item has software-name property.</sch:assert>

            <sch:p>"software or database" inventory-item has software-version property</sch:p>
            <!-- FIXME: vague asset categories -->

            <sch:assert
                diagnostics="inventory-item-has-software-version-diagnostic"
                id="inventory-item-has-software-version"
                role="error"
                test="oscal:prop[@name = 'software-version']">"software or database" inventory-item has software-version property.</sch:assert>

            <sch:assert
                diagnostics="inventory-item-has-one-software-version-diagnostic"
                id="inventory-item-has-one-software-version"
                role="error"
                test="not(oscal:prop[@name = 'software-version'][2])">"software or database" inventory-item has one software-version
                property.</sch:assert>

            <sch:p>"software or database" inventory-item has function</sch:p>
            <!-- FIXME: vague asset categories -->
            <sch:assert
                diagnostics="inventory-item-has-function-diagnostic"
                id="inventory-item-has-function"
                role="error"
                test="oscal:prop[@name = 'function']">"software or database" inventory-item has function property.</sch:assert>

            <sch:assert
                diagnostics="inventory-item-has-one-function-diagnostic"
                id="inventory-item-has-one-function"
                role="error"
                test="not(oscal:prop[@name = 'function'][2])">"software or database" inventory-item has one function property.</sch:assert>

        </sch:rule>
        <sch:title>FedRAMP OSCAL SSP components</sch:title>

        <sch:rule
            context="/oscal:system-security-plan/oscal:system-implementation/oscal:component[(: a component referenced by any inventory-item :)@uuid = //oscal:inventory-item/oscal:implemented-component/@component-uuid]"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 54">

            <sch:p>A FedRAMP OSCAL SSP component</sch:p>

            <sch:assert
                diagnostics="component-has-asset-type-diagnostic"
                id="component-has-asset-type"
                role="error"
                test="oscal:prop[@name = 'asset-type']">component has an asset type.</sch:assert>

            <sch:assert
                diagnostics="component-has-one-asset-type-diagnostic"
                id="component-has-one-asset-type"
                role="error"
                test="oscal:prop[@name = 'asset-type']">component has one asset type.</sch:assert>

        </sch:rule>
    </sch:pattern>
    <sch:pattern>

        <sch:rule
            context="oscal:system-implementation"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 62">

            <sch:p>There must be a component that represents the entire system itself. It should be the only component with the component-type set to
                "system".</sch:p>

            <sch:assert
                id="has-system-component"
                role="error"
                test="oscal:component[@type = 'system']">Missing system component</sch:assert>

            <!-- required @uuid is defined in XML Schema -->

        </sch:rule>


        <sch:rule
            context="oscal:system-characteristics"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 9">

            <sch:p>Information System Name, Title, and FedRAMP Identifier</sch:p>

            <sch:assert
                id="has-system-id"
                role="error"
                test="oscal:system-id[@identifier-type = 'https://fedramp.gov/']">Missing system-id</sch:assert>

            <sch:assert
                id="has-system-name"
                role="error"
                test="oscal:system-name">Missing system-name</sch:assert>

            <sch:assert
                id="has-system-name-short"
                role="error"
                test="oscal:system-name-short">Missing system-name-short</sch:assert>

        </sch:rule>

        <sch:rule
            context="oscal:system-characteristics"
            see="DRAFT Guide to OSCAL-based FedRAMP System Security Plans page 10">

            <sch:p>Information System Categorization and FedRAMP Baselines</sch:p>

            <sch:assert
                id="has-fedramp-authorization-type"
                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'authorization-type' and @value = ('fedramp-jab', 'fedramp-agency', 'fedramp-li-saas')]">Missing
                FedRAMP authorization type</sch:assert>

        </sch:rule>

    </sch:pattern>
    <sch:diagnostics>

        <sch:diagnostic
            id="context-diagnostic">XPath: The context for this error is <sch:value-of
                select="replace(path(), 'Q\{[^\}]+\}', '')" />
        </sch:diagnostic>

        <sch:diagnostic
            doc:assertion="resource-is-referenced"
            id="resource-is-referenced-diagnostic"><sch:value-of
                select="$path" /> SHOULD optionally have a reference within the document (but does not)</sch:diagnostic>

        <sch:diagnostic
            id="has-allowed-media-type-diagnostic">This <sch:value-of
                select="name(parent::node())" /> element has a media-type="<sch:value-of
                select="current()" />" which is not in the list of allowed media types. Allowed media types are <sch:value-of
                select="string-join($media-types, ' ∨ ')" />.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="resource-has-base64"
            id="resource-has-base64-diagnostic"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">
            <sch:value-of
                select="name()" /> should have a base64 element.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="resource-base64-cardinality"
            id="resource-base64-cardinality-diagnostic"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">
            <sch:value-of
                select="name()" /> must not have more than one base64 element.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="base64-has-filename"
            id="base64-has-filename-diagnostic"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">
            <sch:value-of
                select="name()" /> must have a filename attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="base64-has-media-type"
            id="base64-has-media-type-diagnostic"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">
            <sch:value-of
                select="name()" /> must have a media-type attribute.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="base64-has-content"
            id="base64-has-content-diagnostic"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0"><sch:value-of
                select="name()" /> must have content.</sch:diagnostic>

        <sch:diagnostic
            id="has-allowed-security-sensitivity-level-diagnostic">Invalid <sch:value-of
                select="name()" /> "<sch:value-of
                select="." />". It must have one of the following <sch:value-of
                select="count($security-sensitivity-levels)" /> values: <sch:value-of
                select="string-join($security-sensitivity-levels, ' ∨ ')" />. </sch:diagnostic>
        <sch:diagnostic
            id="has-allowed-security-objective-value-diagnostic">Invalid <sch:value-of
                select="name()" /> "<sch:value-of
                select="." />". It must have one of the following <sch:value-of
                select="count($security-objective-levels)" /> values: <sch:value-of
                select="string-join($security-objective-levels, ' ∨ ')" />. </sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-security-sensitivity-level"
            doc:context="oscal:system-characteristics"
            id="has-security-sensitivity-level-diagnostic">This FedRAMP OSCAL SSP lacks a FIPS 199 categorization.</sch:diagnostic>
        <sch:diagnostic
            doc:assertion="has-security-impact-level"
            doc:context="oscal:system-characteristics"
            id="has-security-impact-level-diagnostic">This FedRAMP OSCAL SSP lacks a security impact level.</sch:diagnostic>
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
            doc:assertion="has-inventory-items"
            id="has-inventory-items-diagnostic">A FedRAMP OSCAL SSP must incorporate inventory-item elements.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-unique-asset-id"
            id="has-unique-asset-id-diagnostic">This asset id <sch:value-of
                select="@asset-id" /> is not unique. An asset id must be unique within the scope of a FedRAMP OSCAL SSP document.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-allowed-asset-type"
            id="has-allowed-asset-type-diagnostic">
            <sch:value-of
                select="name()" /> should have a FedRAMP asset type <sch:value-of
                select="string-join($asset-types, ' ∨ ')" /> (not "<sch:value-of
                select="@value" />").</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-allowed-virtual"
            id="has-allowed-virtual-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed value <sch:value-of
                select="string-join($virtuals, ' ∨ ')" /> (not "<sch:value-of
                select="@value" />").</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-allowed-public"
            id="has-allowed-public-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed value <sch:value-of
                select="string-join($publics, ' ∨ ')" /> (not "<sch:value-of
                select="@value" />").</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-allowed-allows-authenticated-scan"
            id="has-allowed-allows-authenticated-scan-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed value <sch:value-of
                select="string-join($allows-authenticated-scans, ' ∨ ')" /> (not "<sch:value-of
                select="@value" />").</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-allowed-is-scanned"
            id="has-allowed-is-scanned-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed value <sch:value-of
                select="string-join($is-scanneds, ' ∨ ')" /> (not "<sch:value-of
                select="@value" />").</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-allowed-scan-type"
            id="inventory-item-has-allowed-scan-type-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed value <sch:value-of
                select="string-join($scan-types, ' ∨ ')" /> (not "<sch:value-of
                select="@value" />").</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="component-has-allowed-type"
            id="component-has-allowed-type-diagnostic">
            <sch:value-of
                select="name()" /> must have an allowed component type <sch:value-of
                select="string-join($component-types, ' ∨ ')" /> (not "<sch:value-of
                select="@type" />").</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-uuid"
            id="inventory-item-has-uuid-diagnostic">
            <sch:value-of
                select="name()" /> must have a uuid attribute.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-asset-id"
            id="has-asset-id-diagnostic">
            <sch:value-of
                select="name()" /> must have an asset-id property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="has-one-asset-id"
            id="has-one-asset-id-diagnostic">
            <sch:value-of
                select="name()" /> must have only one asset-id property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-asset-type"
            id="inventory-item-has-asset-type-diagnostic">
            <sch:value-of
                select="name()" /> must have an asset-type property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-asset-type"
            id="inventory-item-has-one-asset-type-diagnostic">
            <sch:value-of
                select="name()" /> must have only one asset-type property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-virtual"
            id="inventory-item-has-virtual-diagnostic">
            <sch:value-of
                select="name()" /> must have virtual property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-virtual"
            id="inventory-item-has-one-virtual-diagnostic">
            <sch:value-of
                select="name()" /> must have only one virtual property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-public"
            id="inventory-item-has-public-diagnostic">
            <sch:value-of
                select="name()" /> must have public property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-public"
            id="inventory-item-has-one-public-diagnostic">
            <sch:value-of
                select="name()" /> must have only one public property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-scan-type"
            id="inventory-item-has-scan-type-diagnostic">
            <sch:value-of
                select="name()" /> must have scan-type property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-scan-type"
            id="inventory-item-has-one-scan-type-diagnostic">
            <sch:value-of
                select="name()" /> must have only one scan-type property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-allows-authenticated-scan"
            id="inventory-item-has-allows-authenticated-scan-diagnostic">
            <sch:value-of
                select="name()" /> must have allows-authenticated-scan property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-allows-authenticated-scan"
            id="inventory-item-has-one-allows-authenticated-scan-diagnostic">
            <sch:value-of
                select="name()" /> must have only one allows-authenticated-scan property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-baseline-configuration-name"
            id="inventory-item-has-baseline-configuration-name-diagnostic">
            <sch:value-of
                select="name()" /> must have baseline-configuration-name property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-baseline-configuration-name"
            id="inventory-item-has-one-baseline-configuration-name-diagnostic">
            <sch:value-of
                select="name()" /> must have only one baseline-configuration-name property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-vendor-name"
            id="inventory-item-has-vendor-name-diagnostic">
            <sch:value-of
                select="name()" /> must have a vendor-name property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-vendor-name"
            id="inventory-item-has-one-vendor-name-diagnostic">
            <sch:value-of
                select="name()" /> must have only one vendor-name property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-hardware-model"
            id="inventory-item-has-hardware-model-diagnostic">
            <sch:value-of
                select="name()" /> must have a hardware-model property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-hardware-model"
            id="inventory-item-has-one-hardware-model-diagnostic">
            <sch:value-of
                select="name()" /> must have only one hardware-model property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-is-scanned"
            id="inventory-item-has-is-scanned-diagnostic">
            <sch:value-of
                select="name()" /> must have is-scanned property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-is-scanned"
            id="inventory-item-has-one-is-scanned-diagnostic">
            <sch:value-of
                select="name()" /> must have only one is-scanned property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-software-name"
            id="inventory-item-has-software-name-diagnostic">
            <sch:value-of
                select="name()" /> must have software-name property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-software-name"
            id="inventory-item-has-one-software-name-diagnostic">
            <sch:value-of
                select="name()" /> must have only one software-name property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-software-version"
            id="inventory-item-has-software-version-diagnostic">
            <sch:value-of
                select="name()" /> must have software-version property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-software-version"
            id="inventory-item-has-one-software-version-diagnostic">
            <sch:value-of
                select="name()" /> must have only one software-version property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-function"
            id="inventory-item-has-function-diagnostic">
            <sch:value-of
                select="name()" /> "<sch:value-of
                select="oscal:prop[@name = 'asset-type']/@value" />" must have function property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="inventory-item-has-one-function"
            id="inventory-item-has-one-function-diagnostic">
            <sch:value-of
                select="name()" /> "<sch:value-of
                select="oscal:prop[@name = 'asset-type']/@value" />" must have only one function property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="component-has-asset-type"
            id="component-has-asset-type-diagnostic">
            <sch:value-of
                select="name()" /> must have an asset-type property.</sch:diagnostic>

        <sch:diagnostic
            doc:assertion="component-has-one-asset-type"
            id="component-has-one-asset-type-diagnostic">
            <sch:value-of
                select="name()" /> must have only one asset-type property.</sch:diagnostic>

    </sch:diagnostics>

</sch:schema>
