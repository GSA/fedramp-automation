---
title: Security controls
weight: 105
---

![Security Controls](/img/ssp-figure-30.png)

This section describes the modeling of security control information in
an OSCAL-based FedRAMP SSP. To ensure consistent processing, FedRAMP
imposes specific requirements on the use of OSCAL for control implementation information.

The modeling of controls is addressed in the following sections as
follows:

-   **Section 6.1, Control Definitions**

-   **Section 6.2, Responsible Roles Responsible Roles** and Parameter
    Assignments

-   **Section 6.3, Implementation Status**

-   **Section 6.3.1.1, Control Origination**

-   **Section 6.4, Control Implementation Descriptions**

    -   **Organization**

        -   **Policy and Procedure Statements**

        -   **Multi-Part Statements**

        -   **Single Statements**

    -   **Response**

        -   **Overview**

        -   **Example**

        -   **"This System"**

        -   **Inheriting from a Leveraged Authorization**

        -   **Identifying Customer Responsibilities**

        -   **Providing Inheritance**

---
## 6.1. Control Definitions

![Control Definitions](/img/ssp-figure-31.png)

All control definition information is imported from the appropriate
FedRAMP baseline (OSCAL profile).  This includes the original NIST control definition and parameter labels as well as any FedRAMP control 
guidance and parameter constraints.

Interpreting and presenting profile content is beyond the scope of this
document. Please refer to the NIST OSCAL Profile and Catalog schema references for more information:

