<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE stylesheet>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ou="http://omniupdate.com/XSL/Variables" xmlns:fn="http://omniupdate.com/XSL/Functions" xmlns:ouc="http://omniupdate.com/XSL/Variables" exclude-result-prefixes="ou xsl xs fn ouc">
	<xsl:import href="_shared/template-matches.xsl"/>
	<xsl:import href="_shared/ouvariables.xsl"/>
	<xsl:import href="_shared/functions.xsl"/>
	<xsl:import href="_shared/functx-functions.xsl"/>
	<xsl:import href="_shared/custom-functions.xsl"/>
	
	<!-- System Params - don't edit -->
	<xsl:param name="ou:action"/>
	<!-- Default: for HTML5 use below output declaration -->
	<xsl:output method="html" indent="yes" encoding="UTF-8" include-content-type="no"/>
	<xsl:strip-space elements="*"/>

	<xsl:template match="/document">
		<xsl:if test="ou:pcfparam('destination') != ''">
			<xsl:call-template name="redirect"/>
		</xsl:if>
		<!-- begin html -->
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE HTML&gt;</xsl:text>
		<html lang="en">
			<head>
				<meta charset="utf-8"/>
				<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<link rel="icon" type="image/png" href="http://uga.edu/favicon.png" />
				<title>Redirect <xsl:value-of select="if(ou:pcfparam('breadcrumb') != '') then ou:pcfparam('breadcrumb') else ''"/></title>
				<link href="{{f:18817357}}" rel="stylesheet"/>
				<xsl:apply-templates select="headcode/node()"/>
			</head>
			<body>
				<xsl:apply-templates select="bodycode/node()"/>
				<main>
					<xsl:call-template name="page-content"/>
				</main>
				<xsl:apply-templates select="footcode/node()"/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="page-content">
		<main id="content">
			<div class="container-fluid">
				<div class="container">
					<div class="row">
						<div id="main-column" class="{if (ou:pcfparam('layout') = 'two-column') then 'col-md-8' else 'col-md-12'} col-md-12">
							<h1>This is a redirect page.</h1>
							<p>Edit Page Parameters to redirect this page.  Publish the page and the redirect will become active.</p>
							<p>This page will redirect to: <a style="font-size:large;font-family:arial;" href="{ou:pcfparam('destination')}"><xsl:value-of select="ou:pcfparam('destination')"/></a> upon being viewed from the Internet.</p>
							<xsl:apply-templates select="ouc:div[@label='maincontent']" />
						</div>
					</div>
				</div>
			</div>
		</main>
	</xsl:template>
	
	<xsl:template name="redirect">
		<xsl:processing-instruction name="php">header("HTTP/1.1 301 Moved Permanently"); header("Location: <xsl:value-of select="ou:pcfparam('destination')"/>"); ?</xsl:processing-instruction>
	</xsl:template>
</xsl:stylesheet>
