<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		exclude-result-prefixes="tei"
		version="2.0">

  <xsl:output method="html" version="5.0" indent="yes" encoding="utf-8" omit-xml-declaration="yes" />

  <xsl:key name="witnessTitles" match="//tei:witness" use="@xml:id" />

  <xsl:template match="tei:TEI">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template name="tableOfContents">
    <div id="tableOfContents" class="col-sm-6 col-md-3">
      <!-- TO BE ADDED HERE: Introductory Material. -->
      <h2>Contents:</h2>
      
      <!-- Rules for extracting Harlem Shadows and its Table of Contents -->
      <h3><em>Harlem Shadows</em> (1922)</h3>
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
      </ul>

      <!-- A Rule for the Other Main Heads. -->
      <xsl:for-each select="/tei:TEI/tei:text/tei:group/tei:group">	
	<h3><xsl:value-of select="tei:head" /></h3>
	<ul>
	  <!-- A rule for extracting titles and links from other texts -->
	  <xsl:for-each select="tei:text">
	    <li>
	      <xsl:element name="a">
		<xsl:attribute name="href"><xsl:value-of select="@xml:id" />.html</xsl:attribute>
		<xsl:apply-templates select="tei:body/tei:head/tei:title" />
	      </xsl:element>
	    </li>
	  </xsl:for-each>
	</ul>
      </xsl:for-each>

    </div>

  </xsl:template>

  <xsl:template name="JSIncludes">
    <xsl:comment>TODO: Load jQuery from Google CDN with Fallback</xsl:comment>
    <!-- <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script> -->
    <script src="jquery-2.1.1.min.js" type="text/javascript"></script>

    <!-- Latest compiled and minified JavaScript -->
    <script src="hsbs/js/bootstrap.min.js"></script> 
    <!-- <script src="bootstrap/js/bootstrap.min.js"></script> -->
    
    <xsl:comment>Load simple JS controls.</xsl:comment>
    <script src="hs.js" type="text/javascript"></script>
  </xsl:template>

  <xsl:template match="tei:div/tei:head">
    <h3><xsl:apply-templates /></h3>
  </xsl:template>

  <!-- Generate landing index.html page from the teiHeader -->
  <xsl:template match="tei:teiHeader">
    <xsl:result-document method="html" version="5.0" href="harlem-shadows/index.html">
      <html>
	<head>
	  <xsl:call-template name="htmlHeader" />
	  <title>Harlem Shadows: An Electronic Edition</title>

	  <xsl:call-template name="analytics" />
	</head>
	<body>

	  <xsl:call-template name="header" />

	  <div class="col-sm-7 col-md-6">
	    <div class="prose" id="editorsIntroduction">
	      <h1>Harlem Shadows (1922)</h1>

	      <p>This is an open-source edition of Claude McKay's 1922 collection of poems <em>Harlem Shadows</em>. It seeks to aggregate the most comprehensive set of documents related to <em>Harlem Shadows</em> and make them available to students and readers of McKay. This project is under development by <a href="http://cforster.com">Chris Forster</a> and <a href="http://roopikarisam.com">Roopika Risam</a>. You can read more <a href="http://cforster.com/2012/06/drill-baby-drill">about the inspiration for the project</a>.</p>
	      <p>The edition remains under development, but a rationale for the edition, introductory materials, an explanation of how its apparatus is organized, and a PDF copy of the same material collected here are all forthcoming (promise!).</p>
	      <ul>
		<li>Numerous scanned editions of <em>Harlem Shadows</em> exist:
		<ul>
		  <li><a href="http://books.google.com/books?id=aKTPAAAAMAAJ">Google Books Copy Scanned from Indiana University.</a></li>
		  <li><a href="http://books.google.com/books?id=EVFBAAAAYAAJ">Google Books Copy Scanned from Princeton.</a></li>
		  <li><a href="http://www.archive.org/details/harlemshadows00mcka">Archive.org Copy Scanned from the Library of Congress.</a></li>
		  <li><a href="http://www.archive.org/details/harlemshadowspoe00mckauoft">Archive.org Copy Scanned from the University of Toronto.</a></li>
		</ul>
		</li>
		<li>This page is generated from a TEI XML file <a href="https://github.com/c-forster/harlem-shadows">hosted on github</a>.</li>
		<li>The XSLT which transforms the TEI into the HTML viewable here is also <a href="https://github.com/c-forster/hsxlst">hosted on github.</a></li>
	      </ul>
	      <p>If you have any questions about this project or are interested in contributing, contact: <a href="mailto:cforster@syr.edu">cforster@syr.edu</a>.</p>
	      
	      <div id="footer">Page last generated: <xsl:call-template name='today' /></div>
	    </div>
	  </div>
	  <!-- Div for Table of Contents. -->
	  <xsl:text>&#xa;</xsl:text>
	  <xsl:call-template name="tableOfContents" />
	  <xsl:text>&#xa;</xsl:text>
	</body>
      </html>
    </xsl:result-document>
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
    
    <xsl:result-document method="html" version="5.0" href="harlem-shadows/{$poemid}.html">
      <!-- HTML HEADER. -->
      <html>
	<head>
	  <xsl:call-template name="htmlHeader" />
	  <title>Harlem Shadows: <xsl:value-of select="normalize-space((tei:head/text())[1])" /></title>

	  <xsl:call-template name="analytics" />
	</head>

	<body>

	  <xsl:call-template name="header" />

	  <!-- information: what was formerly toggles and textual note. -->
	      <div>
		<xsl:attribute name="class">information col-sm-3 col-md-3</xsl:attribute>
		<xsl:attribute name="id"><xsl:value-of select="$poemid" />_toggles</xsl:attribute>
		<xsl:text>&#10;</xsl:text>

		<!-- If there is a textual note, add the appropriate material. -->
		<xsl:if test='tei:note[@type="textual"]'>
		  <h4>Textual History</h4>
		  <xsl:comment>Textual Information and History Here</xsl:comment>
		  <!--	      <xsl:apply-templates select='tei:note[@type="textual"]' /> -->
		  <xsl:call-template name='textualNote' />
		</xsl:if>

		<!-- If there are any toggles, add 'em -->
		<xsl:comment>Toggles for notes, apparatus, etc.</xsl:comment>
		<xsl:text>&#10;</xsl:text>
		<xsl:if test="./descendant::tei:note[@type='editorial'] or ./descendant::tei:app">
		  <div class='toggles'>
		    <h4>Notes</h4><xsl:text>&#10;</xsl:text>
		    <form><xsl:text>&#10;</xsl:text>
		    <ul>
		      <!--	  <div class="toggle"><input type="checkbox"><xsl:attribute name="id"><xsl:value-of select="$poemid" />_textualApparatusCheckBox</xsl:attribute>Textual Apparatus</input></div><xsl:text>&#10;</xsl:text> -->

		      <!-- If a poem has any editorial notes, create a box to activate 'em. -->
		      <xsl:choose>
			<xsl:when test="./descendant::tei:note[@type='editorial']">
			  <li>
			    <div class="toggle">
			      <input type="checkbox">
				<xsl:attribute name="id"><xsl:value-of select="$poemid" />_editorialNotesCheckBox</xsl:attribute>
				Editorial Notes <a href='#' class='help' data-toggle='tooltip' title="Check this box to view editorial annotations.">?</a>
			      </input>
			    </div>
			    <xsl:text>&#10;</xsl:text>
			  </li>
			</xsl:when>
			<xsl:otherwise><!-- <p>This poem has no editorial notes.</p><xsl:text>&#10;</xsl:text> --></xsl:otherwise>
		      </xsl:choose>

		      <xsl:choose>
			<xsl:when test="./descendant::tei:app">
			  <li>
			    <div class="toggle">
			      <input type="checkbox">
				<xsl:attribute name="id">highlightVariants</xsl:attribute>
				Highlight Variants <a href='#' class='help' data-toggle='tooltip' title="Check this box to highlight words with variant forms; click on the highlighted words to cycle through the variants.">?</a>
			      </input>
			    </div>
			    <xsl:text>&#10;</xsl:text>
			  </li>
			</xsl:when>
			<xsl:otherwise><!--  <p>This poem has no textual variants.</p> --></xsl:otherwise>
		      </xsl:choose>
		    </ul>
		    </form>
		    <xsl:text>&#10;</xsl:text>
		  </div>
		</xsl:if>

		<!-- If a poem has any references in reviews/supplementary material, add 'em
		     here. -->
		<xsl:comment>Incoming references from reviews and supplementary material.</xsl:comment>
		<xsl:if test="//tei:text[@type='review']//tei:ref[@target=concat('#',$poemid)] |
			      //tei:text[@type='supplementary']//tei:ref[@target=concat('#',$poemid)] |
			      //tei:text[@type='review']//tei:quote[@source=concat('#',$poemid)] |
			      //tei:text[@type='supplementary']//tei:quote[@source=concat('#',$poemid)]">

		  <div class='incoming-references'>
		    <h4>References to Poem <a href='#' class='help' data-toggle='tooltip' title='These links will take to you reviews and other places where this poem is mentioned or quoted.'>?</a></h4>
		    <ul>
		      <xsl:for-each select="//tei:text[@type='review']//tei:ref/@target |
					    //tei:text[@type='supplementary']//tei:ref/@target |
					    //tei:text[@type='review']//tei:quote/@source |
					    //tei:text[@type='supplementary']//tei:quote/@source">
			<xsl:variable name="linkID">
			  <xsl:value-of select="generate-id(..)" />
			</xsl:variable>
			<xsl:if test=". = concat('#',$poemid)">
			  <li><xsl:element name='a'>
			    <xsl:attribute name='href'>
			      <xsl:value-of select="concat(concat(ancestor::*[@xml:id][1]/@xml:id, '.html'), concat('#',$linkID))" />
			    </xsl:attribute>
			    <xsl:value-of select="ancestor::tei:text/tei:body/tei:head/tei:title" />
			  </xsl:element></li>
			</xsl:if>
		      </xsl:for-each>
		    </ul>
		  </div>
		</xsl:if>
