<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:o="http://csrc.nist.gov/ns/oscal/1.0">

<sch:ns prefix="f"     uri="https://fedramp.gov/ns/oscal"/>
<sch:ns prefix="o"     uri="http://csrc.nist.gov/ns/oscal/1.0"/>
<sch:ns prefix="oscal" uri="http://csrc.nist.gov/ns/oscal/1.0"/>

<sch:title>FedRAMP System Security Plan Validations</sch:title>

<!--
    Use XSL collection to load FedRAMP values, information types, and threats
    from a known source in a relative path instead of hard-coding filenames.
    All files are XML, but for future-proofing we filter to retrieve only XML
    files.
-->

<!-- 
    This workaround is only to allow XSpec to source the proper context for
    XPath at the global level. We use XSpec for unit testing, and this is a
    known issue with very well-documented work-arounds.
    
    https://gitter.im/usnistgov-OSCAL/FedRAMP-10x-Schematron?at=5fa06e38f2fd4f60fc4ccec7
    
    https://github.com/xspec/xspec/issues/873
    https://github.com/xspec/xspec/issues/892
    https://github.com/xspec/xspec/issues/1239

    See the updated documentation below about the global-context-item pattern.

    https://github.com/xspec/xspec/wiki/Writing-Scenarios/ec19017ab00d769b49786cb227e57eaa2e4ee2b2#global-context-item
    https://github.com/AirQuick/xspec/tree/14ccd455a0e420c97903c06f0faea86719031044/tutorial/global-context-item

    If not, you will definitely see this error like below when running the test suite.

    XPDY0002  Finding root of root/key-name the context item is absent
-->
<xsl:param name="global-context-item" select="/" />
<xsl:param name="fedramp-registry-href" select="'../../xml?select=*.xml'" />
<xsl:variable name="fedramp-registry" select="collection($fedramp-registry-href)"/>
<xsl:variable name="selected-sensitivty-level" select="$global-context-item/o:system-security-plan/o:system-characteristics/o:security-sensitivity-level"/>

<sch:let name="sensitivity-levels" value="$fedramp-registry/f:fedramp-values/f:value-set[@name='security-sensitivity-level']/f:allowed-values/f:enum/@value"/>
<sch:let name="implementation-statuses" value="$fedramp-registry/f:fedramp-values/f:value-set[@name='control-implementation-status']/f:allowed-values/f:enum/@value"/>

<xsl:variable name="profile-map">
    <profile level="low" uuid="4678df89-bdc1-4804-bdfd-0bb1fc5bba1a" href="../../../baselines/xml/FedRAMP_LOW-baseline_profile.xml"/>
    <profile level="moderate" uuid="8383f859-be40-453d-9588-c645af5bef6f" href="../../../baselines/xml/FedRAMP_MODERATE-baseline_profile.xml"/>
    <profile level="high" uuid="b11dba1c-0c68-4724-9eaf-02de2d5bbb89" href="../../../baselines/xml/FedRAMP_HIGH-baseline_profile.xml"/>
</xsl:variable>

<xsl:key name="profile-lookup" match="profile" use="@level"/>
<xsl:variable name="selected-profile-path" select="key('profile-lookup', $selected-sensitivty-level, $profile-map)/@href"/>
<xsl:variable name="selected-profile" select="doc(resolve-uri($selected-profile-path))"/>

<sch:pattern>
    <sch:rule context="/">
        <sch:assert id="no-fedramp-registry-values" test="exists($fedramp-registry/f:fedramp-values)">The FedRAMP Registry values are not present, this validation is invalid.</sch:assert>
    </sch:rule>
</sch:pattern>

<sch:pattern>
    <sch:rule context="/o:system-security-plan/o:system-characteristics/o:security-sensitivity-level">
        <sch:assert id="no-security-sensitivity-level" test="$selected-sensitivty-level">No sensitivty level found from XPath query.></sch:assert>
        <sch:assert id="invalid-security-sensitivity-level" test=". = $sensitivity-levels"><sch:value-of select="./name()"/> is an invalid value <sch:value-of select="."/></sch:assert>
    </sch:rule>
</sch:pattern>
<sch:pattern>
    <sch:rule context="/o:system-security-plan">
        <sch:let name="all" value="o:control-implementation/o:implemented-requirement[o:annotation[@name='implementation-status']]"/>
        <sch:let name="planned" value="o:control-implementation/o:implemented-requirement[o:annotation[@name='implementation-status' and @value='planned']]"/>
        <sch:let name="partial" value="o:control-implementation/o:implemented-requirement[o:annotation[@name='implementation-status' and @value='partial']]"/>
        <sch:assert id="invalid-implemented-requirements-count" test="count($all) > 0">There are no control implementations with statuses set.</sch:assert> 
        <sch:report id="partial-requirements-report" test="true()">There are <sch:value-of select="count($partial)"/> partial<sch:value-of select="if (count($partial)=1) then ' control implementation' else ' control implementations'"/>.</sch:report>
        <sch:report id="planned-requirements-report" test="true()">There are <sch:value-of select="count($planned)"/> planned<sch:value-of select="if (count($planned)=1) then ' control implementation' else ' control implementations'"/>.</sch:report>
        <sch:report id="all-requirements-report" test="true()">There are <sch:value-of select="count($all)"/> total<sch:value-of select="if (count($all)=1) then ' control implementation' else ' control implementations'"/>.</sch:report>
    </sch:rule>
    <sch:rule context="/o:system-security-plan/o:control-implementation">
        <sch:let name="required" value="$selected-profile/o:profile/o:import/o:include/o:call"/>
        <sch:let name="implemented" value="o:implemented-requirement"/>
        <sch:let name="missing" value="$required[not(@control-id = $implemented/@control-id)]"/>
        <sch:report test="true()">The following <sch:value-of select="count($required)"/><sch:value-of select="if (count($required)=1) then ' control' else ' controls'"/> are required: <sch:value-of select="$required/@control-id"/></sch:report>
        <sch:assert id="incomplete-implementation-requirements" test="count($missing) = 0">This SSP has not implemented <sch:value-of select="count($missing)"/><sch:value-of select="if (count($missing)=1) then ' control' else ' controls'"/>: <sch:value-of select="$missing/@control-id"/></sch:assert>
    </sch:rule>
</sch:pattern>
</sch:schema>