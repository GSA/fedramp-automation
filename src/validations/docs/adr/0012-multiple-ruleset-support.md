# 12. Multiple ruleset support

Date: 2023-03-09

## Status

Accepted

## Context

The 10x ASAP team has developed a collection of validations for FedRAMP requirements based primarily on NIST RMF revision 4. As the team transitions its development effort to FedRAMP, the team would like to enable the addition of other, future rulesets. For example, upcoming changes that incorporate NIST RMF revision 5 should live alongside the existing ruleset.

Two primary methods of achieving this were discussed:

1. Tag each validation rule in the source Schematron with the ruleset(s) it belongs to. Then, tooling may choose to ignore those rules that it is not interested in. A benefit of this approach is that the build process does not need to change, and changes to the user interface are limited to adding ruleset filters. A downside is that prior rules would need to continually be revisited as new rulesets become necessary, running the risk of breakage.
2. Create entirely segregated rulesets that reside in separate directories. A benefit of this approach is that changes to the new ruleset may be made without regard for how it impacts prior rulesets. The cost is that there are non-trivial changes to the directory structure, build system, and user interface to support this approach. Additionally, it necessitates duplication of code.

## Decision

The development team will implement separate directories for each ruleset. Each directory in the repository that includes ruleset-specific code will transition to a separate directory. For example:

src/validations/rules   --->   src/validations/rules/rev4
                               src/validations/rules/rev5
src/content             --->   src/content/rev4
                               src/content/rev5

## Consequences

FedRAMP will be able to support multiple rulesets at the same time, from the same build process.

Updates to the build system and web documentation will be necessary. At the time of writing this ADR, these changes have already been made.

Longer-term, this approach will ease the maintenance burden for the FedRAMP automation engineering effort.
