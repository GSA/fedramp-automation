#!/bin/bash

SOURCE_XSL=$1
SOURCE_XML=$2
SVRL_DESTINATION=$3

java -cp "${SAXON_CP}" net.sf.saxon.Transform \
    -o:"${SVRL_DESTINATION}" \
    -s:"${SOURCE_XML}" \
    "${SOURCE_XSL}" \
    ${SAXON_OPTS}
xmllint --xpath "//*[local-name()='failed-assert']//text()" src/validations/target/sch-svrl.xml; \
  test $? -ne 0
