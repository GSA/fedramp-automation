<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    exclude-result-prefixes="xs math uuid expath oscal"
    expand-text="true"
    version="3.0"
    xmlns:expath="http://expath.org/ns/binary"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
    xmlns:saxon="http://saxon.sf.net/"
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
        name="insert-flaws"
        required="false"
        select="false()" />
    <xsl:param
        as="xs:boolean"
        name="insert-diagrams"
        required="false"
        select="false()" />

    <xsl:mode
        on-no-match="fail" />

    <xsl:output
        indent="true"
        method="xml"
        saxon:indent-spaces="4"
        saxon:line-length="150" />

    <xsl:variable
        as="xs:duration"
        name="UTC"
        select="xs:dayTimeDuration('PT0H')" />
    <xsl:variable
        name="UTC-date"
        select="adjust-date-to-timezone(current-date(), $UTC)" />
    <xsl:variable
        name="UTC-datetime"
        select="adjust-dateTime-to-timezone(current-dateTime(), $UTC)" />

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
        name="this-system-uuid"
        select="uuid:randomUUID()" />

    <xsl:variable
        as="xs:string"
        name="leveraged-authorization-uuid"
        select="uuid:randomUUID()" />

    <xsl:variable
        as="xs:string"
        name="leveraged-authorization-party-uuid"
        select="uuid:randomUUID()" />

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
        as="node()*"
        name="pp-uuid">
        <xsl:for-each
            select="//control[matches(@id, '-1$')]">
            <uuid
                id="{@id}"
                pol-c="{uuid:randomUUID()}"
                pol-r="{uuid:randomUUID()}"
                pro-c="{uuid:randomUUID()}"
                pro-r="{uuid:randomUUID()}" />
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable
        as="xs:string"
        name="control-role">implemented-requirement-responsible-role</xsl:variable>

    <xsl:variable
        as="xs:string"
        name="LF"
        select="'&#x0a;'" />
    <xsl:template
        match="/">

        <xsl:copy-of
            select="$LF" />
        <xsl:comment>This document used {base-uri()} as the input.</xsl:comment>
        <xsl:copy-of
            select="$LF" />
        <xsl:comment>This document used {static-base-uri()} as the transform.</xsl:comment>
        <xsl:copy-of
            select="$LF" />
        <xsl:processing-instruction name="xml-model"> schematypens="http://www.w3.org/2001/XMLSchema" title="OSCAL complete schema" href="https://raw.githubusercontent.com/usnistgov/OSCAL/v1.0.2/xml/schema/oscal_complete_schema.xsd" </xsl:processing-instruction>
        <xsl:copy-of
            select="$LF" />
        <xsl:processing-instruction name="xml-model"> schematypens="http://purl.oclc.org/dsdl/schematron" title="FedRAMP SSP constraints" https://github.com/18F/fedramp-automation/raw/master/src/validations/rules/ssp.sch" phase="#ALL"</xsl:processing-instruction>

        <xsl:if
            test="local-name(/*) ne 'catalog'">
            <xsl:message
                terminate="true">Invalid input {local-name(/*)}</xsl:message>
        </xsl:if>


        <system-security-plan
            uuid="{uuid:randomUUID()}"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">

            <xsl:call-template
                name="metadata" />

            <import-profile>
                <xsl:attribute
                    name="href">{//link[@rel='resolution-source']/@href}</xsl:attribute>
            </import-profile>

            <xsl:call-template
                name="system-characteristics" />

            <xsl:call-template
                name="system-implementation" />

            <xsl:call-template
                name="control-implementation" />

            <xsl:call-template
                name="back-matter" />

        </system-security-plan>

    </xsl:template>

    <xsl:template
        name="metadata">

        <xsl:variable
            as="xs:string"
            name="FedRAMP-uuid"
            select="uuid:randomUUID()" />

        <metadata
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP Content §4.1</xsl:comment>

            <title>DRAFT, SAMPLE {/catalog/metadata/title} System Security Plan</title>

            <published>{$UTC-datetime}</published>

            <last-modified>{$UTC-datetime}</last-modified>

            <version>0.2</version>

            <oscal-version>1.0.2</oscal-version>

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP Content §4.6</xsl:comment>
            <revisions>
                <revision>
                    <published>{$UTC-datetime}</published>
                    <last-modified>{$UTC-datetime}</last-modified>
                    <version>0.2</version>
                    <oscal-version>1.0.2</oscal-version>
                    <prop
                        name="party-uuid"
                        ns="https://fedramp.gov/ns/oscal"
                        value="{$FedRAMP-uuid}" />
                    <remarks>
                        <p>Initial publication.</p>
                    </remarks>
                </revision>
            </revisions>

            <!-- roles -->

            <!-- FedRAMP -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP Content §4.6</xsl:comment>
            <role
                id="fedramp-pmo">
                <title>FedRAMP Program Management Office</title>
            </role>

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
                <address>
                    <country>US</country>
                </address>
            </location>

            <!-- organization(s) -->

            <!-- FedRAMP -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP Content §4.6</xsl:comment>
            <party
                type="organization"
                uuid="{$FedRAMP-uuid}">
                <name>FedRAMP Program Management Office</name>
                <short-name>FedRAMP PMO</short-name>
                <link
                    href="https://fedramp.gov" />
                <email-address>oscal@fedramp.gov</email-address>
                <address
                    type="work">
                    <addr-line>1800 F St. NW</addr-line>
                    <city>Washington</city>
                    <state>DC</state>
                    <postal-code>20006</postal-code>
                    <country>US</country>
                </address>
            </party>

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

            <party
                type="organization"
                uuid="{$leveraged-authorization-party-uuid}">
                <name>Leveraged authorization party name</name>
                <short-name>Leveraged authorization party short name</short-name>
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
                uuid="{$ISO-uuid}">
                <name>name</name>
                <email-address>name@example.com</email-address>
                <telephone-number>+1-303-499-7111</telephone-number>
                <location-uuid>{$location-uuid}</location-uuid>
                <member-of-organization>{$csp-uuid}</member-of-organization>
            </party>

            <!-- AO -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.7</xsl:comment>
            <xsl:variable
                as="xs:string"
                name="AO-uuid"
                select="uuid:randomUUID()" />
            <party
                type="person"
                uuid="{$AO-uuid}">
                <name>name</name>
                <email-address>name@example.com</email-address>
                <telephone-number>+1-303-499-7111</telephone-number>
                <location-uuid>{$location-uuid}</location-uuid>
                <member-of-organization>{$csp-uuid}</member-of-organization>
            </party>

            <!-- ISMPoC -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.8</xsl:comment>
            <xsl:variable
                as="xs:string"
                name="ISMPoC-uuid"
                select="uuid:randomUUID()" />
            <party
                type="person"
                uuid="{$ISMPoC-uuid}">
                <name>name</name>
                <email-address>name@example.com</email-address>
                <telephone-number>+1-303-499-7111</telephone-number>
                <location-uuid>{$location-uuid}</location-uuid>
                <member-of-organization>{$csp-uuid}</member-of-organization>
            </party>

            <!-- ISTPoC -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.9</xsl:comment>
            <xsl:variable
                as="xs:string"
                name="ISTPoC-uuid"
                select="uuid:randomUUID()" />
            <party
                type="person"
                uuid="{$ISTPoC-uuid}">
                <name>name</name>
                <email-address>name@example.com</email-address>
                <telephone-number>+1-303-499-7111</telephone-number>
                <location-uuid>{$location-uuid}</location-uuid>
                <member-of-organization>{$csp-uuid}</member-of-organization>
            </party>

            <!-- ISOPoC -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.9</xsl:comment>
            <xsl:variable
                as="xs:string"
                name="ISOPoC-uuid"
                select="uuid:randomUUID()" />
            <party
                type="person"
                uuid="{$ISOPoC-uuid}">
                <name>name</name>
                <email-address>name@example.com</email-address>
                <telephone-number>+1-303-499-7111</telephone-number>
                <location-uuid>{$location-uuid}</location-uuid>
                <member-of-organization>{$csp-uuid}</member-of-organization>
            </party>

            <!-- ISSO -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.10</xsl:comment>
            <xsl:variable
                as="xs:string"
                name="ISSO-uuid"
                select="uuid:randomUUID()" />
            <party
                type="person"
                uuid="{$ISSO-uuid}">
                <name>name</name>
                <email-address>name@example.com</email-address>
                <telephone-number>+1-303-499-7111</telephone-number>
                <location-uuid>{$location-uuid}</location-uuid>
                <member-of-organization>{$csp-uuid}</member-of-organization>
            </party>

            <!-- AOPoC -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.11</xsl:comment>
            <xsl:variable
                as="xs:string"
                name="AOPoC-uuid"
                select="uuid:randomUUID()" />
            <party
                type="person"
                uuid="{$AOPoC-uuid}">
                <name>name</name>
                <email-address>name@example.com</email-address>
                <telephone-number>+1-303-499-7111</telephone-number>
                <location-uuid>{$location-uuid}</location-uuid>
                <member-of-organization>{$csp-uuid}</member-of-organization>
            </party>

            <!-- irrr -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2</xsl:comment>
            <xsl:variable
                as="xs:string"
                name="irrr-uuid"
                select="uuid:randomUUID()" />
            <party
                type="person"
                uuid="{$irrr-uuid}">
                <name>name</name>
                <email-address>name@example.com</email-address>
                <telephone-number>+1-303-499-7111</telephone-number>
                <location-uuid>{$location-uuid}</location-uuid>
                <member-of-organization>{$csp-uuid}</member-of-organization>
            </party>

            <!-- FedRAMP -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP Content §4.6</xsl:comment>
            <responsible-party
                role-id="fedramp-pmo">
                <party-uuid>{$FedRAMP-uuid}</party-uuid>
            </responsible-party>

            <!-- ISO -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.6</xsl:comment>
            <responsible-party
                role-id="system-owner">
                <party-uuid>{$ISO-uuid}</party-uuid>
            </responsible-party>

            <!-- AO -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.7</xsl:comment>
            <responsible-party
                role-id="authorizing-official">
                <party-uuid>{$AO-uuid}</party-uuid>
            </responsible-party>

            <!-- ISMPoC -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.8</xsl:comment>
            <responsible-party
                role-id="system-poc-management">
                <party-uuid>{$ISMPoC-uuid}</party-uuid>
            </responsible-party>

            <!-- ISTPoC -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.9</xsl:comment>
            <responsible-party
                role-id="system-poc-technical">
                <party-uuid>{$ISTPoC-uuid}</party-uuid>
            </responsible-party>

            <!-- ISOPoC -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.9</xsl:comment>
            <responsible-party
                role-id="system-poc-other">
                <party-uuid>{$ISOPoC-uuid}</party-uuid>
            </responsible-party>

            <!-- ISSO -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.10</xsl:comment>
            <responsible-party
                role-id="information-system-security-officer">
                <party-uuid>{$ISSO-uuid}</party-uuid>
            </responsible-party>

            <!-- AOPoC -->
            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.11</xsl:comment>
            <responsible-party
                role-id="authorizing-official-poc">
                <party-uuid>{$AOPoC-uuid}</party-uuid>
            </responsible-party>

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2</xsl:comment>
            <responsible-party
                role-id="{$control-role}">
                <party-uuid>{$irrr-uuid}</party-uuid>
            </responsible-party>

        </metadata>

    </xsl:template>

    <xsl:template
        name="system-characteristics">

        <system-characteristics
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.1</xsl:comment>
            <system-id
                identifier-type="https://fedramp.gov">F00000000</system-id>
            <system-name>Sample SSP</system-name>
            <system-name-short>SSSP</system-name-short>

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.16</xsl:comment>
            <description>
                <p>Describe the purpose and functions of this system here in 32 words or more.</p>
            </description>

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.2</xsl:comment>
            <prop
                name="authorization-type"
                ns="https://fedramp.gov/ns/oscal"
                value="fedramp-agency" />

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.13</xsl:comment>
            <prop
                name="cloud-service-model"
                value="saas" />

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.14</xsl:comment>
            <prop
                name="cloud-deployment-model"
                value="public-cloud" />

            <!-- obsolete <prop
            class="security-eauth"
            name="security-eauth-level"
            ns="https://fedramp.gov/ns/oscal"
            value="2" />-->

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.2</xsl:comment>
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

                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4</xsl:comment>
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

                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3</xsl:comment>
                <information-type
                    uuid="{uuid:randomUUID()}">
                    <xsl:choose>
                        <xsl:when
                            test="matches(base-uri(), 'LOW')">
                            <title>Security Management</title>
                            <description>
                                <p>Security Management involves the physical protection of an organization’s personnel, assets, and facilities
                                    (including security clearance management). Impacts to some information and information systems associated with
                                    security management may affect the security of some critical infrastructure elements and key national assets
                                    (e.g., nuclear power plants, dams, and other government facilities). Impact levels associated with security
                                    information directly relate to the potential threat to human life associated with the asset(s) being protected
                                    (e.g., consequences to the public of terrorist access to dams or nuclear power plants).</p>
                            </description>
                            <categorization
                                system="https://doi.org/10.6028/NIST.SP.800-60v2r1">
                                <information-type-id>C.3.1.3</information-type-id>
                            </categorization>
                            <confidentiality-impact>
                                <base>fips-199-moderate</base>
                                <selected>fips-199-moderate</selected>
                            </confidentiality-impact>
                            <integrity-impact>
                                <base>fips-199-moderate</base>
                                <selected>fips-199-moderate</selected>
                            </integrity-impact>
                            <availability-impact>
                                <base>fips-199-low</base>
                                <selected>fips-199-low</selected>
                            </availability-impact>
                        </xsl:when>
                        <xsl:when
                            test="matches(base-uri(), 'MODERATE')">
                            <title>Security Management</title>
                            <description>
                                <p>Security Management involves the physical protection of an organization’s personnel, assets, and facilities
                                    (including security clearance management). Impacts to some information and information systems associated with
                                    security management may affect the security of some critical infrastructure elements and key national assets
                                    (e.g., nuclear power plants, dams, and other government facilities). Impact levels associated with security
                                    information directly relate to the potential threat to human life associated with the asset(s) being protected
                                    (e.g., consequences to the public of terrorist access to dams or nuclear power plants).</p>
                            </description>
                            <categorization
                                system="https://doi.org/10.6028/NIST.SP.800-60v2r1">
                                <information-type-id>C.3.1.3</information-type-id>
                            </categorization>
                            <confidentiality-impact>
                                <base>fips-199-moderate</base>
                                <selected>fips-199-moderate</selected>
                            </confidentiality-impact>
                            <integrity-impact>
                                <base>fips-199-moderate</base>
                                <selected>fips-199-moderate</selected>
                            </integrity-impact>
                            <availability-impact>
                                <base>fips-199-low</base>
                                <selected>fips-199-low</selected>
                            </availability-impact>
                        </xsl:when>
                        <xsl:when
                            test="matches(base-uri(), 'HIGH')">
                            <title>Global Trade</title>
                            <description>
                                <p>Global Trade refers to those activities the Federal Government undertakes to advance worldwide economic prosperity
                                    by increasing trade through the opening of overseas markets and freeing the flow of goods, services, and capital.
                                    Trade encompasses all activities associated with the importing and exporting of goods to and from the United
                                    States. This includes goods declaration, fee payments, and delivery/shipment authorization. Export promotion
                                    involves the development of opportunities for the expansion of U.S. exports. Merchandise inspection includes the
                                    verification of goods and merchandise as well as the surveillance, interdiction, and investigation of
                                    imports/exports in violation of various Customs laws. Tariffs/quotas monitoring refers to the monitoring and
                                    modification of the schedules of items imported and exported to and from the United States.</p>
                            </description>
                            <categorization
                                system="https://doi.org/10.6028/NIST.SP.800-60v2r1">
                                <information-type-id>D.5.3</information-type-id>
                            </categorization>
                            <confidentiality-impact>
                                <base>fips-199-high</base>
                                <selected>fips-199-high</selected>
                            </confidentiality-impact>
                            <integrity-impact>
                                <base>fips-199-high</base>
                                <selected>fips-199-high</selected>
                            </integrity-impact>
                            <availability-impact>
                                <base>fips-199-high</base>
                                <selected>fips-199-high</selected>
                            </availability-impact>
                        </xsl:when>
                    </xsl:choose>
                </information-type>

            </system-information>

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.4</xsl:comment>
            <xsl:variable
                as="xs:string"
                name="obj">
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
            </xsl:variable>
            <security-impact-level>
                <security-objective-confidentiality>{$obj}</security-objective-confidentiality>
                <security-objective-integrity>{$obj}</security-objective-integrity>
                <security-objective-availability>{$obj}</security-objective-availability>
            </security-impact-level>

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.12</xsl:comment>
            <status
                state="operational" />

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17</xsl:comment>
            <authorization-boundary>
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

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22</xsl:comment>
            <network-architecture>
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

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24</xsl:comment>
            <data-flow>
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

    </xsl:template>

    <xsl:template
        name="system-implementation">

        <system-implementation
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">

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

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.15</xsl:comment>
            <leveraged-authorization
                uuid="{$leveraged-authorization-uuid}">
                <title>AWS GovCloud</title>
                <prop
                    name="leveraged-system-identifier"
                    ns="https://fedramp.gov/ns/oscal"
                    value="F1603047866" />
                <party-uuid>{$leveraged-authorization-party-uuid}</party-uuid>
                <date-authorized>2015-01-01</date-authorized>
                <remarks>
                    <p>Use one leveraged-authorization assembly for each leveraged system.</p>
                    <p>The link fields are optional, but preferred when known. Often, a leveraging system's SSP author will not have access to the
                        leveraged system's SSP, but should have access to the leveraged system's CRM.</p>
                </remarks>
            </leveraged-authorization>

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2</xsl:comment>
            <user
                uuid="{$user-uuid}">

                <prop
                    name="type"
                    value="internal" />

                <prop
                    name="privilege-level"
                    value="privileged" />

                <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.18</xsl:comment>
                <!-- FIXME: documentation -->
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

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.4.6</xsl:comment>
            <component
                type="this-system"
                uuid="{$this-system-uuid}">
                <title>This system</title>
                <description>
                    <p>This component refers to the system itself.</p>
                </description>
                <status
                    state="operational" />
            </component>

            <xsl:comment>See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.15</xsl:comment>
            <component
                type="leveraged-system"
                uuid="{uuid:randomUUID()}">
                <title>Name of leveraged FedRAMP package</title>
                <description>
                    <p>Description of leveraged FedRAMP package</p>
                </description>
                <prop
                    name="leveraged-authorization-uuid"
                    value="{$leveraged-authorization-uuid}" />
                <prop
                    name="implementation-point"
                    value="external" />
                <status
                    state="operational" />
            </component>

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

            <component
                type="DNS-authoritative-service"
                uuid="{uuid:randomUUID()}">
                <title>Authoritative DNS service</title>
                <description>
                    <p>Authoritative DNS service for the following zones.</p>
                </description>
                <prop
                    name="asset-type"
                    value="service" />
                <prop
                    name="DNS-zone"
                    value="example.com.">
                    <remarks>
                        <p>An example of a DNS zone (sometimes referred to as a domain or sub-domain). The zone name resembles a host name but is
                            specifically a DNS resource name of the SOA RR for the zone.</p>
                    </remarks>
                </prop>
                <prop
                    name="DNS-zone"
                    value="example.org" />
                <status
                    state="operational" />
                <protocol
                    name="domain">
                    <xsl:comment> ☚ Note the use of IANA service name (https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml) </xsl:comment>
                </protocol>
                <remarks>
                    <p>Each zone must have a DNS SOA RR at the authoritative service.</p>
                </remarks>
            </component>

            <xsl:for-each
                select="//control[matches(@id, '-1$')]">

                <component
                    type="policy"
                    uuid="{$pp-uuid[@id = current()/@id]/@pol-c}">
                    <title>
                        <xsl:text>{prop[@name = 'label']/@value} - Policy document</xsl:text>
                    </title>
                    <description>
                        <p>
                            <xsl:text>{prop[@name = 'label']/@value} {title} - Policy</xsl:text>
                        </p>
                    </description>
                    <prop
                        name="asset-type"
                        value="document" />
                    <link
                        href="#{$pp-uuid[@id = current()/@id]/@pol-r}"
                        rel="policy" />
                    <status
                        state="operational" />
                </component>

                <component
                    type="procedure"
                    uuid="{$pp-uuid[@id = current()/@id]/@pro-c}">
                    <title>
                        <xsl:text>{prop[@name = 'label']/@value} - Procedure document</xsl:text>
                    </title>
                    <description>
                        <p>
                            <xsl:text>{prop[@name = 'label']/@value} {title} - Procedure</xsl:text>
                        </p>
                    </description>
                    <prop
                        name="asset-type"
                        value="document" />
                    <link
                        href="#{$pp-uuid[@id = current()/@id]/@pro-r}"
                        rel="procedure" />
                    <status
                        state="operational" />
                </component>

            </xsl:for-each>

        </system-implementation>

    </xsl:template>

    <xsl:template
        name="control-implementation">

        <control-implementation
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">
            <description />
            <xsl:for-each
                select="//control">
                <implemented-requirement
                    control-id="{@id}"
                    uuid="{uuid:randomUUID()}">
                    <xsl:comment> Control title: {title} </xsl:comment>
                    <xsl:variable
                        as="xs:integer"
                        name="r">{floor(random-number-generator(generate-id())?number * 100 ) + 1}</xsl:variable>
                    <xsl:variable
                        as="xs:integer"
                        name="w">
                        <xsl:choose>
                            <xsl:when
                                test="not($insert-flaws)">
                                <xsl:value-of
                                    select="1" />
                            </xsl:when>
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
                            value="{$UTC-date + xs:dayTimeDuration('P30D')}" />
                    </xsl:if>
                    <xsl:comment>
                            <xsl:choose>
                                <xsl:when test="count(param) gt 2">
                                    <xsl:text> There are {count(param)} control parameters </xsl:text>
                                </xsl:when>
                                <xsl:when test="count(param) eq 1">
                                    <xsl:text> There is {count(param)} control parameter </xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text> There are no control parameters </xsl:text>
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
                                        test="constraint">
                                        <xsl:value-of
                                            select="normalize-space(constraint)" />
                                    </xsl:when>
                                    <xsl:when
                                        test="label">
                                        <xsl:text>The chosen {normalize-space(label)} should appear here.</xsl:text>
                                    </xsl:when>
                                    <xsl:when
                                        test="
                                            some $choice in select//choice
                                                satisfies $choice/insert">
                                        <xsl:text>it's complicated by parameter inserts</xsl:text>
                                    </xsl:when>
                                    <xsl:when
                                        test="select[@how-many]">
                                        <xsl:text>{select/@how-many} of {string-join(select/choice[not(insert)],', ')}</xsl:text>
                                    </xsl:when>
                                    <xsl:when
                                        test="select">
                                        <xsl:text>one of {string-join(select/choice[not(insert)],' or ')}</xsl:text>
                                    </xsl:when>
                                </xsl:choose>
                            </value>
                            <xsl:if
                                test="constraint">
                                <remarks>
                                    <p>There is a FedRAMP constraint on this ODP: <q>{normalize-space(constraint)}</q></p>
                                </remarks>
                            </xsl:if>
                        </set-parameter>
                    </xsl:for-each>
                    <!--See DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2-->
                    <xsl:if
                        test="$status ne 'not-applicable'">
                        <responsible-role
                            role-id="{$control-role}" />
                    </xsl:if>

                    <xsl:comment>
                            <xsl:text> Required response points are: </xsl:text>
                            <xsl:value-of select="descendant::prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'response-point']/parent::part/@id[matches(., 'smt')]" separator=", " /> 
                        </xsl:comment>

                    <xsl:choose>
                        <xsl:when
                            test="matches(@id, '-1$')">
                            <xsl:apply-templates
                                select="part[@name = 'statement']" />
                            <xsl:call-template
                                name="pol-pro" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates
                                select="part[@name = 'statement']" />
                        </xsl:otherwise>
                    </xsl:choose>

                </implemented-requirement>

            </xsl:for-each>

        </control-implementation>

    </xsl:template>

    <xsl:template
        name="back-matter">

        <back-matter
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">

            <xsl:comment>Authorization Boundary Diagram</xsl:comment>
            <resource
                uuid="{$authorization-boundary-diagram-resource-uuid}">
                <xsl:variable
                    as="xs:string"
                    name="dp"
                    select="'SSSP-authorization-boundary-diagram.graphml'" />
                <xsl:result-document
                    href="{resolve-uri($dp,current-output-uri())}"
                    method="xml">
                    <graphml
                        xmlns="http://graphml.graphdrawing.org/xmlns">
                        <graph
                            edgedefault="undirected"
                            id="G">
                            <node
                                id="n0" />
                            <node
                                id="n1" />
                            <edge
                                id="e1"
                                source="n0"
                                target="n1" />
                        </graph>
                    </graphml>
                </xsl:result-document>
                <title>Authorization Boundary Diagram</title>
                <description />
                <prop
                    name="type"
                    value="diagram" />
                <rlink
                    href="{$dp}" />
                <base64
                    filename="{$dp}"
                    media-type="text/xml">
                    <xsl:choose>
                        <xsl:when
                            test="$insert-diagrams">
                            <xsl:copy-of
                                select="expath:encode-string(doc($dp))" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="expath:encode-string('elided Authorization Boundary Diagram')" />
                        </xsl:otherwise>
                    </xsl:choose>
                </base64>
            </resource>

            <xsl:comment>Network Architecture Diagram</xsl:comment>
            <resource
                uuid="{$network-architecture-diagram-resource-uuid}">
                <xsl:variable
                    as="xs:string"
                    name="dp"
                    select="'SSSP-network-architecture-diagram.graphml'" />
                <xsl:result-document
                    href="{resolve-uri($dp,current-output-uri())}"
                    method="xml">
                    <graphml
                        xmlns="http://graphml.graphdrawing.org/xmlns">
                        <graph
                            edgedefault="undirected"
                            id="G">
                            <node
                                id="n0" />
                            <node
                                id="n1" />
                            <edge
                                id="e1"
                                source="n0"
                                target="n1" />
                        </graph>
                    </graphml>
                </xsl:result-document>
                <title>Network Architecture Diagram</title>
                <description />
                <prop
                    name="type"
                    value="diagram" />
                <rlink
                    href="{$dp}" />
                <base64
                    filename="{$dp}"
                    media-type="text/xml">
                    <xsl:choose>
                        <xsl:when
                            test="$insert-diagrams">
                            <xsl:copy-of
                                select="expath:encode-string(doc($dp))" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="expath:encode-string('elided Network Architecture Diagram')" />
                        </xsl:otherwise>
                    </xsl:choose>
                </base64>
            </resource>

            <xsl:comment>Data Flow Diagram</xsl:comment>
            <resource
                uuid="{$data-flow-diagram-resource-uuid}">
                <xsl:variable
                    as="xs:string"
                    name="dp"
                    select="'SSSP-data-flow-diagram.graphml'" />
                <xsl:result-document
                    href="{resolve-uri($dp,current-output-uri())}"
                    method="xml">
                    <graphml
                        xmlns="http://graphml.graphdrawing.org/xmlns">
                        <graph
                            edgedefault="undirected"
                            id="G">
                            <node
                                id="n0" />
                            <node
                                id="n1" />
                            <edge
                                id="e1"
                                source="n0"
                                target="n1" />
                        </graph>
                    </graphml>
                </xsl:result-document>
                <title>Data Flow Diagram</title>
                <description />
                <prop
                    name="type"
                    value="diagram" />
                <rlink
                    href="{$dp}" />
                <base64
                    filename="{$dp}"
                    media-type="text/xml">
                    <xsl:choose>
                        <xsl:when
                            test="$insert-diagrams">
                            <xsl:copy-of
                                select="expath:encode-string(doc($dp))" />
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
                <xsl:comment>{parent::group/title} Policy and Procedures attachments</xsl:comment>

                <resource
                    uuid="{$pp-uuid[@id = current()/@id]/@pol-r}">
                    <xsl:variable
                        as="xs:string"
                        name="dp">SSSP-A1-ISPP-{@id}-policy.md</xsl:variable>
                    <xsl:variable
                        as="xs:string"
                        name="text">{prop[@name = 'label']/@value} {title} - Policy</xsl:variable>
                    <xsl:result-document
                        href="{resolve-uri($dp,current-output-uri())}"
                        method="text">
                        <xsl:text># {$text}</xsl:text>
                    </xsl:result-document>
                    <title>
                        <xsl:value-of
                            select="$text" />
                    </title>
                    <prop
                        name="type"
                        value="policy" />
                    <rlink
                        href="{$dp}" />
                    <base64
                        filename="{$dp}"
                        media-type="text/markdown">
                        <xsl:value-of
                            select="expath:encode-string($text)" />
                    </base64>
                </resource>

                <resource
                    uuid="{$pp-uuid[@id = current()/@id]/@pro-r}">
                    <xsl:variable
                        as="xs:string"
                        name="dp">SSSP-A1-ISPP-{@id}-procedure.md</xsl:variable>
                    <xsl:variable
                        as="xs:string"
                        name="text">{prop[@name = 'label']/@value} {title} - Procedure</xsl:variable>
                    <xsl:result-document
                        href="{resolve-uri($dp,current-output-uri())}"
                        method="text">
                        <xsl:text># {$text}</xsl:text>
                    </xsl:result-document>
                    <title>
                        <xsl:value-of
                            select="$text" />
                    </title>
                    <prop
                        name="type"
                        value="procedure" />
                    <rlink
                        href="{$dp}" />
                    <base64
                        filename="{$dp}"
                        media-type="text/markdown">
                        <xsl:value-of
                            select="expath:encode-string($text)" />
                    </base64>
                </resource>

            </xsl:for-each>

            <xsl:comment>User Guide</xsl:comment>
            <resource
                uuid="{uuid:randomUUID()}">
                <title>User Guide</title>
                <prop
                    name="type"
                    value="user-guide" />
                <rlink
                    href="SSSP-A2-UG.txt" />
                <base64
                    filename="SSSP-A2-UG.txt"
                    media-type="text/plain">
                    <xsl:value-of
                        select="expath:encode-string('User Guide')" />
                </base64>
            </resource>

            <xsl:comment>Privacy Impact Assessment</xsl:comment>
            <resource
                uuid="{uuid:randomUUID()}">
                <prop
                    name="type"
                    value="privacy-impact-assessment" />
                <rlink
                    href="SSSP-A4-PIA.txt" />
                <base64
                    filename="SSSP-A4-PIA.txt"
                    media-type="text/plain">
                    <xsl:value-of
                        select="expath:encode-string('Privacy Impact Analysis')" />
                </base64>
            </resource>

            <xsl:comment>Rules of Behavior</xsl:comment>
            <resource
                uuid="{uuid:randomUUID()}">
                <prop
                    name="type"
                    value="rules-of-behavior" />
                <rlink
                    href="SSSP-A5-ROB.txt" />
                <base64
                    filename="SSSP-A5-ROB.txt"
                    media-type="text/plain">
                    <xsl:value-of
                        select="expath:encode-string('Rules of Behavior')" />
                </base64>
            </resource>

            <xsl:comment>Information System Contingency Plan</xsl:comment>
            <resource
                uuid="{uuid:randomUUID()}">
                <prop
                    name="type"
                    value="information-system-contingency-plan" />
                <rlink
                    href="SSSP-A6-ISCP.txt" />
                <base64
                    filename="SSSP-A6-ISCP.txt"
                    media-type="text/plain">
                    <xsl:value-of
                        select="expath:encode-string('Information System Contingency Plan')" />
                </base64>
            </resource>

            <xsl:comment>Configuration Management Plan</xsl:comment>
            <resource
                uuid="{uuid:randomUUID()}">
                <prop
                    name="type"
                    value="configuration-management-plan" />
                <rlink
                    href="SSSP-A7-CMP.txt" />
                <base64
                    filename="SSSP-A7-CMP.txt"
                    media-type="text/plain">
                    <xsl:value-of
                        select="expath:encode-string('Configuration Management Plan')" />
                </base64>
            </resource>

            <xsl:comment>Incident Response Plan</xsl:comment>
            <resource
                uuid="{uuid:randomUUID()}">
                <prop
                    name="type"
                    value="incident-response-plan" />
                <rlink
                    href="SSSP-A8-IRP.txt" />
                <base64
                    filename="SSSP-A8-IRP.txt"
                    media-type="text/plain">
                    <xsl:value-of
                        select="expath:encode-string('Incident Response Plan')" />
                </base64>
            </resource>

            <xsl:comment>CIS Workbook</xsl:comment>
            <resource
                uuid="{uuid:randomUUID()}">
                <prop
                    name="type"
                    value="CIS-workbook" />
                <rlink
                    href="SSSP-A9-CIS-Workbook.txt" />
                <base64
                    filename="SSSP-A9-CIS-Workbook.txt"
                    media-type="text/plain">
                    <xsl:value-of
                        select="expath:encode-string('CIS Workbook')" />
                </base64>
            </resource>

            <xsl:comment>Inventory</xsl:comment>
            <resource
                uuid="{uuid:randomUUID()}">
                <prop
                    name="type"
                    value="inventory" />
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

    </xsl:template>

    <xsl:template
        match="part[@name = 'statement']">
        <statement
            statement-id="{@id}"
            uuid="{uuid:randomUUID()}"
            xmlns="http://csrc.nist.gov/ns/oscal/1.0">
            <by-component
                component-uuid="{$this-system-uuid}"
                uuid="{uuid:randomUUID()}">
                <xsl:apply-templates
                    select="p" />
            </by-component>
        </statement>
        <xsl:apply-templates
            select="part" />
    </xsl:template>

    <xsl:template
        match="part[@name = 'item']">
        <xsl:if
            test="p">
            <statement
                statement-id="{@id}"
                uuid="{uuid:randomUUID()}"
                xmlns="http://csrc.nist.gov/ns/oscal/1.0">
                <by-component
                    component-uuid="{$this-system-uuid}"
                    uuid="{uuid:randomUUID()}">
                    <xsl:apply-templates
                        select="p" />
                </by-component>
            </statement>
        </xsl:if>
        <xsl:apply-templates
            select="part" />
    </xsl:template>

    <xsl:template
        match="p">

        <xsl:element
            name="description"
            namespace="http://csrc.nist.gov/ns/oscal/1.0">
            <xsl:element
                name="p"
                namespace="http://csrc.nist.gov/ns/oscal/1.0">
                <xsl:text>A description of how the organization implements "</xsl:text>
                <xsl:apply-templates
                    select="node()" />
                <xsl:text>"</xsl:text>
            </xsl:element>
        </xsl:element>

    </xsl:template>

    <xsl:template
        match="insert">
        <xsl:text>[{@id-ref}]</xsl:text>
    </xsl:template>

    <xsl:template
        match="em | a | strong">
        <xsl:element
            name="{local-name()}"
            namespace="http://csrc.nist.gov/ns/oscal/1.0">
            <xsl:apply-templates
                select="node()" />
        </xsl:element>
    </xsl:template>

    <xsl:template
        match="text()">
        <xsl:copy-of
            select="." />
    </xsl:template>

    <xsl:template
        match="part" />

    <xsl:template
        name="pol-pro">

        <xsl:comment>policy and procedure</xsl:comment>

        <xsl:element
            name="by-component"
            namespace="http://csrc.nist.gov/ns/oscal/1.0">
            <xsl:attribute
                name="uuid"
                select="uuid:randomUUID()" />
            <xsl:attribute
                name="component-uuid"
                select="$pp-uuid[@id = current()/@id]/@pol-c" />
            <xsl:element
                name="description"
                namespace="http://csrc.nist.gov/ns/oscal/1.0">
                <xsl:element
                    name="p"
                    namespace="http://csrc.nist.gov/ns/oscal/1.0">
                    <xsl:text>{title}: policy component reference</xsl:text>
                </xsl:element>
            </xsl:element>
        </xsl:element>

        <xsl:element
            name="by-component"
            namespace="http://csrc.nist.gov/ns/oscal/1.0">
            <xsl:attribute
                name="uuid"
                select="uuid:randomUUID()" />
            <xsl:attribute
                name="component-uuid"
                select="$pp-uuid[@id = current()/@id]/@pro-c" />
            <xsl:element
                name="description"
                namespace="http://csrc.nist.gov/ns/oscal/1.0">
                <xsl:element
                    name="p"
                    namespace="http://csrc.nist.gov/ns/oscal/1.0">
                    <xsl:text>{title}: procedure component reference</xsl:text>
                </xsl:element>
            </xsl:element>
        </xsl:element>

    </xsl:template>

</xsl:stylesheet>
