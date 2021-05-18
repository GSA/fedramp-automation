# 6. Evaluate the Use of XProc for Development, Testing, and Continuous Integration

Date: 2021-05-18

## Status

Accepted

## Context

Early in the project, the development team decided to evaluate one of the existing task runners supporting [the XProc standard](https://spec.xproc.org/master/head/xproc/) to ease adoption of the FedRAMP validations prototype into projects reliant on XML and the XML ecosystem, per [18F/fedramp-automation#16](https://github.com/18F/fedramp-automation/issues/16).

At the time of this spike effort, there were [two XProc processors](https://xproc.org/processors.html):
- MorganaXProc-III
- XProc Calabash

Only MorganaXProc-III is ready for general use., and XProc Calabash is in active development. [MorganaXproc-III also has support for directly integrating Schematron validation](https://www.xml-project.com/files/doc/manual.html#d5e226) without additional customization, so this was seen as a nice benefit to reduce ongoing maintenance of ongoing scripts.

## Decision

After evaluation of available XProc tools, the development decided not to fully implement a pipeline in XProc for development, testing, and continuous integration. They assessed the level of effort required to integrate them into one or more Github Actions we would need to either extend or develop from scratch. Running these pipelines locally with desktop software with commercial tools, like OxygenXML and other common XML development software, would require development effort focused outside of the FedRAMP validations. The development team decided against it primarily over the level of effort for these supporting efforts.

## Consequences

The primary consequence the development team will continue to write shell scripts for local development, testing, and continuous integration tasks. Although simple to reason about and familiar to developers then and now, it more immediately limits the operating systems and confines certain choices around developer tooling.
