import os

import pytest
import saxonc  # type: ignore

#
# Define the paths to required project files.
#
# Demo System Security Plan (SSP)
EXAMPLE_SSP_PATH_JSON = os.path.abspath(
    os.path.join(
        os.path.dirname(__file__),
        "../../../dist/content/templates/ssp/json/FedRAMP-SSP-OSCAL-Template.json",
    )
)
# Schematron rules compiled to an XSLT stylesheet.
OSCAL_JSON_TO_XML = os.path.abspath(
    os.path.join(
        os.path.dirname(__file__),
        "../../../vendor/oscal/xml/convert/oscal_ssp_json-to-xml-converter.xsl",
    )
)


@pytest.fixture
def saxon_processor() -> saxonc.PySaxonProcessor:
    return saxonc.PySaxonProcessor(license=False)


@pytest.fixture
def xslt_processor(saxon_processor: saxonc.PySaxonProcessor) -> saxonc.PyXsltProcessor:
    xslt_processor = saxon_processor.new_xslt30_processor()
    xslt_processor.set_property("it", "from-json")
    xslt_processor.set_parameter(
        "file", saxon_processor.make_string_value(EXAMPLE_SSP_PATH_JSON)
        #"file", saxon_processor.make_atomic_value("anyURI", EXAMPLE_SSP_PATH_JSON.encode("utf-8"))
        #"file", saxon_processor.make_atomic_value("AU", EXAMPLE_SSP_PATH_JSON.encode("utf-8"))
    )
    return xslt_processor


def test_json_to_xml(xslt_processor: saxonc.PyXsltProcessor) -> None:
    xml_string = xslt_processor.transform_to_string(
        source_file=OSCAL_JSON_TO_XML,
        stylesheet_file=OSCAL_JSON_TO_XML,
    )
    assert xml_string == 'blah'
