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
							<h3><xsl:value-of select="ou:pcfparam('breadcrumb')"/></h3>
							<p><xsl:value-of select="ou:displayLongDate(ouc:properties[@label='config']/parameter[@name='date-time'])" /></p>
							<xsl:try>
								<xsl:copy-of select="ouc:div[@label='autopublish']"/>
								<xsl:catch></xsl:catch>
							</xsl:try>
							<xsl:apply-templates select="ouc:div[@label='maincontent']" />
					</article>
					<xsl:if test="ou:pcfparam('layout') != 'full-width'"><xsl:call-template name="side-nav"/></xsl:if>
				</div>
			</div>
		</main>
	</xsl:template>
	<xsl:template name="left-column">
		<div id="left-column" class="col-md-4 col-md-12">
			<nav>
				<ul class="list-unstyled">
					<xsl:choose>
						<xsl:when test="unparsed-text-available(concat($ou:root, $ou:site, $dirname, '_nav.inc'))">
							<xsl:attribute name="class" select="'menu'"/>

							<xsl:comment> ouc:div label="navigation" group="Administrators" button-text="Navigation" path="<xsl:value-of select="$dirname"/>_nav.inc" </xsl:comment>
							<xsl:copy-of select="ou:includeFile(concat($dirname, '_nav.inc'))"/>
							<xsl:comment> /ouc:div </xsl:comment>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class" select="'parent list-unstyled menu'"/>

							<xsl:variable name="sectionNav" select="concat('/', ou:sequence($dirname, '/')[1])"/>
							<xsl:variable name="additional-content" select="doc(concat($ou:root, $ou:site, $sectionNav, '/_nav.pcf'))/document/ouc:div[@label='leftcolumn']"/>
							<xsl:choose>
								<xsl:when test="$ou:action != 'pub'">
									<li><p class="bg-info" style="padding:10px;margin:20px 10px;">
										<span class="glyphicon glyphicon-list-alt" style="font-size:20px;" aria-hidden="true"></span>
										<xsl:text> Local menu _nav.pcf will display upon publish.</xsl:text></p></li>
								</xsl:when>
								<xsl:otherwise>
									<xsl:processing-instruction name="php"> include($_SERVER['DOCUMENT_ROOT'] . "<xsl:value-of select="$sectionNav"/>/_nav.html"); ?</xsl:processing-instruction>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:copy-of select="$additional-content"/>
						</xsl:otherwise>
					</xsl:choose>
				</ul>
			</nav>
		</div>
	</xsl:template>
</xsl:stylesheet>
