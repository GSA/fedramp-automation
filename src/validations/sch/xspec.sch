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

    <sch:pattern>

        <sch:rule
            context="x:description">

            <sch:report
                role="information"
                test="true()"><sch:value-of
                    select="/x:description/@schematron" /> is <sch:value-of
                    select="
                        if (doc-available(/x:description/@schematron)) then
                            'available'
                        else
                            'unavailable'" /></sch:report>

            <sch:assert
                test="doc-available(@schematron)">Schematron document is available.</sch:assert>

            <sch:report
                test="true()"><sch:value-of
                    select="/x:description/@schematron" /> has assertions <sch:value-of
                    select="doc(/x:description/@schematron)//sch:assert/@id" /></sch:report>

            <sch:report
                test="true()">
                <sch:value-of
                    select="count(doc(/x:description/@schematron)//sch:assert/@id)" /> assertions; <sch:value-of
                    select="count(//x:expect-not-assert/@id)" /> affirmative tests; <sch:value-of
                    select="count(//x:expect-assert/@id)" /> negative tests</sch:report>

            <sch:assert
                diagnostics="missing-affirmative-test"
                id="has-affirmative-tests"
                test="
                    every $id in doc(/x:description/@schematron)//sch:assert/@id
                        satisfies $id = //x:expect-not-assert/@id">Every Schematron assertion has a counterpart affirmative
                test</sch:assert>

            <sch:assert
                diagnostics="missing-negative-test"
                id="has-negative-test"
                test="
                    every $id in doc(/x:description/@schematron)//sch:assert/@id
                        satisfies $id = //x:expect-assert/@id">Every Schematron assertion has a counterpart negative test</sch:assert>

        </sch:rule>

    </sch:pattern>

    <sch:diagnostics>
        <sch:diagnostic
            id="missing-affirmative-test">The following <sch:value-of
                select="
                    count(doc(/x:description/@schematron)//sch:assert[current()/@id != //x:expect-not-assert/@id]/@id)" /> assertions lack an affirmative test: <sch:value-of
                        select="for $id in doc(/x:description/@schematron)//sch:assert/@id return if ($id != //x:expect-not-assert/@id) then $id else ''
                    " /></sch:diagnostic>
        <sch:diagnostic
            id="missing-negative-test">The following assertions lack a negative test: <sch:value-of
                select="
                    doc(/x:description/@schematron)//sch:assert[
                    not(current()/@id = //x:expect-assert/@id)
                    ]/@id" /></sch:diagnostic>
    </sch:diagnostics>

</sch:schema>
