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
<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:ou="http://omniupdate.com/XSL/Variables" 
	xmlns:fn="http://omniupdate.com/XSL/Functions" 
	xmlns:functx="http://www.functx.com" 
	xmlns:ouc="http://omniupdate.com/XSL/Variables" 
	exclude-result-prefixes="ou xsl xs fn ouc functx">
	
	<xsl:import href="../_shared/common.xsl"/>
	
	<!--  Here is where you select the menu you want by calling one of three templates below. -->
	<xsl:template name="side-nav">
		<xsl:param name="cols" select="4"/> <!-- Default column width -->
		
		<xsl:variable name="sidenav" select="doc(concat($ou:root, $ou:site, '/_resources/includes/_site-nav.pcf'))/document/ouc:properties[@label='config']"/>
		<xsl:variable name="site-menu-type" select="$sidenav/parameter[@name='use-sidenav']/option[@selected='true']/@value"/>
		<xsl:variable name="section-menu-type" select="if(ou:sectionparam('use-sidenav') != '') then ou:sectionparam('use-sidenav') else 'simple-nav'"/>
		<xsl:variable name="menu-type" select="if($section-menu-type = 'default' or $section-menu-type = '') then $site-menu-type else $section-menu-type"/>
		<xsl:variable name="tags" select="ou:get-page-tags()/tag/name"/>
		<xsl:variable name="show-categories" select="ou:pcfparam('show-categories')"/>
		<xsl:variable name="categories">
			<xsl:for-each select="$tags"><xsl:sort select="name" />
				<span class="label label-primary"><a href="?category={.}"><xsl:value-of select="ou:capital(.)"/></a></span>
			</xsl:for-each>
		</xsl:variable>
		
		
		<div id="left-column" class="col-md-{$cols} col-sm-{$cols} col-xs-12">
			<nav class="side-nav" aria-labelledby="sidemenulabel">
				<strong id="sidemenulabel" class="sidemenu">Section Menu</strong>
				<hr/>
				<xsl:choose>
					<xsl:when test="$menu-type = 'simple-nav'"><xsl:call-template name="simple-nav"/></xsl:when>
					<xsl:when test="$menu-type = 'script-nav'"><xsl:call-template name="script-nav"/></xsl:when>
					<xsl:when test="$menu-type = 'auto-nav'"><xsl:call-template name="auto-nav"/></xsl:when>
					<xsl:otherwise><xsl:call-template name="simple-nav"/></xsl:otherwise>
				</xsl:choose>
			</nav>
			<xsl:if test="boolean(*[@label='leftcolumn']) or boolean($categories)">
				<aside>
					<xsl:if test="boolean(*[@label='leftcolumn'])">
						<xsl:apply-templates select="*[@label='leftcolumn']"/>
					</xsl:if>
					<xsl:if test="not($categories = '') and $show-categories = 'true'">
						<h3 class="categories-heading sidemenu">Categories</h3>
						<xsl:apply-templates select="$categories"/>
					</xsl:if>
				</aside>
			</xsl:if>
		</div>
	</xsl:template>
	
	<xsl:template name="auto-nav">
		<xsl:variable name="section-nav" select="if($dirname = '/') then $dirname else concat('/', ou:sequence($dirname, '/')[1], '/')"/>
		
		<xsl:choose>
			<xsl:when test="doc-available(concat($ou:root, $ou:site, $section-nav, '_nav.pcf'))">
				<xsl:if test="$ou:action != 'pub'">
					<p class="bg-info" style="padding:10px">
						<span class="glyphicon glyphicon-list-alt" style="font-size:20px;" aria-hidden="true"></span>
						<xsl:text> Local menu _nav.pcf will display upon publish.</xsl:text>
					</p>
				</xsl:if>
				<ul class="parent list-unstyled auto-menu">
					<xsl:copy-of select="ou:ssi(concat($section-nav, '_nav.html'))"/>
				</ul>
				<script type="text/javascript" src="/_resources/js/scripts.js"></script>
			</xsl:when>
			<xsl:otherwise>
				<xsl:try>
					<xsl:if test="$ou:action != 'pub'"><p class="bg-warning">No _nav.pcf file found.</p></xsl:if>
					<ul class="parent list-unstyled auto-menu">
						<xsl:comment> ouc:div label="navigation" group="Administrators" button-text="Navigation" path="<xsl:value-of select="$dirname"/>_nav.inc" </xsl:comment>
						<xsl:copy-of select="ou:includeFile(concat($dirname, '_nav.inc'))"/>
						<xsl:comment> /ouc:div </xsl:comment>
					</ul>
					<xsl:catch><p class="bg-warning">No local _nav file found.</p></xsl:catch>
				</xsl:try>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Simple navigation. Only displays the contents of the current section's _nav.inc file on each page. -->
	<xsl:template name="simple-nav">
		<xsl:variable name="sel-dir" select="if(normalize-space($ou:sectionNav) = '') then $dirname else $ou:sectionNav"/>
		<ul class="parent list-unstyled simple-menu">
			<xsl:choose>
				<xsl:when test="$ou:action = 'pub'">
					<xsl:copy-of select="ou:ssi(concat($sel-dir, '_nav.inc'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:comment> ouc:div label="<xsl:value-of select="ou:includeFile(concat($sel-dir, '_nav.inc'))" />" path="<xsl:value-of select="ou:includeFile(concat($sel-dir, '_nav.inc'))" />"</xsl:comment>
					<xsl:copy-of select="ou:includeFile(concat($sel-dir, '_nav.inc'))"/>
					<xsl:comment> /ouc:div </xsl:comment> 
				</xsl:otherwise>
			</xsl:choose>
		</ul>
	</xsl:template>
	<!--
	Call /_resources/php/sidenav.php

	Staging: 
			unparsed-text('/_resources/php/sidenav.php?nav=/about/&amp;path=/about/directions');

	Prod: 	<?php
			# Will give class active to $page
			$page = "/about/directions/office.html";
			$path = "/about/directions";
			require_once('/_resources/php/sidenav.php');
			?>
	--> 
	<xsl:template name="script-nav">
		<xsl:variable name="sidenav-param-path" select="$ou:path"/>
		<xsl:variable name="sidenav-path">
			<xsl:text>/_resources/php/sidenav.php</xsl:text>
			<xsl:if test="$ou:action != 'pub'">
				<xsl:text disable-output-escaping="yes">?page=</xsl:text><xsl:value-of select="concat($dirname, $ou:filename)" />
				<xsl:text disable-output-escaping="yes">&amp;path=</xsl:text><xsl:value-of select="$ou:path"/>
			</xsl:if>
		</xsl:variable>
		
		<xsl:if test="$ou:action = 'pub'">
			<xsl:processing-instruction name="php">
			$page  = "<xsl:value-of select="concat($dirname, $ou:filename)" />";
			$path = "<xsl:value-of select="$ou:path"/>";
			?</xsl:processing-instruction>
		</xsl:if>
		<xsl:copy-of select="ou:ssi($sidenav-path)"/>
		<xsl:if test="$ou:action != 'pub'">
			<xsl:comment> ouc:div label="<xsl:value-of select="ou:includeFile(concat($dirname, '_nav.inc'))" />" path="<xsl:value-of select="ou:includeFile(concat($dirname, '_nav.inc'))" />"</xsl:comment>
			<xsl:copy-of select="ou:includeFile(concat($dirname, '_nav.inc'))"/>
			<xsl:comment> /ouc:div </xsl:comment> 
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>