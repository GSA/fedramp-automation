import base64
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
# XSLT stylesheet that converts a JSON SSP to XML.
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
    xslt_processor = saxon_processor.new_xslt_processor()
    xslt_processor.set_property("it", "from-json")

    # Create a data URI for a JSON sample SSP.
    with open(EXAMPLE_SSP_PATH_JSON, 'r') as f:
        sample_ssp_json = f.read()
        file_base64_encoded = base64.b64encode(sample_ssp_json.encode('utf-8')).decode("utf-8")
        data_uri = f'data:application/json;base64,{file_base64_encoded}'

    xslt_processor.set_parameter(
        # To process an in-memory JSON string, you may pass it as a data URI.
        "file", saxon_processor.make_string_value(data_uri)

        # To process an external document, you may pass it as a URI.
        #"file", saxon_processor.make_string_value(EXAMPLE_SSP_PATH_JSON),
    )
    return xslt_processor


def test_json_to_xml(xslt_processor: saxonc.PyXsltProcessor) -> None:
    xml_string = xslt_processor.transform_to_string(
        source_file=OSCAL_JSON_TO_XML,
        stylesheet_file=OSCAL_JSON_TO_XML,
    )
    assert xslt_processor.exception_count() == 0
    # To get exception details, use the following:
    #assert xslt_processor.get_error_message(0) == None
    assert '<system-security-plan ' in xml_string
