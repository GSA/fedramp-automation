# UUIDs for Examples

Example content with UUIDs can be difficult to follow due to the long, intentionally-random naure of UUIDs. It is possible to craft UUID values that are treated as valid by OSCAL validation tools, yet are easier to follow for developers.

# Example UUID Format

OSCAL allows v4 or v5 UUIDs as defined in [RFC-4122](https://datatracker.ietf.org/doc/html/rfc4122).
Please note that UUID values are hexidecimal. Any digit may contain the numbers 0 - 9 and the lower-case letters a - f.

The format used for examples is v4 compliant as follows:

```
00000000-0000-4000-80SS-MFFF0TT00###
              ^    ^
```

The first group of eight characters and the second group of four characters is always set to zeros (`00000000-0000-`)

**^**: indicates a UUID v4 required digit. 
- The `4` in the third group is required by RFC-4122 to indicate the value is a v4 UUID.
- the first digit in the forth group is rquired by RFC-4122 to always be `8`, `9`, or `a` - `f` (bimary `1xxx`). For example UUIDs, always use `8`.


`SS`: indicates whether the UUID is for the primary system represented in the example or another, external system. 
   `01` = this system
   `02` - `ff` = other systems

`M`: The model being represented in the example (useful for when a POA&M or SAR points to content in an SSP)
  `a` = catalog
  `b` = profile
  `c` = ssp
  `d` = poam
  `e` = sap
  `f` = sar
  `0` = component defintions 

`FFF`: Indicates the OSCAL field name associated with the UUID

**Metadata and Back Matter **
`000`=root
`001`=resource
`002`=prop
`003`=location
`004`=party
`005`=action

**SSP**
`006`=information-type
`007`=diagram
`008`=user
`009`=component
`010`=protocol
`011`=inventory-item
`012`=implemented-requirement
`013`=statement
`014`=by-component
`015`=provided
`016`=responsibility
`017`=inherited
`018`=satisfied
`019`=leveraged-authorization

_Fields for other models to be added as we work with those models._


`TT`: Used to further distinguish a field that can have multiple types. 

**Component Types** (`TT`)
`0`=This System
`1`=System
`2`=Interconnection
`3`=Software
`4`=Hardware
`5`=Service
`6`=Policy
`7`=Physical
`8`=Process/Procedure
`9`=Plan
`10`=Guidance
`11`=Standard
`12`=Validation
`13`=Network

**Enumeration**
`###`: A simple sequence number. (`001`, `002`, through `fff`)
- Start a new sequence for each system/model/field. 


# Examples:

In all example UUIDs, the first 18 digits are always: `00000000-0000-4000-80`

### Resource UUIDs

All parties in example SSP content use: 
`00000000-0000-4000-8001-c00100000###`, where the first resource is `00000000-0000-4000-8001-c00100000001`, the second party is `00000000-0000-4000-8001-c00100000002`, etc.


Backmatter resources in an SSP will always appear as:
`00000000-0000-4000-8001-c00100000###`

Only the final 14 digits (`01-c00400000###`) are relevant.   

Looking just the relevant digits above:
`01` represents the primary system in the example.
`c` indicates this is in an SSP model.
`001` indicates it is for a resource.
The final three digits are assigned in sequence to each resource.

### Parties

All parties in example SSP content use: 
`00000000-0000-4000-8001-c00400000###`, where the first party is `00000000-0000-4000-8001-c00400000001`, the second party is `00000000-0000-4000-8001-c00400000002`, etc.

Only the final 14 digits (`01-c00400000###`) are relevant.   

Looking just the relevant digits above:
`01` represents the primary system in the example.
`c` indicates this is in an SSP model.
`004` indicates it is for a party.
The final three digits are assigned in sequence to each party.

### Components 

All components in example SSP content use: 
`00000000-0000-4000-8001-c00900120###`, where the first resource is `00000000-0000-4000-8001-c00900080001`, the second party is `00000000-0000-4000-8001-c00900120002`, etc.

Only the final 14 digits (`01-c00400000###`) are relevant.   

Looking just the relevant digits above:
`01` represents the primary system in the example.
`c` indicates this is in an SSP model.
`009` indicates it is for a component.
The final three digits are assigned in sequence to each component as in the other examples above; however, the 6th - 8th digits in the last grouping are non-zero.

`012` indicates the UUID is for a `validation` component
`008` indicates the UUID is for a `process-procedure` component 


