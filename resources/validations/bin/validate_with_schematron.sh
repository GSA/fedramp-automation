#!/usr/bin/env bash

if [ ! -e  "$1" ]; then
    echo "no file input for report, exiting"
    exit 1
fi
DOC_TO_VALIDATE="$1"
echo "doc requested to be validated: ${DOC_TO_VALIDATE}"

# Delete pre-existing XSLT report
rm -rf target/*.xsl;

SAXON_VERSION=$2
SAXON_VERSION=${SAXON_VERSION:-10.2}
SAXON_OPTS="${SAXON_OPTS:-allow-foreign=true}"

echo "using saxon version ${SAXON_VERSION}"

mvn -q org.apache.maven.plugins:maven-dependency-plugin:2.1:get \
    -DrepoUrl=https://mvnrepository.com/ \
    -DartifactId=Saxon-HE \
    -DgroupId=net.sf.saxon \
    -Dversion="${SAXON_VERSION}"

# Delete pre-existing SVRL report
rm -rf report/schematron/*.results.xml

for qualifiedSchematronName in src/*.sch; do
    [ -e "${qualifiedSchematronName}" ] || continue
        
    # compute name without .sch
    schematronName=${qualifiedSchematronName##*/}
    schematronRoot=${schematronName%.*}
    
    # Use Saxon XSL transform to convert our Schematron to pure XSL 2.0 stylesheet
    saxon_jar=~/.m2/repository/net/sf/saxon/Saxon-HE/"${SAXON_VERSION}"/Saxon-HE-"${SAXON_VERSION}".jar

    java -cp "${saxon_jar}" net.sf.saxon.Transform \
        -o:target/"${schematronRoot}".xsl \
        -s:"${qualifiedSchematronName}" \
        lib/schematron/trunk/schematron/code/iso_svrl_for_xslt2.xsl \
        $SAXON_OPTS

    echo "compiling: ${qualifiedSchematronName} to: target/${schematronRoot}.xsl"
   
    # Use Saxon XSL transform to use XSL-ified Schematron rules to analyze full FedRAMP-SSP-OSCAL template
    # and dump the result into reports.
    reportName="report/schematron/${DOC_TO_VALIDATE}__${schematronRoot}.results.xml"
    htmlReportName="report/html/${DOC_TO_VALIDATE}__${schematronRoot}.results.html"

    echo "validating doc: ${DOC_TO_VALIDATE} with ${qualifiedSchematronName} output found in ${reportName}"

    java -cp "${saxon_jar}" net.sf.saxon.Transform \
        -o:"${reportName}" -s:"${DOC_TO_VALIDATE}" \
        target/"${schematronRoot}".xsl \
        $SAXON_OPTS

    java -cp "${saxon_jar}" net.sf.saxon.Transform \
        -o:"${htmlReportName}" \
        -s:"${reportName}"  \
        lib/svrl2html.xsl \
        $SAXON_OPTS

done
