<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:f="https://fedramp.gov/ns/oscal"
                xmlns:fedramp="https://fedramp.gov/ns/oscal"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:lv="local-validations"
                xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
                xmlns:oscal="http://csrc.nist.gov/ns/oscal/1.0"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>
   <!--PHASES-->
   <!--PROLOG-->
   <xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>
   <!--XSD TYPES FOR XSLT2-->
   <!--KEYS AND FUNCTIONS-->
   <xsl:function xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
                 xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="lv:if-empty-default">
      <xsl:param name="item"/>
      <xsl:param name="default"/>
      <xsl:choose>
         <xsl:when test="$item instance of xs:untypedAtomic or $item instance of xs:anyURI or $item instance of xs:string or $item instance of xs:QName or $item instance of xs:boolean or $item instance of xs:base64Binary or $item instance of xs:hexBinary or $item instance of xs:integer or $item instance of xs:decimal or $item instance of xs:float or $item instance of xs:double or $item instance of xs:date or $item instance of xs:time or $item instance of xs:dateTime or $item instance of xs:dayTimeDuration or $item instance of xs:yearMonthDuration or $item instance of xs:duration or $item instance of xs:gMonth or $item instance of xs:gYear or $item instance of xs:gYearMonth or $item instance of xs:gDay or $item instance of xs:gMonthDay">
            <xsl:value-of select="                         if ($item =&gt; string() =&gt; normalize-space() = '') then                             $default                         else                             $item"/>
         </xsl:when>
         <xsl:when test="$item instance of element() or $item instance of attribute() or $item instance of text() or $item instance of node() or $item instance of document-node() or $item instance of comment() or $item instance of processing-instruction()">
            <xsl:sequence select="                         if ($item =&gt; normalize-space() =&gt; not()) then                             $default                         else                             $item"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:sequence select="()"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <xsl:function xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
                 xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 as="item()*"
                 name="lv:registry">
      <xsl:sequence select="$registry"/>
   </xsl:function>
   <xsl:function xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
                 xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 as="xs:string"
                 name="lv:sensitivity-level">
      <xsl:param as="node()*" name="context"/>
      <xsl:value-of select="$context//o:security-sensitivity-level"/>
   </xsl:function>
   <xsl:function xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
                 xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 as="document-node()*"
                 name="lv:profile">
      <xsl:param name="level"/>
      <xsl:variable name="profile-map">
         <profile href="{concat($baselines-base-path, '/FedRAMP_rev4_LOW-baseline-resolved-profile_catalog.xml')}"
                  level="low"/>
         <profile href="{concat($baselines-base-path, '/FedRAMP_rev4_MODERATE-baseline-resolved-profile_catalog.xml')}"
                  level="moderate"/>
         <profile href="{concat($baselines-base-path, '/FedRAMP_rev4_HIGH-baseline-resolved-profile_catalog.xml')}"
                  level="high"/>
      </xsl:variable>
      <xsl:variable name="href" select="$profile-map/profile[@level = $level]/@href"/>
      <xsl:sequence select="doc(resolve-uri($href))"/>
   </xsl:function>
   <xsl:function xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
                 xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="lv:correct">
      <xsl:param as="element()*" name="value-set"/>
      <xsl:param as="node()*" name="value"/>
      <xsl:variable name="values" select="$value-set/f:allowed-values/f:enum/@value"/>
      <xsl:choose>
         <xsl:when test="$value-set/f:allowed-values/@allow-other = 'no' and $value = $values"/>
         <xsl:otherwise>
            <xsl:value-of select="$values" separator=", "/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <xsl:function xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
                 xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 name="lv:analyze">
      <xsl:param as="element()*" name="value-set"/>
      <xsl:param as="element()*" name="element"/>
      <xsl:choose>
         <xsl:when test="$value-set/f:allowed-values/f:enum/@value">
            <xsl:sequence>
               <xsl:call-template name="analysis-template">
                  <xsl:with-param name="value-set" select="$value-set"/>
                  <xsl:with-param name="element" select="$element"/>
               </xsl:call-template>
            </xsl:sequence>
         </xsl:when>
         <xsl:otherwise>
            <xsl:message expand-text="yes">error</xsl:message>
            <xsl:sequence>
               <xsl:call-template name="analysis-template">
                  <xsl:with-param name="value-set" select="$value-set"/>
                  <xsl:with-param name="element" select="$element"/>
                  <xsl:with-param name="errors">
                     <error>value-set was malformed</error>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:sequence>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <xsl:function xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
                 xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 as="xs:string"
                 name="lv:report">
      <xsl:param as="element()*" name="analysis"/>
      <xsl:variable as="xs:string" name="results">
         <xsl:call-template name="report-template">
            <xsl:with-param name="analysis" select="$analysis"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$results"/>
   </xsl:function>
   <!--DEFAULT RULES-->
   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>
   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>
   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                              title="FedRAMP System Security Plan Validations"
                              schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="https://fedramp.gov/ns/oscal" prefix="f"/>
         <svrl:ns-prefix-in-attribute-values uri="http://csrc.nist.gov/ns/oscal/1.0" prefix="o"/>
         <svrl:ns-prefix-in-attribute-values uri="http://csrc.nist.gov/ns/oscal/1.0" prefix="oscal"/>
         <svrl:ns-prefix-in-attribute-values uri="https://fedramp.gov/ns/oscal" prefix="fedramp"/>
         <svrl:ns-prefix-in-attribute-values uri="local-validations" prefix="lv"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">phase2</xsl:attribute>
            <xsl:attribute name="name">phase2</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">resources</xsl:attribute>
            <xsl:attribute name="name">Basic resource constraints</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">base64</xsl:attribute>
            <xsl:attribute name="name">base64 attachments</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">specific-attachments</xsl:attribute>
            <xsl:attribute name="name">Constraints for specific attachments</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">policy-and-procedure</xsl:attribute>
            <xsl:attribute name="name">A FedRAMP SSP must incorporate one policy document and one procedure document for each of the 17 NIST SP 800-54 Revision 4 control
        families</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">privacy1</xsl:attribute>
            <xsl:attribute name="name">A FedRAMP OSCAL SSP must specify a Privacy Point of Contact</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">privacy2</xsl:attribute>
            <xsl:attribute name="name">A FedRAMP OSCAL SSP may need to incorporate a PIA and possibly a SORN</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">fips-140</xsl:attribute>
            <xsl:attribute name="name">FIPS 140 Validation</xsl:attribute>
            <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans Appendix A</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">fips-199</xsl:attribute>
            <xsl:attribute name="name">Security Objectives Categorization (FIPS 199)</xsl:attribute>
            <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.4</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">sp800-60</xsl:attribute>
            <xsl:attribute name="name">SP 800-60v2r1 Information Types:</xsl:attribute>
            <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.3</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">sp800-63</xsl:attribute>
            <xsl:attribute name="name">Digital Identity Determination</xsl:attribute>
            <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.5</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">system-inventory</xsl:attribute>
            <xsl:attribute name="name">FedRAMP OSCAL SSP inventory items</xsl:attribute>
            <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">basic-system-characteristics</xsl:attribute>
            <xsl:attribute name="name">basic-system-characteristics</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">general-roles</xsl:attribute>
            <xsl:attribute name="name">Roles, Locations, Parties, Responsibilities</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">implementation-roles</xsl:attribute>
            <xsl:attribute name="name">Roles related to implemented requirements</xsl:attribute>
            <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.2</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">user-properties</xsl:attribute>
            <xsl:attribute name="name">user-properties</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">authorization-boundary</xsl:attribute>
            <xsl:attribute name="name">Authorization Boundary Diagram</xsl:attribute>
            <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.17 Authorization Boundary Diagram</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">network-architecture</xsl:attribute>
            <xsl:attribute name="name">Network Architecture Diagram</xsl:attribute>
            <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.22 Network Architecture Diagram</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">data-flow</xsl:attribute>
            <xsl:attribute name="name">Data Flow Diagram</xsl:attribute>
            <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.24 Data Flow Diagram</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">control-implementation</xsl:attribute>
            <xsl:attribute name="name">control-implementation</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
      </svrl:schematron-output>
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->
   <doc:xspec xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
              xmlns:sch="http://purl.oclc.org/dsdl/schematron"
              href="../test/ssp.xspec"/>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">FedRAMP System Security Plan Validations</svrl:text>
   <xsl:output xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               encoding="UTF-8"
               indent="yes"
               method="xml"/>
   <xsl:param xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
              xmlns:sch="http://purl.oclc.org/dsdl/schematron"
              as="xs:string"
              name="registry-base-path"
              select="'../../content/resources/xml'"/>
   <xsl:param xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
              xmlns:sch="http://purl.oclc.org/dsdl/schematron"
              as="xs:string"
              name="baselines-base-path"
              select="'../../../dist/content/baselines/rev4/xml'"/>
   <xsl:param name="registry"
              select="doc(concat($registry-base-path, '/fedramp_values.xml')) | doc(concat($registry-base-path, '/fedramp_threats.xml')) | doc(concat($registry-base-path, '/information-types.xml'))"/>
   <xsl:template xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
                 xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 as="element()"
                 name="analysis-template">
      <xsl:param as="element()*" name="value-set"/>
      <xsl:param as="element()*" name="element"/>
      <xsl:param as="node()*" name="errors"/>
      <xsl:variable name="ok-values" select="$value-set/f:allowed-values/f:enum/@value"/>
      <analysis>
         <errors>
            <xsl:if test="$errors">
               <xsl:sequence select="$errors"/>
            </xsl:if>
         </errors>
         <reports count="{count($element)}"
                  description="{$value-set/f:description}"
                  formal-name="{$value-set/f:formal-name}"
                  name="{$value-set/@name}">
            <xsl:for-each select="$ok-values">
               <xsl:variable name="match" select="$element[@value = current()]"/>
               <report count="{count($match)}" value="{current()}"/>
            </xsl:for-each>
         </reports>
      </analysis>
   </xsl:template>
   <xsl:template xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
                 xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 as="xs:string"
                 name="report-template">
      <xsl:param as="element()*" name="analysis"/>
      <xsl:value-of>There are 
        <xsl:value-of select="$analysis/reports/@count"/>  
        <xsl:value-of select="$analysis/reports/@formal-name"/>
         <xsl:choose>
            <xsl:when test="$analysis/reports/report">items total, with</xsl:when>
            <xsl:otherwise>items total.</xsl:otherwise>
         </xsl:choose>
         <xsl:for-each select="$analysis/reports/report">
            <xsl:if test="position() gt 0 and not(position() eq last())">
               <xsl:value-of select="current()/@count"/>set as 
            <xsl:value-of select="current()/@value"/>,</xsl:if>
            <xsl:if test="position() gt 0 and position() eq last()">and 
            <xsl:value-of select="current()/@count"/>set as 
            <xsl:value-of select="current()/@value"/>.</xsl:if>
            <xsl:sequence select="."/>
         </xsl:for-each>There are 
        <xsl:value-of select="($analysis/reports/@count - sum($analysis/reports/report/@count))"/>invalid items. 
        <xsl:if test="count($analysis/errors/error) &gt; 0">
            <xsl:message expand-text="yes">hit error block</xsl:message>
            <xsl:for-each select="$analysis/errors/error">Also, 
            <xsl:value-of select="current()/text()"/>, so analysis could be inaccurate or it completely failed.</xsl:for-each>
         </xsl:if>
      </xsl:value-of>
   </xsl:template>
   <!--PATTERN phase2-->
   <!--RULE -->
   <xsl:template match="/o:system-security-plan" priority="1011" mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/o:system-security-plan"/>
      <xsl:variable name="ok-values"
                    select="$registry/f:fedramp-values/f:value-set[@name = 'security-level']"/>
      <xsl:variable name="sensitivity-level"
                    select="/ =&gt; lv:sensitivity-level() =&gt; lv:if-empty-default('')"/>
      <xsl:variable name="corrections" select="lv:correct($ok-values, $sensitivity-level)"/>
      <!--ASSERT fatal-->
      <xsl:choose>
         <xsl:when test="count($registry/f:fedramp-values/f:value-set) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count($registry/f:fedramp-values/f:value-set) &gt; 0">
               <xsl:attribute name="id">no-registry-values</xsl:attribute>
               <xsl:attribute name="role">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The registry values are available.</svrl:text>
               <svrl:diagnostic-reference diagnostic="no-registry-values-diagnostic">
The registry values at the path ' 
        <xsl:text/>
                  <xsl:value-of select="$registry-base-path"/>
                  <xsl:text/>' are not present, this configuration is invalid.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT fatal-->
      <xsl:choose>
         <xsl:when test="$sensitivity-level != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$sensitivity-level != ''">
               <xsl:attribute name="id">no-security-sensitivity-level</xsl:attribute>
               <xsl:attribute name="role">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section C Check 1.a] Sensitivity level is defined.</svrl:text>
               <svrl:diagnostic-reference diagnostic="no-security-sensitivity-level-diagnostic">
[Section C Check 1.a] No sensitivity level was found As a result, no more
                        validation processing can occur.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT fatal-->
      <xsl:choose>
         <xsl:when test="empty($ok-values) or not(exists($corrections))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty($ok-values) or not(exists($corrections))">
               <xsl:attribute name="id">invalid-security-sensitivity-level</xsl:attribute>
               <xsl:attribute name="role">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section C Check 1.a] Sensitivity level has an allowed
                        value.</svrl:text>
               <svrl:diagnostic-reference diagnostic="invalid-security-sensitivity-level-diagnostic">
