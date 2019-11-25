<h2>Federal Risk and Authorization Management Program (FedRAMP) Automation<img src='./assets/FedRAMP_LOGO.png' alt="FedRAMP" width="76" height="94"></h2>

### November 27, 2019

FedRAMP is excited to announce that the program has reached an important milestone in automating security documentation. Since May 2018, FedRAMP has worked closely with NIST and industry to develop the Open Security Controls Assessment Language (OSCAL), a standard language and framework that can be applied to the publication, implementation, and assessment of security controls. 

FedRAMP expects that OSCAL will offer a number of benefits to make things easier for stakeholders. 
- **Cloud Service Providers (CSPs)** will be able to create their System Security Plans (SSPs) more rapidly and accurately, validating much of their content before submission.
- **Third Party Assessment Organizations (3PAOs)** will be able to automate the planning, execution, and reporting of assessment activities.
- **Leveraging Agencies** will be able to import authorization content into existing tools, rather than entering it manually.

FedRAMP is building OSCAL-based tools, beginning with a tool to speed up and automate the review of SSP content submitted in an OSCAL format.

NIST and FedRAMP just released [OSCAL Milestone 2](https://github.com/usnistgov/OSCAL/releases), which offers: 
- A new System Security Plan (SSP) model that lets organizations automate the documentation of security and privacy control implementation using OSCAL 
- Updated content for the four FedRAMP baselines, the three NIST baselines, and the NIST SP 800-53 revision 4 catalog in OSCAL XML, JSON, and YAML formats
- Updated stable versions of the OSCAL catalog and profile models and associated XML and JSON schemas 
- Tools to convert the OSCAL catalog, profile, and SSP content between OSCAL, XML, and JSON
- A registry of FedRAMP-specific extensions, FedRAMP-defined identifiers, and acceptable values when using OSCAL
- A guidance document to aid tool developers in generating fully compliant OSCAL-based FedRAMP SSP content.
- An OSCAL-based FedRAMP SSP template, available in both XML and JSON formats.

**FedRAMP Wants Your Technical Feedback!**<br />
Are you well versed in XML, JSON, or YAML? If so, FedRAMP wants your feedback on the below content. For the below items, please provide comments either via email to info@fedramp.gov, as a comment to an existing issue, or as a new issue via GitHub within the FedRAMP-SSP repository [add link once repo is established]. 
- **FedRAMP OSCAL Registry:** This will serve as the authoritative source for all FedRAMP extensions to the OSCAL syntax, FedRAMP-defined identifiers, and accepted values. The draft for public comment is available here[need link].
- **Guidance Document:** Modeling a FedRAMP SSP in OSCAL: This document enables tool developers to generate OSCAL-based SSP files that are fully compliant with FedRAMP’s extensions, defined identifiers, and acceptable values. The draft for public comment is available [here](https://github.com/GSA/fedramp-automation/raw/master/content/Modeling_a_FedRAMP-SSP_in_OSCAL.pdf).
- **OSCAL-based FedRAMP SSP Template:** The template file is pre-populated with FedRAMP extensions and defined-identifiers where practical. It also includes some sample data, and is the basis for the guidance document above.  The draft for public comment is available in both XML and JSON formats here[need link].
- **FedRAMP Baselines:** The FedRAMP baselines for High, Moderate, Low, and Tailored for Low Impact-Software as a Service (LI-SaaS) in OSCAL (XML, JSON, and YAML formats) are available here. 

**NIST Wants Your Feedback!**<br />
For the below items, please provide comments either via email to oscal@nist.gov, as a comment to an existing issue, or as a new issue via the NIST OSCAL GitHub site.
- **System Security Plan (SSP) model:** This SSP model lets organizations document the security and privacy control implementation of their systems using a rich OSCAL model. The model can represent any type of SSP, including FedRAMP SSP content. The syntax is available here. Content Converters: The converters accurately convert OSCAL catalog, profile, and SSP content from XML to JSON format and JSON to XML. 
- **Content Converters:** The converters accurately convert OSCAL catalog, profile, and SSP content from XML to JSON format and JSON to XML. 
- **NIST’s 800-53 & 53A Revision 4:** NIST is also providing SP 800-53 and 800-53A, Revision 4 content as well as the NIST High, Moderate, and Low baselines in OSCAL (XML, JSON, and YAML formats) here. 

A complete package containing the NIST OSCAL converters, syntax validation tools, 800-53 and FedRAMP baselines content is available for download in both ZIP and BZ2 formats. FedRAMP looks forward to receiving your comments and sharing additional progress.

**Public Comment Period**<br />
We will accept feedback at any time. To ensure FedRAMP considers your feedback before the full release of these documents, please respond no later than January 31, 2020.



