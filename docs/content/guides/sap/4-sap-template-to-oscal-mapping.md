---
title: SAP Template to OSCAL Mapping
weight: 102
---

For SAP-specific content, each page of the SAP is represented in this
section, along with OSCAL code snippets for representing the information
in OSCAL syntax. There is also XPath syntax for querying the code in an
OSCAL-based FedRAMP SAP represented in XML format.

Content that is common across OSCAL file types is described in the
*[Guide to OSCAL-based FedRAMP Content](/guides).*
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

It is not necessary to represent the following sections of the SAR
template in OSCAL; however, tools should present users with this content
where it is appropriate:

-   Any blue-text instructions found in the SAP template where the
    instructions are related to the content itself.

-   Table of Contents.

-   Introductory and instructive content in each section.

The Annual SAP was used, which includes all information typically found
in the Initial SAP, plus a scope section that is unique to annual
assessments. OSCAL always requires a scope. For initial assessments, the
scope is all controls. For annual assessments, it is the controls
required by FedRAMP.

**NOTE: The FedRAMP SAP template screenshots in the sections that follow
vary slightly from the most current version of the FedRAMP rev 5 SAP
template.**

**The following pages are intended to be printed landscape on tabloid
(11\" x 17\") paper.**

---
## 4.1. Background

The *Background*, *Purpose*, and *Applicable Laws* sections of the
FedRAMP SAP template contain references to the CSP name, the CSO name,
and the independent assessor (IA) name. The information in these
sections may be represented as a part assembly within the
terms-and-conditions element of an OSCAL SSP. This approach is optional
as the specific data items can simply be queried from an OSCAL SAP and
its associated documents.

![Background](/img/sap-figure-4.png)

#### SAP Import Representation
{{< highlight xml "linenos=table" >}}
<!-- cut -->

   <terms-and-conditions>
      <!-- Section 2 Background -->
      <part ns="https://fedramp.gov/ns/oscal" name="background">
         <title>Background</title>
         <p>Insert text from FedRAMP template</p>
         <p> Insert text from FedRAMP template </p>
         <part ns="https://fedramp.gov/ns/oscal" name="nist-sp800-39">
            <p> Insert text from FedRAMP template</p>
         </part>
         <!-- Section 2.1 -->
         <part ns="https://fedramp.gov/ns/oscal" name="purpose">
            <title>Purpose</title>
            <prop ns="https://fedramp.gov/ns/oscal" name="sort-id" value="001"/>
            <p>This SAP has been developed by [IA Name] and is for [an initial assessment/an annual assessment/an annual assessment and significant change assessment/a significant change assessment] of the [CSP Name], [CSO Name]. The SAP provides the goals for the assessment and details how the assessment will be conducted.</p>
         </part>
         <!-- Section 2.2 -->
         <part ns="https://fedramp.gov/ns/oscal" name="laws-regulations" >
            <title>Applicable Laws, Regulations, Standards and Guidance</title>
            <prop ns="https://fedramp.gov/ns/oscal" name="sort-id" value="002"/>
            <p>The FedRAMP-applicable laws, regulations, standards and guidance is included in the [CSO Name] SSP section – System Security Plan Approvals. Additionally, in Appendix L of the SSP, the [CSP Name] has included laws, regulations, standards, and guidance that apply specifically to this system.</p>
         </part>
      </part>
      <!-- cut -->
   </terms-and-conditions>

{{</ highlight >}}

#### XPath Queries 
{{< highlight xml "linenos=table" >}}
    (SAP) IA Name:
        /assessment-plan/metadata/party[@uuid="uuid-of-ia"]/name 
    (SAP) Initial assessment, annual assessment, or significant change?
        /assessment-plan/metadata/prop[@ns="https://fedramp.gov/ns/oscal" and @name="assessment-type"]/@value
    (SAP) Are there no/one/many significant changes in SAP scope?
        /assessment-plan/metadata/prop[@ns="https://fedramp.gov/ns/oscal" and @name="significant-changes-scope"]/@value
    (SAP) CSP Name:
        /assessment-plan/metadata/party[@uuid="uuid-of-csp"]/name
    (SSP) CSO Name:
        /system-security-plan/system-characteristics/system-name

{{</ highlight >}}

---
## 4.2. Scope

This information should come entirely from the imported SSP. If the
OSCAL-based SSP exists and is accurate, the tool should query that file
for this information as follows:

#### XPath Queries 
{{< highlight xml "linenos=table" >}}
    Table 2-1
    (SSP) Unique Identifier:
        /*/system-characteristics/system-id[@identifier-type='https://fedramp.gov']
    (SSP) Information System Name:
        /*/system-characteristics/system-name
    (SSP) Information System Abbreviation:
        /*/system-characteristics/system-name-short

{{</ highlight >}}

If no OSCAL-based SSP exists, as described in *Section 3.5.2, If No
OSCAL-based SSP Exists (General)*, the resource with the no-oscal-ssp
type must designate the system\'s identifier, name, and abbreviation.

**NOTE:**

The system\'s authorization date, purpose, and description have not
historically been displayed in the SAP but must be present when the SAR
references this content.

### 4.2.1. Location of Components

The SAP reference location information in the SSP using its ID and must
explicitly cite each location within the scope of the assessment. While
all is valid OSCAL syntax, FedRAMP requires locations to be explicitly
cited, so that the assessor can add their own description of the
location. Also, the SSP will likely also contain locations that are not
data centers.

![Location of Components](/img/sap-figure-6.png)

#### Representation 
{{< highlight xml "linenos=table" >}}
<assessment-subject type="location">
    <description>
        <p>A description of the locations.</p>
    </description>
    <include-subject subject-uuid="uuid-of-location-in-SSP-metadata" type="token">
        <remarks>
            <p>Briefly describe the components at this location.</p>
        </remarks>
    </include-subject>
    <include-subject subject-uuid="uuid-of-location-in-SAP-metadata" type="token">
        <remarks>
            <p>Briefly describe the components at this location.</p>
        </remarks>
    </include-subject>
</assessment-subject>

{{</ highlight >}}

#### XPath Queries 
{{< highlight xml "linenos=table" >}}
    (SSP) List the Data Center UUIDs in the SSP (Primary and Alternate):
        /*/metadata/location[prop[@name='type'][@value='data-center']]/@uuid
    (SSP) List the Primary Data Center UUIDs in the SSP:
        /*/metadata/location[prop[@name='type'][@value='data-center'][@class='primary']]/@uuid
    NOTE: For just alternate data centers, replace 'primary' with 'alternate'.
    (SAP) Location UUID (First Location cited in SAP):
        /*/assessment-subject[@type='location']/include-subject[1]/@subject-uuid
    NOTE: Replace "[1]" with "[2]", "[3]", etc.
    (SSP) Data Center Site Name (Lookup in SSP, using ID cited in SAP):
        /*/metadata/location[@id='location-2']/prop[@name='title'] [@ns='https://fedramp.gov/ns/oscal']
    NOTE: Replace 'location-2' with the SSP location as cited in the SAP.
    (SSP or SAP) Address:
        /*/metadata/location[@uuid='uuid-value-from-SAP']/address/addr-line
    NOTE: Replace addr-line with city, state, and postal-code as needed. 
    There may be more than one addr-line.
    NOTE: Replace 'location-2' with the SSP location as cited in the SAP.

    (SSP) CSP's Description of Location (from SSP):
        /*/metadata/location[@uuid='uuid-value-for-location-2']/remarks
    (SAP) Assessor's Description of Components at the first location:
        /*/assessment-subject[@type='location']/include-subject[1]/remarks/node()
        
    NOTE: Replace "[1]" with "[2]", "[3]", etc.

{{</ highlight >}}

If no OSCAL-based SSP exists, or the location of components is not
accurately reflected in the SSP, this information may be added to the
SAP\'s metadata section using the same syntax as the SSP. The
include-subject citations are still required as described above;
however, the IDs point to the SAP\'s location data instead of the
SSP\'s.

The same queries work as presented above; however, the queries are used
in the SAP instead of the SSP.

---
### 4.2.2. IP Addresses Slated for Testing

The SAP references SSP content for this information. Each subnet should
be represented in the SSP as a component with type=\'subnet\'. If the
SSP does not enumerate subnets in this way, the SAP tool should allow
the assessor to add them to the SAP\'s local-definitions as components.

Beyond subnets, this section is an enumeration of the SSP\'s
inventory-item assemblies, which always contain the hostname and IP
address of the item. Other details, such as the software and version
information, may be found in the inventory item itself or the SSP
inventory item may be linked to an SSP component containing those
details, depending on whether the SSP is using the legacy (flat)
approach or the preferred component approach.

If the assessor needs to add missing component or inventory-item
entries, or if the assessor needs to correct this information, the SAP
tool must add this assessor-provided information to the SAP\'s
local-definitions.

See the [*Guide to OSCAL-based FedRAMP System Security Plans*](/guides/ssp/)
to learn more about legacy (flat-file) and component-based inventory
approaches. Use a combination of include-subject and exclude-subject
assemblies to specify the SSP IDs of all in-scope components and
inventory-items. Excluding items is typically used in association with
the rules of engagement.

If an inventory-item is linked to a component in the SSP, the component
is automatically within scope as this is often necessary to get the
software and version information. Tools should honor this relationship
and consider linked components to be implicitly in-scope even if the
component was not explicitly cited in the SAP.

![Location of Components](/img/sap-figure-7.png)

#### Representation 
{{< highlight xml "linenos=table" >}}
    <assessment-subject type="component">
        <description><p>A description of the included component.</p></description>
        <include-all />
        <exclude-subject subject-uuid="uuid-of-SSP-component-to-exclude" type="token" />
    </assessment-subject>

    <assessment-subject type="inventory-item">
        <description><p>Description of the included inventory.</p></description>
        <include-all />
        <exclude-subject subject-uuid="uuid-of-SSP-inventory-item-to-exclude" 
                        type="token" />
        <exclude-subject subject-uuid="uuid-of-SSP-inventory-item-to-exclude"  
                        type="token" />
    </assessment-subject>
    <!-- OR -->
    <assessment-subject type="inventory-item">
        <description><p>Description of the included inventory.</p></description>
        <include-subject subject-uuid="uuid-of-SSP-inventory-item-to-include"  
                        type="token" />
        <include-subject subject-uuid="uuid-of-SSP-inventory-item-to-include"  
                        type="token" />
        <include-subject subject-uuid="uuid-of-SSP-inventory-item-to-exclude"  
                        type="token" />
    </assessment-subject>

{{</ highlight >}}

#### XPath Queries   
{{< highlight xml "linenos=table" >}}
    (SAP) Should all inventory-items be included? (true/false):
        boolean(/*/assessment-subject[@type='inventory-item']/include-all)
    NOTE: This means all inventory-items in the SSP's system-implementation as well as all inventory-items in the SAP's local definitions
    (SAP) Get the first inventory-item UUID from the SAP:
        /*/assessment-subject[@type='inventory-item']/include-subject[1]/@subject-uuid
    (SSP) Get Host Name from inventory-item in the SSP:
        /*/system-implementation/system-inventory/inventory-item[@uuid='uuid-value-from-above']/prop[@name='fqdn']

{{</ highlight >}}


---
#### 4.2.2.1 If No OSCAL-based SSP Exists or Has Inaccurate Information (IP Addresses)

If no OSCAL-based SSP exists, or the inventory information is not
accurately reflected in the SSP, this information may be added to the
SAP\'s local-definition section as described below. The include-subject
citations are still required as described above; however, the UUIDs
point to the SAP\'s local definitions instead of the SSP.

#### Representation   
{{< highlight xml "linenos=table" >}}
    <local-definitions>
        <inventory-item uuid="uuid-value">
            <description>
                <p>A Windows laptop, not defined in the SSP inventory.</p>
            </description>
            <prop name="ipv4-address" value="10.1.1.99"/>
            <prop name="virtual" value="no"/>
            <prop name="public" value="no"/>
            <prop name="fqdn" value="dns.name"/>
            <prop name="mac-address" value="00:00:00:00:00:00"/>
            <prop name="software-name" value="Windows 10"/>
            <prop name="version" value="V 0.0.0"/>
            <prop name="asset-type" value="os"/>
            <!-- Use any needed prop allowed in an SSP inventory item  -->
        </inventory-item>
        
        <inventory-item uuid="uuid-value" asset-id="none">
            <description><p>A subnet not defined in the SSP inventory.</p></description>
            <prop name="ipv4-subnet">10.20.30.0/24</prop>
            <!-- Use any needed prop allowed in an SSP inventory item  -->
        </inventory-item>
    </local-definitions>

    <assessment-subject type="inventory-item">
        <description><p>Description of the included inventory.</p></description>
        <include-subject subject-uuid="uuid-of-SAP-inventory-item-to-include" 
                        type="token" />
        <exclude-subject subject-uuid="uuid-of-SAP-inventory-item-to-include" 
                        type="token" />
    </assessment-subject>

{{</ highlight >}}

#### XPath Queries
{{< highlight xml "linenos=table" >}}
    (SAP) Get the included ID the same way:
        /*/assessment-subject[@type='inventory-item']/include-subject[2]/@subject-uuid 
    (SAP) Get Subnet from inventory-item in the SAP:
        /*/local-definitions/inventory-item[@uuid='value-from-above']/prop[@name='ipv4-subnet']/@value

{{</ highlight >}}
  
---
### 4.2.3. SAP Web Applications Slated for Testing

The SSP inventory data should already indicate which assets have a web
interface, with the following FedRAMP extension:

{{< highlight xml "linenos=table" >}}
    <prop name="scan-type" ns="https://fedramp.gov/ns/oscal" value="web" />
{{</ highlight >}}

This typically appears in the inventory-item itself with the legacy
approach and appears in a component associated with the inventory-item
if the SSP is using the component-based approach. See the [*Guide to OSCAL-based System Security Plans (SSP)*](/guides/ssp/5-attachments/#system-inventory-approach) for details on the flat-file and component-based approaches.

FedRAMP expects the assessor to review and validate the list of
identified web applications, both initially in the SAP and as a result
of the discovery scans once the assessment begins. SAP tools should
facilitate this review and adjustment of inventory data as needed for
the assessor to properly identify all web applications for testing.

For every web interface to be tested, whether pre-identified in the SSP
inventory or identified by the assessor, there must be a task entry. If
the inventory-item already contains the login-url, the tool should
duplicate it here. If not, the tool should enable the assessor to add it
here. A SAP tool should also enable the assessor to add a login-id for
test users here. Both use FedRAMP extensions.

#### Representation
{{< highlight xml "linenos=table" >}}
    <local-definitions>
        <activity uuid="uuid-of-web-application-activity">
            <title>Web Application Test #1</title>
            <description><p>Describe this web application test.</p></description>
            <prop name="type" ns="https://fedramp.gov/ns/oscal" value="web-application"/>
        </activity>
    </local-definitions>
    <!-- cut: terms-and-conditions, reviewed-controls, assessment-subject -->
    <task uuid="task-uuid-value">
        <title>Web Application Tests</title>
        <task uuid="uuid-value">
            <title>Web Application Test #1</title>
            <prop name="type" ns="https://fedramp.gov/ns/oscal" value="web-application"/>
            <prop name="login-url" ns="https://fedramp.gov/ns/oscal"
                value="https://service.offering.com/login"/>
            <prop name="login-id" ns="https://fedramp.gov/ns/oscal" value="test-user"/>
            <associated-activity activity-uuid="uuid-of-web-application-activity">
                <subject type="inventory-item">
                    <include-subject subject-uuid="uuid-of-SSP-inventory-item" 
                                    type="inventory-item" />
                </subject>
            </associated-activity>
        </task>
    </task>

{{</ highlight >}}

#### XPath Queries
{{< highlight xml "linenos=table" >}}
    (SAP) Login URL:
        (/*//task[prop[@name='type'][@ns="https://fedramp.gov/ns/oscal"][@value='web-application']])[1]/prop[@name='login-url'][@ns="https://fedramp.gov/ns/oscal"]
    (SAP) Login ID:
        (/*//task[prop[@name='type'][@ns="https://fedramp.gov/ns/oscal"][@value='web-application']])[1]/prop[@name='login-id'][@ns="https://fedramp.gov/ns/oscal"]
    (SAP) Inventory-ID of host:
        (/*//task[prop[@name='type'][@ns="https://fedramp.gov/ns/oscal"][@value='web-application']])[2]/ associated-activity/subject[@type='inventory-item']/include-subject/@subject-uuid
    NOTE: Replace "[2]" with "[2]", "[3]", etc.
    REMEMBER: The inventory-item could be in the SSP's system-implementation or the SAP's local-definitions.

{{</ highlight >}}

---
### 4.2.2. SAP Databases Slated for Testing

The SSP inventory data should already indicate which assets are a database, with the following FedRAMP extension:

{{< highlight xml "linenos=table" >}}
<prop name="scan-type" ns="https://fedramp.gov/ns/oscal" value="database"/>
{{</ highlight >}}

This typically appears in the inventory-item itself with the legacy
(flat-file) approach and appears in a component associated with the
inventory-item if the SSP is using the component-based approach. See the
[*Guide to OSCAL-based System Security Plans (SSP)*](/guides/ssp/5-attachments/#component-based-approach) for details on the flat-file and component-based approaches.

FedRAMP expects the assessor to review and validate the list of
identified databases, both initially in the SAP and as a result of
discovery scans once the assessment begins. SAP tools should facilitate
this review and adjustment of inventory data as needed for the assessor
to properly identify all databases for testing.

#### XPath Queries
{{< highlight xml "linenos=table" >}}
    (SSP) Host name of first database in SSP(flat file approach):
        (/*/system-implementation/system-inventory/inventory-item/prop[@name='scan-type'][string()='database'])[1]/../prop[@name='fqdn']
    (SSP) Host name of the first database in SSP (component approach) [xPath 2.0+ only]:
        (let $key:=/*/system-implementation/component[prop [@name='scan-type'] [@ns='https://fedramp.gov/ns/oscal']='database']/@id return /*/system-implementation/system-inventory/inventory-item [implemented-component/@component-id=$key]/prop[@name='fqdn'])[1]

{{</ highlight >}}


#### 4.2.4.1. If No OSCAL-based SSP Exists or Has Inaccurate Information (Database)

If no OSCAL-based SSP exists, or an item is missing completely from the
SSP inventory, it should have already been added as described in
*Section 4.4.1, If No OSCAL-based SSP Exists or Has Inaccurate
Information (IP* Addresses).

If a pre-existing SSP inventory item fails to properly identify a
database, the tool should enable the assessor to add this designation
with an entry in the SAP local-definitions*,* except the value database
should be used instead of web for the scan-type.

### 4.2.5. Roles Testing Inclusions and Exclusion

Historically, FedRAMP assessors often identified generalized roles for
testing, such as \"internal\", \"external\", and \"privileged\" rather
than citing the specific roles enumerated in the SSP. This is in
response to a FedRAMP requirement to test roles from each perspective.
Assessors must ensure all roles are included for testing and identify
roles excluded from testing. When processing an OSCAL SAP, SAP tools
should present assessors with the roles from the associated (import-ssp)
SSP so the assessor can select specific roles for testing. SAP tools
should allow the assessor to easily identify roles that are excluded.
Section 6.2 of the [*Guide to OSCAL-based System Security Plans (SSP)*](/guides/ssp/6-security-controls/#responsible-roles-and-parameter-assignments) describes personnel roles and privileges with examples illustrating how
to identify them in an OSCAL SSP. If the \"roles\" slated for testing
exist in the SSP, the SSP roles are referenced from the SAP using their
SSP IDs as defined in the SSP user assemblies in the system-implementation section of the OSCAL-based SSP file. **Note that in this case, the SAP role must actually map to the uuid of the user assembly in the SSP**.

Assessors should ensure the selection of at least one SSP-defined role
from each of the common generalized role categories ("internal",
"external", and "privileged"). If the assessor elects to reference more
generic roles, the SAP tool should enable the assessor to create these
generic roles locally in the SAP local-definitions assembly.

![Role Testing Exclusions](/img/sap-figure-8.png)

#### Representation
{{< highlight xml "linenos=table" >}}
<local-definitions>
    <!-- add user assembly for each role to be assessed -->
    <user uuid=”uuid-value”>
        <title>Assessor Specified Role</title>
        <prop name=”sensitivity” ns=”https://fedramp.gov/ns/oscal” value=”limited” />
        <prop name=”type” value=”external”/>
        <prop name=”privilege-level” value=”no-logical-access” />
        <role-id>id-for-assessor-specified-role</role-id>
        <authorized-privilege>
            <title>Full administrative access (root)</title>
            <function-performed>Add/remove users and hardware</function-performed>
            <function-performed>install and configure software</function-performed>
            <function-performed>OS updates, patches and hotfixes</function-performed>
            <function-performed>perform backups</function-performed>
        </authorized-privilege>
    </user>
</local-definitions> 

{{</ highlight >}}

For every role to be tested, whether pre-identified in the SSP or
identified by the assessor, there must be an assessment-subject entry,
and at least one corresponding task. A SAP tool should enable the
assessor to add a test user ID here via FedRAMP extension properties.

#### Representation
{{< highlight xml "linenos=table" >}}
<assessment-plan>  
    <!-- cut metadata -->
    <!-- cut import-ssp, local-definitions, terms-and-conditions, reviewed-controls -->
    <!-- set type to 'user' -->
    <assessment-subject type="user">
        <description>
            <p>A description of the included roles.</p>
            <p>A description of an excluded role.</p>
        </description>
        <!-- uuid from SSP or SAP lcocal-definitions -->
        <include-subject subject-uuid="user-uuid-from-SSP" type="token" />
        <exclude-subject subject-uuid="user-uuid-from-SSP" type="token" />
    </assessment-subject>            
    <!-- cut assessment-assets -->
    <task uuid="task-uuid" type="action">
        <title>Role-Based Tests</title>
        <task uuid="test1-uuid" type="action">
            <title>Role Based Test #1</title>
            <prop name="test-type" 
                                           ns="https://fedramp.gov/ns/oscal" value="role-based"/>
            <prop name="login-id" ns="https://fedramp.gov/ns/oscal" value="test-user"/>
            <!-- uuid from SSP or SAP lcocal-definitions -->
            <prop name="user-uuid" 
                                           ns="https://fedramp.gov/ns/oscal"
                   value="user-uuid-value"/>
            <associated-activity activity-uuid="uuid-of-role-testing-activity" />
        </task>
        <task uuid="test2-uuid" type="action">
            <title>Role Based Test #2</title>
            <prop name="test-type" ns="https://fedramp.gov/ns/oscal" 
                  value="role-based"/>
            <prop name="login-id" ns="https://fedramp.gov/ns/oscal" value="test-admin"/>
            <!-- uuid from SSP or SAP lcocal-definitions -->
            <prop name="user-uuid" ns="https://fedramp.gov/ns/oscal"
                   value="user-uuid-value"/>
            <associated-activity activity-uuid="uuid-of-role-testing-activity" />
        </task>
    </task>
    <!-- cut back-matter -->
</assessment-plan>

{{</ highlight >}}

---
## 4.3. SAP Assumptions

SAP Assumptions use syntax similar to OSCAL control catalog statements.
They have a sort-id, which a tool can use to ensure the intended
sequence is maintained.

The insert elements can be used by tool developers as insertion points
for data items that the tool may manage as parameters. The use of insert
within an OSCAL part is described on the [NIST OSCAL Concepts page](https://pages.nist.gov/OSCAL/resources/concepts/layer/control/catalog/sp800-53rev5-example/#parts).

![Role Testing Exclusions](/img/sap-figure-9.png)

#### Representation
{{< highlight xml "linenos=table" >}}
    <terms-and-conditions>
        <part name="assumptions">
            <part name="assumption">
                <prop name="sort-id" value="001"/>
                <p>This SAP is based on <insert type="param" id-ref="cso_name_prm"/>...</p>
            </part>
            <part name="assumption">
                <prop name="sort-id" value="002"/>
                <p>The <insert type="param" id-ref="csp_name_prm"/> ... </p>
            </part>
            <part name="assumption">
                <prop name="sort-id" value="003"/>
                <p>The <insert type="param" id-ref="ia_name_prm"/> ... </p>
            </part>
            <part name="assumption">
                <prop name="sort-id" value="004"/>
                <p>The <insert type="param" id-ref="csp_name_prm"/>... </p>
            </part>
            <part name="assumption">
                <prop name="sort-id" value="005"/>
                <p>Security controls that ... on these security controls.</p>
            </part>
        </part>
    </terms-and-conditions> 

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Obtain Sort IDs, for sorting by the SAP tool:
    /*/terms-and-conditions/part[@name='assumptions']/ part[@name='assumption']/prop[@name='sort-id']
(SAP) The first assumption statement:
    /*/terms-and-conditions/part[@name='assumptions']/ part[@name='assumption']/prop[@name='sort-id'] [.='001']/../(* except prop)
NOTE: Replace '001' with '002', '003', etc. for each sort-id based on desired order.

{{</ highlight >}}

**NOTES:**

-   If the tool is using XPath 1.0 or 2.0, the tool must sort the
    results of the sort-id list, and then obtain the assumptions in the
    intended sequence. XPath 3.0 has a sort function, which can perform
    the sort for the tool.

-   OSCAL does not support the insertion of values within Markup
    Multiline at this time. The tool must either replace each \"\[CSP
    Name\]\" and \"\[3PAO Name\]\" with the appropriate value or enable
    the assessor to manually make those changes. This feature may be
    added to future version of OSCAL.

---
## 4.4. SAP Methodology

In general, the methodology is simply a single markup multiline field, which enables the assessor to modify the content using rich text formatting. The FedRAMP SAP template includes subsections for *Control Testing, Data Gathering, Sampling,* and *Penetration Test*. Each of these sections must be present in the FedRAMP OSCAL SAP terms-and-condition assembly, within part named "methodology" as sub-parts. The subparts are specifically defined for FedRAMP SAP, so they have namespace "https://fedramp.gov/ns/oscal" and attributes are named "control-testing", "data-gathering", "sampling", and "pen-testing".

![SAP Methodology](/img/sap-figure-10.png)

#### Representation
{{< highlight xml "linenos=table" >}}
<terms-and-conditions>
      <!-- Section 5 -->
      <part name="methodology">
         <title>Methodology</title>
         <!-- Section 5.1 Control Testing -->
         <part ns="https://fedramp.gov/ns/oscal" name="control-testing">
            <title>Control Testing</title>
            <prop ns="https://fedramp.gov/ns/oscal" name="sort-id" value="001"/>
            <p>[IA Name] will ... </p>
         </part>
         <!-- Section 5.2 Data Gathering -->
         <part ns="https://fedramp.gov/ns/oscal" name="data-gathering">
            <title>Data Gathering</title>
            <prop ns="https://fedramp.gov/ns/oscal" name="sort-id" value="002"/>
            <p>[IA Name] data gathering activities will ... </p>
         </part>
         <!-- Section 5.3 Sampling -->
         <part ns="https://fedramp.gov/ns/oscal" name="sampling">  
            <title>Sampling</title>
            <prop ns="https://fedramp.gov/ns/oscal" name="sort-id" value="003"/>
            <prop ns="https://fedramp.gov/ns/oscal" name="sampling" value="no"/>
            <p>The sampling methodology for evidence/artifact gathering, related to controls assessment, is described in Appendix B.</p>
            <p>[IA Name] [will/will not] ... </p>
          </part>
         <!-- Section 5.4 Penetration Test -->
         <part ns="https://fedramp.gov/ns/oscal" name="pen-testing">
            <prop ns="https://fedramp.gov/ns/oscal" name="sort-id" value="004"/>
            <p>The Penetration Test Plan and Methodology is attached in Appendix C.</p>
         </part>
      </part>      
     <!-- cut -->
</terms-and-conditions>

{{</ highlight >}}

FedRAMP requires the presence of the sampling property, which indicates whether sampling will be used by the
assessor for the assessment. The insert elements can be used by tool developers for insertion points for data items that the tool may manage as parameters. CSP tools must display a definitive statement based on the value of the sampling property.

![Sampling](/img/sap-figure-11.png)

#### Representation
{{< highlight xml "linenos=table" >}}
<terms-and-conditions>
      <!-- Section 5 -->
      <part name="methodology">
         <title>Methodology</title>

         <!-- Section 5.3 Sampling -->
         <part ns="https://fedramp.gov/ns/oscal" name="sampling">  
            <title>Sampling</title>
            <prop ns="https://fedramp.gov/ns/oscal" name="sort-id" value="003"/>
            <prop ns="https://fedramp.gov/ns/oscal" name="sampling" value="no"/>
            <p>The sampling methodology for evidence/artifact gathering, related to controls assessment, is described in Appendix B.</p>
            <p>[IA Name] [will/will not] ... </p>
          </part>

      </part>      
     <!-- cut -->
</terms-and-conditions>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Will the assessor use sampling?:
    /*/terms-and-conditions/part[@name='methodology']/prop[@name='sampling']/@value
(SAP) Methodology Description:
    /*/terms-and-conditions/part[@name='methodology']/(* except prop)

{{</ highlight >}}

**NOTES:**

-   The SAP tool should provide the assessor with an automated way to
    replace \[CSP Name\] and \[3PAO Name\] with the actual names of
    those parties.

-   The SAP tool should allow the assessor to modify this content as
    needed.

## 4.5. Control Testing

An OSCAL SAP must always explicitly select the in-scope controls from
the applicable FedRAMP Baseline/Profile. For initial assessments, this
can be as simple as specifying include-all. For annual assessments, use
include-control instead - one for each control included in the
assessment. Controls may also be explicitly excluded from the control
scope.

![Control Testing](/img/sap-figure-12.png)

#### Representation   
{{< highlight xml "linenos=table" >}}
<!-- metadata -->
<reviewed-controls>
    <control-selection>
        <description>
            <p>Include all controls in the baseline.</p>
            <p>Then exclude any specific controls if necessary.</p>
            <p>Provide rationale/justification for control exclusion here.</p>
        </description>
        <include-all />
        <exclude-control control-id="ac-1" />
        <!-- OR -->
        <include-control control-id="ac-2" />
        <include-control control-id="ac-3" />
        <!-- repeat as needed for each control --> 
    </control-selection>
    <!-- control-objectives -->
    <!-- objectives -->
    <control-objective-selection><!-- cut --></control-objective-selection>
</reviewed-controls>
<!-- assessment-subject -->    

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Include All Controls? (true or false):
    boolean(/*/objectives/controls/include-all)
(SAP) Exclude Controls Specified? (true or false):
    boolean(/*/objectives/controls/exclude-control)
(SAP) Exclude Controls Total (integer):
    count(/*/objectives/controls/exclude-control)
(SAP) Exclude Specific Control (string):
    /*/objectives/controls/exclude-control[1]/@control-id
NOTE: Replace "exclude-control" with "include-control" above for any explicitly included controls; however, this is redundant when used with 'all'.

{{</ highlight >}}

**NOTES:**

-   Tools should validate the control IDs for explicitly included or
    excluded controls using the relevant baseline.

-   FedRAMP\'s guidance and requirements regarding which controls are
    in-scope for each assessment does not change with OSCAL.

---
## 4.6. SAP Test Plan

### 4.6.1. Assessor\'s Name, Address, and URL

The SAP\'s metadata is used to represent
the assessor\'s name address and URL. This uses the OSCAL common role,
party, and responsible-party assemblies. Some roles are specific to the
SAP. In the responsible-party assembly, the party-uuid may point to a
party in the SSP or SAP. The SAP tool must not assign a role ID or party
ID that duplicates one used in the SSP.

![Test Plan](/img/sap-figure-13.png)

#### Representation 
{{< highlight xml "linenos=table" >}}
<metadata>
    <!-- cut: title, published, last-modified, version, oscal-version, prop -->
    <role id="assessor">
        <title>Assessment Organization</title>
        <desc>The organization performing the assessment.</desc>
    </role>
    <location uuid="uuid-value">
        <address type="work">
            <addr-line>Suite 0000</addr-line>
            <addr-line>1234 Some Street</addr-line>
            <city>Haven</city>
            <state>ME</state>
            <postal-code>00000</postal-code>
            <country>US</country>
        </address>
    </location>
    <party uuid="uuid-value"  type="organization">
        <name>Assessment Organization Name</name>
        <short-name>Acronym/Short Name</short-name>
        <location-uuid>sap-location-1</location-uuid>
        <url>https://assesor.web.site</url>
        <prop name="iso-iec-17020-identifier" 
            ns='https://fedramp.gov/ns/oscal'>0000.00</prop>
    </party>
    <responsible-party role-id="assessor">
        <party-uuid>uuid-of-assessor</party-uuid>
    </responsible-party>
</metadata>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Assessor's Name:
    /*/metadata/party[@id=(/*/metadata/responsible-party[@role-id='assessor']/party-uuid)] /org/org-name
(SAP) Assessor's Street Address (replace addr-line with city, state, etc.):
    /*/metadata/location[@id=/*/metadata/party[@id=(/*/metadata/responsible-party[@role-id='assessor']/party-uuid)]/org/location-id]/address/addr-line
(SAP) Assessor's Web Site:
    /*/metadata/party[@id=(/*/metadata/responsible-party[@role-id='assessor']/party-uuid)] /org/url
