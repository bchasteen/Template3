<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE stylesheet [
<!ENTITY nbsp   "&#160;">
<!ENTITY lsaquo "&#8249;">
<!ENTITY rsaquo "&#8250;">
<!ENTITY laquo  "&#171;">
<!ENTITY raquo  "&#187;">
<!ENTITY copy   "&#169;">
<!ENTITY copy   "&#169;">
<!ENTITY rarr	"&#8594;">
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
				xmlns:ouc="http://omniupdate.com/XSL/Variables" 
				xmlns:media="http://search.yahoo.com/mrss/"
				xmlns:functx="http://www.functx.com" 
				exclude-result-prefixes="ou xsl xs fn ouc functx media">

	<xsl:import href="template-matches.xsl"/>
	<xsl:import href="ouvariables.xsl"/>
	<xsl:import href="functions.xsl"/>
	<xsl:import href="cas.xsl"/>
	<xsl:import href="functx-functions.xsl"/>
	<xsl:import href="custom-functions.xsl"/>
	<xsl:import href="tag-management.xsl"/>
	<xsl:import href="ougalleries.xsl"/>
	<xsl:import href="../../ldp/forms/xsl/forms.xsl"/>
	<xsl:import href="breadcrumb.xsl"/>
	<xsl:import href="../navigation/nav.xsl"/>
	<xsl:import href="../calendar/calendar.xsl"/>

	<!-- System Params - don't edit -->
	<xsl:param name="ou:action"/>
	<!-- Default: for HTML5 use below output declaration -->
	<xsl:output method="html" indent="yes" encoding="UTF-8" include-content-type="no"/>
	<xsl:strip-space elements="*"/>

	<xsl:template match="/document">
		<!-- CAS protected Pages.  Set by a parameter in _props.pcf  the local .pcf file that you want to protect. -->
		<xsl:if test="ou:hasCas($props-protection) and $ou:action = 'pub'"><xsl:call-template name="cas-protect"><xsl:with-param name="protection" select="$props-protection"/></xsl:call-template></xsl:if>
		<xsl:if test="ou:pcfparam('destination') != ''"><xsl:call-template name="redirect"/></xsl:if>
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE HTML&gt;</xsl:text>
		<html lang="en">
			<head>
				<xsl:copy-of select="ou:includeFile('/_resources/includes/headcode.inc')"/>
				<title>
					<xsl:value-of select="$page-title"/>
					<xsl:call-template name="title"><xsl:with-param name="path" select="$dirname"/></xsl:call-template>
				</title>
				<xsl:copy-of select="ou:includeFile('/_resources/includes/css.inc')"/>
				<xsl:apply-templates select="headcode/node()"/>
				<xsl:call-template name="calendar-headcode"/> <!-- Add Calendar Code -->
				<xsl:call-template name="form-headcode"/> <!-- Add Form Code -->
				<xsl:if test="descendant::gallery"><xsl:apply-templates select="ou:gallery-headcode(ou:pcfparam('gallery-type'))"/></xsl:if>
			</head>
			<body><a class="sr-only sr-only-focusable" href="#maincontent">Skip to main content</a>
				<xsl:apply-templates select="bodycode/node()"/>
				<xsl:if test="ou:hasCas($props-protection)"><xsl:apply-templates select="ou:casMessage($props-protection)"/></xsl:if>
				<!-- <xsl:call-template name="quick-links"/> -->
				<xsl:call-template name="header" />
				<xsl:call-template name="template-headcode"/>
				<xsl:call-template name="page-content" />
				<xsl:call-template name="breadcrumb-nav"/>
				<xsl:call-template name="footer" />
				<xsl:call-template name="template-footcode"/>
				<xsl:copy-of select="ou:includeFile('/_resources/includes/final-include.inc')"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="template-headcode"/>



	<xsl:template name="quick-links">
		<nav aria-label="Helpful links" aria-labelledby="quicknav-heading" class="top-nav navbar-inverse">
			<div class="container">
				<div id="quick-links" class="row collapse">
					<xsl:copy-of select="ou:includeFile('/_resources/includes/quick_links.inc')"/>
				</div>
				<div class="row quick-links-bar">
					<a id="quicknav-heading" class="accordion-toggle" role="button" data-toggle="collapse" href="#quick-links" aria-expanded="false" aria-controls="quick-links" aria-haspopup="true">UGA Links 
						<span aria-hidden="true" class="glyphicon glyphicon-triangle-bottom"></span>
					</a>
				</div>
			</div>
		</nav>
	</xsl:template>

	<xsl:template name="header">
		<header class="banner" role="banner">
			<div id="topbar">
				<div class="container">
					<div class="row">
						<div class="col-md-3 site-logo">
							<a href="{{d:3075031}}"><img src="{{f:18817368}}" alt="UGA Logo"/></a>
						</div>
						<div class="col-md-9">
							<div class="social-links-top">
								<ul>
									<xsl:copy-of select="ou:includeFile('/_resources/includes/_social.inc')"/>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<nav aria-label="Main Navigation" aria-labelledyby="main-navigation">
				<h1 id="main-navigation" class="sr-only">Main Navigation</h1>
				<div id="navcontainer">
					<div class="container">
						<div class="row center">
							<div class="col-md-5">
								<a href="/"><img src="{{f:18823422}}" alt="UGA Logo"/></a>
							</div>
							<div class="col-md-5">
								<xsl:variable name="path" select="'/_resources/includes/_site-nav/'"/>
								<xsl:variable name="prod-path" select="concat(substring($path, 1, (string-length($path) - 1)), '.html')"/>
								<xsl:try>
									<xsl:choose>
										<xsl:when test="not($ou:action = 'pub') and doc-available(concat($domain, $path))">
											<xsl:copy-of select="doc(concat($domain, $path))" />
										</xsl:when>
										<xsl:when test="not($ou:action = 'pub') and doc-available(concat($domain, $prod-path))">
											<xsl:copy-of select="doc(concat($domain, $prod-path))" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:processing-instruction name="php">include($_SERVER["DOCUMENT_ROOT"]. "<xsl:value-of select="$prod-path"/>"); ?</xsl:processing-instruction>
										</xsl:otherwise>
									</xsl:choose>	
									<xsl:catch>
										<xsl:if test="not($ou:action = 'pub')">
											<xsl:value-of select="doc(concat($domain, $path))" disable-output-escaping="yes"/>
											<p><xsl:value-of select="concat('File not available. Please make sure the path ( ' , concat($domain, $path),' ) is correct and the file is published.')" /></p>
										</xsl:if>
									</xsl:catch>
								</xsl:try>
							</div>
							<div class="col-md-2">
								<div class="custom-search hidden-xs">
									<xsl:copy-of select="ou:includeFile('/_resources/includes/search.inc')"/>
								</div>
							</div>
						</div>
					</div>
				</div>
			</nav>
			<nav aria-label="Shortcuts" aria-labelledyby="shortcuts">
				<h2 id="shortcuts" class="sr-only">Shortcut Navigation</h2>
				<div class="information-bar">
					<div class="container info-align">
						<xsl:copy-of select="ou:includeFile('/_resources/includes/information.inc')"/>
					</div>
				</div>
			</nav>
		</header>
	</xsl:template>

	<xsl:template name="footer">
		<div class="information-bar">
		</div>
		<footer class="content-info" role="contentinfo">
			<div class="container-fluid no-pad">
				<div class="row no-gutters footer-clearfix">
					<div class="col-md-4 footer-left">
						<div class="footerlogo">
							<a href="http://uga.edu" target="_blank"><img src="{{f:18817482}}" alt="logo" id="footerlogo"/></a>
						</div>
						<div class="social-links-bottom">
							<ul id="social-bottom">
								<xsl:copy-of select="ou:includeFile('/_resources/includes/_social.inc')"/>
							</ul>
						</div>
					</div>
					<div class="col-md-8 footer-right">
						<div class="footer-info">
							<xsl:copy-of select="ou:includeFile('/_resources/includes/footer.inc')"/>
						</div>
						<div class="copyright">
							<xsl:call-template name="copyright"/>
							<div id="de"><ouc:ob /></div>
						</div>	
					</div>
				</div>
			</div>
		</footer>
		<xsl:copy-of select="ou:includeFile('/_resources/includes/footcode.inc')" />
	</xsl:template>
	<!--
<xsl:template name="footer">
<footer class="content-info" role="contentinfo">
<div id="footer" class="container">
<div class="row">
<div class="col-md-3 col-sm-6 col-xs-12 footer-left">
<a href="http://uga.edu" target="_blank"><img src="{{f:18817482}}" alt="logo" /></a>
<br/>
<div class="social-links-bottom">
<xsl:copy-of select="ou:includeFile('/_resources/includes/_social.inc')"/>
</div>
<xsl:call-template name="copyright"/>
<a href="http://uga.edu/" target="_blank">University of Georgia</a>
</div>
<xsl:copy-of select="ou:includeFile('/_resources/includes/footer.inc')"/>
<div id="de"><ouc:ob /></div>		
</div>
</div>
</footer>
<xsl:copy-of select="ou:includeFile('/_resources/includes/footcode.inc')" />
</xsl:template>
-->
	<xsl:template name="template-footcode">
		<xsl:apply-templates select="footcode/node()"/>
		<xsl:call-template name="form-footcode"/><!-- Add Form Code -->
		<xsl:if test="descendant::gallery"><xsl:apply-templates select="ou:gallery-footcode(ou:pcfparam('gallery-type'))"/></xsl:if>
		<xsl:call-template name="calendar-footcode"/>
	</xsl:template>

	<xsl:template name="copyright">
		<xsl:text>&copy; </xsl:text>
		<xsl:if test="$ou:action = 'edt'"><xsl:value-of select="year-from-date(current-date())"/></xsl:if>
		<xsl:copy-of select="ou:ssi('/_resources/php/copyright.php')" />
		<xsl:text> </xsl:text>
		<a href="http://uga.edu/" target="_blank">University of Georgia</a>
	</xsl:template>

	<xsl:template name="redirect">
		<xsl:processing-instruction name="php">header("HTTP/1.1 301 Moved Permanently");
			header("Location: <xsl:value-of select="ou:pcfparam('destination')"/>"); 
			?</xsl:processing-instruction>
	</xsl:template>
</xsl:stylesheet>