[Section C Check 1.a] 
        <xsl:text/>
                  <xsl:value-of select="./name()"/>
                  <xsl:text/>is an invalid value of ' 
        <xsl:text/>
                  <xsl:value-of select="lv:sensitivity-level(/)"/>
                  <xsl:text/>', not an allowed value of 
        <xsl:text/>
                  <xsl:value-of select="$corrections"/>
                  <xsl:text/>. No more validation processing can occur.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="implemented"
                    select="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement"/>
      <!--REPORT information-->
      <xsl:if test="exists($implemented)">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists($implemented)">
            <xsl:attribute name="id">implemented-response-points</xsl:attribute>
            <xsl:attribute name="role">information</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>[Section C Check 2] This SSP has implemented a statement for each of the following lettered
                        response points for required controls: 
            <xsl:text/>
               <xsl:value-of select="$implemented/@statement-id"/>
               <xsl:text/>.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/o:system-security-plan/o:control-implementation"
                 priority="1010"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/o:system-security-plan/o:control-implementation"/>
      <xsl:variable name="registry-ns"
                    select="$registry/f:fedramp-values/f:namespace/f:ns/@ns"/>
      <xsl:variable name="sensitivity-level" select="/ =&gt; lv:sensitivity-level()"/>
      <xsl:variable name="ok-values"
                    select="$registry/f:fedramp-values/f:value-set[@name = 'control-implementation-status']"/>
      <xsl:variable name="selected-profile" select="$sensitivity-level =&gt; lv:profile()"/>
      <xsl:variable name="required-controls" select="$selected-profile/*//o:control"/>
      <xsl:variable name="implemented" select="o:implemented-requirement"/>
      <xsl:variable name="all-missing"
                    select="$required-controls[not(@id = $implemented/@control-id)]"/>
      <xsl:variable name="core-missing"
                    select="$required-controls[o:prop[@name = 'CORE' and @ns = $registry-ns] and @id = $all-missing/@id]"/>
      <xsl:variable name="extraneous"
                    select="$implemented[not(@control-id = $required-controls/@id)]"/>
      <!--REPORT information-->
      <xsl:if test="count($required-controls) &gt; 0">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="count($required-controls) &gt; 0">
            <xsl:attribute name="id">each-required-control-report</xsl:attribute>
            <xsl:attribute name="role">information</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>The following 
            <xsl:text/>
               <xsl:value-of select="count($required-controls)"/>
               <xsl:text/>
               <xsl:text/>
               <xsl:value-of select="                         if (count($required-controls) = 1) then                             ' control'                         else                             ' controls'"/>
               <xsl:text/>are required: 
            <xsl:text/>
               <xsl:value-of select="$required-controls/@id"/>
               <xsl:text/>.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not(exists($core-missing))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(exists($core-missing))">
               <xsl:attribute name="id">incomplete-core-implemented-requirements</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section C Check 3] This SSP has implemented the most important controls.</svrl:text>
               <svrl:diagnostic-reference diagnostic="incomplete-core-implemented-requirements-diagnostic">
[Section C Check 3] This SSP has not implemented the most important 
        <xsl:text/>
                  <xsl:value-of select="count($core-missing)"/>
                  <xsl:text/>core 
        <xsl:text/>
                  <xsl:value-of select="                     if (count($core-missing) = 1) then                         ' control'                     else                         ' controls'"/>
                  <xsl:text/>: 
        <xsl:text/>
                  <xsl:value-of select="$core-missing/@id"/>
                  <xsl:text/>.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(exists($all-missing))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(exists($all-missing))">
               <xsl:attribute name="id">incomplete-all-implemented-requirements</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section C Check 2] This SSP has implemented all required controls.</svrl:text>
               <svrl:diagnostic-reference diagnostic="incomplete-all-implemented-requirements-diagnostic">
[Section C Check 2] This SSP has not implemented 
        <xsl:text/>
                  <xsl:value-of select="count($all-missing)"/>
                  <xsl:text/>
                  <xsl:text/>
                  <xsl:value-of select="                     if (count($all-missing) = 1) then                         ' control'                     else                         ' controls'"/>
                  <xsl:text/>overall: 
        <xsl:text/>
                  <xsl:value-of select="$all-missing/@id"/>
                  <xsl:text/>.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(exists($extraneous))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(exists($extraneous))">
               <xsl:attribute name="id">extraneous-implemented-requirements</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section C Check 2] This SSP has no extraneous implemented controls.</svrl:text>
               <svrl:diagnostic-reference diagnostic="extraneous-implemented-requirements-diagnostic">
[Section C Check 2] This SSP has implemented 
        <xsl:text/>
                  <xsl:value-of select="count($extraneous)"/>
                  <xsl:text/>extraneous 
        <xsl:text/>
                  <xsl:value-of select="                     if (count($extraneous) = 1) then                         ' control'                     else                         ' controls'"/>
                  <xsl:text/>not needed given the selected profile: 
        <xsl:text/>
                  <xsl:value-of select="$extraneous/@control-id"/>
                  <xsl:text/>.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="results"
                    select="$ok-values =&gt; lv:analyze(//o:implemented-requirement/o:prop[@name = 'implementation-status'])"/>
      <xsl:variable name="total" select="$results/reports/@count"/>
      <!--REPORT information-->
      <xsl:if test="count($results/errors/error) = 0">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="count($results/errors/error) = 0">
            <xsl:attribute name="id">control-implemented-requirements-stats</xsl:attribute>
            <xsl:attribute name="role">information</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
               <xsl:text/>
               <xsl:value-of select="$results =&gt; lv:report() =&gt; normalize-space()"/>
               <xsl:text/>.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/o:system-security-plan/o:control-implementation/o:implemented-requirement"
                 priority="1009"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/o:system-security-plan/o:control-implementation/o:implemented-requirement"/>
      <xsl:variable name="sensitivity-level"
                    select="/ =&gt; lv:sensitivity-level() =&gt; lv:if-empty-default('')"/>
      <xsl:variable name="selected-profile" select="$sensitivity-level =&gt; lv:profile()"/>
      <xsl:variable name="registry-ns"
                    select="$registry/f:fedramp-values/f:namespace/f:ns/@ns"/>
      <xsl:variable name="status" select="./o:prop[@name = 'implementation-status']/@value"/>
      <xsl:variable name="corrections"
                    select="lv:correct($registry/f:fedramp-values/f:value-set[@name = 'control-implementation-status'], $status)"/>
      <xsl:variable name="required-response-points"
                    select="$selected-profile/o:catalog//o:part[@name = 'item']"/>
      <xsl:variable name="implemented"
                    select="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement"/>
      <xsl:variable name="missing"
                    select="$required-response-points[not(@id = $implemented/@statement-id)]"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not(exists($corrections))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(exists($corrections))">
               <xsl:attribute name="id">invalid-implementation-status</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section C Check 2] Implementation status is correct.</svrl:text>
               <svrl:diagnostic-reference diagnostic="invalid-implementation-status-diagnostic">
[Section C Check 2] Invalid status ' 
        <xsl:text/>
                  <xsl:value-of select="$status"/>
                  <xsl:text/>' for 
        <xsl:text/>
                  <xsl:value-of select="./@control-id"/>
                  <xsl:text/>, must be 
        <xsl:text/>
                  <xsl:value-of select="$corrections"/>
                  <xsl:text/>.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not(exists($missing))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(exists($missing))">
               <xsl:attribute name="id">missing-response-points</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section C Check 2] This SSP has required response points.</svrl:text>
               <svrl:diagnostic-reference diagnostic="missing-response-points-diagnostic">
[Section C Check 2] This SSP has not implemented a statement for each of the
                        following lettered response points for required controls: 
        <xsl:text/>
                  <xsl:value-of select="$missing/@id"/>
                  <xsl:text/>.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement"
                 priority="1008"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement"/>
      <xsl:variable name="required-components-count" select="1"/>
      <xsl:variable name="required-length" select="20"/>
      <xsl:variable name="components-count" select="./o:by-component =&gt; count()"/>
      <xsl:variable name="remarks" select="./o:remarks =&gt; normalize-space()"/>
      <xsl:variable name="remarks-length" select="$remarks =&gt; string-length()"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="$components-count &gt;= $required-components-count"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$components-count &gt;= $required-components-count">
               <xsl:attribute name="id">missing-response-components</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section D Checks] Response statements have sufficient
                        components.</svrl:text>
               <svrl:diagnostic-reference diagnostic="missing-response-components-diagnostic">
[Section D Checks] Response statements for 
        <xsl:text/>
                  <xsl:value-of select="./@statement-id"/>
                  <xsl:text/>must have at least 
        <xsl:text/>
                  <xsl:value-of select="$required-components-count"/>
                  <xsl:text/>
                  <xsl:text/>
                  <xsl:value-of select="                     if (count($components-count) = 1) then                         ' component'                     else                         ' components'"/>
                  <xsl:text/>with a description. There are 
        <xsl:text/>
                  <xsl:value-of select="$components-count"/>
                  <xsl:text/>.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:description"
                 priority="1007"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:description"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test=". =&gt; empty()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test=". =&gt; empty()">
               <xsl:attribute name="id">extraneous-response-description</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section D Checks] Response statement does not have a description not within a component.</svrl:text>
               <svrl:diagnostic-reference diagnostic="extraneous-response-description-diagnostic">
[Section D Checks] Response statement 
        <xsl:text/>
                  <xsl:value-of select="../@statement-id"/>
                  <xsl:text/>has a description not within a component. That was previously allowed, but not recommended. It will
        soon be syntactically invalid and deprecated.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:remarks"
                 priority="1006"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:remarks"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test=". =&gt; empty()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test=". =&gt; empty()">
               <xsl:attribute name="id">extraneous-response-remarks</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section D Checks] Response statement does not have remarks not within a component.</svrl:text>
               <svrl:diagnostic-reference diagnostic="extraneous-response-remarks-diagnostic">
[Section D Checks] Response statement 
        <xsl:text/>
                  <xsl:value-of select="../@statement-id"/>
                  <xsl:text/>has remarks not within a component. That was previously allowed, but not recommended. It will soon
        be syntactically invalid and deprecated.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component"
                 priority="1005"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component"/>
      <xsl:variable name="component-ref" select="./@component-uuid"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="/o:system-security-plan/o:system-implementation/o:component[@uuid = $component-ref] =&gt; exists()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="/o:system-security-plan/o:system-implementation/o:component[@uuid = $component-ref] =&gt; exists()">
               <xsl:attribute name="id">invalid-component-match</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section D Checks]
                        Response statement cites a component in the system implementation inventory.</svrl:text>
               <svrl:diagnostic-reference diagnostic="invalid-component-match-diagnostic">
[Section D Checks] Response statement 
        <xsl:text/>
                  <xsl:value-of select="../@statement-id"/>
                  <xsl:text/>with component reference UUID ' 
        <xsl:text/>
                  <xsl:value-of select="$component-ref"/>
                  <xsl:text/>' is not in the system implementation inventory, and cannot be used to define a
        control.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="./o:description =&gt; exists()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="./o:description =&gt; exists()">
               <xsl:attribute name="id">missing-component-description</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section D Checks] Response statement has a component which has a required description
                        node.</svrl:text>
               <svrl:diagnostic-reference diagnostic="missing-component-description-diagnostic">
[Section D Checks] Response statement 
        <xsl:text/>
                  <xsl:value-of select="../@statement-id"/>
                  <xsl:text/>has a component, but that component is missing a required description node.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:description"
                 priority="1004"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:description"/>
      <xsl:variable name="required-length" select="20"/>
      <xsl:variable name="description" select=". =&gt; normalize-space()"/>
      <xsl:variable name="description-length" select="$description =&gt; string-length()"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="$description-length &gt;= $required-length"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$description-length &gt;= $required-length">
               <xsl:attribute name="id">incomplete-response-description</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section D Checks] Response statement component description has adequate
                        length.</svrl:text>
               <svrl:diagnostic-reference diagnostic="incomplete-response-description-diagnostic">
[Section D Checks] Response statement component description for 
        <xsl:text/>
                  <xsl:value-of select="../../@statement-id"/>
                  <xsl:text/>is too short with 
        <xsl:text/>
                  <xsl:value-of select="$description-length"/>
                  <xsl:text/>characters. It must be 
        <xsl:text/>
                  <xsl:value-of select="$required-length"/>
                  <xsl:text/>characters long.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:remarks"
                 priority="1003"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/o:system-security-plan/o:control-implementation/o:implemented-requirement/o:statement/o:by-component/o:remarks"/>
      <xsl:variable name="required-length" select="20"/>
      <xsl:variable name="remarks" select=". =&gt; normalize-space()"/>
      <xsl:variable name="remarks-length" select="$remarks =&gt; string-length()"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="$remarks-length &gt;= $required-length"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$remarks-length &gt;= $required-length">
               <xsl:attribute name="id">incomplete-response-remarks</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section D Checks] Response statement component remarks have adequate
                        length.</svrl:text>
               <svrl:diagnostic-reference diagnostic="incomplete-response-remarks-diagnostic">
[Section D Checks] Response statement component remarks for 
        <xsl:text/>
                  <xsl:value-of select="../../@statement-id"/>
                  <xsl:text/>is too short with 
        <xsl:text/>
                  <xsl:value-of select="$remarks-length"/>
                  <xsl:text/>characters. It must be 
        <xsl:text/>
                  <xsl:value-of select="$required-length"/>
                  <xsl:text/>characters long.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/o:system-security-plan/o:metadata"
                 priority="1002"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/o:system-security-plan/o:metadata"/>
      <xsl:variable name="parties" select="o:party"/>
      <xsl:variable name="roles" select="o:role"/>
      <xsl:variable name="responsible-parties" select="./o:responsible-party"/>
      <xsl:variable name="extraneous-roles"
                    select="$responsible-parties[not(@role-id = $roles/@id)]"/>
      <xsl:variable name="extraneous-parties"
                    select="$responsible-parties[not(o:party-uuid = $parties/@uuid)]"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not(exists($extraneous-roles))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(exists($extraneous-roles))">
               <xsl:attribute name="id">incorrect-role-association</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section C Check 2] This SSP has defined a responsible party with no extraneous
                        roles.</svrl:text>
               <svrl:diagnostic-reference diagnostic="incorrect-role-association-diagnostic">
[Section C Check 2] This SSP has defined a responsible party with 
        <xsl:text/>
                  <xsl:value-of select="count($extraneous-roles)"/>
                  <xsl:text/>
                  <xsl:text/>
                  <xsl:value-of select="                     if (count($extraneous-roles) = 1) then                         ' role'                     else                         ' roles'"/>
                  <xsl:text/>not defined in the role: 
        <xsl:text/>
                  <xsl:value-of select="$extraneous-roles/@role-id"/>
                  <xsl:text/>.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not(exists($extraneous-parties))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(exists($extraneous-parties))">
               <xsl:attribute name="id">incorrect-party-association</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section C Check 2] This SSP has defined a responsible party with no extraneous
                        parties.</svrl:text>
               <svrl:diagnostic-reference diagnostic="incorrect-party-association-diagnostic">
