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

<xsl:variable name="values" select="collection('../../xml?select=*.xml')"/>

<sch:let name="sensitivity-levels" value="$values/f:fedramp-values/f:value-set[@name='security-sensitivity-level']/f:allowed-values/f:enum/@value"/>
<sch:let name="selected-sensitivty-level" value="/o:system-security-plan/o:system-characteristics/o:security-sensitivity-level"/>

<xsl:variable name="profile-map">
    <profile level="low" uuid="4678df89-bdc1-4804-bdfd-0bb1fc5bba1a" href="../../../baselines/xml/FedRAMP_LOW-baseline_profile.xml"/>
    <profile level="moderate" uuid="8383f859-be40-453d-9588-c645af5bef6f" href="../../../baselines/xml/FedRAMP_MODERATE-baseline_profile.xml"/>
    <profile level="high" uuid="b11dba1c-0c68-4724-9eaf-02de2d5bbb89" href="../../../baselines/xml/FedRAMP_HIGH-baseline_profile.xml"/>
</xsl:variable>

<xsl:key name="profile-lookup" match="profile" use="@level"/>
<xsl:variable name="selected-profile-path" select="key('profile-lookup', $selected-sensitivty-level, $profile-map)/@href"/>
<xsl:variable name="selected-profile" select="doc(resolve-uri($selected-profile-path))"/>

<sch:pattern>
    <sch:rule context="o:system-security-plan/o:system-characteristics/o:security-sensitivity-level">
        <sch:assert id="no-security-sensitivity-level" test="$selected-sensitivty-level">No sensitivty level found from XPath query.></sch:assert>
        <sch:assert id="invalid-security-sensitivity-level" test=". = $sensitivity-levels"><sch:value-of select="./name()"/> is an invalid value <sch:value-of select="."/></sch:assert>
    </sch:rule>
</sch:pattern>
<sch:pattern>
    <sch:rule context="o:system-security-plan">
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