<!--		<div id="poeticForm">
		  <h4>Form</h4>
		  <xsl:call-template name="poeticform" />
		</div>-->
		<div id="downloads">
		  <h4>Formats</h4>
		  <ul>
		    <li><a href="/pdf/{$poemid}.pdf">PDF</a></li>
		    <li><a href="/text/{$poemid}.txt">Plain Text</a></li>
		    <li><a href="/tei/{$poemid}.tei.xml">TEI</a></li>
		  </ul>
		  <!-- <p>For additional download options, see the <a href="downloads.html">Downloads Page</a>.</p> -->
		</div>
	      </div>
	      
	      <xsl:text>&#10;</xsl:text>

	      <!-- poem -->
	      <xsl:element name="div">
		<xsl:attribute name="class">poem col-sm-8 col-md-5</xsl:attribute>
		<xsl:attribute name="id"><xsl:value-of select="$poemid" /></xsl:attribute>

		<!-- Toggles for individual poem. -->
		<xsl:text>&#10;</xsl:text>
		<xsl:call-template name="poem-title" />
		<div>
		  <ol id='poem-text'>
		    <xsl:apply-templates select="tei:l|tei:lg" />
		  </ol>
		</div>

		<!-- Generate apparatus for notes -->
		<ul>
		  <xsl:attribute name="class">editorialNotes</xsl:attribute>
		  <xsl:attribute name="id"><xsl:value-of select="$poemid" />_editorialNotes</xsl:attribute>
		  <xsl:text>&#10;</xsl:text>
		  <xsl:for-each select=".//tei:note[@type='editorial']">
		    <li>
		      <xsl:attribute name="class">editorialNote</xsl:attribute>
		      <xsl:attribute name="id">
			<xsl:value-of select="ancestor::tei:lg[@type='poem']/@xml:id" />_editorialNote_<xsl:value-of select="count(preceding::tei:note)" />
		      </xsl:attribute>
		      <span class='list-number'><xsl:number count="tei:note[@type='editorial']" from="tei:lg[@type='poem']" level="any" /></span><xsl:text>: </xsl:text>
		      <xsl:apply-templates />
		      </li><xsl:text>&#10;</xsl:text>
		  </xsl:for-each>
		  </ul><xsl:text>&#10;</xsl:text>
	      </xsl:element>

	  <!-- Div for Table of Contents. -->
	  <xsl:call-template name="tableOfContents" />

	  <!-- Load Javascript and jQuery. -->
	  <xsl:call-template name="JSIncludes" />

	</body>