[Section C Check 2] This SSP has defined a responsible party with 
        <xsl:text/>
                  <xsl:value-of select="count($extraneous-parties)"/>
                  <xsl:text/>
                  <xsl:text/>
                  <xsl:value-of select="                     if (count($extraneous-parties) = 1) then                         ' party'                     else                         ' parties'"/>
                  <xsl:text/>is not a defined party: 
        <xsl:text/>
                  <xsl:value-of select="$extraneous-parties/o:party-uuid"/>
                  <xsl:text/>.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/o:system-security-plan/o:back-matter/o:resource"
                 priority="1001"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/o:system-security-plan/o:back-matter/o:resource"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@uuid"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@uuid">
               <xsl:attribute name="id">resource-uuid-required</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Every resource has a uuid attribute.</svrl:text>
               <svrl:diagnostic-reference diagnostic="resource-uuid-required-diagnostic">
This SSP includes back-matter resource missing a UUID.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/o:system-security-plan/o:back-matter/o:resource/o:base64"
                 priority="1000"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/o:system-security-plan/o:back-matter/o:resource/o:base64"/>
      <xsl:variable name="filename" select="@filename"/>
      <xsl:variable name="media-type" select="@media-type"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="./@filename"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@filename">
               <xsl:attribute name="id">resource-base64-available-filename</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>This base64 has a filename attribute.</svrl:text>
               <svrl:diagnostic-reference diagnostic="resource-base64-available-filename-diagnostic">
This base64 lacks a filename attribute.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="./@media-type"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="./@media-type">
               <xsl:attribute name="id">resource-base64-available-media-type</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>This base64 has a media-type attribute.</svrl:text>
               <svrl:diagnostic-reference diagnostic="resource-base64-available-media-type-diagnostic">
This base64 lacks a media-type attribute.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:param name="fedramp-values"
              select="doc(concat($registry-base-path, '/fedramp_values.xml'))"/>
   <!--PATTERN resourcesBasic resource constraints-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Basic resource constraints</svrl:text>
   <xsl:variable name="attachment-types"
                 select="$fedramp-values//fedramp:value-set[@name = 'attachment-type']//fedramp:enum/@value"/>
   <!--RULE -->
   <xsl:template match="oscal:resource" priority="1003" mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oscal:resource"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@uuid"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@uuid">
               <xsl:attribute name="id">resource-has-uuid</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A resource must have a uuid attribute.</svrl:text>
               <svrl:diagnostic-reference diagnostic="resource-has-uuid-diagnostic">
This resource lacks a uuid attribute.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="oscal:title"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:title">
               <xsl:attribute name="id">resource-has-title</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A resource should have a title.</svrl:text>
               <svrl:diagnostic-reference diagnostic="resource-has-title-diagnostic">
This resource lacks a title.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:rlink"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:rlink">
               <xsl:attribute name="id">resource-has-rlink</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A resource must have a rlink element</svrl:text>
               <svrl:diagnostic-reference diagnostic="resource-has-rlink-diagnostic">
This resource lacks a rlink element.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT information-->
      <xsl:choose>
         <xsl:when test="@uuid = (//@href[matches(., '^#')] ! substring-after(., '#'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@uuid = (//@href[matches(., '^#')] ! substring-after(., '#'))">
               <xsl:attribute name="id">resource-is-referenced</xsl:attribute>
               <xsl:attribute name="role">information</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A resource should be referenced from within the
                        document.</svrl:text>
               <svrl:diagnostic-reference diagnostic="resource-is-referenced-diagnostic">
This resource lacks a reference within the document (but does not).</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:back-matter/oscal:resource/oscal:prop[@name = 'type']"
                 priority="1002"
                 mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:back-matter/oscal:resource/oscal:prop[@name = 'type']"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="@value = $attachment-types"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@value = $attachment-types">
               <xsl:attribute name="id">attachment-type-is-valid</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A resource should have an allowed attachment-type property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="attachment-type-is-valid-diagnostic">
Found unknown attachment type « 
        <xsl:text/>
                  <xsl:value-of select="@value"/>
                  <xsl:text/>» in 
        <xsl:text/>
                  <xsl:value-of select="                     if (parent::oscal:resource/oscal:title) then                         concat('&#34;', parent::oscal:resource/oscal:title, '&#34;')                     else                         'untitled'"/>
                  <xsl:text/>resource.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:back-matter/oscal:resource/oscal:rlink"
                 priority="1001"
                 mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:back-matter/oscal:resource/oscal:rlink"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@href"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@href">
               <xsl:attribute name="id">rlink-has-href</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A resource rlink must have an href attribute.</svrl:text>
               <svrl:diagnostic-reference diagnostic="rlink-has-href-diagnostic">
This rlink lacks an href attribute.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:rlink | oscal:base64" priority="1000" mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:rlink | oscal:base64"
                       role="error"/>
      <xsl:variable name="media-types"
                    select="$fedramp-values//fedramp:value-set[@name = 'media-type']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@media-type = $media-types"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@media-type = $media-types">
               <xsl:attribute name="id">has-allowed-media-type</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A media-type attribute must have an allowed value.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-allowed-media-type-diagnostic">
This 
        <xsl:text/>
                  <xsl:value-of select="name(parent::node())"/>
                  <xsl:text/>has a media-type=" 
        <xsl:text/>
                  <xsl:value-of select="current()/@media-type"/>
                  <xsl:text/>" which is not in the list of allowed media types. Allowed media types are 
        <xsl:text/>
                  <xsl:value-of select="string-join($media-types, ' ∨ ')"/>
                  <xsl:text/>.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <!--PATTERN base64base64 attachments-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">base64 attachments</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:back-matter/oscal:resource" priority="1001" mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:back-matter/oscal:resource"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="oscal:base64"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:base64">
               <xsl:attribute name="id">resource-has-base64</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A resource should have a base64 element.</svrl:text>
               <svrl:diagnostic-reference diagnostic="resource-has-base64-diagnostic">
This resource should have a base64 element.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not(oscal:base64[2])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(oscal:base64[2])">
               <xsl:attribute name="id">resource-has-base64-cardinality</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A resource must have only one base64 element.</svrl:text>
               <svrl:diagnostic-reference diagnostic="resource-base64-cardinality-diagnostic">
This resource must not have more than one base64 element.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:back-matter/oscal:resource/oscal:base64"
                 priority="1000"
                 mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:back-matter/oscal:resource/oscal:base64"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@filename"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@filename">
               <xsl:attribute name="id">base64-has-filename</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A base64 element must have a filename attribute.</svrl:text>
               <svrl:diagnostic-reference diagnostic="base64-has-filename-diagnostic">
This base64 must have a filename attribute.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@media-type"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@media-type">
               <xsl:attribute name="id">base64-has-media-type</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A base64 element must have a media-type attribute.</svrl:text>
               <svrl:diagnostic-reference diagnostic="base64-has-media-type-diagnostic">
This base64 must have a media-type attribute.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(), '^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(), '^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$')">
               <xsl:attribute name="id">base64-has-content</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A
                        base64 element must have content.</svrl:text>
               <svrl:diagnostic-reference diagnostic="base64-has-content-diagnostic">
This base64 must have content.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <!--PATTERN specific-attachmentsConstraints for specific attachments-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Constraints for specific attachments</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:back-matter" priority="1000" mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oscal:back-matter">
         <xsl:attribute name="see">https://github.com/18F/fedramp-automation/blob/master/documents/Guide_to_OSCAL-based_FedRAMP_System_Security_Plans_(SSP).pdf</xsl:attribute>
      </svrl:fired-rule>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-acronyms']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-acronyms']]">
               <xsl:attribute name="id">has-fedramp-acronyms</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A
                        FedRAMP OSCAL SSP must have the FedRAMP Master Acronym and Glossary attached.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-fedramp-acronyms-diagnostic">
This FedRAMP OSCAL SSP lacks the FedRAMP Master Acronym and Glossary.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-citations']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-citations']]">
               <xsl:attribute name="id">has-fedramp-citations</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                        [Section B Check 3.12] A FedRAMP OSCAL SSP must have the FedRAMP Applicable Laws and Regulations attached.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-fedramp-citations-diagnostic">
This FedRAMP OSCAL SSP lacks the FedRAMP Applicable Laws and
                        Regulations.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-logo']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'fedramp-logo']]">
               <xsl:attribute name="id">has-fedramp-logo</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A
                        FedRAMP OSCAL SSP must have the FedRAMP Logo attached.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-fedramp-logo-diagnostic">
This FedRAMP OSCAL SSP lacks the FedRAMP Logo.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'user-guide']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'user-guide']]">
               <xsl:attribute name="id">has-user-guide</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section
                        B Check 3.2] A FedRAMP OSCAL SSP must have a User Guide attached.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-user-guide-diagnostic">
This FedRAMP OSCAL SSP lacks a User Guide.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'rules-of-behavior']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'rules-of-behavior']]">
               <xsl:attribute name="id">has-rules-of-behavior</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                        [Section B Check 3.5] A FedRAMP OSCAL SSP must have Rules of Behavior.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-rules-of-behavior-diagnostic">
This FedRAMP OSCAL SSP lacks a Rules of Behavior.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'information-system-contingency-plan']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'information-system-contingency-plan']]">
               <xsl:attribute name="id">has-information-system-contingency-plan</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [Section B Check 3.6] A FedRAMP OSCAL SSP must have a Contingency Plan attached.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-information-system-contingency-plan-diagnostic">
This FedRAMP OSCAL SSP lacks a Contingency Plan.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'configuration-management-plan']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'configuration-management-plan']]">
               <xsl:attribute name="id">has-configuration-management-plan</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                        [Section B Check 3.7] A FedRAMP OSCAL SSP must have a Configuration Management Plan attached.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-configuration-management-plan-diagnostic">
This FedRAMP OSCAL SSP lacks a Configuration Management
                        Plan.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'incident-response-plan']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'incident-response-plan']]">
               <xsl:attribute name="id">has-incident-response-plan</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                        [Section B Check 3.8] A FedRAMP OSCAL SSP must have an Incident Response Plan attached.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-incident-response-plan-diagnostic">
This FedRAMP OSCAL SSP lacks an Incident Response Plan.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'separation-of-duties-matrix']]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'separation-of-duties-matrix']]">
               <xsl:attribute name="id">has-separation-of-duties-matrix</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                        [Section B Check 3.11] A FedRAMP OSCAL SSP must have a Separation of Duties Matrix attached.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-separation-of-duties-matrix-diagnostic">
This FedRAMP OSCAL SSP lacks a Separation of Duties Matrix.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <!--PATTERN policy-and-procedurePolicy and Procedure attachments A FedRAMP SSP must incorporate one policy document and one procedure document for each of the 17 NIST SP 800-54 Revision 4 control
        families-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Policy and Procedure attachments</svrl:text>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">A FedRAMP SSP must incorporate one policy document and one procedure document for each of the 17 NIST SP 800-54 Revision 4 control
        families</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')]"
                 priority="1001"
                 mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')]">
         <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6</xsl:attribute>
      </svrl:fired-rule>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="descendant::oscal:by-component/oscal:link[@rel = 'policy']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::oscal:by-component/oscal:link[@rel = 'policy']">
               <xsl:attribute name="id">has-policy-link</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.1] A FedRAMP SSP must incorporate a
                        policy document for each of the 17 NIST SP 800-54 Revision 4 control families.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-policy-link-diagnostic">
                  <xsl:text/>
                  <xsl:value-of select="local-name()"/>
                  <xsl:text/>
                  <xsl:text/>
                  <xsl:value-of select="@control-id"/>
                  <xsl:text/>
                  <sch:span xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
                            xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                            class="message">lacks policy reference(s) (via by-component link)</sch:span>.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="policy-hrefs"
                    select="distinct-values(descendant::oscal:by-component/oscal:link[@rel = 'policy']/@href ! substring-after(., '#'))"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="                     every $ref in $policy-hrefs                         satisfies exists(//oscal:resource[oscal:prop[@name = 'type' and @value = 'policy']][@uuid = $ref])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $ref in $policy-hrefs satisfies exists(//oscal:resource[oscal:prop[@name = 'type' and @value = 'policy']][@uuid = $ref])">
               <xsl:attribute name="id">has-policy-attachment-resource</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.1] A
FedRAMP SSP must incorporate a policy document for each of the 17 NIST SP 800-54 Revision 4 control families.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-policy-attachment-resource-diagnostic">
                  <xsl:text/>
                  <xsl:value-of select="local-name()"/>
                  <xsl:text/>
                  <xsl:text/>
                  <xsl:value-of select="@control-id"/>
                  <xsl:text/>
                  <sch:span xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
                            xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                            class="message">lacks policy attachment resource(s)</sch:span>
                  <xsl:text/>
                  <xsl:value-of select="string-join($policy-hrefs, ', ')"/>
                  <xsl:text/>.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="descendant::oscal:by-component/oscal:link[@rel = 'procedure']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::oscal:by-component/oscal:link[@rel = 'procedure']">
               <xsl:attribute name="id">has-procedure-link</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.1] A FedRAMP SSP must incorporate a
                        procedure document for each of the 17 NIST SP 800-54 Revision 4 control families.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-procedure-link-diagnostic">
                  <xsl:text/>
                  <xsl:value-of select="local-name()"/>
                  <xsl:text/>
                  <xsl:text/>
                  <xsl:value-of select="@control-id"/>
                  <xsl:text/>
                  <sch:span xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
                            xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                            class="message">lacks procedure reference(s) (via by-component link)</sch:span>.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="procedure-hrefs"
                    select="distinct-values(descendant::oscal:by-component/oscal:link[@rel = 'procedure']/@href ! substring-after(., '#'))"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="                     (: targets of links exist in the document :)                     every $ref in $procedure-hrefs                         satisfies exists(//oscal:resource[oscal:prop[@name = 'type' and @value = 'procedure']][@uuid = $ref])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(: targets of links exist in the document :) every $ref in $procedure-hrefs satisfies exists(//oscal:resource[oscal:prop[@name = 'type' and @value = 'procedure']][@uuid = $ref])">
               <xsl:attribute name="id">has-procedure-attachment-resource</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.1]
