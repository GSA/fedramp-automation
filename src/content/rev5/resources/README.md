<img src="https://github.com/GSA/fedramp-automation/raw/master/assets/FedRAMP_LOGO.png" alt="FedRAMP" width="76" height="94"><br />
# Federal Risk and Authorization Management Program (FedRAMP) Automation

## FedRAMP OSCAL Resources

These resources are experimental drafts, undergoing further updates in the near future.
You are welcome to use them and provide feedback.
Please let us know if you find them valuable.

## FedRAMP OSCAL Registry and Resource Inventory

The following resources are provided in both XML and JSON formats:
- FedRAMP Extensions ([fedramp_extensions.xml](xml/fedramp_values.xml), [fedramp_values.json](json/fedramp_values.json))
- FedRAMP Information Types ([fedramp_information-types.xml](xml/fedramp_information-types.xml), [fedramp_information-types.json](json/fedramp_information-types.json))

### FedRAMP Values

For your convenience, this file provides machine-readable constructs containing the acceptable values found in the FedRAMP OSCAL Registry [Acceptable Values (AV) Tab], as well as other helpful values.

The content is provided in both XML and JSON formats. It is experimental and not documented at this time. It is also subject to change based on feedback.

### FedRAMP Information Types

The OSCAL-based SSP syntax allows an SSP author to identify the information ID of each information type within the system. FedRAMP only accepts NIST 800-60, Volume 2, Release 1 information types. 

For your convenience, this file provides tool developers the relevant 800-60 V2R1 identifiers and associated details in both XML and JSON formats. 

- JSON Format: nist-sp-800-60_vol2.json
- XML Format: nist-sp-800-60_vol2.xml

In anticipation of future changes to the information type references, such as when NIST updates SP 800-60 Volume 2, information types should be queried from this file using both the information-type id and the system, where these values match those in the information-type-id assembly within the SSP syntax.

For example, an OSCAL-based FedRAMP SSP may contain the following:
```
<system-information>
	<information-type name="Information Type Name" uuid="uuid-value">
		<information-type-id system="https://doi.org/10.6028/NIST.SP.800-60v2r1">
			C.2.4.1
		</information-type-id>
		<!-- cut -->
</system-information>
```

The  file should be queried based on both:
- `system = "https://doi.org/10.6028/NIST.SP.800-60v2r1"`; and
- `id = "C.2.4.1"`




