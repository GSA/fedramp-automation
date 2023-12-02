---
title: FedRAMP OSCAL-Based Content Guide
heading: FedRAMP OSCAL-Based Content Guide
menu:
  primary:
    name: Content
    parent: Documentation
    weight: 50
toc:
  enabled: true
suppresstopiclist: true
---

## 1.4. XML and JSON Formats

The examples provided here are in XML; however, FedRAMP accepts XML or
JSON formatted OSCAL content. NIST offers the ability to convert
OSCAL-files between XML and JSON in either direction without data loss.

You may submit your SSP, SAP, SAR, and POA&M to FedRAMP using either XML
or JSON. If necessary, FedRAMP\'s tools will convert the files for
processing.

{{<callout>}}
_For more information on converting OSCAL files between XML and JSON, see Section 1.6.2, NIST OSCAL Format Conversion Mechanisms._
{{</callout>}}

NOTE: NIST partially supports _YAML_ (YAML) as an offshoot of JSON.
FedRAMP will evaluate the use of YAML for FedRAMP deliverables once NIST
offers the same level of support for YAML syntax validation and format
conversion.

## 1.5. OSCAL-based FedRAMP Templates

FedRAMP offers OSCAL-based templates in both XML and JSON formats for
the SSP, SAP, SAR, and POA&M. These templates contain many of the
FedRAMP required content and placeholders to help get you started. This
document is intended to work in concert with those templates. The
OSCAL-based FedRAMP templates are available here:

- [https://github.com/GSA/fedramp-automation/tree/master/dist/content/rev5/templates](https://github.com/GSA/fedramp-automation/tree/master/dist/content/rev5/templates)

## 1.6. XML and JSON Technology Standards

For OSCAL compliance, mechanisms that interpret or generate OSCAL
content must honor the core syntax described at
[https://pages.nist.gov/OSCAL/concepts/layer/](https://pages.nist.gov/OSCAL/concepts/layer/).

While not mandatory, organizations adopting OSCAL are strongly
encouraged to use the NIST-published validation and translation
mechanisms. The validation mechanism ensures XML and JSON files are
using OSCAL-compliant syntax, while the translation mechanism converts
OSCAL content from either format to the other. NIST has an automated
governance process, which ensures these mechanisms remain aligned with
the latest OSCAL syntax.

{{<callout>}}
_TIP: There are comments in the XML versions of the FedRAMP Templates. Unfortunately, JSON does not formally support comments. JSON users may wish to review the comments in the equivalent sections of the XML files._
{{</callout>}}

### 1.6.1. NIST OSCAL Syntax Validation Mechanisms

The latest version of NIST OSCAL schema validation files are always
available here:\
- XML:
[https://github.com/usnistgov/OSCAL/tree/main/xml/schema](https://github.com/usnistgov/OSCAL/tree/main/xml/schema)\
- JSON:
[https://github.com/usnistgov/OSCAL/tree/main/json/schema](https://github.com/usnistgov/OSCAL/tree/main/json/schema)

Validating XML-based OSCAL files using the NIST-published schema
validation requires:\
[XML Schema Definition Language (XSD) 1.1](https://www.w3.org/TR/xmlschema11-1/)

Validating JSON-based OSCAL files using the NIST-published schema
validation requires:\
[JSON Schema, draft-07](https://json-schema.org/specification-links.html%23draft-7)

There are several open-source and commercial tools that will process XSD 1.1 or JSON Schema, draft-07, either as stand-alone capabilities or as programming libraries. FedRAMP and NIST are unable to endorse specific products.

### 1.6.2. NIST OSCAL Format Conversion Mechanisms

The latest version of NIST OSCAL format conversion files are always
available here:\
- XML to JSON:
[https://github.com/usnistgov/OSCAL/tree/main/json/convert](https://github.com/usnistgov/OSCAL/tree/main/json/convert)\
- JSON to XML:
[https://github.com/usnistgov/OSCAL/tree/main/xml/convert](https://github.com/usnistgov/OSCAL/tree/main/xml/convert)

For more information on converting OSCAL files between supported
formats, please see the information at the following links:

- [OSCAL
  Converters](https://pages.nist.gov/OSCAL/concepts/layer/overview/#oscal-converters)

- [Converting OSCAL XML Content to
  JSON](https://github.com/usnistgov/OSCAL/tree/master/json#converting-oscal-xml-content-to-json)

- [Converting OSCAL JSON Content to
  XML](https://github.com/usnistgov/OSCAL/tree/master/xml#converting-oscal-json-content-to-xml)

## 1.7. XPath Queries and References

XPath is a standard query language for XML files, and libraries for
using it are available in many programming languages. Even if you do not
use XPath to query OSCAL data files, the XPath queries provide a concise
and non-ambiguous way to communicate where the data is located within
the file.

Except where noted, all XPath queries in this document are based on
XPath 2.0. Most modern programming languages make XPath 1.0 available by
default. XPath 2.0 can typically be added with third-party libraries or
calls to external command-line utilities.

{{<callout>}}
_JSON Users: There are several JSON query technologies available, such as [JSONPath](https://restfulapi.net/json-jsonpath/); however, no one technology has emerged as a clear standard as of this publication._
{{</callout>}}

Most XPath queries in this document are absolute paths from the root of
the document. In other words, it is clear from the XPath query which of
the major file sections described in Section 2.3 is being referenced,
and where the field is located within the section.

{{<callout>}}
_**Database Users**: Some tool developers prefer to manage OSCAL data by first importing it into a database, which is a perfectly acceptable approach. Any OSCAL file generated from the database must still follow the OSCAL syntax. If the file is intended for delivery to FedRAMP, it must also follow the guidance in these guides._

_There are also database-like XML servers, such as the open-source tool [BaseX](http://www.basex.org/), which allow OSCAL files to remain in their native format yet be queried more like a traditional database. These XML databases typically optimize queries for better performance. Some will handle both XML and JSON files._
{{</callout>}}
