<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:output method="html" media-type="text/html; charset=UTF-8" doctype-public="html" 
        indent="yes" encoding="utf-8" omit-xml-declaration="yes"/>

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
    <div class="poem">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="tei:lg[@type='poem']/tei:lg">
    <div class="linegroup">
      <xsl:apply-templates />
    </div>
  </xsl:template>

  <xsl:template match="tei:lg[@type='poem']/tei:head">
    <h3>
      <xsl:apply-templates />
    </h3>
  </xsl:template>

  <xsl:template match="tei:l">
    <xsl:element name="p">
      <xsl:attribute name="class">
	poetic-line
	<xsl:for-each select="@*">
	  <xsl:value-of select="." />
	</xsl:for-each>
      </xsl:attribute>

      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <!-- This template outputs the text content of poetic lines. -->
  <xsl:template match="tei:l/text()">
    <xsl:value-of select="." />
  </xsl:template>

  <!-- This template outputs the text content of head elements -->
  <!-- that are children of lgs; mostly the titles of individual -->
  <!-- poems, but also some other stuff. -->
  <xsl:template match="tei:lg/tei:head/text()">
    <xsl:value-of select="." />
  </xsl:template>

  <!-- The Following Rule Will Output The Content of the lemma within any -->
  <!-- textual apparatus, ignoring the other readings. -->
  <xsl:template match="tei:app">
    <xsl:value-of select="tei:lem" />
  </xsl:template>

<!-- This is a dummy rule to override the default; this means, rather than  -->
<!--  vomitting everything, only material matched to templates above will, in -->
<!-- fact appear. - csf 6/12/13  -->
<xsl:template match="text()|@*">
</xsl:template>
  
</xsl:stylesheet>
