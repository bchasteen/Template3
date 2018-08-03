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
<xsl:stylesheet version="3.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:xs="http://www.w3.org/2001/XMLSchema" 
				xmlns:ou="http://omniupdate.com/XSL/Variables" 
				xmlns:fn="http://omniupdate.com/XSL/Functions" 
				xmlns:ouc="http://omniupdate.com/XSL/Variables" 
				exclude-result-prefixes="ou xsl xs fn ouc">

	<xsl:import href="_shared/common.xsl"/>
	<xsl:template name="breadcrumb-nav"/>

	<xsl:template name="page-content">
		<main id="home-page" role="main">
			<a id="maincontent"></a>
			<xsl:if test="ou:pcfparam('show-jumbotron') = 'true'">
				<div class="container-fluid feature">
					<div class="container">
						<div class="row">
							<div class="col-md-6 feature_blurb">
								<a href="{feature/ouc:div[@label='feature-link']}">
									<h1><xsl:value-of select="substring(feature/ouc:div[@label='feature-title'], 0, 99)"/></h1>
									<p><xsl:value-of select="substring(feature/ouc:div[@label='feature-description'], 0, 299)"/></p>
									<p>Learn more &#9656;</p>
								</a>
							</div>
							<div class="col-md-6 center-block feature_image">
								<a href="{feature/ouc:div[@label='feature-link']}">
									<img class="img-responsive" alt="{feature/ouc:div[@label='feature-image']/img/@alt}" src="{feature/ouc:div[@label='feature-image']/img/@src}" />
								</a>
							</div>
						</div>
					</div>
				</div>
			</xsl:if>
			<xsl:if test="ou:pcfparam('show-welcome') = 'true'">
				<div class="container padd-top">
					<xsl:call-template name="home-cols"/>
				</div>
			</xsl:if>
			<xsl:if test="ou:pcfparam('show-main') = 'true'">
				<div class="container padd-top">
					<xsl:apply-templates select="ouc:div[@label='maincontent']"/>
				</div>
			</xsl:if>
			<xsl:if test="ou:pcfparam('show-two-divs') = 'true'">
				<div class="container no-pad">
					<div class="row no-gutters audience-grid">
						<xsl:call-template name="two-divs"/>
					</div>
				</div>
			</xsl:if>
			<xsl:if test="ou:pcfparam('show-three-divs') = 'true'">
				<div class="container no-pad">
					<div class="row no-gutters audience-grid">
						<xsl:call-template name="three-divs"/>
					</div>
				</div>
			</xsl:if>
		</main>
	</xsl:template>

	<xsl:template name="home-cols">
		<section class="row">
			<div class="col-md-4 left-col">
				<section>
					<article>
						<xsl:apply-templates select="ouc:div[@label='leftcontent']" />
					</article>
				</section>
			</div>
			<xsl:if test="ou:pcfparam('layout') = 'three-column' or ou:pcfparam('layout') = ''">
				<div class="col-md-5 middle-col">
					<section>
						<article>
							<h2 class="block-title">Events &amp; Announcements</h2>
							<xsl:apply-templates select="ouc:div[@label='middlecontent']" />
						</article>
					</section>
				</div>
			</xsl:if>
			<div class="col-md-3 right-col">
				<section>
					<article>
						<h2 class="block-title">Quicklinks</h2>
						<xsl:apply-templates select="ouc:div[@label='rightcontent']" />
					</article>
				</section>
			</div>
		</section>
	</xsl:template>

	<xsl:template name="two-divs">
		<div class="col-md-6">
			<div class="audience-container">
				<div class="audience-name" style="background-image: url('{ou:pcfparam('left-two-div')}');"><a href="{ou:pcfparam('left-two-div-url')}"><span><xsl:value-of select="ouc:properties[@label='config']/parameter[@name='left-two-div-text']/node()"/></span></a></div>
			</div>
		</div>
		<div class="col-md-6">
			<div class="audience-container">
				<div class="audience-name" style="background-image: url('{ou:pcfparam('right-two-div')}');"><a href="{ou:pcfparam('right-two-div-url')}"><span><xsl:value-of select="ouc:properties[@label='config']/parameter[@name='right-two-div-text']/node()"/></span></a></div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="three-divs">
		<div class="col-md-4">
			<div class="audience-container">
				<div class="audience-name" style="background-image: url('{ou:pcfparam('left-three-div')}');"><a href="{ou:pcfparam('left-three-div-url')}"><span><xsl:value-of select="ouc:properties[@label='config']/parameter[@name='left-three-div-text']/node()"/></span></a></div>
			</div>
		</div>
		<div class="col-md-4">
			<div class="audience-container">
				<div class="audience-name" style="background-image: url('{ou:pcfparam('middle-three-div')}');"><a href="{ou:pcfparam('middle-three-div-url')}"><span><xsl:value-of select="ouc:properties[@label='config']/parameter[@name='middle-three-div-text']/node()"/></span></a></div>
			</div>
		</div>
		<div class="col-md-4">
			<div class="audience-container">
				<div class="audience-name" style="background-image: url('{ou:pcfparam('right-three-div')}');"><a href="{ou:pcfparam('right-three-div-url')}"><span><xsl:value-of select="ouc:properties[@label='config']/parameter[@name='right-three-div-text']/node()"/></span></a></div>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
