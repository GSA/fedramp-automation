# 3. Use Saxon Home Edition XSLT and XML Processor for Developing and Executing Validations

Date: 2021-05-16

## Status

Accepted

## Context

[ADR 2](docs/adr/0002-xml-schematron-usage.md) documents the development team's decision to develop validation rules using Schematron and XSLT. The decision to use Schematron requires the selection of a XSLT processing engine. This engine must be able to transpile Schematron into XSLT stylesheets and execute the transformed XSLT stylesheets for development, unit testing, and integration efforts.

There are [only several reputable XSLT processors](https://en.wikipedia.org/wiki/XSLT#Processor_implementations) that exist for commercial and hobbyist use.

- Altova RaptorXML
- IBM Datapower (and its embedded XSLT processor)
- libxslt's `xmllint` command-line utility
- Microsoft's MSXML and the (Windows-only variant of the).NET Framework's XSLT processor in the `System.Xml` part of the standard library
- Saxon Java-based XML engine and XSLT processor
- Xalan Java-based XML engine and XSLT processor

## Decision

This project uses [Saxonica's](https://www.saxonica.com/download/java.xml) open-source Java variant, [the Saxon Home Edition XSLT processor](https://sourceforge.net/projects/saxon). As both the 9.x and 10.x major versions are in popular community use, the team develops and tests the validations against both. There are several reasons that motivate this decision.

- Many popular open-source projects that require XSLT processing use Saxon HE.
  - The original Schematron XSLT-based implementation [uses Saxon HE for development and testing](https://github.com/Schematron/schematron/blob/master/.travis.yml#L8).
  - The only competing Schematron implementation, developed to be operated natively in Java code, [uses Saxon HE in library form as its XSLT proceessor engine](https://github.com/phax/ph-schematron/blob/master/pom.xml#L92-L96).
- NIST developers rely on Saxon HE for [Metaschema](https://github.com/usnistgov/metaschema/blob/f6500012fac178d7f7266be72a5bb15d91abf2d0/scripts/include/init-saxon.sh) and [OSCAL development](https://github.com/usnistgov/OSCAL/blob/eaf1bf51d546dc0a21e6b98c1cdd0cb63f499057/docs/README.md#prerequisites). Alignment with their development toolchain simplifies ongoing development validations of OSCAL content and configuration data.
- Writing more complex XPath queries for Schematron path bindings is simplified by [the XPath 3.1 specification](https://www.w3.org/TR/xpath-31/). Saxon HE is the only open-source XSLT processor with [relatively complete support of XPath 3.1 syntax support](https://www.saxonica.com/documentation10/#!conformance/xpath31).
- Although Saxon HE is primarily developed in Java, the development has an established track-record of developing implementations of the Saxon engine for alternative languages and runtimes. Examples include [C-based library for use in Perl, PHP, and Python](https://www.saxonica.com/saxon-c/index.xml), as well as [Javascript runtime for use with either server-side NodeJS and browser-only execution](https://www.saxonica.com/saxon-js/index.xml).

## Consequences
- FedRAMP validation developers can choose to recommend or mandate Saxon HE as a requirement. In a subsequent decision in an ADR following this one, the development team can decide to constrain support options to a limited set of integration patterns for downstream developers to integrate the XSLT transform system via runtime APIs (as opposed to running a separate shell process and reading piped output).
- Downstream consumers of validations will need to evaluate whether or not to directly incorporate Saxon HE (the Java, C-based, or Javascript) runtime as a direct dependency or vet alternatives.