</html>
</xsl:result-document>
</xsl:template>


<!-- This will silence the textual note when it occurs in its order. -->
<xsl:template match="tei:note[@type='textual']"></xsl:template>

<!-- And this will let us insert it at the appropriate moment by calling it explicitly.
     This note takes advantage of the cheat according to which named 
     templates called with call-template inhereit the node position of 
     the calling function. -->
<xsl:template name='textualNote'>
  <xsl:element name="div">
    <xsl:attribute name="class">textualNote</xsl:attribute>

    <xsl:for-each select='child::tei:note[@type="textual"]'>
      <xsl:apply-templates />
    </xsl:for-each>
  </xsl:element>
</xsl:template>

<!-- A note to give information/links on poetic form. -->
<xsl:template name="poeticsNote">
</xsl:template>

<xsl:template match="tei:lg[@type='poem']/tei:lg">
  <div class="linegroup">
    <xsl:apply-templates />
  </div>
</xsl:template>

<xsl:template match="tei:lg/tei:lg/tei:head" priority="10">
  <h2><xsl:apply-templates /></h2>
</xsl:template>

<xsl:template name="poem-title">
  <xsl:apply-templates select="tei:head" />
</xsl:template>

<xsl:template match="tei:lg[@type='poem']/tei:head" priority="4">
  <h1><xsl:apply-templates /></h1>
