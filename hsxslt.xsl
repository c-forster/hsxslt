<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

  <xsl:output method="html" media-type="text/html; charset=UTF-8" doctype-public="html" 
              indent="yes" encoding="utf-8" omit-xml-declaration="yes"/>

  <xsl:key name="witnessTitles" match="//tei:witness" use="@xml:id" />

  <xsl:template match="tei:TEI">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template name="tableOfContents">

    <div id="tableOfContents">
      <!-- Rules for extracting Harlem Shadows and its Table of Contents -->
      <h3>Harlem Shadows</h3>
      <ul>
	<!-- A rule for where a div type=contents exist, ie Harlem Shadows-->
	<xsl:for-each select="/tei:TEI/tei:text/tei:group/tei:text/tei:front/tei:div[@type='contents']//tei:item">
	  <li>
	    <xsl:element name="a">
	      <xsl:attribute name="href"><xsl:value-of select="concat(substring-after(tei:ref/@target,'#'),'.html')" /></xsl:attribute>
	      <xsl:apply-templates />
	    </xsl:element>
	  </li>
	</xsl:for-each>
	<xsl:for-each select="tei:text[@xml:id='HarlemShadows-DigitalEdition']/tei:group/tei:group">	
	  <h3><xsl:value-of select="tei:head" /></h3>
	  <!-- A rule for extracting titles and links from other texts -->
	  <xsl:for-each select="tei:text">
	    <li>
	      <xsl:element name="a">
		<xsl:attribute name="href">#<xsl:value-of select="./@xml:id" /></xsl:attribute>
		<xsl:apply-templates select="tei:body/tei:head/tei:title" />
	      </xsl:element>
	    </li>
	  </xsl:for-each>
	</xsl:for-each>
      </ul>

      <!-- This next select matches all the group or text children of -->
      <!-- the main HSDE text wrapper. -->
    </div>

  </xsl:template>

  <xsl:template name="JSIncludes">
    <xsl:comment>TODO: Load jQuery from Google CDN with Fallback</xsl:comment>
    <script src="jquery-2.1.1.js" type="text/javascript"></script>

    <xsl:comment>Load simple JS controls.</xsl:comment>
    <script src="hs.js" type="text/javascript"></script>
  </xsl:template>

  <xsl:template match="tei:head">
  </xsl:template>


  <xsl:template match="tei:div/tei:head">
    <h3><xsl:apply-templates /></h3>
  </xsl:template>

  <!-- Create HTML header from teiHeader -->
  <xsl:template match="tei:teiHeader">
    <head>
      <link rel="stylesheet" href="hs.css" />
      <xsl:apply-templates />
    </head>
  </xsl:template>

  <!-- use titleStmt title for HTML document title -->
  <xsl:template match="tei:titleStmt/tei:title">
    <title><xsl:value-of select="." /></title>
  </xsl:template>

  <!-- These templates silence other aspects of the titleStmt that we -->
  <!-- don't need for HTML output. -->
  <xsl:template match="tei:titleStmt/tei:author"></xsl:template>
  <xsl:template match="tei:titleStmt/tei:principal"></xsl:template>
  <xsl:template match="tei:publicationStmt"></xsl:template>
  <xsl:template match="tei:sourceDesc"></xsl:template>

  <xsl:template match="tei:lg[@type='poem']">
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
    
    <xsl:result-document method="html" href="harlem-shadows/{$poemid}.html">
      <!-- HTML HEADER. -->
      <html>
	<head>
	  <title><xsl:value-of select="tei:head" /></title>
	  <link rel="stylesheet" href="hs.css" />
	  <meta charset="UTF-8" />
	</head>

	<body>
	  <div class="columnsContainer">
	    <div class="leftColumn">

	      <!-- Container div for poem. -->
	      <xsl:element name="div">
		<xsl:attribute name="class">poem</xsl:attribute>
		<xsl:attribute name="id"><xsl:value-of select="$poemid" /></xsl:attribute>

		<!-- Toggles for individual poem. -->
		<xsl:text>&#10;</xsl:text>
		<div>
		  <xsl:attribute name="class">toggles</xsl:attribute>
		  <xsl:attribute name="xml:id"><xsl:value-of select="$poemid" />_toggles</xsl:attribute>
		  <xsl:text>&#10;</xsl:text>
		  <xsl:comment>This div contains the toggles for notes, apparatus, etc.</xsl:comment>
		  <xsl:text>&#10;</xsl:text>
		  <h4>Textual Features:</h4><xsl:text>&#10;</xsl:text>
		  <form><xsl:text>&#10;</xsl:text>
		  <!--	  <div class="toggle"><input type="checkbox"><xsl:attribute name="id"><xsl:value-of select="$poemid" />_textualApparatusCheckBox</xsl:attribute>Textual Apparatus</input></div><xsl:text>&#10;</xsl:text> -->
		  <div class="toggle"><input type="checkbox"><xsl:attribute name="id"><xsl:value-of select="$poemid" />_editorialNotesCheckBox</xsl:attribute>Editorial Notes</input></div><xsl:text>&#10;</xsl:text>
		  <!--	  <div class="toggle"><input type="checkbox"><xsl:attribute name="id"><xsl:value-of select="$poemid" />_citationCheckBox</xsl:attribute>Citation</input></div><xsl:text>&#10;</xsl:text> -->
		  <!--	  <div class="toggle"><input type="checkbox"><xsl:attribute name="id"><xsl:value-of select="$poemid" />_contextualNotesCheckBox</xsl:attribute>Contextual Notes</input></div><xsl:text>&#10;</xsl:text> -->
		  </form>	<xsl:text>&#10;</xsl:text>
		  </div><xsl:text>&#10;</xsl:text>

		  <xsl:apply-templates />

		  <!-- Generate apparatus for notes -->
		  <ul>
		    <xsl:attribute name="class">editorialNotes</xsl:attribute>
		    <xsl:attribute name="id"><xsl:value-of select="$poemid" />_editorialNotes</xsl:attribute>
		    <xsl:text>&#10;</xsl:text>
		    <xsl:for-each select=".//tei:note[@type='editorial']">
		      <li>
			<xsl:attribute name="class">editorialNote</xsl:attribute>
			<xsl:attribute name="xml:id">
			  <xsl:value-of select="ancestor::tei:lg[@type='poem']/@xml:id" />_editorialNote_<xsl:value-of select="count(preceding-sibling::note)" />
			</xsl:attribute>
			<xsl:number count="tei:note[@type='editorial']" from="tei:lg[@type='poem']" level="any" />
			<xsl:text>: </xsl:text>
			<!-- In order preserve formatting using hi tag within notes, rather than value of -->
			<!-- this next function is apply-templates. I'm scared. - csf 5/29/14 -->
			<!--	  <xsl:value-of select="." /> -->
			<xsl:apply-templates />
			</li><xsl:text>&#10;</xsl:text>
		    </xsl:for-each>
		    </ul><xsl:text>&#10;</xsl:text>
	      </xsl:element>
	    </div>

	    <div class="rightColumn">
	      <xsl:call-template name="tableOfContents" />
	    </div>

	  </div>
	  
	  <!-- Load Javascript and jQuery. -->
	  <xsl:comment>TODO: Load jQuery from Google CDN with Fallback</xsl:comment>
	  <script src="jquery-2.1.1.js" type="text/javascript"></script>
	  <xsl:comment>Load simple JS controls.</xsl:comment>
	  <script src="hs.js" type="text/javascript"></script>

	</body>
      </html>
    </xsl:result-document>
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
      <xsl:attribute name="class">verse-container</xsl:attribute>
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

  <xsl:template match="tei:app">
    <span class="apparatus">
      <xsl:attribute name="id"><xsl:value-of select="ancestor::tei:lg[@type='poem']/@xml:id" />_app<xsl:value-of select="count(preceding::tei:app)" />
      </xsl:attribute>
      <xsl:apply-templates />
    </span>
  </xsl:template>

  <xsl:template match="tei:lem">
    <xsl:element name="span">
      <xsl:attribute name="class">reading lemma</xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="ancestor::tei:lg[@type='poem']/@xml:id" />_lemma_<xsl:value-of select="count(preceding-sibling::span[@class='lemma'])" /></xsl:attribute>
      <!--      <xsl:value-of select="." /> -->
      <!-- We test for an empty lemma for those cases, usually puncutation   -->
      <!-- where something has been simply added. We use this to indicate    -->
      <!-- where in the text. -->
      <xsl:if test="not(* or text())"><span class="empty-lemma">&#160;</span></xsl:if>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:rdg">
    <xsl:element name="span">
      <xsl:attribute name="class">reading</xsl:attribute>
      <xsl:attribute name="id">
	<xsl:value-of select="ancestor::tei:lg[@type='poem']/@xml:id" />_app<xsl:value-of select="count(../preceding-sibling::app)" />_rdg<xsl:value-of select="count(preceding-sibling::note)" />
      </xsl:attribute>
      <xsl:value-of select="." /><xsl:text> </xsl:text><xsl:apply-templates select="@wit" />
    </xsl:element>
  </xsl:template>

  <!--
      <xsl:template match="tei:rdg">
      <xsl:element name="span">
      <xsl:attribute name="class">reading</xsl:attribute>
      <xsl:value-of select="../tei:lem" />]
      <xsl:apply-templates /> (
      <xsl:value-of select="substring-before(@wit,'-')" />)
      </xsl:element>
      </xsl:template>
  -->
  <xsl:template match="tei:note[@type='textual']">
    <xsl:element name="div">
      <xsl:attribute name="class">textualNote</xsl:attribute>
      <xsl:attribute name="xml:id"><xsl:value-of select="ancestor::tei:lg[@type='poem']/@xml:id" />_textualNote_<xsl:value-of select="count(preceding-sibling::note)" /></xsl:attribute>
      
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <!-- Probably the ugliest bit of this code. Creates a sort of ad-hoc -->
  <!-- sigla, not for each *witness*, but for each major work. This    -->
  <!-- adhoc sigla in turn is used in the textual apparatus, to avoid  -->
  <!-- having to output the full title / bibl. -->
  <xsl:template match="tei:lg/tei:head/tei:note//tei:ref">
    <!--    <xsl:apply-templates /> (<span class="sigla"><xsl:value-of select="substring-before(@target,'-')" /></span>) -->
    <xsl:apply-templates /> (<xsl:apply-templates select="@target" />)
  </xsl:template>

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
  <!-- 
       <xsl:template match="tei:div[@type='contents']">
       <div id="tableOfContents">
       <h3>Harlem Shadows</h3>
       <xsl:apply-templates />
       <xsl:for-each select="tei:group">
       <h2><xsl:apply-templates select="tei:head" /></h2>
       <ul>
       <xsl:for-each select="tei:text">
       <li><xsl:apply-templates select="tei:head" /></li>
       </xsl:for-each>
       </ul>
       </xsl:for-each>
       </div>
       </xsl:template>
  -->

  <!--
      <xsl:template match="tei:div[@type='contents']//tei:ref">
      <xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="@target" /></xsl:attribute><xsl:apply-templates /></xsl:element>
      </xsl:template>
  -->
  <!--
      <xsl:template match="tei:div[@type='contents']//tei:item">
      <li><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="tei:ref/@target" />
      </xsl:attribute><xsl:apply-templates /></xsl:element></li>
      </xsl:template>
  -->

  <xsl:template match="tei:div[@type='contents']">
  </xsl:template>
  <xsl:template match="tei:div[@type='contents']//tei:ref">
  </xsl:template>


  <!-- Introduction/Preface/Etc ;; Prose Materials -->
  <xsl:template match="tei:div[@type='introductory-prose']">
    <xsl:element name="div">
      <xsl:attribute name="class">prose</xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="@xml:id" /></xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <!--
      <xsl:template match="tei:head">
      <h3><xsl:apply-templates /></h3> 
      </xsl:template>
  -->

  <xsl:template match="tei:p">
    <p><xsl:apply-templates /></p>
  </xsl:template>

  <xsl:template match="tei:closer">
    <p class="closer"><xsl:apply-templates /></p>
  </xsl:template>

  <xsl:template match="tei:closer//*">
    <br /><xsl:apply-templates />
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
    <xsl:apply-templates />
  </xsl:template>

  <!-- This template matches the half-title page -->
  <xsl:template match="tei:div[@type='half-title']">
    <div id="half-title"><h4><xsl:apply-templates /></h4></div>
  </xsl:template>

  <!-- Front matter -->
  <xsl:template match="tei:div[@type='frontmatter']">
    <div id="frontmatter"><xsl:apply-templates /></div>
  </xsl:template>

  <!-- Elements with rend attributes -->
  <xsl:template match="tei:*[@rend='italics']"><em><xsl:apply-templates /></em></xsl:template>
  <xsl:template match="tei:*[@rend='bold']"><strong><xsl:apply-templates /></strong></xsl:template>

  <!-- Line breaks marked in TEI. -->
  <xsl:template match="tei:lb"><br /></xsl:template>

  <xsl:template match="tei:pb"><span class="pageBreak"><xsl:value-of select="@n" /></span></xsl:template>

  <!-- This template inserts footnote markers within the text -->
  <xsl:template match="tei:note[@type='editorial']"><xsl:element name="sup">
    <xsl:attribute name="class">footnote <xsl:value-of select="ancestor::tei:lg[@type='poem']/@xml:id" />_editorialNotesFn</xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select="ancestor::tei:lg[@type='poem']/@xml:id" />_fn<xsl:number count="tei:note[@type='editorial']" from="tei:lg[@type='poem']" level="any" /></xsl:attribute><xsl:number count="tei:note[@type='editorial']" from="tei:lg[@type='poem']" level="any" />
  </xsl:element>
  </xsl:template>

  <!-- Templates for secondary material: contemporary reviews. -->
  <!-- This groups supplementary material in here too. -->
  <xsl:template match="tei:text[@type='review'] | tei:text[@type='supplementary']">
    <xsl:element name="div">
      <xsl:attribute name="class">prose review</xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="@xml:id" /></xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:text[@type='review']/tei:body/tei:head">
    <xsl:apply-templates />
  </xsl:template>

  <!-- This template generates per-review titles with author name. -->
  <!-- HACK: Also grabs supplementary material and handles them the same way. -->
  <xsl:template match="tei:text[@type='review']/tei:body/tei:head|tei:text[@type='supplementary']/tei:body/tei:head">
    <h2 class="review-title"><xsl:apply-templates select="tei:title" />
    </h2>
    <xsl:if test="tei:bibl/tei:author">
      <h4 class="review-author">by 
      <!-- First name/names -->
      <xsl:for-each select="tei:bibl/tei:author/tei:persName/tei:forename">
	<xsl:apply-templates select="." />&#160; 
	<!--  <xsl:value-of select="." />&#160; -->
      </xsl:for-each>
      <!-- Last name -->
      <xsl:apply-templates select="tei:bibl/tei:author/tei:persName/tei:surname" />
      </h4>
    </xsl:if>
    <!-- We now do not call apply-tempaltes for all templates, otherwise we'll -->
    <!-- output stuff we don't want; just the bibl for the citation. -->
    <xsl:apply-templates select="tei:bibl" />
  </xsl:template>

  <!-- This template silences the bibl description. Ideally, they should be -->
  <!-- gathered together in a div, as a sort of works cited. #+:TODO. -->
  <xsl:template match="tei:bibl">
    <!--  <p class="citation"><strong>Citation:</strong> <xsl:apply-templates /></p> -->
  </xsl:template>

  <!-- The following templates format bibliographical info from bibl into an MLA -->
  <!-- style citation. -->
  <xsl:template match="tei:bibl/tei:author">
    <xsl:apply-templates select="tei:persName/tei:surname" />, 
    <xsl:for-each select="tei:persName/tei:forename">
      <xsl:apply-templates select="."/><xsl:if test="position() != last()">&#160;</xsl:if>
      </xsl:for-each>.
  </xsl:template>

  <xsl:template match="tei:bibl/tei:title[@level='a']">
    "<xsl:apply-templates />."
  </xsl:template>

  <xsl:template match="tei:bibl/tei:title[@level='j']">
    <em><xsl:apply-templates /></em> 
  </xsl:template>

  <xsl:template match="tei:bibl/tei:title[@level='j' and @type='main']">
    <em><xsl:value-of select="." />: </em>
  </xsl:template>

  <xsl:template match="tei:bibl/tei:title[@level='j' and @type='sub']">
    <em><xsl:value-of select="." /></em> 
  </xsl:template>



  <!-- This date template could use @when to normalize dates. -->
  <xsl:template match="tei:bibl/tei:date">
    (<xsl:value-of select="." />).
  </xsl:template>

  <!-- For now, we silently omitting place of publication and page References. -->
  <xsl:template match="tei:bibl/tei:pubPlace">
  </xsl:template>
  <xsl:template match="tei:bibl/tei:biblScope">
  </xsl:template>

  <!-- This rule contains the single worst hack of all; a one-off, bespoke rule -->
  <!-- to not print a *particular* head within the document. -->
  <!-- Heaven forgive me. -->
  <xsl:template match="tei:group/tei:head">
    <xsl:choose>
      <xsl:when test="../@xml:id='hs'">
      </xsl:when>
      <xsl:otherwise>
	<xsl:element name="h1">
	  <xsl:attribute name="class">section-title</xsl:attribute>
	  <xsl:apply-templates />
	</xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:p/tei:note">
    <span class="note">
      <xsl:apply-templates />
    </span>
  </xsl:template>

  <!-- Template for quoted material, including poems, particularly in reviews. -->
  <xsl:template match="tei:quote">
    <xsl:choose>
      <xsl:when test="@source">
	<xsl:element name="a">
	  <xsl:attribute name="class">source</xsl:attribute>
	  <xsl:attribute name="href"><xsl:value-of select="@source" /></xsl:attribute>
	  <xsl:apply-templates />
	</xsl:element>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:quote/tei:lg">
    <span class="quoted-lg">
      <xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text>
      <xsl:apply-templates />
      <xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="tei:quote/tei:lg/tei:l">
    <span class="quoted-poetry"><xsl:apply-templates />
    <!-- This sillines is necessary, otherwise our one br tag gets 
	 interpreted as two. -->
    <xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text></span>
  </xsl:template>

  <xsl:template match="tei:quote/tei:lg/tei:lg/tei:l">
    <span class="quoted-poetry">
      <xsl:element name="span"> <xsl:attribute name="class">poetic-line <xsl:for-each select="@*"> <xsl:value-of select="." /> </xsl:for-each> </xsl:attribute>
      <xsl:apply-templates />
      </xsl:element>
      <!-- This sillines is necessary, otherwise our one br tag gets 
	   interpreted as two. -->
    <xsl:text disable-output-escaping="yes">&lt;br /&gt;</xsl:text></span>
  </xsl:template>

  <!-- Template for resolving choice elements -->
  <!-- For now, when there is a choice between: -->
  <!-- a sic and a corr -->
  <!-- or an abbreviation and an expansion -->
  <!-- it chooses the latter. --> 
  <xsl:template match="tei:choice">
    <xsl:apply-templates select="tei:corr|tei:abbr" />
  </xsl:template>

  <!-- Here we handle abbreviations. If type is initial, we add a period. -->
  <!-- Otherwise, this is just a passthrough. -->
  <xsl:template match="tei:abbr">
    <xsl:apply-templates /><xsl:if test="@type='initial'">.</xsl:if>
  </xsl:template>

  <!-- A generic rule to convert refs into HTML a tags. -->
  <xsl:template match="tei:ref">
    <xsl:element name="a">
      <xsl:attribute name="class">reference</xsl:attribute>
      <xsl:attribute name="href"><xsl:value-of select="@target" /></xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:note[@type='textual']//tei:ref" priority="2">
    <xsl:element name="a">
      <xsl:attribute name="class">reference</xsl:attribute>
      <xsl:attribute name="href"><xsl:value-of select="@target" /></xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
    [<xsl:apply-templates select="@target" />]
  </xsl:template>
  <!-- This rule is basically a cheat; it essentially implements a crude 
       sort of look up that converts witness names (or partial witness names) 
       to single character sigla markers. 

You might be asking, why not use xsl:when and xsl:choice.
Good question! Well, a single @wit can in fact contain multiple matches, so
for that reason this crude set of if statements is actually better and easier 
to maintain in this circumstance. Really.
  -->
  <xsl:template match="@wit|@target">
    <xsl:if test="contains(., '#Liberator')"><span class="sigla">*</span></xsl:if>
    <xsl:if test="contains(., '#SINH')"><span class="sigla">†</span></xsl:if>
    <xsl:if test="contains(., '#Pearsons')"><span class="sigla">§</span></xsl:if>
    <xsl:if test="contains(., '#Cambridge')"><span class="sigla">#</span></xsl:if>
    <xsl:if test="contains(., '#ThreeSonnets')"><span class="sigla">‡</span> </xsl:if>
    <xsl:if test="contains(., '#SevenArts')"><span class="sigla">‖</span> </xsl:if>
    <xsl:if test="contains(., '#Messenger')"><span class="sigla">Δ</span> </xsl:if>
  </xsl:template>

</xsl:stylesheet>

