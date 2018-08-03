<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<!-- 
Implementations Skeletor v3 - 5/10/2014

IMPLEMENTATION VARIABLES 
Define global implementation variables here, so that they may be accessed by all page types and in the info/debug tabs.
This also provides a convenient area for complicated logic to exist without clouding up the general xsl/html structure.

Contributors: Your Name Here
Last Updated: Enter Date Here
-->
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ou="http://omniupdate.com/XSL/Variables"
    xmlns:fn="http://omniupdate.com/XSL/Functions"
    xmlns:ouc="http://omniupdate.com/XSL/Variables"
    exclude-result-prefixes="ou xsl xs fn ouc">

	<!-- System Params - don't edit -->
	<!-- Current Page Info -->
	<xsl:param name="ou:action"/>		<!-- Page 'state' in OU Campus (prv = Preview, pub = Publish, edt = Edit, cmp = Compare) -->
	<xsl:param name="ou:uuid"/>			<!-- Unique Page ID -->
	<xsl:param name="ou:path"/>			<!-- Root-relative path to page output -->
	<xsl:param name="ou:dirname"/>		<!-- Root-relative path to current folder (USE "dirname" BELOW INSTEAD) -->
	<xsl:param name="ou:filename"/>		<!-- Filename of output -->
	<xsl:param name="ou:created" as="xs:dateTime"/>		<!-- Page Creation date/time -->
	<xsl:param name="ou:modified" as="xs:dateTime"/> 	<!-- Last Page Modification date/time -->
	<xsl:param name="ou:feed"/>			<!-- Path (root-relative) to RSS Feed that's assigned to current page -->
	<xsl:param name="ou:ftpdir"/>
	
	<!-- Staging Server Info -->
	<xsl:param name="ou:servername"/>	<!-- Staging Server's Domain Name -->
	<xsl:param name="ou:root"/>			<!-- Path from root of staging server -->
	<xsl:param name="ou:site"/>			<!-- Site Name (same as foldername on staging server) -->
	<xsl:param name="ou:stagingpath"/>	<!-- Staging path of the file -->
	
	<!-- Production Server Info -->
	<xsl:param name="ou:target"/>		<!-- Name of Target Production Server -->
	<xsl:param name="ou:httproot"/>		<!-- Address of Target Production Server (from site settings) -->
	<xsl:param name="ou:ftproot"/>		<!-- Folder path to site root on Production Server (from site settings) -->
	<xsl:param name="ou:ftphome"/>		<!-- Initial subdirectory for site root on Production Server (from site settings) -->
	
	<!-- User Info -->
	<xsl:param name="ou:username"/>		<!-- Active user/publisher -->
	<xsl:param name="ou:lastname"/>		<!-- Active user/publisher -->
	<xsl:param name="ou:firstname"/> 	<!-- Active user/publisher -->
	<xsl:param name="ou:email"/>		<!-- Active user/publisher -->
	
	<!-- directory variables -->
	<xsl:param name="ou:sectionNav"/>
	<xsl:param name="ou:sectionProps"/>
	
	<!-- Implementation Specific Variables -->
	<xsl:param name="bodyClass" />
	
	<!-- server information -->
	<xsl:param name="server-type" select="'php'"/> 
	<xsl:param name="index-file" select="'index'"/> 
	<xsl:param name="extension" select="'html'"/> 	

	<!-- for various concatenation purposes -->
	<xsl:param name="dirname" select="if(string-length($ou:dirname) = 1) then '/' else concat($ou:dirname, '/')" />
	<xsl:param name="domain" select="substring($ou:httproot,1,string-length($ou:httproot)-1)" />			
	<xsl:param name="path" select="substring($ou:root,1,string-length($ou:httproot)-1)"/>
	<xsl:param name="filename" select="ou:filename"/>
	
	<!-- section property files -->
	<xsl:param name="props-file" select="'_props.pcf'"/>
	<xsl:param name="nav-file" select="'_nav.inc'"/>
	<xsl:param name="props-path" select="concat($ou:root, $ou:site, concat(if (normalize-space($ou:sectionProps) = '') then $dirname else $ou:sectionProps, '_props.pcf'))"/>
	<xsl:param name="props-title">
		<xsl:try>
			<xsl:value-of select="doc($props-path)/document/ouc:properties[@label='config']/parameter[@name='breadcrumb']"/>
			<xsl:catch></xsl:catch>
		</xsl:try>
	</xsl:param>
	<xsl:param name="props-img">
		<xsl:try>
			<xsl:value-of select="doc($props-path)/document/ouc:properties[@label='config']/parameter[@name='image']"/>
			<xsl:catch></xsl:catch>
		</xsl:try>
	</xsl:param>
	
	<!-- page information -->
	<xsl:param name="page-title" select="if($ou:filename = 'index.html') then '' else /document/ouc:properties[@label='config']/parameter[@name='breadcrumb']" />
	
	<!--path to section, based on prop file currently in use-->
	<xsl:param name="section-link" select="substring-after(substring-before($props-path, '_props.pcf'), concat($ou:root, $ou:site))"/>
	
	<!-- for the following, all are set with start and end slash: /folder/ -->
	<xsl:param name="ou:breadcrumb-start"/> <!-- top level breadcrumb -->
	<xsl:variable name="breadcrumb-start" select="if (ends-with($ou:breadcrumb-start, '/')) then $ou:breadcrumb-start else concat($ou:breadcrumb-start, '/')"/>

	<!-- standard navigation start directory variable for navigation -->
	<xsl:param name="ou:navigation-start"/>
	<xsl:variable name="navigation-start" select="if($dirname = '/') then $dirname else concat('/', ou:sequence($dirname, '/')[1], '/')"/>
	
</xsl:stylesheet>