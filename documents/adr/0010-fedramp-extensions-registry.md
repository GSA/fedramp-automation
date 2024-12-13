# NN. Implement a Metaschema-based approach for the FedRAMP Extensions Registry

## Status

Proposed

## Context

OSCAL content authors need clear and consistent guidance on when to uses specialized FedRAMP OSCAL extensions versus when to use generalized core OSCAL props and values, and a clear understanding of the constraints around all extensions (issue [#564](https://github.com/GSA/fedramp-automation/issues/564)).  

As FedRAMP information needs change (e.g., during recent transition from rev 4 to rev 5 baselines), there are cases where the FedRAMP automation team will either need to create new extensions, update existing extensions, or deprecate extensions to align with the new requirements.  In these cases, the FedRAMP automation team needs the ability to track all FedRAMP extensions and signal any changes to the community.

Currently, FedRAMP extension guidance is spread across the following resources:

- Legacy experimental [FedRMP extensions](https://github.com/GSA/fedramp-automation/blob/b9513d2be64180b0ea96c74b42836af2b368a156/dist/content/rev5/resources/xml/FedRAMP_extensions.xml) registry, however this resource:
  1. is not consistent with FedRAMP's use of external [Metaschema-based validation constraints](https://github.com/GSA/fedramp-automation/blob/develop/src/validations/constraints/README.md#what-are-they) going forward
  2. is deprecated, per [ADR 007](/documents/adr/0007-signal-unsupportent-content-in-github.md)
- The [FedRAMP Developer Hub](https://automate.fedramp.gov/documentation) site, however it can be difficult or time-consuming for OSCAL practitioners to find information about a specific FedRAMP extension.

This ADR explores a couple of options for effectively maintaining a registry of FedRAMP extensions.
---


## Evaluation of Options

### Option 1 - FedRAMP Implements a Separate Metaschema model for its Registry

This option proposes replacing the legacy experimental registry with a new [Metaschema](https://pages.nist.gov/metaschema/)-based FedRAMP Extensions Registry.  The FedRAMP OSCAL Extensions Registry will provide a comprehensive machine-readable reference, documenting all of the FedRAMP extensions.  FedRAMP will implement XML, JSON, and YAML versions of the registry. For each extension, the registry will document:
- **id** - the extension's unique identifier.
- **formal-name** - the extension's formal name.
- **description** - a brief description of the extension.
- **external-constraint-id** - reference to the identifier of the FedRAMP external constraint(s) (e.g., allowed-values) for this FedRAMP extension.
> Note: FedRAMP is currently implementing validation constraints.  The registry will be updated with `external-constraint-id` information as constraint IDs become available. 
- **remarks (OPTIONAL)** - additional information regarding the use of this FedRAMP extension.

The registry will include all FedRAMP extensions, past and present.  Any extensions that are no longer supported have a `deprecated` flag in the registry, specifying the the version number where support ceased.  The following is an example of the proposed structure for the new FedRAMP Extensions Registry.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-model schematypens="http://www.w3.org/2001/XMLSchema" title="FedRAMP OSCAL Extensions Registry"?>
<extensions-registry xmlns="http://fedramp.gov/ns/oscal"
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
    <extension id="authorization-type">
        <formal-name>Authorization Type</formal-name>
        <description><p>Identifies the FedRAMP authorization type.</p></description>
        <!-- IDs of external constraints for this extension -->
        <external-constraint-id>authorization-type</external-constraint-id><!-- allowed-values constraint -->
        <remarks>
            <p>The "authorization-type" is used to specify the authorization path of a CSO in the SSP.  The extension is also used to specify the authorization path of any leveraged CSOs.</p>
        </remarks>
    </extension>

    <!-- example of a deprecated extension -->
    <extension id="security-cia-level" deprecated="1.0.2">
      <formal-name>eAuth Level (OVERALL)</formal-name>
      <description><p>The overall electronic authentication (eAuth) level applied to the system.</p></description>
      <remarks>
         <p>Deprecated.</p>
      </remarks>
   </extension>

</extensions-registry>    

```

#### Option 1 Consequences

The proposed option 1  will:

- Consolidate the extensions into one machine-readable registry, making it easier for OSCAL practitioners to find guidance on FedRAMP extensions
- Consolidate the extensions into one machine-readable registry, making it easier for OSCAL practitioners to detect any changes (e.g., deprecations, addition of new extensions)
- Consolidate the extensions into one machine-readable registry, providing a central, authoritative source of FedRAMP extension information for the [FedRAMP Developer Hub](https://automate.fedramp.gov/documentation) site to reference (e.g., with deep links)
- Model the FedRAMP registry with Metaschema, making it easier to generate XML and JSON schemas for the registry, and allow the registry to be validated (e.g., using the OSCAL CLI)
- Model the FedRAMP registry with Metaschema, making it easier to automate documentation generation (e.g., using the OSCAL CLI, XSLT, or other methods)
- This approach could lead to drift between the extensions registry and the external constraints (e.g., which item is the source of truth if they have conflicting descriptions, remarks, etc.?)
- This approach adds some complexity (yet another model that may needs to be processed by practitioners)


### Option 2 - FedRAMP Leverages its existing External Constraints as Source of Extensions

This option leverages the existing FedRAMP external constraints ([fedramp-external-allowed-values.xml](../../src/validations/constraints/fedramp-external-allowed-values.xml) and [fedramp-external-constraints](../../src/validations/constraints/fedramp-external-constraints.xml)).

For example, all FedRAMP extensions have some corresponding constraint(s) (e.g., allowed values, cardinality, etc.).  These constraints specify the `context` or `target` (e.g., `"system-implementation//prop[@name='scan-type'][@ns='https://fedramp.gov/ns/oscal']/@value"`) of the constraint.  In this  case, we can see the FedRAMP "scan-type" `prop` is a FedRAMP extension and can automatically extract that information (**namespace**, **name**) from the FedRAMP allowed values constraints file using XSLT or any scripting approach than can easily process XML source file.  We can also easily extract the corresponding **constraint-id**, **description**, **level** and other useful information.  The same approach would be used to extract FedRAMP extension information from the FeRAMP external constraints file.  

Ideally, this option would consist of a single parser that would process both files FedRAMP external constraints ([fedramp-external-allowed-values.xml](src/validations/constraints/fedramp-external-allowed-values.xml) and [fedramp-external-constraints](src/validations/constraints/fedramp-external-constraints.xml)), and output a de-duplicated listing of the FedRAMP external constraints with all the pertinent information (**namespace**, **name**, **constraint-id**, **description**, **level**, etc.).  

While the `context` and `target` could be used to identify the FedRAMP constraints, adding a `prop` to the FedRAMP external constraints could further simplify the ability to extract extension information from the external constraints files.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<metaschema-meta-constraints xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">
    <context>
        <metapath target="/catalog//control"/>
        <constraints>
            <expect id="duplicate-response-point" target=".//part" test="count(prop[@ns='https://fedramp.gov/ns/oscal' and @name='response-point']) &lt;= 1" level="ERROR">
                <!-- example use of custom props in constraint to identify FedRAMP extension -->
                <prop namespace="https://fedramp.gov/ns/oscal" name="fedramp-extension-name" value="response-point"/>
                <message>Duplicate response point at '{ path(.) }'.</message>
            </expect>
        </constraints>
    </context>
</metaschema-meta-constraints>
```

#### Option 2 Consequences

The proposed option 2  will:

- Rely on the existing FedRAMP external constraints as the source of truth for identifying FedRAMP extensions and understanding how they are constrained.
- Use post-processing of the FedRAMP external constraints to generate a machine-readable FedRAMP extensions registry on-demand, providing a central, current and authoritative source of FedRAMP extension information for the [FedRAMP Developer Hub](https://automate.fedramp.gov/documentation) site to reference (e.g., with deep links)
  - Alternatively, the extensions registry could enable automatic generation of documentation (e.g., human-readable extensions registry on the [FedRAMP Developer Hub](https://automate.fedramp.gov/documentation) site )
- Will support generating and converting the registry in XML, JSON, and YAML
- This approach reduces complexity and maintenance by using the existing external constraints as the source for all the FedRAMP extensions.  It mitigates the risk for drift between the extensions registry and the external constraints

---

## Decision

TBD.  The FedRAMP automation team will consider these (and other submitted options) for consideration before finalizing a decision.  Factors considered in the decision will include:
- Ease of use by OSCAL practitioners - approaches that are most usable by the community are preferred
- Complexity of proposed approach - least amount of necessary complexity is preferred
- Effort / time required to implement - approaches that can be implemented with less effort / provide value to the community sooner are preferred
- Maintainability - approaches that can be maintained more easily are preferred