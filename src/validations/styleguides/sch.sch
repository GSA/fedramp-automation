<?xml version="1.0" encoding="UTF-8"?>
<?xml-model schematypens="http://purl.oclc.org/dsdl/schematron" href="sch.sch" phase="basic" title="Schematron Style Guide for FedRAMP Validations" ?>
<sch:schema
    defaultPhase="advanced"
    queryBinding="xslt2"
    xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
    xmlns:feddoc="http://us.gov/documentation/federal-documentation"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:unit="http://us.gov/testing/unit-testing"
    xmlns:x="http://www.jenitennison.com/xslt/xspec">

    <sch:ns
        prefix="sch"
        uri="http://purl.oclc.org/dsdl/schematron" />

    <sch:ns
        prefix="doc"
        uri="https://fedramp.gov/oscal/fedramp-automation-documentation" />

    <sch:ns
        prefix="feddoc"
        uri="http://us.gov/documentation/federal-documentation" />

    <sch:ns
        prefix="unit"
        uri="http://us.gov/testing/unit-testing" />

    <sch:ns
        prefix="x"
        uri="http://www.jenitennison.com/xslt/xspec" />

    <sch:phase
        id="basic">
        <sch:active
            pattern="basic-schematron" />
        <sch:active
            pattern="punctuation" />
    </sch:phase>

    <sch:phase
        id="advanced">
        <sch:active
            pattern="basic-schematron" />
        <sch:active
            pattern="punctuation" />
        <sch:active
            pattern="test-coverage" />
    </sch:phase>

    <sch:phase
        id="FedRAMP">
        <sch:active
            pattern="basic-schematron" />
        <sch:active
            pattern="punctuation" />
        <sch:active
            pattern="test-coverage" />
        <sch:active
            pattern="FedRAMP-extensions" />
    </sch:phase>

    <doc:xspec
        href="../test/styleguides/sch.xspec" />

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
                diagnostics="context-reuse-diagnostic"
                id="context-reuse"
                role="warning"
                test="
                    every $r in (parent::sch:pattern/sch:rule except current())
                        satisfies $r/@context ne current()/@context">There are no sch:rule contexts used more than once within a
                pattern.</sch:assert>

        </sch:rule>

        <sch:rule
            context="sch:assert">

            <sch:assert
                diagnostics="has-id-attribute-diagnostic"
                id="has-id-attribute"
                role="error"
                sqf:fix="add-id"
                test="exists(@id)">Every Schematron assertion has an id.</sch:assert>

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
                role="error"
                sqf:fix="add-role"
                test="exists(@role)">Every Schematron assertion has a role.</sch:assert>

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
                diagnostics="has-allowed-role-attribute-diagnostic"
                id="has-allowed-role-attribute"
                role="error"
                sqf:fix="add-role"
                test="@role = ('information', 'warning', 'error', 'fatal')">Every Schematron assertion has an allowed role.</sch:assert>

            <sch:assert
                diagnostics="has-diagnostics-attribute-diagnostic"
                id="has-diagnostics-attribute"
                role="error"
                sqf:fix="add-diagnostics-attribute"
                test="exists(@diagnostics)">Every Schematron assertion has diagnostics.</sch:assert>

            <sqf:fix
                id="add-diagnostics-attribute">
                <sqf:description>
                    <sqf:title>Add the @diagnostics attribute</sqf:title>
                    <sqf:p>An assertion's message explain what is required. The diagnostic explains what is incorrect and how to correct it.</sqf:p>
                </sqf:description>
                <sqf:add
                    node-type="attribute"
                    select="concat(@id, '-diagnostic')"
                    target="diagnostics" />
            </sqf:fix>

            <sch:assert
                diagnostics="diagnostic-defined-diagnostic"
                id="diagnostic-defined"
                role="error"
                sqf:fix="add-diagnostic-element"
                test="
                    every $d in tokenize(@diagnostics, '\s+')
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
                    match="//sch:diagnostic[last()]"
                    node-type="element"
                    position="after"
                    select="."
                    target="{message}" />
            </sqf:fix>

        </sch:rule>

        <sch:rule
            context="sch:diagnostic">

            <sch:report
                diagnostics="diagnostic-is-referenced-diagnostic"
                id="diagnostic-is-referenced"
                role="information"
                test="not(@id = //@diagnostics ! tokenize(., '\s+'))">A diagnostic message is referenced by an assertion.</sch:report>

        </sch:rule>

    </sch:pattern>

    <sch:pattern
        id="punctuation">

        <sch:rule
            context="sch:assert | sch:diagnostic">

            <sch:assert
                diagnostics="has-punctuation-diagnostic"
                id="has-punctuation"
                role="error"
                sqf:fix="add-punctuation"
                test="ends-with(normalize-space(.), '.')">Every assertion message is terminated by a period.</sch:assert>

            <sqf:fix
                id="add-punctuation">
                <sqf:description>
                    <sqf:title>Add the required punctuation</sqf:title>
                </sqf:description>
                <sqf:stringReplace
                    regex="$">.</sqf:stringReplace>
            </sqf:fix>

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
                test="exists(doc:xspec/@href)">Has reference to XSpec document.</sch:assert>

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

            <!-- Provide unit test statistics -->
            <sch:let
                name="assertions"
                value="//(sch:assert)" />
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
            <sch:let
                name="assertions-without-unitoverride"
                value="$assertions[not(@unit:override-xspec)]" />
            <sch:let
                name="coverage-without-unitoverride"
                value="count($referenced-tests) div (count($assertions-without-unitoverride) * 2)" />
            <sch:report
                diagnostics="report-test-coverage-without-unitoverride-diagnostic"
                id="report-test-coverage-without-unitoverride"
                role="information"
                test="true()">Excluding assertions designated as not having xspec tests, there are <sch:value-of
                    select="count($assertions-without-unitoverride)" /> assertions and there are <sch:value-of
                    select="count($referenced-tests)" /> unit tests which reference those assertions for test coverage of <sch:value-of
                    select="format-number($coverage-without-unitoverride, '09.99%')" />.</sch:report>
            <sch:report
                diagnostics="report-test-coverage-diagnostic"
                id="report-test-coverage"
                role="information"
                test="true()">There are <sch:value-of
                    select="count($assertions)" /> total assertions and there are <sch:value-of
                    select="count($referenced-tests)" /> unit tests which reference those assertions for test coverage of <sch:value-of
                    select="format-number($coverage, '09.99%')" />.</sch:report>
        </sch:rule>

        <sch:rule
            context="sch:assert">

            <sch:assert
                diagnostics="has-xspec-affirmative-test-diagnostic"
                id="has-xspec-affirmative-test"
                role="warning"
                test="
                    if (matches(lower-case(current()/@unit:override-xspec), 'aff|both'))
                    then
                        (true())
                    else
                        ($xspec//x:expect-not-assert[@id = current()/@id])">Every Schematron assertion has an XSpec test for the
                affirmative assertion outcome.</sch:assert>

            <sch:assert
                diagnostics="has-xspec-negative-test-diagnostic"
                id="has-xspec-negative-test"
                role="warning"
                test="
                    if (matches(lower-case(current()/@unit:override-xspec), 'neg|both'))
                    then
                        (true())
                    else
                        ($xspec//x:expect-assert[@id = current()/@id])">Every Schematron assertion has an XSpec test for the negative
                assertion outcome.</sch:assert>

        </sch:rule>

    </sch:pattern>

    <sch:pattern
        id="FedRAMP-extensions">

        <sch:rule
            context="sch:assert">

            <sch:assert
                diagnostics="has-doc-guide-reference-diagnostic"
                id="has-doc-guide-reference"
                role="warning"
                test="exists(@doc:guide-reference)">Every assertion has a doc:guide-reference attribute.</sch:assert>

            <sch:assert
                diagnostics="has-doc-template-reference-diagnostic"
                id="has-doc-template-reference"
                role="warning"
                test="exists(@doc:template-reference)">Every assertion has a doc:template-reference attribute.</sch:assert>

            <sch:assert
                diagnostics="has-doc-checklist-reference-diagnostic"
                id="has-doc-checklist-reference"
                role="warning"
                test="exists(@doc:checklist-reference)">Every assertion has a doc:checklist-reference attribute.</sch:assert>

            <sch:assert
                diagnostics="has-feddoc-documentation-diagnostic"
                id="has-feddoc-documentation"
                role="warning"
                test="exists(@feddoc:documentation-reference)">Every assertion has a feddoc:documentation-reference attribute.</sch:assert>

        </sch:rule>

        <sch:rule
            context="sch:diagnostic">

            <sch:assert
                diagnostics="has-doc-assertion-attribute-diagnostic"
                id="has-doc-assertion-attribute"
                role="warning"
                test="exists(@doc:assertion)">Every diagnostic has a doc:assertion attribute.</sch:assert>

            <sch:assert
                diagnostics="has-doc-context-attribute-diagnostic"
                id="has-doc-context-attribute"
                role="warning"
                test="exists(@doc:context)">Every diagnostic has a doc:context attribute.</sch:assert>

        </sch:rule>

    </sch:pattern>

    <sch:diagnostics>

        <sch:diagnostic
            id="xspec-resolved-uri-diagnostic">This is informational message (not an error).</sch:diagnostic>

        <sch:diagnostic
            id="report-test-coverage-diagnostic">This is informational message (not an error).</sch:diagnostic>
        
        <sch:diagnostic
            id="report-test-coverage-without-unitoverride-diagnostic">This is informational message (not an error).</sch:diagnostic>

        <sch:diagnostic
            id="context-reuse-diagnostic">This sch:rule context is used elsewhere. This can cause XSpec evaluation problems.</sch:diagnostic>

        <sch:diagnostic
            id="has-id-attribute-diagnostic">This assertion lacks the id attribute.</sch:diagnostic>

        <sch:diagnostic
            id="has-role-attribute-diagnostic"><sch:value-of
                select="name()" /> id="<sch:value-of
                select="@id" />" lacks the role attribute.</sch:diagnostic>

        <sch:diagnostic
            id="has-allowed-role-attribute-diagnostic"><sch:value-of
                select="name()" /> id="<sch:value-of
                select="@id" />" has an invalid role attribute.</sch:diagnostic>

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
            id="diagnostic-is-referenced-diagnostic">Diagnostic "<sch:value-of
                select="@id" />" is not referenced.</sch:diagnostic>

        <sch:diagnostic
            id="XPath">XPath: The context for this error is <sch:value-of
                select="replace(path(), 'Q\{[^\{]+\}', '')" />.</sch:diagnostic>

        <sch:diagnostic
            id="has-doc-guide-reference-diagnostic">This assertion lacks a doc:guide-reference attribute.</sch:diagnostic>

        <sch:diagnostic
            id="has-doc-template-reference-diagnostic">This assertion lacks a doc:template-reference attribute.</sch:diagnostic>

        <sch:diagnostic
            id="has-doc-checklist-reference-diagnostic">This assertion lacks a doc:checklist-reference attribute.</sch:diagnostic>

        <sch:diagnostic
            id="has-feddoc-documentation-diagnostic">This assertion lacks a feddoc:documentation-reference attribute.</sch:diagnostic>

        <sch:diagnostic
            id="has-doc-assertion-attribute-diagnostic">This diagnostic lacks a doc:assertion attribute.</sch:diagnostic>

        <sch:diagnostic
            id="has-doc-context-attribute-diagnostic">This diagnostic lacks a doc:context attribute.</sch:diagnostic>

    </sch:diagnostics>

</sch:schema>
