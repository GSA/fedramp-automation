<?xml version="1.0" encoding="UTF-8"?>
<?xml-model schematypens="http://purl.oclc.org/dsdl/schematron" href="sch.sch" phase="basic" title="Schematron Style Guide for FedRAMP Validations" ?>
<sch:schema
    defaultPhase="basic"
    queryBinding="xslt2"
    xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:x="http://www.jenitennison.com/xslt/xspec"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <sch:ns
        prefix="sch"
        uri="http://purl.oclc.org/dsdl/schematron" />

    <sch:ns
        prefix="doc"
        uri="https://fedramp.gov/oscal/fedramp-automation-documentation" />

    <sch:ns
        prefix="x"
        uri="http://www.jenitennison.com/xslt/xspec" />

    <sch:phase
        id="basic">
        <sch:active
            pattern="basic-schematron" />
    </sch:phase>

    <sch:phase
        id="advanced">
        <sch:active
            pattern="test-coverage" />
        <sch:active
            pattern="FedRAMP-extensions" />
    </sch:phase>

    <doc:xspec
        href="../test/sch.xspec" />

    <sch:let
        name="xspec-uri"
        value="resolve-uri(/sch:schema/doc:xspec/@href, base-uri())" />
    <sch:let
        name="xspec-available"
        value="doc-available($xspec-uri)" />
    <sch:let
        name="xspec"
        value="
            if ($xspec-available) then
                doc($xspec-uri)
            else
                ()" />

    <sch:pattern
        id="basic-schematron">

        <sch:rule
            context="sch:rule">

            <sch:assert
                role="warning"
                id="context-reuse"
                diagnostics="context-reuse-diagnostic"
                test="
                    every $r in (//sch:rule except current())
                        satisfies $r/@context ne current()/@context">There are no sch:rule contexts used more than once.</sch:assert>

        </sch:rule>

        <sch:rule
            context="sch:assert | sch:report">

            <sch:assert
                diagnostics="has-id-attribute-diagnostic"
                id="has-id-attribute"
                role="error"
                sqf:fix="add-id"
                test="@id">Every Schematron assertion has an id.</sch:assert>

            <sqf:fix
                id="add-id">
                <sqf:description>
                    <sqf:title>Add the @id attribute</sqf:title>
                </sqf:description>
                <sqf:add
                    node-type="attribute"
                    target="id" />
            </sqf:fix>

            <sch:assert
                diagnostics="has-role-attribute-diagnostic"
                id="has-role-attribute"
                role="warning"
                sqf:fix="add-role"
                test="@role">Every Schematron assertion has a role.</sch:assert>

            <sqf:fix
                id="add-role">
                <sqf:description>
                    <sqf:title>Add the @role attribute</sqf:title>
                </sqf:description>
                <sqf:add
                    node-type="attribute"
                    target="role" />
            </sqf:fix>

            <sch:assert
                diagnostics="has-diagnostics-attribute-diagnostic"
                id="has-diagnostics-attribute"
                role="warning"
                sqf:fix="add-diagnostics-attribute"
                test="local-name() eq 'report' or @diagnostics">Every Schematron assertion has diagnostics.</sch:assert>

            <sqf:fix
                id="add-diagnostics-attribute">
                <sqf:description>
                    <sqf:title>Add the @diagnostics attribute</sqf:title>
                    <sqf:p>An assertion's message explain what is required. The diagnostic explains what is incorrect and how to correct it.</sqf:p>
                </sqf:description>
                <sqf:add
                    node-type="attribute"
                    target="diagnostics"
                    select="concat(@id, '-diagnostic')" />
            </sqf:fix>

            <sch:assert
                role="error"
                id="diagnostic-defined"
                diagnostics="diagnostic-defined-diagnostic"
                sqf:fix="add-diagnostic-element"
                test="
                    every $d in tokenize(@diagnostics)
                        satisfies exists(//sch:diagnostic[@id eq $d])">Every diagnostics attribute IDREF has a corresponding
                diagnostic element.</sch:assert>

            <sqf:fix
                id="add-diagnostic-element">
                <sqf:description>
                    <sqf:title>Add a diagnostic element for a dangling reference</sqf:title>
                    <sqf:p>If a diagnostics attribute is found on a Schematron assert that is bound to a diagnostic id, that diagnostic must be
                        defined.</sqf:p>
                </sqf:description>
                <sqf:user-entry
                    name="message">
                    <sqf:description>
                        <sqf:title>Enter the diagnostic message.</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:add
                    node-type="element"
                    match="//sch:diagnostic[last()]"
                    position="after"
                    select="."
                    target="{message}" />
            </sqf:fix>

        </sch:rule>

        <sch:rule
            context="sch:assert | sch:report | sch:diagnostic">

            <sch:assert
                diagnostics="has-punctuation-diagnostic"
                id="has-punctuation"
                role="error"
                sqf:fix="add-punctuation"
                test="ends-with(., '.')">Every Schematron assertion has a message which is terminated with a period.</sch:assert>

            <sqf:fix
                id="add-punctuation">
                <sqf:description>
                    <sqf:title>Add the required punctuation</sqf:title>
                </sqf:description>
                <sqf:stringReplace
                    regex="$">.</sqf:stringReplace>
            </sqf:fix>

        </sch:rule>

        <sch:rule
            context="sch:diagnostic">
            <sch:assert
                id="diagnostic-is-referenced"
                role="warning"
                diagnostics="diagnostic-is-referenced-diagnostic"
                test="@id = //@diagnostics ! tokenize(., '\s+')" />
        </sch:rule>

    </sch:pattern>

    <sch:pattern
        id="test-coverage">


        <sch:rule
            context="sch:schema">

            <!-- A Schematron document must have a reference to the corresponding XSpec document -->
            <sch:assert
                diagnostics="has-xspec-reference-diagnostic"
                id="has-xspec-reference"
                role="error"
                test="doc:xspec/@href">Has reference to XSpec document.</sch:assert>

            <!-- report on absolute XSpec path -->
            <sch:report
                diagnostics="xspec-resolved-uri-diagnostic"
                id="xspec-resolved-uri"
                role="information"
                test="doc:xspec/@href">XSpec reference resolves to <sch:value-of
                    select="$xspec-uri" />. </sch:report>

            <!-- The corresponding XSpec document must be available -->
            <sch:assert
                diagnostics="has-xspec-diagnostic"
                id="has-xspec"
                role="error"
                test="$xspec-available">Referenced XSpec document is available.</sch:assert>

        </sch:rule>

        <sch:rule
            context="doc:xspec">

            <sch:assert
                diagnostics="has-xspec-affirmative-test-diagnostic"
                id="has-xspec-affirmative-test"
                role="warning"
                test="$xspec//x:expect-not-assert[@id = current()/@id]">Every Schematron assertion has an XSpec test for the affirmative assertion
                outcome.</sch:assert>

            <sch:assert
                diagnostics="has-xspec-negative-test-diagnostic"
                id="has-xspec-negative-test"
                role="warning"
                test="$xspec//x:expect-assert[@id = current()/@id]">Every Schematron assertion has an XSpec test for the negative assertion
                outcome.</sch:assert>

            <!-- Provide unit test statistics -->
            <sch:let
                name="assertions"
                value="//(sch:assert | sch:report)" />
            <sch:let
                name="assertion-ids"
                value="$assertions/@id" />
            <sch:let
                name="tests"
                value="$xspec//(x:expect-not-assert | x:expect-assert)[not(@pending)]" />
            <sch:let
                name="referenced-tests"
                value="$tests[@id = $assertion-ids]" />
            <sch:let
                name="coverage"
                value="count($referenced-tests) div (count($assertions) * 2)" />
            <sch:report
                id="report-test-coverage"
                role="information"
                diagnostics="report-test-coverage-diagnostic"
                test="true()">There are <sch:value-of
                    select="count($assertions)" /> assertions and there are <sch:value-of
                    select="count($referenced-tests)" /> unit tests which reference those assertions for test coverage of <sch:value-of
                    select="format-number($coverage, '09.99%')" />.</sch:report>

        </sch:rule>

    </sch:pattern>

    <sch:pattern
        id="FedRAMP-extensions">

        <sch:rule
            context="sch:assert">

            <sch:assert
                sqf:fix="insert-doc-reference-attribute"
                test="@doc:reference"
                role="warning"
                id="has-doc-reference">Every rule has a doc:reference attribute.</sch:assert>

            <sqf:fix
                id="insert-doc-reference-attribute">
                <sqf:description>
                    <sqf:title>Add a doc:reference attribute</sqf:title>
                </sqf:description>
                <sqf:user-entry
                    name="URI">
                    <sqf:description>
                        <sqf:title>Enter a URI</sqf:title>
                    </sqf:description>
                </sqf:user-entry>
                <sqf:add
                    match="."
                    node-type="attribute"
                    target="doc:reference"
                    select="'reference'" />
            </sqf:fix>

        </sch:rule>

    </sch:pattern>

    <sch:diagnostics>
        <sch:diagnostic
            id="xspec-defined-and-available-diagnostic">@href present and available.</sch:diagnostic>
        <sch:diagnostic
            id="xspec-resolved-uri-diagnostic">This is informational message (not an error).</sch:diagnostic>
        <sch:diagnostic
            id="report-test-coverage-diagnostic">This is informational message (not an error).</sch:diagnostic>
        <sch:diagnostic
            id="context-reuse-diagnostic">This sch:rule context is used elsewhere. This can cause XSpec evaluation problems.</sch:diagnostic>
        <sch:diagnostic
            id="has-id-attribute-diagnostic"><sch:value-of
                select="name()" /> id="<sch:value-of
                select="@id" />" lacks the id attribute.</sch:diagnostic>
        <sch:diagnostic
            id="has-role-attribute-diagnostic"><sch:value-of
                select="name()" /> id="<sch:value-of
                select="@id" />" lacks the role attribute.</sch:diagnostic>
        <sch:diagnostic
            id="has-diagnostics-attribute-diagnostic"><sch:value-of
                select="name()" /> id="<sch:value-of
                select="@id" />" lacks the diagnostics attribute.</sch:diagnostic>
        <sch:diagnostic
            id="has-punctuation-diagnostic"><sch:value-of
                select="name()" /> id="<sch:value-of
                select="@id" />" text does not end with a period.</sch:diagnostic>
        <sch:diagnostic
            id="diagnostic-defined-diagnostic">This diagnostic message is missing.</sch:diagnostic>
        <sch:diagnostic
            id="has-xspec-reference-diagnostic"><sch:value-of
                select="name()" /> id="<sch:value-of
                select="@id" />" lacks an XSpec reference.</sch:diagnostic>
        <sch:diagnostic
            id="has-xspec-diagnostic"><sch:value-of
                select="name()" /> referenced XSpec document is not available.</sch:diagnostic>
        <sch:diagnostic
            id="has-xspec-affirmative-test-diagnostic"><sch:value-of
                select="name()" /> id="<sch:value-of
                select="@id" />" lacks an XSpec test for the affirmative assertion outcome.</sch:diagnostic>
        <sch:diagnostic
            id="has-xspec-negative-test-diagnostic"><sch:value-of
                select="name()" /> id="<sch:value-of
                select="@id" />" lacks an XSpec test for the negative assertion outcome.</sch:diagnostic>
        <sch:diagnostic
            id="diagnostic-is-referenced-diagnostic">diagnostic <sch:value-of
                select="@id" /> is not referenced.</sch:diagnostic>
        <sch:diagnostic
            id="XPath">XPath: The context for this error is <sch:value-of
                select="replace(path(), 'Q\{[^\{]+\}', '')" />.</sch:diagnostic>
    </sch:diagnostics>

</sch:schema>
