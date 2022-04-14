<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    exclude-result-prefixes="xs math"
    version="3.0"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">

    <xsl:mode
        on-no-match="shallow-copy" />

    <xsl:output
        indent="true"
        method="xml" />

    <xsl:template
        match="implemented-requirement">
        <xsl:copy>
            <xsl:copy-of
                select="attribute::node()" />
            <xsl:copy-of
                select="prop" />
            <xsl:copy-of
                select="link" />
            <xsl:copy-of
                select="descendant::set-parameter" />
            <xsl:copy-of
                select="responsible-role" />
            <xsl:apply-templates
                select="statement" />
        </xsl:copy>
    </xsl:template>

    <xsl:template
        match="set-parameter" />

</xsl:stylesheet>
