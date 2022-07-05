#!/bin/bash

#
# This compilation usage the Java-compiled *.sch.xsl produced by the project's
# Makefiles.
#
# If you would like to compile the XSLT yourself, using SaxonJS, you may look at
# src/web/package.json for examples using XSLT3.
#
# Here, we compile the XSLT to SEF format - a JSON format that is required by SaxonJS.
#

echo "Compiling Schematron XSLT to SEF format..."
npx xslt3 -xsl:../../validations/target/rules/ssp.sch.xsl -export:dist/poam.sef.json -nogo
npx xslt3 -xsl:../../validations/target/rules/ssp.sch.xsl -export:dist/sap.sef.json -nogo
npx xslt3 -xsl:../../validations/target/rules/ssp.sch.xsl -export:dist/sar.sef.json -nogo
npx xslt3 -xsl:../../validations/target/rules/ssp.sch.xsl -export:dist/ssp.sef.json -nogo
