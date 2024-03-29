---
title: Working with OSCAL Files
weight: 102
---

This section provides a summary of several important concepts and details that apply\ to OSCAL-based FedRAMP SAR files.

The [*Guide to OSCAL-based FedRAMP Content*](/guides) provides important concepts necessary for working with any OSCAL-based
FedRAMP file. Familiarization with those concepts is important to understanding this guide.

## 3.1. XML and JSON Formats

The examples provided here are in XML; however, FedRAMP accepts XML or JSON formatted OSCAL-based SAR files. NIST offers a utility that
provides lossless conversion of OSCAL-compliant files between XML and JSON in either direction.

You may submit your SAR to FedRAMP using either format. If necessary, FedRAMP tools will convert the files for processing.

## 3.2. SAR File Concepts

Unlike the traditional MS Word-based SSP, SAP, and SAR, the OSCAL-based versions of these files are designed to make information available through linkages, rather than duplicating information. In OSCAL, these linkages are established through import commands.

![OSCAL File Imports](/img/sar-figure-1.png)
*Each OSCAL file imports information from the one to the left*

For example, the assessment objectives and actions that appear in a blank test case workbook (TCW), are defined in the FedRAMP profile, and simply referenced by the SAP and SAR. Only deviations from the TCW are captured in the SAP or SAR.

![Baseline Information](/img/sar-figure-2.png) \
*Baseline Information is referenced instead of duplicated.*

For this reason, an OSCAL-based SAR points to the OSCAL-based SAP for this assessment.

In turn, the SAP points to the OSCAL-based SSP of the system being assessed. Instead of duplicating system details, the OSCAL-based SAR
simply points to the SSP content (via the SAP) for information such as system description, boundary, users, locations, and inventory items.

The SAR also inherits the SSP\'s pointer to the appropriate OSCAL-based FedRAMP Baseline via the SAP. Through that linkage, the SAR references the assessment objectives and actions typically identified in the FedRAMP TCW, as well as any changes to this content made in the SAP during planning.

The only reason to include this content in the SAR is when there is a deviation from the SAP.

### 3.2.1. Resolved Profile Catalogs

The resolved profile catalog for each FedRAMP baseline is a pre-processing of the profile and catalog to produce the resulting data.
This reduces overhead for tools by eliminating the need to open and follow references from the profile to the catalog. It also
includes only the catalog information relevant to the baseline, reducing the overhead of opening a larger catalog.

Where available, tool developers have the option of following the links from the profile to the catalog as described above or using the resolved profile catalog.

Developers should be aware that at this time catalogs and profiles remain relatively static. As OSCAL gains wider adoption, there is a risk that profiles and catalogs will become more dynamic, and a resolved profile catalog becomes more likely to be out of date. Early adopters may wish to start with the resolved profile catalog now, and plan to add functionality for the separate profile and catalog handling later in their product roadmap.

![Baseline Information](/img/sar-figure-3.png) \
*The Resolved Profile Catalog for each FedRAMP Baseline reduces tool processing.*

