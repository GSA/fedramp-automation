Schematron Validations for OSCAL
===

![OSCAL Validations: Unit Tests](https://github.com/18F/fedramp-automation/workflows/OSCAL%20Validations:%20Unit%20Tests/badge.svg)

project structure
---

`/src` for the sch files
`/lib` for toolchain dependencies (e.g. Schematron)
`/report/test` for XSpec outputs
`/report/schematron` for final validations in Schematron SVRL reporting format
`/target` for intermediary and compiled artifacts (e.g. XSLT stylesheets)
`/test` for any XSpec or other testing artifacts
`/test/demo` xml files for validating XSpec against

To validate xml files using schematron
---

*Prerequesite
if you haven't done it previously: to add the needed dependencies (declared by .gitmodules), run the following:*

`git submodule update --init --recursive`

`validate_with_schematron.sh` Command Options

`-f` *\<required>* is the input file to be tested. ex: `-f test/demo/FedRAMP-SSP-OSCAL-Template.xml`

`-s` *\<optional>* schematron directory used to validate the file. Each .sch found within the specified directory will be compliled and generate a separate report. defaults to src relative to the parent of the bin directory where this script is located.  ex: `-o ~/mySchematronDirectory`

`-o` *\<optional>* is the root directory of the report output. ex: `-o ~/dev/report`

`-b` *\<optional>* specifies the base directory of the location of this project (for relative references to target, bin and dependencies like OSCAL definiitions). defaults to `.` ex: `-b /dev/fedramp-automation/resources/validations`

`-v` *\<optional>* if you wish to override the default version (currently 10.2) of `SAXON HE`, that is downloaded and used if $SAXON_CP is not specified. ex:  `-v 10.2.2` *Note,  SAXON_CP is set as an Environment Variable. and `-v` is specified, the script will terminate due to inability to determine priority.*

`-h` *\<optional>* outputs the help/usage for the script.`

example:

`./bin/validate_with_schematron.sh -f test/demo/FedRAMP-SSP-OSCAL-Template.xml -o ~/dev/report -v 10.2.2`

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

Adding tests to the harness
---

To add new tests, add an import to the `test-all.xpec`
ex: `<x:import href="new_test.xspec" />`
