# 11. FedRAMP System Identifier Type and Namespace

Date: 2024-10-11

## Status

Proposed

## Context

The FedRAMP automation team needs to provide clear guidance on the acceptable values for an SSP system `identifier-type`, for its extension `prop` namespace values, and the  naming system identifier `system` attribute (used in the assessent results and POA&M).

The OSCAL models specify a set of allowed values for `identifier-type` (see [OSCAL Metaschema Model](https://github.com/usnistgov/OSCAL/blob/4f02dac6f698efda387cc5f55bc99581eaf494b6/src/metaschema/oscal_implementation-common_metaschema.xml#L676-L704)).  For FedRAMP systems, the only allowed value is "http://fedramp.gov/ns/oscal" because "https://fedramp.gov" is deprecated.   However, use of "http://fedramp.gov/ns/oscal" for `identifier-type` may cause some confusion as FedRAMP extensions currently have `@ns` values of "https://fedramp.gov/ns/oscal" (notice the difference - **http** vs **https**).  Currently, the allowed value for naming system identifier (in the assessment results and POA&M) is "https://fedramp.gov/ns/oscal".

## Possible Solutions

The team considered multiple approaches listed below.

1. **Option 1** - require "https://fedramp.gov" for `identifier-type`, `system`, and `prop` namespaces attribute value.  
  - Pros - the `identifier-type`, `system`, and FedRAMP extension `@ns` share the same value, reducing confusion.
  - Cons - this value is marked as a deprecated `identifier-type` in the NIST model, thus creating a misalignment between core OSCAL and FedRAMP OSCAL requirements.

2. **Option 2** - require "http://fedramp.gov/ns/oscal" for `identifier-type`, `system`, and `prop`.  
  - Pros - this approach aligns with NIST allowed values for `identifier-type`, and has the added benefit of reducing confusion since all use the same FedRAMP URI value. 
  - Cons - this approach is likely to impact the community since FedRAMP extensions will all need to be updated (e.g., change "https" to "http" in existing FedRAMP OSCAL documents).  OSCAL content generating tools will also be impacted by the `@ns` change for FedRAMP extensions.

3. **Option 3** - require "https://fedramp.gov/ns/oscal" for `identifier-type`, `system`, and `prop` namespaces attribute value.  
  - Pros - perceived lesser impact on existing FedRAMP OSCAL documents and tools, as only the `identifier-type` would require change.
  - Cons - this approach does not align with NIST allowed-value for `identifier-type` which may cause confusion, thus creating a misalignment between core OSCAL and FedRAMP OSCAL requirements.

4. **Option 4** - go with "http://fedramp.gov/ns/oscal" for `identifier-type`, and "https://fedramp.gov/ns/oscal" for FedRAMP extension `prop` namespaces and `system`.  
  - Pros - this approach aligns with NIST OSCAL allowed value for `identifier-type`, while preserving the current FedRAMP extension `prop` namespace value.  This requires no change to existing FedRAMP OSCAL content or tools.
  - Cons - FedRAMP OSCAL practitioners may be confused by the minor, subtle difference in allowed values for `identifier-type`, `system` and FedRAMP extention `prop` namespaces. 

## Decision

Proceed with Option 2.  The inconsistency in documentation and tooling was the source of a bug that initiated an investigation and led to this ADR. This change will have an impact on updating documentation for FedRAMP, but there is little evidence or public feedback to indicate one or more community-maintained tools warrant this concern. Alignment sooner rather than later by FedRAMP, who will operationalize the FedRAMP constraints, is a key factor to prioritize this change the soonest major release, not defer it until later.

## Consequences

Option 2 is not backwards compatible, as it requires updates to existing FedRAMP documentation. However, it establishes a consistent and maintainable standard that will reduce ambiguity in the long term. Implementing this now also minimizes the risk of future misalignment.