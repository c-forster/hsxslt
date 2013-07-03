<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html" media-type="text/html; charset=UTF-8" doctype-public="html" 
        indent="yes" encoding="utf-8" omit-xml-declaration="yes"/>

  <xsl:key name="witnessTitles" match="//tei:witness" use="@xml:id" />

  <xsl:template match="tei:TEI">
    <html>
    <xsl:apply-templates />
    </html>
  </xsl:template>

<!-- Create HTML header from teiHeader -->
  <xsl:template match="tei:teiHeader">
    <head>
      <link rel="stylesheet" href="hs.css" />
    <xsl:apply-templates />
    </head>
  </xsl:template>

<!-- This rule creates a container div for formatting HTML  -->
<!-- Applying it to tei:body works; applying it to tei:text -->
<!-- does not. I don't know WHY!?!?!?! -->
  <xsl:template match="tei:body">
    <div id="container">
      <xsl:apply-templates />
    </div>
  </xsl:template>

<!-- use titleStmt title for HTML document title -->
  <xsl:template match="tei:titleStmt/tei:title">
    <title>
      <xsl:value-of select="." />
    </title>
  </xsl:template>

  <xsl:template match="tei:text">
    <body>
      <xsl:apply-templates />
    </body>
  </xsl:template>

  <xsl:template match="tei:lg[@type='poem']">
    <xsl:element name="div">
      <xsl:attribute name="class">poem</xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="@xml:id" /></xsl:attribute>
      <xsl:apply-templates />
      <!-- Generate apparatus for notes -->
      <ul class="editorialNotes">
      <xsl:for-each select=".//tei:note[@type='editorial']">
	<li><xsl:value-of select="." /></li>
      </xsl:for-each>
      </ul>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:lg[@type='poem']/tei:lg">
    <div class="linegroup">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="tei:lg[@type='poem']/tei:head">
    <xsl:element name="h3">
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:l">
    <xsl:element name="p">
      <span class="lineNo">
        <xsl:choose>
	  <xsl:when test="parent::tei:lg[@type='poem']">
	    <xsl:value-of select="count(preceding-sibling::tei:l)+1" />
	  </xsl:when>
	  <xsl:otherwise> 
	    <xsl:value-of select="count(preceding-sibling::tei:l)+count(../preceding-sibling::tei:lg/tei:l)+1"/>
	  </xsl:otherwise>
	</xsl:choose> 
      </span>

<!-- This span contains the poetic line itself -->
      <xsl:element name="span"> <xsl:attribute name="class">poetic-line <xsl:for-each select="@*"> <xsl:value-of select="." /> </xsl:for-each> </xsl:attribute>
	<xsl:apply-templates />
      </xsl:element>
<!-- Here ends the template which grabs the poetic line itself -->
    </xsl:element>
  </xsl:template>

  <!-- This template outputs the text content of poetic lines. -->
  <xsl:template match="tei:l/text()">
    <xsl:value-of select="." />
  </xsl:template>

  <!-- This template outputs the text content of head elements -->
  <!-- that are children of lgs; mostly the titles of individual -->
  <!-- poems, but also some other stuff.  -->
<!--  <xsl:template match="tei:lg/tei:head/text()"> -->
<!--    <xsl:apply-templates /> -->
<!--    <xsl:value-of select="." /> 
  </xsl:template>
-->
  <xsl:template match="tei:app">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="tei:lem">
    <xsl:element name="span">
      <xsl:attribute name="class">lemma</xsl:attribute>
<!--      <xsl:value-of select="." /> -->
     <!-- We test for an empty lemma for those cases, usually puncutation   -->
     <!-- where something has been simply added. We use this to indicate    -->
     <!-- where in the text. -->
      <xsl:if test="not(* or text())"><span class="empty-lemma">&#160;</span></xsl:if>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:rdg">
<!--    <xsl:element name="span"> -->
    <xsl:element name="div">
      <xsl:attribute name="class">reading</xsl:attribute>
<!--      <xsl:value-of select="." /> -->
      <xsl:value-of select="../tei:lem" />]
      <xsl:apply-templates /> (
      <!-- <xsl:apply-templates select="key('witnessTitles',substring-after(@wit,'#'))" />)-->
      <xsl:value-of select="substring-before(@wit,'-')" />)
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:note">
    <div class="note">
      <xsl:apply-templates />
    </div>
  </xsl:template>

