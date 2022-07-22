---
title: 4. SSP Template to OSCAL Mapping
toc:
  enabled: true
weight: 400
aliases:
  /ssp/4/
suppresstopiclist: true
---

For SSP-specific content, each page of the SSP is represented in this section, along with OSCAL code snippets for representing the information in OSCAL syntax. There is also XPath syntax for querying the code in an OSCAL-based FedRAMP SSP represented in XML format.

Content that is common across OSCAL file types is described in the [*Guide to OSCAL-based FedRAMP Content](https://github.com/GSA/fedramp-automation/raw/master/documents/Guide_to_OSCAL-based_FedRAMP_Content.pdf)*.* This includes the following:

|**TOPIC**|**LOCATION**|
| :- | :- |
|**Title Page**|[*Guide to OSCAL-based FedRAMP Content](https://github.com/GSA/fedramp-automation/raw/master/documents/Guide_to_OSCAL-based_FedRAMP_Content.pdf)*, Section 4.1*|
|**Prepared By/For**|[*Guide to OSCAL-based FedRAMP Content](https://github.com/GSA/fedramp-automation/raw/master/documents/Guide_to_OSCAL-based_FedRAMP_Content.pdf)*, Section 4.2 - 4.4*|
|**Record of Template Changes**|Not Applicable. Instead follow [*Guide to OSCAL-based FedRAMP Content](https://github.com/GSA/fedramp-automation/raw/master/documents/Guide_to_OSCAL-based_FedRAMP_Content.pdf)*, Section 2.3.2, OSCAL Syntax Version*|
|**Revision History**|[*Guide to OSCAL-based FedRAMP Content](https://github.com/GSA/fedramp-automation/raw/master/documents/Guide_to_OSCAL-based_FedRAMP_Content.pdf)*, Section 4.5*|
|**How to Contact Us**|[*Guide to OSCAL-based FedRAMP Content](https://github.com/GSA/fedramp-automation/raw/master/documents/Guide_to_OSCAL-based_FedRAMP_Content.pdf)*, Section 4.6*|
|**Document Approvers**|[*Guide to OSCAL-based FedRAMP Content](https://github.com/GSA/fedramp-automation/raw/master/documents/Guide_to_OSCAL-based_FedRAMP_Content.pdf)*, Section 4.7*|
|**Acronyms and Glossary**|[*Guide to OSCAL-based FedRAMP Content](https://github.com/GSA/fedramp-automation/raw/master/documents/Guide_to_OSCAL-based_FedRAMP_Content.pdf)*, Section 4.8*|
|**Laws, Regulations, Standards and Guidance**|[*Guide to OSCAL-based FedRAMP Content](https://github.com/GSA/fedramp-automation/raw/master/documents/Guide_to_OSCAL-based_FedRAMP_Content.pdf)*, Section 4.9*|
|**Attachments and Citations**|[*Guide to OSCAL-based FedRAMP Content](https://github.com/GSA/fedramp-automation/raw/master/documents/Guide_to_OSCAL-based_FedRAMP_Content.pdf)*, Section 4.10*|

It is not necessary to represent the following sections of the SSP template in OSCAL; however, tools should present users with this content where it is appropriate:

- Any blue-text instructions found in the SSP template, where the instructions are related to the content itself. 
- Table of Contents
- Introductory and instructive content in sections 1 through 12, such as references to the NIST SP 800-60 Guide to Mapping Types, and the definitions from FIPS Pub 199.
- The control origination definitions are in Section 13 (Table 13-2); however, please note hybrid and shared are represented in OSCAL by specifying more than one control origination.

The OSCAL syntax in this guide may be used to represent the High, Moderate, and Low FedRAMP SSP Templates. Simply ensure the correct FedRAMP baseline is referenced using the import-profile statement.