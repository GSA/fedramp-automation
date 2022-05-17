<?xml version="1.0" encoding="UTF-8"?>
<?xml-model schematypens="http://purl.oclc.org/dsdl/schematron" href="sch.sch" ?>
<sch:schema
    queryBinding="xslt2"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:x="http://www.jenitennison.com/xslt/xspec">

    <sch:ns
        prefix="sch"
        uri="http://purl.oclc.org/dsdl/schematron" />

    <sch:ns
        prefix="x"
        uri="http://www.jenitennison.com/xslt/xspec" />


    <sch:let
        name="xspec"
        value="/" />

    <sch:let
        name="resolved-schematron-uri"
        value="resolve-uri(/x:description/@schematron, document-uri(/))" />

    <sch:let
        name="schematron"
        value="
            if (doc-available($resolved-schematron-uri)) then
                doc($resolved-schematron-uri)
            else
                ()" />

    <sch:pattern>

        <sch:rule
            context="x:description">

            <sch:report
                role="information"
                test="true()">resolved Schematron URI is <sch:value-of
                    select="$resolved-schematron-uri" /></sch:report>

            <sch:report
                role="information"
                test="true()"><sch:value-of
                    select="count(//$schematron//sch:assert/@id)" /> Schematron assertions</sch:report>

            <sch:report
                role="information"
                test="true()"><sch:value-of
                    select="count(//x:expect-not-assert/@id)" /> expect-not-assert tests</sch:report>

            <sch:report
                role="information"
                test="true()"><sch:value-of
                    select="count(//x:expect-assert/@id)" /> expect-assert tests</sch:report>

            <sch:assert
                diagnostics="schematron-document-available-diagnostic"
                id="schematron-document-available"
                role="fatal"
                test="doc-available($resolved-schematron-uri)">Schematron document is available.</sch:assert>

            <sch:assert
                diagnostics="lacks-affirmative-test"
                id="has-affirmative-test"
                role="warning"
                test="
                    (: FIXME: force true until missing XSpec test designation is complete :)
                    true() or
                    (every $id in $schematron//sch:assert/@id
                        satisfies $id = //x:expect-not-assert/@id)">Every Schematron assertion has a counterpart affirmative
                test.</sch:assert>

            <sch:assert
                diagnostics="lacks-negative-test"
                id="has-negative-test"
                role="warning"
                test="
                    (: FIXME: force true until missing XSpec test designation is complete :)
                    true() or
                    (every $id in $schematron//sch:assert/@id
                        satisfies $id = //x:expect-assert/@id)">Every Schematron assertion has a counterpart negative
                test.</sch:assert>

        </sch:rule>

    </sch:pattern>

    <sch:diagnostics>

        <sch:diagnostic
            id="schematron-document-available-diagnostic"><sch:value-of
                select="@schematron" /><sch:value-of
                select="resolve-uri(@schematron, document-uri(/))" /> is not available.</sch:diagnostic>

        <sch:diagnostic
            id="lacks-affirmative-test">Some Schematron assertion lacks a counterpart affirmative test.</sch:diagnostic>

        <sch:diagnostic
            id="lacks-negative-test">Some Schematron assertion lacks a counterpart negative test.</sch:diagnostic>

    </sch:diagnostics>

</sch:schema>
