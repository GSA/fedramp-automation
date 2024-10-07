# FedRAMP OSCAL Extensions

A FedRAMP digital authorization package requires certain information that is not included in the default NIST OSCAL Models.  However, organizations can extend OSCAL by defining their own namespaced `prop` fields and `part` assemblies as described in the [NIST Extending OSCAL Models tutorial](https://pages.nist.gov/OSCAL/learn/tutorials/general/extension/).  FedRAMP has established its own FedRAMP-specific extensions, consisting of a unique namespace (ns="http://fedramp.gov/ns/oscal") and `prop` or `part` names that are required in OSCAL documents (SSP, SAP, SAR or POA&M) submitted to FedRAMP.

The ([FedRAMP OSCAL Extensions Registry](fedramp_extensions_registry.xml)) provides a comprehensive machine-readable reference, documenting all of the FedRAMP extensions.  Currently, the registry is provided in XML format, but future releases will also include JSON, and YAML versions of the registry. For each extension, the registry documents:
- **id** - the extension's unique identifier.
- **formal-name** - the extension's formal name.
- **description** - a brief description of the extension.
- **fedramp-external-constraint-id** - reference to the identifier of the FedRAMP external constraint(s) (e.g., allowed-values) for this FedRAMP extension.
> Note: FedRAMP is currently implementing validation constraints.  The registry will be updated with `fedramp-external-constraint-id` information as constraint IDs become available. 
- **remarks (OPTIONAL)** - additional information regarding the use of this FedRAMP extension.

The registry includes all FedRAMP extensions, past and present.  Any extensions that are no longer supported have a `deprecated` flag in the registry, specifying the the version number where support ceased (e.g., `deprecated="fedramp-2.0.0-oscal-1.0.4"`).