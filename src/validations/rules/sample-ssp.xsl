<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    exclude-result-prefixes="xs math uuid expath oscal"
    version="3.0"
    xmlns:expath="http://expath.org/ns/binary"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns:uuid="java.util.UUID"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">
    <!-- 
        This transform will produce a FedRAMP OSCAL SSP.
        Input to the transform is one of the resolved FedRAMP baselines (catalogs), namely
            FedRAMP_rev4_LOW-baseline-resolved-profile_catalog.xml
            FedRAMP_rev4_MODERATE-baseline-resolved-profile_catalog.xml
            FedRAMP_rev4_HIGH-baseline-resolved-profile_catalog.xml
    -->
    <xsl:param
        as="xs:boolean"
        name="insert-diagrams"
        required="false"
        select="false()" />
    <xsl:mode
        on-no-match="fail" />
    <xsl:output
        indent="false"
        method="xml" />
    <xsl:variable
        as="xs:string"
        name="user-uuid"
        select="uuid:randomUUID()" />
    <xsl:variable
        as="xs:string"
        name="component-uuid"
        select="uuid:randomUUID()" />
    <xsl:variable
        as="xs:string*"
        name="statuses"
        select="
            (
            'implemented',
            'partial',
            'planned',
            'alternative',
            'not-applicable'
            )" />
    <xsl:variable
        as="xs:string"
        name="authorization-boundary-diagram-uuid"
        select="uuid:randomUUID()" />
    <xsl:variable
        as="xs:string"
        name="authorization-boundary-diagram-resource-uuid"
        select="uuid:randomUUID()" />
    <xsl:variable
        as="xs:string"
        name="network-architecture-diagram-uuid"
        select="uuid:randomUUID()" />
    <xsl:variable
        as="xs:string"
        name="network-architecture-diagram-resource-uuid"
        select="uuid:randomUUID()" />
    <xsl:variable
        as="xs:string"
        name="data-flow-diagram-uuid"
        select="uuid:randomUUID()" />
    <xsl:variable
        as="xs:string"
        name="data-flow-diagram-resource-uuid"
        select="uuid:randomUUID()" />
    <xsl:variable
        as="xs:string"
        name="LF"
        select="'&#x0a;'" />
    <xsl:template
        match="/">
        <xsl:copy-of
            select="$LF" />
        <xsl:comment expand-text="true">This document used {base-uri()} as the input.</xsl:comment>
        <xsl:copy-of
            select="$LF" />
        <xsl:comment expand-text="true">This document used {static-base-uri()} as the transform.</xsl:comment>
        <xsl:copy-of
            select="$LF" />
        <xsl:processing-instruction name="xml-model"> href="https://raw.githubusercontent.com/usnistgov/OSCAL/release-1.0/xml/schema/oscal_complete_schema.xsd" schematypens="http://www.w3.org/2001/XMLSchema" title="OSCAL complete schema"</xsl:processing-instruction>
        <!--<xsl:processing-instruction name="xml-model"> href="https://raw.githubusercontent.com/18F/fedramp-automation/master/resources/validations/src/ssp.sch" schematypens="http://purl.oclc.org/dsdl/schematron" title="FedRAMP SSP constraints"</xsl:processing-instruction>-->
        <!--<xsl:processing-instruction name="xml-model"> href="file:/Users/gapinski/branches/fedramp-automation/resources/validations/src/ssp.sch" schematypens="http://purl.oclc.org/dsdl/schematron" title="FedRAMP SSP constraints"</xsl:processing-instruction>-->
        <!--<xsl:processing-instruction name="xml-model"> href="file:/Users/gapinski/branches/fedramp-automation/resources/validations/src/ssp-test.sch" schematypens="http://purl.oclc.org/dsdl/schematron" title="FedRAMP SSP constraints"</xsl:processing-instruction>-->
        <xsl:text disable-output-escaping="true">&#x0a;&lt;!--&lt;?xml-model href=&quot;file:/Users/gapinski/branches/fedramp-automation/resources/validations/src/ssp.sch&quot; schematypens=&quot;http://purl.oclc.org/dsdl/schematron&quot; title=&quot;FedRAMP SSP constraints&quot;?&gt;--&gt;&#x0a;</xsl:text>
        <xsl:variable
            as="xs:string"
            name="control-role">implemented-requirement-responsible-role</xsl:variable>
        <system-security-plan
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">

            <xsl:attribute
                name="uuid"
                select="uuid:randomUUID()" />

            <metadata>
                <title>
                    <xsl:text>DRAFT, SAMPLE </xsl:text>
                    <xsl:value-of
                        select="/catalog/metadata/title" />
                    <xsl:text> System Security Plan</xsl:text>
                </title>
                <last-modified>
                    <xsl:value-of
                        select="current-dateTime()" />
                </last-modified>
                <version>0.1</version>
                <oscal-version>1.0.0</oscal-version>

                <!-- roles -->
                <!-- ISO -->
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.6</xsl:comment>
                <role
                    id="system-owner">
                    <title>Information System Owner</title>
                    <short-name>ISO</short-name>
                </role>
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.7</xsl:comment>
                <role
                    id="authorizing-official">
                    <title>Authorizing Official</title>
                    <short-name>AO</short-name>
                </role>
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.8</xsl:comment>
                <role
                    id="system-poc-management">
                    <title>Information System Management Point of Contact</title>
                    <short-name>ISMPoC</short-name>
                </role>
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.9</xsl:comment>
                <role
                    id="system-poc-technical">
                    <title>Information System Technical Point of Contact</title>
                    <short-name>ISTPoC</short-name>
                </role>
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.9</xsl:comment>
                <role
                    id="system-poc-other">
                    <title>Information System Other Point of Contact</title>
                    <short-name>ISOPoC</short-name>
                </role>
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.10</xsl:comment>
                <role
                    id="information-system-security-officer">
                    <title>Information System Security Officer</title>
                    <short-name>ISSO</short-name>
                </role>
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.11</xsl:comment>
                <role
                    id="authorizing-official-poc">
                    <title>Authorizing Official (AO) PoC</title>
                    <short-name>AOPoC</short-name>
                </role>

                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2</xsl:comment>
                <role
                    id="{$control-role}">
                    <title>Implemented Control Responsibility Role</title>
                </role>

                <!-- location(s) -->
                <xsl:variable
                    as="xs:string"
                    name="location-uuid"
                    select="uuid:randomUUID()" />
                <location
                    uuid="{$location-uuid}">
                    <address />
                </location>

                <!-- organization(s) -->
                <!-- CSP -->
                <xsl:variable
                    as="xs:string"
                    name="csp-uuid"
                    select="uuid:randomUUID()" />
                <party
                    type="organization"
                    uuid="{$csp-uuid}">
                    <name>Cloud Service Provider (CSP) Name</name>
                </party>

                <!-- parties -->
                <!-- ISO -->
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.6</xsl:comment>
                <xsl:variable
                    as="xs:string"
                    name="ISO-uuid"
                    select="uuid:randomUUID()" />
                <party
                    type="person"
                    uuid="">
                    <xsl:attribute
                        name="uuid"
                        select="$ISO-uuid" />
                    <name>name</name>
                    <email-address>name@example.com</email-address>
                    <telephone-number>+1-303-499-7111</telephone-number>
                    <location-uuid>
                        <xsl:value-of
                            select="$location-uuid" />
                    </location-uuid>
                    <member-of-organization>
                        <xsl:value-of
                            select="$csp-uuid" />
                    </member-of-organization>
                </party>
                <!-- AO -->
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.7</xsl:comment>
                <xsl:variable
                    as="xs:string"
                    name="AO-uuid"
                    select="uuid:randomUUID()" />
                <party
                    type="person"
                    uuid="">
                    <xsl:attribute
                        name="uuid"
                        select="$AO-uuid" />
                    <name>name</name>
                    <email-address>name@example.com</email-address>
                    <telephone-number>+1-303-499-7111</telephone-number>
                    <location-uuid>
                        <xsl:value-of
                            select="$location-uuid" />
                    </location-uuid>
                    <member-of-organization>
                        <xsl:value-of
                            select="$csp-uuid" />
                    </member-of-organization>
                </party>
                <!-- ISMPoC -->
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.8</xsl:comment>
                <xsl:variable
                    as="xs:string"
                    name="ISMPoC-uuid"
                    select="uuid:randomUUID()" />
                <party
                    type="person"
                    uuid="">
                    <xsl:attribute
                        name="uuid"
                        select="$ISMPoC-uuid" />
                    <name>name</name>
                    <email-address>name@example.com</email-address>
                    <telephone-number>+1-303-499-7111</telephone-number>
                    <location-uuid>
                        <xsl:value-of
                            select="$location-uuid" />
                    </location-uuid>
                    <member-of-organization>
                        <xsl:value-of
                            select="$csp-uuid" />
                    </member-of-organization>
                </party>
                <!-- ISTPoC -->
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.9</xsl:comment>
                <xsl:variable
                    as="xs:string"
                    name="ISTPoC-uuid"
                    select="uuid:randomUUID()" />
                <party
                    type="person"
                    uuid="">
                    <xsl:attribute
                        name="uuid"
                        select="$ISTPoC-uuid" />
                    <name>name</name>
                    <email-address>name@example.com</email-address>
                    <telephone-number>+1-303-499-7111</telephone-number>
                    <location-uuid>
                        <xsl:value-of
                            select="$location-uuid" />
                    </location-uuid>
                    <member-of-organization>
                        <xsl:value-of
                            select="$csp-uuid" />
                    </member-of-organization>
                </party>
                <!-- ISOPoC -->
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.9</xsl:comment>
                <xsl:variable
                    as="xs:string"
                    name="ISOPoC-uuid"
                    select="uuid:randomUUID()" />
                <party
                    type="person"
                    uuid="">
                    <xsl:attribute
                        name="uuid"
                        select="$ISOPoC-uuid" />
                    <name>name</name>
                    <email-address>name@example.com</email-address>
                    <telephone-number>+1-303-499-7111</telephone-number>
                    <location-uuid>
                        <xsl:value-of
                            select="$location-uuid" />
                    </location-uuid>
                    <member-of-organization>
                        <xsl:value-of
                            select="$csp-uuid" />
                    </member-of-organization>
                </party>
                <!-- ISSO -->
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.10</xsl:comment>
                <xsl:variable
                    as="xs:string"
                    name="ISSO-uuid"
                    select="uuid:randomUUID()" />
                <party
                    type="person"
                    uuid="">
                    <xsl:attribute
                        name="uuid"
                        select="$ISSO-uuid" />
                    <name>name</name>
                    <email-address>name@example.com</email-address>
                    <telephone-number>+1-303-499-7111</telephone-number>
                    <location-uuid>
                        <xsl:value-of
                            select="$location-uuid" />
                    </location-uuid>
                    <member-of-organization>
                        <xsl:value-of
                            select="$csp-uuid" />
                    </member-of-organization>
                </party>
                <!-- AOPoC -->
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.11</xsl:comment>
                <xsl:variable
                    as="xs:string"
                    name="AOPoC-uuid"
                    select="uuid:randomUUID()" />
                <party
                    type="person"
                    uuid="">
                    <xsl:attribute
                        name="uuid"
                        select="$AOPoC-uuid" />
                    <name>name</name>
                    <email-address>name@example.com</email-address>
                    <telephone-number>+1-303-499-7111</telephone-number>
                    <location-uuid>
                        <xsl:value-of
                            select="$location-uuid" />
                    </location-uuid>
                    <member-of-organization>
                        <xsl:value-of
                            select="$csp-uuid" />
                    </member-of-organization>
                </party>

                <!-- irrr -->
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2</xsl:comment>
                <xsl:variable
                    as="xs:string"
                    name="irrr-uuid"
                    select="uuid:randomUUID()" />
                <party
                    type="person"
                    uuid="">
                    <xsl:attribute
                        name="uuid"
                        select="$irrr-uuid" />
                    <name>name</name>
                    <email-address>name@example.com</email-address>
                    <telephone-number>+1-303-499-7111</telephone-number>
                    <location-uuid>
                        <xsl:value-of
                            select="$location-uuid" />
                    </location-uuid>
                    <member-of-organization>
                        <xsl:value-of
                            select="$csp-uuid" />
                    </member-of-organization>
                </party>

                <!-- ISO -->
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.6</xsl:comment>
                <responsible-party
                    role-id="system-owner">
                    <party-uuid>
                        <xsl:value-of
                            select="$ISO-uuid" />
                    </party-uuid>
                </responsible-party>
                <!-- AO -->
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.7</xsl:comment>
                <responsible-party
                    role-id="authorizing-official">
                    <party-uuid>
                        <xsl:value-of
                            select="$AO-uuid" />
                    </party-uuid>
                </responsible-party>
                <!-- ISMPoC -->
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.8</xsl:comment>
                <responsible-party
                    role-id="system-poc-management">
                    <party-uuid>
                        <xsl:value-of
                            select="$ISMPoC-uuid" />
                    </party-uuid>
                </responsible-party>
                <!-- ISTPoC -->
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.9</xsl:comment>
                <responsible-party
                    role-id="system-poc-technical">
                    <party-uuid>
                        <xsl:value-of
                            select="$ISTPoC-uuid" />
                    </party-uuid>
                </responsible-party>
                <!-- ISOPoC -->
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.9</xsl:comment>
                <responsible-party
                    role-id="system-poc-other">
                    <party-uuid>
                        <xsl:value-of
                            select="$ISOPoC-uuid" />
                    </party-uuid>
                </responsible-party>
                <!-- ISSO -->
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.10</xsl:comment>
                <responsible-party
                    role-id="information-system-security-officer">
                    <party-uuid>
                        <xsl:value-of
                            select="$ISSO-uuid" />
                    </party-uuid>
                </responsible-party>
                <!-- AOPoC -->
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.11</xsl:comment>
                <responsible-party
                    role-id="authorizing-official-poc">
                    <party-uuid>
                        <xsl:value-of
                            select="$AOPoC-uuid" />
                    </party-uuid>
                </responsible-party>

                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2</xsl:comment>
                <responsible-party
                    role-id="{$control-role}">
                    <party-uuid>
                        <xsl:value-of
                            select="$irrr-uuid" />
                    </party-uuid>
                </responsible-party>

            </metadata>
            <import-profile>
                <xsl:attribute
                    expand-text="true"
                    name="href">{//link[@rel='resolution-source']/@href}</xsl:attribute>
            </import-profile>
            <system-characteristics>
                <system-id
                    identifier-type="https://fedramp.gov">F00000000</system-id>
                <system-name>Sample SSP</system-name>
                <system-name-short>SSSP</system-name-short>
                <description>
                    <p>This system description is not 32 words in length.</p>
                </description>
                <prop
                    name="authorization-type"
                    ns="https://fedramp.gov/ns/oscal"
                    value="fedramp-agency" />
                <prop
                    name="users-internal"
                    ns="https://fedramp.gov/ns/oscal"
                    value="1" />
                <prop
                    name="users-external"
                    ns="https://fedramp.gov/ns/oscal"
                    value="1" />
                <prop
                    name="users-internal-future"
                    ns="https://fedramp.gov/ns/oscal"
                    value="1" />
                <prop
                    name="users-external-future"
                    ns="https://fedramp.gov/ns/oscal"
                    value="1" />
                <prop
                    name="cloud-service-model"
                    value="saas" />
                <prop
                    name="cloud-deployment-model"
                    value="public-cloud" />
                <prop
                    name="authorization-type"
                    ns="https://fedramp.gov/ns/oscal"
                    value="fedramp-agency" />
                <prop
                    class="security-eauth"
                    name="security-eauth-level"
                    ns="https://fedramp.gov/ns/oscal"
                    value="2" />
                <security-sensitivity-level>
                    <xsl:choose>
                        <xsl:when
                            test="matches(base-uri(), 'LOW')">
                            <xsl:text>fips-199-low</xsl:text>
                        </xsl:when>
                        <xsl:when
                            test="matches(base-uri(), 'MODERATE')">
                            <xsl:text>fips-199-moderate</xsl:text>
                        </xsl:when>
                        <xsl:when
                            test="matches(base-uri(), 'HIGH')">
                            <xsl:text>fips-199-high</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </security-sensitivity-level>
                <system-information>
                    <xsl:comment> Attachment 4, PTA/PIA Designation </xsl:comment>
                    <prop
                        name="privacy-sensitive"
                        value="yes" />
                    <xsl:comment> Attachment 4, PTA Qualifying Questions </xsl:comment>
                    <!--Does the ISA collect, maintain, or share PII in any identifiable form? -->
                    <prop
                        class="pta"
                        name="pta-1"
                        ns="https://fedramp.gov/ns/oscal"
                        value="yes" />
                    <xsl:comment> Does the ISA collect, maintain, or share PII information from or about the public? </xsl:comment>
                    <prop
                        class="pta"
                        name="pta-2"
                        ns="https://fedramp.gov/ns/oscal"
                        value="yes" />
                    <xsl:comment> Has a Privacy Impact Assessment ever been performed for the ISA? </xsl:comment>
                    <prop
                        class="pta"
                        name="pta-3"
                        ns="https://fedramp.gov/ns/oscal"
                        value="yes" />
                    <xsl:comment> Is there a Privacy Act System of Records Notice (SORN) for this ISA system? (If so, please specify the SORN ID.) </xsl:comment>
                    <prop
                        class="pta"
                        name="pta-4"
                        ns="https://fedramp.gov/ns/oscal"
                        value="no" />
                    <prop
                        class="pta"
                        name="sorn-id"
                        ns="https://fedramp.gov/ns/oscal"
                        value="[No SORN ID]" />
                    <information-type>
                        <xsl:attribute
                            name="uuid"
                            select="uuid:randomUUID()" />
                        <title />
                        <description />
                        <categorization
                            system="https://doi.org/10.6028/NIST.SP.800-60v2r1">
                            <information-type-id>C.2.4.1</information-type-id>
                        </categorization>
                        <confidentiality-impact>
                            <base>fips-199-moderate</base>
                            <selected>fips-199-moderate</selected>
                            <adjustment-justification>
                                <p>Required if the base and selected values do not match.</p>
                            </adjustment-justification>
                        </confidentiality-impact>
                        <integrity-impact>
                            <base>fips-199-moderate</base>
                            <selected>fips-199-moderate</selected>
                            <adjustment-justification>
                                <p>Required if the base and selected values do not match.</p>
                            </adjustment-justification>
                        </integrity-impact>
                        <availability-impact>
                            <base>fips-199-moderate</base>
                            <selected>fips-199-moderate</selected>
                            <adjustment-justification>
                                <p>Required if the base and selected values do not match.</p>
                            </adjustment-justification>
                        </availability-impact>
                    </information-type>
                </system-information>
                <security-impact-level>
                    <security-objective-confidentiality>fips-199-moderate</security-objective-confidentiality>
                    <security-objective-integrity>fips-199-moderate</security-objective-integrity>
                    <security-objective-availability>fips-199-moderate</security-objective-availability>
                </security-impact-level>
                <status
                    state="operational" />
                <authorization-boundary>
                    <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17</xsl:comment>
                    <description />
                    <diagram
                        uuid="{$authorization-boundary-diagram-uuid}">
                        <description />
                        <link
                            href="#{$authorization-boundary-diagram-resource-uuid}"
                            rel="diagram" />
                        <caption />
                    </diagram>
                </authorization-boundary>
                <network-architecture>
                    <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22</xsl:comment>
                    <description />
                    <diagram
                        uuid="{$network-architecture-diagram-uuid}">
                        <description />
                        <link
                            href="#{$network-architecture-diagram-resource-uuid}"
                            rel="diagram" />
                        <caption />
                    </diagram>
                </network-architecture>
                <data-flow>
                    <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24</xsl:comment>
                    <description />
                    <diagram
                        uuid="{$data-flow-diagram-uuid}">
                        <description />
                        <link
                            href="#{$data-flow-diagram-resource-uuid}"
                            rel="diagram" />
                        <caption />
                    </diagram>
                </data-flow>
            </system-characteristics>

            <system-implementation>
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.19</xsl:comment>
                <prop
                    name="users-internal"
                    ns="https://fedramp.gov/ns/oscal"
                    value="0" />
                <prop
                    name="users-external"
                    ns="https://fedramp.gov/ns/oscal"
                    value="0" />
                <prop
                    name="users-internal-future"
                    ns="https://fedramp.gov/ns/oscal"
                    value="0" />
                <prop
                    name="users-external-future"
                    ns="https://fedramp.gov/ns/oscal"
                    value="0" />
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2</xsl:comment>
                <user
                    uuid="{$user-uuid}">
                    <prop
                        name="type"
                        value="internal" />
                    <prop
                        name="privilege-level"
                        value="privileged" />
                    <prop
                        name="sensitivity"
                        ns="https://fedramp.gov/ns/oscal"
                        value="moderate" />
                    <role-id>
                        <xsl:value-of
                            select="$control-role" />
                    </role-id>
                    <authorized-privilege>
                        <title>title</title>
                        <function-performed>function</function-performed>
                    </authorized-privilege>
                </user>
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans Appendix A</xsl:comment>
                <component
                    type="validation"
                    uuid="772ea84a-0d4e-4225-b82f-66fdc498a934">
                    <title>FIPS 140-2 Validation</title>
                    <description>
                        <p>FIPS 140-2 Validation</p>
                    </description>
                    <prop
                        name="validation-reference"
                        value="3928" />
                    <link
                        href="https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/3928"
                        rel="validation-details" />
                    <status
                        state="active" />
                </component>
                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.4.6</xsl:comment>
                <component
                    type="this-system"
                    uuid="">
                    <xsl:attribute
                        name="uuid"
                        select="$component-uuid" />
                    <title />
                    <description>
                        <p>This component is the answer to almost everything</p>
                    </description>
                    <status
                        state="operational" />
                </component>
            </system-implementation>

            <control-implementation>
                <description />
                <xsl:for-each
                    select="//control">
                    <implemented-requirement>
                        <xsl:attribute
                            name="control-id"
                            select="@id" />
                        <xsl:attribute
                            name="uuid"
                            select="uuid:randomUUID()" />
                        <xsl:comment expand-text="true">{title}</xsl:comment>
                        <xsl:variable
                            as="xs:integer"
                            expand-text="true"
                            name="r">{floor(random-number-generator(generate-id())?number * 100 ) + 1}</xsl:variable>
                        <xsl:variable
                            as="xs:integer"
                            name="w">
                            <xsl:choose>
                                <xsl:when
                                    test="$r gt 5">
                                    <xsl:value-of
                                        select="1" />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                        select="$r" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable
                            as="xs:string"
                            name="status"
                            select="$statuses[$w]" />
                        <prop
                            name="control-origination"
                            ns="https://fedramp.gov/ns/oscal"
                            value="sp-system" />
                        <prop
                            name="implementation-status"
                            ns="https://fedramp.gov/ns/oscal"
                            value="{$status}">
                            <xsl:choose>
                                <xsl:when
                                    test="$status = 'planned'">
                                    <remarks>
                                        <p>A description of the plan to complete implementation.</p>
                                    </remarks>
                                </xsl:when>
                                <xsl:when
                                    test="$status = 'partial'">
                                    <remarks>
                                        <p>A description the portion of the control that is not satisfied.</p>
                                    </remarks>
                                </xsl:when>
                                <xsl:when
                                    test="$status = 'not-applicable'">
                                    <remarks>
                                        <p>An explanation of why the control is not applicable.</p>
                                    </remarks>
                                </xsl:when>
                                <xsl:when
                                    test="$status = 'alternative'">
                                    <remarks>
                                        <p>A description of the alternative control.</p>
                                    </remarks>
                                </xsl:when>
                            </xsl:choose>
                        </prop>
                        <xsl:if
                            test="$status = 'planned'">
                            <prop
                                name="planned-completion-date"
                                ns="https://fedramp.gov/ns/oscal"
                                value="2021-09-22Z" />
                        </xsl:if>
                        <xsl:comment>
                            <xsl:choose>
                                <xsl:when test="count(param) gt 2">
                                    <xsl:text expand-text="true">There are {count(param)} control parameters</xsl:text>
                                </xsl:when>
                                <xsl:when test="count(param) eq 1">
                                    <xsl:text expand-text="true">There is {count(param)} control parameter</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>There are no control parameters</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:comment>
                        <xsl:for-each
                            select="param">
                            <set-parameter
                                param-id="{@id}">
                                <value>
                                    <xsl:choose>
                                        <xsl:when
                                            test="label">
                                            <xsl:value-of
                                                select="normalize-space(label)" />
                                        </xsl:when>
                                        <xsl:when
                                            test="
                                                some $choice in select//choice
                                                    satisfies $choice/insert">
                                            <xsl:text>it's complicated by parameter inserts</xsl:text>
                                        </xsl:when>
                                        <xsl:when
                                            test="select[@how-many]">
                                            <xsl:text expand-text="true">{select/@how-many} of {string-join(select/choice[not(insert)],', ')}</xsl:text>
                                        </xsl:when>
                                        <xsl:when
                                            test="select">
                                            <xsl:text expand-text="true">one of {string-join(select/choice[not(insert)],' or ')}</xsl:text>
                                        </xsl:when>
                                    </xsl:choose>
                                </value>
                                <xsl:if
                                    test="constraint">
                                    <xsl:comment expand-text="true">Constraint: {normalize-space(constraint)}></xsl:comment>
                                </xsl:if>
                            </set-parameter>
                        </xsl:for-each>
                        <!--See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2-->
                        <responsible-role
                            role-id="{$control-role}" />
                        <xsl:comment>
                            <xsl:text>Required response points are: </xsl:text>
                            <xsl:value-of select="descendant::prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'response-point']/parent::part/@id[matches(., 'smt')]" separator=", " />
                        </xsl:comment>
                        <xsl:apply-templates
                            select="part" />
                    </implemented-requirement>
                </xsl:for-each>
            </control-implementation>
            <back-matter>
                <resource>
                    <xsl:attribute
                        name="uuid"
                        select="$authorization-boundary-diagram-resource-uuid" />
                    <title>
                        <xsl:value-of
                            select="'Authorization Boundary Diagram'" />
                    </title>
                    <description />
                    <prop
                        name="type"
                        value="diagram" />
                    <rlink
                        href="sample-ssp-authorization-boundary-diagram.graphml" />
                    <base64
                        filename="sample-ssp-authorization-boundary-diagram.graphml"
                        media-type="text/xml">
                        <xsl:choose>
                            <xsl:when
                                test="$insert-diagrams">
                                <xsl:copy-of
                                    select="expath:encode-string(doc(resolve-uri('sample-ssp-authorization-boundary-diagram.graphml', static-base-uri())))" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="expath:encode-string('elided Authorization Boundary Diagram')" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </base64>
                </resource>
                <resource>
                    <xsl:attribute
                        name="uuid"
                        select="$network-architecture-diagram-resource-uuid" />
                    <title>
                        <xsl:value-of
                            select="'Network Architecture Diagram'" />
                    </title>
                    <description />
                    <prop
                        name="type"
                        value="diagram" />
                    <rlink
                        href="sample-ssp-network-architecture-diagram.graphml" />
                    <base64
                        filename="sample-ssp-network-architecture-diagram.graphml"
                        media-type="text/xml">
                        <xsl:choose>
                            <xsl:when
                                test="$insert-diagrams">
                                <xsl:copy-of
                                    select="expath:encode-string(doc(resolve-uri('sample-ssp-network-architecture-diagram.graphml', static-base-uri())))" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="expath:encode-string('elided Network Architecture Diagram')" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </base64>
                </resource>
                <resource>
                    <xsl:attribute
                        name="uuid"
                        select="$data-flow-diagram-resource-uuid" />
                    <title>
                        <xsl:value-of
                            select="'Data Flow Diagram'" />
                    </title>
                    <description />
                    <prop
                        name="type"
                        value="diagram" />
                    <rlink
                        href="sample-ssp-data-flow-diagram.graphml" />
                    <base64
                        filename="sample-ssp-data-flow-diagram.graphml"
                        media-type="text/xml">
                        <xsl:choose>
                            <xsl:when
                                test="$insert-diagrams">
                                <xsl:copy-of
                                    select="expath:encode-string(doc(resolve-uri('sample-ssp-data-flow-diagram.graphml', static-base-uri())))" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="expath:encode-string('elided Data Flow Diagram')" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </base64>
                </resource>
                <xsl:for-each
                    select="//control[matches(@id, '-1$')]">
                    <xsl:comment expand-text="true">{parent::group/title} Policy and Procedures attachments</xsl:comment>
                    <resource>
                        <xsl:attribute
                            name="uuid"
                            select="uuid:randomUUID()" />
                        <xsl:variable
                            as="xs:string"
                            expand-text="true"
                            name="text">{prop[@name = 'label']/@value} {title} - Policy</xsl:variable>
                        <title>
                            <xsl:value-of
                                select="$text" />
                        </title>
                        <prop
                            name="type"
                            value="policy" />
                        <rlink
                            href="SSSP-A1-ISPP-{@id}-policy.txt" />
                        <base64
                            filename="SSSP-A1-ISPP-{@id}-policy.txt"
                            media-type="text/plain">
                            <xsl:value-of
                                select="expath:encode-string($text)" />
                        </base64>
                    </resource>
                    <resource>
                        <xsl:attribute
                            name="uuid"
                            select="uuid:randomUUID()" />
                        <xsl:variable
                            as="xs:string"
                            expand-text="true"
                            name="text">{prop[@name = 'label']/@value} {title} - Procedures</xsl:variable>
                        <title>
                            <xsl:value-of
                                select="$text" />
                        </title>
                        <prop
                            name="type"
                            value="procedure" />
                        <rlink
                            href="SSSP-A1-ISPP-{@id}-procedures.txt" />
                        <base64
                            filename="SSSP-A1-ISPP-{@id}-procedures.txt"
                            media-type="text/plain">
                            <xsl:value-of
                                select="expath:encode-string($text)" />
                        </base64>
                    </resource>
                </xsl:for-each>
                <resource>
                    <xsl:attribute
                        name="uuid"
                        select="uuid:randomUUID()" />
                    <title>User Guide</title>
                    <rlink
                        href="SSSP-A2-UG.txt" />
                    <base64
                        filename="SSSP-A2-UG.txt"
                        media-type="text/plain">
                        <xsl:value-of
                            select="expath:encode-string('User Guide')" />
                    </base64>
                </resource>
                <resource>
                    <xsl:attribute
                        name="uuid"
                        select="uuid:randomUUID()" />
                    <title>Privacy Impact Analysis</title>
                    <rlink
                        href="SSSP-A4-PIA.txt" />
                    <base64
                        filename="SSSP-A4-PIA.txt"
                        media-type="text/plain">
                        <xsl:value-of
                            select="expath:encode-string('Privacy Impact Analysis')" />
                    </base64>
                </resource>
                <resource>
                    <xsl:attribute
                        name="uuid"
                        select="uuid:randomUUID()" />
                    <title>Rules of Behavior</title>
                    <rlink
                        href="SSSP-A5-ROB.txt" />
                    <base64
                        filename="SSSP-A5-ROB.txt"
                        media-type="text/plain">
                        <xsl:value-of
                            select="expath:encode-string('Rules of Behavior')" />
                    </base64>
                </resource>
                <resource>
                    <xsl:attribute
                        name="uuid"
                        select="uuid:randomUUID()" />
                    <title>Information System Contingency Plan</title>
                    <rlink
                        href="SSSP-A6-ISCP.txt" />
                    <base64
                        filename="SSSP-A6-ISCP.txt"
                        media-type="text/plain">
                        <xsl:value-of
                            select="expath:encode-string('Information System Contingency Plan')" />
                    </base64>
                </resource>
                <resource>
                    <xsl:attribute
                        name="uuid"
                        select="uuid:randomUUID()" />
                    <title>Configuration Management Plan</title>
                    <rlink
                        href="SSSP-A7-CMP.txt" />
                    <base64
                        filename="SSSP-A7-CMP.txt"
                        media-type="text/plain">
                        <xsl:value-of
                            select="expath:encode-string('Configuration Management Plan')" />
                    </base64>
                </resource>
                <resource>
                    <xsl:attribute
                        name="uuid"
                        select="uuid:randomUUID()" />
                    <title>Incident Response Plan</title>
                    <rlink
                        href="SSSP-A8-IRP.txt" />
                    <base64
                        filename="SSSP-A8-IRP.txt"
                        media-type="text/plain">
                        <xsl:value-of
                            select="expath:encode-string('Incident Response Plan')" />
                    </base64>
                </resource>
                <resource>
                    <xsl:attribute
                        name="uuid"
                        select="uuid:randomUUID()" />
                    <title>CIS Workbook</title>
                    <rlink
                        href="SSSP-A9-CIS-Workbook.txt" />
                    <base64
                        filename="SSSP-A9-CIS-Workbook.txt"
                        media-type="text/plain">
                        <xsl:value-of
                            select="expath:encode-string('CIS Workbook')" />
                    </base64>
                </resource>
                <resource>
                    <xsl:attribute
                        name="uuid"
                        select="uuid:randomUUID()" />
                    <title>Inventory</title>
                    <rlink
                        href="SSSP-A13-INV.txt" />
                    <base64
                        filename="SSSP-A13-INV.txt"
                        media-type="text/plain">
                        <xsl:value-of
                            select="expath:encode-string('Inventory')" />
                    </base64>
                </resource>
            </back-matter>
        </system-security-plan>
    </xsl:template>

    <xsl:template
        match="part[@name = 'statement']">
        <xsl:choose>
            <xsl:when
                test="prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'response-point']">
                <xsl:element
                    name="statement"
                    namespace="http://csrc.nist.gov/ns/oscal/1.0">
                    <xsl:attribute
                        name="statement-id"
                        select="@id" />
                    <xsl:attribute
                        name="uuid"
                        select="uuid:randomUUID()" />
                    <xsl:element
                        name="by-component"
                        namespace="http://csrc.nist.gov/ns/oscal/1.0">
                        <xsl:attribute
                            name="uuid"
                            select="uuid:randomUUID()" />
                        <xsl:attribute
                            name="component-uuid"
                            select="$component-uuid" />
                        <xsl:element
                            name="description"
                            namespace="http://csrc.nist.gov/ns/oscal/1.0">
                            <xsl:element
                                name="p"
                                namespace="http://csrc.nist.gov/ns/oscal/1.0">This description is more than 20 characters in length</xsl:element>
                        </xsl:element>
                        <xsl:element
                            name="remarks"
                            namespace="http://csrc.nist.gov/ns/oscal/1.0">
                            <xsl:element
                                name="p"
                                namespace="http://csrc.nist.gov/ns/oscal/1.0">
                                <xsl:value-of
                                    select="oscal:p" />
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
        <xsl:apply-templates
            select="part" />
    </xsl:template>

    <xsl:template
        match="part[@name = 'item']">
        <xsl:choose>
            <xsl:when
                test="prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'response-point']">
                <xsl:element
                    name="statement"
                    namespace="http://csrc.nist.gov/ns/oscal/1.0">
                    <xsl:attribute
                        name="statement-id"
                        select="@id" />
                    <xsl:attribute
                        name="uuid"
                        select="uuid:randomUUID()" />
                    <xsl:element
                        name="by-component"
                        namespace="http://csrc.nist.gov/ns/oscal/1.0">
                        <xsl:attribute
                            name="uuid"
                            select="uuid:randomUUID()" />
                        <xsl:attribute
                            name="component-uuid"
                            select="$component-uuid" />
                        <xsl:element
                            name="description"
                            namespace="http://csrc.nist.gov/ns/oscal/1.0">
                            <xsl:element
                                name="p"
                                namespace="http://csrc.nist.gov/ns/oscal/1.0">This description is more than 20 characters in length</xsl:element>
                        </xsl:element>
                        <xsl:element
                            name="remarks"
                            namespace="http://csrc.nist.gov/ns/oscal/1.0">
                            <xsl:element
                                name="p"
                                namespace="http://csrc.nist.gov/ns/oscal/1.0">
                                <xsl:value-of
                                    select="oscal:p" />
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
        <xsl:apply-templates
            select="part" />
    </xsl:template>

    <xsl:template
        match="part" />

</xsl:stylesheet>