(SAP) 3PAO's A2LA Certification Number:
    /*/metadata/party[@id=(/*/metadata/responsible-party[@role-id='assessor']/party-uuid)] /org/prop[@name='iso-iec-17020-identifier'][@ns='https://fedramp.gov/ns/oscal']

{{</ highlight >}}

---
### 4.6.2. Security Assessment Team

The SAP\'s metadata is used to represent the assessment team and
assessment lead. This uses the OSCAL common role, party, and
responsible-party assemblies. Some roles are specific to the SAP. The
SAP tool must not assign a role ID or party ID that duplicates one used
in the SSP.

![Test Plan](/img/sap-figure-14.png)

#### Representation 
{{< highlight xml "linenos=table" >}}
<metadata>
    <!-- cut: title, published, last-modified, version, oscal-version, prop -->
    <role id="assessment-team">
        <title>Assessment Team</title>
        <desc>The individual or individuals performing the assessment.</desc>
    </role>
    <party id="sap-person-2"  type="person">
        <person-name>[SAMPLE]Person Name 2</person-name>
        <org-id>assessment-org</org-id>
        <location-id>sap-location-1</location-id>
        <email>name@org.domain</email>
        <phone>202-000-0000</phone>
    </party>
    <!-- Repeat party for each person 3 - 5 -->
    <responsible-party role-id="assessment-team">
        <party-uuid>sap-person-2</party-uuid>
        <party-uuid>sap-person-3</party-uuid>
        <party-uuid>sap-person-4</party-uuid>
        <party-uuid>sap-person-5</party-uuid>
    </responsible-party>
