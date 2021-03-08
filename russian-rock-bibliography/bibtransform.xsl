<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">
	<xsl:output method="xhtml" indent="yes"/>
	<xsl:template match="/">
		<html lang="en">
			<head>
				<title>English-Language Resources on Russian/Soviet Rock</title>
				<link rel="stylesheet" href="css/styles.css"/>
			</head>
			<body>
				<h1>English-Language Resources on Russian/Soviet Rock</h1>
				<xsl:apply-templates select="//tei:listBibl"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="generateBib" match="tei:listBibl">
		<h2>Books</h2>
		<hr/>
		<h3>Monographs</h3>
		<xsl:apply-templates select="tei:biblStruct[@type = 'book']">
			<xsl:sort select="@xml:id"/>
		</xsl:apply-templates>
		<h3>Edited Collections</h3>
		<xsl:apply-templates select="tei:biblStruct[@type = 'editedCollection']">
			<xsl:sort select="@xml:id"/>
		</xsl:apply-templates>
		<h3>Book Chapters</h3>
		<xsl:apply-templates select="tei:biblStruct[@type = 'bookSection']">
			<xsl:sort select="@xml:id"/>
		</xsl:apply-templates>
		<hr/>
		<h2>Academic Journal Articles</h2>
		<xsl:apply-templates select="tei:biblStruct[@type = 'journalArticle']">
			<xsl:sort select="@xml:id"/>
		</xsl:apply-templates>
		<hr/>
		<h2>Theses and Dissertations</h2>
		<xsl:apply-templates select="tei:biblStruct[@type = 'thesis']">
			<xsl:sort select="@xml:id"/>
		</xsl:apply-templates>
		<hr/>
		<h2>Newspaper/Magazine Articles</h2>
		<xsl:apply-templates
			select="tei:biblStruct[@type = ('magazineArticle', 'newspaperArticle')]">
			<xsl:sort select="@xml:id"/>
		</xsl:apply-templates>
		<hr/>
		<h2>Audio Resources</h2>
		<h3>Podcasts</h3>
		<xsl:apply-templates select="tei:biblStruct[@type = 'podcast']">
			<xsl:sort select="@xml:id"/>
		</xsl:apply-templates>
		<h3>Radio Programs</h3>
		<xsl:apply-templates select="tei:biblStruct[@type = 'radioBroadcast']">
			<xsl:sort select="@xml:id"/>
		</xsl:apply-templates>
		<hr/>
		<h2>Websites</h2>
		<xsl:apply-templates select="tei:biblStruct[@type = 'website']">
			<xsl:sort select="@xml:id"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template name="citeMonograph" match="tei:biblStruct[@type = 'book']">
		<div class="citation-container" id="{@xml:id}">
			<xsl:call-template name="citeBook">
				<xsl:with-param name="monogr" select="tei:monogr"/>
				<xsl:with-param name="primaryContributors" select="tei:monogr/tei:author"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	<xsl:template name="citeEdCollection" match="tei:biblStruct[@type = 'editedCollection']">
		<div class="citation-container" id="{@xml:id}">
			<xsl:call-template name="citeBook">
				<xsl:with-param name="monogr" select="tei:monogr"/>
				<xsl:with-param name="primaryContributors"
					select="tei:monogr/tei:editor[not(@role)]"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	<xsl:template name="citeBook">
		<xsl:param name="monogr" as="node()*"/>
		<xsl:param name="primaryContributors" as="node()*"/>
		<div class="citation">
			<p>
				<xsl:call-template name="contributor-list">
					<xsl:with-param name="contributors" select="$primaryContributors"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$monogr/tei:imprint/tei:date"/>
				<xsl:text>. </xsl:text>
				<span class="mono-title">
					<xsl:value-of select="$monogr/tei:title[@level = 'm']"/>
				</span>
				<xsl:text>. </xsl:text>
				<xsl:call-template name="secondary-contributor-list">
					<xsl:with-param name="contributors"
						select="$monogr/tei:editor[@role = 'translator']"/>
				</xsl:call-template>
				<xsl:call-template name="book-publishing">
					<xsl:with-param name="pubInfo" select="$monogr/tei:imprint"/>
				</xsl:call-template>
			</p>
		</div>
		<xsl:call-template name="access-options">
			<xsl:with-param name="level" select="tei:monogr"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="citeBookChapter" match="tei:biblStruct[@type = 'bookSection']">
		<div class="citation-container" id="{@xml:id}">
			<div class="citation">
				<p>
					<xsl:call-template name="contributor-list">
						<xsl:with-param name="contributors" select="tei:analytic/tei:author"/>
					</xsl:call-template>
					<xsl:text> </xsl:text>
					<xsl:value-of select="tei:monogr/tei:imprint/tei:date"/>
					<xsl:text>. </xsl:text>
					<span class="analytic-title">
						<xsl:text>&#8220;</xsl:text>
						<xsl:value-of select="tei:analytic/tei:title[@level = 'a']"/>
						<xsl:text>.&#8221;</xsl:text>
					</span>
					<xsl:text> In </xsl:text>
					<span class="mono-title">
						<xsl:value-of select="tei:monogr/tei:title"/>
					</span>
					<xsl:text>, </xsl:text>
					<xsl:call-template name="secondary-contributor-list">
						<xsl:with-param name="contributors" select="tei:monogr/tei:editor"/>
					</xsl:call-template>
					<xsl:if test="tei:monogr/tei:imprint/tei:biblScope[@unit = 'page']">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="tei:monogr/tei:imprint/tei:biblScope[@unit = 'page']"
						/>
					</xsl:if>
					<xsl:text>. </xsl:text>
					<xsl:call-template name="book-publishing">
						<xsl:with-param name="pubInfo" select="tei:monogr/tei:imprint"/>
					</xsl:call-template>
				</p>
			</div>
			<xsl:call-template name="access-options">
				<xsl:with-param name="level" select="tei:monogr"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	<xsl:template name="citeJournalArticle" match="tei:biblStruct[@type = 'journalArticle']">
		<div class="citation-container" id="{@xml:id}">
			<div class="citation">
				<p>
					<xsl:call-template name="contributor-list">
						<xsl:with-param name="contributors" select="tei:analytic/tei:author"/>
					</xsl:call-template>
					<xsl:text> </xsl:text>
					<xsl:value-of select="tei:monogr/tei:imprint/tei:date"/>
					<xsl:text>. </xsl:text>
					<span class="analytic-title">
						<xsl:text>&#8220;</xsl:text>
						<xsl:value-of select="tei:analytic/tei:title[@level = 'a']"/>
						<xsl:text>.&#8221;</xsl:text>
					</span>
					<xsl:text> </xsl:text>
					<span class="mono-title">
						<xsl:value-of select="tei:monogr/tei:title"/>
					</span>
					<xsl:text>, </xsl:text>
					<xsl:call-template name="journal-publishing">
						<xsl:with-param name="pubInfo" select="tei:monogr/tei:imprint"/>
					</xsl:call-template>
				</p>
			</div>
			<xsl:call-template name="access-options">
				<xsl:with-param name="level" select="tei:analytic"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	<xsl:template name="citeThesis" match="tei:biblStruct[@type = 'thesis']">
		<div class="citation-container" id="{@xml:id}">
			<div class="citation">
				<p>
					<xsl:call-template name="contributor-list">
						<xsl:with-param name="contributors" select="tei:monogr/tei:author"/>
					</xsl:call-template>
					<xsl:text> </xsl:text>
					<xsl:value-of select="tei:monogr/tei:imprint/tei:date"/>
					<xsl:text>. </xsl:text>
					<span class="analytic-title">
						<xsl:text>&#8220;</xsl:text>
						<xsl:value-of select="tei:monogr/tei:title"/>
						<xsl:text>.&#8221;</xsl:text>
					</span>
					<xsl:text> </xsl:text>
					<xsl:value-of select="./@subtype"/>
					<xsl:text> </xsl:text>
					<xsl:choose>
						<xsl:when test="@subtype = 'PhD'">
							<xsl:text>diss</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>thesis</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>. </xsl:text>
					<xsl:value-of select="tei:monogr/tei:imprint/tei:publisher"/>
					<xsl:text>.</xsl:text>
				</p>
			</div>
			<xsl:call-template name="access-options">
				<xsl:with-param name="level" select="tei:monogr"/>
			</xsl:call-template>
		</div>
	</xsl:template>
	<xsl:template name="citeMagazineArticle"
		match="tei:biblStruct[@type = ('magazineArticle', 'newspaperArticle')]">
		<div class="citation-container" id="{@xml:id}">
			<div class="citation">
				<p>
					<xsl:call-template name="contributor-list">
						<xsl:with-param name="contributors" select="tei:analytic/tei:author"/>
					</xsl:call-template>
					<xsl:text> </xsl:text>
					<xsl:value-of select="tei:monogr/tei:imprint/tei:date"/>
					<xsl:text>. </xsl:text>
					<span class="analytic-title">
						<xsl:text>&#8220;</xsl:text>
						<xsl:value-of select="tei:analytic/tei:title[@level = 'a']"/>
						<xsl:text>.&#8221;</xsl:text>
					</span>
					<xsl:text> </xsl:text>
					<xsl:call-template name="secondary-contributor-list">
						<xsl:with-param name="contributors" select="tei:analytic/tei:editor[@role='interviewee']"/>
					</xsl:call-template>
					<span class="mono-title">
						<xsl:value-of select="tei:monogr/tei:title"/>
					</span>
					<xsl:text>. </xsl:text>
					<xsl:call-template name="link-maker">
						<xsl:with-param name="url"
							select="tei:analytic/tei:idno[@type = 'live-url']"/>
						<xsl:with-param name="displayText"
							select="tei:analytic/tei:idno[@type = 'live-url']"/>
					</xsl:call-template>
				</p>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="citePodcast" match="tei:biblStruct[@type = 'podcast']">
		<div class="citation-container" id="{@xml:id}">
			<xsl:call-template name="citeAudio">
				<xsl:with-param name="biblStruct" select="."/>
			</xsl:call-template>
		</div>
	</xsl:template>
	<xsl:template name="citeRadioProgram" match="tei:biblStruct[@type = 'radioBroadcast']">
		<div class="citation-container" id="{@xml:id}">
			<xsl:call-template name="citeAudio">
				<xsl:with-param name="biblStruct" select="."/>
			</xsl:call-template>
		</div>
	</xsl:template>
	<xsl:template name="citeAudio">
		<xsl:param name="biblStruct" as="node()*"/>
		<div class="citation">
			<p>
				<span class="analytic-title">
					<xsl:text>&#8220;</xsl:text>
					<xsl:value-of select="$biblStruct/tei:monogr/tei:title"/>
					<xsl:text>.&#8221;</xsl:text>
				</span>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$biblStruct/tei:monogr/tei:imprint/tei:date"/>
				<xsl:text>. </xsl:text>
				<xsl:call-template name="secondary-contributor-list">
					<xsl:with-param name="contributors"
						select="$biblStruct/tei:monogr/tei:editor[@role='interviewee']"/>
				</xsl:call-template>
				<xsl:value-of select="$biblStruct/tei:series/tei:title"/>
				<xsl:text>. </xsl:text>
				<i>
					<xsl:value-of select="$biblStruct/tei:monogr/tei:imprint/tei:publisher"/>
				</i>
				<xsl:text>. </xsl:text>
				<xsl:call-template name="link-maker">
					<xsl:with-param name="url"
						select="$biblStruct/tei:monogr/tei:idno[@type = 'live-url']"/>
					<xsl:with-param name="displayText"
						select="$biblStruct/tei:monogr/tei:idno[@type = 'live-url']"/>
				</xsl:call-template>
			</p>
		</div>
	</xsl:template>
	<xsl:template name="citeWebsite" match="tei:biblStruct[@type = 'website']">
		<div class="citation-container" id="{@xml:id}">
			<div class="citation">
				<p>
					<xsl:call-template name="link-maker">
						<xsl:with-param name="url" select="tei:monogr/tei:idno[@type = 'live-url']"/>
						<xsl:with-param name="displayText" select="tei:monogr/tei:title"/>
					</xsl:call-template>
				</p>
			</div>
		</div>
	</xsl:template>
	<!-- Make list of links to access resource -->
	<xsl:template name="access-options">
		<xsl:param name="level" as="node()*"/>
		<xsl:if test="$level/tei:idno">
			<div class="access-options">
				<ul>
					<xsl:apply-templates select="$level/tei:idno[@type = 'DOI']"/>
					<xsl:apply-templates select="$level/tei:idno[@type = 'OCLC']"/>
					<xsl:apply-templates select="$level/tei:idno[@type = 'InternetArchive']"/>
					<xsl:apply-templates select="$level/tei:idno[@type = 'JSTOR']"/>
					<xsl:apply-templates select="$level/tei:idno[@type = 'HDL']"/>
					<xsl:call-template name="display-url">
						<xsl:with-param name="url" select="$level/tei:idno[@type = 'live-url']"/>
						<xsl:with-param name="displayText"
							select="$level/tei:idno[@type = 'live-url']"/>
					</xsl:call-template>
				</ul>
			</div>
		</xsl:if>
	</xsl:template>
	<!-- Formatting primary list of contributors -->
	<xsl:template name="contributor-list">
		<xsl:param name="contributors" as="node()*"/>
		<xsl:variable name="countContributors" select="count($contributors)"/>
		<xsl:variable name="firstContributor" select="$contributors[1]"/>
		<xsl:variable name="lastContributor" select="$contributors[last()]"/>
		<xsl:if test="$contributors">
			<xsl:variable name="attributionStr">
				<xsl:call-template name="first-contributor">
					<xsl:with-param name="person" select="$firstContributor"/>
				</xsl:call-template>
				<xsl:if test="$countContributors &gt; 1">
					<xsl:for-each select="$contributors[position() > 1]">
						<xsl:variable name="thisContributor" select="."/>
						<xsl:text>, </xsl:text>
						<xsl:if test="$thisContributor = $lastContributor">
							<xsl:text>and </xsl:text>
						</xsl:if>
						<xsl:call-template name="other-contributor">
							<xsl:with-param name="person" select="$thisContributor"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="$contributors[local-name(.) = 'editor']">
					<xsl:text>, ed</xsl:text>
					<xsl:if test="$countContributors &gt; 1">
						<xsl:text>s</xsl:text>
					</xsl:if>
				</xsl:if>
			</xsl:variable>
			<xsl:value-of select="$attributionStr"/>
			<xsl:if test="not(matches($attributionStr, '\.\s*$'))">
				<xsl:text>.</xsl:text>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- Formatting secondary list of contributors (e.g., translators, editors) -->
	<xsl:template name="secondary-contributor-list">
		<xsl:param name="contributors" as="node()*"/>
		<xsl:variable name="countContributors" select="count($contributors)"/>
		<xsl:variable name="firstContributor" select="$contributors[1]"/>
		<xsl:variable name="lastContributor" select="$contributors[last()]"/>
		<xsl:if test="$contributors">
			<xsl:variable name="attributionStr">
				<xsl:if test="not($contributors[@role])">
					<xsl:text>edited by </xsl:text>
				</xsl:if>
				<xsl:if test="$contributors[@role = 'translator']">
					<xsl:text>Translated by </xsl:text>
				</xsl:if>
				<xsl:if test="$contributors[@role = 'interviewee']">
					<xsl:text>Interview with </xsl:text>
				</xsl:if>
				<xsl:call-template name="other-contributor">
					<xsl:with-param name="person" select="$firstContributor"/>
				</xsl:call-template>
				<xsl:if test="$countContributors &gt; 1">
					<xsl:for-each select="$contributors[position() > 1]">
						<xsl:variable name="thisContributor" select="."/>
						<xsl:text>, </xsl:text>
						<xsl:if test="$thisContributor = $lastContributor">
							<xsl:text>and </xsl:text>
						</xsl:if>
						<xsl:call-template name="other-contributor">
							<xsl:with-param name="person" select="$thisContributor"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:if>
			</xsl:variable>
			<xsl:value-of select="$attributionStr"/>
			<xsl:if
				test="not(matches($attributionStr, '\.\s*$')) and $contributors[@role = ('translator', 'interviewee')]">
				<xsl:text>. </xsl:text>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!-- Formatting for first author -->
	<xsl:template name="first-contributor">
		<xsl:param name="person" as="node()*"/>
		<span class="contributor">
			<xsl:value-of select="$person/tei:surname"/>
			<xsl:text>, </xsl:text>
			<xsl:value-of select="$person/tei:forename"/>
		</span>
	</xsl:template>
	<!-- Formatting for other authors in list -->
	<xsl:template name="other-contributor">
		<xsl:param name="person" as="node()*"/>
		<span class="contributor">
			<xsl:value-of select="$person/tei:forename"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="$person/tei:surname"/>
		</span>
	</xsl:template>
	<!-- Format place and publisher for books -->
	<xsl:template name="book-publishing">
		<xsl:param name="pubInfo" as="node()*"/>
		<span class="pubDetails">
			<xsl:value-of select="$pubInfo/tei:pubPlace"/>
			<xsl:text>: </xsl:text>
			<xsl:value-of select="$pubInfo/tei:publisher"/>
			<xsl:text>.</xsl:text>
		</span>
	</xsl:template>
	<!-- Format volume, issue, page range for journals -->
	<xsl:template name="journal-publishing">
		<xsl:param name="pubInfo" as="node()*"/>
		<span class="pubDetails">
			<xsl:value-of select="$pubInfo/tei:biblScope[@unit = 'volume']"/>
			<xsl:text> (</xsl:text>
			<xsl:value-of select="$pubInfo/tei:biblScope[@unit = 'issue']"/>
			<xsl:text>): </xsl:text>
			<xsl:value-of select="$pubInfo/tei:biblScope[@unit = 'page']"/>
			<xsl:text>.</xsl:text>
		</span>
	</xsl:template>
	<xsl:template match="tei:idno[@type = 'DOI']">
		<xsl:call-template name="display-url">
			<xsl:with-param name="precedingText" select="'DOI: '"/>
			<xsl:with-param name="url" select="concat('https://doi.org/', .)"/>
			<xsl:with-param name="displayText" select="."/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="tei:idno[@type = 'OCLC']">
		<xsl:call-template name="display-url">
			<xsl:with-param name="precedingText" select="'Find on '"/>
			<xsl:with-param name="url" select="concat('http://www.worldcat.org/oclc/', .)"/>
			<xsl:with-param name="displayText" select="'WorldCat'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="tei:idno[@type = 'InternetArchive']">
		<xsl:call-template name="display-url">
			<xsl:with-param name="precedingText" select="'Borrow digitized copy from '"/>
			<xsl:with-param name="url" select="concat('https://archive.org/details/', .)"/>
			<xsl:with-param name="displayText" select="'Internet Archive'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="tei:idno[@type = 'JSTOR']">
		<xsl:call-template name="display-url">
			<xsl:with-param name="precedingText" select="'JSTOR stable link: '"/>
			<xsl:with-param name="url" select="concat('https://www.jstor.org/stable/', .)"/>
			<xsl:with-param name="displayText" select="concat('https://www.jstor.org/stable/', .)"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="tei:idno[@type = 'HDL']">
		<xsl:call-template name="display-url">
			<xsl:with-param name="url" select="concat('https://hdl.handle.net/', .)"/>
			<xsl:with-param name="displayText" select="concat('https://hdl.handle.net/', .)"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="display-url">
		<xsl:param name="precedingText" select="'Available at '"/>
		<xsl:param name="url"/>
		<xsl:param name="displayText"/>
		<xsl:if test="$url">
			<li>
				<xsl:value-of select="$precedingText"/>
				<xsl:call-template name="link-maker">
					<xsl:with-param name="url" select="$url"/>
					<xsl:with-param name="displayText" select="$displayText"/>
				</xsl:call-template>
			</li>
		</xsl:if>
	</xsl:template>
	<xsl:template name="link-maker">
		<xsl:param name="url"/>
		<xsl:param name="displayText"/>
		<a href="{$url}" target="_blank">
			<xsl:value-of select="$displayText"/>
		</a>
	</xsl:template>
</xsl:stylesheet>
