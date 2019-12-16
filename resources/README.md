# RESOURCES
These resources are experimental drafts.
You are welcome to use them and provide feedback.
Please let us know if you find them valuable.

## Resource Inventory

### FedRAMP Information Types

The OSCAL-based SSP syntax allows an SSP author to identify the information ID of each information type within the system. FedRAMP only accepts NIST 800-60, Volume 2, Release 1 information types. 

For your convenience, this file provides tool devlopers the relevant 800-60 V2R1 identifers and associated details in both XML and JSON formats. 

- JSON Format: nist-sp-800-60_vol2.json
- XML Format: nist-sp-800-60_vol2.xml

In anticipation of future changes to the iformation type references, such as when NIST updates SP 800-60 Volume 2, information types should be queried from this file using both the information-type id and the system, where these values match those in the information-type-id assembly within the SSP syntax.

For example, an OSCAL-based FedRAMP SSP may contain the following:
```
<system-information>
	<information-type name="Information Type Name" id="info-01">
		<information-type-id system="https://doi.org/10.6028/NIST.SP.800-60v2r1">
			C.2.4.1
		</information-type-id>
		<!-- cut -->
</system-information>
```

The  file should be queried based on both:
- system = "https://doi.org/10.6028/NIST.SP.800-60v2r1"; and
- id = "C.2.4.1"


### FedRAMP Values

For your convenience, this file provies machine-readable constructs containing the acceptable values found in the FedRAMP OSCAL Registry [Acceptable Values (AV) Tab], as well as other helpful values.

The content is provided in both XML and JSON formats. It is experimental and not documented at this time. It is also subject to change based on feedback.

