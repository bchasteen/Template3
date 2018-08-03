<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE stylesheet[
<!ENTITY nbsp   "&#160;">
<!ENTITY lsaquo "&#8249;">
<!ENTITY rsaquo "&#8250;">
<!ENTITY laquo  "&#171;">
<!ENTITY raquo  "&#187;">
<!ENTITY copy   "&#169;">
<!ENTITY rarr   "&#8594;">
]>
<!-- 
Implementations Skeletor v3 - 5/10/2014

HOME PAGE 
A complex page type.

Contributors: Your Name Here
Last Updated: Enter Date Here
-->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ou="http://omniupdate.com/XSL/Variables" xmlns:fn="http://omniupdate.com/XSL/Functions" xmlns:ouc="http://omniupdate.com/XSL/Variables" exclude-result-prefixes="ou xsl xs fn ouc">
	<xsl:import href="../_shared/common.xsl"/>
	<xsl:import href="../navigation/sidenav.xsl"/>

	<xsl:template name="page-content">
		<main role="main">
			<a id="maincontent"></a>
			<div class="container interior">
				<div class="row">
					<article id="right-column" class="{if (ou:pcfparam('layout') != 'full-width') then 'col-md-8 col-sm-8 col-xs-12' else 'col-md-12'}">
						<xsl:variable name="feed" select="if (ou:pcfparam('rss-feed') != '') then ou:pcfparam('rss-feed') else $ou:feed"/>
						<xsl:variable name="limit" select="if (ou:pcfparam('rss-limit') != '') then ou:pcfparam('rss-limit') else 10" />
						<xsl:variable name="pagination" select="if (ou:pcfparam('rss-pagination') = 'true') then ou:pcfparam('rss-pagination') else 'false'" />

						<h1><xsl:value-of select="$props-title"/></h1>
						<xsl:choose>
							<xsl:when test="$ou:action = 'pub'">
								<xsl:processing-instruction name="php">
									require_once($_SERVER['DOCUMENT_ROOT'] . '/_resources/php/rss.php');

									$feed = "<xsl:value-of select="$feed"/>";
									$options = [];
									$options["limit"] = "<xsl:value-of select="$limit" />";
									$options["pagination"] = "true";
									displayRSS(getRSScategory($feed), json_encode($options));
									?</xsl:processing-instruction>
							</xsl:when>
							<xsl:otherwise>
								<p>News items will be displayed on publish.</p>
								<p><strong>Feed </strong><xsl:value-of select="concat($domain, $feed)" /></p>
								<p><strong>Limit </strong><xsl:value-of select="$limit" /></p>
							</xsl:otherwise>
						</xsl:choose>

					</article>
					<xsl:if test="ou:pcfparam('layout') != 'full-width'"><xsl:call-template name="side-nav"/></xsl:if>
				</div>
			</div>
		</main>
	</xsl:template>
	
</xsl:stylesheet>
