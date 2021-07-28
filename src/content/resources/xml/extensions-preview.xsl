<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:o="http://csrc.nist.gov/ns/oscal/1.0"
   xmlns="http://www.w3.org/1999/xhtml"
   xpath-default-namespace="http://csrc.nist.gov/ns/oscal/1.0">

   <!--
      For each of profile, ssp, sap, sar, poa&m:
    
    make a table (grid) spilling spreadsheet summary of constraints
    
    -->
   
   <xsl:param name="constraint-set" as="xs:string">profile | ssp | sap | sar | poam</xsl:param>
   
   <xsl:variable name="filter-sets" as="element()*">
      <set key="catalog" label="Catalog"  >catalog</set>
      <set key="profile" label="Baseline" >profile</set>
      <set key="ssp"     label="SSP"      >system-security-plan</set>
      <set key="sap"     label="SAP"      >assessment-plan</set>
      <set key="sar"     label="SAR"      >assessment-results</set>
      <set key="poam"    label="POA&amp;M">plan-of-action-and-milestones</set>
   </xsl:variable>
   
<!-- A sequence of element names keyed to arguments above -->
   <xsl:variable name="runtime-sets" as="element()*"
      select="$filter-sets[ (@key,'all') = tokenize($constraint-set,'\s') ]"/>
   
   <xsl:template match="/">
      <html>
         <head>
            <title>OSCAL Extensions Model [display]</title>
            <xsl:call-template name="css"/>
         </head>
         <body>
            <h1>FedRAMP OSCAL Registry</h1>
            
            <xsl:apply-templates>
               <xsl:with-param name="including" tunnel="true" select="$runtime-sets"/>
            </xsl:apply-templates>
         </body>
      </html>
   </xsl:template>

   <xsl:template match="metadata"/>
      
   <xsl:template match="extensions">
      <xsl:param name="including" tunnel="true" required="true" as="element()*"/>
      
      <xsl:choose>
         <xsl:when test="empty($including)" expand-text="true">
            <xsl:message>Including nothing</xsl:message>
            <h1>Nothing to include for constraint-set "{ $constraint-set }"</h1>
         </xsl:when>
         <xsl:otherwise>
            <xsl:message expand-text="true">Using key(s) { $including => string-join(', ') }</xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:where-populated>
         <table class="spread">
            <tr>
               <th colspan="{ count($including) }" class="blue">Cardinality</th>
               <th class="blue" colspan="3">FedRAMP Information</th>
               <td>All FedRAMP extensions must include a <code>ns</code> flag with the value <code>https://fedramp.gov/ns/oscal</code></td>
               <th class="blue" rowspan="2">OSCAL Data Type</th>
               <th class="blue" rowspan="2">See Defined Identifiers Tab</th>
               <th class="blue" rowspan="2">See Accepted Values Tab</th>
            </tr>
            <tr>
               <xsl:for-each select="$including" expand-text="true">
                 <th class="black">{ @label }</th>
               </xsl:for-each>
               <th class="black">Data</th>
               <th class="black">Field/Assembly</th>
               <th class="black">name="___"</th>
               <th class="black">XPath notation <em class="red">(explicit prefixes, case sensitive)</em></th>
               <th class="black">Notes</th>
            </tr>
            <xsl:apply-templates select="extension[o:included(.,$including/string(.) )]"/>
            
         </table>
      </xsl:where-populated>
   </xsl:template>
   
   <!-- should be given on /extensions/extension-namespace[1] but it isn't -  -->
   <xsl:variable name="pfx" as="xs:string">o</xsl:variable>
  
   <!-- returns true for elements wanted in the table. If a 'binding' element
     is present with a @pattern containing one of the $including strings, we accept it. -->
   <xsl:function name="o:included" as="xs:boolean">
      <xsl:param name="who" as="node()"/>
      <xsl:param name="includes" as="xs:string*"/>
      
      <!-- Setting all this up with variables for debuggability -->
      <!--<xsl:message expand-text="true">including { $who/name() } '{ $who/@id}' ?</xsl:message>-->
      <xsl:variable name="match-strings" select="$includes ! ($pfx || ':' || .)"/>
      <!-- include any binding leading with '/*' -->
      <xsl:variable name="match-regex" select="('(' || string-join(($match-strings,'^/\*'),'|') || ')' )"/>
      <xsl:variable name="patterns-here" select="$who/binding/@pattern"/>
      <xsl:variable name="gotcha" select="some $p in ($patterns-here) satisfies matches($p,$match-regex)"/>
      <xsl:message expand-text="true">matching { string-join($match-strings,', ') } on patterns { string-join($patterns-here, ', ') }  using regex '{ $match-regex}' : { $gotcha } </xsl:message>
      
      <xsl:sequence select="$gotcha"/>
      
   </xsl:function>
   
   <xsl:template match="extension">
      <xsl:param name="including" tunnel="true" required="true" as="element()*"/>
      <xsl:variable name="here" select="."/>
      <tr class="extension">
         <xsl:for-each select="$including">
            <td class="center">
               <xsl:choose>
                  <xsl:when test="o:included($here,string(.))">
                     <xsl:apply-templates mode="report-cardinality" select="$here"/>
                  </xsl:when>
                  <xsl:otherwise><span class="grey">n/a</span></xsl:otherwise>
               </xsl:choose>
            </td>
         </xsl:for-each>
         <td class="data">
            <xsl:apply-templates select="formal-name, description"/>
         </td>
         <td class="mtype">
            <xsl:apply-templates select="." mode="metaschema-type"/>
         </td>
         <td class="pname">
            <xsl:apply-templates select="extension-name"/>
         </td>
         <td class="xpaths">
            <xsl:for-each select="binding">
               <p class="binding">
                  <xsl:value-of select="@pattern"/>
               </p>
            </xsl:for-each>
         </td>
         <td class="mdtype">
            <xsl:value-of select="(constraint/matches/@data-type,'&#xA0;')[1]"/>
         </td>
         <td class="defined-ids center">&#xA0;</td>
         <td class="avs center">
            <xsl:sequence select="if (exists(constraint/allowed-values)) then 'x' else '&#xA0;'"/>
         </td>
         <td class="notes">
            <xsl:apply-templates select="remarks"/>
         </td>
         
         <!--<xsl:apply-templates/>-->
      </tr>
   </xsl:template>
   
   
   
   <xsl:template mode="metaschema-type" match="extension">
      <xsl:for-each expand-text="true" select="binding/@pattern/tokenize(.,'/')[last()] ! replace(.,'\[.*$','') ! replace(.,'^.*:','') => distinct-values()">
         <p class="pattern">{ . }</p>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template match="extension" mode="report-cardinality">
      <xsl:apply-templates select="constraint/has-cardinality" mode="#current"/>
      <xsl:if test="empty(constraint/has-cardinality)">
         <span class="grey">[unspecified]</span></xsl:if>
   </xsl:template>
   
   <xsl:template mode="report-cardinality" match="has-cardinality">
      <xsl:variable name="minOccurs" select="(@min-occurs, '0')[1]"/>
      <xsl:variable name="maxOccurs"
         select="
         (@max-occurs, '1')[1] ! (if (. eq 'unbounded') then
         '&#x221e;'
         else
         .)"/>
      <span class="cardinality">
         <xsl:choose>
            <xsl:when test="$minOccurs = $maxOccurs" expand-text="true">{ $minOccurs }</xsl:when>
            <xsl:when test="number($maxOccurs) = number($minOccurs) + 1" expand-text="true">{
               $minOccurs } or { $maxOccurs }</xsl:when>
            <xsl:otherwise expand-text="true">{ $minOccurs } to { $maxOccurs }</xsl:otherwise>
         </xsl:choose>
      </span>
   </xsl:template>
   
   
   <xsl:template match="formal-name">
      <h4 class="formal-name">
         <xsl:apply-templates/>
      </h4>
   </xsl:template>
   
   <xsl:template match="description">
      <p class="description">
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <xsl:template match="remarks">
      <div class="remarks">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <xsl:template match="extension-name">
      <p class="extension-name">
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <xsl:template match="p | ul | table | h1 | h2 | h3 | h4 | h5 | h6">
      <xsl:apply-templates select="." mode="cast-html"/>
   </xsl:template>
   
   <xsl:template match="*" mode="cast-html">
      <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates mode="cast-html"/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template match="insert" mode="cast-html">
      <span class="insert">
         <xsl:text>insert value </xsl:text>
         <xsl:value-of select="@paramk-id"/>
      </span>
   </xsl:template>
   
   <xsl:key name="resource-by-internal-link" match="resource" use="'#' || @uuid"/>
   
   <xsl:template match="a" mode="cast-html">
      <xsl:variable name="resource" select="key('resource-by-internal-link',@href)"/>
      <a href="{ ($resource/rlink[1]/@href,@href)[1] }">
        <xsl:apply-templates/>
      </a>
   </xsl:template>
   
   
   <xsl:template mode="asleep" match="extensions">
      <div class="extensions">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <xsl:template mode="asleep" match="index">
      <div class="index">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="extension">
      <div class="extension">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="constraint">
      <div class="constraint">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="has-cardinality">
      <div class="has-cardinality">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="matches">
      <div class="matches">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="expect">
      <div class="expect">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="index-has-key">
      <div class="index-has-key">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="allowed-values">
      <div class="allowed-values">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template mode="asleep" match="extension-namespace">
      <p class="extension-namespace">
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   <xsl:template mode="asleep" match="key-field">
      <p class="key-field">
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   <xsl:template mode="asleep" match="binding">
      <p class="binding">
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <xsl:template mode="asleep" match="enum">
      <p class="enum">
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   <xsl:template name="css">
      <style type="text/css">
