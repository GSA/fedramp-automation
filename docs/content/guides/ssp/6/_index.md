---
title: 6. ATTATCHMENTS
toc:
  enabled: true
weight: 600
aliases:
  /ssp/6/
suppresstopiclist: true
---

Classic FedRAMP attachments include a mix of items. Some lend well to machine-readable format, while others do not. Machine-readable content is typically addressed within the OSCAL-based FedRAMP SSP syntax, while policies, procedures, plans, guidance, and the rules of behavior documents are all treated as classic attachments, as described in the *Citations, Attachments, and Embedded Content in OSCAL Files* Section. The following table describes how each attachment is handled:

|**ATTACHMENT**|**MACHINE READABLE**|**HOW TO HANDLE**|
| :- | :- | :- |
|**Policies and Procedures**|No|<p>Attach using the back-matter, resource syntax. </p><p>Use resource id="att-policy-**1**" for policies, and set type to "policy".</p><p>Use resource id="att-procedure-**1**" for procedures, and set type to "procedure".</p>|
|**User Guide**|No|<p>Attach using the back-matter, resource syntax.</p><p>Use resource id="att-guide-**1**" for guides, and set type to "guide".</p>|
|**Digital Identity Worksheet**|Yes|Incorporated above. See the *Digital Identity Determination* Section.|
|**Privacy Threshold Analysis (PTA)**|Yes|Incorporated into System Information. See the *Privacy Impact Assessment* Section.|
|**Privacy Impact Assessment (PIA)**|No (Future)|<p>Attach using the back-matter, resource syntax.</p><p>Use resource id="att-pia".<br>FedRAMP intends to incorporate machine-readable PIA content into the OSCAL-based FedRAMP SSP at a later date.</p>|
|**Rules of Behavior**|No|<p>Attach using the back-matter, resource syntax.</p><p>Use resource id="att-rob" for procedures, and set type to "rob".</p>|
|**Information System Contingency Plan**|No|<p>Attach using the back-matter, resource syntax.</p><p>Use resource id="att-plan-**cp**" for procedures, and set type to "plan".</p>|
|**Configuration Management Plan**|No|<p>Attach using the back-matter, resource syntax.</p><p>Use resource id="att-plan-**cm**" for procedures, and set type to "plan".</p>|
|**Incident Response Plan**|No|<p>Attach using the back-matter, resource syntax.</p><p>Use resource id="att-plan-**ir**" for procedures, and set type to "plan".</p>|
|**CIS Workbook**|Yes|This can be generated from the content in the Security Controls section and no longer needs to be maintained separately or attached. |
|**FIPS-199**|Yes|Incorporated above. See the *Security Objectives Categorization (FIPS-199)* Section.|
|**Inventory**|Yes|See the *System Inventory* Section below.|