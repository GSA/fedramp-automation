<?xml version="1.0" encoding="UTF-8"?>
<?xml-model schematypens="http://purl.oclc.org/dsdl/schematron" href="sch.sch" ?>
<sch:schema
    queryBinding="xslt2"
    xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:x="http://www.jenitennison.com/xslt/xspec">

    <sch:ns
        prefix="sch"
        uri="http://purl.oclc.org/dsdl/schematron" />

    <sch:ns
        prefix="doc"
        uri="https://fedramp.gov/oscal/fedramp-automation-documentation" />

    <sch:ns
        prefix="x"
        uri="http://www.jenitennison.com/xslt/xspec" />

    <doc:xspec
        href="sch.xspec" />

    <sch:pattern>

        <sch:rule
            context="sch:schema">

            <!-- report on related XSpec reference -->
            <sch:report
                diagnostics="xspec-defined-and-available-diagnostic"
                id="xspec-defined-and-available"
                role="information"
                test="doc:xspec/@href">doc:xspec is defined and <sch:value-of
                    select="doc:xspec/@href" /> is <sch:value-of
                    select="
                        if (doc-available(doc:xspec/@href)) then
                            'available'
                        else
                            'unavailable'" />. </sch:report>

            <!-- report on absolute XSpec path -->
            <sch:report
                diagnostics="xspec-resolved-uri-diagnostic"
                id="xspec-resolved-uri"
                role="information"
                test="doc:xspec/@href"><sch:value-of
                    select="doc:xspec/@href" /> resolves to <sch:value-of
                    select="resolve-uri(doc:xspec/@href, base-uri())" />. </sch:report>

            <!-- An Schematron document must have a reference to the corresponding XSpec document -->
            <sch:assert
                diagnostics="has-xspec-reference-diagnostic"
                id="has-xspec-reference"
                role="info"
                test="doc:xspec/@href">Has reference <sch:value-of
                    select="doc:xspec/@href" /> to XSpec document.</sch:assert>

            <!-- The corresponding XSpec document must be available -->
            <sch:assert
                diagnostics="has-xspec-diagnostic"
                id="has-xspec"
                role="error"
                test="doc:xspec/@href and doc-available(doc:xspec/@href)">Referenced XSpec document is available.</sch:assert>

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
                sqf:fix="add-diagnostics"
                test="local-name() eq 'report' or @diagnostics">Every Schematron assertion has diagnostics.</sch:assert>

            <sqf:fix
                id="add-diagnostics">
                <sqf:description>
                    <sqf:title>Add the @diagnostics attribute</sqf:title>
                </sqf:description>
                <sqf:add
                    node-type="attribute"
                    target="diagnostics" />
            </sqf:fix>

            <sch:let
                name="xspec"
                value="doc(/sch:schema/doc:xspec/@href)" />
            <sch:assert
                diagnostics="has-xspec-affirmative-test-diagnostic"
                id="has-xspec-affirmative-test"
                role="warning"
                test="@id and doc(//doc:xspec/@href)//x:expect-not-assert[@id = current()/@id]">Every Schematron assertion has an XSpec test for the
                affirmative assertion outcome.</sch:assert>
            <sch:assert
                diagnostics="has-xspec-negative-test-diagnostic"
                id="has-xspec-negative-test"
                role="warning"
                test="@id and doc(//doc:xspec/@href)//x:expect-not-assert[@id = current()/@id]">Every Schematron assertion has an XSpec test for the
                negative assertion outcome.</sch:assert>

        </sch:rule>

        <sch:rule
            context="sch:assert | sch:report | sch:diagnostic">

            <sch:assert
                diagnostics="has-punctuation-diagnostic"
                id="has-punctuation"
                role="error"
                sqf:fix="add-punctuation"
                test="ends-with(., text()[last()])">Every Schematron assertion has a sentence which is terminated with a period.</sch:assert>

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

    <sch:diagnostics>
        <sch:diagnostic
            id="xspec-defined-and-available-diagnostic">@href present and available.</sch:diagnostic>
        <sch:diagnostic
            id="xspec-resolved-uri-diagnostic">@href resolves.</sch:diagnostic>
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
            id="has-xspec-reference-diagnostic"><sch:value-of
                select="name()" /> id="<sch:value-of
                select="@id" />" lack an XSpec reference.</sch:diagnostic>
        <sch:diagnostic
            id="has-xspec-diagnostic"><sch:value-of
                select="name()" /> id="<sch:value-of
                select="@id" />" referenced XSpec document is not available.</sch:diagnostic>
        <sch:diagnostic
            id="has-xspec-affirmative-test-diagnostic"><sch:value-of
                select="name()" /> id="<sch:value-of
                select="@id" />" lacks an XSpec test for the affirmative assertion outcome.</sch:diagnostic>
        <sch:diagnostic
            id="has-xspec-negative-test-diagnostic"><sch:value-of
                select="name()" /> id="<sch:value-of
                select="@id" />" lacks an XSpec test for the negative assertion outcome.</sch:diagnostic>
        <sch:diagnostic
            id="XPath">XPath: The context for this error is <sch:value-of
                select="replace(path(), 'Q\{[^\{]+\}', '')" />.</sch:diagnostic>
    </sch:diagnostics>

</sch:schema>
