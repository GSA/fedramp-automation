---
title: Working with OSCAL Files
section: /poam/
weight: 101
---

This section provides a summary of several important concepts and
details that apply to OSCAL-based FedRAMP POA&M files.

The [*Guide to OSCAL-based FedRAMP Content*](/guides) provides important concepts necessary for working with any OSCAL-based
FedRAMP file. Familiarization with those concepts is important to understanding this guide.

## 3.1. XML and JSON Formats

The examples provided here are in XML; however, FedRAMP accepts XML or JSON formatted OSCAL-based POA&M files. NIST offers a utility that
provides lossless conversion of OSCAL-compliant files between XML and JSON in either direction.

You may submit your POA&M to FedRAMP using either format. If necessary, FedRAMP tools will convert the files for processing.

## 3.2. POA&M File Concepts

Unlike the traditional MS Word-and Excel based SSP and POA&M, the OSCAL-based versions of these files are designed to make information
available through linkages, rather than duplicating information. In OSCAL, these linkages are established through import commands.

![OSCAL File Imports](/img/poam-figure-1.png)

_Each OSCAL file imports information from the one to the left_

For example, the systems impacted by a vulnerability as listed in the POA&M are defined in the FedRAMP SSP and simply referenced by the POA&M.

![Baseline and SSP Information](/img/poam-figure-2.png)

_Baseline and SSP Information is referenced instead of duplicated._

For this reason, an OSCAL-based POA&M points to the OSCAL-based SSP of the system being assessed. Instead of duplicating system details, the OSCAL-based POA&M simply points to the SSP content for information such as system description, boundary, users, locations, and inventory items.

The POA&M also inherits the SSP\'s pointer to the appropriate OSCAL-based FedRAMP Baseline. Through that linkage, the POA&M references the control baseline definitions for the system\'s baseline.

### 3.2.1. Resolved Profile Catalogs

The resolved profile catalog for each FedRAMP baseline is produced by applying the FedRAMP profiles as a set of tailoring instructions on top of the NIST control catalog. This reduces overhead for tools by eliminating the need to open and follow references from the profile to the catalog. It also includes only the catalog information relevant to the baseline, reducing the overhead of opening a larger catalog.

Where available, tool developers have the option of following the links from the profile to the catalog as described above or using the resolved profile catalog.

Developers should be aware that at this time, catalogs and profiles remain relatively static. As OSCAL gains wider adoption, there is a risk that profiles and catalogs will become more dynamic, and a resolved profile catalog becomes more likely to be out of date. Early adopters may wish to start with the resolved profile catalog now, and plan to add
functionality later for the separate profile and catalog handling later
in their product roadmap.

![Resolved Profile Catalog](/img/poam-figure-3.png)

_The Resolved Profile Catalog for each FedRAMP Baseline reduces tool processing._

