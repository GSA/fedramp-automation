# fedramp-automation Javascript usage example

This is a simple example of how to use the fedramp-automation validation rules with `SaxonJS`.

`SaxonJS` is available in two forms:

- A node.js version, installable via npm: https://www.npmjs.com/package/saxon-js
- A browser version, which must be loaded via a `<script>` tag. See the SaxonJS documentation for more details: https://www.saxonica.com/saxon-js/index.xml

This example utilizes the node.js version. Usage in the browser is similar, with some subtle differences. The `fedramp-automation` web code base may be referenced as an example, in Typescript, that will run in both node.js and the browser. See: [../../web]([../../web])

## Prerequisites

Compiled Schematron XSLT artifacts are required to run this example. The following command will build the artifact:

```bash
cd ../../..
make build-validations
```

## Usage

To get a bash prompt within the container, run:

```bash
docker compose run example bash -l
```

You may now run and interact with the example code.

## Developer notes

To run tests, build the required Schematron XSLT to sef.json files and run the test script:

```bash
docker compose run example npm run ./test.sh
```

To auto-format code:

```bash
docker compose run example npm format
```
