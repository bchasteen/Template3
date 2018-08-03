<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE stylesheet[
<!ENTITY nbsp   "&#160;">
]>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ou="http://omniupdate.com/XSL/Variables" xmlns:fn="http://omniupdate.com/XSL/Functions" xmlns:functx="http://www.functx.com" xmlns:ouc="http://omniupdate.com/XSL/Variables" exclude-result-prefixes="ou xsl xs fn ouc functx">
	<xsl:import href="../_shared/common.xsl"/>	
	<xsl:import href="../navigation/sidenav.xsl"/>
	
	<xsl:template name="page-content">
		<main role="main">
			<a id="maincontent"></a>
			<div class="container interior">
				<div class="row">
					<article id="right-column" class="{if (ou:pcfparam('layout') != 'full-width') then 'col-md-8 col-sm-8 col-xs-12' else 'col-md-12'}">
						<xsl:if test="ou:pcfparam('breadcrumb') != ''">
							<h1><xsl:value-of select="ou:pcfparam('breadcrumb')"/></h1>
						</xsl:if>
						<xsl:apply-templates select="*[@label='maincontent']"/>
					</article>
					<xsl:if test="ou:pcfparam('layout') != 'full-width'"><xsl:call-template name="side-nav"/></xsl:if>
				</div>
			</div>
		</main>
	</xsl:template>
	
</xsl:stylesheet>
