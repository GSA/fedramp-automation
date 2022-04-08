# 11. DNS validation withion Schematron

Date: 2022-04-08

## Status

Proposed

## Context

Some validations require DNS queries to be performed from within Schematron.

There are public DNS services which provide DNS over HTTPS (DoH) with responses in JSON format.
([RFC8484](https://datatracker.ietf.org/doc/html/rfc8484)'s wire format is non-trivial to implement in pure Schematron.)
That is compatible with the XPath functions `unparsed-text()` and `unparsed-text-available()`

Google and Cloudflare have equivalent APIs. Both have high availability via anycast.

### Proof of Concept
```
<?xml version="1.0" encoding="UTF-8"?>
<sch:schema
    queryBinding="xslt2"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">

    <sch:ns
        prefix="array"
        uri="http://www.w3.org/2005/xpath-functions/array" />
    <sch:ns
        prefix="map"
        uri="http://www.w3.org/2005/xpath-functions/map" />

    <sch:pattern
        id="dnssec">

        <sch:let
            name="dnssec_href"
            value="'https://dns.google/resolve?name=fedramp.gov&amp;type=soa'" />

        <sch:let
            name="dnssec_data"
            value="unparsed-text($dnssec_href)" />

        <sch:rule
            context="/">

            <sch:report
                role="information"
                test="true()"><sch:value-of
                    select="$dnssec_data" /></sch:report>

            <sch:let
                name="response"
                value="parse-json($dnssec_data)" />

            <sch:report
                role="information"
                test="true()"><sch:value-of
                    select="map:keys($response)" /></sch:report>

            <sch:report
                role="information"
                test="true()">DNSSEC validated: <sch:value-of
                    select="$response?AD" /></sch:report>

        </sch:rule>

    </sch:pattern>

</sch:schema>
```

## Decision

Use [Google Public DNS](https://developers.google.com/speed/public-dns/docs/intro) via its 
[JSON API for DNS over HTTPS (DoH)](https://developers.google.com/speed/public-dns/docs/doh/json).

See also [0010-remote-resource-usage](0010-remote-resource-usage.md).

## Consequences
