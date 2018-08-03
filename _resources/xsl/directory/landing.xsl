<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp   "&#160;">
]>
<!-- 
Kitchen Sink v2.4 - 2/14/2014

INTERIOR PAGE 
A simple pagetype.

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

	<xsl:import href="../_shared/common.xsl"/>
	<xsl:import href="../navigation/sidenav.xsl"/>

	<xsl:template name="template-headcode"/>

	<xsl:template name="page-content">
		<main role="main">
			<a id="maincontent"></a>
			<div class="container interior">
				<div class="row">
					
					<article id="right-column" class="{if (ou:pcfparam('layout') != 'full-width') then 'col-md-8 col-sm-8 col-xs-12' else 'col-md-12'}">
						<xsl:try>
							<h1><xsl:value-of select="$props-title"/></h1>
							<xsl:catch>Section Properties Breadcrumb is not set</xsl:catch>
						</xsl:try>

						<xsl:apply-templates select="/document/ouc:div[@label='maincontent']" />
						<xsl:variable name="tags" select="ou:get-page-tags()/tag/name"/>

						<table class="directory table table-striped">
							<thead><tr>
								<th>Name</th>
								<xsl:if test="ou:pcfparam('show-category') = 'true'"><th>Category</th></xsl:if>
								<th>Title</th>
								<th>Phone</th>
								<th>Email</th>
								<xsl:if test="ou:pcfparam('show-address') = 'true'">
									<th>Room&nbsp;#</th>
								</xsl:if>
								</tr></thead>
							<tbody>
								<xsl:for-each select="$tags">
									<xsl:sort select="name" order="ascending"/>
									<xsl:variable name="files" select="ou:get-files-with-all-tags(string-join(., ', '))"/>
									<xsl:variable name="current-tag" select = "."/>
									
									<xsl:for-each select="$files/page">
										<xsl:variable name="content" select="doc(concat($ou:root, $ou:site, path))/document"/>
										<xsl:variable name="page-tag" select="ou:get-page-tags(concat($ou:root, $ou:site, path))"/>
										<xsl:if test="$content/profile">
											<xsl:variable name="link" select="ou:removeExt(path)"/>
											<xsl:variable name="tags" select="ou:get-page-tags()/tag/name"/>
											<xsl:variable name="name" select="$content/profile/ouc:div[@label='name']/text()"/>
											<xsl:variable name="job-title" select="ou:split($content/profile/ouc:div[@label='job-title']/text(), ';')"/>
											<xsl:variable name="degrees" select="ou:split($content/profile/ouc:div[@label='degrees-held']/text(), ';')"/>
											<xsl:variable name="img" select="$content/profile/ouc:div[@label='photo']/node()"/>
											<xsl:variable name="bio" select="$content/profile/ouc:div[@label='bio']/node()"/>
											<xsl:variable name="cv" select="$content/profile/ouc:div[@label='cv']/text()"/>
											<xsl:variable name="email" select="normalize-space($content/profile/ouc:div[@label='email']/text())"/>
											<xsl:variable name="phone" select="ou:split($content/profile/ouc:div[@label='phone-number']/text(), ';', 'phone')"/>
											<xsl:variable name="street" select="$content/profile//ouc:div[@label='street']/text()"/>
											<xsl:variable name="room" select="$content/profile//ouc:div[@label='room-number']/text()"/>
											<tr>
												<td data-order="{lower-case(ou:lastName($name))}"><a href="{$link}"><xsl:value-of select="$name"/></a></td>
												<xsl:if test="ou:pcfparam('show-category') = 'true'">
													<td><xsl:value-of select="ou:capital($current-tag)"/></td>
												</xsl:if>
												<td><xsl:value-of select="$job-title"/></td>
												<td><a href="tel:{$phone}"><xsl:value-of select="$phone"/></a></td>
												<td><xsl:if test="$email != ''"><a href="mailto: {$email}"><xsl:value-of select="$email"/></a></xsl:if></td>
												<xsl:if test="ou:pcfparam('show-address') = 'true'">
													<td><xsl:value-of select="$street"/><xsl:text> </xsl:text><xsl:value-of select="$room"/></td>
												</xsl:if>
											</tr>
										</xsl:if>
									</xsl:for-each>
								</xsl:for-each>

							</tbody>
						</table>
					</article>
					<xsl:if test="ou:pcfparam('layout') != 'full-width'"><xsl:call-template name="side-nav"/></xsl:if>
				</div>
			</div>
		</main>
		</xsl:template>
	
</xsl:stylesheet>
