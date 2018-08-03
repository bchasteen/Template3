<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<!-- 

INTERIOR PAGE 
A simple pagetype.

Contributors: OUTC 16
Last Updated: 1/18/16
-->
<xsl:stylesheet version="3.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:ou="http://omniupdate.com/XSL/Variables"
				xmlns:fn="http://omniupdate.com/XSL/Functions"
				xmlns:ouc="http://omniupdate.com/XSL/Variables"
				exclude-result-prefixes="ou xsl xs fn ouc">

	<!-- Import resource XSL files here -->
	<xsl:import href="common.xsl"/>

	<!-- Default: for HTML5 use below output declaration -->
	<xsl:output method="html" version="5.0" indent="yes" encoding="UTF-8" include-content-type="no"/>

	<xsl:mode name="copy" on-no-match="shallow-copy" />

	
	<xsl:template name="header">
		<div class="row bg-{$ou:theme-color}">
			<div class="col-xs-12">
				<h1><xsl:value-of select="ouc:properties[@label='config']/parameter[@name='heading']" /></h1>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="content">
		<div class="row">
			<div class="col-sm-9 col-sm-push-3">
				<p>Page Tags: <xsl:copy-of select="string-join($page-tags/tag/name, ', ')" /></p>
				<p>All Tags: <xsl:value-of select="string-join(doc('ou:/Tag/GetAllTags')/tags/tag/name, ', ')" /></p>
				<xsl:variable name="tag">robert</xsl:variable>
				<p>Files with Tags ('<xsl:value-of select="$tag"/>'): <xsl:copy-of select="string-join(doc(concat('ou:/Tag/GetFilesWithAnyTags?site=', $ou:site, '&amp;tag=',$tag))/pages/page/path, ', ')" /></p>
				<p>S-Tag: <xsl:value-of select="ouc:properties/parameter[@name='file']"/></p>
				
				<p><strong>Day: <xsl:value-of select="format-dateTime($ou:modified, '[F]')" /></strong></p>
				<p><strong>Day Abbr.: <xsl:value-of select="ou:day-abbreviation(format-dateTime($ou:modified, '[F]'))" /></strong></p>
				
				<xsl:variable name="phone">(805) 490-9400 </xsl:variable>
				<p>Telephone: <a href="{ou:tel-link($phone)}"><xsl:value-of select="$phone" /></a></p>
				<xsl:apply-templates select="ouc:div[@label='maincontent']" mode="copy" />
			</div>
			<div class="col-sm-3 col-sm-pull-9">
				<h3>Navigation</h3>
				<ul class="nav nav-pills nav-stacked">
					<xsl:comment> ouc:div label="navigation" group="None" button-text="Navigation" path="<xsl:value-of select="$dirname"/>_nav.inc" </xsl:comment>
					<!--#include virtual="/_training/rkiffe/_nav.inc" -->
					<xsl:processing-instruction name="php">
						include($_SERVER['DOCUMENT_ROOT'] . "<xsl:value-of select="$dirname"/>_nav.inc"); 
						?</xsl:processing-instruction>
					<xsl:comment> /ouc:div </xsl:comment>
				</ul>
				<hr />

				<!-- Contact Info -->
				<xsl:copy-of select="ouc:properties/parameter[@name='contactinfo']/node()" />
			</div>
		</div>
	</xsl:template>


</xsl:stylesheet>
