---
title: APPENDIX B- CONVERTING A LEGACY SSP TO OSCAL
weight: 704
toc:
  enabled: true
---

NIST designed OSCAL such that a system architect can express all aspects of the system as components. A component is anything that can satisfy a control requirement. This includes hardware, software, services, and underlying service providers, as well as policies, plans, and procedures. 

OSCAL is also designed to support legacy conversion of SSPs without individual components defined, and enables an SSP author to migrate to the component approach gradually over time. In this instance, only a single component is initially required, representing the system as a whole and designated with the special component type, "this-system". The following provides an example of FedRAMP's minimum required component approach:

### **Example control for legacy SSP conversion**

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

<br>

{{<callout>}}
Anything that can satisfy a control requirement is a component, including hardware, software, services, policies, plans, and procedures.
{{</callout>}}