</xsl:template>

<xsl:template match="tei:lg[@type='poem']/tei:head[@type='dedication']" priority="5">
  <h3><xsl:apply-templates /></h3>
</xsl:template>

<xsl:template match="tei:l">
  <xsl:variable name="lineNumber">
    <xsl:choose>
      <xsl:when test="parent::tei:lg[@type='poem']">
	<xsl:value-of select="count(preceding-sibling::tei:l)+1" />
      </xsl:when>
      <xsl:otherwise> 
	<xsl:value-of select="count(preceding-sibling::tei:l)+count(../preceding-sibling::tei:lg/tei:l)+1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <li><p class='verse-container'>

    <!-- This span contains the poetic line itself -->
    <xsl:element name="span"> <xsl:attribute name="class">poetic-line <xsl:for-each select="@*"> <xsl:value-of select="." /> </xsl:for-each> </xsl:attribute>
    <xsl:apply-templates />
    </xsl:element>
    <!-- Here ends the template which grabs the poetic line itself -->
  </p></li>
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
    <xsl:attribute name="class">reading lemma <xsl:value-of select='normalize-space(replace(@wit,"#",""))' /></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select="ancestor::tei:lg[@type='poem']/@xml:id" />_lemma_<xsl:value-of select="count(preceding::tei:lem)" /></xsl:attribute>
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
    <xsl:attribute name="class">reading <xsl:value-of select='normalize-space(replace(@wit,"#",""))' /></xsl:attribute>
    <!--
	<xsl:attribute name="id">
	<xsl:value-of select="ancestor::tei:lg[@type='poem']/@xml:id" />_app<xsl:value-of select="count(../preceding::tei:app)" />_rdg<xsl:value-of select="count(preceding::tei:rdg)" /> 
	</xsl:attribute>
    -->
    <!--      <xsl:value-of select="." /><xsl:text></xsl:text><xsl:apply-templates select="@wit" /> -->
    <xsl:apply-templates /><xsl:text></xsl:text><xsl:apply-templates select="@wit" />
  </xsl:element>
</xsl:template>


<!-- Probably the ugliest bit of this code. Creates a sort of ad-hoc -->
<!-- sigla, not for each *witness*, but for each major work. This    -->
<!-- adhoc sigla in turn is used in the textual apparatus, to avoid  -->
<!-- having to output the full title / bibl. -->
<xsl:template match="tei:lg/tei:head/tei:note[@type='textual']//tei:ref">
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


<!-- Front Matter Template -->
<xsl:template match="tei:front">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="tei:div[@type='contents']">
</xsl:template>
<xsl:template match="tei:div[@type='contents']//tei:ref">
</xsl:template>