A FedRAMP SSP must incorporate a procedure document for each of the 17 NIST SP 800-54 Revision 4 control families.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-procedure-attachment-resource-diagnostic">
                  <xsl:text/>
                  <xsl:value-of select="local-name()"/>
                  <xsl:text/>
                  <xsl:text/>
                  <xsl:value-of select="@control-id"/>
                  <xsl:text/>
                  <sch:span xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
                            xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                            class="message">lacks procedure attachment resource(s)</sch:span>
                  <xsl:text/>
                  <xsl:value-of select="string-join($procedure-hrefs, ', ')"/>
                  <xsl:text/>.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:by-component/oscal:link[@rel = ('policy', 'procedure')]"
                 priority="1000"
                 mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:by-component/oscal:link[@rel = ('policy', 'procedure')]"/>
      <xsl:variable name="ir" select="ancestor::oscal:implemented-requirement"/>
      <!--REPORT error-->
      <xsl:if test="                     (: the current @href is in :)                     @href = (: all controls except the current :) (//oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')] except $ir) (: all their @hrefs :)/descendant::oscal:by-component/oscal:link[@rel = 'policy']/@href">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="(: the current @href is in :) @href = (: all controls except the current :) (//oscal:implemented-requirement[matches(@control-id, '^[a-z]{2}-1$')] except $ir) (: all their @hrefs :)/descendant::oscal:by-component/oscal:link[@rel = 'policy']/@href">
            <xsl:attribute name="id">has-reuse</xsl:attribute>
            <xsl:attribute name="role">error</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
            [Section B Check 3.1] Policy and procedure documents must have unique per-control-family associations.</svrl:text>
            <svrl:diagnostic-reference diagnostic="has-reuse-diagnostic">
A policy or procedure reference was incorrectly re-used.</svrl:diagnostic-reference>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <!--PATTERN privacy1A FedRAMP OSCAL SSP must specify a Privacy Point of Contact-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">A FedRAMP OSCAL SSP must specify a Privacy Point of Contact</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:metadata" priority="1000" mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oscal:metadata">
         <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.2</xsl:attribute>
      </svrl:fired-rule>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="/oscal:system-security-plan/oscal:metadata/oscal:role[@id = 'privacy-poc']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="/oscal:system-security-plan/oscal:metadata/oscal:role[@id = 'privacy-poc']">
               <xsl:attribute name="id">has-privacy-poc-role</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.4] A FedRAMP OSCAL SSP
                        must incorporate a Privacy Point of Contact role.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-privacy-poc-role-diagnostic">
This FedRAMP OSCAL SSP lacks a Privacy Point of Contact role.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']">
               <xsl:attribute name="id">has-responsible-party-privacy-poc-role</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.4] A
                        FedRAMP OSCAL SSP must declare a Privacy Point of Contact responsible party role reference.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-responsible-party-privacy-poc-role-diagnostic">
This FedRAMP OSCAL SSP lacks a Privacy Point of Contact responsible
                        party role reference.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']/oscal:party-uuid"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']/oscal:party-uuid">
               <xsl:attribute name="id">has-responsible-privacy-poc-party-uuid</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section
                        B Check 3.4] A FedRAMP OSCAL SSP must declare a Privacy Point of Contact responsible party role reference identifying the
                        party by UUID.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-responsible-privacy-poc-party-uuid-diagnostic">
This FedRAMP OSCAL SSP lacks a Privacy Point of Contact responsible
                        party role reference identifying the party by UUID.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="poc-uuid"
                    select="/oscal:system-security-plan/oscal:metadata/oscal:responsible-party[@role-id = 'privacy-poc']/oscal:party-uuid"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="/oscal:system-security-plan/oscal:metadata/oscal:party[@uuid = $poc-uuid]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="/oscal:system-security-plan/oscal:metadata/oscal:party[@uuid = $poc-uuid]">
               <xsl:attribute name="id">has-privacy-poc</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.4] A FedRAMP OSCAL SSP
                        must define a Privacy Point of Contact.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-privacy-poc-diagnostic">
This FedRAMP OSCAL SSP lacks a Privacy Point of Contact.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <!--PATTERN privacy2A FedRAMP OSCAL SSP may need to incorporate a PIA and possibly a SORN-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">A FedRAMP OSCAL SSP may need to incorporate a PIA and possibly a SORN</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:prop[@name = 'privacy-sensitive'] | oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and matches(@name, '^pta-\d$')]"
                 priority="1002"
                 mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:prop[@name = 'privacy-sensitive'] | oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and matches(@name, '^pta-\d$')]">
         <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4</xsl:attribute>
      </svrl:fired-rule>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="current()/@value = ('yes', 'no')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="current()/@value = ('yes', 'no')">
               <xsl:attribute name="id">has-correct-yes-or-no-answer</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.4] A Privacy Threshold Analysis (PTA)/Privacy Impact Analysis
                        (PIA) qualifying question must have an allowed answer.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-correct-yes-or-no-answer-diagnostic">
This property has an incorrect value: should be "yes" or "no".</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information"
                 priority="1001"
                 mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/oscal:system-security-plan/oscal:system-characteristics/oscal:system-information">
         <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4</xsl:attribute>
      </svrl:fired-rule>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@name = 'privacy-sensitive']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@name = 'privacy-sensitive']">
               <xsl:attribute name="id">has-privacy-sensitive-designation</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.4] A FedRAMP OSCAL SSP must have a privacy-sensitive
                        designation.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-privacy-sensitive-designation-diagnostic">
The privacy-sensitive designation is missing.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-1']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-1']">
               <xsl:attribute name="id">has-pta-question-1</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.4] A
                        FedRAMP OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question
                        #1.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-pta-question-1-diagnostic">
The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #1
                        is missing.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-2']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-2']">
               <xsl:attribute name="id">has-pta-question-2</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.4] A
                        FedRAMP OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question
                        #2.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-pta-question-2-diagnostic">
The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #2
                        is missing.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-3']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-3']">
               <xsl:attribute name="id">has-pta-question-3</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.4] A
                        FedRAMP OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question
                        #3.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-pta-question-3-diagnostic">
The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #3
                        is missing.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-4']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-4']">
               <xsl:attribute name="id">has-pta-question-4</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.4] A
                        FedRAMP OSCAL SSP must have Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question
                        #4.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-pta-question-4-diagnostic">
The Privacy Threshold Analysis (PTA)/Privacy Impact Analysis (PIA) qualifying question #4
                        is missing.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="                     every $name in ('pta-1', 'pta-2', 'pta-3', 'pta-4')                         satisfies exists(oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = $name])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $name in ('pta-1', 'pta-2', 'pta-3', 'pta-4') satisfies exists(oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = $name])">
               <xsl:attribute name="id">has-all-pta-questions</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check
3.4] A FedRAMP OSCAL SSP must have all four PTA questions.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-all-pta-questions-diagnostic">
One or more of the four PTA questions is missing.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="                     not(some $name in ('pta-1', 'pta-2', 'pta-3', 'pta-4')                         satisfies exists(oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = $name][2]))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(some $name in ('pta-1', 'pta-2', 'pta-3', 'pta-4') satisfies exists(oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = $name][2]))">
               <xsl:attribute name="id">has-correct-pta-question-cardinality</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check
3.4] A FedRAMP OSCAL SSP must have no duplicate PTA questions.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-correct-pta-question-cardinality-diagnostic">
One or more of the four PTA questions is a duplicate.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-4' and @value = 'yes'] and oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'sorn-id' (: and @value != '':)]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'pta-4' and @value = 'yes'] and oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and @name = 'sorn-id' (: and @value != '':)]">
               <xsl:attribute name="id">has-sorn</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [Section B Check 3.4] A FedRAMP OSCAL SSP may have a SORN ID.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-sorn-diagnostic">
The SORN ID is missing.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:back-matter" priority="1000" mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oscal:back-matter">
         <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.4</xsl:attribute>
      </svrl:fired-rule>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="                     every $answer in //oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and matches(@name, '^pta-\d$')]                         satisfies $answer = 'no' or oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'pia']] (: a PIA is attached :)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $answer in //oscal:system-information/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'pta' and matches(@name, '^pta-\d$')] satisfies $answer = 'no' or oscal:resource[oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'type' and @value = 'pia']] (: a PIA is attached :)">
               <xsl:attribute name="id">has-pia</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            [Section B Check 3.4] This FedRAMP OSCAL SSP must incorporate a Privacy Impact Analysis.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-pia-diagnostic">
This FedRAMP OSCAL SSP lacks a Privacy Impact Analysis.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <!--PATTERN fips-140FIPS 140 Validation-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">FIPS 140 Validation</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:system-implementation" priority="1003" mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:system-implementation"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:component[@type = 'validation']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:component[@type = 'validation']">
               <xsl:attribute name="id">has-CMVP-validation</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP must incorporate one or more FIPS 140 validated
                        modules.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-CMVP-validation-diagnostic">
This FedRAMP OSCAL SSP does not declare one or more FIPS 140 validated
                        modules.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:component[@type = 'validation']"
                 priority="1002"
                 mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:component[@type = 'validation']"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@name = 'validation-reference']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@name = 'validation-reference']">
               <xsl:attribute name="id">has-CMVP-validation-reference</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A validation component or inventory-item must have a validation-reference
                        property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-CMVP-validation-reference-diagnostic">
This validation component or inventory-item lacks a validation-reference
                        property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:link[@rel = 'validation-details']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:link[@rel = 'validation-details']">
               <xsl:attribute name="id">has-CMVP-validation-details</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A validation component or inventory-item must have a validation-details
                        link.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-CMVP-validation-details-diagnostic">
