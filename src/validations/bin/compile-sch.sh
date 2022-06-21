#!/usr/bin/env bash

set -euxo pipefail

SOURCE=$1
DESTINATION=$2

echo "Preprocessing stage 1/3 of ${SOURCE}..."
STAGE_1=$(mktemp)
# shellcheck disable=SC2086
java -cp "${SAXON_CP}" net.sf.saxon.Transform \
    -o:"${STAGE_1}" \
    -s:"${SOURCE}" \
    "${BASE_DIR}/vendor/schematron/trunk/schematron/code/iso_dsdl_include.xsl" \
    ${SAXON_OPTS}

echo "Preprocessing stage 2/3 of ${SOURCE}..."
STAGE_2=$(mktemp)
# shellcheck disable=SC2086
java -cp "${SAXON_CP}" net.sf.saxon.Transform \
    -o:"${STAGE_2}" \
    -s:"${STAGE_1}" \
    "${BASE_DIR}/vendor/schematron/trunk/schematron/code/iso_abstract_expand.xsl" \
    ${SAXON_OPTS}

echo "Preprocessing stage 3/3 of ${SOURCE}..."
# shellcheck disable=SC2086
java -cp "${SAXON_CP}" net.sf.saxon.Transform \
    -o:"${DESTINATION}" \
    -s:"${STAGE_2}" \
    "${BASE_DIR}/vendor/schematron/trunk/schematron/code/iso_svrl_for_xslt2.xsl" \
    ${SAXON_OPTS}
