---
title: Intro to OSCAL-Based FedRAMP Content
heading: FedRAMP OSCAL Guides
menu:
  primary:
    name: Guides
    weight: 100
suppresstopiclist: true
sidenav:
  #focusrenderdepth: 1
  inactiverenderdepth: 1
  activerenderdepth: 2
toc:
  enabled: true
---

## Who Should Use These Guides?
These Guides are intended for technical staff and tool developers implementing solutions for importing, exporting, and manipulating Open Security Controls Assessment Language (OSCAL)-based FedRAMP System Security Plan (SSP) content.

It provides guidance and examples intended to guide an organization in the production and use of OSCAL-based FedRAMP-compliant SSP files. Our goal is to enable your organization to develop tools that will seamlessly ensure these standards are met so your security practitioners can focus on SSP content and accuracy rather than formatting and presentation.

Refer to the *Guide to OSCAL-based FedRAMP Content* for foundational information and core concepts.

<!-- <img style="float: right;" src="/img/refer-to.png"> -->

<div class='callout'>
  <span style="color: red">Refer to the <a href="https://github.com/GSA/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_Content.pdf">Guide to OSCAL-based Content</a> for foundational information and core concepts</span>
</div>

## Related Documents
This document does not stand alone. It provides information specific to developing tools to create and manage OSCAL-based, FedRAMP-compliant SSPs. 

The [*Guide to OSCAL-based FedRAMP Content*](https://github.com/GSA/fedramp-automation/raw/master/documents/Guide_to_OSCAL-based_FedRAMP_Content.pdf), contains foundational information and core concepts, which apply to all OSCAL-based FedRAMP guides. This document contains several references to that content guide.

## Basic Terminology
XML and JSON use different terminology. Instead of repeatedly clarifying format-specific terminology, this document uses the following format-agnostic terminology through the document. 

|**TERM**|**XML EQUIVALENT**|**JSON EQUIVALENT**|
| :- | :- | :- |
|**Field**|A single element or node that can hold a value or an attribute|A single object that can hold a value or property|
|**Flag**|Attribute|Property|
|**Assembly**|A collection of elements or nodes. Typically, a parent node with one or more child nodes.|A collection of objects. Typically, a parent object with one or more child objects.|

These terms are used by National Institute of Standards and Technology (NIST) in the creation of OSCAL syntax.

Throughout this document, the following words are used to differentiate between requirements, recommendations, and options.

|**TERM**|**MEANING**|
| :- | :- |
|**must**|Indicates a required action.|
|**should**|Indicates a recommended action, but not necessarily required.|
|**may**|Indicates an optional action.|
