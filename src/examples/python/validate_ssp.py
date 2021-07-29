import os

# Define a type alias for the Schematron SVRL schema.
SvrlType = str


def validate_ssp(ssp_contents: str) -> SvrlType:
    return ssp_contents


def validate_sample_ssp() -> SvrlType:
    example_ssp_path = os.path.abspath(
        os.path.join(
            os.path.dirname(__file__),
            "FedRAMP-SSP-OSCAL-Template.xml",
        )
    )
    with open(example_ssp_path, "r") as f:
        return validate_ssp(f.read())


if __name__ == "__main__":
    validate_sample_ssp()
