---
title: Key OSCAL Concepts
weight: 20
---

# Working with OSCAL Files

This section covers several important concepts and details that apply to
OSCAL-based FedRAMP files.

## 2.1. File Content Concepts

Unlike the traditional MS Word-based SSP, SAP, and SAR, the OSCAL-based
versions of these files are designed to make information available
through linkages, rather than duplicating information. In OSCAL, these
linkages are established through `import` commands.

![OSCAL File Imports](/img/content-figure-1.png)
*Each OSCAL file imports information from the one before it.*

\
For example, the assessment objectives and actions that appear in a
blank test case workbook (TCW), are defined in the FedRAMP profile, and
simply referenced by the SAP and SAR. Only deviations from the TCW are
captured in the SAP or SAR.

![Baseline and SSP Info](/img/content-figure-2.png)
*Baseline and SSP Information is referenced instead of duplicated.*

\
For this reason, an OSCAL-based SAP points to the OSCAL-based SSP of the
system being assessed. Instead of duplicating system details, the
OSCAL-based SAP simply points to the SSP content for information such as
system description, boundary, users, locations, and inventory items.

The SAP also inherits the SSP's pointer to the appropriate OSCAL-based
FedRAMP Baseline. Through that linkage, the SAP references the
assessment objectives and actions typically identified in the FedRAMP
TCW.

The only reason to include this content in the SAP is when the assessor
documents a deviation from the SSP, Baseline, or TCW.

### 2.1.1. Resolved Profile Catalogs

The resolved profile catalog for each FedRAMP baseline is a
pre-processing the profile and catalog to produce the resulting data.
This reduces overhead for tools by eliminating the need to open and
follow references from the profile to the catalog. It also includes only
the catalog information relevant to the baseline, reducing the overhead
of opening a larger catalog.

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

![Resolved Profile Catalog](/img/content-figure-3.png)
*The Resolved Profile Catalog for each FedRAMP Baseline reduce tool processing.*

\
For more information about resolved profile catalogs, see *Appendix C,
Profile Resolution*.

## 2.2. Hierarchy and Sequence

For both XML and JSON, the hierarchy of syntax is important and must be
followed. For example, the `metadata` assembly must be at the top level of
the OSCAL file, just below its root. If it appears within any other
assembly, it is invalid.

The same field name is interpreted differently in different assemblies.
For example, the `title` field under metadata is the document title, while
the `title` field under role gives a human-friendly name to that role.

For XML, the sequence of fields and assemblies (elements) is also
important. JSON typically does not require a specific sequence fields
and assemblies (objects). Where sequence is important, OSCAL uses array
objects in JSON.

For example, within the `metadata` assembly, XML must find `title`,
`published`, `last-modified`, `version`, and `oscal-version` in exactly that
order. The `published` field is optional and may be omitted, but if
present, it must be in that position relative to the other fields. When
using JSON, these fields are allowed in any order within the `metadata`
assembly.

Tools must ensure this sequence is maintained when creating or modifying
XML-based OSCAL files. NIST's XML documentation presents the fields and
assemblies in the correct sequence.

Always use the hierarchy found here:

-   SSP:
    <https://pages.nist.gov/OSCAL/reference/latest/system-security-plan/xml-outline/>

-   SAP:
    <https://pages.nist.gov/OSCAL/reference/latest/assessment-plan/xml-outline/>

-   SAR:
    <https://pages.nist.gov/OSCAL/reference/latest/assessment-results/xml-outline/>

-   POA&M:
    <https://pages.nist.gov/OSCAL/reference/latest/plan-of-action-and-milestones/xml-outline/>

### 2.2.1. Typical OSCAL Assembly Structure

Most assemblies in OSCAL follow a general pattern as follows:

-   `title` (field): Typically only one `title` is allowed. Sometimes it is
    optional. This is a *markup-line* datatype.

-   `description` (field): Typically only one `description` field is
    allowed. Sometimes it is optional. This is a *markup-multiline*
    datatype.

-   `prop` (fields): There may be many `prop` fields. The `name` flag
    identifies the specific annotation. The `value` flag is a string
    datatype and holds the intended value. The `prop` field includes an
    optional `uuid` flag to give a globally unique identifier, an optional
    `ns` field to allow for namespacing the `prop` and indicate it is
    optional information that is not of core OSCAL syntax and a `class`
    flag to sub-class one or more instances of the `prop` into specific
    sub-groups.

-   `link` (fields): There may be many `link` fields. The `href` flag allows a
    uniform resource identifier (URI) or URI fragment to a related item.
    Often, `href` fields point to a `resource` in back matter using its UUID
    value in the form of href="#[uuid-value]".

-   ***assembly-specific fields***

-   `remarks` (field): Typically only one `remarks` field is allowed. It is
    always optional. This is a *markup-multiline* datatype.

While this is not universal in OSCAL, when any of these fields are
present, they follow this pattern.

The `prop` field is present to allow OSCAL extensions within each
assembly. See *Section 3, FedRAMP Extensions and Accepted Values* for
more information on FedRAMP's use of OSCAL extensions.

## 2.3. Multiple Layers of Validation

There are several layers at which an OSCAL file can be considered
valid.
**OSCAL-based FedRAMP files must be valid at all layers.**