<!-- Introduction/Preface/Etc ;; Prose Materials -->
<xsl:template match="tei:div[@type='introductory-prose']">
  <xsl:variable name="id"><xsl:value-of select="@xml:id" /></xsl:variable>
  <xsl:result-document method="html" version="5.0" href="harlem-shadows/{$id}.html">
    <!-- HTML HEADER. -->
    <html>
      <head>
	<xsl:call-template name="htmlHeader" />
	<title>Harlem Shadows: <xsl:value-of select="tei:head" /></title>

	<xsl:call-template name="analytics" />
      </head>

      <body>
	<xsl:call-template name="header" />

	<!-- Container divs for content. -->
	<div class="col-sm-7 col-md-6">
	  <!-- Div for Central Content. -->
	  <xsl:element name="div">
	    <xsl:attribute name="class">prose</xsl:attribute>
	    <xsl:attribute name="id"><xsl:value-of select="@xml:id" /></xsl:attribute>
	    <xsl:apply-templates />
	  </xsl:element>
	</div>
	
	<!-- Div for Table of Contents. -->
	<xsl:call-template name="tableOfContents" />
      </body>
    </html>
  </xsl:result-document>
</xsl:template>

<xsl:template match="tei:p">
  <p><xsl:apply-templates /></p>
</xsl:template>

<xsl:template match="tei:closer">
  <br />
  <p class="closer"><xsl:apply-templates /></p>
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

<!-- Silence page breaks. -->
<xsl:template match="tei:pb"></xsl:template>

<!-- This template inserts footnote markers within the text -->
<xsl:template match="tei:note[@type='editorial']" priority='4'><xsl:element name="sup">
  <xsl:attribute name="class">footnote <xsl:value-of select="ancestor::tei:lg[@type='poem']/@xml:id|ancestor::tei:text/@xml:id" />_editorialNotesFn</xsl:attribute>
  <xsl:attribute name="id"><xsl:value-of select="ancestor::tei:lg[@type='poem']/@xml:id" />_fn<xsl:number count="tei:note[@type='editorial']" from="tei:lg[@type='poem']" level="any" /></xsl:attribute><xsl:number count="tei:note[@type='editorial']" from="tei:lg[@type='poem']" level="any" />
</xsl:element>
</xsl:template>

<!-- Templates for secondary material: contemporary reviews. -->
<!-- This groups supplementary material in here too. -->
<xsl:template match="tei:text[@type='review'] | tei:text[@type='supplementary']">
  <xsl:variable name="id"><xsl:value-of select="@xml:id" /></xsl:variable>

  <xsl:result-document method="html" version="5.0" href="harlem-shadows/{$id}.html">
    
    <html>
      <head>
	<xsl:call-template name="htmlHeader" />
	<title>Harlem Shadows: <xsl:value-of select="tei:body/tei:head/tei:title" /></title>

	<xsl:call-template name="analytics" />
      </head>

      <body>
	<xsl:call-template name="header" />

	<!-- Container divs for content. -->
	<!-- Div for Central Content. -->
	<div class='col-sm-7 col-md-7'>
	  <xsl:element name="div">
	    <xsl:attribute name="class">prose review</xsl:attribute>
	    <xsl:attribute name="id"><xsl:value-of select="@xml:id" /></xsl:attribute>
	    <xsl:apply-templates />
	  </xsl:element>
	  
	  <!-- We now do not call apply-tempaltes for all templates, otherwise we'll -->
	  <!-- output stuff we don't want; just the bibl for the citation. -->
	  <div class='citation'>
	    <h4>Citation</h4>
	    <xsl:apply-templates select="tei:body/tei:head/tei:bibl" />
	  </div>

	  <div class='information'>
	    <xsl:if test='tei:body/tei:head/tei:note[@type="source"]'>
	      <h4>Source</h4>
	      <xsl:comment>Information about Source of This Text</xsl:comment>
	      <xsl:for-each select='tei:body/tei:head/tei:note[@type="source"]'>
		<xsl:apply-templates />
	      </xsl:for-each>
	    </xsl:if>
	    <xsl:if test='tei:body/tei:head/tei:note[@type="editorial"]'>
	      <h4>Note</h4>
	      <xsl:for-each select='tei:body/tei:head/tei:note[@type="editorial"]'>
		<xsl:apply-templates />
	      </xsl:for-each>
	    </xsl:if>
	  </div>
	</div>

	<xsl:text>&#10;</xsl:text>
	<!-- Div for Table of Contents. -->
	<xsl:call-template name="tableOfContents" />
	<xsl:text>&#10;</xsl:text>
      </body>
    </html>
  </xsl:result-document>
</xsl:template>

