---
title: FedRAMP OSCAL Guides
menu:
  primary:
    name: Documentation
    weight: 100
cascade:
  suppresstopiclist: true
  toc:
    display: true
  sidenav:
    activerenderdepth: 2
    inactiverenderdepth: 1
---

# FedRAMP OSCAL Guides

## Who Should Use These Guides?

These Guides are intended for technical staff and tool developers implementing solutions for importing, exporting, and manipulating Open Security Controls Assessment Language (OSCAL)-based FedRAMP System Security Plan (SSP) content.

It provides guidance and examples intended to guide an organization in the production and use of OSCAL-based FedRAMP-compliant SSP files. Our goal is to enable your organization to develop tools that will seamlessly ensure these standards are met so your security practitioners can focus on SSP content and accuracy rather than formatting and presentation.

Refer to the *Guide to OSCAL-based FedRAMP Content* for foundational information and core concepts.

<!-- <img style="float: right;" src="/img/refer-to.png"> -->

{{<callout>}}
  <span style="color: red">Refer to the [Guide to OSCAL-based Content](/guides) for foundational information and core concepts</span>
{{</callout>}}

## Related Documents
This document does not stand alone. It provides information specific to developing tools to create and manage OSCAL-based, FedRAMP-compliant SSPs. 

The [*Guide to OSCAL-based FedRAMP Content*](/guides), contains foundational information and core concepts, which apply to all OSCAL-based FedRAMP guides. This document contains several references to that content guide.

## Basic Terminology

XML and JSON use different terminology. Instead of repeatedly clarifying format-specific terminology, this document uses the following format-agnostic terminology through the document. 

|**TERM**|**XML EQUIVALENT**|**JSON EQUIVALENT**|
| :- | :- | :- |
|**Field**|A single element or node that can hold a value or an attribute|A single object that can hold a value or property|
|**Flag**|Attribute|Property|
|**Assembly**|A collection of elements or nodes. Typically, a parent node with one or more child nodes.|A collection of objects. Typically, a parent object with one or more child objects.|

These terms are used by National Institute of Standards and Technology (NIST) in the creation of OSCAL syntax.

Throughout this document, the following words are used to differentiate between requirements, recommendations, and options.

|**TERM**|**MEANING**|
| :- | :- |
|**must**|Indicates a required action.|
|**should**|Indicates a recommended action, but not necessarily required.|
|**may**|Indicates an optional action.|


## XML and JSON Formats

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

## OSCAL-based FedRAMP Templates

FedRAMP offers OSCAL-based templates in both XML and JSON formats for
the SSP, SAP, SAR, and POA&M. These templates contain many of the
FedRAMP required content and placeholders to help get you started. This
document is intended to work in concert with those templates. The
OSCAL-based FedRAMP templates are available here:

- [https://github.com/GSA/fedramp-automation/tree/master/dist/content/rev5/templates](https://github.com/GSA/fedramp-automation/tree/master/dist/content/rev5/templates)

## XML and JSON Technology Standards

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

### NIST OSCAL Syntax Validation Mechanisms

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

### NIST OSCAL Format Conversion Mechanisms

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

## XPath Queries and References

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

