<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    exclude-result-prefixes="xs math oscal fv fn sch doc x"
    version="3.0"
    xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
    xmlns:fn="local function"
    xmlns:fv="https://fedramp.gov/ns/oscal"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:x="http://www.jenitennison.com/xslt/xspec"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param
        as="xs:string"
        name="title"
        required="false">
        <xsl:text>FedRAMP Rules and Validation Logic</xsl:text>
    </xsl:param>
    <xsl:mode
        on-no-match="fail" />
    <xsl:output
        encoding="UTF-8"
        html-version="5"
        indent="false"
        method="html" />

    <xsl:template
        match="*"
        mode="serialize">
        <xsl:choose>
            <xsl:when
                test="name() = 'sch:name'">
                <span
                    class="context-item substitution"
                    title="{ancestor::sch:rule/@context}">
                    <xsl:text>Context</xsl:text>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span
                    class="substitution">
                    <xsl:text>&lt;</xsl:text>
                    <xsl:value-of
                        select="name()" />
                    <xsl:apply-templates
                        mode="#current"
                        select="attribute::node()" />
                    <xsl:choose>
                        <xsl:when
                            test="text()">
                            <xsl:apply-templates
                                mode="#current"
                                select="node()" />
                            <xsl:text>&lt;/&gt;</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>/&gt;</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template
        match="attribute::node()"
        mode="serialize">
        <xsl:text> </xsl:text>
        <xsl:value-of
            select="name()" />
        <xsl:text>="</xsl:text>
        <xsl:value-of
            select="." />
        <xsl:text>"</xsl:text>
    </xsl:template>

    <xsl:template
        match="text()[matches(., '^\s+$')]"
        mode="serialize"> </xsl:template>
    <xsl:template
        match="text()"
        mode="serialize">
        <xsl:copy-of
            select="." />
    </xsl:template>

    <xsl:template
        match="/">


        <!-- ensure input is this transform -->
        <xsl:choose>
            <xsl:when
                test="base-uri() = static-base-uri()">
                <!-- that's correct --></xsl:when>
            <xsl:otherwise>
                <xsl:message
                    expand-text="true"
                    terminate="true">{base-uri()} is not static-base-uri()</xsl:message>
            </xsl:otherwise>
        </xsl:choose>

        <html>
            <head>
                <title>
                    <xsl:value-of
                        select="$title" />
                </title>
                <xsl:variable
                    as="xs:string"
                    name="css-href"
                    select="replace(static-base-uri(), '\.xsl$', '.css')" />
                <xsl:if
                    test="unparsed-text-available($css-href)">
                    <xsl:variable
                        name="css"
                        select="unparsed-text($css-href)" />
                    <style><xsl:value-of disable-output-escaping="true" select="replace($css, '\s+', ' ')" /></style>
                </xsl:if>

            </head>
            <body>
                <h1>
                    <xsl:value-of
                        select="$title" />
                </h1>

                <p>
                    <xsl:text expand-text="true">Last updated { format-dateTime(current-dateTime(), '[MNn] [D] [Y] [H01]:[m01] [ZN,*-3]') }.</xsl:text>
                </p>

                <p>Information from <a
                        href="#fedramp_values.xml"><code>fedramp_values.xml</code></a> and <a
                        href="#FedRAMP_extensions.xml"><code>FedRAMP_extensions.xml</code></a> is presented.</p>

                <xsl:variable
                    as="xs:string*"
                    name="docs"
                    select="
                        'ssp.sch'" />

                <p>Some items for discussion and decision:</p>
                <ul>
                    <li>How much context should accompany Schematron messages? <ul>
                            <li>For FedRAMP OSCAL SSP submitters</li>
                            <li>For FedRAMP OSCAL SSP reviewers</li>
                        </ul>
                    </li>
                    <li>Should Schematron be a structured form of FedRAMP rule definitions? (A Schematron document may include arbitrary information
                        cast as XML in one or more XML namespaces.) <ul>
                            <li>Should it be the sole source?</li>
                        </ul>
                    </li>
                    <li>Should <a
                            href="https://www.plainlanguage.gov/"
                            target="_blank">plainlanguage.gov</a> prose style be used?</li>
                    <li>Will FedRAMP automation structured documentation be inclusive of <a
                            href="https://www.section508.gov/"
                            target="_blank">Section 508</a> accommodations?</li>
                </ul>


                <xsl:variable
                    as="node()*"
                    name="d">
                    <xsl:sequence>
                        <xsl:for-each
                            select="$docs">
                            <xsl:if
                                test="not(doc-available(.))">
                                <xsl:message
                                    expand-text="true"
                                    terminate="true">The expected input document {.} is not available.</xsl:message>
                            </xsl:if>
                            <xsl:copy-of
                                select="doc(.)" />
                        </xsl:for-each>
                    </xsl:sequence>
                </xsl:variable>

                <h2>Rules</h2>
                <!--<p>NB: When FedRAMP rules and validation logic is discussed, there is a minor mismatch between a general concept of a <i>rule</i>
                    versus rule representation in Schematron. The former is what SSP reviewers (and perhaps submitters) hold; the latter might be
                    expressed as multiple Schematron <code>&lt;rule&gt;</code>, <code>&lt;assert&gt;</code>, and <code>&lt;report&gt;</code> elements.
                    The same word with different meanings in both venues is unfortunate.</p>-->
                <p>The following table lists Schematron <code>assert</code> and <code>report</code> elements with the Schematron ID, assertion
                    (affirmative statement), diagnostic (negative statement used when the assertion was false), and related attributes. Each of these
                    is subordinate to a context defined in a parent Schematron <code>rule</code> element.</p>
                <xsl:if
                    test="false()">
                    <p>The Schematron documentation describes a <code>rule></code> as</p>
                    <blockquote>
                        <p>A list of assertions tested within the context specified by the required context attribute.</p>
                        <p>NOTE: It is not an error if a rule never fires in a document. In order to test that a document always has some context, a
                            new pattern should be created from the context of the document, with an assertion requiring the element or attribute.</p>
                        <p>When the rule element has the attribute abstract with a value true, then the rule is an abstract rule. An abstract rule
                            shall not have a context attribute. An abstract rule is a list of assertions that will be invoked by other rules belonging
                            to the same pattern using the extends element. Abstract rules provide a mechanism for reducing schema size.</p>
                    </blockquote>
                    <p>The Schematron documentation (in the Schematron schema) states the following about constraint statements:</p>
                    <blockquote>
                        <p>An assertion made about the context nodes. The data content is a natural-language assertion. <strong>The natural-language
                                assertion shall be a positive statement of a constraint.</strong>
                        </p>
                        <p>NOTE: The natural-language assertion may contain information about actual values in addition to expected values and may
                            contain diagnostic information. Users should note, however, that <strong>the diagnostic element is provided for such
                                information to encourage clear statement of the natural-language assertion</strong>.</p>
                    </blockquote>
                    <p>Schematron assertions (<code>assert</code> and <code>report</code> elements) may employ a <code>@diagnostics</code> attribute
                        which cites one or more diagnostic message identifiers. Such messages are described as</p>
                    <blockquote>
                        <p>A natural-language message giving more specific details concerning a failed assertion, such as found versus expected values
                            and repair hints.</p>
                        <p>NOTE: In multiple languages may be supported by using a different diagnostic element for each language, with the
                            appropriate xml:lang language attribute, and referencing all the unique identifiers of the diagnostic elements in the
                            diagnostics attribute of the assertion.</p>
                    </blockquote>
                </xsl:if>

                <table>
                    <caption>
                        <div>List of assertions</div>
                        <p>There are <xsl:value-of
                                select="count($d//(sch:assert | sch:report))" /> Schematron assertions as of this update</p>
                    </caption>
                    <colgroup>
                        <col
                            style="width:15%;" />
                        <col />
                    </colgroup>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Statement</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each
                            select="$d//assert"
                            xpath-default-namespace="http://purl.oclc.org/dsdl/schematron">
                            <xsl:sort
                                select="tokenize(document-uri(root()), '/')[last()]" />
                            <!--<xsl:sort
                                select="@id" />-->
                            <tr>
                                <td>
                                    <xsl:choose>
                                        <xsl:when
                                            test="@id">
                                            <xsl:value-of
                                                select="@id" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>(missing assertion id)</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>

                                </td>
                                <td>
                                    <div>
                                        <span
                                            class="assertion">
                                            <xsl:apply-templates
                                                mode="serialize"
                                                select="node()" />
                                        </span>
                                    </div>
                                    <xsl:if
                                        test="@diagnostics">
                                        <xsl:for-each
                                            select="//diagnostic[@id = tokenize(current()/@diagnostics, '\s+')]">
                                            <div>
                                                <span
                                                    class="diagnostic">
                                                    <xsl:attribute
                                                        name="title">
                                                        <xsl:value-of
                                                            select="@id" />
                                                    </xsl:attribute>
                                                    <xsl:text> </xsl:text>
                                                    <xsl:apply-templates
                                                        mode="serialize"
                                                        select="node()" />
                                                </span>
                                            </div>
                                        </xsl:for-each>
                                    </xsl:if>
                                    <div>
                                        <xsl:text>context: </xsl:text>
                                        <code>
                                            <xsl:value-of
                                                select="parent::rule/@context" />
                                        </code>
                                    </div>
                                    <div>
                                        <xsl:text>test: </xsl:text>
                                        <code>
                                            <xsl:value-of
                                                select="@test" />
                                        </code>
                                    </div>
                                    <div>
                                        <xsl:text>role: </xsl:text>
                                        <code>
                                            <xsl:value-of
                                                select="@role" />
                                        </code>
                                    </div>
                                    <xsl:variable
                                        as="document-node()"
                                        name="xspec"
                                        select="doc(//doc:xspec/@href)" />
                                    <xsl:variable
                                        as="element()*"
                                        name="a"
                                        select="$xspec//x:expect-not-assert[@id = current()/@id]" />
                                    <xsl:choose>
                                        <xsl:when
                                            test="$xspec//x:expect-not-assert[@id = current()/@id]">
                                            <div>
                                                <xsl:text>affirmative XSpec test: </xsl:text>
                                                <xsl:value-of
                                                    select="$a/ancestor::x:scenario/@label, $a/@label"
                                                    separator=" ➔ " />
                                            </div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div>
                                                <xsl:text>affirmative XSpec test: </xsl:text>
                                                <span
                                                    class="missing">
                                                    <xsl:text>no coverage</xsl:text>
                                                </span>
                                            </div>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:variable
                                        as="element()*"
                                        name="b"
                                        select="$xspec//x:expect-assert[@id = current()/@id]" />
                                    <xsl:choose>
                                        <xsl:when
                                            test="$xspec//x:expect-assert[@id = current()/@id]">
                                            <div>
                                                <xsl:text>negative XSpec test: </xsl:text>
                                                <xsl:value-of
                                                    select="$b/ancestor::x:scenario/@label, $b/@label"
                                                    separator=" ➔ " />
                                            </div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div>
                                                <xsl:text>negative XSpec test: </xsl:text>
                                                <span
                                                    class="missing">
                                                    <xsl:text>no coverage</xsl:text>
                                                </span>
                                            </div>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:if
                                        test="@doc:*">
                                        <div>
                                            <xsl:text expand-text="true">FedRAMP note: {@doc:*}</xsl:text>
                                        </div>
                                    </xsl:if>

                                </td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>

                <h2>FedRAMP Values</h2>
                <p>The <code>fedramp_values.xml</code> document contains value enumerations for various FedRAMP OSCAL document elements.</p>
                <xsl:variable
                    as="document-node()"
                    name="fvxml"
                    select="doc('../../xml/fedramp_values.xml')" />
                <table
                    id="fedramp_values.xml">
                    <caption><code>fedramp_values.xml</code> constraints</caption>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Values</th>
                            <th>Context(s) - <span
                                    class="highlight">Light blue</span> highlights use of name in context. <span
                                    class="highlight-missed">Yellow</span> highlights absence of name in context.</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:apply-templates
                            select="$fvxml//value-set"
                            xpath-default-namespace="https://fedramp.gov/ns/oscal">
                            <xsl:sort
                                select="@name" />
                        </xsl:apply-templates>
                    </tbody>
                </table>

                <h2>FedRAMP Extensions</h2>
                <p>The <code>FedRAMP_extensions.xml</code> document contains OSCAL schema extensions for FedRAMP OSCAL documents.</p>
                <xsl:variable
                    as="document-node()"
                    name="fx"
                    select="doc('../../xml/FedRAMP_extensions.xml')" />
                <table
                    id="FedRAMP_extensions.xml">
                    <caption><code>FedRAMP_extensions.xml</code> constraints</caption>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Values</th>
                            <th>Context(s) - <span
                                    class="highlight">Light blue</span> highlights use of name in context. <span
                                    class="highlight-missed">Yellow</span> highlights absence of name in context.</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:apply-templates
                            select="$fx//extensions/constraint[@name]"
                            xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
                            <xsl:sort
                                select="@name" />
                        </xsl:apply-templates>
                    </tbody>
                </table>

            </body>
        </html>
    </xsl:template>

    <xsl:template
        match="assert | report"
        xpath-default-namespace="http://purl.oclc.org/dsdl/schematron">
        <tr>
            <td>
                <xsl:value-of
                    select="@id" />
            </td>
            <td>
                <div>
                    <xsl:text>context: </xsl:text>
                    <code>
                        <xsl:value-of
                            select="fn:highlight-ns(parent::rule/@context)" />
                    </code>
                </div>
                <div>
                    <xsl:text expand-text="true">{local-name()}: </xsl:text>
                    <code>
                        <xsl:value-of
                            select="fn:highlight-ns(@test)" />
                    </code>
                </div>
                <div>
                    <xsl:text>role: </xsl:text>
                    <xsl:choose>
                        <xsl:when
                            test="@role">
                            <code>
                                <xsl:value-of
                                    select="@role" />
                            </code>
                        </xsl:when>
                        <xsl:otherwise>
                            <span
                                class="missing">not specified</span>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
                <div>
                    <xsl:text>text: </xsl:text>
                    <code>
                        <xsl:value-of
                            select="
                                replace(
                                normalize-space(serialize(
                                node(), map {
                                    'method': 'xml',
                                    'omit-xml-declaration': true()
                                }
                                )), 'xmlns:.+=&quot;[^&quot;]+&quot;', '')" />
                    </code>
                </div>
                <xsl:if
                    test="preceding-sibling::p[1]">
                    <div>
                        <xsl:text>rule: </xsl:text>
                        <xsl:text>the context item </xsl:text>
                        <i>
                            <xsl:value-of
                                select="preceding-sibling::p[1]" />
                        </i>
                    </div>
                </xsl:if>
                <xsl:if
                    test="@diagnostics">


                    <xsl:variable
                        as="node()"
                        name="context"
                        select="root()" />
                    <xsl:for-each
                        select="tokenize(@diagnostics, '\s+')">
                        <div>
                            <xsl:text>diagnostic: </xsl:text>
                            <code>
                                <xsl:value-of
                                    select="." />
                            </code>
                            <xsl:text>: </xsl:text>
                            <i>
                                <xsl:value-of
                                    select="$context//diagnostic[@id = current()]" />
                            </i>
                        </div>
                    </xsl:for-each>


                </xsl:if>
            </td>

        </tr>
    </xsl:template>

    <xsl:template
        match="value-set"
        xpath-default-namespace="https://fedramp.gov/ns/oscal">
        <tr>
            <td>
                <xsl:attribute
                    name="rowspan"
                    select="
                        if (exists(remarks)) then
                            3
                        else
                            2" />
                <div>
                    <code>
                        <xsl:value-of
                            select="@name" />
                    </code>
                </div>
            </td>
            <td>
                <xsl:for-each
                    select="allowed-values/enum">
                    <div>
                        <code>
                            <xsl:value-of
                                select="@value" />
                        </code>
                    </div>
                </xsl:for-each>
                <xsl:if
                    test="allowed-values/@allow-other = 'yes'">
                    <div>
                        <i>or any other value</i>
                    </div>
                </xsl:if>
            </td>
            <td>
                <xsl:for-each
                    select="binding">
                    <div>
                        <code>
                            <xsl:copy-of
                                select="fn:highlight(@pattern, parent::node()/@name)" />
                        </code>
                    </div>
                </xsl:for-each>
            </td>
        </tr>
        <tr>
            <td
                colspan="2">
                <u>
                    <xsl:value-of
                        select="formal-name" />
                </u>
                <xsl:text>: </xsl:text>
                <i>
                    <xsl:value-of
                        select="description" />
                </i>
            </td>
        </tr>
        <xsl:if
            test="remarks">
            <tr>
                <td
                    colspan="2">
                    <xsl:text>Remarks: </xsl:text>
                    <xsl:value-of
                        select="remarks" />
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <xsl:template
        match="extensions/constraint"
        xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
        <tr>
            <td>
                <xsl:attribute
                    name="rowspan"
                    select="
                        if (exists(remarks)) then
                            3
                        else
                            2" />
                <div>
                    <code>
                        <xsl:value-of
                            select="@name" />
                    </code>
                </div>
            </td>
            <td>
                <xsl:for-each
                    select="allowed-values/enum">
                    <div>
                        <code>
                            <xsl:value-of
                                select="@value" />
                        </code>
                    </div>
                </xsl:for-each>
            </td>
            <td>
                <xsl:for-each
                    select="binding">
                    <div>
                        <code>
                            <xsl:copy-of
                                select="fn:highlight(@pattern, parent::node()/@name)" />
                        </code>
                    </div>
                </xsl:for-each>
            </td>
        </tr>
        <tr>
            <td
                colspan="2">
                <u>
                    <xsl:value-of
                        select="formal-name" />
                </u>
                <xsl:text>: </xsl:text>
                <i>
                    <xsl:value-of
                        select="description" />
                </i>
            </td>
        </tr>
        <xsl:if
            test="remarks">
            <tr>
                <td
                    colspan="2">
                    <xsl:text>Remarks: </xsl:text>
                    <xsl:value-of
                        select="remarks" />
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <xsl:template
        match="node()"
        priority="-1">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:function
        as="node()*"
        name="fn:highlight-ns">
        <xsl:param
            as="node()*"
            name="text" />
        <xsl:variable
            as="xs:string"
            name="frns-regex">
            <xsl:text>\[@ns='https://fedramp.gov/ns/oscal'\]|@ns = 'https://fedramp.gov/ns/oscal'</xsl:text>
        </xsl:variable>
        <xsl:choose>
            <xsl:when
                test="matches($text, $frns-regex)">
                <xsl:sequence>
                    <xsl:copy-of
                        select="$text" />
                    <span
                        class="NB">
                        <xsl:text> ☚ Note the </xsl:text>
                        <code>@ns</code>
                    </span>
                </xsl:sequence>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of
                    select="$text" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function
        as="node()*"
        name="fn:highlight">
        <xsl:param
            as="xs:string"
            name="text"
            required="true" />
        <xsl:param
            as="xs:string"
            name="target"
            required="true" />
        <xsl:variable
            as="xs:string"
            name="frns-regex">
            <xsl:text>\[@ns='https://fedramp.gov/ns/oscal'\]|@ns = 'https://fedramp.gov/ns/oscal'</xsl:text>
        </xsl:variable>
        <xsl:choose>
            <xsl:when
                test="matches($text, $target)">
                <xsl:analyze-string
                    regex="^(.*)({$target})(.*)$"
                    select="$text">
                    <xsl:matching-substring>
                        <xsl:value-of
                            select="regex-group(1)" />
                        <span
                            class="highlight">
                            <xsl:value-of
                                select="regex-group(2)" />
                        </span>
                        <xsl:value-of
                            select="regex-group(3)" />
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:otherwise>
                <span
                    class="highlight-missed">
                    <xsl:value-of
                        select="$text" />
                </span>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if
            test="matches($text, $frns-regex)">
            <span
                class="NB">
                <xsl:text> ☚ Note the </xsl:text>
                <code>@ns</code>
            </span>
        </xsl:if>
    </xsl:function>
</xsl:stylesheet>
