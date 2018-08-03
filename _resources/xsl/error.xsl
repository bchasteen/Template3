<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE stylesheet>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ou="http://omniupdate.com/XSL/Variables" xmlns:fn="http://omniupdate.com/XSL/Functions" xmlns:ouc="http://omniupdate.com/XSL/Variables" exclude-result-prefixes="ou xsl xs fn ouc">
	<xsl:import href="_shared/common.xsl"/>	
	<xsl:template name="breadcrumb-nav"/>
	
	<xsl:import href="_shared/common.xsl"/>
	
	<!-- System Params - don't edit -->
	<xsl:param name="ou:action"/>
	<!-- Default: for HTML5 use below output declaration -->
	<xsl:output method="html" indent="yes" encoding="UTF-8" include-content-type="no"/>
	<xsl:strip-space elements="*"/>

	<xsl:template match="/document">
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE HTML&gt;</xsl:text>
		<html lang="en">
			<head>
				<xsl:copy-of select="ou:includeFile('/_resources/includes/headcode.inc')"/>
				<title><xsl:value-of select="ou:pcfparam('breadcrumb')"/></title>
				<xsl:copy-of select="ou:includeFile('/_resources/includes/css.inc')"/>
				<xsl:apply-templates select="headcode/node()"/>
			</head>
			<body><a class="sr-only sr-only-focusable" href="#maincontent">Skip to main content</a>
				<xsl:apply-templates select="bodycode/node()"/>
				<xsl:call-template name="quick-links"/>
				<xsl:call-template name="header" />
				<xsl:call-template name="main-nav"/>
				<xsl:call-template name="template-headcode"/>
				<xsl:call-template name="page-content" />
				<xsl:call-template name="breadcrumb-nav"/>
				<xsl:call-template name="footer" />
				<xsl:call-template name="template-footcode"/>
				<xsl:apply-templates select="footcode/node()"/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="page-content">
		<main role="main">
			<a id="maincontent"></a>
			<div class="container interior">
				<div class="row">
					<article id="right-column" class="col-md-12">
						<h1><xsl:value-of select="ou:pcfparam('breadcrumb')"/></h1>
						<xsl:apply-templates select="ouc:div[@label='maincontent']" />
					</article>
				</div>
			</div>
		</main>
	</xsl:template>
</xsl:stylesheet>
