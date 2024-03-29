---
title: Working with OSCAL Files
weight: 101
---

This section provides a summary of several important concepts and
details that apply to OSCAL-based FedRAMP SAP files.

The [*Guide to OSCAL-based FedRAMP Content*](/guides)
provides important concepts necessary for working with any OSCAL-based
FedRAMP file. Familiarization with those concepts is important to
understanding this guide.

## 3.1. XML and JSON Formats

The examples provided here are in XML; however, FedRAMP accepts XML or
JSON formatted OSCAL-based SAP files. NIST offers a utility that
provides lossless conversion of OSCAL-compliant files between XML and
JSON in either direction.

You may submit your SAP to FedRAMP using either format. If necessary,
FedRAMP tools will convert the files for processing.

## 3.2. SAP File Concepts

Unlike the traditional MS Word-based SSP, SAP, and SAR, the OSCAL-based
versions of these files are designed to make information available
through linkages, rather than duplicating information. In OSCAL, these
linkages are established through import commands.

![OSCAL File Imports](/img/sap-figure-1.png)

*Each OSCAL file imports information from the one to the left*

For example, the assessment objectives and actions that appear in a
blank test case workbook (TCW), are defined in the FedRAMP profile, and
simply referenced by the SAP and SAR. Only deviations from the TCW are
captured in the SAP or SAR.

![Baseline and SSP Reference](/img/sap-figure-2.png)

*Baseline and SSP Information is referenced instead of duplicated.*

For this reason, an OSCAL-based SAP points to the OSCAL-based SSP of the
system being assessed. Instead of duplicating system details, the
OSCAL-based SAP simply points to the SSP content for information such as
system description, boundary, users, locations, and inventory items.

The SAP also inherits the SSP\'s pointer to the appropriate OSCAL-based
FedRAMP Baseline. Through that linkage, the SAP references the
assessment objectives and actions typically identified in the FedRAMP
TCW.

The only reason to include this content in the SAP is when the assessor
documents a deviation from the SSP, Baseline, or TCW.

### 3.2.1. Resolved Profile Catalogs

The resolved profile catalog for each FedRAMP baseline is produced by
applying the FedRAMP profiles as a set of tailoring instructions on top
of the NIST control catalog. This reduces overhead for tools by
eliminating the need to open and follow references from the profile to
the catalog. It also includes only the catalog information relevant to
the baseline, reducing the overhead of opening a larger catalog.

Where available, tool developers have the option of following the links
from the profile to the catalog as described above or using the resolved
profile catalog.

Developers should be aware that at this time catalogs and profiles
remain relatively static. As OSCAL gains wider adoption, there is a risk
that profiles and catalogs will become more dynamic, and a resolved
profile catalog becomes more likely to be out of date. Early adopters
may wish to start with the resolved profile catalog now, and plan to add
functionality later for the separate profile and catalog handling later
in their product roadmap.

![Resolved Profile Catalog](/img/sap-figure-3.png)

*The Resolved Profile Catalog for each FedRAMP Baseline reduces tool
processing.*

