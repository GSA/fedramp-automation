# fedramp-automation Java usage example

This is a simple example of how to use the fedramp-automation validation rules with the Java Saxon-HE library.

The implementation applies the project's compiled XSLT, `ssp.xsl`, to the demo [FedRAMP-SSP-OSCAL-Template.xml](../../../dist/content/templates/ssp/xml/FedRAMP-SSP-OSCAL-Template.xml) document, and then extracts failed assertions from the resulting SVRL.

## Prerequisites

A compiled Schematron XSLT artifact is required to run this example. The following command will build the artifact:

```bash
cd ../../..
make build-validations
```

## Usage

This example uses Maven. You may run directly, or via the provided `docker-compose` configuration.

```bash
mvn --help
```

```bash
docker-compose run example mvn --help
```

## Developer notes

To run tests:

```bash
docker-compose run example mvn test
```

To auto-format code:

```bash
docker-compose run example mvn com.coveo:fmt-maven-plugin:format
```