<!-- Probably the ugliest bit of this code. Creates a sort of ad-hoc -->
<!-- sigla, not for each *witness*, but for each major work. This    -->
<!-- adhoc sigla in turn is used in the textual apparatus, to avoid  -->
<!-- having to output the full title / bibl. -->
  <xsl:template match="tei:ref">
    <xsl:apply-templates /> (<span class="sigla"><xsl:value-of select="substring-before(@target,'-')" /></span>)
  </xsl:template>

<!--  <xsl:template match="@rend">
    <xsl:apply-templates />
  </xsl:template>
-->
<!-- Span level Templates -->
<!-- This template matches journal and monograph titles -->
  <xsl:template match="tei:title[@level='j']|tei:title[@level='m']">
    <span class='title'><xsl:apply-templates /></span>
  </xsl:template>

<!-- Templates for convert TEI lists into HTML lists -->
  <xsl:template match="tei:list">
    <ul>
      <xsl:apply-templates />
    </ul>
  </xsl:template>

  <xsl:template match="tei:item">
    <li><xsl:apply-templates /></li>
  </xsl:template>

<!--  <xsl:template match="//*[@rend='caps']">
    <span class="caps">
      <xsl:apply-templates />
    </span>
  </xsl:template>
-->
<!-- This is a dummy rule to override the default; this means, rather than  -->
<!--  vomitting everything, only material matched to templates above will, in -->
<!-- fact appear. - csf 6/12/13  -->
<!-- <xsl:template match="text()|@*"> 
</xsl:template>  -->

<!-- Front Matter Template -->
<xsl:template match="tei:front">
  <xsl:apply-templates />
</xsl:template>

<!-- Table of Contents Templates -->
<xsl:template match="tei:div[@type='contents']">
  <div id="tableOfContents">
    <xsl:apply-templates />
  </div>
</xsl:template>

<!--
<xsl:template match="tei:div[@type='contents']//tei:ref">
  <xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="@target" /></xsl:attribute><xsl:apply-templates /></xsl:element>
</xsl:template>
-->
<xsl:template match="tei:div[@type='contents']//tei:item">
  <li><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="tei:ref/@target" />
</xsl:attribute><xsl:apply-templates /></xsl:element></li>
</xsl:template>

<xsl:template match="tei:div[@type='contents']//tei:ref">
</xsl:template>


<!-- Introduction -->
<xsl:template match="tei:div[@type='introduction']|tei:div[@type='preface']">
  <div class="prose">
    <xsl:apply-templates />
  </div>
</xsl:template>

<xsl:template match="tei:head">
  <h3><xsl:apply-templates /></h3>
</xsl:template>

<xsl:template match="tei:p">
  <p><xsl:apply-templates /></p>
</xsl:template>

<xsl:template match="tei:signed">
  <p class="signature"><xsl:apply-templates /></p>
</xsl:template>


<!-- Title -->
<xsl:template match="tei:titlePage">
  <div id="titlePage">
    <xsl:apply-templates />
  </div>
</xsl:template>

<xsl:template match="tei:titlePart[@type='main']">
  <h2><xsl:apply-templates /></h2>
</xsl:template>

<xsl:template match="tei:titlePart[@type='sub']">
  <h3><xsl:apply-templates /></h3>
</xsl:template>

<xsl:template match="tei:titlePart[@type='desc']">
  <h4><xsl:apply-templates /></h4>
</xsl:template>

<!-- Front matter -->
<xsl:template match="tei:div[@type='frontmatter']">
  <div id="frontmatter"><xsl:apply-templates /></div>
</xsl:template>

<!-- Elements with rend attributes -->
<xsl:template match="tei:*[@rend='italics']"><em><xsl:apply-templates /></em></xsl:template>

<!-- Line breaks marked in TEI. -->
<xsl:template match="tei:lb"><br /></xsl:template>

<xsl:template match="tei:pb"><div class="pageBreak"><xsl:value-of select="@n" /></div></xsl:template>

<!-- For editorial notes within the text -->
<xsl:template match="tei:note[@type='editorial']">◦ </xsl:template>

</xsl:stylesheet>

