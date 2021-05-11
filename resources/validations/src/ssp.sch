<sch:schema queryBinding="xslt2"
            xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
            xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
    <sch:ns prefix="f"
            uri="https://fedramp.gov/ns/oscal" />
    <sch:ns prefix="o"
            uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns prefix="oscal"
            uri="http://csrc.nist.gov/ns/oscal/1.0" />
    <sch:ns prefix="lv"
            uri="local-validations" />
    <sch:title>FedRAMP System Security Plan Validations</sch:title>
    <xsl:output encoding="UTF-8"
                indent="yes"
                method="xml" />
    <xsl:param name="registry-href"
               select="'../../xml?select=*.xml'" />
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
        <xsl:param name="href" />
        <xsl:variable name="collection"
                      select="$href =&gt; collection()" />
        <xsl:choose>
            <xsl:when test="$collection =&gt; exists()">
                <xsl:sequence select="$collection" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence>
                    <fedramp-values xmlns="https://fedramp.gov/ns/oscal" />
                    <fedramp-threats xmlns="https://fedramp.gov/ns/oscal" />
                    <information-types />
                </xsl:sequence>
            </xsl:otherwise>
        </xsl:choose>
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
            <profile href="https://raw.githubusercontent.com/usnistgov/oscal-content/0f78f05f0953e64f37b5cb24e0522030d82fc1fa/fedramp.gov/xml/FedRAMP_LOW-baseline-resolved-profile_catalog.xml"
                     level="low" />
            <profile href="https://raw.githubusercontent.com/usnistgov/oscal-content/0f78f05f0953e64f37b5cb24e0522030d82fc1fa/fedramp.gov/xml/FedRAMP_MODERATE-baseline-resolved-profile_catalog.xml"
                     level="moderate" />
            <profile href="https://raw.githubusercontent.com/usnistgov/oscal-content/0f78f05f0953e64f37b5cb24e0522030d82fc1fa/fedramp.gov/xml/FedRAMP_HIGH-baseline-resolved-profile_catalog.xml"
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
            <sch:let name="registry"
                     value="$registry-href =&gt; lv:registry()" />
            <sch:let name="ok-values"
                     value="$registry/f:fedramp-values/f:value-set[@name='security-sensitivity-level']" />
            <sch:let name="sensitivity-level"
                     value="/ =&gt; lv:sensitivity-level() =&gt; lv:if-empty-default('')" />
            <sch:let name="corrections"
                     value="lv:correct($ok-values, $sensitivity-level)" />
            <sch:assert id="no-registry-values"
                        role="fatal"
                        test="count($registry/f:fedramp-values/f:value-set) &gt; 0">The registry values at the path ' 
            <sch:value-of select="$registry-href" />' are not present, this configuration is invalid.</sch:assert>
            <sch:assert id="no-security-sensitivity-level"
                        organizational-id="section-c.1.a"
                        role="fatal"
                        test="$sensitivity-level != ''">[Section C Check 1.a] No sensitivty level found, no more validation processing can
                        occur.</sch:assert>
            <sch:assert id="invalid-security-sensitivity-level"
                        organizational-id="section-c.1.a"
                        role="fatal"
                        test="empty($ok-values) or not(exists($corrections))">[Section C Check 1.a] 
            <sch:value-of select="./name()" />is an invalid value of ' 
            <sch:value-of select="lv:sensitivity-level(/)" />', not an allowed value of 
            <sch:value-of select="$corrections" />. No more validation processing can occur.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation">
            <sch:let name="registry"
                     value="$registry-href =&gt; lv:registry()" />
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
                        organizational-id="section-c.3"
                        role="error"
                        test="not(exists($core-missing))">[Section C Check 3] This SSP has not implemented the most important 
            <sch:value-of select="count($core-missing)" />core 
            <sch:value-of select="if (count($core-missing)=1) then ' control' else ' controls'" />: 
            <sch:value-of select="$core-missing/@id" /></sch:assert>
            <sch:assert id="incomplete-all-implemented-requirements"
                        organizational-id="section-c.2"
                        role="warn"
                        test="not(exists($all-missing))">[Section C Check 2] This SSP has not implemented 
            <sch:value-of select="count($all-missing)" />
            <sch:value-of select="if (count($all-missing)=1) then ' control' else ' controls'" />overall: 
            <sch:value-of select="$all-missing/@id" /></sch:assert>
            <sch:assert id="extraneous-implemented-requirements"
                        organizational-id="section-c.2"
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
            <sch:let name="registry"
                     value="$registry-href =&gt; lv:registry()" />
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
                        organizational-id="section-c.2"
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
                        organizational-id="section-c.2"
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
                        role="warning"
                        test="$components-count &gt;= $required-components-count">Response statements for 
            <sch:value-of select="./@statement-id" />must have at least 
            <sch:value-of select="$required-components-count" />
            <sch:value-of select="if (count($components-count)=1) then ' component' else ' components'" />with a description. There are 
            <sch:value-of select="$components-count" />.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:description">
            <sch:assert id="extraneous-response-description"
                        role="warning"
                        test=". =&gt; empty()">Response statement 
            <sch:value-of select="../@statement-id" />has a description not within a component. That was previously allowed, but not recommended. It
            will soon be syntactically invalid and deprecated.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:remarks">
            <sch:assert id="extraneous-response-remarks"
                        role="warning"
                        test=". =&gt; empty()">Response statement 
            <sch:value-of select="../@statement-id" />has remarks not within a component. That was previously allowed, but not recommended. It will
            soon be syntactically invalid and deprecated.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component">
        <sch:let name="component-ref"
                 value="./@component-uuid" />
        <sch:assert id="invalid-component-match"
                    organizational-id="section-d"
                    role="warning"
                    test="/o:system-security-plan/o:system-implementation/o:component[@uuid = $component-ref] =&gt; exists()">[Section D Checks]
                    Response statment 
        <sch:value-of select="../@statement-id" />with component reference UUID ' 
        <sch:value-of select="$component-ref" />' is not in the system implementation inventory, and cannot be used to define a control.</sch:assert>
        <sch:assert id="missing-component-description"
                    organizational-id="section-d"
                    role="error"
                    test="./o:description =&gt; exists()">[Section D Checks] Response statement 
        <sch:value-of select="../@statement-id" />has a component, but that component is missing a required description
        node.</sch:assert>"</sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:description">
            <sch:let name="required-length"
                     value="20" />
            <sch:let name="description"
                     value=". =&gt; normalize-space()" />
            <sch:let name="description-length"
                     value="$description =&gt; string-length()" />
            <sch:assert id="incomplete-response-description"
                        organizational-id="section-d"
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
                        organizational-id="section-d"
                        role="warning"
                        test="$remarks-length &gt;= $required-length">[Section D Checks] Response statement component remarks for 
            <sch:value-of select="../../@statement-id" />is too short with 
            <sch:value-of select="$remarks-length" />characters. It must be 
            <sch:value-of select="$required-length" />characters long.</sch:assert>
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
                        organizational-id="section-d"
                        role="warning"
                        test="$components-count &gt;= $required-components-count">[Section D Checks] Response statements for 
            <sch:value-of select="./@statement-id" />must have at least 
            <sch:value-of select="$required-components-count" />
            <sch:value-of select="if (count($components-count)=1) then ' component' else ' components'" />with a description. There are 
            <sch:value-of select="$components-count" />.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:description">
            <sch:assert id="extraneous-response-description"
                        organizational-id="section-d"
                        role="warning"
                        test=". =&gt; empty()">[Section D Checks] Response statement 
            <sch:value-of select="../@statement-id" />has a description not within a component. That was previously allowed, but not recommended. It
            will soon be syntactically invalid and deprecated.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:remarks">
            <sch:assert id="extraneous-response-remarks"
                        organizational-id="section-d"
                        role="warning"
                        test=". =&gt; empty()">[Section D Checks] Response statement 
            <sch:value-of select="../@statement-id" />has remarks not within a component. That was previously allowed, but not recommended. It will
            soon be syntactically invalid and deprecated.</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component">
        <sch:let name="component-ref"
                 value="./@component-uuid" />
        <sch:assert id="invalid-component-match"
                    organizational-id="section-d"
                    role="warning"
                    test="/o:system-security-plan/o:system-implementation/o:component[@uuid = $component-ref] =&gt; exists()">[Section D Checks]
                    Response statment 
        <sch:value-of select="../@statement-id" />with component reference UUID ' 
        <sch:value-of select="$component-ref" />' is not in the system implementation inventory, and cannot be used to define a control.</sch:assert>
        <sch:assert id="missing-component-description"
                    organizational-id="section-d"
                    role="error"
                    test="./o:description =&gt; exists()">[Section D Checks] Response statement 
        <sch:value-of select="../@statement-id" />has a component, but that component is missing a required description
        node.</sch:assert>"</sch:rule>
        <sch:rule context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:description">
            <sch:let name="required-length"
                     value="20" />
            <sch:let name="description"
                     value=". =&gt; normalize-space()" />
            <sch:let name="description-length"
                     value="$description =&gt; string-length()" />
            <sch:assert id="incomplete-response-description"
                        organizational-id="section-d"
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
                        organizational-id="section-d"
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
                        organizational-id="section-c.6"
                        test="not(exists($extraneous-roles))">[Section C Check 2] This SSP has defined a responsible party with 
            <sch:value-of select="count($extraneous-roles)" />
            <sch:value-of select="if (count($extraneous-roles)=1) then ' role' else ' roles'" />not defined in the role: 
            <sch:value-of select="$extraneous-roles/@role-id" /></sch:assert>
            <sch:assert id="incorrect-party-association"
                        organizational-id="section-c.6"
                        test="not(exists($extraneous-parties))">[Section C Check 2] This SSP has defined a responsible party with 
            <sch:value-of select="count($extraneous-parties)" />
            <sch:value-of select="if (count($extraneous-parties)=1) then ' party' else ' parties'" />is not a defined party: 
            <sch:value-of select="$extraneous-parties/o:party-uuid" /></sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:back-matter/o:resource">
            <sch:assert id="resource-uuid-required"
                        organizational-id="section-b.?????"
                        test="./@uuid">[Section B Check ????] This SSP includes back-matter resource missing a UUID</sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:back-matter/o:resource/o:rlink">
            <sch:assert id="resource-rlink-required"
                        organizational-id="section-b.?????"
                        test="doc-available(./@href)">[Section B Check ????] This SSP references back-matter resource: 
            <sch:value-of select="./@href" /></sch:assert>
        </sch:rule>
        <sch:rule context="/o:system-security-plan/o:back-matter/o:resource/o:base64">
            <sch:let name="filename"
                     value="@filename" />
            <sch:let name="media-type"
                     value="@media-type" />
            <sch:assert id="resource-base64-available"
                        organizational-id="section-b.?????"
                        test="./@filename">[Section B Check ????] This SSP has file name: 
            <sch:value-of select="./@filename" /></sch:assert>
            <sch:assert id="resource-base64-available"
                        organizational-id="section-b.?????"
                        test="./@filename">[Section B Check ????] This SSP has media type: 
            <sch:value-of select="./@media-type" /></sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
