# 11. DNS validation within Schematron

Date: 2022-04-08

## Status

Proposed

## Context

Some validations require DNS queries to be performed from within Schematron.

There are public DNS services which provide DNS over HTTPS (DoH) with responses in JSON format.
([RFC8484](https://datatracker.ietf.org/doc/html/rfc8484)'s wire format is non-trivial to implement in pure Schematron.)

JSON response format is compatible with the XPath functions `unparsed-text()` and `unparsed-text-available()`

- There is no normative specification for DoH with JSON.
- Google and Cloudflare have DoH services with equivalent APIs.
- Both have high availability via anycast.
- Both are established companies.
- Both DNS services have been available for several years.
- Both DNS services are widely used
- Both DNS services support all DNS resource record (RR) types.

### Proof of Concept

The following Schematron code sample was used to test DoH with JSON response.

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

- The Google Public DNS [Terms of Service](https://developers.google.com/speed/public-dns/terms) are acceptable for our intended use.
- The Google Public DNS [Privacy Statement](https://developers.google.com/speed/public-dns/privacy) is acceptable for our intended use.
- The Google Public DNS response time is acceptable for our use. Sub-second response time was observed.

See also [0010-remote-resource-usage](0010-remote-resource-usage.md) for usage considerations.

## Consequences

The Comcast DoH service can be substituted if the need arises - the API is the same as Google DoH.