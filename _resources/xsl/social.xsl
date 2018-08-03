<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet>
<!--
Implementations Skeletor v3 - 5/10/2014

SECTION PROPERTIES 

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

	<xsl:import href="_shared/common.xsl"/>

	<xsl:template name="social-icons">
		<div class="social-links-top">
			<ul>
				<xsl:if test="ou:pcfparam('show-facebook') = 'true'">
					<li>
						<a href="{ou:pcfparam('facebook-icon')}" title="facebook"><span class="platform-name">facebook</span><i class="fa fa-facebook fa-2x" aria-hidden="true"></i></a>
					</li>
				</xsl:if>
				<xsl:if test="ou:pcfparam('show-twitter') = 'true'">
					<li>
						<a href="{ou:pcfparam('twitter-icon')}" title="twitter"><span class="platform-name">twitter</span><i class="fa fa-twitter fa-2x" aria-hidden="true"></i></a>
					</li>
				</xsl:if>
				<xsl:if test="ou:pcfparam('show-instagram') = 'true'">
					<li>
						<a href="{ou:pcfparam('instagram-icon')}" title="instagram"><span class="platform-name">instagram</span><i class="fa fa-instagram fa-2x" aria-hidden="true"></i></a>
					</li>
				</xsl:if>
				<xsl:if test="ou:pcfparam('show-snapchat') = 'true'">
					<li>
						<a href="{ou:pcfparam('snapchat-icon')}" title="snapchat"><span class="platform-name">snapchat</span><i class="fa fa-snapchat fa-2x" aria-hidden="true"></i></a>
					</li>
				</xsl:if>
				<xsl:if test="ou:pcfparam('show-youtube') = 'true'">
					<li>
						<a href="{ou:pcfparam('youtube-icon')}" title="youtube-play"><span class="platform-name">youtube-play</span><i class="fa fa-youtube-play fa-2x" aria-hidden="true"></i></a>
					</li>
				</xsl:if>
				<xsl:if test="ou:pcfparam('show-linkedin') = 'true'">
					<li>
						<a href="{ou:pcfparam('linkedin-icon')}" title="linkedin"><span class="platform-name">linkedin</span><i class="fa fa-linkedin fa-2x" aria-hidden="true"></i></a>
					</li>
				</xsl:if>
			</ul>
		</div>
	</xsl:template>

	<xsl:template name="page-content">
		<main id="content">
			<div class="container-fluid">
				<div class="container">
					<div class="row">
						<xsl:apply-templates select="ouc:div[@label='maincontent']"/>
						<xsl:call-template name="social-icons"/>
					</div>
				</div>
			</div>
		</main>
	</xsl:template>


</xsl:stylesheet>