This validation component or inventory-item lacks a validation-details
                        link.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:prop[@name = 'validation-reference']"
                 priority="1001"
                 mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:prop[@name = 'validation-reference']"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="matches(@value, '^\d{3,4}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(@value, '^\d{3,4}$')">
               <xsl:attribute name="id">has-credible-CMVP-validation-reference</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A validation-reference property must provide a CMVP certificate number.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-credible-CMVP-validation-reference-diagnostic">
This validation-reference property does not resemble a CMVP
                        certificate number.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@value = tokenize(following-sibling::oscal:link[@rel = 'validation-details']/@href, '/')[last()]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@value = tokenize(following-sibling::oscal:link[@rel = 'validation-details']/@href, '/')[last()]">
               <xsl:attribute name="id">has-consonant-CMVP-validation-reference</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A
                        validation-reference property must be in accord with its sibling validation-details href.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-consonant-CMVP-validation-reference-diagnostic">
This validation-reference property does not match its sibling
                        validation-details href.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:link[@rel = 'validation-details']"
                 priority="1000"
                 mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:link[@rel = 'validation-details']"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="matches(@href, '^https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/\d{3,4}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(@href, '^https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/\d{3,4}$')">
               <xsl:attribute name="id">has-credible-CMVP-validation-details</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A
                        validation-details link must refer to a NIST CMVP certificate detail page.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-credible-CMVP-validation-details-diagnostic">
This validation-details link href attribute does not resemble a CMVP
                        certificate URL.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="tokenize(@href, '/')[last()] = preceding-sibling::oscal:prop[@name = 'validation-reference']/@value"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="tokenize(@href, '/')[last()] = preceding-sibling::oscal:prop[@name = 'validation-reference']/@value">
               <xsl:attribute name="id">has-consonant-CMVP-validation-details</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A
                        validation-details link must be in accord with its sibling validation-reference.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-consonant-CMVP-validation-details-diagnostic">
This validation-details link href attribute does not match its sibling
                        validation-reference value.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <!--PATTERN fips-199Security Objectives Categorization (FIPS 199)-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Security Objectives Categorization (FIPS 199)</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:system-characteristics" priority="1003" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:system-characteristics"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:security-sensitivity-level"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:security-sensitivity-level">
               <xsl:attribute name="id">has-security-sensitivity-level</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP must specify a FIPS 199 categorization.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-security-sensitivity-level-diagnostic">
This FedRAMP OSCAL SSP lacks a FIPS 199 categorization.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:security-impact-level"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:security-impact-level">
               <xsl:attribute name="id">has-security-impact-level</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP must specify a security impact level.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-security-impact-level-diagnostic">
This FedRAMP OSCAL SSP lacks a security impact level.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:security-sensitivity-level" priority="1002" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:security-sensitivity-level"/>
      <xsl:variable name="security-sensitivity-levels"
                    select="$fedramp-values//fedramp:value-set[@name = 'security-level']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="current() = $security-sensitivity-levels"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="current() = $security-sensitivity-levels">
               <xsl:attribute name="id">has-allowed-security-sensitivity-level</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP must specify an allowed
                        security-sensitivity-level.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-allowed-security-sensitivity-level-diagnostic">
Invalid security-sensitivity-level " 
        <xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>". It must have one of the following 
        <xsl:text/>
                  <xsl:value-of select="count($security-sensitivity-levels)"/>
                  <xsl:text/>values: 
        <xsl:text/>
                  <xsl:value-of select="string-join($security-sensitivity-levels, ' ∨ ')"/>
                  <xsl:text/>.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:security-impact-level" priority="1001" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:security-impact-level"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:security-objective-confidentiality"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:security-objective-confidentiality">
               <xsl:attribute name="id">has-security-objective-confidentiality</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP must specify a confidentiality security
                        objective.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-security-objective-confidentiality-diagnostic">
This FedRAMP OSCAL SSP lacks a confidentiality security
                        objective.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:security-objective-integrity"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:security-objective-integrity">
               <xsl:attribute name="id">has-security-objective-integrity</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP must specify an integrity security objective.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-security-objective-integrity-diagnostic">
This FedRAMP OSCAL SSP lacks an integrity security
                        objective.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:security-objective-availability"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:security-objective-availability">
               <xsl:attribute name="id">has-security-objective-availability</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP must specify an availability security
                        objective.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-security-objective-availability-diagnostic">
This FedRAMP OSCAL SSP lacks an availability security
                        objective.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:security-objective-confidentiality | oscal:security-objective-integrity | oscal:security-objective-availability"
                 priority="1000"
                 mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:security-objective-confidentiality | oscal:security-objective-integrity | oscal:security-objective-availability"/>
      <xsl:variable name="security-objective-levels"
                    select="$fedramp-values//fedramp:value-set[@name = 'security-level']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="current() = $security-objective-levels"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="current() = $security-objective-levels">
               <xsl:attribute name="id">has-allowed-security-objective-value</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP must specify an allowed security objective
                        value.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-allowed-security-objective-value-diagnostic">
Invalid 
        <xsl:text/>
                  <xsl:value-of select="name()"/>
                  <xsl:text/>" 
        <xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>". It must have one of the following 
        <xsl:text/>
                  <xsl:value-of select="count($security-objective-levels)"/>
                  <xsl:text/>values: 
        <xsl:text/>
                  <xsl:value-of select="string-join($security-objective-levels, ' ∨ ')"/>
                  <xsl:text/>.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <!--PATTERN sp800-60SP 800-60v2r1 Information Types:-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">SP 800-60v2r1 Information Types:</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:system-information" priority="1005" mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:system-information"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:information-type"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:information-type">
               <xsl:attribute name="id">system-information-has-information-type</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP must specify at least one information-type.</svrl:text>
               <svrl:diagnostic-reference diagnostic="system-information-has-information-type-diagnostic">
A FedRAMP OSCAL SSP lacks at least one
                        information-type.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:information-type" priority="1004" mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:information-type"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:title"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:title">
               <xsl:attribute name="id">information-type-has-title</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP information-type must have a title.</svrl:text>
               <svrl:diagnostic-reference diagnostic="information-type-has-title-diagnostic">
A FedRAMP OSCAL SSP information-type lacks a title.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:description"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:description">
               <xsl:attribute name="id">information-type-has-description</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP information-type must have a description.</svrl:text>
               <svrl:diagnostic-reference diagnostic="information-type-has-description-diagnostic">
A FedRAMP OSCAL SSP information-type lacks a description.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:categorization"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:categorization">
               <xsl:attribute name="id">information-type-has-categorization</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP information-type must have at least one categorization.</svrl:text>
               <svrl:diagnostic-reference diagnostic="information-type-has-categorization-diagnostic">
A FedRAMP OSCAL SSP information-type lacks at least one
                        categorization.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:confidentiality-impact"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:confidentiality-impact">
               <xsl:attribute name="id">information-type-has-confidentiality-impact</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP information-type must have a confidentiality-impact.</svrl:text>
               <svrl:diagnostic-reference diagnostic="information-type-has-confidentiality-impact-diagnostic">
A FedRAMP OSCAL SSP information-type lacks a
                        confidentiality-impact.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:integrity-impact"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:integrity-impact">
               <xsl:attribute name="id">information-type-has-integrity-impact</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP information-type must have a integrity-impact.</svrl:text>
               <svrl:diagnostic-reference diagnostic="information-type-has-integrity-impact-diagnostic">
A FedRAMP OSCAL SSP information-type lacks a
                        integrity-impact.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:availability-impact"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:availability-impact">
               <xsl:attribute name="id">information-type-has-availability-impact</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP information-type must have a availability-impact.</svrl:text>
               <svrl:diagnostic-reference diagnostic="information-type-has-availability-impact-diagnostic">
A FedRAMP OSCAL SSP information-type lacks a
                        availability-impact.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:categorization" priority="1003" mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oscal:categorization"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@system"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@system">
               <xsl:attribute name="id">categorization-has-system-attribute</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP information-type categorization must have a system attribute.</svrl:text>
               <svrl:diagnostic-reference diagnostic="categorization-has-system-attribute-diagnostic">
A FedRAMP OSCAL SSP information-type categorization lacks a system
                        attribute.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@system = 'https://doi.org/10.6028/NIST.SP.800-60v2r1'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@system = 'https://doi.org/10.6028/NIST.SP.800-60v2r1'">
               <xsl:attribute name="id">categorization-has-correct-system-attribute</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP information-type categorization must have a
                        correct system attribute.</svrl:text>
               <svrl:diagnostic-reference diagnostic="categorization-has-correct-system-attribute-diagnostic">
A FedRAMP OSCAL SSP information-type categorization lacks a
                        correct system attribute. The correct value is "https://doi.org/10.6028/NIST.SP.800-60v2r1".</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:information-type-id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:information-type-id">
               <xsl:attribute name="id">categorization-has-information-type-id</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP information-type categorization must have at least one
                        information-type-id.</svrl:text>
               <svrl:diagnostic-reference diagnostic="categorization-has-information-type-id-diagnostic">
A FedRAMP OSCAL SSP information-type categorization lacks at least one
                        information-type-id.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:information-type-id" priority="1002" mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:information-type-id"/>
      <xsl:variable name="information-types"
                    select="doc(concat($registry-base-path, '/information-types.xml'))//fedramp:information-type/@id"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="current()[. = $information-types]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="current()[. = $information-types]">
               <xsl:attribute name="id">has-allowed-information-type-id</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP information-type-id must have a SP 800-60v2r1
                        identifier.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-allowed-information-type-id-diagnostic">
A FedRAMP OSCAL SSP information-type-id lacks a SP 800-60v2r1
                        identifier.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:confidentiality-impact | oscal:integrity-impact | oscal:availability-impact"
                 priority="1001"
                 mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:confidentiality-impact | oscal:integrity-impact | oscal:availability-impact"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:base"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:base">
               <xsl:attribute name="id">cia-impact-has-base</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact must have a base
                        element.</svrl:text>
               <svrl:diagnostic-reference diagnostic="cia-impact-has-base-diagnostic">
A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact
                        lacks a base element.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:selected"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:selected">
               <xsl:attribute name="id">cia-impact-has-selected</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact must have a
                        selected element.</svrl:text>
               <svrl:diagnostic-reference diagnostic="cia-impact-has-selected-diagnostic">
A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or
                        availability-impact lacks a selected element.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:base | oscal:selected" priority="1000" mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:base | oscal:selected"/>
      <xsl:variable name="fips-199-levels"
                    select="$fedramp-values//fedramp:value-set[@name = 'security-level']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test=". = $fips-199-levels"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test=". = $fips-199-levels">
               <xsl:attribute name="id">cia-impact-has-approved-fips-categorization</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP information-type confidentiality-, integrity-, or availability-impact base or
                        select element must have an approved value.</svrl:text>
               <svrl:diagnostic-reference diagnostic="cia-impact-has-approved-fips-categorization-diagnostic">
A FedRAMP OSCAL SSP information-type confidentiality-,
                        integrity-, or availability-impact base or select element lacks an approved value.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <!--PATTERN sp800-63Digital Identity Determination-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Digital Identity Determination</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:system-characteristics" priority="1004" mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:system-characteristics"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'security-eauth' and @name = 'security-eauth-level']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'security-eauth' and @name = 'security-eauth-level']">
               <xsl:attribute name="id">has-security-eauth-level</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                        [Section B Check 3.3] A FedRAMP OSCAL SSP must have a Digital Identity Determination property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-security-eauth-level-diagnostic">
This FedRAMP OSCAL SSP lacks a Digital Identity Determination
                        property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT information-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@name = 'identity-assurance-level']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@name = 'identity-assurance-level']">
               <xsl:attribute name="id">has-identity-assurance-level</xsl:attribute>
               <xsl:attribute name="role">information</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.3] A FedRAMP OSCAL SSP may have a Digital Identity
                        Determination identity-assurance-level property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-identity-assurance-level-diagnostic">
A FedRAMP OSCAL SSP may lack a Digital Identity Determination
                        identity-assurance-level property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT information-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@name = 'authenticator-assurance-level']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@name = 'authenticator-assurance-level']">
               <xsl:attribute name="id">has-authenticator-assurance-level</xsl:attribute>
               <xsl:attribute name="role">information</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.3] A FedRAMP OSCAL SSP may have a Digital
                        Identity Determination authenticator-assurance-level property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-authenticator-assurance-level-diagnostic">
A FedRAMP OSCAL SSP may lack a Digital Identity Determination
                        authenticator-assurance-level property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT information-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@name = 'federation-assurance-level']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@name = 'federation-assurance-level']">
               <xsl:attribute name="id">has-federation-assurance-level</xsl:attribute>
               <xsl:attribute name="role">information</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.3] A FedRAMP OSCAL SSP may have a Digital Identity
                        Determination federation-assurance-level property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-federation-assurance-level-diagnostic">
A FedRAMP OSCAL SSP may lack a Digital Identity Determination
                        federation-assurance-level property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'security-eauth' and @name = 'security-eauth-level']"
                 priority="1003"
                 mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @class = 'security-eauth' and @name = 'security-eauth-level']"
                       role="error"/>
      <xsl:variable name="eauth-levels"
                    select="$fedramp-values//fedramp:value-set[@name = 'eauth-level']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@value = $eauth-levels"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@value = $eauth-levels">
               <xsl:attribute name="id">has-allowed-security-eauth-level</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.3] A FedRAMP OSCAL SSP must have a Digital Identity Determination property
                        with an allowed value.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-allowed-security-eauth-level-diagnostic">
This FedRAMP OSCAL SSP lacks a Digital Identity Determination property with
                        an allowed value.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:prop[@name = 'identity-assurance-level']"
                 priority="1002"
                 mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:prop[@name = 'identity-assurance-level']"/>
      <xsl:variable name="identity-assurance-levels"
                    select="$fedramp-values//fedramp:value-set[@name = 'identity-assurance-level']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@value = $identity-assurance-levels"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@value = $identity-assurance-levels">
               <xsl:attribute name="id">has-allowed-identity-assurance-level</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.3] A FedRAMP OSCAL SSP should have an allowed Digital Identity
                        Determination identity-assurance-level property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-allowed-identity-assurance-level-diagnostic">
A FedRAMP OSCAL SSP may lack an allowed Digital Identity Determination
                        identity-assurance-level property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:prop[@name = 'authenticator-assurance-level']"
                 priority="1001"
                 mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:prop[@name = 'authenticator-assurance-level']"/>
      <xsl:variable name="authenticator-assurance-levels"
                    select="$fedramp-values//fedramp:value-set[@name = 'authenticator-assurance-level']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@value = $authenticator-assurance-levels"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@value = $authenticator-assurance-levels">
               <xsl:attribute name="id">has-allowed-authenticator-assurance-level</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.3] A FedRAMP OSCAL SSP should have an allowed Digital
                        Identity Determination authenticator-assurance-level property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-allowed-authenticator-assurance-level-diagnostic">
A FedRAMP OSCAL SSP may lack an allowed Digital Identity
                        Determination authenticator-assurance-level property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:prop[@name = 'federation-assurance-level']"
                 priority="1000"
                 mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:prop[@name = 'federation-assurance-level']"/>
      <xsl:variable name="federation-assurance-levels"
                    select="$fedramp-values//fedramp:value-set[@name = 'federation-assurance-level']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@value = $federation-assurance-levels"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@value = $federation-assurance-levels">
               <xsl:attribute name="id">has-allowed-federation-assurance-level</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[Section B Check 3.3] A FedRAMP OSCAL SSP should have an allowed Digital
                        Identity Determination federation-assurance-level property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-allowed-federation-assurance-level-diagnostic">
A FedRAMP OSCAL SSP may lack an allowed Digital Identity Determination
                        federation-assurance-level property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <!--PATTERN system-inventoryFedRAMP OSCAL System Inventory A FedRAMP OSCAL SSP must specify system inventory items FedRAMP SSP property constraints FedRAMP OSCAL SSP inventory components FedRAMP OSCAL SSP inventory items-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">FedRAMP OSCAL System Inventory</svrl:text>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">A FedRAMP OSCAL SSP must specify system inventory items</svrl:text>
   <!--RULE -->
   <xsl:template match="/oscal:system-security-plan/oscal:system-implementation"
                 priority="1012"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="/oscal:system-security-plan/oscal:system-implementation"/>
      <doc:rule xmlns:doc="https://fedramp.gov/oscal/fedramp-automation-documentation"
                xmlns:sch="http://purl.oclc.org/dsdl/schematron">A FedRAMP OSCAL SSP must incorporate inventory-item elements</doc:rule>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:inventory-item"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:inventory-item">
               <xsl:attribute name="id">has-inventory-items</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP must incorporate inventory-item elements.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-inventory-items-diagnostic">
