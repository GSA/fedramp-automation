# Validations

## Project Structure

All directory references are local to the `fedramp-automation/src/validations`

* `bin` has the validation script.
* `docs/adr` has a list of [Architectural Decision Records](https://adr.github.io) in which the product team documented technical decisions for the project.
* `report/test` for XSpec and SCH test outputs
* `report/schematron` for the final validations in Schematron SVRL reporting format.
* `rules` has the Schematron files for the SSP.
* `styleguides` for XSpec and Schematron styling Schematron.
* `target` for intermediary and complied artifacs, e.g. XSLT stylesheets, etc.
* `test` for any XSpec or other testing artifacts.
* `test/demo` has the demo XML file.

## Validate XML Files using Schematron

**Prerequesite**: *To ensure that you have all required dependencies (see .gitmodules), run the following command:*

```sh
git submodule update --init --recursive
```

### Validation Command

The command is:

```sh
./bin/validate_with_schematron.sh
```

It has many *optional* parameters. If the command is run without any parameters, it will download the **Saxon HE** JAR file in the `vendor` directory.

### Parameters

The validation command has many parameters; all parameters are *optional*.

`-f fileName` is the input file to be tested, ex: `-f test/demo/FedRAMP-SSP-OSCAL-Template.xml`. If omitted, the XSLT transform will be compiled, but it will not be applied to a document.
`-s directoryName` Schematron directory used to validate the file, ex: `-o ~/mySchematronDirectory`. Each `.sch` document found within the specified directory will be compliled and generate a separate report. If omitted, defaults to the src relative to the parent of the bin directory where this script is located.
`-o outputRootDirectory` is the root directory of the report output, ex: `-o ~/dev/report`.
`-v saxonVersionNumber` is used to override the default version (currently 10.8) of `SAXON HE`, that is downloaded and used if `SAXON_CP` is not specified, ex:  `-v 10.2`. *Note that if `SAXON_CP` is set as an environment variable and this parameter is specified, then the script will terminate due to inability to determine priority.*
`-b baseDirectory` specifies the base directory of the location of this project (for relative references to target, `bin` and dependencies like OSCAL definiitions), ex: `-b /dev/fedramp-automation/resources/validations`. If omitted, defaults to the current directory.
`-t` is used to skip the Schematron compilation and used for tranform-only.
`-h` outputs the help/usage for the script.

#### Example

A typical usage of the validation command:

```sh
./bin/validate_with_schematron.sh -f ./test/demo/FedRAMP-SSP-OSCAL-Template.xml -o ~/dev/report
```

Using the command with a different version of Saxon HE. *Note that you must download the different version first.*

```sh
./bin/validate_with_schematron.sh -v 10.8
./bin/validate_with_schematron.sh -f test/demo/FedRAMP-SSP-OSCAL-Template.xml -o ~/dev/report -v 10.8
```

Alternatively, you can also use `docker-compose` to execute the validation script, like so:

```sh
docker-compose run \
  -w /root/src/validations \
  validator \
  ./bin/validate_with_schematron.sh -f ./test/demo/FedRAMP-SSP-OSCAL-Template.xml
```

## Unit Test

Unit tests consist of:

- src/validations/test/*.xspec
- src/validations/styleguides/sch.sch

A make target is provided to run all unit tests:

```sh
# If you haven't done so previously: initialize your workspace.
make init
# Run xspec and Schematron tests
make test-validations
```

Alternately, you may follow the instructions below to run the tests manually.

### Running Unit Test

Run the unit tests from with `./fedramp-automation/src/validations` directory. The `SAXON_CP` and `TEST_DIR` environment variables must be set to the **Saxon HE** and test report directories, respectively. *Note that you may choose to run your preferred version of the Saxon HE JAR file.*

The following code assumes that the user is in the `./fedramp-automation/src/validations` directory.

```sh
export SAXON_CP=$(pwd)/../../vendor/Saxon-HE-10.5.jar
export TEST_DIR=$(pwd)/report/test
../../vendor/xspec/bin/xspec.sh -s -j test/test_all.xspec
```

The JUnit XML report will be stored in the path set in the `TEST_DIR` environment variable.

Alternatively, you can also use `docker-compose` to execute the test harness, like so:

```sh
docker-compose run \
  -w /root/src/validations \
  validator \
  /root/vendor/xspec/bin/xspec.sh -s -j ./test/test_all.xspec
```


### Rerunning Failed Tests

After running the full test suite, you may want to rerun only the failed tests for quicker debugging. To do this, you can use the following npm script:

```sh
npm run test:failed
```

This command will rerun only the tests that failed in the previous execution. It's particularly useful when you're fixing issues and want to verify that your changes have resolved the failures without running the entire test suite again.

Note: Make sure you've run the full test suite at least once before using this command, as it relies on the `@rerun.txt` file generated during the initial run.

## Adding tests to the harness

To add new tests, add an import to the `./test/test_all.xpec` file. For example:

```xml
<x:description schematron="../rules/ssp.sch"
               xmlns:x="http://www.jenitennison.com/xslt/xspec">
    <x:import href="ssp.xspec" />
    <x:import href="new_test.xspec" />
</x:description>
```

## Analyzing Changes to OSCAL Data Models to Update Rules

OSCAL has abstract information models that are converted into concrete data models into XML and JSON.

As a developer, you can look at individual OSCAL files that must conform to schemas for these data models, including SSPs, Components, SAPs, SARs, and POA&Ms. However, looking at individual examples for each respective model will be exhaustive and time-consuming.

The schemas for the models themselves are designed and programmatically [designed, cross-referenced between JSON and XML, and generated with appropriate schema validation tools by way of the NIST Metaschema project](https://pages.nist.gov/OSCAL/documentation/schema/overview/). Therefore, it is most prudent to focus analysis on the changes in the version-controlled Metaschema declarations, as they define the abstract information model. This information model is used to generate concrete data models in JSON and XML, to be validated by JSON Schema and XSD, respectively.

Developers ought to review the following relevant information sources, in order of least to most effort.

* [Release notes from the NIST OSCAL Development Team](https://github.com/usnistgov/OSCAL/blob/master/src/release/release-notes.md), where they summarize model changes in their own words from version to version.
* [XSLT "up-convert" transforms](https://github.com/usnistgov/OSCAL/tree/f44426e0ec14431b88833dbd381b5434d0892403/src/release/content-upgrade) give specific declarative detail on how to modify the OSCAL XML data models.
* The source code of the Metaschema models, filtering on the release tags. Developers can use the Github web interface to compare Metaschema files, [such as this example comparison between release candidate versions `1.0.0-rc1` and `1.0.0-rc2`](https://github.com/usnistgov/OSCAL/compare/v1.0.0-rc1...v1.0.0-rc2). Focus on the files in the `src/metaschema` directory.

Per [18F/fedramp-automation#61](https://github.com/18F/fedramp-automation/issues/61), programmatic diff utilities to semantically analyze the differences between OSCAL versions requires resources not available at this time.

### Formatting XML

When contributing, please use the following indentation and formatting settings. Formatting options are chosen for readability, and for clean git diffs.

For Oxygen XML Editor:
- Indent size 4
- 150 character line width (folding threshold)
- Preserve empty lines
- Preserve line breaks in attributes
- Indent inline elements
- Sort attributes
- Add space before slash in empty elements
- Break line before an attribute name

### Generating a sample OSCAL System Security Plan XML document

An XSL transform [`sample-ssp.xsl`](rules/sample-ssp.xsl) can be used to produce a (rather rudimentary) OSCAL SSP document in XML form. The transform uses one of the [resolved catalogs](../../dist/content/rev4/baselines/xml) as input.

Saxon-PE or Saxon-EE is required (such as within oXygen XML Editor). Saxon-HE is not supported, due to extension usage.
