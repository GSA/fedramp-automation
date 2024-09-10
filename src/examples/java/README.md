# fedramp-automation Java usage example

This is a simple example of how to use the fedramp-automation validation rules with the Java Saxon-HE library.

The implementation applies the project's compiled XSLT (`ssp.sch.xsl`, `sap.sch.xsl`, `sar.sch.xsl`, and `poam.sch.xsl`), to the demo documents (eg, [FedRAMP-SSP-OSCAL-Template.xml](../../../dist/content/rev4/templates/ssp/xml/FedRAMP-SSP-OSCAL-Template.xml)), and then extracts failed assertions from the resulting SVRL.

## Prerequisites

Compiled Schematron XSLT artifacts are required to run this example. The following command will build the artifact:

```bash
cd ../../..
make build-validations
```

## Usage

This example uses Maven. You may run directly, or via the provided `docker compose` configuration.

```bash
mvn --help
```

```bash
docker compose run example mvn --help
```

## Developer notes

To run tests:

```bash
docker compose run example mvn test
```

To auto-format code:

```bash
docker compose run example mvn com.coveo:fmt-maven-plugin:format
```
