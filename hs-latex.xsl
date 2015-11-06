<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="tei"
		version="2.0">

  <xsl:output method="text" encoding="utf-8" />

  <xsl:strip-space elements="tei:head tei:app tei:pb tei:bibl" />
  <xsl:preserve-space elements="tei:lem tei:p tei:ref" />

  <xsl:template name="header">
\documentclass[12pt,english]{memoir}
\usepackage[a4paper]{geometry}

\usepackage{fontspec}

% For headers
\makepagestyle{hs}
\makeevenhead{hs}{\textsf{\footnotesize \textsc{Harlem Shadows: An Electronic Edition}} \\ {\scriptsize &lt;\url{http://harlemshadows.org}&gt;}}{}{}
\makeoddhead{hs}{}{}{\textsf{\footnotesize \textsc{Harlem Shadows: An Electronic Edition}} \\ {\scriptsize &lt;\url{http://harlemshadows.org}&gt;}}
\makeevenfoot{hs}{\thepage}{}{}
\makeoddfoot{hs}{}{}{\thepage}
\makeheadrule{hs}{\textwidth}{\normalrulethickness}

% For compact lists
\usepackage{mdwlist}

% To adjust
\usepackage[hang]{footmisc}
\setlength\footnotemargin{10pt}

% To center sections
%\usepackage{sectsty}
%\sectionfont{\centering}
%\subsectionfont{\centering}

% csquotes package ensures pretty, curly quotation marks 
% with the straight marks that are encoded in the TEI source.
\usepackage[autostyle]{csquotes}
\MakeOuterQuote{"}

% We'll use columns for our notes.
\usepackage{multicol}

% For representation of poetry we use the verse package, and redefine
% some rules.
\usepackage{verse}
%\renewcommand{\poemtitlefont}{\normalfont\bfseries\large\raggedright}
\renewcommand{\poemtitlefont}{\normalfont\bfseries\large}

%\setlength{\vleftmargin}{0pt}

%\newcommand{\authortitle}[2]{\poemtitle{#1} #2 \par}
%\newcommand{\authortitle}[2]{\noindent\hspace{\vleftmargin}{\poemtitlefont #1} \par \noindent\hspace{\vleftmargin}#2}
\newcommand{\authortitle}[2]{\noindent{\poemtitlefont #1} \par \noindent#2}


\newcommand{\prosetitlefont}{\normalfont\bfseries\large\raggedright}
    
% For URLS; loaded last to prevent conflicts.
\usepackage{hyperref}

% Font stuff
\setromanfont[Mapping=tex-text,Numbers=OldStyle]{Linux Libertine O} 
\setsansfont[Mapping=tex-text,Numbers=OldStyle]{Linux Biolinum O} 

\IfFileExists{microtype.sty}{\usepackage{microtype}}{}

% Remove Section Numbers
\setcounter{secnumdepth}{0}

% Custom Fonts
\newfontfamily\sans{Linux Biolinum O}

% Some Custom Environments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{textualnote}{\sans \small \setlength{\parindent}{0cm} \setlength{\parskip}{0.5em}}{\par}
%\newenvironment{mlacitation}{\setlength{\leftskip}{0.4\textwidth} \footnotesize \par \noindent\ignorespaces\begin{hangparas}{3em}{-1}}{\end{hangparas}\par}
\newenvironment{mlacitation}{\setlength{\leftskip}{0.4\textwidth} \footnotesize \vspace{2em} \begin{hangparas}{3em}{1}}{\end{hangparas}\par}

% An include command
\newcommand{\myinclude}[1]{\clearpage\input{#1}\clearpage}

% Custom Commands %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For Listing Author
\newcommand{\poemauthor}[1]{
{\raggedright \noindent #1}
\vspace{1em}}
\setlength{\afterpoemtitleskip}{0em}

\pagestyle{hs}
  </xsl:template>

  <xsl:key name="witnessTitles" match="//tei:witness" use="@xml:id" />

  <xsl:template match="tei:TEI">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template name="tableOfContents"></xsl:template>

  <!-- Silences TEI Header -->
  <xsl:template match="tei:teiHeader"></xsl:template>

  <!-- These templates silence other aspects of the titleStmt that we -->
  <xsl:template match="tei:titleStmt/tei:author"></xsl:template>
  <xsl:template match="tei:titleStmt/tei:principal"></xsl:template>
  <xsl:template match="tei:publicationStmt"></xsl:template>
  <xsl:template match="tei:sourceDesc"></xsl:template>


  <!-- Output template for poems by McKay -->
  <xsl:template match="tei:text[@xml:id='hs']//tei:lg[@type='poem'] |
		       tei:group[@xml:id='mckay_additional-poems']//tei:lg[@type='poem']">
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
    <xsl:result-document method="text" href="latex/{$poemid}.tex">
      <xsl:call-template name="header" />

      <xsl:choose>
	<xsl:when test="../../tei:text[@xml:id='hs']">\title{<xsl:value-of select="tei:head" />}</xsl:when>
	<xsl:otherwise>\title{<xsl:value-of select="../tei:head/tei:title" />}</xsl:otherwise>
      </xsl:choose>

      \begin{document}

      <xsl:call-template name="titleblock" />

      <xsl:call-template name="poem" />
      
      <!-- Output notes. -->
      <xsl:if test="tei:note[@type='textual']">
	<xsl:call-template name="textualNote" />
      </xsl:if>

      <!-- Editorial Notes. -->
      <xsl:if test=".//tei:note[@type='editorial']">
	<xsl:call-template name="editorialNotes"/>
      </xsl:if>

      <!-- Output Citation. -->
      <xsl:apply-templates select="../tei:head/tei:bibl" />
      
      \end{document}
    </xsl:result-document>
  </xsl:template>

  <xsl:template name="poem">
    \begin{verse}

    <!-- This choice is for whether there are nested lgs within the main 
	 poem lg. -->
    <xsl:choose>
      <xsl:when test="not(tei:lg)">
	<xsl:call-template name="stanza" />
      </xsl:when>
      <xsl:otherwise>
	<xsl:for-each select="tei:lg">
	  <xsl:call-template name="stanza" />
	</xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
    \end{verse}
  </xsl:template>
  
  <xsl:template name="stanza">
    \begin{patverse}
    <xsl:call-template name="indentation" /><xsl:apply-templates select="tei:l" />
    \end{patverse}
  </xsl:template>

  <xsl:template name="titleblock">
    <xsl:apply-templates select="tei:head" />
  </xsl:template>
  
  <!-- This will silence the textual note when it occurs in its order. -->
  <xsl:template match="tei:note[@type='textual']"></xsl:template>

  <!-- And this will let us insert it at the appropriate moment by calling it explicitly.
       This note takes advantage of the cheat according to which named 
       templates called with call-template inhereit the node position of 
       the calling function. -->
  <xsl:template name='textualNote'>
    \begin{textualnote}
    \noindent {\textbf{Textual Note:}}\par
    <xsl:apply-templates select="tei:note[@type='textual']/*" />
    \end{textualnote}
  </xsl:template>

  <xsl:template match="tei:lg[@type='poem']/tei:lg"><xsl:apply-templates /></xsl:template>

  <xsl:template match="tei:lg/tei:lg/tei:head" priority="10">\poemtitlemark{<xsl:apply-templates />}</xsl:template>

  <!--  <xsl:template match="tei:lg[@type='poem']/tei:head" priority="4">\poemtitle{<xsl:apply-templates />}
       \poemauthor{Claude McKay}
       </xsl:template>
  -->

  <xsl:template match="tei:text[@xml:id='hs']//tei:lg[@type='poem']/tei:head" priority="4">\authortitle{<xsl:apply-templates />}{Claude McKay}</xsl:template>

  <xsl:template match="tei:lg[@type='poem']/tei:head">
    \poemtitle{<xsl:apply-templates />}
    
  </xsl:template>

  <xsl:template match="tei:lg[@type='poem']/tei:head[@type='dedication']" priority="5">
    \emph{<xsl:apply-templates />}
  </xsl:template>

  <xsl:template match="tei:div[@type='introductory-prose']/tei:head">
    \subsection*{<xsl:apply-templates />}
  </xsl:template>

  <xsl:template match="tei:text[@type='review']/tei:body/tei:head|tei:text[@type='supplementary']/tei:body/tei:head">
    \subsection*{<xsl:apply-templates select="tei:title" />}
  </xsl:template>
  
  <!-- For each poetic line, apply-templates and, if it isn't the last line
       in a stanza, use the verse package's line termination macro: // -->
  <xsl:template match="tei:l"><xsl:apply-templates /><xsl:if test="following-sibling::tei:l">\\</xsl:if></xsl:template>

  <!-- This template outputs the text content of poetic lines. -->
  <xsl:template match="tei:l/text()"><xsl:value-of select="." /></xsl:template>

  <xsl:template match="tei:app">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="tei:lem">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="tei:rdg"></xsl:template>

  <!--  <xsl:template match="tei:app//text()"><xsl:value-of select="normalize-space(.)" /></xsl:template> -->

  <xsl:template name="indentation">\indentpattern{<xsl:for-each select=".//tei:l"><xsl:choose>
  <xsl:when test="contains(@rend, 'indent')"><xsl:value-of select='substring-after(@rend, "indent")' /></xsl:when>
  <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose></xsl:for-each>}</xsl:template>
  
  <!-- Span level Templates -->
  <!-- This template matches journal and monograph titles -->
  <xsl:template match="tei:title[@level='j']|tei:title[@level='m']">\emph{<xsl:apply-templates />}</xsl:template>

  <!-- Templates for convert TEI lists into HTML lists -->
  <xsl:template match="tei:list">
    \begin{itemize*}
    <xsl:apply-templates />
    \end{itemize*}
  </xsl:template>

  <xsl:template match="tei:item">
    \item <xsl:apply-templates />
  </xsl:template>


  <!-- Front Matter Template -->
  <xsl:template match="tei:front">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="tei:div[@type='contents']"></xsl:template>
  <xsl:template match="tei:div[@type='contents']//tei:ref"></xsl:template>

  <!-- Output Template for Prose Materials -->
  <xsl:template match="tei:div[@type='introductory-prose'] | tei:text[@type='review'] | tei:text[@type='supplementary']">
    <xsl:variable name="id"><xsl:value-of select="@xml:id" />.tex</xsl:variable>
    <xsl:result-document method="text" href="latex/{$id}">
      <!-- HEADER. -->
      <xsl:call-template name="header" />

      \begin{document}
      
<!--      <xsl:call-template name="titleblock" /> -->
      <xsl:apply-templates />

      <xsl:apply-templates select="tei:body/tei:head/tei:bibl" />
      
      \end{document}
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="tei:text[@type='supplementary']/tei:body/tei:lg[@type='poem']">
    <!-- HACK, for documents which are just single poems. -->
    <xsl:value-of select="../tei:head/tei:bibl/tei:author" />
    <xsl:call-template name="poem" />
  </xsl:template>
  
  <xsl:template match="tei:p">
    <xsl:apply-templates />
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="tei:closer">
    \vspace{1em}
    \begin{flushright}
    {\large \textbf{<xsl:apply-templates />}}
    \end{flushright}
  </xsl:template>

  <!-- Title -->
  <xsl:template match="tei:titlePage"></xsl:template>

  <xsl:template match="tei:titlePart[@type='main']"></xsl:template>

  <xsl:template match="tei:titlePart[@type='sub']"></xsl:template>

  <xsl:template match="tei:titlePart[@type='desc']"></xsl:template>

  <!-- This template matches the half-title page -->
  <xsl:template match="tei:div[@type='half-title']"></xsl:template>

  <!-- Front matter -->
  <xsl:template match="tei:div[@type='frontmatter']"></xsl:template>

  <!-- Elements with rend attributes -->
  <xsl:template match="tei:*[@rend='italics']">\emph{<xsl:apply-templates />}</xsl:template>
  <xsl:template match="tei:*[@rend='bold']">\textbf{<xsl:apply-templates />}</xsl:template>

  <!-- Line breaks marked in TEI. -->
  <xsl:template match="tei:lb"><xsl:text>&#xd;&#xd;</xsl:text></xsl:template>

  <!-- Silence page breaks. -->
  <xsl:template match="tei:pb"></xsl:template>

  <!-- Editorial footnotes, in two steps. -->
  <!-- Add footnote number at location of note. -->
  <xsl:template match="tei:note[@type='editorial']" priority='4'>\protect\footnotemark</xsl:template>

  <!-- Generate actual notes. -->
  <xsl:template name="editorialNotes">
    % Footnotes
    \setcounter{footnote}{0}
    <xsl:for-each select=".//tei:note[@type='editorial']">
      \stepcounter{footnote}
      \footnotetext{<xsl:apply-templates />}
    </xsl:for-each>
  </xsl:template>

  <!-- The following templates format bibliographical info from bibl into an MLA -->
  <!-- style citation. -->
  <xsl:template match="tei:bibl">
    \begin{mlacitation}
    <xsl:apply-templates select="tei:author" />
    <xsl:apply-templates select="tei:title" /><xsl:text> </xsl:text>
    <xsl:apply-templates select="tei:biblScope[@unit='vol']" />
    <xsl:apply-templates select="tei:biblScope[@unit='no']" />
    <xsl:apply-templates select="tei:date" />: <xsl:apply-templates select="tei:biblScope[@unit='pg']" />
    \end{mlacitation}
  </xsl:template>
  
  <xsl:template match="tei:bibl/tei:author">
    <xsl:apply-templates select="tei:persName/tei:surname" />, <xsl:apply-templates select="tei:persName/tei:forename" />.
  </xsl:template>

  <xsl:template match="tei:persName/tei:forename">
    <xsl:apply-templates /><xsl:if test="position() != last()"><xsl:text> </xsl:text></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:bibl/tei:title[@level='a']">"<xsl:apply-templates />." </xsl:template>

  <xsl:template match="tei:bibl/tei:title[@level='j']" priority='2'>\emph{<xsl:apply-templates />}</xsl:template>

  <xsl:template match="tei:bibl/tei:title[@level='j' and @type='main']" priority='3'>\emph{<xsl:value-of select="." />} </xsl:template>

  <xsl:template match="tei:bibl/tei:title[@level='j' and @type='sub']" priority='3'>\emph<xsl:value-of select="." />}</xsl:template>

  <xsl:template match="tei:bibl/tei:date|tei:biblStruct//tei:date">
    <!-- This choose attempts to identify the string format based
	 solely on length, and then use XSLT datestring formatting.
	 If it isn't 7 chars long (YYYY-MM) or 10 (YYYY-MM-DD) then
	 it falls back to using the node content. -->
    <xsl:text> </xsl:text><!-- Ug, whitespace, amirite? -->
    <xsl:choose>
      <xsl:when test="string-length(@when) = 7">(<xsl:value-of select='format-date(xs:date(concat(@when,"-01")),"[MNn], [Y]", "en", (), ())' />)</xsl:when>
      <xsl:when test="string-length(@when) = 10">(<xsl:value-of select='format-date(@when,"[MNn], [Y]", "en", (), ())' />)</xsl:when>
      <xsl:otherwise>(<xsl:value-of select="." />)</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- For now, we silently omitting place of publication and page References. -->
  <xsl:template match="tei:bibl/tei:pubPlace"></xsl:template>
  <xsl:template match="tei:bibl/tei:biblScope">
    <xsl:choose>
      <xsl:when test="@unit='vol'"><xsl:apply-templates />.</xsl:when>
      <xsl:when test="@unit='no'"><xsl:apply-templates /> </xsl:when>
      <xsl:when test="@unit='pg'"><xsl:apply-templates />. </xsl:when>
      <xsl:otherwise><xsl:apply-templates /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:p/tei:note">\footnote{<xsl:apply-templates /></xsl:template>

  <!-- Template for quoted material, including poems, particularly in reviews. -->
  <xsl:template match="tei:quote">
    \begin{quote}
    <xsl:apply-templates />
    \end{quote}
  </xsl:template>


  <xsl:template match="tei:ptr">
    <xsl:variable name='biblID'><xsl:value-of select='substring-after(@target,"#")' /></xsl:variable>

    <xsl:apply-templates select='/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listWit/tei:witness[@xml:id=$biblID]/tei:bibl/tei:title |
				 /tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listWit/tei:witness[@xml:id=$biblID]/tei:biblStruct/tei:monogr/tei:title' />
    <xsl:text> </xsl:text>
    <xsl:apply-templates select='/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listWit/tei:witness[@xml:id=$biblID]/tei:bibl/tei:date|
				 /tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:listWit/tei:witness[@xml:id=$biblID]/tei:biblStruct/tei:monogr//tei:date' />
  </xsl:template>
  
  <!-- Template for resolving choice elements -->
  <!-- For now, when there is a choice between: -->
  <!-- a sic and a corr -->
  <!-- or an abbreviation and an expansion -->
  <!-- it chooses the latter. --> 
  <xsl:template match="tei:choice">
    <xsl:apply-templates select="tei:corr|tei:abbr" />
  </xsl:template>

  <!-- Template to silence errors. TODO [Awaiting a better solution; 
       perhaps a simple span that can be styled to mark/differentiate 
       the error from the editorial correction. -->
  <xsl:template match="tei:sic"><xsl:apply-templates /> [\emph{sic}]</xsl:template>

  <!-- Here we handle abbreviations. If type is initial, we add a period. -->
  <!-- Otherwise, this is just a passthrough. -->
  <xsl:template match="tei:abbr"><xsl:apply-templates /><xsl:if test="@type='initial'">.</xsl:if></xsl:template>

  <!-- Rules for making refs into links where appropriate. -->
  <xsl:template match="tei:ref"><xsl:apply-templates /></xsl:template>
  <xsl:template match="tei:ref[@type='weblink']">\href{<xsl:value-of select="@target" />}{<xsl:apply-templates />} \texttt{&lt;<xsl:value-of select="@target" />&gt;}</xsl:template>

  <xsl:template match='tei:witness'></xsl:template>

  <!-- Rules for citations, cit, which group a quote and bibl. -->
  <xsl:template match="tei:cit">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="tei:cit/tei:bibl"></xsl:template>

  <xsl:template match="tei:quote/tei:lg[@type='poem']" priority="9">
    <xsl:call-template name="titleblock" />

    \begin{verse}
    <xsl:choose>
      <xsl:when test="not(tei:lg)">
	<xsl:call-template name="stanza" />
      </xsl:when>
      <xsl:otherwise>
	<xsl:for-each select="tei:lg">
	  <xsl:call-template name="stanza" />
	</xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
    \end{verse}
    
  </xsl:template>

  <!-- To remove superfluous whitespace in paragraphs.
       Particularly an issue with tei:pbs interrupting
       the flow. -->
  <!--  <xsl:template match="tei:p/text()">
       <xsl:value-of select="normalize-space(.)" />
       </xsl:template> -->
  <!-- Template to do simple LaTeX-specific replacements for things like
       abbreviations and similar. -->
  <xsl:template match="text()">
    <xsl:value-of select="replace(
			  replace(
			  replace(., 'Dr.','Dr.\\ ')
			  , 'Mrs.','Mrs.\\ ')
			  , 'Mr.','Mr.\\ ')" />
  </xsl:template>
</xsl:stylesheet>
