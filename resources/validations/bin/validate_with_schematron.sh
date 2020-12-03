#!/usr/bin/env bash
set -o pipefail

usage() {
    if test -n "$1"; then
        echo "$1"
        echo
    fi
    echo "Usage: validate_with_schematron.sh [-s directoryName|-o outputRootDirectory|-b baseDirectory|-v saxonVersionNumber|-h] -f file"
    echo
    echo "  -f    fileName               the input file to be tested."
    echo "  -s    directoryName          schematron directory containing .sch files used to validate"
    echo "  -o    outputRootDirectory          is an the root of the report output."
    echo "  -v    saxonVersionNumber     if you wish to override the default version to be downloaded"
    echo "  -b    baseDirectory          if you need to override the default base directory (.) for the project"
    echo "  -h                           display this help message"
}

# output root defaults to report folder relative to this script
OUTPUT_ROOT="report/schematron"
# schematron directory validate the file with each .sch found defaults to src/*.sch relative to this script
SCHEMA_LOCATION_DIR="src"
##
## options ###################################################################
##
while echo "$1" | grep -- ^- > /dev/null 2>&1; do
    case "$1" in
        # input file to validate
        -f)
            shift
            DOC_TO_VALIDATE="$1"
            ;;
        # saxon version
        -v)
            if test -n "$SAXON_CP"; then
                echo "SAXON_CP is set to ${SAXON_CP} as an environment variable setting version using -v is invalid"
                exit 1
            else
                shift
                SAXON_VERSION="$1"
            fi
            ;;
        # schema directory location
        -s)
            shift
            SCHEMA_LOCATION_DIR="$1"
            ;;
        # output directory root
        -o)
            shift
            OUTPUT_ROOT="$1"
            ;;
        # base directory root
        -b)
            shift
            BASE_DIR="$1"
            ;;
        # Help!
        -h)
            usage
            exit 0
            ;;
        # Unknown option!
        -*)
            usage "Error: Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

echo output dir "${OUTPUT_ROOT}"
if test ! -e  "$DOC_TO_VALIDATE" ; then
    echo "no file input to validate, exiting"
    exit 1
else 
    echo "doc requested to be validated: ${DOC_TO_VALIDATE}"
fi

#if version not specified default
SAXON_VERSION=${SAXON_VERSION:-10.2}
SAXON_OPTS="${SAXON_OPTS:-allow-foreign=true diagnose=true}"
BASE_DIR="${BASE_DIR:-.}"

echo "using saxon version ${SAXON_VERSION}"

# Delete pre-existing compiled XSLT
rm -rf "${BASE_DIR}"/target/{*.sch,*.xsl};

saxonLocation=saxon/Saxon-HE/"${SAXON_VERSION}"/Saxon-HE-"${SAXON_VERSION}".jar
if test -n "$SAXON_CP" ; then
    echo SAXON_CP env variable used is "${SAXON_CP}"
elif command -v mvn &> /dev/null ;then
    mvn -q org.apache.maven.plugins:maven-dependency-plugin:2.1:get \
        -DrepoUrl=https://mvnrepository.com/ \
        -DartifactId=Saxon-HE \
        -DgroupId=net.sf.saxon \
        -Dversion="${SAXON_VERSION}"
    SAXON_CP=~/.m2/repository/net/sf/${saxonLocation}
elif command -v curl &> /dev/null; then
    SAXON_CP="${BASE_DIR}"/lib/Saxon-HE-"${SAXON_VERSION}".jar
    curl -H "Accept: application/zip" -o "${SAXON_CP}" https://repo1.maven.org/maven2/net/sf/"${saxonLocation}" &> /dev/null
else
    echo "SAXON_CP environment variable is not set. mvn or curl is required to download dependencies, neither found, please install one and retry"
    exit 1
fi