<!-- Template to create bibliographic entries for prose. 
     <xsl:template match="tei:text[@type='review']/tei:body/tei:head/tei:bibl|tei:text[@type='supplementary']/tei:body/tei:head/tei:bibl">
     <div class='textualNote'>
     <xsl:apply-templates />
     </div>
     </xsl:template>
-->
<!-- This template generates per-review titles with author name. -->
<!-- HACK: Also grabs supplementary material and handles them the same way. -->
<xsl:template match="tei:text[@type='review']/tei:body/tei:head|tei:text[@type='supplementary']/tei:body/tei:head">

  <h2 class="review-title"><xsl:apply-templates select="tei:bibl/tei:title[1]" /></h2>
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

<xsl:template match="tei:bibl/tei:title[@level='j']" priority='2'>
  <em><xsl:apply-templates /></em> 
</xsl:template>

<xsl:template match="tei:bibl/tei:title[@level='j' and @type='main']" priority='3'>
  <em><xsl:value-of select="." />: </em>
</xsl:template>

<xsl:template match="tei:bibl/tei:title[@level='j' and @type='sub']" priority='3'>
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
  <span class='quotation'>
    <xsl:apply-templates />
  </span>
</xsl:template>

<xsl:template name="add-source-link">
  <xsl:if test="../@source">
    <span class='source'>
      [<xsl:element name="a"><xsl:attribute name="id"><xsl:value-of select="generate-id()" /></xsl:attribute><xsl:attribute name="href"><xsl:value-of select="concat(substring-after(../@source,'#'),'.html')" /></xsl:attribute>source</xsl:element>]</span>
  </xsl:if>

</xsl:template>

<!-- These rules handle poems quoted within some other context
     (usually prose: reviews, etc). These templates are necessary 
     to prevent the main poem template being triggered, which writes 
     out to a new file. We give them a high priority.
-->

<xsl:template match="tei:quote/tei:lg" priority="9">
  <span class="quoted-lg">
    <xsl:apply-templates />
    <xsl:call-template name="add-source-link" />
  </span>
</xsl:template>

<xsl:template match="tei:quote/tei:lg[@type='poem']/tei:head" priority='6'>
  <span class='quoted-poem-title'><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="tei:quote/tei:lg/tei:lg" priority="9">
  <span class='quoted-poem-stanza'><xsl:apply-templates /></span>
</xsl:template>

<!-- Template to match all lines of poetry in quotes. -->
<xsl:template match="tei:quote/tei:lg/tei:l|tei:quote/tei:lg/tei:lg/tei:l" priority="9">
  <span class="quoted-poetry"><xsl:apply-templates /></span>
</xsl:template>

<!-- Template for resolving choice elements -->
<!-- For now, when there is a choice between: -->
<!-- a sic and a corr -->
<!-- or an abbreviation and an expansion -->
<!-- it chooses the latter. --> 
<xsl:template match="tei:choice">
  <xsl:apply-templates select="tei:corr|tei:reg" />
</xsl:template>

