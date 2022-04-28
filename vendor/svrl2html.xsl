<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
    <xsl:output method="html" indent="yes"/>
 
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>SVRL report</title>
                <style>
                    body {margin:8px;}
                    a[href] {color:blue;}
                    li.diagnostic {background-color:orange;}
                </style>
            </head>
            <body>
                <h1>SVRL report</h1>
                <div>Errors: <xsl:value-of select="count(.//svrl:failed-assert)"/></div>
                <xsl:for-each select=".//svrl:failed-assert">
                    <ul>
                        <li><b>Text: <xsl:value-of select="svrl:text"/></b></li>
                        <li class="diagnostic">Error message: <xsl:value-of select="svrl:diagnostic-reference"/></li>
                        <li>Test: <xsl:value-of select="@test"/></li>
                        <li>See: <xsl:value-of select="@see"/></li>
                        <li>Location: <xsl:value-of select="@location"/></li>
                    </ul>
                </xsl:for-each>
                <div>Reports: <xsl:value-of select="count(.//svrl:successful-report)"/></div>
                <xsl:for-each select=".//svrl:successful-report">
                    <ul>
                        <li><b>Text: <xsl:value-of select="svrl:text"/></b></li>
                        <li>Test: <xsl:value-of select="@test"/></li>
                        <li>See: <xsl:value-of select="@see"/></li>
                        <li>Location: <xsl:value-of select="@location"/></li>
                    </ul>
                </xsl:for-each>
                 
            </body>
        </html>
    </xsl:template>
 
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>