For more information about resolved profile catalogs, see the [*Guide to OSCAL-based FedRAMP Content*](guides/5-appendices/#appendix-c-profile-resolution) *Appendix C, Profile Resolution*.

## 3.3. OSCAL-based FedRAMP POA&M Template

FedRAMP offers an OSCAL-based POA&M shell file in both XML and JSON formats. This shell contains many of the FedRAMP required standards to help get you started. This document is intended to work in concert with that file. The OSCAL-based FedRAMP POA&M Template is available in XML and JSON formats here:

-   OSCAL-based FedRAMP POA&M Template (JSON Format):\
    <https://github.com/GSA/fedramp-automation/raw/master/dist/content/rev5/templates/poam/json/FedRAMP-POAM-OSCAL-Template.json>

-   OSCAL-based FedRAMP POA&M Template (XML Format):\
    <https://github.com/GSA/fedramp-automation/raw/master/dist/content/rev5/templates/poam/xml/FedRAMP-POAM-OSCAL-Template.xml>

## 3.4. OSCAL's Minimum File Requirements

Every OSCAL-based FedRAMP POA&M file must have a minimum set of required fields/assemblies, and must follow the OSCAL POA&M Model syntax found
here:

[https://pages.nist.gov/OSCAL/concepts/layer/assessment/poam/](https://pages.nist.gov/OSCAL/concepts/layer/assessment/poam/)

![Minimum File Requirements](/img/poam-figure-4.png)

## 3.5. Importing the System Security Plan

OSCAL is designed for traceability. Because of this, the POA&M is designed to be linked to the SSP. Rather than duplicating content from the SSP, the POA&M is intended to reference the SSP content itself.

{{<callout>}}
***Unavailable OSCAL-based SSP Content OR Monthly Deliverable Option***

OSCAL syntax requires the POA&M to import an OSCAL-based SSP, even if no OSCAL-based SSP exists.

FedRAMP recognizes some system owners may adopt OSCAL for the POA&M before adopting it for their SSP. Similarly, FedRAMP does not currently require monthly delivery of the SSP with the monthly Continuous Monitoring POA&M delivery.
{{</callout>}}

Use the import-ssp field to specify an existing OSCAL-based SSP. The href flag may include any valid uniform resource identifier (URI), including a relative path, absolute path, or URI fragment.

####  SSP Import Representation
{{< highlight xml "linenos=table" >}}
<import-ssp href="../ssp/FedRAMP-SSP-OSCAL-File.xml" /> 

<!-- OR --> 

<import-ssp href="#[uuid-valueof-resource]" />
{{</ highlight >}}

####  XPath Queries
{{< highlight xml "linenos=table" >}}
<!-- (POA&M) URI to SSP:  -->
  /*/import-ssp/@href
{{</ highlight >}}

If the value is a URI fragment, such as #96445439-6ce1-4e22-beae-aa72cfe173d0, the value to the right of the hashtag (#) is the UUID value of a resource in the POA&M file\'s back-matter. Refer to the *[Guide to OSCAL-based FedRAMP Content](https://github.com/GSA/fedramp-automation/raw/master/documents/rev5/Guide_to_OSCAL-based_FedRAMP_Content_rev5.pdf), Section 2.7, Citations and Attachments in OSCAL Files*, for guidance on handling.

#### POA&M Back Matter Representation                                      
{{< highlight xml "linenos=table" >}}
<back-matter> 
  <resource uuid="96445439-6ce1-4e22-beae-aa72cfe173d0"> 
    <title>[System Name] [FIPS-199 Level] SSP</title> 
    <prop name="type" ns="https://fedramp.gov/ns/oscal" value="system-security-plan"/> 
    <!-- Specify the XML or JSON file location. Only one required. --> 
    <rlink media-type="application/xml" href="./CSP_System_SSP.xml" /> 
    <rlink media-type="application/json" href="./CSP_System_SSP.json" /> 
    <!-- Do not embed a Base64-encoded SSP. --> 
  </resource> 
</back-matter>
{{</ highlight >}}
<br />
{{<callout>}}
***Do Not Embed the SSP in the POA&M***

While OSCAL provides the ability to embed the SSP in the POA&M, this approach does not align with FedRAMP's current delivery process and is discouraged.
{{</callout>}}

####  XPath Queries
{{< highlight xml "linenos=table" >}}
<!-- (POA&M) Referenced OSCAL-based SSP XML: -->
  /*/back-matter/resource[@uuid='96445439-6ce1-4e22-beae-aa72cfe173d0'] /rlink[@media-type='application/xml']/@href 
  
<!-- OR JSON: --> 
  /*/back-matter/resource[@uuid='96445439-6ce1-4e22-beae-aa72cfe173d0'] /rlink[@media-type='application/json']/@href

{{</ highlight >}}

Where the provided path is invalid, tool developers should ensure the tool prompts the user for the updated path to the OSCAL-based SSP.

### 3.5.1. When OSCAL-based SSP Information is Inaccurate

Ideally, when SSP information is missing or inaccurate the system ISSO should correct the SSP.

If the POA&M must be updated with missing or inaccurate SSP information, the POA&M syntax allows for SSP information correction.

Tool designers should ensure their tools can cite the relevant OSCAL-based SSP information when possible, and capture assessor-corrected SSP information in the POA&M\'s local-definitions or metadata sections when necessary. The relevant sections of this guide describe how to represent inaccurate SSP  information in the POA&M when needed.

{{<callout>}}
***Monthly Continuous Monitoring (ConMon) Delivery***

For monthly ConMon deliveries, the CSP may duplicate the component and inventory-item content from their SSP into the POA&M's local-definitions section. Delivering an OSCAL POA&M with all inventory in this way satisfies both the POA&M and System Inventory deliverables.
{{</callout>}}

### 3.5.2. Delivering the POA&M and Inventory Without the SSP 

FedRAMP currently requires CSPs to deliver their POA&M, system inventory, and raw scanner tool output each month. OSCAL enables the delivery of POA&M and inventory without delivering the linked SSP.

In this instance, the OSCAL allows the import-ssp syntax to be omitted; however, FedRAMP still requires the system-id content containing the system\'s FedRAMP-assigned unique identifier.

All SSP inventory-item assemblies must be duplicated into the POA&M local-definitions assembly. Any SSP component cited by an inventory-item must also be duplicated to the POA&M\'s local-definitions assembly.

Finally, any SSP component referenced by POA&M data must be duplicated, whether it is referenced by an inventory-item or not.

#### POA&M Representation                                      
{{< highlight xml "linenos=table" >}}
<system-id identifier-type="https://fedramp.gov">F00000000</system-id> 
<local-definitions> 
  <component uuid="uuid-value" type="software"> 
    <!-- cut --> 
  </component> 
  <component uuid="uuid-value" type="software"> 
    <!-- cut --> 
  </component> 
  <inventory-item uuid="uuid-value"> 
    <!-- cut --> 
  </inventory-item> 
  <inventory-item uuid="uuid-value"> 
    <!-- cut --> 
  </inventory-item>
  <inventory-item uuid="uuid-value"> 
    <!-- cut --> 
    <implemented-component component-uuid="uuid-of-component" /> 
  </inventory-item> 
  <inventory-item uuid="uuid-value"> 
    <!-- cut --> 
    <implemented-component component-uuid="uuid-of-component" /> 
  </inventory-item> 
</local-definitions>
{{</ highlight >}}

## 3.6. Resolution Resource Prop

FedRAMP will be implementing a separate set of automated POA&M validation rules for the rev 5 OSCAL templates. To ensure FedRAMP initiates the appropriate validation rules when processing OSCAL POA&Ms, POA&M authors should add a new prop called "resolution-resource" in the metadata section and include an associated back-matter resource as shown below:

#### SSP Resolution Resource
{{< highlight xml "linenos=table, hl_lines=11-12" >}}
<plan-of-action-and-milestones>
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
    <prop ns="https://fedramp.gov/ns/oscal" name="resolution-resource" value="ace2963d-ecb4-4be5-bdd0-1f6fd7610f41" /> 
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
</plan-of-action-and-milestones>
{{</ highlight >}}

####  XPath Queries
{{< highlight xml "linenos=table" >}}
(SAR) UUID of “resolution-resource”: 
  /*/metadata/prop[@name=”resolution-resource”]/@value 
  
(SAR)Target baseline version: 
  /*/back-matter/resource[@uuid=”uuid-of-resolution-resource”]/prop[@name=”dataset” and @class=”version”]/@value
{{</ highlight >}}

If the "resolution-resource" prop is not specified in the metadata section of the POA&M, FedRAMP will assume the POA&M should be validated using the rev 5 validation rules. If the "resolution-resource" prop is present, FedRAMP will use the validation rules that correspond with the version specified in the back-matter resource.
