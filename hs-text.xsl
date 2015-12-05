<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="tei"
		version="2.0">

<xsl:output method="text" encoding="utf-8" />

<xsl:strip-space elements="*" />
<xsl:preserve-space elements="tei:app tei:lem tei:rdg" /> 

<xsl:template match="/"><xsl:apply-templates /></xsl:template>
  
<xsl:template match="tei:text[@xml:id='hs']//tei:lg[@type='poem'] |
		       tei:group[@xml:id='mckay_additional-poems']//tei:lg[@type='poem']" priority="100">
    <!-- Create variable to hold a unique id for this poem, which can be used 
         to generate other unique xml:id's for elements within the poem. -->
<xsl:variable name="poemid">
<xsl:choose>
<xsl:when test="ancestor::tei:group[@xml:id='mckay_additional-poems']">
<xsl:value-of select="../../@xml:id" />
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="@xml:id" />
</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<!-- For Poems. -->
<xsl:result-document method="text" href="text/{$poemid}.txt"><xsl:apply-templates /><xsl:text>
</xsl:text>
</xsl:result-document>
</xsl:template>

<xsl:template match="tei:div[@type='introductory-prose'] | tei:text[@type='review'] | tei:text[@type='supplementary']">
<xsl:variable name="id"><xsl:value-of select="@xml:id" />.txt</xsl:variable>
<xsl:result-document method="text" href="text/{$id}"><xsl:apply-templates /><xsl:text>
</xsl:text></xsl:result-document>
</xsl:template>

<!-- Rules for handling apparatus. -->
<xsl:template match="tei:app"><xsl:apply-templates /></xsl:template>

<xsl:template match="tei:lem"><xsl:apply-templates /></xsl:template>

<xsl:template match="tei:rdg"></xsl:template>

<xsl:template name="stanza" match="tei:lg[@type='stanza']"><xsl:apply-templates /><xsl:text>
</xsl:text></xsl:template>

<xsl:template match="tei:l"><xsl:choose>
<xsl:when test="@rend='indent1'"><xsl:text>   </xsl:text></xsl:when>
<xsl:when test="@rend='indent2'"><xsl:text>      </xsl:text></xsl:when>
<xsl:when test="@rend='indent3'"><xsl:text>         </xsl:text></xsl:when>
<xsl:when test="@rend='indent4'"><xsl:text>            </xsl:text></xsl:when>
</xsl:choose>
<xsl:apply-templates /><xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="tei:head"><xsl:apply-templates /><xsl:text>

</xsl:text>
</xsl:template>

<xsl:template match="tei:head/text()"><xsl:value-of select="upper-case(.)" /></xsl:template>
<xsl:template match="tei:head/tei:title"><xsl:value-of select="upper-case(.)" /></xsl:template>
<xsl:template match="tei:bibl" />

<!-- Silence notes. -->
<xsl:template match="tei:note"></xsl:template>

<xsl:template match="text()"><xsl:value-of select="normalize-space(.)" /></xsl:template>

<xsl:template match="tei:l/text()|tei:lem/text()"><xsl:value-of select="." /></xsl:template> 

</xsl:stylesheet>