This FedRAMP OSCAL SSP lacks inventory-item elements.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">FedRAMP SSP property constraints</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:prop[@name = 'asset-id']" priority="1010" mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:prop[@name = 'asset-id']"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="count(//oscal:prop[@name = 'asset-id'][@value = current()/@value]) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(//oscal:prop[@name = 'asset-id'][@value = current()/@value]) = 1">
               <xsl:attribute name="id">has-unique-asset-id</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An asset-id must be unique.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-unique-asset-id-diagnostic">
This asset id 
        <xsl:text/>
                  <xsl:value-of select="@asset-id"/>
                  <xsl:text/>is not unique. An asset id must be unique within the scope of a FedRAMP OSCAL SSP
        document.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:prop[@name = 'asset-type']" priority="1009" mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:prop[@name = 'asset-type']"/>
      <xsl:variable name="asset-types"
                    select="$fedramp-values//fedramp:value-set[@name = 'asset-type']//fedramp:enum/@value"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="@value = $asset-types"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@value = $asset-types">
               <xsl:attribute name="id">has-allowed-asset-type</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An asset-type property must have an allowed value.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-allowed-asset-type-diagnostic">
                  <xsl:text/>
                  <xsl:value-of select="name()"/>
                  <xsl:text/>should have a FedRAMP asset type 
        <xsl:text/>
                  <xsl:value-of select="string-join($asset-types, ' ∨ ')"/>
                  <xsl:text/>(not " 
        <xsl:text/>
                  <xsl:value-of select="@value"/>
                  <xsl:text/>").</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:prop[@name = 'virtual']" priority="1008" mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:prop[@name = 'virtual']"/>
      <xsl:variable name="virtuals"
                    select="$fedramp-values//fedramp:value-set[@name = 'virtual']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@value = $virtuals"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@value = $virtuals">
               <xsl:attribute name="id">has-allowed-virtual</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A virtual property must have an allowed value.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-allowed-virtual-diagnostic">
                  <xsl:text/>
                  <xsl:value-of select="name()"/>
                  <xsl:text/>must have an allowed value 
        <xsl:text/>
                  <xsl:value-of select="string-join($virtuals, ' ∨ ')"/>
                  <xsl:text/>(not " 
        <xsl:text/>
                  <xsl:value-of select="@value"/>
                  <xsl:text/>").</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:prop[@name = 'public']" priority="1007" mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:prop[@name = 'public']"/>
      <xsl:variable name="publics"
                    select="$fedramp-values//fedramp:value-set[@name = 'public']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@value = $publics"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@value = $publics">
               <xsl:attribute name="id">has-allowed-public</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A public property must have an allowed value.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-allowed-public-diagnostic">
                  <xsl:text/>
                  <xsl:value-of select="name()"/>
                  <xsl:text/>must have an allowed value 
        <xsl:text/>
                  <xsl:value-of select="string-join($publics, ' ∨ ')"/>
                  <xsl:text/>(not " 
        <xsl:text/>
                  <xsl:value-of select="@value"/>
                  <xsl:text/>").</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:prop[@name = 'allows-authenticated-scan']"
                 priority="1006"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:prop[@name = 'allows-authenticated-scan']"/>
      <xsl:variable name="allows-authenticated-scans"
                    select="$fedramp-values//fedramp:value-set[@name = 'allows-authenticated-scan']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@value = $allows-authenticated-scans"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@value = $allows-authenticated-scans">
               <xsl:attribute name="id">has-allowed-allows-authenticated-scan</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An allows-authenticated-scan property has an allowed value.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-allowed-allows-authenticated-scan-diagnostic">
                  <xsl:text/>
                  <xsl:value-of select="name()"/>
                  <xsl:text/>must have an allowed value 
        <xsl:text/>
                  <xsl:value-of select="string-join($allows-authenticated-scans, ' ∨ ')"/>
                  <xsl:text/>(not " 
        <xsl:text/>
                  <xsl:value-of select="@value"/>
                  <xsl:text/>").</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:prop[@name = 'is-scanned']" priority="1005" mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:prop[@name = 'is-scanned']"/>
      <xsl:variable name="is-scanneds"
                    select="$fedramp-values//fedramp:value-set[@name = 'is-scanned']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@value = $is-scanneds"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@value = $is-scanneds">
               <xsl:attribute name="id">has-allowed-is-scanned</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>is-scanned property must have an allowed value.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-allowed-is-scanned-diagnostic">
                  <xsl:text/>
                  <xsl:value-of select="name()"/>
                  <xsl:text/>must have an allowed value 
        <xsl:text/>
                  <xsl:value-of select="string-join($is-scanneds, ' ∨ ')"/>
                  <xsl:text/>(not " 
        <xsl:text/>
                  <xsl:value-of select="@value"/>
                  <xsl:text/>").</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'scan-type']"
                 priority="1004"
                 mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'scan-type']"/>
      <xsl:variable name="scan-types"
                    select="$fedramp-values//fedramp:value-set[@name = 'scan-type']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@value = $scan-types"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@value = $scan-types">
               <xsl:attribute name="id">has-allowed-scan-type</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A scan-type property must have an allowed value.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-allowed-scan-type-diagnostic">
                  <xsl:text/>
                  <xsl:value-of select="name()"/>
                  <xsl:text/>must have an allowed value 
        <xsl:text/>
                  <xsl:value-of select="string-join($scan-types, ' ∨ ')"/>
                  <xsl:text/>(not " 
        <xsl:text/>
                  <xsl:value-of select="@value"/>
                  <xsl:text/>").</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">FedRAMP OSCAL SSP inventory components</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:component" priority="1002" mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oscal:component"/>
      <xsl:variable name="component-types"
                    select="$fedramp-values//fedramp:value-set[@name = 'component-type']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@type = $component-types"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@type = $component-types">
               <xsl:attribute name="id">component-has-allowed-type</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A component must have an allowed type.</svrl:text>
               <svrl:diagnostic-reference diagnostic="component-has-allowed-type-diagnostic">
                  <xsl:text/>
                  <xsl:value-of select="name()"/>
                  <xsl:text/>must have an allowed component type 
        <xsl:text/>
                  <xsl:value-of select="string-join($component-types, ' ∨ ')"/>
                  <xsl:text/>(not " 
        <xsl:text/>
                  <xsl:value-of select="@type"/>
                  <xsl:text/>").</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="                     (: not(@uuid = //oscal:inventory-item/oscal:implemented-component/@component-uuid) or :)                     oscal:prop[@name = 'asset-type']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(: not(@uuid = //oscal:inventory-item/oscal:implemented-component/@component-uuid) or :) oscal:prop[@name = 'asset-type']">
               <xsl:attribute name="id">component-has-asset-type</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A component must have an asset type.</svrl:text>
               <svrl:diagnostic-reference diagnostic="component-has-asset-type-diagnostic">
                  <xsl:text/>
                  <xsl:value-of select="name()"/>
                  <xsl:text/>lacks an asset-type property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not(oscal:prop[@name = 'asset-type'][2])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(oscal:prop[@name = 'asset-type'][2])">
               <xsl:attribute name="id">component-has-one-asset-type</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A component must have only one asset type.</svrl:text>
               <svrl:diagnostic-reference diagnostic="component-has-one-asset-type-diagnostic">
                  <xsl:text/>
                  <xsl:value-of select="name()"/>
                  <xsl:text/>has more than one asset-type property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">FedRAMP OSCAL SSP inventory items</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:inventory-item" priority="1000" mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oscal:inventory-item">
         <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §6.5</xsl:attribute>
      </svrl:fired-rule>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@uuid"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@uuid">
               <xsl:attribute name="id">inventory-item-has-uuid</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An inventory-item has a uuid.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-uuid-diagnostic">
This inventory-item lacks a uuid attribute.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@name = 'asset-id']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@name = 'asset-id']">
               <xsl:attribute name="id">has-asset-id</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An inventory-item must have an asset-id.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-asset-id-diagnostic">
This inventory-item lacks an asset-id property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not(oscal:prop[@name = 'asset-id'][2])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(oscal:prop[@name = 'asset-id'][2])">
               <xsl:attribute name="id">has-one-asset-id</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An inventory-item must have only one asset-id.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-one-asset-id-diagnostic">
This inventory-item has more than one asset-id property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@name = 'asset-type']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@name = 'asset-type']">
               <xsl:attribute name="id">inventory-item-has-asset-type</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An inventory-item must have an asset-type.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-asset-type-diagnostic">
This inventory-item lacks an asset-type property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not(oscal:prop[@name = 'asset-type'][2])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(oscal:prop[@name = 'asset-type'][2])">
               <xsl:attribute name="id">inventory-item-has-one-asset-type</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An inventory-item must have only one asset-type.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-one-asset-type-diagnostic">
This inventory-item has more than one asset-type property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@name = 'virtual']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@name = 'virtual']">
               <xsl:attribute name="id">inventory-item-has-virtual</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An inventory-item must have a virtual property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-virtual-diagnostic">
This inventory-item lacks a virtual property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not(oscal:prop[@name = 'virtual'][2])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(oscal:prop[@name = 'virtual'][2])">
               <xsl:attribute name="id">inventory-item-has-one-virtual</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An inventory-item must have only one virtual property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-one-virtual-diagnostic">
This inventory-item has more than one virtual property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@name = 'public']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@name = 'public']">
               <xsl:attribute name="id">inventory-item-has-public</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An inventory-item must have a public property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-public-diagnostic">
This inventory-item lacks a public property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not(oscal:prop[@name = 'public'][2])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(oscal:prop[@name = 'public'][2])">
               <xsl:attribute name="id">inventory-item-has-one-public</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An inventory-item must have only one public property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-one-public-diagnostic">
This inventory-item has more than one public property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@name = 'scan-type']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@name = 'scan-type']">
               <xsl:attribute name="id">inventory-item-has-scan-type</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An inventory-item must have a scan-type property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-scan-type-diagnostic">
This inventory-item lacks a scan-type property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not(oscal:prop[@name = 'scan-type'][2])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(oscal:prop[@name = 'scan-type'][2])">
               <xsl:attribute name="id">inventory-item-has-one-scan-type</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An inventory-item has only one scan-type property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-one-scan-type-diagnostic">
This inventory-item has more than one scan-type property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="is-infrastructure"
                    select="exists(oscal:prop[@name = 'asset-type' and @value = ('os', 'infrastructure')])"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not($is-infrastructure) or oscal:prop[@name = 'allows-authenticated-scan']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($is-infrastructure) or oscal:prop[@name = 'allows-authenticated-scan']">
               <xsl:attribute name="id">inventory-item-has-allows-authenticated-scan</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>"infrastructure" inventory-item has
                        allows-authenticated-scan.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-allows-authenticated-scan-diagnostic">
This inventory-item lacks allows-authenticated-scan
                        property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not($is-infrastructure) or not(oscal:prop[@name = 'allows-authenticated-scan'][2])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($is-infrastructure) or not(oscal:prop[@name = 'allows-authenticated-scan'][2])">
               <xsl:attribute name="id">inventory-item-has-one-allows-authenticated-scan</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An inventory-item has
                        one-allows-authenticated-scan property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-one-allows-authenticated-scan-diagnostic">
This inventory-item has more than one
                        allows-authenticated-scan property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not($is-infrastructure) or oscal:prop[@name = 'baseline-configuration-name']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($is-infrastructure) or oscal:prop[@name = 'baseline-configuration-name']">
               <xsl:attribute name="id">inventory-item-has-baseline-configuration-name</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>"infrastructure" inventory-item has
                        baseline-configuration-name.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-baseline-configuration-name-diagnostic">
This inventory-item lacks baseline-configuration-name
                        property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not($is-infrastructure) or not(oscal:prop[@name = 'baseline-configuration-name'][2])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($is-infrastructure) or not(oscal:prop[@name = 'baseline-configuration-name'][2])">
               <xsl:attribute name="id">inventory-item-has-one-baseline-configuration-name</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>"infrastructure" inventory-item
                        has only one baseline-configuration-name.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-one-baseline-configuration-name-diagnostic">
This inventory-item has more than one
                        baseline-configuration-name property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not($is-infrastructure) or oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'vendor-name']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($is-infrastructure) or oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'vendor-name']">
               <xsl:attribute name="id">inventory-item-has-vendor-name</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                        "infrastructure" inventory-item has a vendor-name property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-vendor-name-diagnostic">
This inventory-item lacks a vendor-name property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not($is-infrastructure) or not(oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'vendor-name'][2])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($is-infrastructure) or not(oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'vendor-name'][2])">
               <xsl:attribute name="id">inventory-item-has-one-vendor-name</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                        "infrastructure" inventory-item must have only one vendor-name property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-one-vendor-name-diagnostic">
This inventory-item has more than one vendor-name
                        property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not($is-infrastructure) or oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'hardware-model']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($is-infrastructure) or oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'hardware-model']">
               <xsl:attribute name="id">inventory-item-has-hardware-model</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                        "infrastructure" inventory-item must have a hardware-model property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-hardware-model-diagnostic">
This inventory-item lacks a hardware-model property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not($is-infrastructure) or not(oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'hardware-model'][2])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($is-infrastructure) or not(oscal:prop[(: @ns = 'https://fedramp.gov/ns/oscal' and :)@name = 'hardware-model'][2])">
               <xsl:attribute name="id">inventory-item-has-one-hardware-model</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                        "infrastructure" inventory-item must have only one hardware-model property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-one-hardware-model-diagnostic">
This inventory-item has more than one hardware-model
                        property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not($is-infrastructure) or oscal:prop[@name = 'is-scanned']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($is-infrastructure) or oscal:prop[@name = 'is-scanned']">
               <xsl:attribute name="id">inventory-item-has-is-scanned</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>"infrastructure" inventory-item must have is-scanned
                        property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-is-scanned-diagnostic">
This inventory-item lacks is-scanned property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not($is-infrastructure) or not(oscal:prop[@name = 'is-scanned'][2])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($is-infrastructure) or not(oscal:prop[@name = 'is-scanned'][2])">
               <xsl:attribute name="id">inventory-item-has-one-is-scanned</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>"infrastructure" inventory-item must have only one
                        is-scanned property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-one-is-scanned-diagnostic">
This inventory-item has more than one is-scanned property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="is-software-and-database"
                    select="exists(oscal:prop[@name = 'asset-type' and @value = ('software', 'database')])"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not($is-software-and-database) or oscal:prop[@name = 'software-name']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($is-software-and-database) or oscal:prop[@name = 'software-name']">
               <xsl:attribute name="id">inventory-item-has-software-name</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>"software or database" inventory-item must have
                        a software-name property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-software-name-diagnostic">
This inventory-item lacks software-name property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not($is-software-and-database) or not(oscal:prop[@name = 'software-name'][2])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($is-software-and-database) or not(oscal:prop[@name = 'software-name'][2])">
               <xsl:attribute name="id">inventory-item-has-one-software-name</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>"software or database" inventory-item
                        must have a software-name property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-one-software-name-diagnostic">
This inventory-item has more than one software-name
                        property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not($is-software-and-database) or oscal:prop[@name = 'software-version']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($is-software-and-database) or oscal:prop[@name = 'software-version']">
               <xsl:attribute name="id">inventory-item-has-software-version</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>"software or database" inventory-item must
                        have a software-version property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-software-version-diagnostic">
This inventory-item lacks software-version property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not($is-software-and-database) or not(oscal:prop[@name = 'software-version'][2])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($is-software-and-database) or not(oscal:prop[@name = 'software-version'][2])">
               <xsl:attribute name="id">inventory-item-has-one-software-version</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>"software or database" inventory-item
                        must have one software-version property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-one-software-version-diagnostic">
This inventory-item has more than one software-version
                        property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not($is-software-and-database) or oscal:prop[@name = 'function']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($is-software-and-database) or oscal:prop[@name = 'function']">
               <xsl:attribute name="id">inventory-item-has-function</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>"software or database" inventory-item must have a
                        function property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-function-diagnostic">
                  <xsl:text/>
                  <xsl:value-of select="name()"/>
                  <xsl:text/>" 
        <xsl:text/>
                  <xsl:value-of select="oscal:prop[@name = 'asset-type']/@value"/>
                  <xsl:text/>" lacks function property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="not($is-software-and-database) or not(oscal:prop[@name = 'function'][2])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($is-software-and-database) or not(oscal:prop[@name = 'function'][2])">
               <xsl:attribute name="id">inventory-item-has-one-function</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>"software or database" inventory-item must
                        have one function property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="inventory-item-has-one-function-diagnostic">
                  <xsl:text/>
                  <xsl:value-of select="name()"/>
                  <xsl:text/>" 
        <xsl:text/>
                  <xsl:value-of select="oscal:prop[@name = 'asset-type']/@value"/>
                  <xsl:text/>" has more than one function property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--PATTERN basic-system-characteristics-->
   <!--RULE -->
   <xsl:template match="oscal:system-implementation" priority="1001" mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:system-implementation">
         <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.4.6</xsl:attribute>
      </svrl:fired-rule>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="exists(oscal:component[@type = 'this-system'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(oscal:component[@type = 'this-system'])">
               <xsl:attribute name="id">has-this-system-component</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP must have a "this-system" component.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-this-system-component-diagnostic">