For more information about resolved profile catalogs, see the [*Guide to OSCAL-based FedRAMP Content*](/guides/5-appendices/#profile-resolution) *Appendix C, Profile Resolution*.

## 3.3. OSCAL-based FedRAMP SAP Template

FedRAMP offers an OSCAL-based SAP shell file in both XML and JSON
formats. This shell contains many of the FedRAMP required standards to
help get you started. This document is intended to work in concert with
that file. The OSCAL-based FedRAMP SAP Template is available in XML and
JSON formats here:

-   OSCAL-based FedRAMP SAP Template (JSON Format):\
    [https://github.com/GSA/fedramp-automation/raw/master/dist/content/rev5/templates/sap/json/FedRAMP-SAP-OSCAL-Template.json](https://github.com/GSA/fedramp-automation/raw/master/dist/content/rev5/templates/sap/json/FedRAMP-SAP-OSCAL-Template.json)

-   OSCAL-based FedRAMP SAP Template (XML Format):\
    [https://github.com/GSA/fedramp-automation/raw/master/dist/content/rev5/templates/sap/xml/FedRAMP-SAP-OSCAL-Template.xml](https://github.com/GSA/fedramp-automation/raw/master/dist/content/templates/sap/xml/FedRAMP-SAP-OSCAL-Template.xml)

##  3.4. OSCAL's SAP Minimum File Requirements

Every OSCAL-based FedRAMP SAP file must have a minimum set of required
fields/assemblies and must follow the OSCAL Assessment Plan model syntax
found here:

[https://pages.nist.gov/OSCAL/documentation/schema/assessment-layer/assessment-plan/](https://pages.nist.gov/OSCAL/concepts/layer/assessment/assessment-plan/)


## 3.5. Importing the System Security Plan

OSCAL is designed for traceability. Because of this, the assessment plan
is designed to be linked to the system security plan. Rather than
duplicating content from the SSP, the SAP is intended to reference the
SSP content itself. **If a system security plan is available in OSCAL
format, it must be used with the OSCAL-based security assessment plan.**

Use the import-ssp field to specify an existing OSCAL-based SSP. The
href flag may include any valid uniform resource identifier (URI),
including a relative path, absolute path, or URI fragment.

#### SAP Import Representation
{{< highlight xml "linenos=table" >}}
   <import-ssp href="../ssp/FedRAMP-SSP-OSCAL-File.xml" />

    <!-- OR -->
   
   <import-ssp href="#[uuid-value-of-resource]" />

{{</ highlight >}}

#### XPath Queries 
{{< highlight xml "linenos=table" >}}
  (SAP) URI to SSP:
    /*/import-ssp/@href

{{</ highlight >}}

If the value is a URI fragment, such as
#96445439-6ce1-4e22-beae-aa72cfe173d0, the value to the right of the
hashtag (#) is the universally unique identifier (UUID) value of a
resource in the SAP file\'s back-matter. Refer to the *[Guide to OSCAL-based FedRAMP Content](/guides/2-working-with-oscal-files/#citations-and-attachments-in-oscal-files), Section 2.7, Citations and Attachments in OSCAL Files* for guidance on handling.

#### SAP Back Matter Representation 
{{< highlight xml "linenos=table" >}}
  <back-matter>
      <resource uuid="96445439-6ce1-4e22-beae-aa72cfe173d0">
          <title>[System Name] [FIPS-199 Level] SSP</title>
          <prop name="type" value="system-security-plan"/>
          <!-- Specify the XML or JSON file location. Only one required. -->
          <rlink media-type="text/xml" href="./CSP_System_SSP.xml" />
          <rlink media-type="application/json" href="./CSP_System_SSP.json" />
          <!-- Do not embed a Base64-encoded SSP. -->
      </resource>
  </back-matter>
{{</ highlight >}}

#### XPath Queries 
{{< highlight xml "linenos=table" >}}
  (SAP) Referenced OSCAL-based SSP
  XML: 
    /*/back-matter/resource[@uuid='96445439-6ce1-4e22-beae-aa72cfe173d0'] /rlink[@media-type='application/xml']/@href
  OR JSON:
    /*/back-matter/resource[@uuid='96445439-6ce1-4e22-beae-aa72cfe173d0'] /rlink[@media-type='application/json']/@href

{{</ highlight >}}

FedRAMP SSPs are delivered by the Cloud Service Provider (CSP), while
FedRAMP SAPs are delivered by the assessor. For this reason, FedRAMP
strongly encourages the use of relative paths from the OSCAL-based
FedRAMP SAP to the OSCAL-based FedRAMP SSP.

Where the provided path is invalid, tool developers should ensure the
tool prompts the user for the updated path to the OSCAL-based SSP.

### 3.5.1. When OSCAL-based SSP Information is Inaccurate

When an assessor encounters inaccurate information in an OSCAL-based
SSP, they should encourage the CSP to fix it and use the corrected
version of the SSP. The CSP is responsible for all SSP content. An
assessor\'s tools must not change an SSP.

If an assessor must move forward with inaccurate SSP information, the
SAP syntax allows for SSP information correction. Performing these
corrections in the SAP instead of the SSP ensures the corrected content
is clearly attributed to the assessor.

Tool designers should ensure their tools can cite the relevant
OSCAL-based SSP information when possible and capture assessor-corrected
SSP information in the SAP\'s local-definitions or metadata sections
when necessary. The relevant sections of this guide describe how to
represent inaccurate SSP information in the SAP when needed.

### 3.5.2. If No OSCAL-based SSP Exists (General)

The OSCAL-based SAP must always have an import-ssp field, even if no
OSCAL-based SSP is available. To compensate for this, use a URI fragment
that points to a resource in the back-matter. The resource must have a
\"type\" property with the value of **no-oscal-ssp**

#### SAP Representation 
{{< highlight xml "linenos=table" >}}
  <import-ssp href="#7c30125f-c056-4888-9f1a-7ed1b6a1b638" />

  <back-matter>
      <resource uuid="ssp-information">
          <title>System's Full Name</title>
          <description>
              <p>Briefly describe the system. This will appear in the SAR.</p>
          </description>
          <prop name="type" value="no-oscal-ssp"/>
          <prop name="type" value="system-security-plan"/>
          <prop name="title-short" 
                ns="https://fedramp.gov/ns/oscal" value="SFN"/>
          <prop name="authorization-date" 
                ns="https://fedramp.gov/ns/oscal" 
                value="2017-01-02T00:00:00Z"/>
          <prop name="system-id" 
                ns="https://fedramp.gov/ns/oscal" value="FR00000000"/>
          <prop name="import-profile" ns="https://fedramp.gov/ns/oscal"
                value="#uuid-of-resource"/>
          <prop name="purpose" ns="https://fedramp.gov/ns/oscal"
                value="Briefly state the system's purpose, for the SAP and
                      SAR."/>
          <rlink href="/documents/CSP_System_SSP.docx" 
                media-type="application/msword"/>
      </resource>
  </back-matter>

{{</ highlight >}}

#### XPath Queries 
{{< highlight xml "linenos=table" >}}
  (SAP) Resource representing system details when no OSCAL-based SSP exists:
    /*/back-matter/resource/prop[@name='type'][@value='no-oscal-ssp']

{{</ highlight >}}

The system\'s authorization date, purpose, and description have not
historically been displayed in the SAP but must be present in the SAP
for the SAR to reference.

Include the system name in the title field, and the system description
in the description field. Add FedRAMP Extension properties to capture
the system\'s short name as \"title-short\", FedRAMP-assigned system
identifier as \"system-id" and describe the system\'s purpose in
\"purpose\".

Also include the \"import-profile\" extension and supply either a URI to
the profile externally or a URI fragment with the UUID of the SAP
resource containing the relevant profile details.

In addition to defining the system here, SAP tools must place other
relevant SSP information in the SAP\'s metadata and local-definitions
section as needed for the SAP to reference this information, essentially
treating all relevant SSP content as \"missing\" from an OSCAL
perspective.

The relevant sections of this guide describe how to represent missing
SSP in formation in the SAP when needed.

## 3.6. Resolution Resource Prop

FedRAMP will be implementing a separate set of automated SAP validation
rules for the rev 5 OSCAL templates. To ensure FedRAMP initiates the
appropriate validation rules when processing OSCAL SAPs, SAP authors
should add a new prop called "resolution-resource" in the metadata
section and include an associated back-matter resource as shown below:

#### SSP Resolution Resource Representation 
{{< highlight xml "linenos=table, hl_lines=11-14" >}}
  <assessment-plan>
    <metadata>
        <title>FedRAMP Security Assessment Plan (SAP)</title>
        <!-- cut -->
        <version>fedramp2.0.0-oscal1.0.4</version>
        <oscal-version>1.0.4</oscal-version>
        <revisions>
          <revision>
              <!-- cut -->
        </revisions>
        <!-- New rev 5 prop -->
        <prop ns="https://fedramp.gov/ns/oscal" 
              name="resolution-resource"
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
              <p>This "resolution resource" is used by FedRAMP as a local, authoritative indicator of what version SAP (rev 4 or rev 5) this OSCAL document is for.</p>
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

If the "resolution-resource" prop is not specified in the metadata
section of the SAP, FedRAMP will assume the SAP should be validated
using the rev 5 validation rules. If the "resolution-resource" prop is
present, FedRAMP will use the validation rules that correspond with the
version specified in the back-matter resource.