For more information about resolved profile catalogs, see the [*Guide to OSCAL-based FedRAMP Content*](/guides/5-appendices/#profile-resolution) *Appendix, Profile Resolution*.

### 3.2.2. Assessment Deviations and SAP/SAR Syntax Overlap

The SAP represents the assessment intentions before it starts and should not be modified once the assessment starts. The SAR represents what actually happened during the assessment, in addition to reporting the results.

![Assessment Results to POA&M](/img/sar-figure-4.png)

The SAR reference SAP content when those references are accurate and defines content locally when the assessment details deviate from the SAP. Similarly, the SAR\'s assessment log captures the actual timing of events and can be linked to the SAP\'s defined tasks (schedule).

FedRAMP\'s requirement to report assessment deviations can be very straightforward if the above approach is supported by tools.

For schedule deviations, a SAR's tools can simply compare the SAR assessment log to the SAP tasks and report differences.

Any other changes are essentially summarized in the SAR\'s local definitions. The overarching local definitions captures changes to
defined activities or control objectives. The \"Result\" local definitions capture missing or inaccurate components, inventory items, users, and assessment tools.

Instead of an assessor manually summarizing assessment deviations, a tool can simply compare the SAP and SAR content and report the
differences automatically. 

### 3.2.3. Copying SAR Residual Risks to the POA&M

FedRAMP requires residual risks from an initial or annual assessment to be reflected in the POA&M. The observation and risk assemblies syntax of the SAR and POA&M are identical to facilitate ease of transfer. The SAR finding assembly and POA&M poam-item assembly are also as similar as possible to further facilitate this transfer.

At the end of an assessment, copy all \"open\" risks from the SAR to POA&M. For every copied risk, also copy all related observations. Risks are linked to observations in the finding assembly.

If available, use the finding/target citation in the SAR to determine the impacted control and set the value in the risk section of the POA&M using the \"impacted-control\" FedRAMP Extension. If the identified SAR risk is not associated with a specific control, the SAR tool should prompt the assessor to assign a value for the risk in the resulting POA&M export.

It may also be necessary to copy content from the AP or SAR into the POA&M\'s Local Definitions, such as to ensure Observation/Origin references remain valid.

![Assessment Results to POA&M](/img/sar-figure-5.png)

A SAR tool can transfer residual risks to a POA&M using the same OSCAL syntax.

Ideally, tools will automatically detect potential duplicate risks between a new SAR and existing POA&M. In any case, tools should offer a mode for manual review and merging of duplicate risks from different sources.

A SAR tool should collect Test Case Workbook, Automated Tool Output, Manual Test Results, and Penetration Test Results as a series of individual finding assemblies.

As these findings become risks, the SAR tool should allow the risk information to be added to the finding.

As risks are closed during testing, the SAR tool should allow the assessor to mark the status as closed. Likewise, as a risk is found to be a false positive or operationally required, the tool should allow the assessor to make these changes as well. The tool should also provide for risk adjustments, by preserving the initial risk information and adding mitigating factors and adjusted risk values.

Allowing for these adjustments, the Risk Exposure table is simply a view or presentation of the findings that have risks with an open status that have not been marked as a false positive. These are also the entries that are copied to the Cloud Service Provider (CSP)\'s POA&M.

![Assessment Results to POA&M](/img/sar-figure-6.png)

A SAR allows the assessor to update finding and risk information during the assessment.

### 3.2.4. Previous Assessment Results

The OSCAL assessment results model is designed to support both continuous assessment as well as snapshot in time assessments. Currently, FedRAMP assessments represent a snapshot in time. This means a single result assembly should be used for all of the current assessment findings.

Any findings from previous assessments may be included in the SAR by including each in its own result assembly. In this way, the assessor can include the \"snapshot\" of each previous assessment with the current assessment, eliminating the need to manually copy past findings into that portion of the TCW.

#### SAR Representation
{{< highlight xml "linenos=table" >}}
  <result uuid="d2b54365-1b4c-427c-a42d-5ad2932a0a73">
      <title>2023 Annual Assessment</title>
      <description></description>
      <start>2023-03-01T00:00:00Z</start>
      <end>2023-03-12T00:00:00Z</end>
      <!-- findings -->
  </result>
  <result uuid="fcaa8260-8254-49d3-9ca2-751bacd4b715">
      <title>2022 Annual Assessment</title>
      <description></description>
      <start>2022-03-01T00:00:00Z</start>
      <end>2022-03-12T00:00:00Z</end>
      <!-- findings -->
  </result>
  <result uuid="6608034d-aa14-4c82-b60d-57dc5aeeecee">
      <title>2021 Initial Assessment</title>
      <description></description>
      <start>2021-03-01T00:00:00Z</start>
      <end>2021-03-12T00:00:00Z</end>
      <!-- findings -->
  </result>

{{</ highlight >}}

#### XPath Queries
{{< highlight xml "linenos=table" >}}
(SAR) Number of Assessments Represented:
  count(/*/result)
(SAR) Start Date of First Results Set:
  /*/result/start[1]
NOTE: Replace "[1]" with "[2]", "[3]", etc.
NOTE: Compare start dates of each result set to identify the newest.

{{</ highlight >}}

## 3.3. OSCAL-based FedRAMP SAR Template

FedRAMP offers an OSCAL-based SAR shell file in both XML and JSON formats. This shell contains many of the FedRAMP required standards to
help get you started. This document is intended to work in concert with that file. The OSCAL-based FedRAMP SAR Template is available in XML and JSON formats here:

-   OSCAL-based FedRAMP SAR Template (JSON Format):\
    [https://github.com/GSA/fedramp-automation/raw/master/dist/content/rev5/templates/sar/json/FedRAMP-SAR-OSCAL-Template.json](https://github.com/GSA/fedramp-automation/raw/master/dist/content/rev5/templates/sar/json/FedRAMP-SAR-OSCAL-Template.json)

-   OSCAL-based FedRAMP SAR Template (XML Format):\
    [https://github.com/GSA/fedramp-automation/raw/master/dist/content/rev5/templates/sar/xml/FedRAMP-SAR-OSCAL-Template.xml](https://github.com/GSA/fedramp-automation/raw/master/dist/content/rev5/templates/sar/xml/FedRAMP-SAR-OSCAL-Template.xml)

## 3.4. OSCAL's Minimum File Requirements

Every OSCAL-based FedRAMP SAR file must have a minimum set of required fields/assemblies, and must follow the OSCAL Assessment Results model syntax found here:

[https://pages.nist.gov/OSCAL/concepts/layer/assessment/assessment-results/](https://pages.nist.gov/OSCAL/concepts/layer/assessment/assessment-results/)

## 3.5. Importing the Security Assessment Plan

OSCAL is designed for traceability. Because of this, the assessment report is designed to be linked to the security assessment plan. Rather than duplicating content from the SSP and SAP, the SAR is intended to reference the SSP and SAP content itself.

{{<callout>}}
#### *Unavailable or Inaccurate OSCAL-based SSP Content*
*The SAR must import an OSCAL-based SAP, even if no OSCAL-based SSP exists. FedRAMP enables an assessor to use the OSCAL SAP and SAR, when no OSCAL-based SSP exists, or where the assessor finds it to be inaccurate. The [Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP)](/guides/sap/4-sap-template-to-oscal-mapping/) describes when and how to represent missing or inaccurate SSP content.*

*SAR tools must search both the SSP (if any) and the SAP for any SSP-related references. If an ID in the SAR references content in both the SSP and the SAP, the tool should treat the SAP content as an update to the SSP content. See the [Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP)](/guides/sap/4-sap-template-to-oscal-mapping/) for more details.*
{{</callout>}}

Use the import-ap field to specify an existing OSCAL-based SAP. The href flag may include any valid uniform resource identifier (URI), including a relative path, absolute path, or URI fragment.

#### SAR Import Representation
{{< highlight xml "linenos=table" >}}
  <import-ap href="../sap/FedRAMP-SAP-OSCAL-File.xml" />
  
  - OR -
  
  <import-ap href="#[uuid-value]" />

{{</ highlight >}}

#### XPath Queries
{{< highlight xml "linenos=table" >}}
(SAR) URI to SSP:
  /*/import-ap/@href

{{</ highlight >}}

If the value is a URI fragment, such as #96445439-6ce1-4e22-beae-aa72cfe173d0, the value to the right of the hashtag (#) is the universally unique identifier (UUID) value of a resource in the SAR file\'s back-matter. Refer to the *[Guide to OSCAL-based FedRAMP Content](/guides/2-working-with-oscal-files/#citations-and-attachments-in-oscal-files),
Section 2.6, Citations, Attachments and Embedded Content in OSCAL Files*, for guidance on handling.

#### SAR Back Matter Representation
{{< highlight xml "linenos=table" >}}
<back-matter>
    <resource id="96445439-6ce1-4e22-beae-aa72cfe173d0">
        <title>[System Name] [FIPS-199 Level] SAP</title>
        <prop name="type" ns="https://fedramp.gov/ns/oscal" value="sap"/>
        <!-- Only one required. (XML or JSON, rlink or base64) -->
        <rlink media-type="application/xml" href="./CSP_System_SAP.xml" />
        <rlink media-type="application/json" href="./CSP_System_SAP.json" />
        <base64 media-type="application/xml" href="CSP_System_SAP.xml" />
        <base64 media-type="application/json" href="CSP_System_SAP.json" />
    </resource>
</back-matter>

{{</ highlight >}}

#### XPath Queries
{{< highlight xml "linenos=table" >}}
(SAR) Referenced OSCAL-based SAP:
  /*/back-matter/resource[@uuid='96445439-6ce1-4e22-beae-aa72cfe173d0'] /rlink[@media-type= 'application/xml']/@href

{{</ highlight >}}

Where the provided path is invalid, tool developers should ensure the tool prompts the user for the updated path to the OSCAL-based SAP.

## 3.6. Resolution Resource Prop

FedRAMP will be implementing a separate set of automated SAR validation rules for the rev 5 OSCAL templates. To ensure FedRAMP initiates the appropriate validation rules when processing OSCAL SARs, SAR authors should add a new prop called "resolution-resource" in the metadata section and include an associated back-matter resource as shown below:

#### Resolution Resource
{{< highlight xml "linenos=table, hl_lines=11-13" >}}
<assessment-results>
   <metadata>
      <title>FedRAMP Security Assessment Results (SAR)</title>
      <!-- cut -->
      <version>fedramp2.0.0-oscal1.0.4</version>
      <oscal-version>1.0.4</oscal-version>
      <revisions>
         <revision>
            <!-- cut -->
      </revisions>
      <!-- New rev 5 prop -->
      <prop ns="https://fedramp.gov/ns/oscal" name="resolution-resource"
         value="ace2963d-ecb4-4be5-bdd0-1f6fd7610f41" />
   </metadata>
   <!-- cut -->
   <back-matter>
<resource uuid="ace2963d-ecb4-4be5-bdd0-1f6fd7610f41">
         <title>Resolution Resource</title>
         <prop name="dataset" class="collection" value="Special Publication"/>
         <prop name="dataset" class="name" value="800-53"/>
         <prop name="dataset" class="version" value="5.0.2"/>
         <prop name="dataset" class="organization" value="gov.nist.csrc"/>
         <remarks>
            <p>This "resolution resource" is used by FedRAMP as a local, authoritative indicator of what version SAR (rev 4 or rev 5) this OSCAL document is for.</p>
         </remarks>
      </resource>

   </back-matter>
</ assessment-results>

{{</ highlight >}}

#### XPath Queries
{{< highlight xml "linenos=table" >}}
(SAR) UUID of “resolution-resource”:
  /*/metadata/prop[@name=”resolution-resource”]/@value
(SAR)Target baseline version:
  /*/back-matter/resource[@uuid=”uuid-of-resolution-resource”]/prop[@name=”dataset” and @class=”version”]/@value

{{</ highlight >}}

If the "resolution-resource" prop is not specified in the metadata section of the SAR, FedRAMP will assume the SAR should be validated using the rev 5 validation rules. If the "resolution-resource" prop is present, FedRAMP will use the validation rules that correspond with the version specified in the back-matter resource.
