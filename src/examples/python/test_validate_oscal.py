import os

from .validate_oscal import validate_oscal_document


def test_ssp_validation() -> None:
    # Demo System Security Plan (SSP)
    example_ssp_path = os.path.abspath(
        os.path.join(
            os.path.dirname(__file__),
            "../../../dist/content/rev4/templates/ssp/xml/FedRAMP-SSP-OSCAL-Template.xml",
        )
    )
    # Schematron rules compiled to an XSLT stylesheet.
    ssp_xsl_file = os.path.abspath(
        os.path.join(
            os.path.dirname(__file__),
            "../../validations/target/rules/ssp.sch.xsl",
        )
    )

    result = validate_oscal_document(example_ssp_path, ssp_xsl_file)
    assert result["failed_asserts"].size > 0
    assert result["successful_reports"].size > 0

    # Each assertion should have a number of attributes
    first_assertion = result["failed_asserts"].item_at(0).get_node_value()
    attributes = set(att.name for att in first_assertion.attributes)
    assert attributes == {"test", "id", "role", "location"}

    # Each assertion should have a number of attributes
    first_assertion = result["successful_reports"].item_at(0).get_node_value()
    attributes = set(att.name for att in first_assertion.attributes)
    assert attributes == {"test", "id", "role", "location"}


def test_sap_validation() -> None:
    result = validate_oscal_document(
        os.path.abspath(
            os.path.join(
                os.path.dirname(__file__),
                "../../../dist/content/rev4/templates/sap/xml/FedRAMP-SAP-OSCAL-Template.xml",
            )
        ),
        os.path.abspath(
            os.path.join(
                os.path.dirname(__file__),
                "../../validations/target/rules/sap.sch.xsl",
            )
        ),
    )
    assert result


def test_sar_validation() -> None:
    result = validate_oscal_document(
        os.path.abspath(
            os.path.join(
                os.path.dirname(__file__),
                "../../../dist/content/rev4/templates/sar/xml/FedRAMP-SAR-OSCAL-Template.xml",
            )
        ),
        os.path.abspath(
            os.path.join(
                os.path.dirname(__file__),
                "../../validations/target/rules/sar.sch.xsl",
            )
        ),
    )
    assert result


def test_poam_validation() -> None:
    result = validate_oscal_document(
        os.path.abspath(
            os.path.join(
                os.path.dirname(__file__),
                "../../../dist/content/rev4/templates/poam/xml/FedRAMP-POAM-OSCAL-Template.xml",
            )
        ),
        os.path.abspath(
            os.path.join(
                os.path.dirname(__file__),
                "../../validations/target/rules/poam.sch.xsl",
            )
        ),
    )
    assert result