</metadata>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Number of Assessment Team Members (integer):
    count(/*/metadata/responsible-party[@role-id='assessment-team']/party-uuid)
(SAP) Name of First Assessment Team Member:
    /*/metadata/party[@id=/*/metadata/responsible-party[@role-id='assessment-team'] /party-uuid[1]]/person/person-name
(SAP) Role of First Assessment Team Member:
    /*/metadata/role[@id='assessment-team']/title
(SAP) Contact Information of First Assessment Team Member (phone):
    /*/metadata/party[@id=/*/metadata/responsible-party[@role-id='assessment-team'] /party-uuid[1]]/person/phone
NOTE: Replace 'phone' with 'email'
NOTE: Replace [1] as needed with [2], [3], etc.

{{</ highlight >}}

---
### 4.6.3. CSP Testing Points of Contact

The SAP\'s metadata is used to represent the CSP\'s points of contact.
This uses the OSCAL common role, party, and responsible-party
assemblies. In the responsible-party assembly, the party-uuid may point
to a party in the SSP or SAP. The SAP tool must not assign a role ID or
party ID that duplicates one used in the SSP. If an individual is
already identified via a party assembly in the SSP, that individual\'s
information should not be duplicated in the SAP. Instead, the SAP should
reference the SSP party ID for that individual.

![Test Plan](/img/sap-figure-15.png)

#### Representation 
{{< highlight xml "linenos=table" >}}
<metadata>
    <role id="csp-assessment-poc">
        <title>CSP POCs During Testing</title>
        <desc>At least three CSP POCs must be identified in a FedRAMP SAP.</desc>
    </role>
    
    <!-- Only define a CSP party in the SAP when no appropriate party exits in SSP -->
    
    <responsible-party role-id="csp-assessment-poc">
        <!-- At least three -->
        <party-uuid>person-1</party-uuid>
        <party-uuid>person-2</party-uuid>
        <party-uuid>soc</party-uuid>
    </responsible-party>
</metadata>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Number of CSP Assessment POCs (integer):
    count(/*/metadata/responsible-party[@role-id='csp-assessment-poc']/party-uuid)
(SAP) ID of the first CSP Assessment POC:
    /*/metadata/responsible-party[@role-id='csp-assessment-poc']/party-uuid[1]
NOTE: Replace [1] as needed with [2], [3], etc.
(SAP) Role:
    /*/metadata/role[@id='csp-assessment-poc']/title
(SSP) Name of the first person or organization:
    /*/metadata/party[@id='person-1']/(./person/person-name | ./org/org-name)
(SSP) Phone for the first person or organization:
    /*/metadata/party[@id='person-1']//phone
(SSP) Email for the first person or organization:
    /*/metadata/party[@id='person-1']//email
NOTE: Replace 'person-1' with each party-uuid found in the responsible role.

{{</ highlight >}}

**NOTES:**
-   IDs used for roles or parties in the SAP must not duplicate IDs used
    for roles or parties in the SSP.

-   Only define a CSP party in the SAP when no appropriate party exists
    in the SSP.

---
### 4.6.4. Testing Performed Using Automated Tools

Automated tools are enumerated in the assets section of the SAP using
the tools assembly. Each tool is listed using the same component syntax
available in the SSP.

![Test Plan](/img/sap-figure-16.png)

#### Representation 
{{< highlight xml "linenos=table" >}}
<assessment-assets >
    <component uuid="assessor-component1-uuid" type="software">
        <title>XYZ Vulnerability Scanning Tool</title>
        <description>
            <p>Describe the purpose of the tool here.</p>
        </description>
        <prop name="vendor" value="Vendor Name"/>
        <prop name="name" value="Tool Name"/>
        <prop name="version" value="1.2.3"/>
        <status state="operational"/>
    </component>
    
    <component uuid="assessor-componenet2-uuid" type="software">
        <title>XYZ Database Scanning Tool</title>
        <description>
            <p>Describe the purpose of the tool here.</p>
        </description>
        <prop name="vendor" value="Vendor Name"/>
        <prop name="name" value="Tool Name"/>
        <prop name="version" value="1.2.3"/>
        <status state="operational"/>
        <remarks><p><!-- cut --></p></remarks>
    </component>
</assessment-assets >
<!-- assessment-activities  -->

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Number of Tools (integer):
    count(/*/assessment-assets/component)
(SAP) Name of first tool:
    /*/assessment-assets/component[1]/prop[@name='name']/@value
(SAP) Vendor/Organization Name of first tool:
    /*/assessment-assets/component[1]/prop[@name='vendor']/@value
(SAP) Version of first tool:
    /*/assessment-assets/component[1]/prop[@name='version']/@value
(SAP) Purpose of first tool:
    /*/assessment-assets/component[1]/description/node()
NOTE: Replace [1] as needed with [2], [3], etc.

{{</ highlight >}}

**NOTES:**

-   OSCAL syntax requires a status field within each component assembly.
    For FedRAMP, assessment tools state should typically be
    \'operational\', otherwise a remark must be provided.

---
### 4.6.5. Testing Performed Through Manual Methods

In OSCAL, the manual assessment methods are described in the activity
assembly as shown below:

![Test Plan](/img/sap-figure-17.png)

#### Representation 
{{< highlight xml "linenos=table" >}}
<local-definitions>
    <activity uuid="2715174e-9355-4775-bea4-4068e59e916b">
        <title>Title of the Manual Test</title>
        <description>
            <p>Description of the manual test</p>
        </description>
        <prop name="type" value="manual"/>
        <prop name="label" value="Test ID"/>
        <step uuid="fb039fd7-5a2b-4c0f-867c-88cce9c3778c ">
            <description><p>Describe test step #1</p></description>
            <prop name="sort-id" value="001"/>
        </step>
        <step uuid="fb039fd7-5a2b-4c0f-867c-88cce9c3778c ">
            <description><p>Describe test step #2</p></description>
            <prop name="sort-id" value="002"/>
        </step>
        <step uuid="fb039fd7-5a2b-4c0f-867c-88cce9c3778c ">
            <description><p>Describe test step #3</p></description>
            <prop name="sort-id">003</prop>
        </step>
    </activity>
    <activity uuid="3ba68918-80ef-4846-89e0-9f1def7e5223">
        <title>[SAMPLE]Forceful Browsing</title>
        <description>
            <p>We will login as a customer ...cut... browser to various URLs</p>
        </description>
        <prop name="type" value="manual"/>
        <prop name="label" value="Test ID"/>
    </activity>
</local-definitions>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Number of manual test methods (integer):
    count(/*/local-definitions/activity[prop[@name='type'][@value='manual']])
(SAP) Test ID of first manual test method:
    (/*/local-definitions/activity[prop[@name='type'][@value='manual']]) [1]/prop[@name='label']
(SAP) Test Name of first manual test method:
    (/*/local-definitions/activity[prop[@name='type'][@value='manual']]) [1]/title
(SAP) Description of first manual test method:
    (/*/local-definitions/activity[prop[@name='type'][@value='manual']]) [1]/description/node()
NOTE: Replace [1] as needed with [2], [3], etc.

{{</ highlight >}}

**NOTES:**

-   If a test method represents more than one test type, such as manual
    test that is also a role-based test, the test-type property should
    appear twice, indicating each type.
 
---
#### Including Manual Test Methods in the OSCAL SAP Test Plan Section

The FedRAMP OSCAL SAP terms-and-condition assembly, should contain a
part with ns=\"https://fedramp.gov/ns/oscal\" name=\"manual-methods-testing\" when needed to facilitate rending of
OSCAL SAP by tools. The insert elements can be used by tool developers
as insertion points for data items such as test ID, test name, and test
description if the tool is able manage them as parameters. The use of
insert within an OSCAL part is described on the [NIST OSCAL Concepts page](https://pages.nist.gov/OSCAL/concepts/layer/control/catalog/sp800-53rev5-example/#parts). The XPath queries below show how to identify manual test information within the OSCAL SAP.

#### Representation 
{{< highlight xml "linenos=table" >}}
<terms-and-conditions>
      <!-- Section 6 Test Plan -->
      <part ns="https://fedramp.gov/ns/oscal" name="test-plan">
         <title>Test Plan</title>
         <!-- Section 6.4 Testing performed using manual methods -->
         <part ns="https://fedramp.gov/ns/oscal" name="manual-methods-testing">
            <title>Testing Performed Using Manual Methods</title>
            <prop ns="https://fedramp.gov/ns/oscal" name="sort-id" value="004"/>
            <!-- Table 6-4 Describe what technical tests will be performed through manual methods without the use of automated tools. -->
            <table>
               <tr>
                  <th>Test ID</th>
                  <th>Test Name</th>
                  <th>Description</th>
               </tr>
               <tr>
                  <!-- Identifiers must be in the format MT-1, MT-2, etc., which indicates "Manual Test 1", "Manual Test 2", etc. -->
                  <td>[Insert test ID]</td>
                  <td>[Insert test name]</td>
                  <td>[Insert test description text]</td>
               </tr>
            </table>
         </part>
      </part>      
     <!-- cut -->
</terms-and-conditions>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Test ID:
    /assessment-plan/local-definitions[1]/activity[1]/prop[@ns="https://fedramp.gov/ns/oscal" and @name="label"]/@value
(SAP) Test Name:
    /assessment-plan/local-definitions[1]/activity[1]/title
(SAP) Description:
    /assessment-plan/local-definitions[1]/activity[1]/description/p
NOTE: Replace [1] as needed with [2], [3], etc.

{{</ highlight >}}

---
### 4.6.6. Schedule

In OSCAL, the assessment schedule is described using an array of task
assemblies as shown below:

![Test Plan](/img/sap-figure-18.png)

#### Representation 
{{< highlight xml "linenos=table" >}}
<task uuid="17030aaf-7712-4228-8607-a5a97a785efa" type="action">
    <title>Prepare Test Plan</title>
    <description>
        <p>optional description here</p>
    </description>
    <timing>
        <within-date-range start="2020-06-01T00:00:00Z" end="2020-06-15T00:00:00Z"/>
    </timing>
</task>
<task uuid="b65e7779-bd3d-4a49-9de5-3122c290792f" type="action">
    <title>Meeting to Review Test Plan</title>
    <description>
        <p>optional description here</p>
    </description>
    <timing>
        <within-date-range start="2020-06-01T00:00:00Z" end="2020-06-15T00:00:00Z"/>
    </timing>
</task>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Number of tasks in schedule (integer):
    count(/*/task)
(SAP) Name of first task:
    /*/task[1]/title
(SAP) Start date of first task:
    /*/task[1]/timing/within-date-range/@start
(SAP) Finish date of first task:
    /*/task[1]/timing/within-date-range/@end
(SAP) Optional Description of first task:
    /*/task[1]/description/node()
NOTE: Replace [1] as needed with [2], [3], etc.

{{</ highlight >}}

**NOTES:**

-   In the OSCAL file, the start and end fields must use the OSCAL data
    type
    [dateTime-with-timezone](https://pages.nist.gov/OSCAL/reference/datatypes/#date-with-timezone).

-   The time may be entered as all zeros.

-   For FedRAMP, a SAP tool should display only the date and ignore the
    time. The date should be presented to the user in a more
    user-friendly format.

---
## 4.7. SAP Rules of Engagement (ROE)

### 4.7.1. Origination Addresses

The scan origination IP address(es) are included in the
assessment-platform assembly. See the next page for other disclosures.

#### Representation 
{{< highlight xml "linenos=table" >}}
<assessment-assets>
    <component type="hardware" uuid="BA991C3F-1E00-4C38-BF81-86A9E503F3B9">
        <title>Assessment Laptop</title>
    </component>
    <component uuid="040937c3-2e0e-407a-bb3c-d4e61ac1c460" type="software">
        <title>XYZ Vulnerability Scanning Tool</title>
    </component>
    <component uuid="c50104b9-69b3-4383-a1f1-d8a6f6f806f7" type="software">
        <title>XYZ Database Scanning Tool</title>
    </component>
    <assessment-platform uuid="60218FE9-B01A-4553-B705-DBE9DEC44AA1">
        <title>Scanning Tools</title>
        <prop name="ipv4-address" value="10.10.10.10"/>
        <prop name="ipv4-address" value="10.10.10.11"/>
        <prop name="ipv4-address" value="10.10.10.12"/>
        <uses-component component-uuid="BA991C3F-1E00-4C38-BF81-86A9E503F3B9" >
            <remarks><p>Cites assessment laptop.</p></remarks>
        </uses-component>
        <uses-component component-uuid="BA991C3F-1E00-4C38-BF81-86A9E503F3B9">
            <remarks><p>Cites assessment laptop.</p></remarks>
        </uses-component>
        <uses-component component-uuid="040937c3-2e0e-407a-bb3c-d4e61ac1c460">
            <remarks><p>Cites Vulnerability Scanning Tool</p></remarks>
        </uses-component>
        <uses-component component-uuid="c50104b9-69b3-4383-a1f1-d8a6f6f806f7">
            <remarks><p>Cites Database Scanning Tool</p></remarks>
        </uses-component>
    </assessment-platform>
</assessment-assets>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Count scan origination addresses (integer):
    count(/*/assessment-assets/assessment-platform/prop[@name='ipv4-address'])
(SAP) First scan origination address:
    /*/assessment-assets/assessment-platform/prop[@name='ipv4-address'][1]
NOTE: Replace [1] as needed with [2], [3], etc.

{{</ highlight >}}

**NOTES:**

-   A SAP tool should present the scan origination addresses using the
    statement:\
    \"All scans will originate from the following IP address(es):\",
    followed by the list of addresses.

---
### 4.7.2. Disclosures

The scan origination IP address(es) are included in the
assessment-platform assembly. See the next page for other disclosures\`.

![Test Plan](/img/sap-figure-19.png)

#### Representation 
{{< highlight xml "linenos=table" >}}
<terms-and-conditions>
    <part name="disclosures">
        <part name="disclosure">
            <prop name="sort-id" value="001"/>
            <p>Any testing will be performed according to terms and conditions designed                                               to minimize risk exposure that could occur during security testing.</p>
        </part>
        <part name="disclosure">
            <prop name="sort-id" value="002"/>
            <p>A disclosure statement</p>
        </part>
    </part>
</terms-and-conditions>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Count other disclosure statements (integer):
    count(/*/terms-and-conditions/part[@name='disclosures']/part[@name='disclosure'])
(SAP) Obtain Sort IDs, for sorting by the SAP tool:
    /*/terms-and-conditions/part[@name='disclosures']/part[@name='disclosure']/prop[@name='sort-id']
(SAP) The first assumption statement:
    /*/terms-and-conditions/part[@name='disclosures']/part[@name='disclosure']/prop[@name='sort-id'] [string()='001']/../(* except prop)
NOTE: Replace '001' with '002', '003', etc. for each sort-id based on desired order.

{{</ highlight >}}

**NOTES:**

-   A SAP tool should present the scan origination addresses using the
    statement:\
    \"All scans will originate from the following IP address(es):\",
    followed by the list of addresses.

---
### 4.7.3. Security Testing May Include 

SAP authors should describe the security testing that may be included
within the terms-and-conditions assembly, in the "included-activities"
part and its "included-activity" sub-parts.

![Test Plan](/img/sap-figure-20.png)

#### Representation 
{{< highlight xml "linenos=table" >}}
<terms-and-conditions>
    <part name="included-activities">
        <title>Included Activities</title>
        <p>The following activities are to be included as part of the FedRAMP assessment.</p>
        <part name="included-activity">
            
        </part>
        <part name="included-activity">
            <p>Port scans and other network service interaction and queries</p>
        </part>
        <part name="included-activity">
            <p>Network sniffing, traffic monitoring, traffic analysis, and host discovery</p>
        </part>
        <part name="included-activity">
            <p>Attempted logins or other use of systems, with any account name/password</p>
        </part>
        <part name="included-activity">
            <p>Attempted structured query language (SQL) injection and other forms of input
                parameter testing</p>
        </part>
        <!-- cut other included-activities -->
    </part>
</terms-and-conditions>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Number of Included Activities:
    count(/*/terms-and-conditions/part[@name='included-activities']/part[@name='included-activity'])
(SAP) First Included Activity:
    /*/terms-and-conditions/part[@name='included-activities']/part[@name='included-activity'][1]/node()
NOTE: Replace [1] as needed with [2], [3], etc.

{{</ highlight >}}

**NOTES:**

-   An assessment tool should present a list of included activities with
    a preceding phrase such as, \"Security testing may include the
    following activities:\"

---
### 4.7.4. Security Testing Will Not Include

SAP authors should describe exclusive disclosures within the
terms-and-conditions assembly, in the "excluded-activities" part and its
"included-activity" sub-parts.

![Test Plan](/img/sap-figure-21.png)

#### Representation 
{{< highlight xml "linenos=table" >}}
<terms-and-conditions>
    <part name="excluded-activities">
        <title>Excluded Activities</title>
        <p>The following activities are explicitly excluded from the assessment.</p>
        <part name="excluded-activity">
            <p>Changes to assigned user passwords</p>
        </part>
        <part name="excluded-activity">
            <p>Modification of user files or system files</p>
        </part>
        <part name="excluded-activity">
            <p>Telephone modem probes and scans (active and passive)</p>
        </part>
        <part name="excluded-activity">
            <p>Intentional viewing of [CSP Name] staff email, Internet caches, and/or personnel
                cookie files</p>
        </part>
        <part name="excluded-activity">
            <p>Denial of service attacks</p>
        </part>
        <part name="excluded-activity">
            <p>Exploits that will introduce new weaknesses to the system</p>
        </part>
        <part name="excluded-activity">
            <p>Intentional introduction of malicious code (viruses, Trojans, worms, etc.)</p>
        </part>
    </part>
    </terms-and-conditions>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Number of Excluded Activities:
    count(/*/terms-and-conditions/part[@name='excluded-activities']/part[@name='excluded-activity'])
(SAP) First Excluded Activity:
    /*/terms-and-conditions/part[@name='excluded-activities']/part[@name='excluded-activity'][1]/node()
NOTE: Replace [1] as needed with [2], [3], etc.

{{</ highlight >}}

**NOTES:**

-   An assessment tool should present a list of included activities with
    a preceding phrase such as, \"Security testing will not include any
    of the following activities:\"

---
### 4.7.5. End of Testing

This indicates who the Independent Assessor (IA) should notify within
the CSP\'s organization when testing is complete.

![Test Plan](/img/sap-figure-22.png)

#### Representation 
{{< highlight xml "linenos=table" >}}
<metadata>
    <role id="csp-end-of-testing-poc">
        <title>CSP's End of Testing Notification POC</title>
        <desc>A role for an individual within the CSP to be notified by the assessor when testing is complete.</desc>
    </role>
    
    <!-- Only define CSP party in SAP when no appropriate party exits in SSP -->
    
    <responsible-party role-id="csp-end-of-testing-poc">
        <!-- At Least one -->
        <party-uuid>person-2</party-uuid>
    </responsible-party>
</metadata>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Number of CSP Parties to notify at EOT (integer):
    count(/*/metadata/responsible-party[@role-id='csp-end-of-testing-poc']/party-uuid)
(SAP) ID of the first CSP Party to Notify:
    /*/metadata/responsible-party[@role-id='csp-end-of-testing-poc']/party-uuid[1]
NOTE: Replace [1] as needed with [2], [3], etc.
(SSP) Name of the first person or team:
    /*/metadata/party[@id='person-2']/(./person/person-name | ./org/org-name)
(SSP) Phone for the first person or team:
    /*/metadata/party[@id='person-2']//phone
(SSP) Email for the first person or team:
    /*/metadata/party[@id='person-2']//email
NOTE: Replace 'person-2' with each party-uuid found in the responsible role.

{{</ highlight >}}

**NOTES:**

-   IDs used for roles or parties in the SAP must not duplicate IDs used
    for roles or parties in the SSP.

-   Only define a CSP party in the SAP when no appropriate party exists
    in the SSP.  

---
### 4.7.6. Communication of Test Results

This indicates who the Independent Assessor (IA) should send all the
assessment results to at the CSP\'s organization.

#### Representation 
{{< highlight xml "linenos=table" >}}
<metadata>
    <role id="csp-results-poc">
        <title>CSP Results POCs</title>
        <desc>A role for the individuals within the CSP who are to receive the assessment results.</desc>
    </role>
    
    <!-- Only define CSP party in the SAP when no appropriate party exits in SSP -->
    
    <responsible-party role-id="csp-results-poc">
        <!-- One or More -->
        <party-uuid>person-1</party-uuid>
        <party-uuid>person-2</party-uuid>
    </responsible-party>
</metadata>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Number of CSP Test Result POCs (integer):
    count(/*/metadata/responsible-party[@role-id='csp-results-poc']/party-uuid)
(SAP) ID of the first CSP Assessment POC:
    /*/metadata/responsible-party[@role-id='csp-results-poc']/party-uuid[1]
NOTE: Replace [1] as needed with [2], [3], etc.
(SSP) Name of the first person or organization:
    /*/metadata/party[@id='person-1']/person/person-name
(SSP) Role/Title of the first person:
    /*/metadata/party[@id='person-1']/person/prop[@name='title'] [@ns='https://fedramp.gov/ns/oscal']
(SSP) Phone for the first person or organization:
    /*/metadata/party[@id='person-1']//phone
(SSP) Email for the first person or organization:
    /*/metadata/party[@id='person-1']//email
NOTE: Replace 'person-1' with each party-uuid found in the responsible role.

{{</ highlight >}}

**NOTES:**

-   IDs used for roles or parties in the SAP must not duplicate IDs used
    for roles or parties in the SSP.

-   Only define a CSP party in the SAP when no appropriate party exists
    in the SSP.  

---
### 4.7.7. Limitation of Liability 

#### Representation 
{{< highlight xml "linenos=table" >}}
<terms-and-conditions>
    <part name="liability-limitations">
        <title>FedRAMP Required Limitation of Liability Statements</title>
        <part name="liability-limitation">
            <prop name="sort-id" value="001"/>
            <p><insert type="param" id-ref="3pao_name_prm"/>, and its stated partners, shall not be held liable to <insert type="param" id-ref="csp_name_prm"/>  for any and all liabilities, claims, or damages arising out of or relating to the security vulnerability testing portion of this agreement, howsoever caused and regardless of the legal theory asserted, including breach of contract or  warranty, tort, strict liability, statutory liability, or otherwise.</p>
        </part>
        <part name="liability-limitation">
            <prop name="sort-id" value="002"/>
            <p><insert type="param" id-ref="csp_name_prm"/> acknowledges that there are limitations inherent in the methodologies implemented, and the assessment of security and vulnerability relating to information technology is an uncertain process based on past experiences, currently available information, and the anticipation of reasonable threats at the time of the analysis. There is no assurance that an analysis of this nature will identify all vulnerabilities or propose exhaustive and operationally viable recommendations to mitigate all exposure.</p>
        </part>
    </part>
</terms-and-conditions>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Count individual limitations of liability statements (integer):
    count(/*/terms-and-conditions/part[@name='liability-limitations']/ part[@name='liability-limitation'])
(SAP) Obtain Sort IDs, for sorting by the SAP tool:
    /*/terms-and-conditions/part[@name='liability-limitations']/part[@name='liability-limitation'] /prop[@name='sort-id']
(SAP) The first liability limitation statement:
    /*/terms-and-conditions/part[@name='liability-limitations']/part[@name='liability-limitation']/prop [@name='sort-id'] [string()='001']/../(* except prop)
NOTE: Replace '001' with '002', '003', etc. for each sort-id based on desired order.

{{</ highlight >}}

---
## 4.8. SAP Signatures

Using a machine-readable format such as OSCAL for SAP content creates a
challenge in the handling of acceptance signatures. Early adopters are
encouraged to approach the FedRAMP PMO to discuss specific solutions on
a case-by-case basis. Until such time as the FedRAMP PMO and JAB have a
well-established capability for handling signatures, one of the
following approaches is encouraged:

-   Manual \"Wet\" Signature Approach (Document or Letter)

-   Digital Signature

![Test Plan](/img/sap-figure-23.png)

#### Representation 
{{< highlight xml "linenos=table" >}}
<back-matter>
    <resource id="sap-signatures">
        <description><p>Signed SAP</p></description>
        <prop name='type' value='signed-sap'/>
        <!-- Use rlink and/or base64 -->
        <rlink href="./signed-sap.pdf" media-type="application/pdf" />
        <base64 filename="sap.pdf" media-type="application/pdf">00000000</base64>
    </resource>
</back-matter>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Link to signed SAP in PDF Format:
    /*/back-matter/resource/prop[@name='type'] [.='signed-sap']/../rlink/@href
(SAP) Base64-encoded signed SAP in PDF Format:
    /*/back-matter/resource/prop[@name='type'] [.='signed-sap']/../base64

{{</ highlight >}}

### 4.8.1. Manual \"Wet\" Signature Approach (Document or Letter) Print, manually sign, scan, and attach. 

1.  Print one of the following:

    a.  The OSCAL-based SAP content with a tool that renders the SAP in
        a format that resembles the MS-Word based FedRAMP SAP Template;
        or

    b.  A separate letter, which uses the same language.

2.  Have all parties manually sign the document or letter in ink.

3.  Scan the signed copy.

4.  Attach it to the OSCAL-based SAP as a resource.

### 4.8.2. Digital Signature Approach Render, digitally sign, and attach. 

1.  Render the OSCAL-based SAP content as a PDF that resembles the
    MS-Word based FedRAMP SAP Template.

2.  Have all parties digitally sign the PDF document.

3.  Attach it to the OSCAL-based SAP as a resource.

---
## 4.9. SAP Appendices

### 4.9.1. Security Controls Selection Worksheet

An OSCAL SAP must always explicitly select the in-scope controls from
the applicable FedRAMP Baseline/Profile. See section 4.5 Controls
Testing for additional guidance.

### 4.9.2. Test Case Procedures

The assessment objectives and actions (Examine, Interview, and Test)
from the test case workbook are now part of the [OSCAL-based FedRAMP
baselines](https://github.com/GSA/fedramp-automation/tree/master/baselines),
with the detail imported from the OSCAL-based NIST SP 800-53 Catalog via
the baseline.

#### 4.9.2.1. Baseline Objectives and Methods

To include an assessment objective and associated actions in the SAP,
its control must be designated in-scope as described in *Sections 4.1,
SAP Scope*. SAP tools should support and enforce this constraint.

In most cases, a FedRAMP assessor must adopt these without change. In
this case, a SAP tool may simply specify all, to indicate that all
assessment objectives should be included for all in-scope controls. If
needed, objectives can be explicitly included or excluded as well.

![Test Plan](/img/sap-figure-24.png)

#### Representation 
{{< highlight xml "linenos=table" >}}
<reviewed-controls>
    <control-selection>
        <description><h1>Control Scope</h1></description>
        <include-all />
        <exclude-control control-id="ac-1" />
    </control-selection>
    <control-objective-selection>
        <description><h1>Control Objective Scope</h1></description>
        <include-all />
        <!-- OR -->
        <include-objective objective-id="ac-1.a.1_obj.1" />
        <include-objective objective-id="ac-1.a.1_obj.2" />
        <include-objective objective-id="ac-1.a.1_obj.3" />
        <include-objective objective-id="ac-1.a.2_obj.1" />
        <include-objective objective-id="ac-1.a.2_obj.2" />
        <include-objective objective-id="ac-1.a.2_obj.3" />
        <include-objective objective-id="ac-1.b.1_obj.1" />
        <include-objective objective-id="ac-1.b.1_obj.2" />
        <include-objective objective-id="ac-1.b.2_obj.1" />
        <include-objective objective-id="ac-1.b.2_obj.2" />
    </control-objective-selection>
</reviewed-controls>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Include All Objectives for in-scope controls? (true or false):
    boolean(/*/reviewed-controls/control-objective-selection/include-all)
(SAP) Exclude Controls Specified? (true or false):
    boolean(/*/objectives/control-objectives/exclude-objective)
(SAP) Exclude Objectives Total (integer):
    count(/*/objectives/control-objectives/exclude-objective)
(SAP) Exclude Specific Objective (string):
    /*/objectives/control-objectives/exclude-objective[1]/@objective-id

NOTE: Replace "exclude-objective" with "include-objective" above for any explicitly included objective; however, this is redundant when used with 'all'.

{{</ highlight >}}

#### 4.9.2.2. Sampling Methodology

The sampling methodology may continue to be a separate, attached
document. This should be provided as a back-matter resource, containing
a FedRAMP "type" prop with an allowed value, sampling-methodology.

#### Representation 
{{< highlight xml "linenos=table" >}}
<back-matter>
    <resource uuid="uuid">
         <title>Sampling Methodology</title>
         <description>
            <p>Embed or reference copies of the sampling methodology for security controls assessment and vulnerability scanning (if applicable).</p>
         </description>
         <prop ns="https://fedramp.gov/ns/oscal" name="type" 
               value="sampling-methodology"/>
         <!-- Use rlink and/or base64 -->
         <rlink href="./sampling-methodology-reference-1.pdf" 
                media-type="application/pdf"/>
         <rlink href="./sampling-methodology-reference-2.docx" 
                media-type="application/msword"/>
    </resource>
<back-matter>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Link to Sampling Methodology:
    /*/back-matter/resource/prop[@name='type'] [@value='sampling-methodology']/../rlink/@href
(SAP) Base64-encoded Sampling Methodology:
    /*/back-matter/resource/prop[@name='type'] [@value=''sampling-methodology ']/../base64

{{</ highlight >}}

---
### 4.9.3. SAP Penetration Testing Plan and Methodology

The penetration test plan methodology may continue to be a separate,
attached document. This should be provided as a back-matter resource,
containing a FedRAMP "type" prop with an allowed value,
penetration-test-plan.

#### Representation 
{{< highlight xml "linenos=table" >}}
<back-matter>
    <resource uuid="uuid">
         <title>Penetration Testing Plan and Methodology</title>
         <description>
            <p> . . . /p>
            <!-- update the table to reflect the attack vectors, threat models, 
                 and attack models being assessed. -->
            <table>
               <tr>
                  <th>Include</th>
                  <th>Mandatory Attack Vectors</th>
                  <th>Include</th>
                  <th>Threat Models</th>
                  <th>Include</th>
                  <th>Attack Models</th>
               </tr>
               <tr>
                  <td>x</td>
                  <td>External to Corporate</td>
                  <td></td>
                  <td>Internet based (untrusted)</td>
                  <td></td>
                  <td>Enterprise</td>
               </tr>
               <tr> . . . </tr>
            </table>
         </description>
         <prop ns="https://fedramp.gov/ns/oscal" name="type" 
               value="penetration-test-plan"/>
         <!-- Use rlink and/or base64 -->
         <rlink href="./pen_test_plan.pdf" media-type="application/pdf"/>
         <base64 filename="pen_test_plan.pdf" 
                 media-type="application/pdf">00000000</base64>

    </resource>
<back-matter>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Link to Penetration Test Plan:
    /*/back-matter/resource/prop[@name='type'] [@value='penetration-test-plan']/../rlink/@href
(SAP) Base64-encoded Penetration Test Plan:
    /*/back-matter/resource/prop[@name='type'] [@value='penetration-test-plan']/../base64

{{</ highlight >}}

---
### 4.9.4. Significant Change Documentation

The significant change documentation must be provided as a back-matter
resource, containing a FedRAMP "type" prop with an allowed value,
significant-change-request.

#### Representation 
{{< highlight xml "linenos=table" >}}
<back-matter>
<!-- Significant Change Request Documentation -->
      <resource uuid="c965ffb0-cd67-4a80-9014-0c7a217c1f85">
         <title>Significant Change Request Documentation</title>
         <description>
            <p><tr> . . . </tr></p>
            <!-- Add table of additional roles -->
            <table>
               <tr>
                  <th>Role Name</th>
                  <th>Test User ID</th>
                  <th>Associated Functions</th>
               </tr>
               <tr> . . . </tr>
            </table>
         </description>
         <prop ns="https://fedramp.gov/ns/oscal" name="type" 
               value="significant-change-request"/>
         <!-- Use rlink and/or base64 -->
         <rlink href="./fedramp_scr_form.pdf" media-type="application/pdf"/>
         <rlink href="./scr_inventory.xlsx" media-type="application/vnd.ms-excel"/>
         <rlink href="./other_scr_files.zip" media-type="application/zip"/>
      </resource>

<back-matter>

{{</ highlight >}}

#### XPath Queries  
{{< highlight xml "linenos=table" >}}
(SAP) Link to Significant Change Documentation:
    /*/back-matter/resource/prop[@name='type'] [@value=' significant-change-request ']/../rlink/@href
(SAP) Base64-encoded Significant Change Documentation:
    /*/back-matter/resource/prop[@name='type'] [@value= significant-change-request ']/../base64

{{</ highlight >}}