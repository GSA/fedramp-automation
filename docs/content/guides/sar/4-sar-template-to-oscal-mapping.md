---
title: SAR Template to OSCAL Mapping
weight: 103
---

The OSCAL Assessment Results Model is used to represent the FedRAMP SAR. This model includes:

-   Metadata and back-matter syntax, which is common to all OSCAL models;
-   Assessment scope, subject, assets, and activities syntax, which is common to both the SAP and SAR; and
-   Results syntax, which is common to the SAR and POA&M.

{{<callout>}}
This guide assumes tool developers are already familiar with the [Guide to OSCAL-based FedRAMP Content](/guides) and the [Guide to OSCAL-based FedRAMP Security Assessment Plans (SAP)](/guides/sap/). 

Instead of duplicating content from those guides, this document refers to them and only adds details that are unique to the SAR.
{{</callout>}}

This section addresses the TCW, Scanner Tool Results, Risks Identified during Penetration Testing, and the Risk Exposure Table (RET) first. These are addressed first because much of the individual SAR tables are generated from OSCAL-based content.

As described in *Section 2, FedRAMP Extensions and Allowed Values*

NIST designed the core OSCAL syntax to model cybersecurity information that is common to most organization and compliance frameworks; however, NIST also recognized the need to provide flexibility or organizations with unique information needs.

Instead of trying to provide a language that meets each organization\'s unique needs, NIST provided designed OSCAL with the ability to be extended.

As a result, FedRAMP-compliant OSCAL files are a combination of the core OSCAL syntax and extensions defined by FedRAMP. The *Guide to
OSCAL-Based FedRAMP Content* describes the concepts behind FedRAMP extensions and allowed values. The extensions related to the Security Assessment Plan (SAP) are cited in this document in context of their use.

**FedRAMP extensions and allowed values are cited in relevant portions of this document and summarized in the FedRAMP OSCAL Registry.**