This FedRAMP OSCAL SSP lacks a "this-system" component.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:system-characteristics" priority="1000" mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:system-characteristics"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:system-id[@identifier-type = 'https://fedramp.gov']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:system-id[@identifier-type = 'https://fedramp.gov']">
               <xsl:attribute name="id">has-system-id</xsl:attribute>
               <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.1</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP must have a FedRAMP
                        system-id.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-system-id-diagnostic">
This FedRAMP OSCAL SSP lacks a FedRAMP system-id.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:system-name"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:system-name">
               <xsl:attribute name="id">has-system-name</xsl:attribute>
               <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.1</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP must have a system-name.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-system-name-diagnostic">
This FedRAMP OSCAL SSP lacks a system-name.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:system-name-short"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:system-name-short">
               <xsl:attribute name="id">has-system-name-short</xsl:attribute>
               <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.1</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP must have a system-name-short.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-system-name-short-diagnostic">
This FedRAMP OSCAL SSP lacks a system-name-short.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'authorization-type' and @value = ('fedramp-jab', 'fedramp-agency', 'fedramp-li-saas')]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal' and @name = 'authorization-type' and @value = ('fedramp-jab', 'fedramp-agency', 'fedramp-li-saas')]">
               <xsl:attribute name="id">has-fedramp-authorization-type</xsl:attribute>
               <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.2</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            A FedRAMP OSCAL SSP must have a FedRAMP authorization type.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-fedramp-authorization-type-diagnostic">
This FedRAMP OSCAL SSP lacks a FedRAMP authorization type.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <!--PATTERN general-rolesRoles, Locations, Parties, Responsibilities-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Roles, Locations, Parties, Responsibilities</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:metadata" priority="1003" mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oscal:metadata">
         <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §4.6-§4.10</xsl:attribute>
      </svrl:fired-rule>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:role[@id = 'system-owner']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:role[@id = 'system-owner']">
               <xsl:attribute name="id">role-defined-system-owner</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The system-owner role must be defined.</svrl:text>
               <svrl:diagnostic-reference diagnostic="role-defined-system-owner-diagnostic">
The system-owner role is missing.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:role[@id = 'authorizing-official']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:role[@id = 'authorizing-official']">
               <xsl:attribute name="id">role-defined-authorizing-official</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The authorizing-official role must be defined.</svrl:text>
               <svrl:diagnostic-reference diagnostic="role-defined-authorizing-official-diagnostic">
The authorizing-official role is missing.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:role[@id = 'system-poc-management']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:role[@id = 'system-poc-management']">
               <xsl:attribute name="id">role-defined-system-poc-management</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The system-poc-management role must be defined.</svrl:text>
               <svrl:diagnostic-reference diagnostic="role-defined-system-poc-management-diagnostic">
The system-poc-management role is missing.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:role[@id = 'system-poc-technical']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:role[@id = 'system-poc-technical']">
               <xsl:attribute name="id">role-defined-system-poc-technical</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The system-poc-technical role must be defined.</svrl:text>
               <svrl:diagnostic-reference diagnostic="role-defined-system-poc-technical-diagnostic">
The system-poc-technical role is missing.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:role[@id = 'system-poc-other']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:role[@id = 'system-poc-other']">
               <xsl:attribute name="id">role-defined-system-poc-other</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The system-poc-other role must be defined.</svrl:text>
               <svrl:diagnostic-reference diagnostic="role-defined-system-poc-other-diagnostic">
The system-poc-other role is missing.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:role[@id = 'information-system-security-officer']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:role[@id = 'information-system-security-officer']">
               <xsl:attribute name="id">role-defined-information-system-security-officer</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The information-system-security-officer role must be
                        defined.</svrl:text>
               <svrl:diagnostic-reference diagnostic="role-defined-information-system-security-officer-diagnostic">
The information-system-security-officer role is
                        missing.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:role[@id = 'authorizing-official-poc']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:role[@id = 'authorizing-official-poc']">
               <xsl:attribute name="id">role-defined-authorizing-official-poc</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The authorizing-official-poc role must be defined.</svrl:text>
               <svrl:diagnostic-reference diagnostic="role-defined-authorizing-official-poc-diagnostic">
The authorizing-official-poc role is missing.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:role" priority="1002" mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oscal:role"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:title"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:title">
               <xsl:attribute name="id">role-has-title</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A role must have a title.</svrl:text>
               <svrl:diagnostic-reference diagnostic="role-has-title-diagnostic">
This role lacks a title.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="//oscal:responsible-party[@role-id = current()/@id]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="//oscal:responsible-party[@role-id = current()/@id]">
               <xsl:attribute name="id">role-has-responsible-party</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>One or more responsible parties must be defined for each
                        role.</svrl:text>
               <svrl:diagnostic-reference diagnostic="role-has-responsible-party-diagnostic">
This role has no responsible parties.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:responsible-party" priority="1001" mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:responsible-party"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="//oscal:party[@uuid = current()/oscal:party-uuid and @type = 'person']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="//oscal:party[@uuid = current()/oscal:party-uuid and @type = 'person']">
               <xsl:attribute name="id">responsible-party-has-person</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each responsible-party party-uuid must identify
                        a person.</svrl:text>
               <svrl:diagnostic-reference diagnostic="responsible-party-has-person-diagnostic">
This responsible-party party-uuid does not identify a person.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:party[@type = 'person']" priority="1000" mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:party[@type = 'person']"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="//oscal:responsible-party[oscal:party-uuid = current()/@uuid]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="//oscal:responsible-party[oscal:party-uuid = current()/@uuid]">
               <xsl:attribute name="id">party-has-responsibility</xsl:attribute>
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each person should have a responsibility.</svrl:text>
               <svrl:diagnostic-reference diagnostic="party-has-responsibility-diagnostic">
This person has no responsibility.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <!--PATTERN implementation-rolesRoles related to implemented requirements-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Roles related to implemented requirements</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:implemented-requirement" priority="1001" mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:implemented-requirement"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:responsible-role"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:responsible-role">
               <xsl:attribute name="id">implemented-requirement-has-responsible-role</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each implemented-requirement must have one or more responsible-role definitions.</svrl:text>
               <svrl:diagnostic-reference diagnostic="implemented-requirement-has-responsible-role-diagnostic">
This implemented-requirement lacks a responsible-role
                        definition.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:responsible-role" priority="1000" mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:responsible-role"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="//oscal:role/@id = current()/@role-id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="//oscal:role/@id = current()/@role-id">
               <xsl:attribute name="id">responsible-role-has-role-definition</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each responsible-role must reference a role definition.</svrl:text>
               <svrl:diagnostic-reference diagnostic="responsible-role-has-role-definition-diagnostic">
This responsible-role references a non-existent role
                        definition.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="//oscal:role-id = current()/@role-id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="//oscal:role-id = current()/@role-id">
               <xsl:attribute name="id">responsible-role-has-user</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each responsible-role must be referenced in a system-implementation user
                        assembly.</svrl:text>
               <svrl:diagnostic-reference diagnostic="responsible-role-has-user-diagnostic">
This responsible-role lacks a system-implementation user assembly.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <!--PATTERN user-properties-->
   <!--RULE -->
   <xsl:template match="oscal:user" priority="1007" mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oscal:user"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:role-id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:role-id">
               <xsl:attribute name="id">user-has-role-id</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Every user has a role-id.</svrl:text>
               <svrl:diagnostic-reference diagnostic="user-has-role-id-diagnostic">
This user lacks a role-id.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@name = 'type']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@name = 'type']">
               <xsl:attribute name="id">user-has-user-type</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Every user has a user type property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="user-has-user-type-diagnostic">
This user lacks a user type property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@name = 'privilege-level']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@name = 'privilege-level']">
               <xsl:attribute name="id">user-has-privilege-level</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Every user has a privilege-level property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="user-has-privilege-level-diagnostic">
This user lacks a privilege-level property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal'][@name = 'sensitivity']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@ns = 'https://fedramp.gov/ns/oscal'][@name = 'sensitivity']">
               <xsl:attribute name="id">user-has-sensitivity-level</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Every user has a sensitivity level
                        property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="user-has-sensitivity-level-diagnostic">
This user lacks a sensitivity level property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:authorized-privilege"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:authorized-privilege">
               <xsl:attribute name="id">user-has-authorized-privilege</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Every user has one or more authorized-privileges.</svrl:text>
               <svrl:diagnostic-reference diagnostic="user-has-authorized-privilege-diagnostic">
This user lacks one or more authorized-privileges.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:user/oscal:role-id" priority="1006" mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:user/oscal:role-id"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="//oscal:role[@id = current()]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="//oscal:role[@id = current()]">
               <xsl:attribute name="id">role-id-has-role-definition</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each role-id must reference a role definition.</svrl:text>
               <svrl:diagnostic-reference diagnostic="role-id-has-role-definition-diagnostic">
This role-id references a non-existent role definition.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:user/oscal:prop[@name = 'type']"
                 priority="1005"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:user/oscal:prop[@name = 'type']"/>
      <xsl:variable name="user-types"
                    select="$fedramp-values//fedramp:value-set[@name = 'user-type']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="current()/@value = $user-types"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="current()/@value = $user-types">
               <xsl:attribute name="id">user-user-type-has-allowed-value</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>User type property has an allowed value.</svrl:text>
               <svrl:diagnostic-reference diagnostic="user-user-type-has-allowed-value-diagnostic">
User type property has an allowed value.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:user/oscal:prop[@name = 'privilege-level']"
                 priority="1004"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:user/oscal:prop[@name = 'privilege-level']"/>
      <xsl:variable name="user-privilege-levels"
                    select="$fedramp-values//fedramp:value-set[@name = 'user-privilege']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="current()/@value = $user-privilege-levels"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="current()/@value = $user-privilege-levels">
               <xsl:attribute name="id">user-privilege-level-has-allowed-value</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>User privilege-level property has an allowed value.</svrl:text>
               <svrl:diagnostic-reference diagnostic="user-privilege-level-has-allowed-value-diagnostic">
User privilege-level property has an allowed value.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:user/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal'][@name = 'sensitivity']"
                 priority="1003"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:user/oscal:prop[@ns = 'https://fedramp.gov/ns/oscal'][@name = 'sensitivity']"/>
      <xsl:variable name="user-sensitivity-levels"
                    select="$fedramp-values//fedramp:value-set[@name = 'user-sensitivity-level']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="current()/@value = $user-sensitivity-levels"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="current()/@value = $user-sensitivity-levels">
               <xsl:attribute name="id">user-sensitivity-level-has-allowed-value</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>User sensitivity level property has an allowed value.</svrl:text>
               <svrl:diagnostic-reference diagnostic="user-sensitivity-level-has-allowed-value-diagnostic">
This user sensitivity level property lacks an allowed
                        value.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:user/oscal:authorized-privilege"
                 priority="1002"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:user/oscal:authorized-privilege"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:title"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:title">
               <xsl:attribute name="id">authorized-privilege-has-title</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Every authorized-privilege has a title.</svrl:text>
               <svrl:diagnostic-reference diagnostic="authorized-privilege-has-title-diagnostic">
Every authorized-privilege has a title.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:function-performed"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:function-performed">
               <xsl:attribute name="id">authorized-privilege-has-function-performed</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Every authorized-privilege has one or more function-performed.</svrl:text>
               <svrl:diagnostic-reference diagnostic="authorized-privilege-has-function-performed-diagnostic">
Every authorized-privilege has one or more
                        function-performed.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:authorized-privilege/oscal:title"
                 priority="1001"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:authorized-privilege/oscal:title"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="current() ne ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="current() ne ''">
               <xsl:attribute name="id">authorized-privilege-has-non-empty-title</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Every authorized-privilege title is non-empty.</svrl:text>
               <svrl:diagnostic-reference diagnostic="authorized-privilege-has-non-empty-title-diagnostic">
Every authorized-privilege title is non-empty.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:authorized-privilege/oscal:function-performed"
                 priority="1000"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:authorized-privilege/oscal:function-performed"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="current() ne ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="current() ne ''">
               <xsl:attribute name="id">authorized-privilege-has-non-empty-function-performed</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Every authorized-privilege has a non-empty function-performed.</svrl:text>
               <svrl:diagnostic-reference diagnostic="authorized-privilege-has-non-empty-function-performed-diagnostic">
Every authorized-privilege has a non-empty
                        function-performed.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--PATTERN authorization-boundaryAuthorization Boundary Diagram-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Authorization Boundary Diagram</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:system-characteristics" priority="1003" mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:system-characteristics"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:authorization-boundary"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:authorization-boundary">
               <xsl:attribute name="id">has-authorization-boundary</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP includes an authorization-boundary in its
                        system-characteristics.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-authorization-boundary-diagnostic">
This FedRAMP OSCAL SSP lacks an authorization-boundary in its
                        system-characteristics.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:authorization-boundary" priority="1002" mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:authorization-boundary"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:description"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:description">
               <xsl:attribute name="id">has-authorization-boundary-description</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP has an authorization-boundary description.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-authorization-boundary-description-diagnostic">
This FedRAMP OSCAL SSP lacks an authorization-boundary
                        description.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:diagram"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:diagram">
               <xsl:attribute name="id">has-authorization-boundary-diagram</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP has at least one authorization-boundary diagram.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-authorization-boundary-diagram-diagnostic">
This FedRAMP OSCAL SSP lacks at least one authorization-boundary
                        diagram.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:authorization-boundary/oscal:diagram"
                 priority="1001"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:authorization-boundary/oscal:diagram"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@uuid"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@uuid">
               <xsl:attribute name="id">has-authorization-boundary-diagram-uuid</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP authorization-boundary diagram has a uuid attribute.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-authorization-boundary-diagram-uuid-diagnostic">
This FedRAMP OSCAL SSP authorization-boundary diagram lacks a uuid
                        attribute.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:description"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:description">
               <xsl:attribute name="id">has-authorization-boundary-diagram-description</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP authorization-boundary diagram has a description.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-authorization-boundary-diagram-description-diagnostic">
