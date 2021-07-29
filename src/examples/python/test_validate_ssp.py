from .validate_ssp import validate_sample_ssp


def test_validate_ssp() -> None:
    assert validate_sample_ssp() == ""
