---
title: Attachments
weight: 104
---

Classic FedRAMP attachments include a mix of items. Some lend well to
machine-readable format, while others do not. Machine-readable content
is typically addressed within the OSCAL-based FedRAMP SSP syntax, while
policies, procedures, plans, guidance, and the rules of behavior
documents are all treated as classic attachments, as described in the
*Citations, Attachments, and Embedded Content in OSCAL Files* Section.
The resource's title and description must be used to provide a
human-readable indicator of what attachment is being referenced,
however, OSCAL extensions must also be provided when applicable for
machine readability. The following table describes how each attachment
is handled:

|**Appendix Name**|**Machine Readable**|**How to Handle in OSCAL**|
| :-- | :-- | :-- |
| **Appendix A: FedRAMP Security Controls** | Yes | This can be generated from the content in the Security Controls section and does not need to be maintained separately or attached. |
| **Appendix B: Related Acronyms** | No | Attach using the back-matter, resource syntax.<br /><br />For Acronyms, resource must include a prop with @ns="https://fedramp.gov/ns/oscal", @name="type", and @value="fedramp-acronyms". |
| **Appendix C: Security Policies and Procedures** | No | Attach using the back-matter, resource syntax.<br /><br />For Policies, resource must include a prop with @name=”type”, @value=”policy”, and @class=”control-family”.<br /><br />For Procedures, resource must include a prop with @name=”type”, @value=”procedure”, and @class=”control-family”. |
| **Appendix D: User Guide** | No | Attach using the back-matter, resource syntax.<br /><br />For User Guides, resource must include a prop with @name=”type” and @value=”users-guide”. |
| **Appendix E: Digital Identity Worksheet** | Yes | Incorporated above. See the Digital Identity Determination Section. |
| **Appendix F: Rules of Behavior** | No | Attach using the back-matter, resource syntax.<br /><br />For Rules of Behavior, resource must include a prop with @name=”type” and @value="rules-of-behavior". |
| **Appendix G: Information System Contingency Plan (ISCP)** | No | Attach using the back-matter, resource syntax.<br /><br />For ISCP, resource must include a prop with @name=”type”, @value="plan", and @class="information-system-contingency-plan". |
| **Appendix H: Configuration Management Plan (CMP)** | No | Attach using the back-matter, resource syntax.<br /><br />For CMP, resource must include a prop with @name=”type”, @value="plan", and @class="configuration-management-plan". |
| **Appendix I: Incident Response Plan (IRP)** | No | Attach using the back-matter, resource syntax.<br /><br />For IRP, resource must include a prop with @name=”type”, @value="plan", and @class="incident-response-plan". |
| **Appendix J: CIS and CRM Workbook** | Yes | This can be generated from the content in the Security Controls section and does not need to be maintained separately or attached. |
| **Appendix K: FIPS 199 Worksheet** | Yes | Incorporated above. See the Security Objectives Categorization (FIPS-199) Section. |
| **Appendix L: CSO-Specific Required Laws and Regulations** | No | Attach using the back-matter, resource syntax.<br /><br />For User Guides, resource must include a prop with @name=”type” and @value=”law”. |
| **Appendix M: Integrated Inventory Workbook** | Yes | See the System Inventory Section. |
| **Appendix N: Continuous Monitoring Plan** | No | Attach using the back-matter, resource syntax.<br /><br />For ConMon, resource must include a prop with @name=”type”, @value="plan", and @class="incident-response-plan". |
| **Appendix O: POA&M** | Yes | This is maintained separately in an OSCAL POA&M but can be attached using the back-matter, resource syntax.<br /><br />For POA&M, resource must include a prop with @name=”type”, @value="plan", and @class="poam". |
| **Appendix P: Supply Chain Risk Management Plan (SCRMP)** | No | Attach using the back-matter, resource syntax.<br /><br />For SCRMP, resource must include a prop with @name=”type”, @value="plan", and @class="scrmp". |
| **Appendix Q: Cryptographic Module Table** | Yes | See the Cryptographic Modules Section dealing with components. |

---
## 5.1. Attachments
Classic FedRAMP attachments include a mix of items. Some lend well to
machine-readable format, while others do not. Machine-readable content
is typically addressed within the OSCAL-based FedRAMP SSP syntax, while
policies, procedures, plans, guidance, and the rules of behavior documents are all treated as classic attachments, as described in the *Citations, Attachments, and Embedded Content in OSCAL Files* Section. The following table describes how each attachment is handled:

