<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:o="http://csrc.nist.gov/ns/oscal/1.0">

<sch:ns prefix="f"     uri="https://fedramp.gov/ns/oscal"/>
<sch:ns prefix="o"     uri="http://csrc.nist.gov/ns/oscal/1.0"/>
<sch:ns prefix="oscal" uri="http://csrc.nist.gov/ns/oscal/1.0"/>

<sch:title>FedRAMP System Security Plan Validations</sch:title>

<sch:let name="values" value="doc(resolve-uri('../xml/fedramp_values.xml'))"/>
<sch:let name="levels" value="$values/f:fedramp-values/f:value-set[@name='security-sensitivity-level']/f:allowed-values/f:enum/@value"/>

<sch:pattern>
    <sch:rule context="o:system-security-plan/o:system-characteristics/o:security-sensitivity-level">
        <sch:report test="true()">Permissible FedRAMP SSP Impact Levels are <sch:value-of select="$levels"/></sch:report>
        <sch:report test="."><sch:value-of select="./name()"/> is <sch:value-of select="."/></sch:report>
        <sch:assert test=". = $levels"><sch:value-of select="./name()"/> is an invalid value <sch:value-of select="."/></sch:assert>
    </sch:rule>
</sch:pattern>
<sch:pattern>
    <sch:rule context="o:system-security-plan">
        <sch:let name="all" value="o:control-implementation/o:implemented-requirement[o:annotation[@name='implementation-status']]"/>
        <sch:let name="planned" value="o:control-implementation/o:implemented-requirement[o:annotation[@name='implementation-status' and @value='planned']]"/>
        <sch:let name="partial" value="o:control-implementation/o:implemented-requirement[o:annotation[@name='implementation-status' and @value='partial']]"/>
        <sch:report test="true()">I see <sch:value-of select="count($partial)"/> partial<sch:value-of select="if (count($partial)=1) then ' control implementation' else ' control implementations'" />.</sch:report>
        <sch:report test="true()">I see <sch:value-of select="count($planned)"/> planned<sch:value-of select="if (count($planned)=1) then ' control implementation' else ' control implementations'" />.</sch:report>
        <sch:report test="true()">I see <sch:value-of select="count($all)"/> total<sch:value-of select="if (count($all)=1) then ' control implementation' else ' control implementations'" />.</sch:report>
    </sch:rule>
</sch:pattern>
</sch:schema>