# fedramp-automation usage examples

As a collection of validation rules for FedRAMP OSCAL documents, `fedramp-automation` is intended to be used by FedRAMP reviewers to ensure that the documents meet the requirements of the OSCAL standard with FedRAMP extensions. Additionally, validation rules can be integrated with third-party tools to ensure that documents meet FedRAMP requirements.

For the purposes of third-party integration, Schematron validation rules are provided in a compiled XSLT format. This repository includes usage examples that leverage appropriate Saxon XSLT libraries.

- [Python example](./python/README.md)
- [Java example](./java/README.md)
- [Javascript example](./javascript/README.md)

Additionally, these examples serve as basic automated tests of the validation suite over each of the implemented languages.

## General overview

- The source SSP rules defined in [../validations/rules/ssp.sch](../validations/rules/ssp.sch) are compiled into a single XSLT file, [../validations/target/rules/ssp.sch.xsl](../validations/target/rules/ssp.sch.xsl). Similar artifacts are produced for SAP, SAR, and POA&M rules.
- The compiled XSLT file must be evaluated by an XSLT 3.0 compatible processor. The [Saxon](https://www.saxonica.com/) suite of libraries are the only compatible XSLT 3.0 processors at the time of writing.
  - Java Saxon-HE is open-source and recommended.
  - Javascript Saxon-JS is free, but not open-source. The UI for this project may be referenced as an example.
  - .NET Saxon-HE is open-source. It requires .NET Framework (ie, not compatible with .NET Core).
  - Saxon/C is an open-source C-compatibility layer over the Java runtime. It has bindings for Python and PHP. The Python example in this directory utilizes Saxon/C with the Python extension.
- When evaluated, the XSLT output is an SVRL document (Schematron Validation Report Language). Failed assertions and diagnostic messages may be extracted from the SVRL using XPath. SVRL identifies the locus of the error in the source document via an XPath 3.0 location.

## Validation parameters

The Schematron rules support a number of parameters that can be applied via XSLT stylesheet parameters.

- `baselines-base-path` - Path to this repository's baselines. Default value is path relative to Schematron source document. Set to local or network root path. See: https://github.com/GSA/fedramp-automation/tree/master/dist/content/rev4/baselines/xml
- `registry-base-path` - Path to this repository's registry values. Default value is path relative to Schematron source document. Set to local or network root path. See: https://github.com/GSA/fedramp-automation/tree/master/dist/content/rev4/resources/xml
- `param-use-remote-resources` - Boolean, default False. If True, validate references to external resources, which may be remote.

# JSON support

OSCAL may be represented via both XML and JSON formats. The FedRAMP OSCAL validation rules, however, require XML. To validate a JSON OSCAL SSP, you must convert the JSON to XML. The OSCAL project provides an collection of JSON to XML converters, in the form of XSLT stylesheets, [available here](https://github.com/usnistgov/OSCAL/tree/main/xml#oscal-json-to-xml-converters).

Each of the examples (Java, Python, and Javascript) provide examples of usage of these stylesheets.

# Schematron Validation Report Language (SVRL)

The result of an evaluated Schematron ruleset is an XML document in SVRL format. This document includes failed assertions, diagnostic messages for each assertion, and the XPath selector that identifies the location of the deficiency in the source OSCAL document.

To browse a sample SVRL document, you may evaluate the sample SSP via the command-line. You may need to refer to [../validations/CONTRIBUTING.md](../validations/CONTRIBUTING.md) for set-up instructions first.

```bash
cd src/validations
./bin/validate_with_schematron.sh -f ./test/demo/FedRAMP-SSP-OSCAL-Template.xml
```

On success, the SVRL document will be available here: [../validations/report/schematron/test/demo/FedRAMP-SSP-OSCAL-Template.xml__ssp.results.xml](../validations/report/schematron/test/demo/FedRAMP-SSP-OSCAL-Template.xml__ssp.results.xml)

## SVRL reference

A number of notable SVRL elements are outlined below.

### //svrl:failed-assert

Failed assertions. Example:

```xml
<svrl:failed-assert test="./@media-type"
                    id="resource-base64-available-media-type"
                    role="error"
                    location="/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]/*:back-matt
er[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]/*:resource[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1
2]/*:base64[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]">
  <svrl:text>This base64 has a media-type attribute.</svrl:text>
  <svrl:diagnostic-reference diagnostic="resource-base64-available-media-type-diagnostic">
This base64 lacks a media-type attribute.</svrl:diagnostic-reference>
</svrl:failed-assert>
```

### //svrl:fired-rule

A reference that a Schematron rule fired, and its corresponding XPath context. Example:

```xml
<svrl:fired-rule context="/o:system-security-plan"/>
```

### //svrl:successful-report

Similar to `failed-assert`, but purely for informational reporting purposes. At time of writing, `fedramp-automation` utilizes reporting to extract metadata from the source SSP. Example:

```xml
<svrl:successful-report test="true()"
                        id="info-system-name"
                        role="information"
                        location="/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]">
  <svrl:text>System's Full Name</svrl:text>
</svrl:successful-report>
<svrl:successful-report test="true()"
                        id="info-ssp-title"
                        role="information"
                        location="/*:system-security-plan[namespace-uri()='http://csrc.nist.gov/ns/oscal/1.0'][1]">
  <svrl:text>FedRAMP System Security Plan (SSP)</svrl:text>
</svrl:successful-report>
```
