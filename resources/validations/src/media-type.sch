<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    queryBinding="xslt2"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <!-- evaluate a media-type attribute for allowed values -->
    <sch:pattern>
        <sch:rule
            context="@media-type"
            role="error">
            <sch:let
                name="media-types-url"
                value="'media-types.xml'" />
            <sch:assert
                test="doc-available($media-types-url)">media-types document is available.</sch:assert>
            <sch:let
                name="media-types"
                value="doc($media-types-url)" />
            <sch:let
                name="media-types"
                value="$media-types//value-set[@name = 'media-type']//enum/@value" />
            <sch:assert
                test="count($media-types) &gt; 1">media-types have been correctly obtained.</sch:assert>
            <sch:assert
                diagnostics="has-allowed-media-type-diagnostic"
                id="has-allowed-media-type"
                role="error"
                test="current() = $media-types">A media-type attribute must have an allowed value.</sch:assert>
        </sch:rule>
    </sch:pattern>
    <sch:diagnostics>
        <sch:diagnostic
            id="has-allowed-media-type-diagnostic">This <sch:value-of
                select="name(parent::node())" /> has a media-type=" <sch:value-of
                select="current()" />" which is not in the list of allowed media types. Allowed media types are <sch:value-of
                select="string-join($media-types, ' ∨ ')" />.</sch:diagnostic>
    </sch:diagnostics>
</sch:schema>