-   [Profile Model](https://pages.nist.gov/OSCAL/concepts/layer/control/profile/)

-   [Catalog Reference](https://pages.nist.gov/OSCAL/concepts/layer/control/catalog/)

Only the control implementation information is present within an
OSCAL-based SSP. Each control in the FedRAMP baseline must have a
corresponding implemented-requirement assembly in the
control-implementation assembly.

#### Representation
{{< highlight xml "linenos=table" >}}
    <!-- metadata -->
    <import-profile href="https://path/to/xml/FedRAMP_MODERATE-baseline_profile.xml"/>
    <!-- system-characteristics -->
    <!-- system-implementation -->
    <control-implementation>
        <description>
            <p>This field required by OSCAL, but may be left blank.</p>
            <p>FedRAMP requires no specific content here.</p>
        </description>
        
        <!-- one implemented-requirement assembly for each required control -->
        <implemented-requirement uuid="uuid-value" control-id="ac-1">
            <!-- Control content cut - See next pages for detail -->
        </implemented-requirement>
        <implemented-requirement uuid="uuid-value" control-id="ac-2">
        <!-- Control content cut - See next pages for detail -->
        </implemented-requirement>
        <implemented-requirement uuid="uuid-value" control-id="ac-2.1">
        <!-- Control content cut - See next pages for detail -->
        </implemented-requirement>
        
    </control-implementation>
    <!-- back-matter -->

{{</ highlight >}}

#### XPath Queries
{{< highlight xml "linenos=table" >}}
  URI to Profile:
    /*/import-profile/@href
  CSP's Control Implementation Information
    /*/control-implementation/implemented-requirement[@control-id="ac-1"]

{{</ highlight >}}

**NOTE:** FedRAMP tools check to ensure there is one
implemented-requirement assembly for each control identified in the
applicable FedRAMP baseline.

---
## 6.2. Responsible Roles and Parameter Assignments

Every applicable control must have at least one responsible-role
defined. There must be a separate responsible-role assembly for each
responsible role. OSCAL requires the specified role-id to be valid in
the defined list of roles in the metadata. Controls with a FedRAMP
implementation-status property value of non-applicable (see section 6.3)
do not require a responsible-role. FedRAMP further requires the
specified role-id must also have been referenced in the system-implementation user assembly. This equates to the FedRAMP requirement of all responsible roles appearing in the Personnel Roles and Privileges table.

![Responsible Roles and Parameters](/img/ssp-figure-32.png)

With the implemented-requirement assembly, there must be one set-parameter statement for each of the control\'s parameters, as specified in the FedRAMP baseline and illustrated in the example representation below. The only exception to this is with nested parameters. Some select parameters contain an assignment parameter within a selection parameter, such as appears in AC-7 (b). In these instances, only the final selected value must be provided. The nested assignment parameter may be ignored.

OSCAL also supports parameter setting at the component level, within a
by-component assembly.

#### Representation
{{< highlight xml "linenos=table" >}}
<metadata>
    <role id="admin-unix">
        <title>Unix Administrator</title>
    </role>
</metadata>
<!-- Fragment: -->
<system-implementation>
    <user uuid="uuid-value">
        <role-id>admin-unix</role-id>
    </user>
</system-implementation >
<!-- system-implementation -->
<control-implementation>
    <implemented-requirement uuid="uuid-value" control-id="ac-2">
        <!-- cut -->
        <responsible-role role-id="admin-unix" />
        <set-parameter param-id="ac-2_prm_1">
            <value>System Manager, System Architect, ISSO</value>
        </set-parameter >
        <!-- cut -->
    </implemented-requirement>
</control-implementation>
<!-- back-matter -->

{{</ highlight >}}

#### XPath Queries
{{< highlight xml "linenos=table" >}}
  Number of specified Responsible Roles:
    count(/*/control-implementation/implemented-requirement[@control-id="ac-2"]/responsible-role)
  Responsible Role:
    /*/metadata/role[@id=/*/control-implementation/implemented-requirement[@control-id="ac-2"]/responsible-role[1]/@role-id]/title
  Check for existence in Personnel Roles and Privileges (Should return a number > 0)
    count(/*/system-implementation/user/role-id[string(.)=/*/control-implementation/implemented-requirement[@control-id="ac-2"]/responsible-role/@role-id])
  Parameter Value:
    /*/control-implementation/implemented-requirement[@control-id="ac-2"]/set-parameter [@param-id="ac-2_prm_1"]/value

{{</ highlight >}}

---
## 6.3. Implementation Status

FedRAMP only accepts only one of five values for implementation-status:
implemented, partial, planned, alternative, and not-applicable. A
control may be marked "partial" and "planned" (using two separate
implementation-status fields). All other choices are mutually exclusive.

**If the implementation-status is partial,** the gap must be explained
in the remarks field.

**If the implementation-status is planned,** a brief description of the
plan to address the gap, including major milestones must be explained in
the remarks field. There must also be a prop
(name=\"planned-completion-date\" ns=\"https://fedramp.gov/ns/oscal\")
field containing the intended completion date. With XML, prop fields
must appear before prop fields, even though that sequence is
counter-intuitive in this situation.

**If the implementation-status is alternative,** the alternative
implementation must be summarized in the remarks field.

**If the implementation-status is not-applicable,** the N/A
justification must be provided in the remarks field.

![Responsible Roles and Parameters](/img/ssp-figure-33.png)

#### Representation
{{< highlight xml "linenos=table" >}}
<!-- system-implementation -->
<control-implementation>
    <implemented-requirement uuid="uuid-value" control-id="ac-1">
        <prop name="planned-completion-date" 
            ns="https://fedramp.gov/ns/oscal" value="2021-01-01Z"/>
        <prop name="implementation-status" 
            ns="https://fedramp.gov/ns/oscal" value="implemented" />
        <prop name="implementation-status"
            ns="https://fedramp.gov/ns/oscal" value="partial" />
        <prop name="implementation-status" 
            ns="https://fedramp.gov/ns/oscal" value="planned" />
        <prop name="implementation-status" 
            ns="https://fedramp.gov/ns/oscal" value="not-applicable"/>      
        <!-- responsible-role, statement, by-component -->
    </implemented-requirement>  
</control-implementation>
<!-- back-matter -->

{{</ highlight >}}

#### XPath Queries
{{< highlight xml "linenos=table" >}}
  Implementation Status (may return more than 1 result for a given control) :
    /*/control-implementation/implemented-requirement[@control-id="ac-1"] /prop[@name="implementation-status"]/@value
  Gap Description (If implementation-status="partial"):
    /*/control-implementation/implemented-requirement/prop[@name='implementation-status'][@value="partial"][@ns="https://fedramp.gov/ns/oscal"]/remarks/node()
  Planned Completion Date (If implementation-status="planned"):
    /*/control-implementation/implemented-requirement[@control-id="ac-1"]/prop[@name="planned-completion-date"][@ns="https://fedramp.gov/ns/oscal"]/@value
  Plan for Completion (If implementation-status="planned"):
    /*/control-implementation/implemented-requirement/prop[@name='implementation-status'][@value="planned"][@ns="https://fedramp.gov/ns/oscal"]/remarks/node()
  Not Applicable (N/A) Justification (If implementation-status="na"):
    /*/control-implementation/implemented-requirement/prop[@name='implementation-status'][@value="not-applicable"][@ns="https://fedramp.gov/ns/oscal"]/remarks/node()

{{</ highlight >}}

The FedRAMP implementation-status property at the control's
implemented-requirement level is a summary of all statement and/or
component level core OSCAL implementation-status designations. It must
be set to the appropriately based on the least value of child statement
or component level implementation-status designations. When a statement
and/or component level implementation-status designation is not
specified, the FedRAMP implementation-status value is assumed.
Individual statements and/or components may override
implementation-status locally.

### 6.3.1. Control Origination

FedRAMP accepts only one of five values for control-origination:
sp-corporate, sp-system, customer-configured, customer-provided, and
inherited. Hybrid choices are now expressed by identifying more than one
control-origination, each in a separate prop field.\
For controls with a control-id ending in \"-1\", FedRAMP only accepts
sp-corporate, and sp-system.

**If the control origination is inherited,** there must also be a
FedRAMP extension (prop name=\"leveraged-authorization-uuid\"
ns=\"https://fedramp.gov/ns/oscal\") field containing the UUID of the
leveraged authorization as it appears in the
/\*/system-implementation/leveraged-authorization assembly.

![Control Origination](/img/ssp-figure-34.png)

#### Representation
{{< highlight xml "linenos=table" >}}
<system-implementation>
    <!-- status -->
    <leveraged-authorization uuid="uuid-of-leveraged-authorization"> 
        <!-- details cut - see Leveraged Authorizations Section -->
    </leveraged-authorization>
</system-implmentation>

<control-implementation>
    <implemented-requirement uuid="uuid-value" control-id="ac-2">
        <prop name="leveraged-authorization-uuid" 
            value="uuid-of-leveraged-authorization"/>
        <prop ns="https://fedramp.gov/ns/oscal" name="control-origination" 
            value="sp-corporate" />
        <prop ns="https://fedramp.gov/ns/oscal" name="control-origination" 
            value="sp-system" />
        <prop ns="https://fedramp.gov/ns/oscal" name="control-origination" 
            value="customer-configured" />
        <prop ns="https://fedramp.gov/ns/oscal" name="control-origination" 
            value="inherited" />
        <!-- responsible-role -->
    </implemented-requirement>
</control-implementation>
<!-- back-matter -->

{{</ highlight >}}

#### XPath Queries
{{< highlight xml "linenos=table" >}}
  Number of Control Originations:
    count(/*/control-implementation/implemented-requirement[@control-id="ac-2"]/prop[@name="control-origination"][@ns="https://fedramp.gov/ns/oscal"])
  Control Origination(could return more than 1 result):
    /*/control-implementation/implemented-requirement[@control-id="ac-2"]/prop[@name="control-origination"][@ns="https://fedramp.gov/ns/oscal"][1]/@value
  Inherited From: System Name (If control-origination="inherited"):
    /*/system-implementation/leveraged-authorization[@uuid=/*/control-implementation/implemented-requirement[@control-id="ac-2"]/prop[@name="leveraged-authorization-uuid"]]/title
  Inherited From: Authorization Date (If control-origination="inherited"):
    /*/system-implementation/leveraged-authorization[@uuid=/*/control-implementation/implemented-requirement[@control-id="ac-2"]/prop[@name="leveraged-authorization-uuid"]]/date-authorized

{{</ highlight >}}

---
## 6.4. Control Implementation Descriptions

![Control Origination](/img/ssp-figure-35.png)

Within the OSCAL-based FedRAMP baselines, control statements and control
objectives are tagged with a response-point FedRAMP Extension. Every
control statement designated as a response-point in the baseline must
have a statement with the control\'s implemented-requirement assembly.
Please note control objective response points are used for the SAP and
SAR.

When using a **FedRAMP Resolved Profile Catalog**, the following query
will identify the response points for a given control.

#### XPath Query
{{< highlight xml "linenos=table" >}}
  Response Points for AC-1:
    //control[@id='ac-1']/part[@name='statement']//prop[@name='response-point'][@ns='https://fedramp.gov/ns/oscal']/../@id

{{</ highlight >}}

---
### 6.4.1. Organization: Policy and Procedure Statements

For each of the -1 controls, such as AC-1, there must be exactly four
statement assemblies: Part (a)(1), Part (a)(2), Part (b)(1), and Part
(b)(2).

#### Policy and Procedure Representation
{{< highlight xml "linenos=table" >}}
<!-- system-implementation -->
<control-implementation>
    <!-- cut -->
    <implemented-requirement uuid="uuid-value" control-id="ac-1">
        <statement statement-id="ac-1_smt.a.1"><!-- cut --></statement>
        <statement statement-id="ac-1_smt.a.2"><!-- cut --></statement>
        <statement statement-id="ac-1_smt.b.1"><!-- cut --></statement>
        <statement statement-id="ac-1_smt.b.2"><!-- cut --></statement>
    </implemented-requirement>
</control-implementation>

{{</ highlight >}}

---
### 6.4.2. Organization: Multi-Part Statements 

There must be one statement assembly for each lettered part, such as
with AC-2, parts a, b, c, etc.

#### Multi-Part Statement Representation
{{< highlight xml "linenos=table" >}}
<!-- system-implementation -->
<control-implementation>
    <!-- cut -->
    <implemented-requirement uuid="uuid-value" control-id="ac-2">
        <statement statement-id="ac-2_smt.a"><!-- cut --></statement>
        <!-- repeat for b, c, d, e, f, g, h, i, j -->
        <statement statement-id="ac-2_smt.k"><!-- cut --></statement>
    </implemented-requirement>
</control-implementation>

{{</ highlight >}}

---
### 6.4.3. Organization: Single Statement

If there are no lettered parts in the control definition, such as with
AC-2 (1), there must be exactly one statement assembly.

#### Single-Statement Representation
{{< highlight xml "linenos=table" >}}
<!-- system-implementation -->
<control-implementation>
    <!-- cut -->
    <implemented-requirement control-id="ac-2.1">
        <statement statement-id="ac-2.1_smt"><!-- cut --></statement>
    </implemented-requirement>
</control-implementation>

{{</ highlight >}}

---
### 6.4.4. Response: Overview

Within each statement assembly, all responses must be provided within
one or more by-component assemblies. There must always be a component
defined in the system-implementation representing the system as a whole
(**"THIS SYSTEM"**), even if individual components are defined that
comprise the system. **See *7.3,* *Working with Components* for more information.**

An OSCAL-based FedRAMP SSP should define individual components of the
system. Components are not just hardware and software. Policies,
processes, FIPS 140 validation information, interconnections, services,
and underlying systems (leveraged authorizations) are all components.

With OSCAL, the content in the cell next to *Part a* must be broken down
into its individual components and responded to separately.

![Control Implementation](/img/ssp-figure-36.png)

- For **Part a**
    - Component - This System
        - Describes how *part a* is satisfied holistically, or where the description does not fit with a defined component.
    - Component - Platform
        - Describes how *part a* is satisfied by the platform.
    - Component - Web-Server
        - Describes how *part a* is satisfied by the web server.
    - Component - Process
        - Describes how *part a* is satisfied by an identified process within this organization.
    - Component - Inherited
        - Describes what is inherited from the underlying Infrastructure as a Service (IaaS) provider to satisfy *part a*.
- For **Part b**
    - Component - This System
        - Describes how *part b* is satisfied holistically, or where the description does not fit with a defined component.
    - Component - Platform
        - Describes how *part b* is satisfied by the platform.
    - Component - Web-Server
        - Describes how *part b* is satisfied by the web server.
    - Component - Process
        - Describes how *part b* is satisfied by an identified process within this organization.
    - Component - Inherited
        - Describes what is inherited from the underlying Infrastructure as a Service (IaaS) provider to satisfy *part b*.


**The following pages provide examples.**

---
### 6.4.5. Response: Example

Within each of the statement assemblies, all responses appear in one or
more by-component assemblies. Each by-component assembly references a component defined in the system-implementation assembly.

![Response](/img/ssp-figure-37.png)

#### Representation
{{< highlight xml "linenos=table" >}}
<system-implementation>
    <!-- leveraged-authorization, user -->
    <component uuid="uuid-value" type="software">
        <title>Component Title</title>
        <description>
            <p>Description of the component.</p>
        </description>
        <status state="operational"/>
    </component>
    
    <component uuid="uuid-value" type="process">
        <title>Process Title</title>
        <description>
            <p>Description of the component.</p>
        </description>
        <status state="operational"/>
        <responsible-role role-id="admin-unix">
            <party-uuid>3360e343-9860-4bda-9dfc-ff427c3dfab6</party-uuid>
        </responsible-role>
    </component>
</system-implementation>

<control-implementation>
    <!-- cut -->
    <implemented-requirement uuid="uuid-value" control-id="ac-2">
        <statement uuid="uuid-value" statement-id="ac-2_smt.a">
            
            <by-component uuid="uuid-value" component-uuid="uuid-of-software-component">
                <description>
                    <p>Describe how is the software component satisfying the control.</p>
                </description>
            </by-component>
            <by-component uuid="uuid-value" component-uuid="uuid-of-process-component">
                <description>
                    <p>Describe how is the process satisfies the control.</p>
                </description>
            </by-component>
            <!-- repeat by-component assembly for each component related to part a. -->
            
        </statement>
        <!-- repeat statement assembly for statement part (b, c, etc.) as needed. -->
    </implemented-requirement>
</control-implementation>
<!-- back-matter -->

{{</ highlight >}}

**NOTES:**

-   All statement-id values must be cited as they appear in the NIST SP
    800-53, Revision 4 or Revision 5 OSCAL catalogs:\
    <https://github.com/usnistgov/oscal-content/tree/master/nist.gov/SP800-53>

---
### 6.4.6. Response: "This System" Component

There must always be a **"This System"** component in the SSP. This is used in several ways:

-   **Holistic Overview**: If the SSP author wishes to provide a more
    holistic overview of how several components work together, even if
    details are provided individually in other by-component assemblies.

-   **Catch-all**: Any control response that does not cleanly align with
    another system component may be described in the **"This System"**
    component.

-   **Legacy SSP Conversion**: When converting a legacy SSP to OSCAL,
    the legacy control response statements may initially be associated
    with the **"This System"** component until the SSP author is able\
    to provide responses for individual components.

![This System Component](/img/ssp-figure-38.png)

#### Representation
{{< highlight xml "linenos=table" >}}
<system-implementation>
    <!-- leveraged-authorization, user -->
    <component uuid="uuid-value" type="this-system">
        <title>This System</title>
        <description>
            <p>Description of the component.</p>
        </description>
        <status state="operational"/>
    </component>
</system-implementation>

<control-implementation>
    <!-- cut -->
    <implemented-requirement uuid="uuid-value" control-id="ac-2">
        <statement uuid="uuid-value" statement-id="ac-2_smt.a">
            
            <by-component uuid="uuid-value" component-uuid="uuid-of-this-system-component">
                <description>
                    <p>Describe how individual components are working together.</p>
                    <p>Describe how the system - as a whole - is satisfying this statement.</p>
                    <p>This can include policy, procedures, hardware, software, etc.</p>
                </description>
            </by-component>
            
        </statement>
        <!-- repeat statement assembly for statement part (b, c, etc.) as needed. -->
    </implemented-requirement>
</control-implementation>
<!-- back-matter -->

{{</ highlight >}}

**NOTES:**

-   Although the name of the component is **"This System"**,
    non-technical solutions may also be discussed here, such as policies
    and procedures.

---
### 6.4.7. Linking to Artifacts

Any time policies, procedures, plans, and similar documentation are
cited in a control response, they must be linked.

For the legacy approach, when responding within the by-component
assembly for **"this system"**, the link must be within the same by-component assembly where the artifact is cited.

![This System Component](/img/ssp-figure-39.png)

#### Representation: Legacy Approach Example - No Policy Component
{{< highlight xml "linenos=table" >}}
<control-implementation>
    <implemented-requirement uuid="uuid-value" control-id="ac-1">
        <statement uuid="uuid-value" statement-id="ac-1_smt.a">
            <by-component component-uuid="uuid-of-this-system" uuid="uuid-value">
                <description>
                    <p>Describe how Part a is satisfied within the system.</p>
                </description>
                <link href="#uuid-of-policy-resource-in-back-matter" rel="policy" />
            </by-component>
        </statement>
    </implemented-requirement>
</control-implementation>
<!-- back-matter -->

{{</ highlight >}}

For the component approach, use the component representing the policy.
The link should be in the component, but may be added directly to the
by-component as well.

#### Representation: Component Approach Example
{{< highlight xml "linenos=table" >}}
<system-implementation>
    <!-- leveraged-authorization, user -->
    <component uuid="uuid-value" type="policy">
        <title>Access Control and Identity Management Policy</title>
        <description>
            <p>An example component representing a policy.</p>
        </description>
        <link href="#uuid-of-policy-resource-in-back-matter" rel="policy" />
        <status state="operational"/>
    </component>
</system-implementation>
<control-implementation>
    <implemented-requirement uuid="uuid-value" control-id="ac-1">
        <statement uuid="uuid-value" statement-id="ac-1_smt.a">
            <by-component component-uuid="uuid-of-policy-component" uuid="uuid-value">
                <description>
                    <p>Describe how this policy satisfies Part a.</p>
                </description>
            </by-component>
        </statement>
    </implemented-requirement>
</control-implementation>
<!-- back-matter -->

{{</ highlight >}}

For either example above, the policy must be present as a resource in back-matter.

#### In Back Matter
{{< highlight xml "linenos=table" >}}
<back-matter>
    <resource uuid="uuid-value">
        <title>Access Control and Identity Management Policy</title>
        <rlink media-type="application/pdf" href="./documents/policies/sample_policy.pdf" />
        <base64 filename="sample_policy.pdf" media-type="application/pdf">00000000</base64>
    </resource>
</back-matter>

{{</ highlight >}}

---
### 6.4.8. Response: Identifying Inheritable Controls and Customer Responsibilities

For systems that may be leveraged, OSCAL enables a robust mechanism for
providing both inheritance details as well as customer responsibilities
(referred to as consumer responsibilities by NIST). OSCAL is designed to
enable leveraged and leveraging system SSP details to be linked by tools
for validation.

Within the appropriate by-component assembly, include an export
assembly. Use provided to identify a capability that may be inherited by a leveraging system. Use responsibility to identify a customer responsibility. If a responsibility must be satisfied to achieve inheritance, add the
provided-uuid flag to the responsibility field.

#### Representation
{{< highlight xml "linenos=table" >}}
<!-- system-implementation -->
<control-implementation><!-- cut -->
    <implemented-requirement uuid="uuid-value" control-id="ac-2">
        <statement uuid="uuid-value" statement-id="ac-2_smt.a">
            <by-component uuid="uuid-value" component-uuid="uuid-of-this-system-component">
                <description>
                    <p>Describe how the system - as a whole - is satisfying this statement.</p>
                </description>
                <export>
                    <responsibility uuid="uuid-value">
                        <description>
                            <p>Leveraging system's responsibilities in satisfaction of AC-2.</p>
                            <p>Not linked to inheritance, so this is always required.</p>
                        </description>
                        <responsible-role role-id="customer" />
                    </responsibility>
                </export>
            </by-component>            
            <by-component uuid="uuid-value" component-uuid="uuid-of-software-component">
                <description>
                    <p>Describe how the software is satisfying this statement.</p>
                </description>
                <export>
                    <provided uuid="uuid-value">
                        <description>
                            <p>Customer appropriate description of what may be inherited.</p>
                        </description>
                        <responsible-role role-id="poc-for-customers" />
                    </provided>
                    
                    <responsibility uuid="uuid-value" provided-uuid="uuid-of-provided">
                        <description>
                            <p>Customer responsibilities if inheriting this capability.</p>
                        </description>
                        <responsible-role role-id="customer" />
                    </responsibility>
                </export>
            </by-component>
        </statement>
    </implemented-requirement>
</control-implementation>

{{</ highlight >}}

**See Section 6.4.10, XPath Queries for Control Implementation Descriptions**

**See the [NIST OSCAL Leveraged Authorization Presentation](https://pages.nist.gov/OSCAL/presentations/oscal-leveraged-authorizations-v6a.pdf) for more information.**

---
### 6.4.9. Leveraged Authorization Response: Inheriting Controls, Satisfying Responsibilities

When the current system is inheriting a control from or meeting customer
responsibilities defined by an underlying authorization, the leveraged
system must first be defined as described in *Section **Error! Reference
source not found.**, **Error! Reference source not found.*** before it
may be referenced in a control response. The by-component assembly
references these components.

IMPORTANT: The leveraged system may provide a single component
representing the entire leveraged system\
or may provide individual system components as well. In either case, the
inherited-uuid property in the component when defined in the leveraging
system\'s SSP.

![Leveraged Authorization Response](/img/ssp-figure-41.png)

#### Representation
{{< highlight xml "linenos=table" >}}
<system-implementation>
    <component uuid="uuid-value" type="this-system"><!-- cut --></component>
    <component uuid="uuid-value" type="leveraged-system">
        <title><b>LEVERAGED SYSTEM as a whole (IaaS)</b></title>
        <prop name="leveraged-authorization-uuid" value="uuid-of-LA-in-this-SSP" />
        <prop name="inherited-uuid" value="uuid-of-component-in-leveraged-SSP" />
    </component>
    <component uuid="uuid-value" type="service">
        <title>Service Provided by Leveraged System</title>
        <prop name="leveraged-authorization-uuid" value="uuid-of-LA-in-this-SSP" />
        <prop name="inherited-uuid" value="uuid-of-component-in-leveraged-SSP" />
    </component>
</system-implementation>        
<control-implementation>
    <implemented-requirement uuid="uuid-value" control-id="ac-2">
        <statement uuid="uuid-value" statement-id="ac-2_smt.a">            
            <by-component uuid="uuid-value" component-uuid="uuid-of-this-system-component">
                <description><p>Describe what is satisfied by this system.</p></description>
            </by-component>
            
            <by-component uuid="uuid-value" component-uuid="uuid-leveraged-system-component">
                <description>
                    <p>Describe what is inherited from the leveraged system in satisfaction
                        of this control statement.</p>
                </description>
                
                <inherited provided-uuid="uuid-of-provided" uuid="uuid-value">
                    <description>
                        <p>Optional: Information provided by leveraged system.</p>
                    </description>
                </inherited>
                
                <satisfied responsibility-uuid="uuid-of-responsibility" uuid="uuid-value" >
                    <description>
                        <p>Description of how the responsibility was satisfied.</p>
                    </description>
                </satisfied>
            </by-component>
        </statement>
        <!-- repeat statement assembly for statement part (b, c, etc.) as needed. -->
    </implemented-requirement>
</control-implementation>
<!-- back-matter -->

{{</ highlight >}}

**See Section 6.4.10, XPath Queries for Control Implementation Descriptions**

**See the [NIST OSCAL Leveraged Authorization Presentation](https://pages.nist.gov/OSCAL/presentations/oscal-leveraged-authorizations-v6a.pdf) for more information.**

---
### 6.4.10. XPath Queries for Control Implementation Descriptions

Use the following XPath queries to retrieve basic control response
information. For any given control response part, tools should list the
name of each component cited by a by-component assembly, as well as the
description.

![Leveraged Authorization Response](/img/ssp-figure-41.png)

#### Representation
{{< highlight xml "linenos=table" >}}
  Number of cited components for AC-2, part a (Integer):
    count(/*/control-implementation/implemented-requirement[@control-id="ac-2"]/statement[@statement-id="ac-2_smt.a"]/by-component)
  Name of first component related to AC-2, part a:
    /*/system-implementation/component[@uuid=/*/control-implementation/implemented-requirement[@control-id="ac-2"]/statement[@statement-id="ac-2_smt.a"]/by-component[1]/@component-uuid]/title
  "What is the solution and how is it implemented?" for AC-2, Part (a), first component:
    /*/control-implementation/implemented-requirement[@control-id="ac-2"]/statement[@statement-id="ac-2_smt.a"]/by-component[1]/description/node()
  Is there a customer responsibility for the first component in AC-2, part a? (true/false):
    boolean(/*/control-implementation/implemented-requirement[@control-id="ac-2"]/statement[@statement-id="ac-2_smt.a"]/by-component[1] /prop[@name='responsibility'][@value='customer'])
  Customer responsibility statement for the first component in AC-2, part a:
    /*/control-implementation/implemented-requirement[@control-id="ac-2"]/statement[@statement-id="ac-2_smt.a"]/by-component[1]/prop[@name='responsibility'][@value='customer']/remarks/node()     

{{</ highlight >}}


**NOTES:**

-   Replace "ac-2" with target control-id.
-   Replace "ac-2_smt.a" with target control statement-id.
-   Replace "\[1\]" with "\[2\]", "\[3\]", etc. as needed to reference
    is by-component statement.
