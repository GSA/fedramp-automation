Schematron Validations for OSCAL
===

project structure
---

`/src` for the sch files
`/lib` for toolchain dependencies (e.g. Schematron)
`/report/test` for XSpec outputs
`/report/schematron` for final validations in Schematron SVRL reporting format
`/target` for intermediary and compiled artifacts (e.g. XSLT stylesheets)
`/test` for any XSpec or other testing artifacts
`/test/demo` xml files for validating XSpec against

To Run Tests
---

```sh
cd /path/to/fedramp-automation/resources/validations
export SAXON_CP=yourpath/Saxon-HE-X.Y.Z.jar
export TEST_DIR=$(pwd)/report/test
lib/xspec/bin/xspec.sh -s -j test/test_all.xspec
```

Adding tests to the harness
---

To add new tests, add an import to the `test-all.xpec`
ex: `<x:import href="new_test.xspec" />`
