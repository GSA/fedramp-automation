#!/bin/bash

npx xslt3 -xsl:../../validations/target/rules/poam.sch.xsl -export:/tmp/poam.sef.json -relocate:on -nogo
npx xslt3 -xsl:../../validations/target/rules/sap.sch.xsl -export:/tmp/sap.sef.json -relocate:on -nogo
npx xslt3 -xsl:../../validations/target/rules/sar.sch.xsl -export:/tmp/sar.sef.json -relocate:on -nogo
npx xslt3 -xsl:../../validations/target/rules/ssp.sch.xsl -export:/tmp/ssp.sef.json -relocate:on -nogo
node ./src/validator.test.js
