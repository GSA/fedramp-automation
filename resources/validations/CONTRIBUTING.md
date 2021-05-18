Project Structure
---
All directory references are local to the `fedramp-automation/resources/validations`

`src` for the sch files

`lib` for toolchain dependencies (e.g. Schematron)

`report/test` for XSpec outputs

`report/schematron` for final validations in Schematron SVRL reporting format

`target` for intermediary and compiled artifacts (e.g. XSLT stylesheets)

`test` for any XSpec or other testing artifacts

`test/demo` xml files for validating XSpec against

`docs/adr` a list of [Architectural Decision Records](https://adr.github.io) in which the product team documented technical decisions for the project

To validate xml files using schematron
---

__Prerequesite__
*if you haven't done it previously: to add the needed dependencies (declared by .gitmodules), run the following:*

`git submodule update --init --recursive`

__Command Options__ for `/bin/validate_with_schematron.sh`

`-f` *\<required>* is the input file to be tested. ex: `-f test/demo/FedRAMP-SSP-OSCAL-Template.xml`

`-s` *\<optional>* schematron directory used to validate the file. Each .sch found within the specified directory will be compliled and generate a separate report. defaults to src relative to the parent of the bin directory where this script is located.  ex: `-o ~/mySchematronDirectory`

`-o` *\<optional>* is the root directory of the report output. ex: `-o ~/dev/report`

`-b` *\<optional>* specifies the base directory of the location of this project (for relative references to target, bin and dependencies like OSCAL definiitions). defaults to `.` ex: `-b /dev/fedramp-automation/resources/validations`

`-v` *\<optional>* if you wish to override the default version (currently 10.2) of `SAXON HE`, that is downloaded and used if $SAXON_CP is not specified. ex:  `-v 10.2.2` *Note,  SAXON_CP is set as an Environment Variable. and `-v` is specified, the script will terminate due to inability to determine priority.*

`-h` *\<optional>* outputs the help/usage for the script.`

example:

`./bin/validate_with_schematron.sh -f test/demo/FedRAMP-SSP-OSCAL-Template.xml -o ~/dev/report -v 10.2.2`

Alternatively, you can also use `docker-compose` to execute the validation script like so.

```sh
cd /path/to/fedramp-automation/resources/validations
docker-compose run \
  -w /root/resources/validations \
  validator \
  bin/validate_with_schematron.sh \
  -f test/demo/FedRAMP-SSP-OSCAL-Template.xml
```


To Run Unit Tests
---

*Prerequesite
if you haven't done it previously: to add the needed dependencies (declared by .gitmodules), run the following:*

`git submodule update --init --recursive`

```sh
cd /path/to/fedramp-automation/resources/validations
#if you have a preferred version of a saxon jar downloaded export SAXON_CP as so
export SAXON_CP=yourpath/Saxon-HE-X.Y.Z.jar
#set the test directory relative to project path, you may change if you prefer somehere else
export TEST_DIR=$(pwd)/report/test
#execute xpec with the test harness that runs all tests
lib/xspec/bin/xspec.sh -s -j test/test_all.xspec
```

Alternatively, you can also use `docker-compose` to execute the test harness like so.

```sh
cd /path/to/fedramp-automation/resources/validations
docker-compose run \
  -w /root/resources/validations \
  validator \
  lib/xspec/bin/xspec.sh -s -j test/test_all.xspec
```

Adding tests to the harness
---

To add new tests, add an import to the `test-all.xpec`
ex: `<x:import href="new_test.xspec" />`

Analyzing Changes to OSCAL Data Models to Update Rules
---

OSCAL has abstract information models that are converted into concrete data models into XML and JSON.

As a developer, you can look at individual OSCAL files that must conform to schemas for these data models, including SSPs, Components, SAPs, SARs, and POA&Ms. However, looking at individual examples for each respective model will be exhaustive and time-consuming.

The schemas for the models themselves are designed and programmatically [designed, cross-referenced between JSON and XML, and generated with appropriate schema validation tools by way of the NIST Metaschema project](https://pages.nist.gov/OSCAL/documentation/schema/overview/). Therefore, it is most prudent to focus analysis on the changes in the version-controlled Metaschema declarations, as they define the abstract information model. This information model is used to generate concrete data models in JSON and XML, to be validated by JSON Schema and XSD, respectively.

Developers ought to review the following relevant information sources, in order of least to most effort.
- [Release notes from the NIST OSCAL Development Team](https://github.com/usnistgov/OSCAL/blob/master/src/release/release-notes.md), where they summarize model changes in their own words from version to version.
- [XSLT "up-convert" transforms](https://github.com/usnistgov/OSCAL/tree/f44426e0ec14431b88833dbd381b5434d0892403/src/release/content-upgrade) give specific declarative detail on how to modify the OSCAL XML data models.
- The source code of the Metaschema models, filtering on the release tags. Developers can use the Github web interface to compare Metaschema files, [such as this example comparison between release candidate versions `1.0.0-rc1` and `1.0.0-rc2`](https://github.com/usnistgov/OSCAL/compare/v1.0.0-rc1...v1.0.0-rc2). Focus on the files in the `src/metaschema` directory.

Per [18F/fedramp-automation#61](https://github.com/18F/fedramp-automation/issues/61), programmatic diff utilities to semantically analyze the differences between OSCAL versions requires resources not available at this time.

__Formatting XML__

When contributing, please use the provided XML formatter (htmltidy >= 5.6.0). Formatting options are chosen for readability, and for clean git diffs.

To format validation XML, you may use the provided `docker-compose` harness:

```sh
cd /path/to/fedramp-automation/resources/validations
docker-compose run \
  -w /root/resources/validations \
  validator \
  bin/format_xml.sh
```
