<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    exclude-result-prefixes="xs math sch doc"
    version="3.0"
    xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
    xmlns:feddoc="http://us.gov/documentation/federal-documentation"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://purl.oclc.org/dsdl/schematron">
    <xsl:output
        method="text" />
    <xsl:template
        match="/">
        <!-- define a variable for the input (Schematron) document -->
        <!-- because subsequent contexts are strings -->
        <xsl:variable
            as="document-node()"
            name="sch"
            select="current()" />
        <!-- declare the distinct attribute names -->
        <xsl:variable
            as="xs:string*"
            name="groups"
            select="distinct-values(//assert/(@doc:*|@feddoc:*) ! local-name()), ('all')" />
        <!-- create the proto-JSON XML -->
        <xsl:variable
            as="node()"
            name="xml">
            <!-- the outermost structure is an array -->
            <array
                xmlns="http://www.w3.org/2005/xpath-functions">
                <!-- iterate over the various attribute names -->
                <xsl:for-each
                    select="$groups">
                    <!-- preserve the current context as it will be occluded -->
                    <xsl:variable
                        as="xs:string"
                        name="attribute-local-name"
                        select="current()" />
                    <!-- create a grouping -->
                    <map>
                        <string
                            key="title">
                            <xsl:choose>
                                <xsl:when
                                    test="current() eq 'checklist-reference'">
                                    <xsl:text>FedRAMP Submission Checklist</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="current() eq 'guide-reference'">FedRAMP OSCAL Guide</xsl:when>
                                <xsl:when
                                    test="current() eq 'template-reference'">FedRAMP SSP Template</xsl:when>
                                <xsl:when
                                    test="current() eq 'documentation-reference'">Other Federal Documentation</xsl:when>
                                <xsl:when
                                    test="current() eq 'all'">
                                    <xsl:text>All Rules</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                        </string>
                        <!-- get the distinct values found in this attribute -->
                        <xsl:variable
                            as="xs:string*"
                            name="groupitems"
                            select="
                                if ($attribute-local-name = 'all') then
                                    ('Unorganized')
                                else
                                    distinct-values($sch//(@doc:*|@feddoc:*)[local-name() eq $attribute-local-name] ! tokenize(., ',\s*'))"
                        />
                        <!-- create a list of related assertions for each distinct attribute value-->
                        <array
                            key="groups">
                            <xsl:for-each
                                select="$groupitems">
                                <xsl:sort>
                                    <!-- attempt to order by text -->
                                    <xsl:analyze-string
                                        regex="^(\D+)"
                                        select=".">
                                        <xsl:matching-substring>
                                            <xsl:value-of
                                                select="regex-group(1)" />
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:sort>
                                <xsl:sort>
                                    <!-- attempt to order by number -->
                                    <xsl:variable
                                        as="xs:string"
                                        name="s">
                                        <xsl:analyze-string
                                            regex="^\D+([0-9.]+).*$"
                                            select=".">
                                            <xsl:matching-substring>
                                                <xsl:choose>
                                                    <xsl:when
                                                        test="ends-with(regex-group(1), '.')">
                                                        <xsl:text expand-text="true">00{substring-before(regex-group(1),'.')}</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when
                                                        test="matches(regex-group(1), '^\d+$')">
                                                        <xsl:text expand-text="true">{regex-group(1) ! xs:integer(.) ! format-integer(.,'000')}</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when
                                                        test="matches(regex-group(1), '\.')">
                                                        <xsl:text expand-text="true">{tokenize(regex-group(1),'\.') ! xs:integer(.) ! format-integer(.,'000')}</xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:text>999 999</xsl:text>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:text>999 999</xsl:text>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:variable>
                                    <xsl:copy-of
                                        select="$s" />
                                </xsl:sort>

                                <xsl:variable
                                    as="xs:string"
                                    name="item"
                                    select="current()" />
                                <xsl:if
                                    test="
                                        $item = 'Unorganized' or (some $d in $sch//assert/(@doc:*|@feddoc:*)
                                            satisfies some $t in tokenize($d, ',\s*')
                                                satisfies $t = tokenize($item, ',\s*'))">
                                    <map>
                                        <string
                                            key="title">
                                            <xsl:value-of
                                                select="current()" />
                                        </string>
                                        <array
                                            key="assertionIds">
                                            <xsl:for-each
                                                select="$sch//assert">
                                                <xsl:if
                                                    test="
                                                        $item = 'Unorganized' or (some $d in (@doc:*|@feddoc:*)
                                                            satisfies some $t in tokenize($d, ',\s*')
                                                                satisfies $t = tokenize($item, ',\s*'))">
                                                    <string>
                                                        <xsl:value-of
                                                            select="@id" />
                                                    </string>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </array>
                                    </map>
                                </xsl:if>
                            </xsl:for-each>
                        </array>
                    </map>
                </xsl:for-each>
            </array>
        </xsl:variable>
        <!-- output the equivalent JSON -->
        <xsl:copy-of
            select="xml-to-json($xml)" />
    </xsl:template>
</xsl:stylesheet>