#### Attachment Representation
{{< highlight xml "linenos=table" >}}
<!-- cut -->
<back-matter>
    <resource uuid="uuid-value">
        <title>Document Title</title>
        <desc>Policy document</desc>
        <prop name="type" ns="https://fedramp.gov/ns/oscal" value="policy"/>
        <prop name="publication" ns="https://fedramp.gov/ns/oscal" value="2021-01-01Z"/>
        <prop name="version" ns="https://fedramp.gov/ns/oscal" value="1.2"/>
        <!-- Add rlink with relative path or embed with base64 encoding -->
        <base64>00000000</base64>
    </resource>
    <resource uuid="uuid-value" />
    <!-- cut: policies 3 - 13 -->
    <resource uuid="uuid-value" />
    <resource uuid="uuid-value" />
    <!-- cut: procedure 2 - 13 -->
</back-matter>
{{</ highlight >}}

#### XPath Queries 
{{< highlight xml "linenos=table" >}}
  The Number of Policies Attached:
    count(/*/back-matter/resource/prop[@name="type"][@ns="https://fedramp.gov/ns/oscal"][string(./@value)="policy"])
  Attachment (Embedded Base64 encoded):
    /*/back-matter/resource[@id="att-policy-1"]/base64
  OR (Relative Link):
    /*/back-matter/resource[@id="att-policy-1"]/rlink/@href
  Title of First Policy Document:
    /*/back-matter/resource/prop[@name="type"][@ns="https://fedramp.gov/ns/oscal"][string(.)="policy"][1]/../prop[@name="title"][@ns="https://fedramp.gov/ns/oscal"]
{{</ highlight >}}

---
## 5.2. System Inventory Approach

![Flat-File Inventory Approach](/img/ssp-figure-24.png)

OSCAL makes two approaches available for depicting the system inventory:

-   **Flat-File Approach**: Similar to today\'s FedRAMP Integrated inventory workbook where all of the information on a spreadsheet row is captured in a single assembly.

-   **Component-Based Approach**: A component is defined once with as much known detail as possible, and inventory-items point to components for common information.

FedRAMP prefers the component-based approach but accepts the flat-file approach to aid CSPs who are converting their existing MS-Excel based FedRAMP Integrated Inventory Workbook to OSCAL. **FedRAMP SSP tools must support both approaches.**

![Flat-File Inventory Approach](/img/ssp-figure-25.png)

With the **flat-file approach**, all content on a spreadsheet row appears in a single OSCAL inventory-item assembly. This results in a great deal of redundant information but is a simple transition from the current spreadsheet approach.

![Flat-File Inventory Approach](/img/ssp-figure-26.png)

With the **component-based approach**, common information is captured once in a component assembly. Each instance of that component has its own inventory-item assembly, which cites the relevant component and only includes information unique to that instance.

For example, if the same Linux operating system is used as the platform for all database and web servers, most of the details about the Linux operating system can be captured once as a component. This includes information such as vendor name, version number, and patch level. If four Linux instances are used, each instance is an inventory item with a unique IP address and MAC address. Only those unique pieces are captured at the inventory level. All four inventory-items point back to the component for vendor name, version number, and patch level.

---
### 5.2.1. Flat File Approach

#### Flat-File Representation
{{< highlight xml "linenos=table" >}}
<!-- cut -->
<system-implementation>
    <!-- interconnection -->
    <system-inventory>
        <inventory-item uuid="uuid-value" asset-id="unique-asset-id">
            <description><p>Flat-File Example (No implemented-component).</p></description>
            <prop name="ipv4-address" value="0.0.0.0"/>
            <prop name="ipv6-address" value="0000:0000:0000:0000"/>
            <prop name="virtual" value="no"/>
            <prop name="public" value="no"/>
            <prop name="fqdn" value="example.com"/>
            <prop name="uri" value="https://example/query?key=value#anchor"/>
            <prop name="netbios-name" value="netbios-name"/>
            <prop name="mac-address" value="00:00:00:00:00:00"/>
            <prop name="software-name" value="software-name"/>
            <prop name="version" value="V 0.0.0"/>
            <prop name="asset-type" value="os"/>
            <prop name="vendor-name" value="Vendor Name"/>
            <prop name="model" value="Model Number"/>
            <prop name="patch-level" value="Patch-Level"/>
            <prop name="serial-number" value="Serial #"/>
            <prop name="asset-tag" value="Asset Tag"/>
            <prop name="vlan-id" value="VLAN Identifier"/>
            <prop name="network-id" value="Network Identifier"/>
            <prop name="scan-type" ns="https://fedramp.gov/ns/oscal" value="infrastructure"/>
            <prop name="allows-authenticated-scan"  value="no">
                <remarks><p>If no, explain why. If yes, omit remarks field.</p></remarks>
            </prop>
            <prop name="baseline-configuration-name" value="Baseline Config. Name" />
            <prop name="physical-location" value="Physical location of Asset" />
            <prop name="is-scanned" value="yes"/>
            <prop name="function" value="Required brief, text-based description."/>
            <link rel="validation" href="#uuid-of-validation-component" />
            <status state="operational"/>
            <responsible-party role-id="asset-owner">
                <party-id>person-7</party-id>
            </responsible-party>
            <responsible-party role-id="asset-administrator">
                <party-id>it-dept</party-id>
            </responsible-party>
            <implemented-component component-uuid="component-uuid-value " />
            <remarks><p>COMMENTS: Additional information about this item.</p></remarks>
        </inventory-item>
        <!-- Repeat the inventory-item assembly for each item in the inventory -->
    </system-inventory>
    <!-- system-implementation remarks -->
</system-implementation>
{{</ highlight >}}

**Notes:**

The value of asset-type determines whether the identified
asset-administrator is managing a system or an application. Currently, any FedRAMP-defined asset-type implies the management of a system, and therefore, is to be scanned as infrastructure.

---
### 5.2.2. Component-based Approach

#### Component-based Representation
{{< highlight xml "linenos=table" >}}
<!-- cut -->
<system-implementation>
    <component uuid="uuid-value" type="software">
        <prop name="virtual" value="no"/>
        <prop name="software-name" value="software-name"/>
        <prop name="version" value="V 0.0.0"/>
        <prop name="asset-type" value="operating-system"/>
        <prop name="vendor-name" value="Vendor Name"/>
        <prop name="model" value="Model Number"/>
        <prop name="patch-level" value="Patch-Level"/>
        <prop name="scan-type" ns="https://fedramp.gov/ns/oscal" value="infrastructure"/>
        <prop name="allows-authenticated-scan"  value="no">
            <remarks><p>If no, explain why. If yes, omit remarks field.</p></remarks>
        </prop>
        <prop name="baseline-configuration-name" value="Baseline Config. Name" />
        <prop name="function" value="Required brief, text-based description.">
            <remarks><p>Optional, longer, formatted description.</p></remarks>
        </prop>
        <link rel="validation" href="#uuid-of-validation-component" />
        <status state="operational"/>
        <responsible-party role-id="asset-owner">
            <party-id>person-7</party-id>
        </responsible-party>
        <responsible-party role-id="asset-administrator">
            <party-id>it-dept</party-id>
        </responsible-party>
    </component>
    <!-- service, interconnection -->
    <system-inventory>
        <inventory-item uuid="uuid-value" asset-id="unique-asset-id">
            <description><p>If needed, describe this instance.</p></description>
            <prop name="ipv4-address" value="0.0.0.0"/>
            <prop name="public" value="no"/>
            <prop name="fqdn" value="example.com"/>
            <prop name="uri" value="https://example/query?key=value#anchor"/>
            <prop name="mac-address" value=">00:00:00:00:00:00"/>
            <prop name="serial-number" value="Serial #"/>
            <prop name="vlan-id" value="VLAN Identifier"/>
            <prop name="network-id" value="Network Identifier"/>
            <prop name="is-scanned" value="yes" />
            <implemented-component component-uuid="component-uuid-value " />
            <remarks><p>COMMENTS: Additional information about this item.</p></remarks>
        </inventory-item>
        <!-- Repeat the inventory-item assembly for each use of the above component -->
    </system-inventory>
    <!-- system-implementation remarks -->
</system-implementation>
{{</ highlight >}}

**Notes:**

-   If component-sample is an image of a Linux virtual machine (VM), and 10 instances of that VM are in use, there would be one (1) component assembly and ten (10) inventory-item assemblies, all referencing the same component.

---
### 5.2.3. Inventory Data Locations and XPath Queries

The following queries are intended to show where to find each piece of information within the system inventory template.

![All Inventory](/img/ssp-figure-26.1.png)
*All Inventory*

![OS Infrastructure Inventory](/img/ssp-figure-26.2.png)
*OS Infrastructure Inventory*

![Software and Database Inventory](/img/ssp-figure-26.3.png)
*Software and Database Inventory*

![Any Inventory](/img/ssp-figure-26.4.png)
*Any Inventory*

#### XPath Queries
{{< highlight xml "linenos=table" >}}
  Number of Inventory Items:
    count(/*/system-implementation/system-inventory/inventory-item)
  Number of Hardware Components:
    count(/*/system-implementation/component[@type="hardware"])
  Number of Software Components:
    count(/*/system-implementation/component[@type="software"])
  In Latest Scan?:
    /*/system-implementation/system-inventory/inventory-item[1]/prop[@name="is-scanned"]/@value

  List Inventory Items Not Scanned:
    /*/system-implementation/system-inventory/inventory-item/prop[@name="is-scanned"][@value='no']/../prop[@name='ipv4-address']
  List of Reasons Inventory Items Were Not Scanned:
    /*/system-implementation/system-inventory/inventory-item/prop[@name="is-scanned"][@value='no']/remarks/node()
{{</ highlight >}}

Unlike most XPath 2.0 queries in this
document, the following queries cannot be easily converted to XPath 1.0.
If working with XPath 1.0, it may be necessary to perform each search
with two separate queries. These queries will list all the IPv4
addresses for each scan type (infrastructure, web, and database),
whether using the flat-file inventory approach or the component-based
approach.

#### XPath Queries
{{< highlight xml "linenos=table" >}}
  IPv4 Address of All Inventory Items Identified for Infrastructure Scanning:
    distinct-values( (let $key:=/*/system-implementation/component[prop [@name='scan-type'] [@ns='https://fedramp.gov/ns/oscal']='infrastructure']/@uuid return /*/system-implementation/system-inventory/inventory-item [implemented-component/@component-uuid=$key]/ prop[@name='ipv4-address']) | (/*/system-implementation/system-inventory/inventory-item/prop[@name='ipv4-address'][../prop[@name='scan-type'][@ns='https://fedramp.gov/ns/oscal']  [string(.)='infrastructure']]) )
  IPv4 Address of All Inventory Items Identified for Web Scanning: 
    distinct-values( (let $key:=/*/system-implementation/component[prop[@name='scan-type'][@ns='https://fedramp.gov/ns/oscal']='web']/@uuid return /*/system-implementation/system-inventory/inventory-item [implemented-component/@component-uuid=$key]/prop[@name='ipv4-address']) | (/*/system-implementation/system-inventory/inventory-item/prop[@name='ipv4-address'][../prop[@name='scan-type'][@ns='https://fedramp.gov/ns/oscal'][string(.)='web']]))
  IPv4 Address of All Inventory Items Identified for Database Scanning: 
    distinct-values( (let $key:=/*/system-implementation/component[prop [@name='scan-type'] [@ns='https://fedramp.gov/ns/oscal']='database']/@uuid return /*/system-implementation/system-inventory/inventory-item [implemented-component/@component-uuid=$key]/prop[@name='ipv4-address']) | (/*/system-implementation/system-inventory/inventory-item/prop[@name='ipv4-address'][../prop[@name='scan-type'][@ns='https://fedramp.gov/ns/oscal'][string(.)='database']]))
  IPv4 Address of All Items Where an Authenticated Scan is Possible:
    distinct-values( (/*/system-implementation/system-inventory/inventory-item/prop [@name='ipv4-address'][../prop[@name="allows-authenticated-scan"][@value='yes']] ) | (let $key:=/*/system-implementation/component[prop [@name='allows-authenticated-scan'][@value='yes']]/@uuid return /*/system-implementation/system-inventory/inventory-item [implemented-component/@component-uuid=$key]/prop[@name='ipv4-address']))
  IPv4 Address of All Items Where an Authenticated Scan is Not Possible:
    distinct-values( (/*/system-implementation/system-inventory/inventory-item/prop[@name='ipv4-address'][../prop[@name="allows-authenticated-scan"][@value='no']] ) | ( let $key:=/*/system-implementation/component[prop [@name='allows-authenticated-scan'][@value='no']]/@uuid return /*/system-implementation/system-inventory/inventory-item [implemented-component/@component-uuid=$key]/prop[@name='ipv4-address']) )
  Authenticated Scan Justification (if Authenticate Scan is "no"):
    /*/system-implementation/system-inventory/inventory-item/prop[@name="allows-authenticated-scan"][@value="no"]/remarks/node()
  OR
    /*/system-implementation/component/prop[@name="allows-authenticated-scan"] [@value="no"]/remarks/node()
{{</ highlight >}}
