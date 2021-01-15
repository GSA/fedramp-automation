# FedRAMP Validation Suite

## What is this?

This is the FedRAMP Validation Suite, a framework to take [FedRAMP documentation](https://www.fedramp.gov/templates/) that is properly formatted with [NIST OSCAL schemas](https://pages.nist.gov/OSCAL/) and check the content for correctness. [FedRAMP's adoption of OSCAL](https://www.youtube.com/watch?v=WCPkt56vZ-s) allows you to use this framework to perform logical validations, i.e. business rule checks, on documentation content. Currently, FedRAMP staff manually review the content provided by a cloud service provider for all steps of the [different](https://github.com/GSA/fedramp-gov/blob/master/assets/img/agency-auth.png) [authorization](https://github.com/GSA/fedramp-gov/blob/master/assets/img/ato-auth.png) processes. This framework and the associated business rules will automate as many of these checks as possible. Shared expectations are the goal: system owners, third-party assessors, or any interested party can use them as well.
## How does it work?

The [OSCAL data model](https://pages.nist.gov/OSCAL/documentation/schema/overview/) can be expressed in multiple machine-readable formats: XML, JSON, and YAML. This validation suite allows tool authors to receive a FedRAMP documentation artifact in XML and use FedRAMP's own validation framework and business rules using XSLT (Extensible Stylesheet Transformations). These authors can use the programming languages and frameworks of their choice, and the program will received a structured, machine-readable result (the XML SVRL standard). The results will encode:

- A direct reference to IDs FedRAMP reviewers use in their current checklist
- A detailed explanation of the business rule constraint and/or how it is not properly modeled with the relevant OSCAL schema to explain that reference in detail
- The location in the XML document where the error, list of errors, or the missing data should be added using the XPath standard

## Authors and Reviewers: What validations are currently implemented?

At this time, FedRAMP is primarily focused on standardizing and extending the composite checks for the different pieces of a FedRAMP System Security Plan and all required attachments. The official FedRAMP checklist items are listed below by section and ID.

For any error, the error message will be prefix with the section name and the check ID. For example, `[Section C Check 3.1a]` will be proceed the detailed explanation text. This validation suite does provide summary reporting information. As these are not errors in the report, if provided to help a reviewer, they will _not_ contain a section name and check ID.

This format will allow for reviewers to collaborate and communicate improvements with the development team. Therefore, you can direct the development team to the `@organizational-id` in [the validation suite source code](https://github.com/18F/fedramp-automation/blob/master/resources/validations/src/ssp.sch) that maps to these check IDs.
### Section B: Documents Provided Check

- [ ]  1.0	 Initial Authorization Package Checklist
- [ ]  2.0	 ATO Provided
- [ ]  3.0	 System Security Plan (SSP)
- [ ]  3.1	 Att. 1: Information Security Policies and Procedures
- [ ]  3.2	 Att. 2: User Guide
- [ ]  3.3	 Att. 3: Digital Identity Worksheet
- [ ]  3.4	 Att. 4: Privacy Threshold Analysis (PTA) and Privacy Impact Assessment (PIA) 
- [ ]  3.5	 Att. 5: Rules of Behavior (ROB)
- [ ]  3.6	 Att. 6: Information System Contingency Plan (ISCP)
- [ ]  3.7	 Att. 7: Configuration Management Plan (CMP)
- [ ]  3.8	 Att. 8: Incident Response Plan (IRP)
- [ ]  3.9	 Att. 9: Control Implementation Summary (CIS) Workbook 
- [ ]  3.10 Att. 10: Federal Information Processing Standard (FIPS) 199 Categorization
- [ ]  3.11 Att. 11: Separation of Duties Matrix
- [ ]  3.12 Att. 12: FedRAMP Laws and Regulations
- [ ]  3.13 Att. 13: FedRAMP Integrated Inventory Workbook

### Section C: Overall SSP Checks

- [X]  1a Is the correct SSP Template used?
- [ ]  1b Is the correct Deployment Model chosen for the system? 
- [X]  2  Do all controls have at least one implementation status checkbox selected?
- [X]  3  Are all critical controls implemented?
- [ ]  4a Are the customer responsibilities clearly identified in the CIS-CRM Tab, as well as the SSP Controls (by checkbox selected and in the implementation description)?  Are the CIS-CRM and SSP controls consistent for customer responsibilities? A sampling of seven controls involving customer roles is reviewed.
- [ ]  4b Does the Initial Authorizing Agency concur with the CRM (adequacy and clarity of customer responsibilities)?
- [ ]  5  Does the Roles Table (User Roles and Privileges) sufficiently describe the range of user roles, responsibilities, and access privileges?
- [X]  6  In the control summary tables, does the information in the Responsible Role row correctly describe the required entities responsible for fulfilling the control? (50% complete, control mapping will complete this work in [18F/fedramp-automation#51](https://github.com/18F/fedramp-automation/issues/51))
- [ ]  7  Is the appropriate Digital Identity Level selected?
- [ ]  8a Is the authorization boundary explicitly identified in the network diagram?
- [ ]  8b Does the CSO provide components to run on the client side? 
- [ ]  9  Is there a data flow diagram that clearly illustrates the flow and protection of data going in and out of the service boundary and that includes all traffic flows for both internal and external users?
- [ ]  10 Does the CSP use any third-party or external cloud services that lack FedRAMP Authorization?
If so, please list them.
- [ ]  11a If this is a SaaS or a PaaS, is it "leveraging" another IaaS with a FedRAMP Authorization?
- [ ]  11b If 11a is Yes, are the "inherited" controls clearly identified in the control descriptions?
- [ ]  12  Are all interconnections correctly identified and documented in the SSP?
- [X]  13  Are all required controls present?
- [ ]  14  Is the inventory provided in the FedRAMP Integrated Inventory Workbook?
- [ ]  15  Is the CSO compliant with DNSSEC? (Controls SC-20 and SC-21 apply)
- [ ]  16  Does the CSO adequately employ Domain-based Message Authentication, Reporting & Conformance (DMARC) requirements according to DHS BOD 18-01?

## Section D

NOTE: Section D currently has specific system security plan controls from [the 800-53 control family](https://nvd.nist.gov/800-53) called out specifically. This validation suite will run the checks across FedRAMP critical controls (Section C Check #3) and any control statement found, regardless of whether the SSP author used a FedRAMP, Low, Moderate, or High template. This framework will automatically determine all required controls and the subset of critical controls given the sensitivity level for the system described in the documents. Therefore, all quality checks at the individual control level will be labelled as `[Section D]`  validation errors at this time.

## Authorizing Officials: Using this for FISMA-Based Authorizations Not Part of FedRAMP

Do you want your government agency or operational division to have similar business rules to perform logical validations? Please [open an issue](https://github.com/18F/fedramp-automation/issues/new/choose) or [send us an email](mailto:info@FedRAMP.gov). This framework is meant to be reusable and extensible. For development teams, see below for guidance for your technical teams.

## Developers: Need Help or Have a Technical Question?

If you have a technical question or want to recommend and/or submit a PR to our
project for new features and enhancements, please read the [Contributors' Guide](./CONTRIBUTING.md)
or [open an issue](https://github.com/18F/fedramp-automation/issues/new/choose).
