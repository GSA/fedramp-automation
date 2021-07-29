# fedramp-automation Python usage example

This is a simple example of how to use the fedramp-automation Python library with `saxonc` and its Python bindings.

`saxonc` is not bundled for installation via PyPI; it is available for download from the Saxonica website, and must be build and installed manually. An example of this process may be found in the provided [Dockerfile](./Dockerfile).

## Usage

To get a bash prompt within the container, run:

```bash
docker-compose run python bash -l
```

You may now run and interact with the example code.

## Developer notes

To run tests:

```bash
docker-compose run python pytest
```

To auto-format code:

```bash
docker-compose run python black
```

To type-check code:

```bash
docker-compose run python mypy .
```
