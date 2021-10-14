#!/bin/bash

set -euxo pipefail

SOURCE_XSL=$1
SOURCE_XML=$2
SVRL_DESTINATION=$3

java -cp "${SAXON_CP}" net.sf.saxon.Transform \
    -o:"${SVRL_DESTINATION}" \
    -s:"${SOURCE_XML}" \
    "${SOURCE_XSL}" \
    ${SAXON_OPTS}
if xmllint --xpath '//*[local-name()="failed-assert"]//text()' "${BASE_DIR}/src/validations/target/sch-svrl.xml" ; then
  echo "Schematron evaluation failed"
  exit 1
else
  echo "Schematron evaluation succeeded"
  exit 0
fi