html, body { font-family: sans-serif }

div { margin-left: 1rem }
.tag { color: green; font-family: sans-serif; font-size: 80%; font-weight: bold }
.UNKNOWN { color: red; font-family: sans-serif; font-size: 80%; font-weight: bold }
.UNKNOWN .tag { color: darkred }

table.spread th, table.spread td { border: thin solid black; vertical-align: top; padding: 0.4rem }
table.spread th *, table.spread td * { margin: 0rem; margin-top: 0.6em }
table.spread th *:first-child, table.spread td *:first-child { margin-top: 0em }

.center { text-align: center }

.blue { background-color: lightsteelblue }
.red { color: red }
.grey { color: grey }
.black { background-color: black; color: white; font-weight: bold }

.cardinality { white-space: nowrap; font-weight: bold }

.binding, .pattern { font-family: monospace }

.remarks { font-size: smaller }

td.data p { font-size: smaller }

</style>
   </xsl:template>
   <xsl:template priority="-0.4"
                 match="extensions | index | extension | constraint | has-cardinality | matches | expect | index-has-key | allowed-values">
      <div class="{name()}">
         <div class="tag">
            <xsl:value-of select="name()"/>: </div>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   <xsl:template priority="-0.4"
                 match="extension-namespace | key-field | extension-name | binding | formal-name | description | enum">
      <p class="{name()}">
         <span class="tag">
            <xsl:value-of select="name()"/>: </span>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   <!-- fallback logic catches strays -->
   <xsl:template match="*">
      <p class="UNKNOWN {name()}">
         <span class="tag">
            <xsl:value-of select="name()"/>: </span>
         <xsl:apply-templates/>
      </p>
   </xsl:template>
</xsl:stylesheet>
