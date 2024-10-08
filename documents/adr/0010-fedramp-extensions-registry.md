# 10. Create Metaschema-based FedRAMP Extensions Registry

## Status

Proposed

## Context

OSCAL content authors need clear and consistent guidance on when to uses specialized FedRAMP OSCAL extensions versus when to use generalized core OSCAL props and values, and a clear understanding of the constraints around all extensions (issue [#564](https://github.com/GSA/fedramp-automation/issues/564)).

Currently, FedRAMP extension guidance is spread across the following resources:

- Legacy experimental [FedRMP extensions](https://github.com/GSA/fedramp-automation/blob/b9513d2be64180b0ea96c74b42836af2b368a156/dist/content/rev5/resources/xml/FedRAMP_extensions.xml) registry, however this resource:
  1. is not consistent with FedRAMP's use of external [Metaschema-based validation constraints](https://github.com/GSA/fedramp-automation/blob/develop/src/validations/constraints/README.md#what-are-they) going forward
  2. is deprecated, per [ADR 007](/documents/adr/0007-signal-unsupportent-content-in-github.md)
- The [FedRAMP Developer Hub](https://automate.fedramp.gov/documentation) site, however it can be difficult or time-consuming for OSCAL practitioners to find information about a specific FedRAMP extension.


## Decision

This architectural decision record (ADR) proposes replacing the legacy experimental registry with a new [Metaschema](https://pages.nist.gov/metaschema/)-based FedRAMP Extensions Registry.  The FedRAMP OSCAL Extensions Registry will provide a comprehensive machine-readable reference, documenting all of the FedRAMP extensions.  FedRAMP will implement XML, JSON, and YAML versions of the registry. For each extension, the registry will document:
- **id** - the extension's unique identifier.
- **formal-name** - the extension's formal name.
- **description** - a brief description of the extension.
- **fedramp-external-constraint-id** - reference to the identifier of the FedRAMP external constraint(s) (e.g., allowed-values) for this FedRAMP extension.
> Note: FedRAMP is currently implementing validation constraints.  The registry will be updated with `fedramp-external-constraint-id` information as constraint IDs become available. 
- **remarks (OPTIONAL)** - additional information regarding the use of this FedRAMP extension.

The registry will include all FedRAMP extensions, past and present.  Any extensions that are no longer supported have a `deprecated` flag in the registry, specifying the the version number where support ceased.  The following is an example of the proposed structure for the new FedRAMP Extensions Registry.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-model schematypens="http://www.w3.org/2001/XMLSchema" title="FedRAMP OSCAL Extensions Registry"?>
<fedramp-extensions-registry xmlns="http://fedramp.gov/ns/oscal"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" uuid="af4b2194-ace7-491b-89d4-b97eba3ae5f8">
   <!-- ===================================================================== -->
   <!--  METADATA                                                             -->
   <!-- ===================================================================== -->
   <metadata>
      <title>FedRAMP Extensions Registry</title>
      <published>2024-10-04T00:00:00Z</published>
      <last-modified>2024-10-04T00:00:00Z</last-modified>
      <version>fedramp2.1.0-oscal1.0.4</version>
      <!-- roles -->
      <!-- party -->
      <!-- responsible-party -->
      <!-- remarks -->
    </metadata>


    <!-- ===================================================================== -->
    <!--  EXTENSTIONS                                                          -->
    <!-- ===================================================================== -->
    <!-- example of a fedramp extension -->
    <fedramp-extension id="authorization-type">
        <formal-name>Authorization Type</formal-name>
        <description><p>Identifies the FedRAMP authorization type.</p></description>
        <!-- IDs of external constraints for this extension -->
        <fedramp-external-constraint-id>authorization-type</fedramp-external-constraint-id><!-- allowed-values constraint -->
        <remarks>
            <p>The "authorization-type" is used to specify the authorization path of a CSO in the SSP.  The extension is also used to specify the authorization path of any leveraged CSOs.</p>
        </remarks>
    </fedramp-extension>

    <!-- example of a deprecated extension -->
    <fedramp-extension id="security-cia-level" deprecated="1.0.2">
      <formal-name>eAuth Level (OVERALL)</formal-name>
      <description><p>The overall electronic authentication (eAuth) level applied to the system.</p></description>
      <remarks>
         <p>Deprecated.</p>
      </remarks>
   </fedramp-extension>

</fedramp-extensions-registry>    

```


## Consequences

The proposed solution will:

- Consolidate the extensions into one machine-readable registry, making it easier for OSCAL practitioners to find guidance on FedRAMP extensions
- Consolidate the extensions into one machine-readable registry, making it easier for OSCAL practitioners to detect any changes (e.g., deprecations, addition of new extensions)
- Consolidate the extensions into one machine-readable registry, providing a central, authoritative source of FedRAMP extension information for the [FedRAMP Developer Hub](https://autoamte.fedramp.gov/documentation) site to reference (e.g., with deep links)
- Model the FedRAMP registry with Metaschema, making it easier to generate XML and JSON schemas for the registry, and allow the registry to be validated (e.g., using the OSCAL CLI)
- Model the FedRAMP registry with Metaschema, making it easier to automate documentation generation (e.g., using the OSCAL CLI, XSLT, or other methods)
