#!/bin/bash

set -euxo pipefail

SOURCE_XSL=$1
SOURCE_XML=$2
SVRL_DESTINATION=$3

# shellcheck disable=SC2086
java -cp "${SAXON_CP}" net.sf.saxon.Transform \
    -o:"${SVRL_DESTINATION}" \
    -s:"${SOURCE_XML}" \
    "${SOURCE_XSL}" \
    ${SAXON_OPTS}
if "${BASE_DIR}/src/validations/bin/assert-svrl.py" "${SVRL_DESTINATION}" ; then
  echo "Schematron evaluation succeeded"
  exit 0
else
  echo "Schematron evaluation failed"
  exit 1
fi
