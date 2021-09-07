import os

import pytest
import saxonc  # type: ignore

#
# Define the paths to required project files.
#
# Demo System Security Plan (SSP)
EXAMPLE_SSP_PATH = os.path.abspath(
    os.path.join(
        os.path.dirname(__file__),
        "../../../dist/content/templates/ssp/xml/FedRAMP-SSP-OSCAL-Template.xml",
    )
)
# Schematron rules compiled to an XSLT stylesheet.
SSP_XSL_FILE = os.path.abspath(
    os.path.join(
        os.path.dirname(__file__),
        "../../validations/target/ssp.xsl",
    )
)
# FedRAMP OSCAL LOW/MODERATE/HIGH/LI baselines
BASELINES_BASE_PATH = os.path.abspath(
    os.path.join(
        os.path.dirname(__file__),
        "../../../dist/content/baselines/rev4/xml",
    )
)
# FedRAMP OSCAL custom values (fedramp-values.xml)
REGISTRY_BASE_PATH = os.path.abspath(
    os.path.join(
        os.path.dirname(__file__),
        "../../../dist/content/resources/xml",
    )
)


@pytest.fixture(scope="session")
def ssp_demo_xml() -> str:
    with open(EXAMPLE_SSP_PATH, "r") as f:
        return f.read()


@pytest.fixture
def saxon_processor() -> saxonc.PySaxonProcessor:
    return saxonc.PySaxonProcessor(license=False)


@pytest.fixture
def xslt_processor(saxon_processor: saxonc.PySaxonProcessor) -> saxonc.PyXsltProcessor:
    xslt_processor = saxon_processor.new_xslt30_processor()
    # Set parameters to `fedramp-automation` baselines and fedramp-values files.
    xslt_processor.set_parameter(
        "baselines-base-path", saxon_processor.make_string_value(BASELINES_BASE_PATH)
    )
    xslt_processor.set_parameter(
        "registry-base-path", saxon_processor.make_string_value(REGISTRY_BASE_PATH)
    )
    xslt_processor.set_parameter(
        # Set to `True` to validate external resource references.
        "param-use-remote-resources", saxon_processor.make_boolean_value(False)
    )
    return xslt_processor


@pytest.fixture
def svrl_node(
    saxon_processor: saxonc.PySaxonProcessor, xslt_processor: saxonc.PyXsltProcessor
) -> saxonc.PyXdmNode:
    # Validate the SSP, returning an SVRL document as a string.
    svrl_string = xslt_processor.transform_to_string(
        source_file=EXAMPLE_SSP_PATH,
        stylesheet_file=SSP_XSL_FILE,
    )
    assert "<svrl:schematron-output" in svrl_string

    # Parse the SVRL document and check its type.
    svrl_node = saxon_processor.parse_xml(xml_text=svrl_string)
    assert type(svrl_node) is saxonc.PyXdmNode

    return svrl_node


@pytest.fixture
def xpath_processor(
    saxon_processor: saxonc.PyXsltProcessor, svrl_node: saxonc.PyXsltProcessor
) -> saxonc.PyXPathProcessor:
    xpath_processor = saxon_processor.new_xpath_processor()
    xpath_processor.set_context(xdm_item=svrl_node)
    return xpath_processor


def test_failed_asserts(xpath_processor: saxonc.PyXPathProcessor) -> None:
    # PyXPathProcessor does not appear to be honoring this namespace declaration.
    # xpath_processor.declare_namespace("svrl", "http://purl.oclc.org/dsdl/svrl")
    # value = xpath_processor.evaluate("//svrl:failed-assert")
    value = xpath_processor.evaluate("//*:failed-assert")
    assert value.size > 0

    # Each assertion should have a number of attributes
    first_assertion = value.item_at(0).get_node_value()
    attributes = set(att.name for att in first_assertion.attributes)
    assert attributes == {"test", "id", "role", "location"}


def test_reports(xpath_processor: saxonc.PyXPathProcessor) -> None:
    # PyXPathProcessor does not appear to be honoring this namespace declaration.
    # xpath_processor.declare_namespace("svrl", "http://purl.oclc.org/dsdl/svrl")
    # value = xpath_processor.evaluate("//svrl:successful-report")
    value = xpath_processor.evaluate("//*:successful-report")
    assert value.size > 0

    # Each assertion should have a number of attributes
    first_assertion = value.item_at(0).get_node_value()
    attributes = set(att.name for att in first_assertion.attributes)
    assert attributes == {"test", "id", "role", "location"}
