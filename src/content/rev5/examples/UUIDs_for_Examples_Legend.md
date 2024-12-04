# UUIDs for Examples

Example content with UUIDs can be difficult to follow due to the long, intentionally-random naure of UUIDs. It is possible to craft UUID values that are treated as valid by OSCAL validation tools, yet are easier to follow for developers.

# Example UUID Format

OSCAL allows v4 or v5 UUIDs as defined in [RFC-4122](https://datatracker.ietf.org/doc/html/rfc4122).
Please note that UUID values are hexidecimal. Any digit may contain the numbers 0 - 9 and the lower-case letters a - f.

The format used for examples is v4 compliant as follows:

```
00000000-0000-4000-8000-FFF0TTT00###
  FILE  MODEL ^    ^    FIELD   SEQUENCE 
```

**FILE**: The first grouping represents the OSCAL file. All digits are the same.
- If an example involves the SSP of two systems, the first system's SSP will use UUID values that starts with all 1's (`11111111-xxxx-4000-8000-xxxxxxxxxxxx`) and the second system will use UUID values that start with all 2's (`22222222-xxxx-4000-8000-xxxxxxxxxxxx`)
- If an example involves a catalog and a profile, the catalog will use all 1's (`11111111-xxxx-4000-8000-xxxxxxxxxxxx`) and the prifle will use all 2's (`22222222-xxxx-4000-8000-xxxxxxxxxxxx`).


**MODEL**: The second group of characters represents the model as follows:
- The values are as follows:
  - `0000`: Catalog
  - `1111`: Profile
  - `2222`: SSP
  - `3333`: Component Definition
  - `4444`: SAP
  - `5555`: SAR
  - `6666`: POA&M
- - If an example involves the SSP of two systems, both SSPs will use UUID values that have all 2's in the second grouping (`11111111-2222-4000-8000-xxxxxxxxxxxx` and `22222222-2222-4000-8000-xxxxxxxxxxxx`)


**^**: indicates a UUID v4 required digit. 
- The `4` in the third group is required by RFC-4122 to indicate the value is a v4 UUID. 
- The first digit in the forth group is rquired by RFC-4122 to always be `8`, `9`, or `a` - `f` (bimary `1xxx`). For example UUIDs, always use `8`.
- We will always use `4000` for the third grouping.
- We will always use `8000` for the forth grouping.


**FIELD**: `FFF`: Indicates the OSCAL field name associated with the UUID

**Metadata and Back Matter**
- `-0000`=root
- `-0010`=resource
- `-0020`=prop
- `-0030`=location
- `-0040`=party
- `-0050`=action

**SSP**
- `-0060`=information-type
- `-0070`=diagram
- `-0080`=user
- `-0090`=component
- `-0100`=protocol
- `-0110`=inventory-item
- `-0120`=implemented-requirement
- `-0130`=statement
- `-0140`=by-component
- `-0150`=provided
- `-0160`=responsibility
- `-0170`=inherited
- `-0180`=satisfied
- `-0190`=leveraged-authorization

_Fields for other models to be added as we work with those models._


- `TT`: Used to further distinguish a field that can have multiple types. It is optional and may be difficult to manage. Only use when this clarity is helpful or necessary. 

**Component Types** (`TT`)
- `0000`=This System
- `0010`=System
- `0020`=Interconnection
- `0030`=Software
- `0040`=Hardware
- `0050`=Service
- `0060`=Policy
- `0070`=Physical
- `0080`=Process/Procedure
- `0090`=Plan
- `0100`=Guidance
- `0110`=Standard
- `0120`=Validation
- `0130`=Network

**Enumeration**
- `0###`: A simple sequence number. (`001`, `002`, through `fff`)
- Start a new sequence for each system/model/field. 


# Examples:

### "This System"

Always `11111111-2222-4000-8000-009000000000` in its SSP.


### Resource UUIDs

All parties in example SSP content use: 
- `11111111-2222-4000-8001-001000000###`, where the first resource is `11111111-2222-4000-8001-001000000001`, the second party is `11111111-2222-4000-8001-001000000002`, etc.


Backmatter resources in an SSP will always appear as:
- `11111111-2222-4000-8001-001000000###`

Where:
- `11111111` represents the primary system in the example.
- `-2222` indicates this is in an SSP model.
- `-0010` indicates it is for a resource.
- The final three digits are assigned in sequence to each resource.

### Parties

All parties in example SSP content use: 
- `11111111-2222-4000-8001-004000000###`, where the first party is `11111111-2222-4000-8001-004000000001`, the second party is `-004000000002`, etc.  

Where:
- `11111111` represents the primary system in the example.
- `-2222` indicates this is in an SSP model.
- `0040` indicates it is for a party.
- The final three digits are assigned in sequence to each party.

### Components 

All components in example SSP content use: 
- `11111111-2222-4000-8001-0090TTT00###`, where the first resource is `11111111-2222-4000-8001-009000800001`, the second resource is `11111111-2222-4000-8001-009001200002`, etc.

Where:
- `11111111` represents the primary system in the example.
- `-2222` indicates this is in an SSP model.
- `-00900120` indicates it is for a component of type `validation`.
- `-00900080` indicates it is for a component of type `process-procedure` 
- The final three digits are assigned in sequence to each component as in the other examples above; however, the 6th - 8th digits in the last grouping are non-zero.