|**Layer**|**Description**|
| :-- | :-- |
|**Well-Formed**|The XML or JSON file follows the rules defined for that format. <br /> Any tool that processes the format will recognize it as "well-formed," which means the tool can proceed with processing the XML or JSON. <br /> XML: [https://www.w3.org/TR/REC-xml/](https://www.w3.org/TR/REC-xml/) <br /> JSON: [https://json.org/](https://json.org/)|
|**OSCAL Syntax**|The XML or JSON file only uses names and values defined by NIST for OSCAL.  NIST publishes schema validation tools to verify syntax compliance based on the following standards: <br /> XML Syntax Validation: [XML Schema Definition Language (XSD) 1.1](https://www.w3.org/TR/xmlschema11-1/) <br /> JSON Syntax Validation: [JSON Schema, draft 07](https://json-schema.org/)|
|**OSCAL Content**| For certain OSCAL fields, the NIST syntax validation tools also enforce content - allowing only a pre-defined set of values to be used in certain fields. <br /><br /> For example, Within the SSP model, impact levels within the information type assemblies only allow the following values: `fips-199-low`, `fips-199-moderate`, and `fips-199-high`. Any other value will cause an error when validating the file. <br /><br /> In the future, NIST intends to publish more robust content enforcement mechanisms, such as [Schematron](http://schematron.com/). This enables more complex rules such as, "If field A is marked 'true', field B must have a value." FedRAMP is also exploring the use of Schematron for enhanced validation and may publish these in the future.|
|**FedRAMP Syntax Extensions**    | NIST designed OSCAL to represents the commonality of most cybersecurity frameworks and provided the ability to extend the language for framework-specific needs. FedRAMP makes use of these extensions. <br /><br />NIST provides `prop` fields throughout most of its assemblies, always with a `name`, `class`, and `ns` (namespace) flag: <br /> `<prop name="" class="" ns="">Data</prop>` <br /><br /> In the core OSCAL syntax, the `ns` flag is never used. Where FedRAMP extends OSCAL, the value for `ns` is always: <br /><br />`https://fedramp.gov/ns/oscal` (case sensitive). <br /><br /> When `ns='https://fedramp.gov/ns/oscal'` the `name` flag is as defined by FedRAMP. If the `class` flag is present, that is also defined by FedRAMP.|
|**FedRAMP Content**| Today, FedRAMP content is enforced programmatically. FedRAMP intends to publish automated validation rules, which may be adopted by tool developers to verify OSCAL-based FedRAMP content is acceptable before submission. <br /><br />Initial validation rules ensure a package has all required elements and will evolve to perform more detailed validation. Separate details will be published about this in the near future.|

##  2.4. OSCAL's Minimum File Requirements

Every OSCAL-based FedRAMP file must have a minimum set of required
fields/assemblies, and must follow the core OSCAL syntax found here:
![Anatomy of an OSCAL File](/img/content-figure-4.png)
*Anatomy of an OSCAL file*

In addition to the core OSCAL syntax, the following FedRAMP-specific
implementation applies:

-   The root element of the file indicates the type of content within
    the body of the file. The recognized OSCAL root element types are as
    follows:

    -   **catalog**: Contains a catalog of control definitions, control
        objectives, and assessment activities, such as NIST SP 800-53
        and 800-53A.

    -   **profile**: Contains a control baseline, such as FedRAMP
        Moderate

    -   **component**: Contains information about a product, service, or
        other security capability, such as the controls it can satisfy.

    -   **system-security-plan**: Describes a system and its security
        capabilities, including its authorization boundary and a
        description of how each control is satisfied.

    -   **assessment-plan**: Describes the plan for assessing a specific
        system.

    -   **assessment-results**: Describes the actual activities
        performed in the assessment of a specific system, as well as the
        results of those activities.

    -   **plan-of-action-and-milestones**: Describes and tracks known
        risks to a system, as well as the plan for remediation.

-   The Universally Unique ID (UUID) at the root must be changed every
    time the content of the file is modified.

-   Every OSCAL file must have a metadata section and include a title,
    last-modified timestamp, and OSCAL syntax version.

-   The body of an OSCAL file is different for each model.

-   Back matter syntax is identical in all OSCAL models. It is used for
    attachments, citations, and embedded content such as graphics. Tool
    developers and content authors are encouraged to attach content here
    and reference it from within the body of an OSCAL file.

The table below shows an empty OSCAL file, based purely on the NIST
syntax; however, FedRAMP requires much more in a minimum file. The
latest OSCAL-based FedRAMP template files can be found here in JSON and
XML formats:

[https://github.com/GSA/fedramp-automation/tree/master/dist/content/rev5/templates](https://github.com/GSA/fedramp-automation/tree/master/dist/content/rev5/templates)

#### An Empty OSCAL File Representation
{{< highlight xml "linenos=table" >}}
    <?xml version="1.0" encoding="UTF-8"?>
    <OSCAL-root-element xmlns="http://csrc.nist.gov/ns/oscal/1.0" uuid="[generated-uuid]">
        <metadata>
        <title>Document Title</title>
        <last-modified>2023-03-06T00:00:00.000Z</last-modified>
        <version>0.0</version>
        <oscal-version>1.0.4</oscal-version>
        </metadata>

        <!-- body cut -->

        <back-matter />
    </OSCAL-root-element>
{{< /highlight >}}


### 2.4.1. UTF-8 Character Encoding

OSCAL uses UTF-8 character encoding. JSON files are always UTF-8
character encoded.

In XML, the first line in the example above ensures UTF-8 encoding is
used. Other encoding options will create unpredictable results.

### 2.4.2. OSCAL Syntax Version

Tools designed to read an OSCAL file must verify the `oscal-version` field
to determine which published syntax is used.

Tools designed to create or manipulate an OSCAL file must specify the
syntax version of OSCAL used in the file in the `oscal-version` field.

NIST ensures backward compatibility of syntax where practical; however,
this is not always possible. Some syntax changes between milestone
releases leading up to OSCAL version 1.0 are unavoidable. NIST intends
to keep all formally published schema validation files available, which
keeps validation and conversion tools available for older versions of
OSCAL. See Section *2.4.6 OSCAL Syntax Versions* for more information.
FedRAMP releases indicate, in its trailing half, the earliest version of
OSCAL supported by baselines, templates, documentation, and ancillary
utilities. See [the OSCAL Support and Deprecation Policy in the FedRAMP Automation Github repository](https://github.com/GSA/fedramp-automation/blob/e0bf4d343b8bd06daa52e7817b2215f294aeab6b/README.md#support-and-oscal-deprecation-strategy) for further details.

### 2.4.3. Content Change Requirements

Any time a tool changes the contents of an OSCAL file, it must also:

-   update the file's `uuid flag` (`/*/@uuid`) with a new UUID; and

-   update the `last-modified` field (`/*/metadata/last-modified`) with the current date and time. (Using the OSCAL date/time format, as described in *Section 2.6.1 [Date and Time in OSCAL Files](#date-and-time-in-oscal-files)*)

Tools that open or import OSCAL files should rely on the UUID value
provided by the `uuid` flag, and `last-modified` field as easy methods of
knowing the file has changed.

See the following for more information:
https://pages.nist.gov/OSCAL/documentation/schema/overview/#common-high-level-structure

### 2.4.4. Cryptographic Integrity (Future)

NIST intends to add a cryptographic hash feature to OSCAL during
calendar year 2021. Once available, NIST will publish details here:
<https://pages.nist.gov/OSCAL/concepts/layer/>

While tool developers are encouraged to perform their own integrity
checking, it is important to note cryptographic hash algorithms will
produce a different result for inconsequential file differences, such as
different indentation or a change in the sequence of flags.

### 2.4.5. Useful XPath Queries for Document Changes and OSCAL Syntax

Below are a few important queries, which enable a tool to obtain
critical information about any OSCAL file.

#### XPath Queries          
{{< highlight xml "linenos=table" >}} 
    <!-- OSCAL syntax version used in this file: -->
    /*/metadata/oscal-version                                           
                                                                        
    <!-- Last Modified Date/Time: -->                                        
    /*/metadata/last-modified                                           
                                                                        
    <!-- Unique Document ID: -->                                             
    /*/@uuid                                                            
                                                                        
    <!-- Document Title: -->                                                
    /*/metadata/title            

{{< /highlight >}}


### 2.4.6. OSCAL Syntax Versions

NIST's approach to OSCAL development ensures the syntax validation and
format conversion tools remain available for release of OSCAL.

{{<callout>}}
_NIST always makes the latest version of syntax validation and format conversion files available in the main OSCAL repository, including any changes since the last formal release._ 

To ensure stable resources, use a formal OSCAL release. NIST publishes formal OSCAL releases here:
https://github.com/usnistgov/OSCAL/releases
{{</callout>}}

## 2.5. Assigning Identifiers

There are four ways identifiers are typically used in OSCAL:

-   **ID flag**: uniquely identifies a field or assembly.

-   **UUID flag**: An [RFC-4122](https://tools.ietf.org/html/rfc4122)
    compliant universally unique identifier, version 4.

-   **ID/UUID Reference**: a flag or field that points to another field
    or assembly using its unique ID or UUID flag value.

-   **Uniform Resource Identifier (URI) Fragment**: A value in a flag or
    field with a [URI data
    type](https://pages.nist.gov/OSCAL/documentation/schema/datatypes/#uri).
    A [URI fragment](https://tools.ietf.org/html/rfc3986#section-3.5)
    starts with a hashtag (#) followed by a unique ID value.

{{<callout>}}
 _Tools must generate RFC4122 version 4 UUID values and assign them anyplace a UUID flag exists._
 {{</callout>}}

**Identifiers** appear as an "**id**" or "**uuid**" flag to a data
field or assembly. Examples include:

-   `<control id="ac-1">`: Uniquely identifies the control.

-   `<party uuid="8e83458e-dde5-4ee2-88bc-152f8da3fc31">`:
    Uniquely identifies the party.

**An ID reference** typically appears with a name and hyphen in front of
the "id" (name-id) or "uuid" (name-uuid). It is typically a flag where
the relationship is one-to-one, but sometimes a field when the
relationship is one-to-many. The name of an ID reference flag/field
typically reflects the name of the field to which it points.

{{<callout>}}
_IDs and UUIDs are intended to be managed by tools "behind the scenes," and should not typically be exposed to users for manipulating SSP, SAP, SAR and POA&M content._
{{</callout>}}

Examples include:

-   `<responsible-party role-id="prepared-by">`: points to a role
    identified by "prepared-by".

-   `<implemented-requirement id="imp-req-01" control-id="ac-2">`: points to the control identified by
    "ac-2".

NIST provides some standard identifiers. Where appropriate, FedRAMP has
adopted those and defined additional identifiers as needed. To ensure
consistent processing, FedRAMP encourage content creators to use the
NIST and FedRAMP-defined identifiers to the greatest degree practical.
Deviation is likely to result in processing errors.

### 2.5.1. Uniqueness of Identifiers

Within FedRAMP deliverables, only `roles` in the `metadata` assembly have ID
flags. All other OSCAL identifiers are UUID.

Some role ID values are prescribed by NIST, and others by FedRAMP. These
are "reserved" and must not be assigned to other roles for other
reasons. The scope of this requirement goes beyond the current OSCAL
file to all files in the OSCAL stack as a result of import statements,
as described in *Section 2.1, File Content Concepts*.

For UUID fields, if using a tool that properly generates version 4 UUID
values, no two will be alike; however, buggy tools have been known to
create unexpected duplicate values. In an abundance of caution, tool
developers are encouraged to check for unintended duplicates whenever
generating a new UUID values. At least during the testing phase of your
development lifecycle.

### 2.5.2. Searching for Information by ID or UUID Values

When searching for an ID or UUID reference, the tool must look both in
the current OSCAL file, and other files in the OSCAL stack as described
in *Section 2.1, File Content Concepts*.

For example, a UUID reference in an OSCAL-based FedRAMP SAR could refer
to a field or assembly in the SAR, SAP, or SSP. XPath and similar
standards only search the current file.

This requires OSCAL tools to search the current file first. If the ID or
UUID is not found, the tool should follow the file's import statement
and search the next file the same way. This must be repeated until
either the ID/UUID is found, or all files in the stack have been
processed. Of course, tools may limit

**Searching for a Field or Assembly by ID or UUID**

In general, it is very simple to query for an ID or UUID value within an
XML file. Simply use the following XPath query:

{{< highlight xml "linenos=table" >}}
//*[@id='id-value']

<!-- OR  -->

//*[@uuid='uuid-value']
{{< /highlight >}}

Of course, the tool must replace 'id-value' or 'uuid-value' above
with the appropriate reference.

**Ensuring the Field or Assembly Name Matches**

Often flags that reference OSCAL information using its ID or UUID will
have a name and context that clarifies the expected target. For example,
a flag may appear as follows:

{{< highlight xml "linenos=table" >}}
<field-name component-uuid='1c23ddee-7001-4512-9de1-e062faa69c0a' />
{{< /highlight >}}

To ensure this UUID value points to a component, use the following XPath
query: 

{{< highlight xml "linenos=table" >}}
boolean(//*[@uuid='1c23ddee-7001-4512-9de1-e062faa69c0a']/name()='component')
{{< /highlight >}}

If the above expression returns true, the UUID points to a component as
intended.

**Limiting Searches by Field or Assembly Name**

Another approach is to limit the search only to fields or flags with a
specific name.

The following will only find the UUID value if it is associated with a
component. It would work in the SSP, SAP, SAR and POA&M.
{{< highlight xml "linenos=table" >}}
//component[@uuid='1c23ddee-7001-4512-9de1-e062faa69c0a']
{{< /highlight >}}

The following will only find the UUID value if it is associated with a
component in the system-implementation assembly of the SSP. If the UUID
value is
{{< highlight xml "linenos=table" >}}
/*/system-implementation/component[@uuid='1c23ddee-7001-4512-9de1-e062faa69c0a']
{{< /highlight >}}
## 2.6. Handling of OSCAL Data Types

OSCAL fields and flags have data types assigned to them. NIST provides
important information about these data types here:
[[https://pages.nist.gov/OSCAL/reference/datatypes/]](https://pages.nist.gov/OSCAL/reference/datatypes/)

The following sections describe special handling considerations for data
types that directly impact FedRAMP content in OSCAL.

### 2.6.1. Date and Time in OSCAL Files

Except where noted, all dates and times in the OSCAL-based content must
be in an OSCAL
`dateTime-with-timezone` format as documented here:

[[https://pages.nist.gov/OSCAL/reference/datatypes/#datetime-with-timezone]](https://pages.nist.gov/OSCAL/reference/datatypes/#datetime-with-timezone)

This means all dates and times must be represented in the OSCAL file
using following format, unless otherwise noted:

`"Y-m-dTH:i:s.uP"` (See
[HERE](https://www.php.net/manual/en/class.datetime.php) for formatting
codes.)

For example, a publication date of 5:30 pm EST, January 10, 2020 must
appear as
2020-01-10T17:30:00.00-05:00

This includes:

-   Numeric Year: Four-digits

-   A dash

-   Numeric Month: Two-digit, zero-padded

-   A dash

-   Numeric Day: Two digit, zero padded

-   The capital letter "T" (Do not use lower case)

-   Hour: Two digit, zero-padded, 24-hour clock (Use 18 for 6:00 pm)

-   A colon

-   Minute: Two digit, zero-padded

-   A colon

-   Seconds: Two digit, zero-padded

-   A decimal point

-   Fractions of a second: two or three digits, zero padded

Followed by either:

-   A capital letter Z to indicate the time is expressed in Coordinated
    Universal Time (UTC)

OR:

-   A plus or minus representing the offset from UTC

-   Hour Offset: Difference from UTC, two-digit, padded

-   A colon

-   Minutes Offset: Difference from UTC, two-digit, padded

This is only for *storing* dates in the OSCAL file. NIST syntax
verification tools will generate an error if this format is not found.

Tool developers are encouraged to *present* dates as they have
historically appeared in FedRAMP documents. In other words, tools should
convert `"2020-03-04T00:00:00.00-05:00"` to `"March 4, 2020"` when
presenting the publication date to the user.

Please use the appropriate UTC offset in your region. If you are storing
a date and padding the time with zeros, you may also pad the UTC offset
with zeros.

### 2.6.2. UUID Datatypes

Any place a UUID flag or UUID reference exits, NIST requires UUID
version 4, as defined by
[RFC-4122](https://tools.ietf.org/html/rfc4122). See here for more
information: <https://pages.nist.gov/OSCAL/reference/datatypes/#uuid>

Version 4 UUIDs are 128-bit numbers, represented as 32 hexadecimal
(base-16) digits in the pattern:

`xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`

All alphabetic characters (a-f) representing hexadecimal values must be
lower case.

Strictly following the RFC ensures the probability of generating an
unintended duplicate UUID value is so close to zero it may be ignored.
As calculated on
[Wikipedia](https://en.wikipedia.org/wiki/Universally_unique_identifier),
after generating 103 trillion version 4 UUIDs, there is a one in a
billion chance of a duplicate.

There are several open-source algorithms and built-in functions for
generating UUID. It is important to use one that is known to be fully
compliant. Unintended duplicate UUIDs become more likely when using
non-compliant or erroneous algorithms.

**For more information about the use of UUIDs in OSCAL, see *Section*
*2.5,* *Assigning Identifiers*.**

### 2.6.3. ID Datatypes

NIST typically uses ID flags in OSCAL where the identifier is intended
to be canonical, such as the identifiers for `role` IDs or NIST SP 800-53
controls.

Any place an ID flag or ID reference exits, the datatype is
[token](https://pages.nist.gov/OSCAL/reference/datatypes/#token). It is
similar to the [NCName](https://www.w3.org/TR/xmlschema-2/#NCName) as
defined by the World Wide Web Consortium (W3C), but does not allow
spaces. The allowable values of an NCName are limited as follows:

-   The first character must be alphabetic [a-z or A-Z], or an
    underscore [_].

-   The remaining characters must be alphabetic [a-z or A-Z], numeric
    [0-9], an underscore [_], period [.], or dash [-].

-   Spaces are not allowed.

`Token` values are case sensitive. `"This"` does not match `"this"` in searches.

A tool developer may wish to assign UUID values to ID flags. UUIDs may
start with a numeric character, which is invalid for NCName. To ensure a
valid datatype when using a UUID value in an ID field, consider
prepending "uuid-" to the UUID value.

**For more information about the use of IDs in OSCAL, see *Section*
*2.5,* *Assigning Identifiers*.**

### 2.6.4. Working With href Flags

All OSCAL-based `href` flags are URIs formatted according to [section 4.1
of RFC3986](https://tools.ietf.org/html/rfc3986#section-4.1). When
assembling or processing an OSCAL-based FedRAMP file, please consider
the following:

**Absolute Paths**: When using an absolute path within a FedRAMP OSCAL
file, the path must be publicly accessible from any location on the
Internet, to ensure agency and FedRAMP reviewers can reach the
information.

Tool developers are encouraged to validate paths before storing or using
them in OSCAL files and raise issues to users if paths are not
reachable.

**Relative Paths**: All relative paths are assumed to be based on the
location of the OSCAL file, unless tools are explicit as to other
handling. Sensitive external documents should travel with the OSCAL file
and be linked using a relative path.

**Internal Locations**: These URI fragments appear as just a hashtag (#)
followed by a name, such as `#a3e9f988-2db7-4a14-9859-0a0f5b0eebee`. This
notation points to a location internal to the OSCAL content. Typically,
this references to a `resource` assembly, but may reference to any field
or assembly with a unique ID or UUID.

If only a URI fragment (internal location) is present, the OSCAL tool
must strip the hashtag (#) and treat the remaining string as a UUID
reference to a resource. The resource may exist in the current OSCAL
file, or one of the imported OSCAL files in the stack as described in
*Section 2.1, File Content Concepts*.

For example, the following OSCAL content contains a `href` flag with a URI
fragment:

#### URI Fragment Example
 {{< highlight xml "linenos=table" >}}
 <system-characteristics>
  <authorization-boundary>
  <diagram uuid="a04b5a0c-6111-420c-9ea3-613629599213">
  <link href="#a3e9f988-2db7-4a14-9859-0a0f5b0eebee"/>
  <caption>Authorization Boundary Diagram</caption>
  </diagram>
  </authorization-boundary>
 </system-characteristics>
 {{< /highlight >}}

When a tool processes the above example, it should look inside the
document for a field or assembly with a UUID of
`"a3e9f988-2db7-4a14-9859-0a0f5b0eebee"`. This can be accomplished with
the following XPath query:
{{< highlight xml "linenos=table" >}}
//*[@uuid="a3e9f988-2db7-4a14-9859-0a0f5b0eebee"]
{{< /highlight >}}
If this is found to point to a resource assembly, see the *Attachments
and Embedded Content in OSCAL Files* section for additional handling.

The name of the field or assembly referenced by the above URI fragment
can be determined using the following XPath 2.0 query:
{{< highlight xml "linenos=table" >}}
//*[@uuid="uri-fragment" | @id="uri-fragment"]/name()
{{< /highlight >}}
To express this in XPath 1.0, you must use the following:
{{< highlight xml "linenos=table" >}}
name(//*[@uuid="uri-fragment" | @id="uri-fragment"])
{{< /highlight >}}
The above query will return "resource", if the URI Fragment references
the UUID of a `resource` assembly.

### 2.6.5. Markup-line and Markup-multiline Fields in OSCAL

As with most machine-readable formats, most of OSCAL's fields are
intended to capture short, discrete pieces of information; however,
sometimes users require content to be formatted using features such
bold, underline, and italics.
{{<callout>}}
_For markup-line and markup-multi-line, a subset of HTML is used to format XML-based OSCAL files, while Markdown is used to format JSON-based OSCAL files._
{{</callout>}}

OSCAL provides two types of fields for this purpose:

-   **markup-line**: Allows some formatting within a single line of
    text.

-   **Markup-multiline**: Allows all the markup-line formatting, plus
    allows multiple lines, ordered/ unordered lists, and tables.

In OSCAL-based XML files, markup-line and -multiline uses a subset of
HTML.

In OSCAL-based JSON files, markup-line and -multiline uses a subset of
markdown.

**NIST has implemented only a subset of formatting tags from these
standards.** This is to ensure formatted content converts completely and
consistently between XML and JSON in either direction.

Both *markup-line* and *markup-multiline* support:

-   emphasis and important text

-   inline code and quoted text

-   sub/super-script

-   images and links

*Markup-multiline* also supports:

-   Paragraphs

-   Headings (Levels 1-6)

-   Preformatted text

-   Ordered and Unordered Lists

-   Tables

For a complete list of markup-line and markup-multiline features, please
visit:
[[https://pages.nist.gov/OSCAL/reference/datatypes/#markup-data-types]](https://pages.nist.gov/OSCAL/reference/datatypes/#markup-data-types)

### 2.6.6. Working with Markup-multiline Content

In JSON, markup-multiline is based on Markdown syntax and requires no
special handling. XML-based markup-multiline fields require all content
to be enclosed in one of the following tags: `<p>`, `<h1>` - `<h6>`,
`<ol>`, `<ul>`, `<pre>`, or `<table>`. At least one of these tags must
be present. More than one may be present. All text must be enclosed
within one of these tags.

The example below is a common misuse of markup-multiline. The
description contains text, but the text is not enclosed in one of the
required tags. This will produce an error when checked with the OSCAL
schema.


#### Incorrect Markup-multiline Representation
{{< highlight xml "linenos=table" >}}
  <system-characteristics>
    <!-- cut -->
    <description>The xyz system performs ...</description>
  </system-characteristics>
{{< /highlight >}}
  

The simplest way to correct the error is to enclose the text in
`<p></p>` tags, within the `description` field.

#### Correct Markup-multiline Representation
{{< highlight xml "linenos=table" >}}
  <system-characteristics>
    <!-- cut -->
    <description>
        <p>The xyz system performs ...</p>
    </description>
  </system-characteristics>
{{< /highlight >}}
  

The example below demonstrates a correct use of markup-multiline in XML.
Please note, the inclusion of a `<p />` tag on a line by itself inserts
an empty paragraph. Within XML and HTML, this is treated as a shortcut,
and is interpreted as `"<p></p>"`.

#### Correct Markup-multiline Representation
{{< highlight xml "linenos=table" >}}
  <system-characteristics>
    <!-- cut -->
    <description>
        <p>The <b>xyz system</b> performs ... </p>
        <p>The xyz system further supports ... as follows:</p>
        <table>
            <tr>
                <td>Cell A1</td>
                <td>Cell B1</td>
            </tr>
            <tr>
                <td>Cell A2</td>
                <td>Cell B2</td>
            </tr>
        </table>
        <h1>Big Header</h1>
        <p>More detail</p>
        <p><img alt="alt text" src="url" title="title text"/></p>
    </description>
  </system-characteristics>
{{< /highlight >}}

For more information, please visit:
[https://pages.nist.gov/OSCAL/reference/datatypes/#markup-data-types](https://pages.nist.gov/OSCAL/reference/datatypes/#markup-data-types)

### 2.6.7. Special Characters in OSCAL

While OSCAL itself does not directly impose special character handling
requirements, XML and JSON do. Characters, such as ampersand (&),
greater than (>), less than (<), and quotes (") require special
treatment in OSCAL files, depending on the format. For a complete list
of special characters and the appropriate treatment for each format,
please visit:

[https://pages.nist.gov/OSCAL/reference/datatypes/#specialized-character-mapping](https://pages.nist.gov/OSCAL/reference/datatypes/#specialized-character-mapping)

## 2.7. Citations and Attachments in OSCAL Files

OSCAL is designed so that all citations and attachments are defined once
at the end of the file as a `resource`, and then referenced as needed
throughout the file. This includes logos, diagrams, policies,
procedures, plans, evidence, and interconnection security agreements
(ICAs).

Each `resource` may be referenced from anywhere in the OSCAL file, using
its resource UUID.
{{< highlight xml "linenos=table" >}}
  <back-matter>
    <resource uuid="3df7eeea-421b-459d-98cf-3d972bec610a">
        <title>Attachment or Document Title</title>
        <desc>An optional description of the attachment.</desc>
        <rlink href="./relative/path/doc.pdf" media-type="application/pdf"
        />
        <rlink href="/absolute/path/doc.pdf" media-type="application/pdf"
        />
        <base64 filename="doc.pdf" media-type="application/pdf">
        00000000
        </base64>
    </resource>
  </back-matter>
{{< /highlight >}}

The `media-type` flag should be present and must be set to an [Internet
Assigned Numbers Authority (IANA) Media
Type](http://www.iana.org/assignments/media-types/media-types.xhtml).

### 2.7.1. Citations

Citations are for reference. The content is not included with the
authorization package.

Citations use an `rlink` field with an *absolute path* to content that is
accessible by FedRAMP and Agency reviewers from government systems.

Examples include links to publicly available laws such as FISMA, and
applicable standards, such NIST SP 800 series documents.

### 2.7.2. Attachments

Unlike citations, attachments are included with the authorization
package when submitted.

Tools may either embed an attachment using the `base64` field, or point to an attachment using an `rlink` field. If no base64 embedded content is
present, at least one `rlink` field must exist with either an *absolute
path* to content that is accessible by FedRAMP and Agency reviewers from
government systems, or a relative path.

If a relative path is used, the attachment must be delivered with the
OSCAL file and packaged such that the attachment exists in the correct
relative location.

Examples include the logo for the CSP or 3PAO, authorization boundary
diagrams, policies, process, plans, raw scanner output, assessment
evidence, and POA&M deviation request evidence.

Tools should embed (base64) or link to (rlink) an attachment once as a
`resource` in `back-matter`, then use URI fragments to reference the
attachment anyplace it is needed within the body of the OSCAL file, as
described in *Section 2.5, Assigning Identifiers* or *Section 2.6.2,
Working With href Flags*.

For example, a policy document that satisfies several control families
is attached as a `resource` in the `back-matter`, with a UUID of
`"3df7eeea-421b-459d-98cf-3d972bec610a"`. Each control satisfied by that
policy, links to the policy using a URI fragment as follows:
{{< highlight xml "linenos=table" >}}
<link href="#3df7eeea-421b-459d-98cf-3d972bec610a" rel="policy" />
{{< /highlight >}}

As described in *Section 2.6.2, Working With href Flags*, when a tool
identifies a URI fragment in an `href` value, the leading hashtag (#) must
be dropped and the remaining value is expected to reference an OSCAL
addressable ID or UUID. This ID/UUID may be either within the OSCAL file
itself, or within other OSCAL documents linked via the `import` field.

The policy's title, version, publication date and other details are
defined once in the resource and are displayed anyplace the policy is
referenced. If a newer policy is published, only the one resource in
needs to be updated.

If the policy's location is identified as `="./policies/doc.pdf"`, the
OSCAL file and the doc.pdf file should be delivered together and
packaged such that the folder containing the OSCAL file includes a
sub-folder named `"policies"`, which contains the `"doc.pdf"` file.

When using attachments with relative paths, consider using a technology
such as a ZIP archive to package and deliver attachments while
maintaining their relative position to the OSCAL file.

### 2.7.3. Including Multiple rlink and base64 Fields

Within a `resource`, there may be:

-   no `rlink` nor `base64` fields;

-   one or more `rlink` fields;

-   one or more base64-encoded data fields within the OSCAL file; or

-   any combination of `rlink` and `base64` fields.

OSCAL allows multiple `rlink` and `base64` fields to exist within the same `resource`. This provides the flexibility to identify multiple locations or multiple formats of the same resource. Some examples of using
multiple `rlink` and/or `base64` fields within the same resource include:

-   **Multiple Locations**: Multiple `rlink` fields allow an OSCAL tool to
    include one `rlink` field with an *absolute* path to the authoritative
    location of a policy document within the CSP's intranet. The same
    `resource` could have a second `rlink` field with a *relative* path to
    the same policy document. Having both allows the CSP to maintain the
    link to authoritative location of the policy when working with the
    OSCAL file internally, while allowing a cached, local copy to travel
    with the OSCAL file when delivered to FedRAMP for review.

-   **Multiple Quality Levels**: Multiple `rlink` or `base64` fields allow
    both low-resolution and high-resolution versions of the same image,
    which is sometimes used to boost the performance of web-based
    applications.

-   **Multiple Formats**: Multiple `rlink` or `base64` fields allow a
    portable network graphic (PNG) version of an image may be provided
    for presentation by a web application, and a more detailed portable
    document format (PDF) version of the same image for download by
    users.

### 2.7.4. Handling Multiple rlink and base64 Fields

NIST designed `resource` assemblies to be flexible and wanted to offer
developers the flexibility to implement handling of multiple `rlink` and
`base64` fields on a case-by-case basis.

This section describes FedRAMP's processing of multiple `rlink` and
`base64` fields, which will be used by default unless a compelling
circumstance requires otherwise.

FedRAMP accepts both `base64` and `rlink` option content for diagrams and
graphics. FedRAMP prefers documents, such as policies and plans, are
attached using `rlink` fields and relative paths.

If the tool is designed to work interactively with a user, the tool
developer should consider designing the tool to make intelligent choices
based on context and circumstances where practical. The tool could also
present valid choices to the user where the correct choice is ambiguous
to the tool.

When more than one `rlink` and/or `base64` field is present in a resource,
FedRAMP's automated processing tools will attempt to find valid content
using the following priority, unless specified otherwise:

1.  FedRAMP tools will look first in `base64` fields

    a.  Start with the first `base64` field in the resource.

    b.  Check each `base64` field in the sequence in which they appear in
        the `resource`.

    c.  If valid content is found, stop looking and use the content.

    d.  If no valid content is found after checking all `base64` fields in
        the resource, proceed to step #2.

2.  If no valid base64 content is found, look in `rlink` fields.

    a.  Start with the first `rlink` field in the resource.

    b.  Check each `rlink` field in the sequence in which they appear in
        the `resource`.

    c.  If valid content is found, stop looking and use the content.

    d.  If no valid content is found after checking all `rlink` fields,
        treat the resource as invalid, which may include raising a
        warning or error message.

### 2.7.5. Citation and Attachment Details

IMPORTANT: As of 1.0.0, NIST includes `type`, `version`, and `published`
properties as part of core OSCAL, eliminating the requirement to treat
this content as FedRAMP Extensions.

For policies, plans, user guides, and other documents, FedRAMP requires
the document's title, version, and publication date.

The following example demonstrates the inclusion of this content within
a resource.
  {{< highlight xml "linenos=table" >}}
  <back-matter>
    <resource uuid="3df7eeea-421b-459d-98cf-3d972bec610a">
        <title>Attachment or Document Title</title>
        <prop name="type" value="policy"/>
        <prop name="version" value="2.1"/>
        <prop name="published" value="2018-11-11T00:00:00Z"/>
        <base64>0000000</base64>
        <rlink href="./rel/path/doc.pdf" media-type="application/pdf" />
        <rlink href="/absolute/path/doc.pdf" media-type="application/pdf"
        />
    </resource>
  </back-matter>
  {{< /highlight >}}

### 2.7.6. Citation and Attachment Conformity

IMPORTANT: As of 1.0.0, NIST includes many aspects of OSCAL previously
only possible with conformity tags. For citations and attachments,
FedRAMP now uses a combination of the resource "type" property, and
link statements from relevant portions of the OSCAL content.

The following represents an example linking a policy directly to the
control it satisfies. (Legacy approach)

  {{< highlight xml "linenos=table" >}}
  <control-implementation>
    <implemented-requirement control-id='ac-1'
    uuid="[uuid-value]">
        <statement>
            <link href="#090ab379-2089-4830-b9fd-26d0729e22e9"
        rel="policy" />
        </statement>
    </implemented-requirement>
  </control-implementation>
  
  <back-matter>
    <resource uuid="090ab379-2089-4830-b9fd-26d0729e22e9">
        <title>Access Control and Identity Management Policy</title>
        <description>
        <p>Policy Document.</p>
        </description>
        <prop name="type" value="policy"/>
        <base64 filename="./documents/policies/sample_policy.pdf">
        0000
        </base64>
    </resource>
  </back-matter>
  {{< /highlight >}}

The following represents an example linking a policy to the control it
satisfies via the preferred component-based approach.
  {{< highlight xml "linenos=table" >}}
  <system-implementation>
    <component uuid="f25e84bf-3e57-48c3-ac0b-7a567b3af79e"
    type="policy">
        <title>[EXAMPLE]Access Control and Identity Management
        Policy</title>
        <description>
            <p>[EXAMPLE]An example component representing a policy.</p>
        </description>
        <link href="#090ab379-2089-4830-b9fd-26d0729e22e9" rel="policy"
        />
        <status state="operational"/>
    </component>
  </system-implementation>
  
  <control-implementation>
    <implemented-requirement control-id="ac-1"
    uuid="[uuid-value]">
        <statement statement-id="ac-1_smt.a"
        uuid="fb4d039a-dc4f-46f5-9c1f-f6343eaf69bc">
            <by-component
            component-uuid="f25e84bf-3e57-48c3-ac0b-7a567b3af79e">
                <description>
                    <p>Describe how statement a is satisfied by this policy.</p>
                </description>
            </by-component>
        </statement>
    </implemented-requirement>
  </control-implementation>
  
  <back-matter>
    <resource uuid="090ab379-2089-4830-b9fd-26d0729e22e9">
        <title>Access Control and Identity Management Policy</title>
        <description>
        <p>Policy Document.</p>
        </description>
        <prop name="type">policy</prop>
        <base64
        filename="./documents/policies/sample_policy.pdf">0000</base64>
    </resource>
  </back-matter>
  {{< /highlight >}}