{{<callout>}}
_***Revised FedRAMP Registry Approach***<br/>The FedRAMP OSCAL Registry was originally provided as a spreadsheet. It now uses the draft OSCAL Extensions syntax and is offered in XML and JSON formats, with a human-readable HTML representation._
- _[XML Version](https://github.com/GSA/fedramp-automation/raw/master/dist/content/rev5/resources/xml/FedRAMP_extensions.xml)_
- _[JSON Version](https://raw.githubusercontent.com/GSA/fedramp-automation/master/dist/content/rev5/resources/json/FedRAMP_extensions.json)_
- _[HTML Version](https://github.com/GSA/fedramp-automation/raw/master/documents/rev5/FedRAMP_extensions.html)_
{{</callout>}}

Working with OSCAL Files, the SAP communicates the *intended* scope, subject, assets, and activities, and the SAR communicates the actual circumstances of the assessment. The same OSCAL syntax is used for this content in the SAP and SAR.

Assessment tools must enable assessors to duplicate the SAP content and modify it to reflect what actually happened during the assessment, including changes to the schedule, team, and tools used.

Content that is common across OSCAL file types is described in the *[Guide to OSCAL-based FedRAMP Content](/guides).*
This includes the following:

| Topic                                         | Location                                                                                                                                                                                                                          |
| --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Title Page**                                | [_Guide to OSCAL-based FedRAMP Content_](/guides/4-expressing-common-fedramp-template-elements-in-oscal/#title-page)_, Section 4.1_                                                        |
| **Prepared By/For**                           | [_Guide to OSCAL-based FedRAMP Content_](/guides/4-expressing-common-fedramp-template-elements-in-oscal/#prepared-by-third-party)_, Section 4.2 - 4.4_                                                  |
| **Record of Template Changes**                | Not Applicable. Instead follow [_Guide to OSCAL-based FedRAMP Content_](/guides/2-working-with-oscal-files/#oscal-syntax-version)_, Section 2.3.2, OSCAL Syntax Version_ |
| **Revision History**                          | [_Guide to OSCAL-based FedRAMP Content_](/guides/4-expressing-common-fedramp-template-elements-in-oscal/#document-revision-history)_, Section 4.5_                                                        |
| **How to Contact Us**                         | [_Guide to OSCAL-based FedRAMP Content_](/guides/4-expressing-common-fedramp-template-elements-in-oscal/#how-to-contact-us)_, Section 4.6_                                                        |
| **Document Approvers**                        | [_Guide to OSCAL-based FedRAMP Content_](/guides/4-expressing-common-fedramp-template-elements-in-oscal/#document-approvals)_, Section 4.7_                                                        |
| **Acronyms and Glossary**                     | [_Guide to OSCAL-based FedRAMP Content_](/guides/4-expressing-common-fedramp-template-elements-in-oscal/#fedramp-standard-attachments-acronyms-lawsregulations)_, Section 4.8_                                                        |
| **Laws, Regulations, Standards and Guidance** | [_Guide to OSCAL-based FedRAMP Content_](/guides/4-expressing-common-fedramp-template-elements-in-oscal/#additional-laws-regulations-standards-or-guidance)_, Section 4.9_                                                        |
| **Attachments and Citations**                 | [_Guide to OSCAL-based FedRAMP Content_](/guides/4-expressing-common-fedramp-template-elements-in-oscal/#attachments-and-embedded-content)_, Section 4.10_  

It is not necessary to represent the following sections of the SAR template in OSCAL; however, tools should present users with this content where it is appropriate:

-   Any blue-text instructions found in the SSP template, where the instructions are related to the content itself.
-   Table of Contents 
-   Introductory and instructive content in each section
-   SAR Section 4.3, Consideration of Threats
-   SAR Section 4.4, Document Results

The Annual SAR was used, which includes all information typically found in the Initial SAR, plus a scope section that is unique to annual assessments. OSCAL always requires a scope. For initial assessments, the scope is all controls. For annual assessments, it is the controls required by FedRAMP.

**The following pages are intended to be printed landscape on tabloid (11\" x 17\") paper.**

---
## 4.1. One Result Assembly for the Entire Assessment

All results from the current assessment, such as observations, findings, and risks, must be in a single result assembly. Additional result assemblies are used for past assessment results. One result assembly for each past assessment results. This is covered in more detail in *Section 3.2.4, Previous Assessment Results*.

Tool developers must use the start field for each result assembly to determine the most recent set of results present in the SAR.

![Current Assessment Results](/img/sar-figure-7.png)

#### Representation
{{< highlight xml "linenos=table" >}}
    <!-- assessment-activities -->
    <result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25">
        <title>2022 Annual Assessment</title>
        <description><p>Brief assessment description.</p></description>
        <start>2022-03-01T00:00:00Z</start>
        <end>2022-03-12T00:00:00Z</end>
        <!-- TCW Findings -->
        <!-- Penetration Test Findings -->
        <!-- Automated Testing / Scanner Findings -->
    </result>
    
    <result uuid="301a0bd4-18aa-4c3e-a4a8-07f544d27266">
        <title>2021 Annual Assessment</title>
        <description><p>Brief assessment description.</p></description>
        <start>2021-02-01T00:00:00Z</start>
        <end>2021-02-12T00:00:00Z</end>
        <!-- findings -->
    </result>
    
    <result uuid="74803987-0313-4bbd-9347-edfaa8364f46">
        <title>2020 Initial Assessment</title>
        <description><p>Brief assessment description.</p></description>
        <start>2020-01-01T00:00:00Z</start>
        <end>2020-01-12T00:00:00Z</end>
        <!-- findings -->
    </result>
    <!-- back-matter -->

{{</ highlight >}}

#### XPath Queries
{{< highlight xml "linenos=table" >}}
(SAR) Quantity of assessment cycles present in file:
  count(/*/result)
(SAR) Start date/time of first assessment cycle results in file:
  /*/result/start[1]

{{</ highlight >}}

**NOTES:** The start and end fields are [dateTime-with-timezone](https://pages.nist.gov/OSCAL/documentation/schema/datatypes/#datetime-with-timezone). For FedRAMP initial and annual assessments, the time portion of this field may be all zeros as shown in the
representation above.

---
## 4.2. Test Case Workbook: Assessment Objectives and Methods

There should be one finding assembly for each row in the Excel-based FedRAMP TCW. Tools must identify the appropriate FedRAMP baseline as described in Section 2.1 of the Guide to OSCAL-based FedRAMP Content.

Within the OSCAL-based FedRAMP baselines, control statements and control objectives are tagged with a response-point FedRAMP Extension. For each **in-scope** control, every control objective designated as a response-point in the baseline must have a finding assembly in the result assembly of the SAR.

When using a **FedRAMP Resolved Profile Catalog**, the following query will identify the response points for a given control.

![Assessment Objectives and Methods](/img/sar-figure-8.png)

#### XPath Queries
{{< highlight xml "linenos=table" >}}
(Baseline) Response Points for AC-1:
  //control[@id='ac-1']/part[@name='objective']//prop[@name='response-point'] [@ns='https://fedramp.gov/ns/oscal']/../@id

(Baseline) Response Points for AC Family:
  //group[@id='ac']/control/part[@name='objective']//prop[@name='response-point'] [@ns='https://fedramp.gov/ns/oscal']/../@id
(Baseline) Response Points for entire baseline:
  //control/part[@name='objective']//prop[@name='response-point'] [@ns='https://fedramp.gov/ns/oscal']/../@id

{{</ highlight >}}
<br />
{{<callout>}}
**HELPFUL HINTS**

Use the appropriate FedRAMP resolved profile catalog, instead of the profile. This has the catalog content pre-merged, saving your tool the extra work of stepping through the profile to the catalog.

When processing an OSCAL-based FedRAMP baseline (profile or resolved-profile-catalog), each FedRAMP Test Case Workbook objective has a corresponding part named "assessment-objective" and part(s) named "assessment-method".  The "assessment-method" parts  have "method" properties specifying applicable assessment method (EXAMINE, INTERVIEW, TEST).
{{</callout>}}

---
## 4.3. Test Case Workbook: Findings and Objective Status

There must be exactly one finding assembly for each required control objective as determined in the previous section. This is equivalent to having exactly one finding assembly for each in-scope row of the Excel-based FedRAMP TCW.

The target assembly identifies which objective is being addressed by the assessor. It also holds the Implementation Status and Assessment Results fields.

![Findings and Objective Status](/img/sar-figure-9.png)

#### Representation
{{< highlight xml "linenos=table, hl_lines=21-22 39-40" >}}
<result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25">
    <!-- title, description, start, end -->
    <!-- local-definitions, reviewed-controls, assessment-log -->
    <!-- observation 1 -->
    <!-- observation 2 -->
    <!-- observation 3 -->
    <!-- risk A -->
    <!-- risk B -->
    <!-- risk C -->
    
    <finding uuid="951325ce-c0ca-4f8f-9b37-11ccf5258f3b">
        <title>[EXAMPLE]TCW Objective AC-1(a)(1)[1] <em>(Examine)</em></title>
        <description><p>Statement about satisfaction of this objective.</p>
                   </description>
        <origin>
            <!-- Assessor POCs for this objective -->
            <actor type="party" actor-uuid="f4568fda-c6d2-4640-adec-0012015af7d0" />
            <actor type="party" actor-uuid="e934d8b5-13e5-4f77-b55e-871e6f2df2fe" />
        </origin>
        <target type="objective-id" target-id="ac-1.a.1_obj.1">
            <prop name="implementation-status" ns="https://fedramp.gov/ns/oscal"       value="implemented"/>
            <status reason="pass">satisfied</status>
        </target>
        <related-observation observation-uuid="d02f9117-84e3-4993-af59-c5ce5e8675ab"/>
        <related-observation observation-uuid="29e4ce70-6a17-411d-aa65-ec7cef21e774"/>
        <associated-risk risk-uuid="1689ec06-100a-4fed-9df9-e69f07d3f3c9"/>
    </finding>
    
    <finding uuid="EF489684-C2E5-46BD-887A-A86A4AA210D9">
        <title>[EXAMPLE]TCW Objective AC-1(a)(1)[2] <em>(Examine)</em></title>
        <description><p>Statement about satisfaction of this objective.</p>
                   </description>
        <origin>
            <!-- Assessor POCs for this objective -->
            <actor type="party" actor-uuid="f4568fda-c6d2-4640-adec-0012015af7d0" />
            <actor type="party" actor-uuid="e934d8b5-13e5-4f77-b55e-871e6f2df2fe" />
        </origin>
        <target type="objective-id" target-id="ac-1.a.1_obj.2">
            <prop name="implementation-status" ns="https://fedramp.gov/ns/oscal" value="implemented"/>
            <status reason="pass">satisfied</status>
        </target>
        <related-observation observation-uuid="d02f9117-84e3-4993-af59-c5ce5e8675ab"/>
        <related-observation observation-uuid="29e4ce70-6a17-411d-aa65-ec7cef21e774"/>
        <associated-risk risk-uuid="1689ec06-100a-4fed-9df9-e69f07d3f3c9"/>
    </finding>
    
</result>

{{</ highlight >}}

<br />
{{<callout>}}
**Accepted Values**
- The implementation-status fields must have the @ns flag with a value of https://fedramp.gov
- The implementation-status field may only have one of the following values, which match the SSP accepted values:
    - implemented, partial, planned, alternative, not-applicable
- The status field may only have one of the following values:
    - satisfied, not-satisfied
- The reason flag on the status field may only have one of the following values:
    - pass, fail, other
{{</callout>}}

The assessors who gathered the evidence are identified at the bottom of the finding assembly using the actor-uuid attribute of the origin actor fields. The assessment team is defined as a party in the SAP metadata. If the assessor was not listed in the SAP, add a party to the SAR metadata for the assessor. In either case, a tool should list the UUID here, and should search both the SAP and SAR for the UUID when using this data.

**See the next page for XPath Queries.**

![Implementation Status and Result](/img/sar-figure-10.png)

![Assessment POC](/img/sar-figure-11.png)

The following assumes, the first result assembly contains the current assessment, as determined in *Section 4.1, One Result Assembly for the Entire Assessment*.

#### XPath Queries
{{< highlight xml "linenos=table" >}}
(SAR) Implementation Status:
  /*/result[1]/finding/target[@type='objective-id'][@target-id='ac-1.a.1_obj.1'] /prop[@name='implementation-status'][@ns='https://fedramp.gov/ns/oscal']
(SAR) Assessment Result:
  /*/result[1]/finding/target[@type='objective-id'][@target-id='ac-1.a.1_obj.1'] /status
(SAR) Quantity of Assessor POC's cited for this objective (integer):
  count(/*/result[1]/finding[./target[@type='objective-id'][@target-id='ac-1.a.1_obj.1'] ]/origin/actor[@type='party'])
(SAR) UUID of the First Assessor POC cited for this objective:
  /*/result[1]/finding[./target[@type='objective-id'][@target-id='ac-1.a.1_obj.1'] ]/origin/actor[@type='party'][1]/@actor-uuid
NOTE: Search the SAP and SAR metadata for the party referenced by the UUID.

{{</ highlight >}}

---
## 4.4. Test Case Workbook: Observations and Evidence

The historic TCW spreadsheet only provided the assessor one cell for each Assessment Procedure to capture all observations and evidence. 

![Observations and Evidence](/img/sar-figure-12.png)

![Assessment POC](/img/sar-figure-13.png)

OSCAL enables observations to be broken down into more granular detail, which further enables machine processing.

While each assessment procedure must have exactly one finding assembly, within the finding assembly there must be one or more observation assemblies. There should be at least one observation for each assessment method. For example, if an assessment procedure has an EXAMINE method, there should be at least two observations, including at least one for TEST and at least one for EXAMINE. There may be more. Each observation should include the following:

|**Goal**|**Field and Information**|
| :-- | :-- |
|**Action**: How was this assessed?|**method (=\"EXAMINE\", \"INTERVIEW\", \"TEST\")**|
|**Categorize**|**type \[=\"control-objective\"\]**|
|**Actor**: Who performed this action?|**assessor**|
|**Subject**: Who was interviewed?|**subject \[type=\"party\"\]**|
|**Subject**: What was tested/inspected?|**subject \[type=\"component\", \"inventory-item\", \"resource\" (Artifact)\]**|
|**How**: What was used?|**reference \[type=\"tool\" or \"method\"\]**|
|**Evidence**: What evidence supports this?|**relevant-evidence \[type=\'observation\'\]**|

**The following pages contain specific examples of Observations and Evidence.**

---
### 4.4.1. TCW - Observations and Evidence: Examine

In the example below, the Access Control Policy was examined and found to be fully compliant. The title is discretionary.

The description describes the observation and may include opinions.

The method is set to \"EXAMINE\" indicating this is in response to the EXAMINE activities prescribed for this objective.

The type must be \"control-objective\" for all TCW Observations and Evidence content.

The origin/actor field points to an individual identified as a party in the metadata assembly of either the SAP or SAR.

The origin/related-task points to the task in the SAP schedule (or locally defined task), which describes the review of documentation.

The subject cites the policy that was reviewed. While OSCAL would allow the UUID to point to the policy attached to the SSP, FedRAMP requires assessors directly attach the artifacts and evidence to the SAR. Therefore, this should typically point to a resource in the SAR.

#### Representation
{{< highlight xml "linenos=table, hl_lines=8" >}}
<result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25">
    <!-- title, description, start, end -->
    <observation uuid="d02f9117-84e3-4993-af59-c5ce5e8675ab">
        <title>[EXAMPLE]Examine AC Policy</title>
        <description>
            <p>[EXAMPLE]The AC policy existed, and had all the required elements.</p>
        </description>
        <method>EXAMINE</method>
        <type>control-objective</type>
        <origin>
            <actor type="party" actor-uuid="f4568fda-c6d2-4640-adec-0012015af7d0" />
            <related-task task-uuid="e1890486-a9f0-4388-b2bc-34fb6c623686" />
        </origin>
        <subject type="component" subject-uuid="f32b7ab1-baf1-451a-b3a1-1dfdadbe8dc7">
            <title>Reviewed Policy</title>
            <remarks>
                <p>If the policy is defined in the SSP as a component.</p></remarks>
        </subject>
        <relevant-evidence>
            <description><p>Reviewed Policy</p></description>
            <link href="#f32b7ab1-baf1-451a-b3a1-1dfdadbe8dc7" rel="policy" />
            <remarks><p>If the policy is <em>not</em> an SSP component.</p></remarks>
        </relevant-evidence>
        <collected>2020-10-10T00:00:00Z</collected>
    </observation>
    
    <observation uuid="29e4ce70-6a17-411d-aa65-ec7cef21e774">
        <!-- method: INTERVIEW -->     
    </observation>
    
    <!-- risk A -->        
    <finding uuid="30f81987-b773-4034-a54d-a75753cb5464">
        <!-- findings risks to observations -->
        <related-observation observation-uuid="d02f9117-84e3-4993-af59-c5ce5e8675ab"/>
        <related-observation observation-uuid="29e4ce70-6a17-411d-aa65-ec7cef21e774"/>
    </finding>
</result> 

{{</ highlight >}}

<br />
{{<callout>}}
**Accepted Values**

For TWC, Observations and Evidence, the type field must be set to:
- control-objective

The method field may be set to one of the following:
- EXAMINE, INTERVIEW, or TEST

The type flag of the subject field may be set to one of the following:
- component, inventory-item, location, party, or user

The type flag of the origin/actor field may be set to one of the following:
- tool, party, assessment-platform

{{</callout>}}

Finally, the relevant-evidence assembly is used to reference evidence. It has an optional href flag that is used to reference a backmatter resource. Alternatively, the relevant-evidence assembly has a child link field then can also be used to reference a backmatter resource. Either approach is acceptable, however if both relevant-evidence/@href and relevant-evidence/link/@href are specified, the link is assumed to be the definitive reference. The previous example demonstrates using link to point back to an examined policy document.

---
### 4.4.2. TCW - Observations and Evidence: Interview

In the example below, the Access Control Policy was examined and found to be fully compliant. The title is discretionary.

The description describes the observation, and may include opinions.

The method is set to \"INTERVIEW\" indicating this is in response to the INTERVIEW activities prescribed for this objective.

The type must be \"control-objective\" for all TCW Observations and Evidence content.

The origin/actor field points to an individual identified as a party in the metadata assembly of either the SAP or SAR.

The origin/related-task points to the task in the SAP schedule (or locally defined in the SAR), which describes the interviewing of staff.

The subject points to the person interviewed, who may be listed in the SSP, SAP, or SAR.

Finally, the relevant-evidence must be used to point to the attached interview notes as a URI fragment, and to provide detail as to where the relevant statements are in the notes.  While OSCAL will allow a relative external link in the href flag, FedRAMP requires each piece of evidence to be listed as a resource in the SAR back matter.

#### Representation
{{< highlight xml "linenos=table, hl_lines=12" >}}
<result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25">
    <!-- title, description, start, end -->
    <observation uuid="d02f9117-84e3-4993-af59-c5ce5e8675ab">
        <!-- method: EXAMINE -->
    </observation>
    
    <observation uuid="29e4ce70-6a17-411d-aa65-ec7cef21e774">
        <title>[EXAMPLE]AC Policy Interview</title>
        <description>
            <p>[EXAMPLE]The person interviewed knew about the policy and where to find it.</p>
        </description>
        <method>INTERVIEW</method>
        <type>control-objective</type>
        <origin>
            <actor type="party" actor-uuid="f4568fda-c6d2-4640-adec-0012015af7d0" />
            <related-task task-uuid="172d4ba2-3362-4e3b-9379-a65a50e399bf" />
        </origin>
        <subject type="party" subject-uuid="5ff3d794-d2e8-48be-bf9c-95c2328271ce">
            <title>Interviewed Person</title>
        </subject>
        <relevant-evidence href="#65fb91b1-f7dc-46bf-8b99-bd98f1a5293d">
            <description><p>describe the evidence.</p></description>
        </relevant-evidence>
        <collected>2020-10-10T00:00:00Z</collected>
    </observation>
    
    <!-- risk A -->
    <finding uuid="30f81987-b773-4034-a54d-a75753cb5464">
        <!-- cut -->
        <related-observation observation-uuid="d02f9117-84e3-4993-af59-c5ce5e8675ab"/>
        <related-observation observation-uuid="29e4ce70-6a17-411d-aa65-ec7cef21e774"/>
    </finding>  
</result>

{{</ highlight >}}

<br />
{{<callout>}}
**Accepted Values**

For TWC, Observations and Evidence, the type field must be set to:
- control-objective

The method field may be set to one of the following:
- EXAMINE, INTERVIEW, or TEST

The type flag of the subject field may be set to one of the following:
- component, inventory-item, location, party, or user

The type flag of the origin/actor field may be set to one of the following:
- tool, party, assessment-platform

{{</callout>}}

---
### 4.4.3. TCW - Observations and Evidence: Evidence and Artifacts

All artifacts reviewed and all evidence collected must be attached (by relative URI path or embedded Base64) as a resource in the back-matter. See *Section 2.6, Citations, Attachments, and Embedded Content in OSCAL Files *for more information.

Evidence must have the \"type\" property with the value set to \"evidence\".

Reviewed Artifacts must have the \"type\" property with the value set to \"artifact\".

Additional type fields may also be added with values such as plan, policy, or image. This adds clarity and can ensure specific tables are generated properly.

Artifacts and evidence may be cited from an observation as relative-evidence.

A SAR tool could use either an rlink or base64 field here, and may use both. If both are present, FedRAMP tools will give preference to the base64 content. If an rlink is used, its href should have a relative path to ensure the path remains valid when the OSCAL content is delivered to FedRAMP.

Tools may include multiple rlink fields within the same resource assembly. This may be useful if the assessor wanted to maintain an
absolute link to the file\'s authoritative source location as well as a relative link suitable for delivery to FedRAMP.

#### Representation
{{< highlight xml "linenos=table, hl_lines=12" >}}
<!-- results -->
<back-matter>
    <resource uuid="65fb91b1-f7dc-46bf-8b99-bd98f1a5293d">
        <title>[EXAMPLE]Interview Notes</title>
        <prop name="type" value="evidence"/>
        <rlink media-type="application/msword" href="./interview-notes.docx"></rlink>
        <base64 media-type="application/msword" 
            filename="interview-notes.docx">00000000</base64>
    </resource>
    
    <resource uuid="f32b7ab1-baf1-451a-b3a1-1dfdadbe8dc7">
        <title>[EXAMPLE]AC Policy</title>
        <prop name="type" value="artifact"/>
        <prop name="type" value="policy"/>
        <prop name="version" value="2.1"/>
        <prop name="publication" value="2018-11-11T00:00:00Z"/>
        <rlink media-type="application/pdf" href="./artifacts/AC_Policy.pdf"></rlink>
        <base64 media-type="application/pdf" filename="AC_Policy.pdf">00000000</base64>
    </resource>
    
    <resource uuid="53af7193-b25d-4ed2-a82f-5954d2d0df61">
        <title>[EXAMPLE]Screen Shot</title>
        <prop name="type" value="evidence"/>
        <rlink media-type="image/jpeg" href="./evidence/screen-shot.jpg"></rlink>
        <base64 media-type="image/jpeg" filename="screen-shot.jpg">00000000</base64>
    </resource>
</back-matter>    

{{</ highlight >}}

---
### 4.4.4. TCW - Observations and Evidence: Queries

![](./media/image3.png){width="7.812482502187226in"
height="4.5633989501312335in"}The following assumes, the first result assembly contains the current assessment, as determined in *Section 4.1, One Result Assembly for the Entire Assessment*.

#### Representation
{{< highlight xml "linenos=table" >}}
(SAR) Quantity of observations for this objective (integer):
  count(/*/result[1]/finding[./target[@type='objective-id'][@target-id='ac-1.a.1_obj.1']]/related-observation)
(SAR) The second observation for this objective:
  /*/result[1]/observation[@uuid=/*/result[1]/finding[./target[@type='objective-id'][@ target-id='ac-1.a.1_obj.1']]/related-observation[1]/@observation-uuid]/description/node()
(SAR) SOURCE: Type of source cited (first finding, first, observation, first source):
  /*/result[1]/observation[@uuid=/*/result[1]/finding[./target[@type='objective-id'][@ target-id='ac-1.a.1_obj.1']]/related-observation[1]/@observation-uuid]/origin/actor/@type
(SAR) SOURCE: UUID of source cited (first finding, first, observation, first source):
  /*/result[1]/observation[@uuid=/*/result[1]/finding[./target[@type='objective-id'][@ target-id='ac-1.a.1_obj.1']]/related-observation[1]/@observation-uuid]/origin/actor/@actor-uuid
(SAR) SUBJECT: Type of subject cited, such as interviewed people or examined/tested system components:
  /*/result[1]/observation[@uuid=/*/result[1]/finding[./target[@type='objective-id'][@ target-id='ac-1.a.1_obj.1']]/related-observation[1]/@observation-uuid]/subject/@type
(SAR) SUBJECT: UUID of subject cited, such as interviewed people, examined/tested system components, or reviewed artifacts:
  /*/result[1]/observation[@uuid=/*/result[1]/finding[./target[@type='objective-id'][@ target-id='ac-1.a.1_obj.1']]/related-observation[1]/@observation-uuid]/subject/@actor-uuid
(SAR) EVIDENCE: Description of the first piece of evidence for the second observation:
  /*/result[1]/observation[@uuid=/*/result[1]/finding[./target[@type='objective-id'][@ target-id='ac-1.a.1_obj.1']]/related-observation[1]/@observation-uuid]/relevant-evidence/description/node()
(SAR) EVIDENCE: The URI pointing to the evidence. For FedRAMP, the value should always be a URI fragment (starting with a '#' pointing to a back-matter resource):
  /*/result[1]/observation[@uuid=/*/result[1]/finding[./target[@type='objective-id'][@ target-id='ac-1.a.1_obj.1']]/related-observation[1]/@observation-uuid]/relevant-evidence/link/@href
(SAR) EVIDENCE: The back-matter resource containing the evidence (strip leading '#'):
  /*/back-matter/resource[@uuid='65fb91b1-f7dc-46bf-8b99-bd98f1a5293d']/rlink/@href
(SAR) EVIDENCE: The back-matter resource containing the evidence (strip leading '#'):
  /*/back-matter/resource[@uuid='65fb91b1-f7dc-46bf-8b99-bd98f1a5293d']/base64

{{</ highlight >}}

<br />
{{<callout>}}
**UUID References**

OSCAL is designed around traceability, which means information is often referenced in its original location rather than duplicated into another file. As a result, it may be necessary to search the SSP, SAP, and/or SAR for a referenced UUID. To optimize tool searches, be aware of where to search for information based on a provided UUID. 

For example, the subject-uuid value identified by subject may be found in the SSP, SAP, or SAR, but mostly likely the SSP. For this reason, it may make sense to always search the SSP first, SAP second, and SAR last.
Conversely, everything cited by related-evidence must appear in the SAR, so only the SAR should 
be searched.

Other UUID references, such as party-uuid, will sometimes only be found in the SAR, sometimes the 
SAP or SAR, and sometimes possibly all three depending on the context.
{{</callout>}}

---

### 4.4.5. Historic Test Case Workbook: Observations and Evidence

When converting Historic Test Case Workbook content to OSCAL, many details broken down in a way that fits OSCAL. While refactoring legacy data to fit OSCAL is ideal and encouraged, it is not required for historic information.

![Historic Test Case Workbook](/img/sar-figure-14.png)

There must still be one finding assembly for each row of the Test Case Workbook.

If no date or time is available for an individual row, use the result assembly\'s start field value.

Provide a single observation assembly in each finding and put the entire TCW entry in the description field.

Finally, set the observation/method to \"MIXED\" and the observation/type to \"historic\".

The Implementation Status, Assessment Results, and Assessor POC are handled the same as described in sections 4.3 -- 4.4.4.

#### Representation
{{< highlight xml "linenos=table, hl_lines=7" >}}
<result uuid="d755e7fd-346d-40f0-b538-1b1da1aa5821">
    <title>Initial (2018) Assessment</title>
    <description/>
    <start>2022-03-01T00:00:00Z</start>
    <end>2022-03-12T00:00:00Z</end>
    
    <observation uuid="1c23ddee-7001-4512-9de1-e062faa69c0a">
        <title>Observations and Evidence</title>
        <description>
            <p>Contents of the Observations and Evidence cell in the TCW.</p>
        </description>
        <method>MIXED</method>
        <type>historic</type>
        <origin>
            <actor type="party" actor-uuid=" e934d8b5-13e5-4f77-b55e-871e6f2df2fe" />
        </origin>
        <collected>2022-03-01T00:00:00Z</collected>
        
    </observation>
    
    <finding uuid="0cbd1819-3ea7-4f78-9ebc-92873eab4d6e">
        <title>AC-1.1.1.3</title>
        <description/>
        <target type="objective-id" target-id="ac-1.1_obj.3">
            <prop name="implementation-status" 
                ns="https://fedramp.gov/ns/oscal" value="implemented"/>
            <status>satisfied</status>
        </target>
    </finding>
    <!-- finding -->
    <!-- finding -->
</result>

{{</ highlight >}}

---
## 4.5. Test Case Workbook: SSP Implementation Statement Differential

If an SSP Implementation Statement Differential is identified, add an additional observation with a type
value of \"ssp-statement-issue\" and cite this observation from finding assembly. The finding assembly should also include the
implementation-statement-uuid field with the UUID of the original statement in the SSP.

If this was an issue where an inventory-item or component was not configured as described in the SSP, the related observation should
include the relevant inventory-item or component should be cited as subjects.

![SSP Implementation Statement Differential](/img/sar-figure-15.png)

<br />
{{<callout>}}
**Accepted Values**

For TWC, SSP Implementation Statement Differential, the type field must be set to:
- ssp-statement-issue

The observation method field must be set to:
- EXAMINE

If the subject field is present, the type flag may be set to one of the following:
- component, inventory-item, location, party, or user

The type flag of the origin/actor field may be set to one of the following:
- tool, part, or assessment-platform

{{</callout>}}

#### Representation
{{< highlight xml "linenos=table, hl_lines=6" >}}
<result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25">

    <observation uuid="a38f3bba-5b71-400d-b8f2-d808e1d4627f">
        <description><p>Policy describes procedure, which could not be found.</p></description>
        <method>EXAMINE</method>
        <type>ssp-statement-issue</type>
        <origin>
            <actor type="party" actor-uuid="f4568fda-c6d2-4640-adec-0012015af7d0" />
        </origin>
        <collected>2022-10-10T00:00:00Z</collected>
    </observation>
    
    <finding uuid="33e43825-6fd7-49c6-a610-4c795954a167">
        <title>[EXAMPLE]Issue With AU-1 Statement</title>
        <description><p>[EXAMPLE]There is an issue with an SSP Statement.</p></description>
        <origin>
            <actor type="party" actor-uuid="f4568fda-c6d2-4640-adec-0012015af7d0" />
            <actor type="party" actor-uuid="e934d8b5-13e5-4f77-b55e-871e6f2df2fe"></actor>
        </origin>
        <implementation-statement-uuid
            >7924db51-e44d-4215-ad7e-3a5dda44a631</implementation-statement-uuid>
        <related-observation observation-uuid="a38f3bba-5b71-400d-b8f2-d808e1d4627f" />
    </finding>
</result>

{{</ highlight >}}

The following assumes, the first result assembly contains the current assessment, as determined in *Section 4.1, One Result Assembly for the Entire Assessment*.

{{< highlight xml "linenos=table" >}}
(SAR) Quantity of SSP implementation statement differential issues cited in current assessment (integer):
  count(/*/result[1]/observation/type[.='ssp-statement-issue'] )
(SAR) List of SSP implementation statement differential issues cited in current assessment (by SSP Statement UUID):
  /*/result[1]/finding[./related-observation[@observation-uuid=/*/result[1]/observation[./type[.='ssp-statement-issue']]/@uuid]]/implementation-statement-uuid
(SAR) The description of the first deficiency:
  /*/result[1]/observation[./type[.='ssp-statement-issue']]/description/node()

{{</ highlight >}}

---
## 4.6. Test Case Workbook: Identified Risks

For any finding with a finding/target/status value of \"not-satisfied\", there must be at least one associated-risk field within the finding assembly, pointing to a risk assembly.

Within the cited risk assembly, the \"Identified Risk\" is described in the description field. The Risk Statement is described in the risk-statement field.

The Likelihood Level and Impact Level are each entered in a characterization/facet field. The FedRAMP Risk Exposure Level must be calculated by the SAR tool. If the \"state\" annotation is missing, it is assumed to be \"initial\".

Initially, the status field should always be set to \"open\". If the risk is addressed by the CSP and verified by the assessor before assessment activities are complete, this may be set to \"closed\", and entry must be made in the risk-log.

![Identified Risks](/img/sar-figure-16.png)

<br />
{{<callout>}}
**Accepted Values**
- The risk status field should always be set to "open" when a risk content is first created.
- The facet likelihood and impact fields must each have one of the following values:
    - low
    - moderate
    - high
- The risk exposure rating  is calculated, consistent with Annual SAR Table 3-6, Risk Exposure Rating
![Risk Exposure Rating](/img/sar-figure-risk-exposure-rating.png)

{{</callout>}}

#### Representation
{{< highlight xml "linenos=table, hl_lines=2-23" >}}
<result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25">
    <risk uuid="1689ec06-100a-4fed-9df9-e69f07d3f3c9">
        <title>Risk Title</title>
        <description>
            <p>This is a general description of the identified risk.</p>
        </description>
        <statement>
            <p>This is a statement about the identified risk in the context of this system.</p>
        </statement>
        <status>open</status>
        
        <characterization>
            <origin>
                <actor type="party" actor-uuid="f4568fda-c6d2-4640-adec-0012015af7d0" />
            </origin>
            <facet name="likelihood" system="https://fedramp.gov/ns/oscal" value="high">
                <prop name="state" value="initial" />
            </facet>
            <facet name="impact" system="https://fedramp.gov/ns/oscal" value="moderate">
                <prop name="state" value="initial" />
            </facet>
        </characterization>
    </risk>   
    
    <finding uuid="951325ce-c0ca-4f8f-9b37-11ccf5258f3b">
        <title>[EXAMPLE]TCW Objective AC-1(a)(1)[1] (Examine)</title>
        <description><p>cut.</p></description>
        <origin><!-- cut --></origin>
        <target type="objective-id" target-id="ac-1.a.1_obj.1">
            <prop name="implementation-status" 
                ns="https://fedramp.gov/ns/oscal" value="implemented"/>
            <status>not-satisfied</status>
        </target>
        <related-observation observation-uuid="d02f9117-84e3-4993-af59-c5ce5e8675ab"/>
        <associated-risk risk-uuid="1689ec06-100a-4fed-9df9-e69f07d3f3c9"/>
    </finding>
</result>

{{</ highlight >}}

### 4.6.1. Test Case Workbook: Recommendation for Mitigation

For the risk assembly, there must be a response assembly containing the assessors recommended mitigation. 
The lifecycle flag must be set to \"recommendation\".

There may be more than one response assembly. For example, a tool may provide a recommended remediation, and the assessor may want to add their own recommendation. This would result in two response assemblies.

Later, any SAR remediation recommendations may be transferred to the POA&M using this syntax, and the CSP will add yet another response assembly with their actual plan for remediation.

If the risk is closed during testing, there must be an additional response-assembly with a lifecycle value of \"completed\".

The assessor\'s recommendation should appear in the description field.

The response origin field\'s type flag should be set to \"party\", and the actor-uuid should contain the UUID of either the assessment organization itself or the individual assessor making the recommendation.

![Recommendation for Mitigation](/img/sar-figure-17.png)

<br />
{{<callout>}}
**Accepted Values**
- The lifecycle flag on the response field must be set to:
    - recommendation
- The type flag on the response origin field:
    - party
    - tool

{{</callout>}}

#### Representation
{{< highlight xml "linenos=table, hl_lines=22-37" >}}
<result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25">
    <risk uuid="1689ec06-100a-4fed-9df9-e69f07d3f3c9">
        <title>Risk Title</title>
        <description>
            <p>This is a description of the identified risk.</p>
        </description>        
        <statement>
            <p>This is a statement about the identified risk.</p>
        </statement>
        <status>open</status>        
        <characterization>
            <origin>
                <actor type="party" actor-uuid="f4568fda-c6d2-4640-adec-0012015af7d0" />
            </origin>
            <facet name="likelihood" system="https://fedramp.gov/ns/oscal" value="high">
                <prop name="state" value="initial" />
            </facet>
            <facet name="impact" system="https://fedramp.gov/ns/oscal" value="moderate">
                <prop name="state" value="initial" />
            </facet>
        </characterization>
        <!-- recommendations for risk remediation -->
        <response uuid="fde4758d-6417-4f35-ba71-278af4f008f8"
                  lifecycle="recommendation">
            <title>Remediation Title</title>
            <description>
                <p>A description of the recommended remediation.</p>
                <p>TCW: Assessor's recommended remediation 
                   (lifecycle='recommendation').</p>
            </description>
            <origin>
                <actor type="party" actor-uuid="f4568fda-c6d2-4640-adec-0012015af7d0" />
            </origin>
        </response>
        <!-- other recommendations for risk remediation (cut) -->
        <response uuid="scan-tool-recommendation-uuid" lifecycle="recommendation" />   
        <response uuid="other-recommendation-uuid" lifecycle="recommendation" />         
    </risk>      
</result>

{{</ highlight >}}

---
## 4.7. Automated Tools

Automated scanning tool output is simply another finding; however, the target is typically not present.

FedRAMP requires exactly one finding assembly for each unique vulnerability identified by the scanning tool. Within this finding assembly, there must be exactly one observation assembly. The collected field must be set to the automation tool\'s discovery timestamp.

Within the observation assembly, the observation method field must be set to \"TEST\", and the observation type field must be set to
\"finding\". 

The actor-uuid flag of the origin field must identify the automated tool\'s UUID, and the type flag must be set to \"tool\". The scanning tool should have been previously defined in the SAP\'s assessment-assets assembly and copied to the SAR. If not, the
scanning tool should be added to the SAR results local-definitions/assessment-assets assembly as described in the [*Guide to OSCAL-based Security Assessment Plans (SAP)*](/guides/sap/4-sap-template-to-oscal-mapping/#testing-performed-using-automated-tools), *Section 4.13, SAP Test Plan: Testing Performed Using Automated Tools*.

The href flag in the relevant-evidence field must contain a URI fragment that points to the resource containing the raw tool output attached in the back-matter.

At the end of the finding assembly, the UUID for the tool operator must be listed as the actor-uuid for the finding. There may be more than one.

#### Representation
{{< highlight xml "linenos=table, hl_lines=6" >}}
<result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25">
    <observation uuid="6841d8eb-a72c-4672-acc2-2fd265d9617d">
        <description>
            <p>Undocumented devices found on network.</p>
        </description>
        <method>TEST</method>
        <type>finding</type>
        <origin>
            <actor type="tool" actor-uuid="9d194268-a9d1-4c38-839f-9c4aa57bf71e"></actor>
        </origin>
        <subject type="inventory-item" subject-uuid="f61f4408-2cb8-444a-a312-bc88412e7c61" />
        <subject type="inventory-item" subject-uuid="02075556-3660-4112-8982-02fc7d6fac00" />
        <subject type="inventory-item" subject-uuid="5efe2c07-9fdf-453a-8457-6471046082fb" />
        <subject type="component" subject-uuid="75b059f2-a9ba-40b1-a1e0-881196ca1ead" />
        <relevant-evidence href="#19a07333-4e87-46dc-abab-adad60e706b9">
            <description>
                <p>Raw scanner tool output - discovery scan.</p>
            </description>
        </relevant-evidence>
        <collected>2022-10-10T00:00:00Z</collected>
        <remarks>
            <p>Undocumented hosts are entered into the SAR's local-definitions.</p>
        </remarks>
    </observation>
    <finding uuid="d6316907-a5e5-4ad5-871d-f2f29938360e">
        <title>Discovery Scan Results</title>
        <description><p>The results of the discovery scan.</p></description>
        <origin>
            <actor type="party" actor-uuid="f4568fda-c6d2-4640-adec-0012015af7d0" />
            <actor type="party" actor-uuid="e934d8b5-13e5-4f77-b55e-871e6f2df2fe" />
        </origin>
        <related-observation observation-uuid="6841d8eb-a72c-4672-acc2-2fd265d9617d"/>
    </finding>
</result>

{{</ highlight >}}

### 4.7.1. Automated Tools: Discovery Scans

Any undocumented devices identified by the discovery scans must be added to the SAR\'s local-definitions assembly as either inventory-items or components, as described in the [*Guide to OSCAL-based Security Assessment Plans (SAP)*](/guides/sap/4-sap-template-to-oscal-mapping/#ip-addresses-slated-for-testing), *Section 4.5, SAP IP Addresses Slated for Testing*.

This should include information such as IP address, host name, and OS, as well as any other details typically reported for an undocumented host. All component and inventory-item syntax from the SSP is available here. Each undocumented device should then be listed as an individual subject reference.

If the assessor believes any of the undocumented devices represent a risk, the risk assembly may be added with the appropriate information; however, it is not automatically required for discovery scans.

#### Representation
{{< highlight xml "linenos=table, hl_lines=14-16" >}}
<result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25">
    <!-- title, description, start, end -->
    <observation uuid="6841d8eb-a72c-4672-acc2-2fd265d9617d">
        <description>
            <p>Undocumented devices found on network.</p>
        </description>
        <method>TEST</method>
        <type>finding</type>
        <origin>
            <actor type="tool" actor-uuid="9d194268-a9d1-4c38-839f-9c4aa57bf71e" />
            <actor type="party" actor-uuid="f4568fda-c6d2-4640-adec-0012015af7d0" />
            <actor type="party" actor-uuid="e934d8b5-13e5-4f77-b55e-871e6f2df2fe" />
        </origin>
        <subject type="inventory-item" subject-uuid="f61f4408-2cb8-444a-a312-bc88412e7c61" />
        <subject type="inventory-item" subject-uuid="02075556-3660-4112-8982-02fc7d6fac00" />
        <subject type="inventory-item" subject-uuid="5efe2c07-9fdf-453a-8457-6471046082fb" />
        <subject type="component" subject-uuid="75b059f2-a9ba-40b1-a1e0-881196ca1ead" />
        <relevant-evidence href="#19a07333-4e87-46dc-abab-adad60e706b9">
            <description>
                <p>Raw scanner tool output - discovery scan.</p>
            </description>
        </relevant-evidence>
        <collected>2022-10-10T00:00:00Z</collected>
        <remarks>
            <p>Undocumented hosts are entered into the SAR's result/local-definitions section as inventory-items or components.</p>
            <p>Undocumented hosts are listed in the observations assembly as subjects.</p>
            <p>The origin must contain the UUID of the tool used to perform the scan.</p>
        </remarks>
    </observation>
    
    <finding uuid="d6316907-a5e5-4ad5-871d-f2f29938360e">
        <title>Discovery Scan Results</title>
        <description><p>The results of the discovery scan.</p></description>
        <related-observation observation-uuid="6841d8eb-a72c-4672-acc2-2fd265d9617d"/>
    </finding>
</result>

{{</ highlight >}}

#### 4.7.2. Automated Tools: Identified Vulnerabilities

There must be one risk assembly for each unique vulnerability. All devices identified as having that unique vulnerability must be itemized with subject fields in the observation assemblies.

The individual components and inventory-items on which the scans are performed should already be marked as to whether authenticated scanning is possible.

All components and inventory-items found to have the vulnerability must be cited using their UUID in the subject field. One subject for each item.

The uuid flag of the origin field must be set to the tool\'s UUID, and the type flag must be set to \"tool\".

#### Representation
{{< highlight xml "linenos=table, hl_lines=14-16" >}}
<result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25">
    <risk uuid="1689ec06-100a-4fed-9df9-e69f07d3f3c9">
        <title>Risk Title</title>
        <description>
            <p>This is a description of the identified risk.</p>
            <!-- <p>TCW: Identified Risk.</p> -->
            <p>Scans: Vulnerability Description.</p>
            <!-- <p>Pen Test: Risk Description.</p> -->
            <!-- <p>RET: Description.</p> -->
        </description>
        
        <statement>
            <p>This is a statement about the identified risk.</p>
            <!-- <p>TCW: Risk Statement..</p> -->
            <p>Scans: N/A.</p>
            <!-- <p>Pen Risk Statement.</p> -->
            <!-- <p>RET: Risk Statement.</p> -->
        </statement>
        <status>open</status>
        
        <characterization>
            <origin>
                <actor type="party" actor-uuid="f4568fda-c6d2-4640-adec-0012015af7d0" />
            </origin>
            <facet name="likelihood" system="https://fedramp.gov" value="high">
                <prop name="state" value="initial"/>
            </facet>
            <facet name="likelihood" system="https://fedramp.gov" value="moderate">
                <prop name="state" value="initial"/>
            </facet>
        </characterization>
        
        <response uuid="fde4758d-6417-4f35-ba71-278af4f008f8" lifecycle="recommendation">
            <title>Remediation Title</title>
            <description>
                <p>A description of the recommended remediation.</p>
                <!-- <p>TCW: Assessor's recommended remediation (type='recommendation').</p> -->
                <p>Scans: Tool's recommended remediation (type='recommendation')</p>
                <!-- <p>Pen Test: Assessor's recommended remediation (type='recommendation')</p> -->
                <!-- <p>RET: Assessor's recommended remediation (type='recommendation').</p> -->
                <!-- <p>POA&amp;M: CSP's intended remediation (no type flag).</p> -->
            </description>
        </response>
        
    </risk>
</result>

{{</ highlight >}}

**See next page for risk assembly**

The risk assembly uses facet fields to capture relevant tool output details. The facet field's system flag allows data from different tools and different security frameworks to co-exist in the same file.

FedRAMP required risk-metric data, such as likelihood and impact are specified with facet fields with system flag value of \"https://fedramp.gov\". FedRAMP required risk metrics must also have the class flag set to either \"initial\" or \"residual\". There must
always be an initial risk metric. If adjusted, there may be a residual risk metric as well.

The uuid flag of the origin field must be set to the tool\'s UUID, and the type flag must be set to \"tool\".

#### Representation
{{< highlight xml "linenos=table" >}}
<result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25">
    <!-- title, description, start, end -->
    <risk uuid="ae628cc5-b64c-4030-af30-57e6b24a6ae7">
        <title>Vulnerability Title</title>
        <description>
            <p>This is a description of the vulnerability provided by the tool.</p>
        </description>
        <statement>
            <p>This is a statement about the identified risk as provided by the tool.</p>
        </statement>
        <status>open</status>
        
        <characterization>
            <origin>
                <actor type="tool" actor-uuid="040937c3-2e0e-407a-bb3c-d4e61ac1c460" />
            </origin>
            <facet name="vulnerability-id" system="http://csrc.nist.gov/ns/oscal/unknown" 
                value="VulID-001" />
            <facet name="plugin-id" system="http://csrc.nist.gov/ns/oscal/unknown" 
                value="Plugin-ID" />
            <facet name="iavm-severity" system="https://us-cert.cisa.gov/" value="high" />
            
            <facet name="vulnerability-id" system="http://cve.mitre.org" 
                value="CVE-2020-00000"></facet>
            <facet name="impact" system="http://csrc.nist.gov/ns/oscal/unknown" 
                value="high" />
            <facet name="AV" system="http://www.first.org/cvss/v3.1" 
                value="network" />
            
            <facet name="likelihood" system="https://fedramp.gov" value="high">
                <prop name="state" value="initial"/>
            </facet>
            <facet name="impact" system="https://fedramp.gov" value="high">
                <prop name="state" value="initial"/>
            </facet>
            
            <facet name="likelihood" system="https://fedramp.gov" value="moderate">
                <prop name="state" value="residual"/>
            </facet>
            <facet name="impact" system="https://fedramp.gov" value="moderate">
                <prop name="state" value="residual"/>
            </facet>
        </characterization>
        
    </risk>
</result>

{{</ highlight >}}

For information about the remediation assembly, see *Section 4.6.1, Test Case Workbook: Recommendation for Mitigation*.

---
## 4.8. Penetration Testing: Findings

FedRAMP requires exactly one finding assembly for each risk identified through penetration testing. Required reporting, such as spear phishing tests, each must have their own finding assembly as well. Each finding has a related-observation referencing observation (where additional details are recorded) via the uuid flag. At the end of the finding assembly, the UUID for the penetration test lead or team member must be listed as the actor-uuid for the finding. Note that there may be more than one penetration test member listed.

The observation assembly contains the method field which must be set to \"TEST\", and the type field which must be set to \"finding\". The observation assembly also contains the collected field which must be set to the automation tool\'s discovery timestamp, or the date and time observed. The assessors who gathered the evidence are identified at the bottom of the finding assembly using actor-uuid fields.

The href flag in the relevant-evidence field must contain a URI fragment that points to the resource containing the penetration testing report. Section 4.4.3 describes how to reference evidence resources. The back-matter resource containing the penetration test must also have a prop with a name of \"type\" and with a value of \" report\".

#### Representation
{{< highlight xml "linenos=table" >}}
<result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25"> 
    <observation uuid="a38f3bba-5b71-400d-b8f2-d808e1d4627f">
        <description><p>Penetration Testing</p></description>
        <method>TEST</method>
        <type>finding</type>
        <origin>
            <actor type="party" actor-uuid="f4568fda-c6d2-4640-adec-0012015af7d0" />
        </origin>
        <related-evidence href="#4739a1e6-b861-4e38-b9b9-7be33d463a5b"><!-- cut -->
        </related-evidence>
        <collected>2022-10-10T00:00:00Z</collected>
    </observation>
    
    <finding uuid="b56edab1-8cdc-45f9-8589-35f1bd7b3348">
        <title>[EXAMPLE]Penetration Test Result</title>
        <description><p>A finding from penetration testing activities.</p></description>
        <origin>
            <actor type="party" actor-uuid="f4568fda-c6d2-4640-adec-0012015af7d0" />
            <actor type="party" actor-uuid="e934d8b5-13e5-4f77-b55e-871e6f2df2fe" />
        </origin>
        <related-observation observation-uuid="a38f3bba-5b71-400d-b8f2-d808e1d4627f"/>
        <associated-risk risk-uuid="e552fb72-d662-4c01-b2d7-4dcb2086bb07"/>
        <remarks>
            <p>If a penetration test result is favorable, such as to say the SOC detected the activities appropriately, no risk is required.</p>
            <p>If a penetration test result identifies a vulnerability or deficiency, the risk assembly is required.</p>
        </remarks>
    </finding>
    
    <risk uuid="e552fb72-d662-4c01-b2d7-4dcb2086bb07">
        <!-- cut -->
    </risk>
</result>

{{</ highlight >}}

---
## 4.9. Penetration Testing: Identified Risks

Some penetration test results may be reportable even if they do not represent a risk. For example, the spear phishing test results must be reported regardless; however, those results only generate a risk if the click rate exceeds a certain threshold. Where a risk must be reported, the risk assembly is added beneath the observation.

For penetration testing, there must be one finding assembly per observation or observation/risk pair.

The risk assembly is populated as described in previous sections.

#### Representation
{{< highlight xml "linenos=table" >}}
<result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25">
    <!-- observation cut -->
    
    <risk uuid="e552fb72-d662-4c01-b2d7-4dcb2086bb07">
        <title>Risk Title</title>
        <description>
            <p>This is a description of the issue found by the penetration testing team.</p>
        </description>
        <statement>
            <p>Statement about the risk identified by penetration testing.</p>
        </statement>
        <prop name="priority" ns="https://fedramp.gov/ns/oscal" value="1"/>
        <status>open</status>  
        <characterization>
            <origin>
                <actor type="party" actor-uuid="f4568fda-c6d2-4640-adec-0012015af7d0" />
            </origin>
            <facet name="likelihood" system="https://fedramp.gov" value="high">
                <prop name="state" value="initial" />
            </facet>
            <facet name="impact" system="https://fedramp.gov" value="high">
                <prop name="state" value="initial" />
            </facet>
        </characterization> 
        <response uuid="69344d05-937e-40f4-9c3f-9aa8702ad99d" lifecycle="recommendation">
            <title>Assessor's Recommendation</title>
            <description>
                <p>A description of the recommended remediation as provided by the assessor.</p>
            </description>
            <origin>
                <actor type="party" actor-uuid="49f73135-efab-4275-9a79-003656ad890a" />
            </origin>
            <remarks>
                <p>The assessor may add their recommendation.</p>
            </remarks>
        </response>
    </risk>

    <!-- finding cut -->
</result>

{{</ highlight >}}

---
## 4.10. Deviations

After risks are identified during an assessment, their status may change. Some are identified as false positive 
(FP), operationally required (OR), or risk adjusted (RA). As deviations arise, the initial risk information is [not]{.underline} modified. Additional content is added to identify these changes. In each case, an additional observation is added to the finding assembly, and additional facet fields are added to the risk assembly. There may be both OR and an RA information in the same finding assembly.

### 4.10.1. False Positive (FP)

To document a false positive, add a prop to the risk assembly, and change the risk status to \"closed\". Set the prop name to
\"false-positive\", the ns to \"https://fedramp.gov/ns/oscal\", and the value to \"pending\".

Within the observation assembly, provide a description of the false positive. This must have a conformity tag with a value of \"false-positive\". Typically, the observation method is set to EXAMINE; however, another method may be identified if more
appropriate.

Finally, add a separate relevant-evidence assembly for each piece of evidence supporting the FP. Attached evidence, such as screen shots, must be defined as a resource in the back-matter, and cited using a URI fragment (hashtag, followed by the UUID of the
resource.)

#### Representation
{{< highlight xml "linenos=table" >}}
<result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25">
    <!-- title, description, start, end -->
    <observation uuid="46209140-8263-4e74-b3c9-cead4ffed22c">
        <title>False Positive</title>
        <description><p>False positive justification.</p></description>
        <method>EXAMINE</method>
        <type>false-positive</type>
        
        <relevant-evidence href="#53af7193-b25d-4ed2-a82f-5954d2d0df61">
            <description>
                <p>A screen shot showing the setting is correct</p></description>
        </relevant-evidence>
        
        <relevant-evidence href="https://vendor.site/describing/something.htm">
            <description>
                <p>Vendor detail describing why this happens.</p></description>
        </relevant-evidence>
    </observation>
    
    <risk uuid="e552fb72-d662-4c01-b2d7-4dcb2086bb07">
        <!-- title, description -->
        <prop name="false-positive" ns="https://fedramp.gov/ns/oscal" 
            value="pending"/>
        <!-- risk statement -->
        <status>closed</status>
    </risk>
</result>

{{</ highlight >}}

<br />
{{<callout>}}
FedRAMP allowed values for false-positive prop:
- investigating
- pending
- approved
- withdrawn

{{</callout>}}

### 4.10.2. Operationally Required (OR)

To document an operationally required risk, add a prop to the risk assembly, and keep the risk status as \"open\". Set the prop name to \" operational-requirement \", the ns to \"https://fedramp.gov/ns/oscal\", and the value to \"pending\".

Within the observation assembly, provide a justification for the operational requirement. This must have a conformity tag with a value of \"operational-requirement\". Typically, the observation method is set to EXAMINE; however, another method may be identified if more appropriate. 

Finally, add a separate relevant-evidence assembly for each piece of evidence supporting the FP. Attached evidence, such as screen shots, must be defined as a resource in the back-matter, and cited using a URI fragment (hashtag, followed by the UUID of the resource.)

#### Representation
{{< highlight xml "linenos=table" >}}
<result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25">
    
    <observation uuid="9de7cba9-40fc-4c4d-b6af-01bd24f1def6">
        <title>Operational Requirement</title>
        <description><p>Justification for the OR.</p></description>
        <method>EXAMINE</method>
        <type>operational-requirement</type>
        
        <relevant-evidence href="#53af7193-b25d-4ed2-a82f-5954d2d0df61">
            <description>
                <p>Screen shot showing impact when patched.</p>
            </description>
        </relevant-evidence>
        
        <relevant-evidence 
            href="https://vendor.site/article/describing/something.htm">
            <description>
                <p>Vendor detail describing why this happens.</p>
            </description>
        </relevant-evidence>
    </observation>
    
    <risk uuid="e552fb72-d662-4c01-b2d7-4dcb2086bb07">
        <!-- title, description -->
        <prop name="operational-requirement" ns="https://fedramp.gov/ns/oscal" 
            value="pending"/>
        
        <!-- risk statement -->
        <status>open</status>
    </risk>
</result>

{{</ highlight >}}

<br />
{{<callout>}}
FedRAMP allowed values for operational-requirement prop:
- investigating
- pending
- approved
- withdrawn

{{</callout>}}

### 4.10.3. Risk Adjustment (RA)

To document an operationally required risk, add a prop to the risk assembly and keep the risk status as \"open\". Set the prop name to
\"risk-adjustment\", the ns to \"https://fedramp.gov/ns/oscal\", and the value to \"pending\".

Within the observation assembly, provide a justification for the risk adjustment. This must have a conformity tag with a value of
\"risk-adjustment\". Typically, the observation method is set to EXAMINE; however, another method may be identified if more appropriate.

Use facet fields to adjust risk by lowering either likelihood, impact, or both. Within the facet fields, set a prop with the name "state" to indicate whether this is an "initial" or "adjusted" risk metric.

Finally, mitigating-factor assemblies. One describing each mitigating factor. If an SSP implementation statement describes the mitigating factor, link to it using the implementation-uuid flag.

{{<callout>}}
**Using the Common Vulnerability Scoring System (CVSS)**

When using CVSS scoring to justify a risk adjustment, the CVSS metrics are added as additional risk-metric fields. There must be one risk-metric field for each CVSS metric. 

``` <risk-metric name="AV" system="CVSSv3.1">network</risk-metric> ```

See Appendix A, CVSS Scoring for more information.

{{</callout>}}

#### Representation
{{< highlight xml "linenos=table" >}}
<result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25">
    <!-- title, description, start, end -->
    
    <observation uuid="7acee179-1570-4ea0-94dc-01b8c0a29c0a">
        <title>Risk Adjustment</title>
        <description><p>Justify the risk.</p></description>
        <method>EXAMINE</method>
        <type>risk-adjustment</type>
    </observation>
    
    <risk uuid="ae628cc5-b64c-4030-af30-57e6b24a6ae7">
        <prop name="risk-adjustment" ns="https://fedramp.gov/ns/oscal" 
            value="pending"/>
        <characterization>
            <origin>
                <actor type="tool" actor-uuid="040937c3-2e0e-407a-bb3c-d4e61ac1c460" />
            </origin>
            
            <facet name="likelihood"       system="https://fedramp.gov" value="high">
                <prop name="state" value="initial"/>
            </facet>
            <facet name="impact"           system="https://fedramp.gov" value="high">
                <prop name="state" value="initial"/>
            </facet>
            
            <facet name="likelihood"       system="https://fedramp.gov" value="moderate">
                <prop name="state" value="adjusted"/>
            </facet>
            <facet name="impact"           system="https://fedramp.gov" value="moderate">
                <prop name="state" value="adjusted"/>
                
            </facet>
        </characterization>
        <mitigating-factor uuid="fd061039-e9b0-4b4c-a78b-ca024d411174"
            implementation-uuid="46f4c261-e488-4fb5-84d6-6a61dd30c3d7">
            <!-- cut -->     
        </mitigating-factor>
        <!-- risk statement -->
        <status>open</status>
    </risk>
</result>

{{</ highlight >}}

<br />
{{<callout>}}
FedRAMP allowed values for risk-adjustment prop:
- investigating
- pending
- approved
- withdrawn

{{</callout>}}

---
## 4.11. Risk Closure

Once identified, risks must remain in the SAR; however, if the CSP closes the risk before testing is complete, it may be marked as closed in the SAR. To represent a risk closure, change the risk status to \"closed\", then add an entry field and risk-log assembly, with a status-change value of \"closed \".

In the risk-log , describe the action(s) taken by the CSP to close the risk.


#### Representation
{{< highlight xml "linenos=table" >}}
<result uuid="c62765e1-b221-4890-9fb8-93fe84a41c25">
    <risk uuid="ae628cc5-b64c-4030-af30-57e6b24a6ae7">
        <title>Vulnerability Title</title>
        <description><p>cut</p></description>
        <statement><p>cut</p></statement>
        <status>closed</status>
        
        <characterization/> <!-- cut for brevity -->
        
        <response uuid="a3106e23-8b79-4b1b-abf4-74f16c51ad0c" lifecycle="recommendation">
            <title>Tool's Recommendation</title>
            <description>
                <p>A description of the recommended remediation as provided by the tool.</p>
            </description>
            <origin>
                <actor type="tool" actor-uuid="9d194268-a9d1-4c38-839f-9c4aa57bf71e" />
            </origin>
        </response>
        <response uuid="69344d05-937e-40f4-9c3f-9aa8702ad99d" lifecycle="planned">
            <title>Assessor's Recommendation</title>
            <description>
                <p>A description of the recommended remediation as provided by the assessor.</p>
            </description>
            <origin>
                <actor type="party" actor-uuid="49f73135-efab-4275-9a79-003656ad890a" />
            </origin>
        </response>
        
        <risk-log>
            <entry uuid="0b09e341-cf3c-4de7-b728-751c6e88b653">
                <title>Closed</title>
                <description>
                    <p>Describe what action(s) the CSP took to close the risk.</p>
                    <p>Applied patch. Vulnerability no longer found in subsequent scan.</p>
                </description>
                <start>2022-07-07T00:00:00Z</start>
                <status-change>closed</status-change>
            </entry>
        </risk-log>
    </risk>
</result>

{{</ highlight >}}

---
## 4.12. Continued Authorization Recommendation

There must be a prop field with a value indicating whether the assessor recommends the system for authorization or reauthorization. This must be a FedRAMP extension with the name \"recommend-authorization\". If the recommendation is \"no\" or \"provisionally\", the first paragraph of the Continued Authorization Recommendation should be generated by a SAR tool, as follows:

{{<callout>}}
*A total of \[# of risks\] system risks were identified for \[system > name\], including \[#high\] High risks, \[#moderate\] Moderate risks, \[#low\] Low risks, and \[#operationally-required\] of operationally required risks.*
{{</callout>}}

The \"other information as may be required\" may be added as a part assembly in the assets section.

Each risk may have a priority value assigned to it. This is another FedRAMP extension prop with the name flag set to \"priority\". A
priority value of \"1\" represents the most important risk. \"2\" represents the second most important risk. Each number should be unique. Do not assign a priority value to a risk that will not be mitigated, such as an operationally required risk.

![Continued Authorization Recommendation](/img/sar-figure-18.png)

#### Representation
{{< highlight xml "linenos=table" >}}
<result>
    <attestation>
        <responsible-role role-id="assessment-lead"><party-uuid><!-- uuid-of-assessment-lead --></party-uuid></responsible-role>
        <part name="authorization-statements">
            <prop name="recommend-authorization" 
                ns="https://fedramp.gov/ns/oscal" value="yes"/>
            <part name="authorization-statement">
                <prop name="sort-id" value="001"/>
                <p>[3PAO] attests to the accuracy of the information provided in this FedRAMP Security Assessment Report for the annual assessment
                       of [Information System Name]</p>
            </part>
            <part name="authorization-statement">
                <prop name="sort-id" value="002"/>
                <p>This [Information System Name] SAR provides a complete assessment of the applicable FedRAMP controls defined in the SAP. 
                       Evidence to validate the successful implementation of the security controls has been collected and validated, and will be made 
                       available upon request.</p>
            </part>
            <part name="authorization-statement">
                <prop name="sort-id" value="999"/>
                <p>Based on the remaining risk noted in the [Information System Abbreviation] Risk Exposure Table,  and the continuous improvement 
                       of security related processes and controls, [3PAO Name] [recommends |does not recommend | provisionally recommends]
                       continued authorization be granted for [Information System Name].</p>
            </part>
        </part>
    </attestation>
    <!-- assessment-activities -->
    <risk uuid="ae628cc5-b64c-4030-af30-57e6b24a6ae7">
        <title>Vulnerability Title</title>
        <description>
            <p>This is a description of the vulnerability provided by the tool.</p>
        </description>
        <statement>
            <p>This is a statement about the identified risk as provided by the tool.</p>
        </statement>
        <prop name="priority" ns="https://fedramp.gov/ns/oscal" value="1"/>
    </risk>
</result>

{{</ highlight >}}
