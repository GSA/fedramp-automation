# 5. Collect usage metrics

Date: 2022-04-15

## Status

Accepted

## Context

The 10x ASAP team, developers of the Schematron validations and the corresponding front-end, would like to understand how users are making use of the frontend, and how effectively users are able to remediate validation errors.

The team plans to collect such data during the course of the project's phase 4, and must decide how to do so. It is presumed that the user must opt-in to data collection, and that full disclosure of all data collected is a requirement.

### Possible Solutions

#### Digital Analytics Program

The [Digital Analytics Program (DAP)](https://digital.gov/guides/dap/) is a managed Google Analytics account. Limited event data may be posted to DAP and analyzed via the Google Analytics interface.

There is a size limit to posted event data, which is problematic given the large number of validations that may trigger assertions in the ASAP tool. Additionally, the team would not directly have control over who can access this data. Lastly, browser plugins such as uBlock Origin block DAP traffic.

#### Cloud.gov-hosted analytics platform

The phase 4 team could self-host an database-backed service. This would require development and devops effort.

#### Use Google Forms

A final option is to use a solution that does not require self-hosting. Google Forms fulfills this niche. The process would involve creating a Google Form, backing it with a Google Sheet, and then manually extracting the generated field IDs from the form so that the application may send an HTTP post to the form endpoint.

## Decision

We will use a Google Form for usage metrics, and will also configure DAP for general web traffic data.

## Consequences

- Does not require self-hosted resources.
- Flexible enough to collect arbitrary data in JSON format.
- Does not require disabling of browser traffer blockers.
