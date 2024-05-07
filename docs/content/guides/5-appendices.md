---
title: Appendices
weight: 90
---

# Appendices

## Appendix A. OSCAL-Based FedRAMP Baselines

NIST designed OSCAL catalogs as the primary source of control definition
information from a framework publisher. Catalogs are typically only
published by organizations such as NIST for NIST SP 800-53, or ISO/IEC
for standards such as their 27000 series. If an organization has unique
control definitions that fall outside an applicable framework, the
organization must create a catalog containing those unique control
definitions.

NIST designed profiles as the primary means of defining a baseline of
controls. An OSCAL profile may identify and even modify controls from
one or more catalogs and even from other profiles. This approach ensures
control additions, modifications, or removal are fully traceable back to
the source of the modification.

![FedRAMP Baselines](/img/content-figure-13.png)

FedRAMP\'s baselines are represented as OSCAL profiles. The correct
profile must be selected from the SSP based on the system\'s identified
security categorization level. This can be checked using the XPath
syntax below.

#### Security Sensitivity Level XPath Query
{{< highlight xml "linenos=table" >}}
  (SSP) Security Categorization Level:
    /*/system-characteristics/security-sensitivity-level
{{</ highlight >}}

This determines which URL should be entered for the `import-profile` field
in an OSCAL-based FedRAMP SSP.

#### Baseline Representation
{{< highlight xml "linenos=table" >}}
  <!-- metadata -->
  <!-- This must point to the appropriate FedRAMP Baseline -->
  <import-profile
  href="https://path/to/FedRAMP_MODERATE-baseline_profile.xml"/>
  <!-- system-characteristics -->
{{</ highlight >}}

FedRAMP validation tools will compare the identified security
categorization level to the actual FedRAMP baseline specified in the SSP
and raise a warning if a different baseline was used.

|**High (Rev 5)**|
| :-- |
| **XML Version:** <https://raw.githubusercontent.com/GSA/fedramp-automation/master/dist/content/rev5/baselines/xml/FedRAMP_rev5_HIGH-baseline_profile.xml>|
| **JSON Version:** <https://raw.githubusercontent.com/GSA/fedramp-automation/master/dist/content/rev5/baselines/json/FedRAMP_rev5_HIGH-baseline_profile.json>|

|**Moderate (Rev 5)**|
| :-- |
| **XML Version:** <https://raw.githubusercontent.com/GSA/fedramp-automation/master/dist/content/rev5/baselines/xml/FedRAMP_rev5_MODERATE-baseline_profile.xml>|
| **JSON Version:** <https://raw.githubusercontent.com/GSA/fedramp-automation/master/dist/content/rev5/baselines/json/FedRAMP_rev5_MODERATE-baseline_profile.json>|

|**Low (Rev 5)**|
| :-- |
| **XML Version:** <https://raw.githubusercontent.com/GSA/fedramp-automation/master/dist/content/rev5/baselines/xml/FedRAMP_rev5_LOW-baseline_profile.xml>|
| **JSON Version:** <https://raw.githubusercontent.com/GSA/fedramp-automation/master/dist/content/rev5/baselines/json/FedRAMP_rev5_LOW-baseline_profile.json>|

**Do not copy and modify the FedRAMP baseline.** FedRAMP will use the
original, published file for validation, ignoring any modified copies.

If you require a modification to the FedRAMP baselines, such as may be
required when directed to do so by an authorizing official, first
contact FedRAMP to coordinate the modification, then follow the
instructions in Appendix B.

When FedRAMP publishes baselines for NIST SP 800-53 Revision 5, they
will be located here:\
<https://github.com/GSA/fedramp-automation/tree/master/dist/content/rev5/baselines>

### *FedRAMP Tailored*

FedRAMP Tailored for Low Impact -- Software as a Service (LI-SaaS)
Appendix B merges SSP, SAP, and SAR information into a single document.
The SSP portions of that document may be represented using the same
OSCAL conventions described in this document with only a few minor
differences.

Specific OSCAL-based FedRAMP Tailored guidance will be published at a
later date; however, fully representing Appendix B in OSCAL requires the
SSP, SAP, and SAR syntax, used the same way as they are explained for
FedRAMP Low, Moderate, and High baselines.

For your convenience, FedRAMP has made the FedRAMP Tailored for LI-SaaS
baseline available now in both XML and JSON formats as follows:

|**Low-Impact SaaS (Tailored)**|
| :-- |
| **XML Version:** <https://raw.githubusercontent.com/GSA/fedramp-automation/master/dist/content/rev5/baselines/xml/FedRAMP_rev5_LI-SaaS-baseline_profile.xml>|
| **JSON Version:** <https://raw.githubusercontent.com/GSA/fedramp-automation/master/dist/content/rev5/baselines/json/FedRAMP_rev5_LI-SaaS-baseline_profile.json>|

## Appendix B. Modifying a FedRAMP Baseline

OSCAL is designed to allow modification of controls and baselines, while
maintaining traceability through each layer of modification. This means
you must create a new profile as a means of modifying an existing
profile.

If you require a change to a FedRAMP baseline, you should first
coordinate that change with the FedRAMP JAB or PMO. Assuming FedRAMP
agrees with the change, the correct way to implement the change is as
follows:

1.  **Create a new, blank OSCAL Profile.**

2.  **Point to the FedRAMP Baseline**: Point it to the appropriate
    FedRAMP baseline using an `import` field.

3.  **Select the Relevant Controls**: Use the `include` and `exclude` fields
    to identify the controls to include or exclude from the FedRAMP
    baseline.

    a.  For example, if you need all but one control, you can `include all`, then `exclude` the one.

4.  **Specify How Controls Are Organized**: FedRAMP prefers you merge
    \"as-is\" using those merge fields. This is relevant when resolving
    the profile. See the *Profile Resolution* section of this appendix
    for more information.

5.  **Modify the Selected Controls**: Use the `modify` assembly to make modifications to parameters and control definitions.

{{< callout >}}
Create a new profile, importing to the appropriate FedRAMP profile, then use profile syntax to make necessary changes.

**FedRAMP does not typically allow modifications to its baselines. This capability is present only in the event of a policy change or unforeseen circumstances.**
{{</ callout >}}


The next page contains an example profile, which accomplishes the
following actions:

-   Imports the FedRAMP Moderate baseline

-   Includes all controls from that baseline

-   Explicitly removes AT-4 from the baseline

-   Indicates that if this profile is resolved, the organization of the
    controls should remain as-is. See the *Profile Resolution* section
    of this appendix for more information.

-   Adds a constraint to the third parameter of AC-1 (ac-1_prm_3), which
    is more restrictive than the FedRAMP constraint, but changing it
    from \"at least annually\" to \"at least every six months.\"

-   Removes the additional FedRAMP requirement statement in AU-11 and
    replaces it with a more restrictive statement, which now requires
    online retention of audit records for at least 180 days instead of
    90 days.

For more information on working with profiles, please visit the NIST
OSCAL site at:\
<https://pages.nist.gov/OSCAL>

A complete OSCAL profile syntax reference is available here:\
[https://pages.nist.gov/OSCAL/concepts/layer/control/profile/](https://pages.nist.gov/OSCAL/concepts/layer/control/profile/)

#### Sample Profile to Modify a FedRAMP Baseline
{{< highlight xml "linenos=table" >}}
<profile xmlns="http://csrc.nist.gov/ns/oscal/1.0"
    uuid="-UUID-value-cut-">
    <metadata>
        <title>[XYZ Org] Modification to FedRAMP Moderate Baseline</title>
        <last-modified>2023-03-06T08:05:30.000Z</last-modified>
        <version>fedramp2.0.0-oscal1.0.4</version>
        <oscal-version>1.0.4</oscal-version>
    </metadata>
    <import href="https://path/to/FedRAMP_MODERATE-baseline_profile.xml">
        <!-- Include every control (and child control) in the Moderate baseline -->
        <include-all />
        <exclude-controls with-child-controls="yes">
            <!-- Remove Control AT-4 -->
            <with-id>at-4</with-id> 
        </exclude-controls>
    </import>
    <merge><as-is>yes</as-is></merge>
    <modify>
        <set-parameter id="ac-1_prm_3">
            <!-- Change the constraint from "at least annually" -->
            <constraint>
                <description>
                    <p>at least every six months</p>
                </description>
            </constraint>
        </set-parameter>        
        <alter control-id="au-11">
            <remove by-id="au-11_fr" />
            <add position="ending">
                <part id="au-11_fr" name="item">
                    <title>[XYZ Org]Modified Requirement</title>
                    <part id="au-11_fr_smt.1" name="item">
                        <prop name="label">Requirement:</prop>
                        <p>The service provider retains audit records on-line for at 180 days and further preserves audit records off-line for a period that is in accordance with NARA requirements.</p>
                    </part>
                </part>
            </add>
        </alter>
    </modify>
</profile>
{{</ highlight >}}

## Appendix C. Profile Resolution

Profiles are intended to identify upstream sources of control definition
information and show only the changes to those upstream sources. This
enables humans and computers to trace control definition changes back to
their source framework.

{{< callout >}}
Profile resolution flattens or merges a profile and its imported catalog(s) and profiles into a single OSCAL file using the catalog syntax.
{{</ callout >}}

While this ensures traceability of selected controls and modified
content, it can also be resource intensive. Profile resolution flattens
or merges a profile and its imported catalog(s) and profiles into a
single OSCAL file using the catalog syntax.

![Profile Resolution](/img/content-figure-14.png)

This single file is essentially a pre-processed result of the profile
import and modification content. A resolved profile catalog is useful
for the FedRAMP baselines given their static nature. Any tool that would
normally open an OSCAL-based FedRAMP profile and process it against the
NIST SP 800-53 catalog can instead simply use the resolved-profile
catalog.

Each FedRAMP XML and JSON baseline profile has a resolved profile
catalog in the same location as the pre-processed profile. Where
available, these may be used by tools to save processing time.

The `merge` assembly within an OSCAL profile offers a profile resolver
control over how the final file is organized. To maintain the same
organization as within the catalog, simply use the `as-is` field and set
it to `"yes"`.

The complete profile syntax is available here:

<https://pages.nist.gov/OSCAL/concepts/layer/control/profile/>

### *NIST\'s Profile Resolution Tool*

NIST created a profile resolution specification, and built a profile
resolution capability based on that specification. The specification can
be found here:

<https://github.com/usnistgov/OSCAL/tree/main/src/specifications/profile-resolution>

The actual tool can be found here:

<https://github.com/usnistgov/OSCAL/tree/main/src/utils/util/resolver-pipeline>

Currently the tool requires the profile and all imported catalogs and
profiles to be in XML format. For now, JSON content must be converted to
XML before using this tool.

The tool requires an XSLT 3.1 processor, which is the same requirement
for XML to JSON and JSON to XML conversions.

All XSL files provided at the link above must be in the same directory.
Only oscal-profile-RESOLVE.xsl must be identified to the XSLT processor.
All other files are called by this file as part of processing.

It is also possible to run the scripts directly from the NIST OSCAL
repository by supplying the following URL directly to the XSLT
processor:

<https://raw.githubusercontent.com/usnistgov/OSCAL/main/src/utils/util/resolver-pipeline/oscal-profile-RESOLVE.xsl>

This is a new capability provided by NIST and leveraged by FedRAMP.
Please report bugs or provide feedback related to this tool directly to
NIST at <oscal@nist.gov> or by submitting an issue here:

<https://github.com/usnistgov/OSCAL/issues>

## Appendix D. Working with Roles, Locations, People, and Organizations

An OSCAL file defines roles, people, and organizations within the
metadata as part of three separate assemblies:

-   **role**: A role ID and role `title` are required. Other content, such
    as a `short-name`, `description`, or `remarks` are optional.

-   **location**: Locations, such as corporate offices and data center
    addresses, are defined as `location` assemblies

-   **party**: People and organizations are defined as `party` assemblies.
    An organization is any collection of people, and can represent a
    company, agency, department, or team.

-   **responsible-party**: Links roles to parties. The same `role` can
    have more than one `party` assigned to it. Also a `party` can be
    assigned to more than one `role`.

### *FedRAMP Defined Party Identifiers*

FedRAMP has eliminated the use of FedRAMP-Defined Party Identifiers.

With the transition from ID to UUID for party identifiers this is no
longer possible. Further, this helps ensure OSCAL remains compatible
with multiple compliance frameworks.

### *Working with Role Assemblies*

All roles within the document are defined under the metadata element as
follows:

{{< highlight xml "linenos=table" >}}
<metadata>
    <!-- cut -->
    <role id="prepared-by">
        <title>Prepared By</title>
        <description>
          <p>The organization that prepared this SSP.</p>
        </description>
    </role>
    <role id="prepared-for">
        <title>Prepared For</title>
        <description>
          <p>The organization for which this SSP was prepared</p>
        </description>
    </role>
    <!-- cut -->
</metadata>
{{</ highlight >}}

To ensure consistent processing, FedRAMP has defined a specific set of
roles that must exist with a FedRAMP SSP, SAP, SAR, or POA&M. **Most are
pre-populated in the OSCAL-based FedRAMP Templates.** They vary by
template.

OSCAL-based FedRAMP tools must ensure these roles, titles, and
descriptions exist using the prescribed role IDs within an OSCAL-based
FedRAMP file. Additional roles may be added, provided these roles
remain.

**NIST-defined and FedRAMP-defined role-identifiers are cited in
relevant portions of each guide, and summarized in the FedRAMP OSCAL
Registry.**

### *Working with Location Assemblies*

The `location` assembly is intended to represent the address of a location
such as the HQ of a CSP or 3PAO, a data center, or an Agency.

Some locations are required. For example, the SSP must contain the at
least one `location` assembly with the primary business address of the
CSP. The SAP and SAR must contain at least one `location` assembly with
the primary business address of the assessor.

OSCAL allows the `title` field to be optional. FedRAMP strongly encourages
its use. If the `country` field is missing, FedRAMP tools will assume the
address is within the United States of America.

{{< highlight xml "linenos=table" >}}
<metadata>
    <!-- role -->
    <location uuid="uuid-of-hq-location">
        <title>CSP HQ</title>
        <address type="work">
            <addr-line>1234 Some Street</addr-line>
            <city>Haven</city>
            <state>ME</state>
            <postal-code>00000</postal-code>
            <country>us</country>
        </address>
        <prop name="type" class="primary" value="data-center"/>
    </location>
    <!-- party -->
</metadata>
{{</ highlight >}}

Some locations require type properties to ensure FedRAMP tools can
accurately identify required content. For example, the location assembly
for a data center must include a `type` property with a value of
`"data-center"`. The class may be used to indicate whether the data
center is \"primary\" or \"alternate\".

### *Working with Party Assemblies*

Party assemblies may be used to represent individuals, teams, or an
entire company/agency. When representing an individual, the `type` flag
must have a value of `"person"`. When representing a team, company or
agency, the `type` flag must have a value of `"organization"`. FedRAMP
artifacts typically require an individual\'s title to be identified, the
`prop` `"job-title"` is designated for this purpose.

Contact details, such as an individual\'s email address and phone
number, or a business web site, may be included and are often required
within FedRAMP artifacts. A `short-name` field provides an ability to
define an organization\'s acronym or desired abbreviation. This is
required for the CSP, assessor, and any Agency.

{{< highlight xml "linenos=table" >}}
<metadata>
    <!-- role -->
    <party uuid="uuid-of-csp" type="organization">
        <name>Cloud Service Provider (CSP) Name</name>
        <short-name>CSP Acronym</short-name>
        <link href="https://www.csp.com" />
    </party>
    
    <party uuid="uuid-of-person-1" type="person">
        <name>[SAMPLE]Person Name 1</name>
        <prop name="job-title" value="Individual's Title"/>
        <email-address>name@org.domain</email-address>
        <telephone-number>202-555-0000</telephone-number>
    </party>
</metadata>
{{</ highlight >}}

**FedRAMP extensions are cited in relevant portions of each guide, and summarized in the FedRAMP OSCAL Registry.**

### *Identifying Organizational Membership of Individuals*

An individual may be affiliated with one or more teams/organizations.\
Use one `member-of-organization` field for each team, and one to link the
individual to their employer.

{{< highlight xml "linenos=table" >}}
<metadata>
    <!-- role -->
    <party uuid="uuid-of-csp" type="organization">
        <name>Cloud Service Provider (CSP) Name</name>
    </party>
    
    <party uuid="uuid-of-it-dept" type="organization">
        <name>CSP's IT Department</name>
    </party>
    
    <party uuid="uuid-of-person-1" type="person">
        <name>[SAMPLE]Person Name 1</name>
        <member-of-organization>uuid-of-csp</member-of-organization>
        <member-of-organization>uuid-of-it-dept</member-of-organization>
    </party>
</metadata>
{{</ highlight >}}

### *Identifying the Address of People and Organizations*

Representing the address of people or organizations (parties) may be
accomplished with one of three approaches:

**Preferred Approach**: When multiple parties share the same address,
such as multiple staff members at a company HQ, define the address once
as a `location` assembly, then use the `location-uuid` field within each
`party` assembly to identify the location of that individual or team.

**Alternate Approach**: If the address is unique to this individual, it
may be included in the `party` assembly itself.

**Hybrid Approach**: It is possible to include both a `location-uuid` and
an `address` assembly within a `party` assembly. This may be used where
multiple staff are in the same building, yet have different office
numbers or mail stops. Use the `location-uuid` to identify the shared
building, and only include a single `addr-line` field within the party\'s
`address` assembly.

A tool developer may elect to always create a location assembly, even
when only used once; however, tools must recognize and handle all of the
approaches above when processing OSCAL files.

{{< highlight xml "linenos=table" >}}
<metadata>
    <!-- cut -->
    <location uuid="uuid-of-hq-location">
        <title>CSP HQ</title>
        <address type="work">
            <addr-line>1234 Some Street</addr-line>
            <city>Haven</city>
            <state>ME</state>
            <postal-code>00000</postal-code>
        </address>
    </location>
    
    <party uuid="uuid-of-csp" type="organization">
        <name>Cloud Service Provider (CSP) Name</name>
        <location-uuid>uuid-of-hq-location</location-uuid>
    </party>
    
    <party uuid="uuid-of-person-1" type="person">
        <name>[SAMPLE]Person Name 1</name>
        <prop name="mail-stop" value="A-1"/>
        <location-uuid>uuid-of-hq-location</location-uuid>
    </party>
</metadata>
{{</ highlight >}}

### *Working with Responsible Party Assemblies*

The responsible party assembly links party assemblies (people and
organizations) to defined roles. FedRAMP tools rely on these linkages to
find required content.

For example, an OSCAL-based SSP must have a role defined for the System
Owner using the role ID value \"system-owner\". The responsible-party
assembly links this required role to the individual (party). FedRAMP
tools follow this linkage to verify that a system owner was identified
in the SSP, and to display that information to reviewers.

{{< highlight xml "linenos=table" >}}
<metadata>
    <!-- party -->
    <responsible-party role-id="system-owner">
        <party-uuid>uuid-of-person-1</party-uuid>
    </responsible-party>
</metadata>
{{</ highlight >}}
