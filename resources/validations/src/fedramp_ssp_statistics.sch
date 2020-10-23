<sch:schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
        xmlns:sqf="http://www.schematron-quickfix.com/validator/process" 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:o="http://csrc.nist.gov/ns/oscal/1.0">

        <sch:ns prefix="o"     uri="http://csrc.nist.gov/ns/oscal/1.0"/>
        <sch:ns prefix="oscal" uri="http://csrc.nist.gov/ns/oscal/1.0"/>

<sch:title>FedRAMP Low Baseline Profile - System Security Plan Validations</sch:title>
<sch:pattern>
    <sch:rule context="system-security-plan/control-implementation">
        <sch:let name="statuses-all" value="implemented-requirement[annotation[@name='implementation-status']]"/>
        <sch:let name="statuses-planned" value="implemented-requirement[annotation[@name='implementation-status' and @value='planned']]"/>
        <sch:let name="statuses-partial" value="implemented-requirement[annotation[@name='implementation-status' and @value='partial']]"/>
        <sch:let name="statuses-na" value="implemented-requirement[annotation[@name='implementation-status' and @value='not-applicable']]"/>
        <sch:let name="percent-of-total-control-status-threshold" value="count($statuses-all)*.25"/>
        
        <sch:assert test="count($statuses-planned) + count($statuses-na) &lt; percent-of-total-control-status-threshold"> There are too many controls implemented in status of planned: <sch:value-of select="count($statuses-planned)"/> and status of not-applicable: <sch:value-of select="count($statuses-na)"/> (total: <sch:value-of select="count($statuses-planned) + count($statuses-na)"/>) )when the threshold is no more than <sch:value-of select="$percent-of-total-control-status-threshold"/>.</sch:assert>
        <sch:report test="true()">I see <sch:value-of select="count($statuses-na)"/> control-implementation(s) with a status of Not Applicable.</sch:report>

        <sch:report test="true()">I see <sch:value-of select="count($statuses-partial)"/> control-implementation(s) with a status of partial.</sch:report>
        <sch:report test="true()">I see <sch:value-of select="count($statuses-planned)"/> control-implementation(s) with a status of planned.</sch:report>
        <sch:report test="true()">I see <sch:value-of select="count($statuses-all)"/> control-implementation(s) total.</sch:report>
        <sch:report test="true()">The threshold is <sch:value-of select="$percent-of-total-control-status-threshold"/> (25% of total control-implementation(s)).</sch:report>
    </sch:rule>
</sch:pattern>

<sch:pattern id="a-4-control-statistics">
    <!--<let name="statuses" value="document('../xml/fedramp_values.xml')/fedramp-values/value-set[@name='control-implementation-status']/allowed-values/enum/@value" />-->
    <sch:rule context="system-security-plan/control-implementation/implemented-requirement[annotation[@name='implementation-status']]" >
        <sch:let name="allCtrlImpl" select="@value='impossible'"/>
        <sch:let name="plannedCtrlImpl" select="annotation[@name='implementation-status' and @value='planned']"/>
        <sch:report test="annotation[@name='implementation-status' and @value='impossible']">Found an invalid status! in control: <value-of select="@control-id"/>
            metrics: <value-of select="count($plannedCtrlImpl)"/> of <sch:value-of select="$allCtrlImpl"/></sch:report>
        <!-- <report test="count(annotation[@name='implementation-status'])"><value-of select="count(.)"/>SSP control implementation statuses counted.</report> -->
        <!-- <assert test=". = $statuses">A control is using an invalid implementation status of <value-of select="."/>.</assert> -->
        <!-- <report test="count($statuses)"><value-of select="count($statuses)"/> official FedRAMP SSP control implementation statuses loaded.</report> -->
    </sch:rule>
</sch:pattern>
</sch:schema>