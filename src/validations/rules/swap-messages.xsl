<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
    xmlns:msg="https://fedramp.gov/oscal/fedramp-automation-messages"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    version="3.0">

    <!-- Transform ssp.sch changing each assertion's affirmative and diagnostic messages to those of a specific persona -->

    <!-- The desired persona id is required -->
    <xsl:param
        name="persona"
        as="xs:string"
        required="true" />

    <xsl:param
        name="preserve"
        as="xs:boolean"
        required="false"
        select="false()" />

    <xsl:param
        name="tag"
        as="xs:boolean"
        required="false"
        select="false()" />

    <xsl:strip-space
        elements="*" />

    <xsl:output
        method="xml" />

    <xsl:template
        match="(assert | report)"
        xpath-default-namespace="http://purl.oclc.org/dsdl/schematron">
        <xsl:copy>
            <xsl:copy-of
                select="attribute::node()" />
            <xsl:if
                test="$tag">
                <xsl:attribute
                    name="msg:persona"
                    select="$persona" />
            </xsl:if>
            <xsl:apply-templates
                select="//msg:message[@id = current()/@id]/msg:persona[@id = $persona]/msg:affirmative/node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template
        match="msg:message">
        <xsl:copy>
            <xsl:copy-of
                select="attribute::node()" />
            <xsl:copy-of
                select="node()" />
            <xsl:if
                test="$preserve">
                <xsl:element
                    name="previous"
                    namespace="https://fedramp.gov/oscal/fedramp-automation-messages">
                    <xsl:element
                        name="affirmative"
                        namespace="https://fedramp.gov/oscal/fedramp-automation-messages">
                        <xsl:apply-templates
                            select="//sch:*[@id = current()/@id]/node()" />
                    </xsl:element>
                    <xsl:element
                        name="diagnostic"
                        namespace="https://fedramp.gov/oscal/fedramp-automation-messages">
                        <xsl:apply-templates
                            select="//sch:diagnostic[@id = //sch:*[@id = current()/@id]/@diagnostics]/node()" />
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:copy>
    </xsl:template>

    <xsl:template
        match="node()"
        priority="-1"
        mode="#all">
        <xsl:copy>
            <xsl:copy-of
                select="attribute::node()" />
            <xsl:apply-templates
                mode="#current" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