<!-- Template to silence errors. TODO [Awaiting a better solution; 
     perhaps a simple span that can be styled to mark/differentiate 
     the error from the editorial correction. -->
<xsl:template match="tei:sic">
  <span class='sic'><xsl:apply-templates />[SIC]</span>
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
    <xsl:attribute name="id"><xsl:value-of select="generate-id()" /></xsl:attribute>
    <xsl:attribute name="href">
      <!-- This choice treats internal ref links differently than outgoing links. -->
      <xsl:choose>
	<xsl:when test="starts-with(@target, '#')">
	  <xsl:value-of select="concat(substring-after(@target,'#'),'.html')" />
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="@target" />
	</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:apply-templates />
  </xsl:element>
</xsl:template>

<xsl:template match="tei:note[@type='textual']//tei:ptr">
  <xsl:element name="a">
    <xsl:attribute name="class">textualWitness</xsl:attribute>
    <xsl:attribute name="href">#</xsl:attribute>
    <xsl:attribute name='id'>
      <xsl:value-of select="substring-after(@target,'#')" />
    </xsl:attribute>

    <xsl:call-template name='shortCitation' />
  </xsl:element>
  [<xsl:apply-templates select="@target" />]

  <xsl:call-template name='fullCitation' />
</xsl:template>

<xsl:template match="tei:ref[@type='weblink']">
  <xsl:element name="a">
    <xsl:attribute name="class">weblink</xsl:attribute>
    <xsl:attribute name="href"><xsl:value-of select="@target" /></xsl:attribute>
    <xsl:apply-templates />
  </xsl:element>
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
  <xsl:if test="contains(., '#Crusader')"><span class="sigla">◊</span> </xsl:if>
</xsl:template>

<xsl:template name="header">
  <nav class="navbar" id="header">
    <a href='http://harlemshadows.org'><h1><span class='firstPart'>Harlem Shadows</span>: An Electronic Edition</h1></a>
  </nav>
</xsl:template>

<xsl:template name='htmlHeader'>
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <xsl:call-template name="dublinCore" /> 
  <!-- Bootstrap -->
  <!-- Latest compiled and minified CSS -->
  <!-- <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" /> -->
  <link rel="stylesheet" href="hsbs/css/bootstrap.min.css" /> 
  <!-- Optional theme -->
  <!--  <link rel="stylesheet" href="bootstrap/css/bootstrap-theme.min.css" /> -->

  <link rel="stylesheet" href="hs-bootstrap.css"  />
  
  <link href='https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,700' rel='stylesheet' type='text/css' />
  <link href='http://fonts.googleapis.com/css?family=Open+Sans+Condensed:300' rel='stylesheet' type='text/css' />
  <link href='http://fonts.googleapis.com/css?family=EB+Garamond' rel='stylesheet' type='text/css' />
</xsl:template>

<xsl:template name="dublinCore">
  <xsl:choose>
    <!-- For Eastman's Introduction. -->
    <xsl:when test="@xml:id='introduction'">
      <xsl:element name="meta"><xsl:attribute name="name">DC.title</xsl:attribute><xsl:attribute name="content">Introduction [Harlem Shadows]</xsl:attribute></xsl:element>
      <xsl:element name="meta"><xsl:attribute name="name">DC.creator</xsl:attribute><xsl:attribute name="content">Eastman, Max</xsl:attribute></xsl:element>
      <xsl:element name="meta"><xsl:attribute name="name">DC.date</xsl:attribute><xsl:attribute name="content">1922</xsl:attribute></xsl:element>
      <xsl:element name="meta"><xsl:attribute name="name">DC.identifier</xsl:attribute><xsl:attribute name="content">http://harlemshadows.org/introduction.html</xsl:attribute></xsl:element>
    </xsl:when>
    <!-- For McKay's Author's Word. -->
    <xsl:when test="@xml:id='authors-word'">
      <xsl:element name="meta"><xsl:attribute name="name">DC.title</xsl:attribute><xsl:attribute name="content">Author's Word [Harlem Shadows]</xsl:attribute></xsl:element>
      <xsl:element name="meta"><xsl:attribute name="name">DC.creator</xsl:attribute><xsl:attribute name="content">McKay, Claude</xsl:attribute></xsl:element>
      <xsl:element name="meta"><xsl:attribute name="name">DC.date</xsl:attribute><xsl:attribute name="content">1922</xsl:attribute></xsl:element>
      <xsl:element name="meta"><xsl:attribute name="name">DC.identifier</xsl:attribute><xsl:attribute name="content">http://harlemshadows.org/authors-word.html</xsl:attribute></xsl:element>
    </xsl:when>
    <!-- For Harlem Shadows Poems. -->
    <xsl:when test="ancestor::tei:text[@xml:id='hs']">
      <xsl:element name="meta"><xsl:attribute name="name">DC.title</xsl:attribute>
      <xsl:attribute name="content">
	<xsl:value-of select="normalize-space((tei:head/text())[1])" />
      </xsl:attribute></xsl:element>
      <xsl:element name="meta"><xsl:attribute name="name">DC.creator</xsl:attribute><xsl:attribute name="content">McKay, Claude</xsl:attribute></xsl:element>
      <xsl:element name="meta"><xsl:attribute name="name">DC.date</xsl:attribute><xsl:attribute name="content">1922</xsl:attribute></xsl:element>
      <xsl:element name="meta"><xsl:attribute name="name">DC.identifier</xsl:attribute><xsl:attribute name="content">http://harlemshadows.org/<xsl:value-of select="@xml:id" />.html</xsl:attribute></xsl:element>
    </xsl:when>
    <!-- For Secondary Material: Reviews, Supplementary, etc. -->
    <xsl:otherwise>
      <xsl:element name="meta"><xsl:attribute name="name">DC.title</xsl:attribute><xsl:attribute name="content"><xsl:value-of select="tei:body/tei:head/tei:bibl/tei:title[1]/text()" /></xsl:attribute></xsl:element>
      <xsl:element name="meta"><xsl:attribute name="name">DC.creator</xsl:attribute><xsl:attribute name="content"><xsl:value-of select="string-join(tei:body/tei:head/tei:bibl/tei:author/tei:persName/tei:surname, ' ')" />, <xsl:value-of select="string-join(tei:body/tei:head/tei:bibl/tei:author/tei:persName/tei:forename, ' ')" /></xsl:attribute></xsl:element>
      <xsl:element name="meta"><xsl:attribute name="name">DC.date</xsl:attribute><xsl:attribute name="content"><xsl:value-of select="tei:body/tei:head/tei:bibl/tei:date/@when" /></xsl:attribute></xsl:element>
      <xsl:element name="meta"><xsl:attribute name="name">DC.identifier</xsl:attribute><xsl:attribute name="content">http://harlemshadows.org/<xsl:value-of select="@xml:id" />.html</xsl:attribute></xsl:element>
    </xsl:otherwise>
  </xsl:choose>
  <meta name="DC.publisher" content="Harlem Shadows: Digital Edition" />
</xsl:template>

<!-- Google Analytics -->
<xsl:template name='analytics'>
  <script>
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

    ga('create', 'UA-55463139-1', 'auto');
    ga('send', 'pageview');
  </script>
</xsl:template>

<!-- This function converts witness bibliographic information into a 
     formatted full citation. N.B.: It takes advantage of the fact 
     that the context node of templates called by name remains the 
     same, so that we have the information we need ready-to-hand in 
     the target attribute.
-->
<xsl:template name='fullCitation'>
  <xsl:variable name='biblID'><xsl:value-of select='substring-after(@target,"#")' /></xsl:variable>
  <span class='fullBiblioEntry'>
    <xsl:attribute name='id'>full_bibl<xsl:value-of select='$biblID' /></xsl:attribute>
    <xsl:apply-templates select='/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listWit/tei:witness[@xml:id=$biblID]' />
  </span>
</xsl:template>

<xsl:template name='shortCitation'>
  <xsl:variable name='biblID'><xsl:value-of select='substring-after(@target,"#")' /></xsl:variable>
  <span class='shortBiblioEntry'>
    <xsl:attribute name='id'>short_bibl<xsl:value-of select='$biblID' /></xsl:attribute>
    <xsl:apply-templates select='/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listWit/tei:witness[@xml:id=$biblID]/tei:bibl/tei:title' />
    <xsl:apply-templates select='/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listWit/tei:witness[@xml:id=$biblID]/tei:biblStruct/tei:monogr/tei:title' />
    <xsl:text> </xsl:text>
    <xsl:apply-templates select='/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listWit/tei:witness[@xml:id=$biblID]/tei:bibl/tei:date|
				 /tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listWit/tei:witness[@xml:id=$biblID]/tei:biblStruct/tei:monogr//tei:date' />
  </span>
</xsl:template>


<xsl:template match='tei:witness'>
  <xsl:apply-templates />
</xsl:template>

<xsl:template name='today'>
  <xsl:value-of select="format-date(current-date(), '[MNn] [D1], [Y]')" />
</xsl:template>

<!-- This Template ensures that supplementary texts which consist only of a poem get processed.  -->
<xsl:template match="tei:text[@type='supplementary']/tei:body/tei:lg[@type='poem']" priority="1">
  <ol id='poem-text'>
    <xsl:apply-templates select="tei:l|tei:lg" />
  </ol>
</xsl:template>


<!-- Rules for citations, cit, which group a quote and bibl. -->
<xsl:template match="tei:cit">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="tei:cit/tei:bibl">
</xsl:template>


<!-- Linkback Templates: These templates create anchors within secondary
     literature and a list of links. -->
<!--  <xsl:template match="tei:text[@type='review']//tei:ref |
     tei:text[@type='supplementary']//tei:ref |
     tei:text[@type='review']//tei:quote |
     tei:text[@type='supplementary']//tei:ref">
     </xsl:template>
-->


</xsl:stylesheet>
