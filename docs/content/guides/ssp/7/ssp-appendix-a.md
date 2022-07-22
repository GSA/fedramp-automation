---
title: Appendix A- WORKING WITH COMPONENTS
weight: 703
toc:
  enabled: true
---

NIST designed OSCAL such that a system architect can express all aspects of the system as components. A component is anything that can satisfy a control requirement. This includes hardware, software, services, and underlying service providers, as well as policies, plans, and procedures. There are several ways to use components in an OSCAL-based SSP. The following defines FedRAMP's minimum initial use. 

This section will likely be updated as NIST continues to evolve its approach to components in OSCAL, and as FedRAMP receives feedback from stakeholders.

**FedRAMP-defined component identifiers are cited in relevant portions of this document and summarized in the FedRAMP OSCAL Registry.**

{{<callout>}}
Anything that can satisfy a control requirement is a component, including hardware, software, services, policies, plans, and procedures.
{{</callout>}}

##### **Minimum Required Components**

There must be a component that represents the entire system itself. It should be the only component with the component-type set to "system". 
<br>
The following is an example of defined components. 

### **Minimum Required Component Representation**

{{< highlight xml "linenos=table" >}}
<!-- system-characteristics -->
<system-implementation>
    <!-- user -->
    <!-- This System -->
    <component uuid="uuid-value" type="this-system" >
        <title>This System</title>
        <description><p>
        The entire system as depicted in the system authorization boundary.
        </p></description>
        <status state="operational" />
    </component>
</system-implementation>
{{< /highlight >}}

{{<callout>}}
*NIST has clarified the approach to leveraged authorizations and the CRM. Leveraged authorizations and customer responsibility content are no longer handled as components. These scenarios require special handling as described in Section 5, Security Controls.* 
{{</callout>}}


##### **Common Additional Components**

For each FIPS 140 validated module, there must be a component that represents the validation certificate itself. For more information about this, see the *FIPS 140 Validated Components* Section.


### **Common Additional Component Representation**

{{< highlight xml "linenos=table" >}}
 <!-- system-characteristics -->
   <system-implementation>
      <!-- user -->
      <!-- System Copmponent -->
      <!-- Ports, Protocols and Services Entry -->
      <component uuid="uuid-of-service" type="service">
         <title>[SAMPLE]Service Name</title>
         <description><p>Describe the service</p></description>
         <purpose>Describe the purpose the service is needed.</purpose>
         <prop name="used-by" value="What uses this service?"/>
         <status state="operational" />
         <protocol name="http">
            <port-range start="80" end="80" transport="TCP"/>
         </protocol>
         <protocol name="https">
            <port-range start="443" end="443" transport="TCP"/>
         </protocol>
      </component>
      <!-- FIPS 140 Validation Certificate Information -->
      <!-- Include a separate component for each relevant certificate -->
      <component uuid="uuid-value" type="validation">
         <title>Module Name</title>
         <description><p>FIPS 140 Validated Module</p></description>
         <prop name="validation-type" value=”fips-140-2”/>
         <prop name="validation-reference" value="0000"/>
         <link href="https://csrc.nist.gov/projects/cryptographic-module-validation-program/Certificate/0000" />
         <status state="operational" />
      </component>
      <!-- service -->
   </system-implementation>
   <!-- control-implementation -->
{{< /highlight >}}

{{<callout>}}
NIST has clarified the approach to leveraged authorizations and the CRM. Leveraged authorizations and customer responsibility content are no longer handled as components. These scenarios require special handling as described in Section 5, Security Controls. 
The component-type "service" is now used for information typically found in the Ports, Protocols, and Services table, as described in Section 4.25, Ports, Protocols and Services.
{{</callout>}}


##### **Components as a Basis for System Inventory**
NIST's approach to component-based system modeling is to reduce redundancy of information and increase flexibility. NIST accomplishes this with separate component and inventory item modeling. 

This is a one-to-many relationship. One component to many inventory item instances.

For example, if an open source operating system (OS) is used in many places throughout the system, it is defined once as a component. All information about the product, vendor, and support are modeled within the component detail. If the OS is used four times within the system, each use is an inventory item, with details about that specific information, such as IP address. 

**ADD IMAGES**


![](Aspose.Words.2a7003f3-3487-4ce0-a4f2-ffc6deeee87c.005.png)

![](Aspose.Words.2a7003f3-3487-4ce0-a4f2-ffc6deeee87c.004.png)

FedRAMP requires a component assembly for each model of infrastructure device used, and each version of software and database used within the system. FedRAMP is not asking for more detail than provided in the legacy inventory workbook. Only that the information is organized differently.

As NIST continues to evolve its component approach, FedRAMP will re-evaluate its approach to system inventory representation.


##### **FIPS 140 Validated Components**

NIST's component model treats independent validation of products and services as if that validation were a separate component. This means when using components with FIPS 140 validated cryptographic modules, there must be two component assemblies:

- **The Validation Definition**: A component definition that provides details about the validation.
- **The Product Definition**: A component definition that describes the hardware or software product. 

The validation definition is a component definition that provides details about the independent validation. It's type must have a value of "validation". In the case of FIPS 140 validation, this must include a link field with a rel value set to "validation-details". This link must point to the cryptographic module's entry in the NIST Computer Security Resource Center (CSRC) [Cryptographic Module Validation Program Database](https://csrc.nist.gov/projects/cryptographic-module-validation-program/validated-modules/search). 

The product definition is a product with a cryptographic module. It must contain all of the typical component information suitable for reference by inventory-items and control statements. It must also include a link field with a rel value set to "validation" and an href value containing a URI fragment. The Fragment must start with a hashtag (#) and include the UUID value of the validation component. This links the two together.

### **Component Representation: Example Product with FIPS 140-2 Validation**

{{< highlight xml "linenos=table" >}}
 <!-- system-characteristics -->
   <system-implementation>
      <!-- user -->
      <!-- Minimum Required Components -->
      <!-- FIPS 140-2 Validation Certificate Information -->
      <!-- Include a separate component for each relevant certificate -->
      <component uuid="uuid-value" type="validation">
         <title>Module Name</title>
         <description><p>FIPS 140-2 Validated Module</p></description>
         <prop name="validation-type" value=”fips-140-2”/>
         <prop name="validation-reference" value="0000"/>
         <link href="https://csrc.nist.gov/projects/cryptographic-module-validation-program/Certificate/0000" rel="validation-details" />
         <status state="operational" />
      </component>
      <!-- FIPS 140-2 Validated Product -->
      <component uuid="uuid-value" type="software" >
         <title>Product Name</title>
         <description><p>A product with a cryptographic module.</p></description>
         <link href="#uuid-of-validation-component" rel="validation" />
         <status state="operational" />
      </component>
      <!-- service -->
   </system-implementation>
   <!-- control-implementation -->
{{< /highlight >}}