if test -f "${SAXON_CP}" ; then
    java -cp "${SAXON_CP}" net.sf.saxon.Transform -? &> /dev/null
    retval=$?
    if  test $retval -eq 0 ; then
        echo Saxon JAR at classpath "${SAXON_CP}" is valid
    else
        echo Saxon JAR at classpath "${SAXON_CP}" does not contain net.sf.saxon.Transform
        exit 1
    fi
else 
    echo Saxon JAR at classpath "${SAXON_CP}" is not present 
    exit 1
fi

# Delete pre-existing SVRL report
rm -rf "${OUTPUT_ROOT}/*.results.xml"
rm -rf "${OUTPUT_ROOT}/*.results.html"

#in the future replace the for loop with an optional passed in directory or single schema file -f 
for qualifiedSchematronName in "${SCHEMA_LOCATION_DIR}"/*.sch; do
    [ -e "${qualifiedSchematronName}" ] || continue
        
    # compute name without .sch
    schematronName=${qualifiedSchematronName##*/}
    schematronRoot=${schematronName%.*}

    # See pipeline steps 1-4 for further details.
    # github.com/Schematron/schematron/blob/72f7f7c9c46236f073bc59b60869b79528890fd0/trunk/schematron/code/readme.txt
    #
    # Step 1
    java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -o:"${BASE_DIR}"/target/"${schematronRoot}-stage1.sch" \
        -s:"${qualifiedSchematronName}" \
        "${BASE_DIR}"/lib/schematron/trunk/schematron/code/iso_dsdl_include.xsl \
        $SAXON_OPTS
    echo "preprocessing stage 1: ${qualifiedSchematronName} to: ${BASE_DIR}/target/${schematronRoot}-stage1.sch"

    # Step 2
    java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -o:"${BASE_DIR}"/target/"${schematronRoot}-stage2.sch" \
        -s:"${BASE_DIR}"/target/"${schematronRoot}-stage1.sch" \
        "${BASE_DIR}"/lib/schematron/trunk/schematron/code/iso_abstract_expand.xsl \
        $SAXON_OPTS
    echo "preprocessing stage 2: ${BASE_DIR}/target/${schematronRoot}-stage1.sch to: ${BASE_DIR}/target/${schematronRoot}-stage2.sch"

    # Use Saxon XSL transform to convert our Schematron to pure XSL 2.0 stylesheet
    # shellcheck disable=2086
    java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -o:"${BASE_DIR}"/target/"${schematronRoot}".xsl \
        -s:"${BASE_DIR}"/target/"${schematronRoot}-stage2.sch" \
        "${BASE_DIR}"/lib/schematron/trunk/schematron/code/iso_svrl_for_xslt2.xsl \
        $SAXON_OPTS

    echo "compiling: ${qualifiedSchematronName} to: ${BASE_DIR}/target/${schematronRoot}.xsl"
   
    # Use Saxon XSL transform to use XSL-ified Schematron rules to analyze full FedRAMP-SSP-OSCAL template
    # and dump the result into reports.
    reportName="${OUTPUT_ROOT}/${DOC_TO_VALIDATE}__${schematronRoot}.results.xml"
    htmlReportName="${OUTPUT_ROOT}/${DOC_TO_VALIDATE}__${schematronRoot}.results.html"

    rm -rf "${reportName}" "${htmlReportName}"

    echo "validating doc: ${DOC_TO_VALIDATE} with ${qualifiedSchematronName} output found in ${reportName}"

    # shellcheck disable=2086
    java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -o:"${reportName}" \
        -s:"${DOC_TO_VALIDATE}" \
        "${BASE_DIR}"/target/"${schematronRoot}".xsl \
        $SAXON_OPTS

    # shellcheck disable=2086
    java -cp "${SAXON_CP}" net.sf.saxon.Transform \
        -o:"${htmlReportName}" \
        -s:"${reportName}"  \
        "${BASE_DIR}"/lib/svrl2html.xsl \
        $SAXON_OPTS

done