This FedRAMP OSCAL SSP authorization-boundary diagram lacks a
                        description.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:link"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:link">
               <xsl:attribute name="id">has-authorization-boundary-diagram-link</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP authorization-boundary diagram has a link.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-authorization-boundary-diagram-link-diagnostic">
This FedRAMP OSCAL SSP authorization-boundary diagram lacks a
                        link.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:caption"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:caption">
               <xsl:attribute name="id">has-authorization-boundary-diagram-caption</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP authorization-boundary diagram has a caption.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-authorization-boundary-diagram-caption-diagnostic">
This FedRAMP OSCAL SSP authorization-boundary diagram lacks a
                        caption.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:authorization-boundary/oscal:diagram/oscal:link"
                 priority="1000"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:authorization-boundary/oscal:diagram/oscal:link"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@rel"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@rel">
               <xsl:attribute name="id">has-authorization-boundary-diagram-link-rel</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP authorization-boundary diagram has a link rel attribute.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-authorization-boundary-diagram-link-rel-diagnostic">
This FedRAMP OSCAL SSP authorization-boundary diagram lacks a
                        link rel attribute.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@rel = 'diagram'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@rel = 'diagram'">
               <xsl:attribute name="id">has-authorization-boundary-diagram-link-rel-allowed-value</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP authorization-boundary diagram has a link rel attribute with the value
                        "diagram".</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-authorization-boundary-diagram-link-rel-allowed-value-diagnostic">
This FedRAMP OSCAL SSP authorization-boundary
                        diagram lacks a link rel attribute with the value "diagram".</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="exists(//oscal:resource[@uuid = substring-after(current()/@href, '#')])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(//oscal:resource[@uuid = substring-after(current()/@href, '#')])">
               <xsl:attribute name="id">has-authorization-boundary-diagram-link-href-target</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP authorization-boundary
                        diagram link references a back-matter resource representing the diagram document.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-authorization-boundary-diagram-link-href-target-diagnostic">
This FedRAMP OSCAL SSP authorization-boundary diagram
                        link does not reference a back-matter resource representing the diagram document.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <!--PATTERN network-architectureNetwork Architecture Diagram-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Network Architecture Diagram</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:system-characteristics" priority="1003" mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:system-characteristics"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:network-architecture"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:network-architecture">
               <xsl:attribute name="id">has-network-architecture</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP includes a network-architecture in its
                        system-characteristics.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-network-architecture-diagnostic">
This FedRAMP OSCAL SSP lacks an network-architecture in its
                        system-characteristics.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:network-architecture" priority="1002" mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:network-architecture"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:description"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:description">
               <xsl:attribute name="id">has-network-architecture-description</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP has a network-architecture description.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-network-architecture-description-diagnostic">
This FedRAMP OSCAL SSP lacks an network-architecture
                        description.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:diagram"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:diagram">
               <xsl:attribute name="id">has-network-architecture-diagram</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP has at least one network-architecture diagram.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-network-architecture-diagram-diagnostic">
This FedRAMP OSCAL SSP lacks at least one network-architecture
                        diagram.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:network-architecture/oscal:diagram"
                 priority="1001"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:network-architecture/oscal:diagram"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@uuid"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@uuid">
               <xsl:attribute name="id">has-network-architecture-diagram-uuid</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP network-architecture diagram has a uuid attribute.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-network-architecture-diagram-uuid-diagnostic">
This FedRAMP OSCAL SSP network-architecture diagram lacks a uuid
                        attribute.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:description"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:description">
               <xsl:attribute name="id">has-network-architecture-diagram-description</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP network-architecture diagram has a description.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-network-architecture-diagram-description-diagnostic">
This FedRAMP OSCAL SSP network-architecture diagram lacks a
                        description.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:link"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:link">
               <xsl:attribute name="id">has-network-architecture-diagram-link</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP network-architecture diagram has a link.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-network-architecture-diagram-link-diagnostic">
This FedRAMP OSCAL SSP network-architecture diagram lacks a
                        link.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:caption"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:caption">
               <xsl:attribute name="id">has-network-architecture-diagram-caption</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP network-architecture diagram has a caption.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-network-architecture-diagram-caption-diagnostic">
This FedRAMP OSCAL SSP network-architecture diagram lacks a
                        caption.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:network-architecture/oscal:diagram/oscal:link"
                 priority="1000"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:network-architecture/oscal:diagram/oscal:link"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@rel"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@rel">
               <xsl:attribute name="id">has-network-architecture-diagram-link-rel</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP network-architecture diagram has a link rel attribute.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-network-architecture-diagram-link-rel-diagnostic">
This FedRAMP OSCAL SSP network-architecture diagram lacks a link
                        rel attribute.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@rel = 'diagram'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@rel = 'diagram'">
               <xsl:attribute name="id">has-network-architecture-diagram-link-rel-allowed-value</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP network-architecture diagram has a link rel attribute with the value
                        "diagram".</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-network-architecture-diagram-link-rel-allowed-value-diagnostic">
This FedRAMP OSCAL SSP network-architecture diagram
                        lacks a link rel attribute with the value "diagram".</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="exists(//oscal:resource[@uuid = substring-after(current()/@href, '#')])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(//oscal:resource[@uuid = substring-after(current()/@href, '#')])">
               <xsl:attribute name="id">has-network-architecture-diagram-link-href-target</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP network-architecture
                        diagram link references a back-matter resource representing the diagram document.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-network-architecture-diagram-link-href-target-diagnostic">
This FedRAMP OSCAL SSP network-architecture diagram link
                        does not reference a back-matter resource representing the diagram document.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <!--PATTERN data-flowData Flow Diagram-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Data Flow Diagram</svrl:text>
   <!--RULE -->
   <xsl:template match="oscal:system-characteristics" priority="1003" mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:system-characteristics"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:data-flow"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:data-flow">
               <xsl:attribute name="id">has-data-flow</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP includes a data-flow in its system-characteristics.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-data-flow-diagnostic">
This FedRAMP OSCAL SSP lacks an data-flow in its system-characteristics.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:data-flow" priority="1002" mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oscal:data-flow"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:description"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:description">
               <xsl:attribute name="id">has-data-flow-description</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP has a data-flow description.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-data-flow-description-diagnostic">
This FedRAMP OSCAL SSP lacks an data-flow description.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:diagram"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:diagram">
               <xsl:attribute name="id">has-data-flow-diagram</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP has at least one data-flow diagram.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-data-flow-diagram-diagnostic">
This FedRAMP OSCAL SSP lacks at least one data-flow diagram.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:data-flow/oscal:diagram" priority="1001" mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:data-flow/oscal:diagram"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@uuid"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@uuid">
               <xsl:attribute name="id">has-data-flow-diagram-uuid</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP data-flow diagram has a uuid attribute.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-data-flow-diagram-uuid-diagnostic">
This FedRAMP OSCAL SSP data-flow diagram lacks a uuid attribute.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:description"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:description">
               <xsl:attribute name="id">has-data-flow-diagram-description</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP data-flow diagram has a description.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-data-flow-diagram-description-diagnostic">
This FedRAMP OSCAL SSP data-flow diagram lacks a
                        description.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:link"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:link">
               <xsl:attribute name="id">has-data-flow-diagram-link</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP data-flow diagram has a link.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-data-flow-diagram-link-diagnostic">
This FedRAMP OSCAL SSP data-flow diagram lacks a link.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:caption"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:caption">
               <xsl:attribute name="id">has-data-flow-diagram-caption</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP data-flow diagram has a caption.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-data-flow-diagram-caption-diagnostic">
This FedRAMP OSCAL SSP data-flow diagram lacks a caption.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:data-flow/oscal:diagram/oscal:link"
                 priority="1000"
                 mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:data-flow/oscal:diagram/oscal:link"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@rel"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@rel">
               <xsl:attribute name="id">has-data-flow-diagram-link-rel</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP data-flow diagram has a link rel attribute.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-data-flow-diagram-link-rel-diagnostic">
This FedRAMP OSCAL SSP data-flow diagram lacks a link rel
                        attribute.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@rel = 'diagram'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@rel = 'diagram'">
               <xsl:attribute name="id">has-data-flow-diagram-link-rel-allowed-value</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each FedRAMP OSCAL SSP data-flow diagram has a link rel attribute with the value
                        "diagram".</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-data-flow-diagram-link-rel-allowed-value-diagnostic">
This FedRAMP OSCAL SSP data-flow diagram lacks a link rel
                        attribute with the value "diagram".</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="exists(//oscal:resource[@uuid = substring-after(current()/@href, '#')])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(//oscal:resource[@uuid = substring-after(current()/@href, '#')])">
               <xsl:attribute name="id">has-data-flow-diagram-link-href-target</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP data-flow diagram link
                        references a back-matter resource representing the diagram document.</svrl:text>
               <svrl:diagnostic-reference diagnostic="has-data-flow-diagram-link-href-target-diagnostic">
This FedRAMP OSCAL SSP data-flow diagram link does not reference a
                        back-matter resource representing the diagram document.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <!--PATTERN control-implementation-->
   <!--RULE -->
   <xsl:template match="oscal:system-security-plan" priority="1004" mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:system-security-plan">
         <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.1</xsl:attribute>
      </svrl:fired-rule>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="exists(oscal:import-profile)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(oscal:import-profile)">
               <xsl:attribute name="id">system-security-plan-has-import-profile</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A FedRAMP OSCAL SSP declares the related FedRAMP OSCAL Profile using an import-profile
                        element.</svrl:text>
               <svrl:diagnostic-reference diagnostic="system-security-plan-has-import-profile-diagnostic">
This FedRAMP OSCAL SSP lacks an import-profile
                        element.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:import-profile" priority="1003" mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oscal:import-profile">
         <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.1</xsl:attribute>
      </svrl:fired-rule>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@href"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@href">
               <xsl:attribute name="id">import-profile-has-href-attribute</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The import-profile element has an href attribute.</svrl:text>
               <svrl:diagnostic-reference diagnostic="import-profile-has-href-attribute-diagnostic">
The import-profile element lacks an href attribute.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:implemented-requirement" priority="1002" mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:implemented-requirement"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="exists(oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'implementation-status'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="exists(oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'implementation-status'])">
               <xsl:attribute name="id">implemented-requirement-has-implementation-status</xsl:attribute>
               <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Every
                        implemented-requirement has an implementation-status property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="implemented-requirement-has-implementation-status-diagnostic">
This implemented-requirement lacks an
                        implementation-status.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="                     if (oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'implementation-status' and @value eq 'planned']) then                         exists(current()/oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'planned-completion-date' and @value castable as xs:date])                     else                         true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if (oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'implementation-status' and @value eq 'planned']) then exists(current()/oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'planned-completion-date' and @value castable as xs:date]) else true()">
               <xsl:attribute name="id">implemented-requirement-has-planned-completion-date</xsl:attribute>
               <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Planned control implementations have a planned completion date.</svrl:text>
               <svrl:diagnostic-reference diagnostic="implemented-requirement-has-planned-completion-date-diagnostic">
This planned control implementations lacks a planned
                        completion date.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'control-origination']"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'control-origination']">
               <xsl:attribute name="id">implemented-requirement-has-control-origination</xsl:attribute>
               <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3.1.1</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Every implemented-requirement has
                        a control-origination property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="implemented-requirement-has-control-origination-diagnostic">
This implemented-requirement lacks a control-origination
                        property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="control-originations"
                    select="$fedramp-values//fedramp:value-set[@name eq 'control-origination']//fedramp:enum/@value"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'control-origination' and @value = $control-originations]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'control-origination' and @value = $control-originations]">
               <xsl:attribute name="id">implemented-requirement-has-allowed-control-origination</xsl:attribute>
               <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3.1.1</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                        Every implemented-requirement has an allowed control-origination property.</svrl:text>
               <svrl:diagnostic-reference diagnostic="implemented-requirement-has-allowed-control-origination-diagnostic">
This implemented-requirement lacks an allowed
                        control-origination property.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="                     if (oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'control-origination' and @value eq 'inherited']) then                         (: there must be a leveraged-authorization-uuid property :)                         exists(oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'leveraged-authorization-uuid'])                         and                         (: the referenced leveraged-authorization must exist :)                         exists(//oscal:leveraged-authorization[@uuid = current()/oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'leveraged-authorization-uuid']/@value])                     else                         true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if (oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'control-origination' and @value eq 'inherited']) then (: there must be a leveraged-authorization-uuid property :) exists(oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'leveraged-authorization-uuid']) and (: the referenced leveraged-authorization must exist :) exists(//oscal:leveraged-authorization[@uuid = current()/oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'leveraged-authorization-uuid']/@value]) else true()">
               <xsl:attribute name="id">implemented-requirement-has-leveraged-authorization</xsl:attribute>
               <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3.1.1</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Every implemented-requirement with a control-origination property of "inherited" references a
leveraged-authorization.</svrl:text>
               <svrl:diagnostic-reference diagnostic="implemented-requirement-has-leveraged-authorization-diagnostic">
This implemented-requirement with a control-origination
                        property of "inherited" does not reference a leveraged-authorization element in the same document.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'implementation-status' and @value ne 'implemented']"
                 priority="1001"
                 mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'implementation-status' and @value ne 'implemented']"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="oscal:remarks"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oscal:remarks">
               <xsl:attribute name="id">implemented-requirement-has-implementation-status-remarks</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Incomplete control implementations have an explanation.</svrl:text>
               <svrl:diagnostic-reference diagnostic="implemented-requirement-has-implementation-status-remarks-diagnostic">
This incomplete control implementation lacks an
                        explanation.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'planned-completion-date']"
                 priority="1000"
                 mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="oscal:prop[@ns eq 'https://fedramp.gov/ns/oscal' and @name eq 'planned-completion-date']"/>
      <!--ASSERT error-->
      <xsl:choose>
         <xsl:when test="@value castable as xs:date"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@value castable as xs:date">
               <xsl:attribute name="id">planned-completion-date-is-valid</xsl:attribute>
               <xsl:attribute name="see">DRAFT Guide to OSCAL-based FedRAMP System Security Plans §5.3</xsl:attribute>
               <xsl:attribute name="role">error</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Planned completion date is valid.</svrl:text>
               <svrl:diagnostic-reference diagnostic="planned-completion-date-is-valid-diagnostic">
This planned completion date is not valid.</svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
</xsl:stylesheet>
