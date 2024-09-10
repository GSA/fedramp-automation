# fedramp-automation Python usage example

This is a simple example of how to use the fedramp-automation validation rules with `saxonc` and its Python bindings.

`saxonc` is not bundled for installation via PyPI; it is available for download from the Saxonica website, and must be built and installed manually. An example of this process may be found in the provided [Dockerfile](./Dockerfile).

This example is implemented as a [pytest](https://pytest.org/) module [./test_validate_oscal.py](./test_validate_oscal.py).
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

To run tests:

```bash
docker compose run example pytest
```

To auto-format code:

```bash
docker compose run example black
```

To type-check code:

```bash
docker compose run example mypy .
```
