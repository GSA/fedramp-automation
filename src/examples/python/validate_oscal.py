import os
from urllib.request import pathname2url
from urllib.parse import urljoin

import saxonc  # type: ignore

#
# Define the paths to required project files.
#

# FedRAMP OSCAL LOW/MODERATE/HIGH/LI baselines
BASELINES_BASE_PATH = urljoin(
    "file:",
    pathname2url(
        os.path.abspath(
            os.path.join(
                os.path.dirname(__file__),
                "../../../dist/content/rev4/baselines/xml",
            )
        )
    ),
)
# FedRAMP OSCAL custom values (fedramp-values.xml)
REGISTRY_BASE_PATH = urljoin(
    "file:",
    pathname2url(
        os.path.abspath(
            os.path.join(
                os.path.dirname(__file__),
                "../../../dist/content/rev4/resources/xml",
            )
        )
    ),
)


def get_xslt_processor(
    saxon_processor: saxonc.PySaxonProcessor,
) -> saxonc.PyXslt30Processor:
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
        "param-use-remote-resources",
        saxon_processor.make_boolean_value(False),
    )
    return xslt_processor


def process_schematron(
    saxon_processor: saxonc.PySaxonProcessor,
    xslt_processor: saxonc.PyXslt30Processor,
    source_file: str,
    stylesheet_file: str,
) -> saxonc.PyXdmNode:
    # Validate the SSP, returning an SVRL document as a string.
    svrl_string = xslt_processor.transform_to_string(
        source_file=source_file,
        stylesheet_file=stylesheet_file,
    )
    assert xslt_processor.error_message is None
    assert xslt_processor.exception_occurred == False
    assert "<svrl:schematron-output" in svrl_string

    # Parse the SVRL document and check its type.
    svrl_node = saxon_processor.parse_xml(xml_text=svrl_string)
    assert type(svrl_node) is saxonc.PyXdmNode

    return svrl_node


def validate_oscal_document(source_file: str, stylesheet_file: str) -> dict:
    saxon_processor = saxonc.PySaxonProcessor(license=False)

    xslt_processor = get_xslt_processor(saxon_processor)
    svrl_node = process_schematron(
        saxon_processor,
        xslt_processor,
        source_file=source_file,
        stylesheet_file=stylesheet_file,
    )

    xpath_processor = saxon_processor.new_xpath_processor()
    xpath_processor.set_context(xdm_item=svrl_node)

    return {
        "failed_asserts": xpath_processor.evaluate("//*:failed-assert"),
        "successful_reports": xpath_processor.evaluate("//*:successful-report"),
    }
