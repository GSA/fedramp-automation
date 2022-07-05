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

npx xslt3 -xsl:../../validations/target/rules/ssp.sch.xsl -export:poam.sef.json -nogo
npx xslt3 -xsl:../../validations/target/rules/ssp.sch.xsl -export:sap.sef.json -nogo
npx xslt3 -xsl:../../validations/target/rules/ssp.sch.xsl -export:sar.sef.json -nogo
npx xslt3 -xsl:../../validations/target/rules/ssp.sch.xsl -export:ssp.sef.json -nogo
