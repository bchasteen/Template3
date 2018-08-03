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

	<xsl:template match="list/file">
		<xsl:param name="path" />
		<li>
			<a href="{concat($path,'/', .)}"><xsl:value-of select="."/></a>
		</li>
	</xsl:template>
	
	<xsl:template match="list/file[ends-with(.,'.pcf')]">
		<xsl:param name="path" />
		<xsl:variable name="file-path" select="concat($ou:root,$ou:site,$path,'/',.)" />
		<li>
			<a href="{concat($path,'/', replace(.,'.pcf', '.html'))}"><xsl:value-of select="if (doc-available($file-path)) then doc($file-path)/document/ouc:properties/title else ."/></a>
		</li>
	</xsl:template>


	<xsl:template match="list/directory">
		<xsl:param name="path" />
		<xsl:variable name="new-path" select="concat($path,'/',.)" />
		<li>
			<xsl:value-of select="."/>
			<ul>
				<xsl:apply-templates select="doc(concat($ou:root, $ou:site, $new-path))/list/element()">
					<xsl:with-param name="path" select="$new-path"/>
				</xsl:apply-templates>
			</ul>
		</li>
	</xsl:template>


	<xsl:template name="content">
		<div class="row">
			<div class="col-xs-12">
				<h2>Directory Listing</h2>
				<ul>
					<xsl:apply-templates select="doc(concat($ou:root, $ou:site, '/_training'))/list/element()">
						<xsl:with-param name="path" select="'/_training'"/>
					</xsl:apply-templates>
				</ul>
				
				<h2>Superheroes!</h2>
				<xsl:variable name="path">
					<xsl:choose>
						<xsl:when test="$ou:action = 'pub'">
							<xsl:value-of select="concat($domain, '/_training/xml/superheroes.xml')" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($ou:root, $ou:site, '/_training/xml/superheroes.xml')" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:try>
					<xsl:if test="$ou:action ='pub'">
						<p>Data Source:<xsl:value-of select="$path"/></p>
					</xsl:if>

					<xsl:variable name="superheroes" select="doc($path)" />
					<!-- doc-available() returns boolean result -->
					<!-- unparsed-text() returns text data from file -->
					<!-- unparsed-text-available() returns boolean result -->

					<xsl:choose>
						<xsl:when test="$ou:action = 'pub'">
							<xsl:processing-instruction name="php">

								$superheroes = array();

								<xsl:for-each select="$superheroes/superheroes/profile">
									$superheroes["<xsl:value-of select="name"/>"][] = "<xsl:value-of select="alias"/>";
								</xsl:for-each>

								echo print_r($superheroes);
								?</xsl:processing-instruction>
						</xsl:when>
						<xsl:otherwise>
							<p>PHP Code</p>
						</xsl:otherwise>
					</xsl:choose>


					<ul class="list-group">
						<xsl:apply-templates select="$superheroes/superheroes/profile">
							<xsl:sort select="@source" order="descending" />
							<xsl:sort select="name" />
						</xsl:apply-templates>
					</ul>

					<xsl:for-each-group select="$superheroes/superheroes/profile" group-by="@source">
						<xsl:sort select="current-grouping-key()" order="descending"/>

						<h3><xsl:value-of select="current-grouping-key()"/></h3>
						<table class="table table-striped">
							<thead>
								<tr>
									<xsl:for-each select="current-group()[1]/element()">
										<th><xsl:value-of select="upper-case(name())"/></th>
									</xsl:for-each>
								</tr>
							</thead>
							<tbody>
								<xsl:for-each select="current-group()">
									<tr>
										<xsl:for-each select="./element()">
											<td><xsl:value-of select="." /></td>
										</xsl:for-each>

									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</xsl:for-each-group>

					<xsl:for-each select="1 to 5">
						<xsl:variable name="pos" select="."/>
						<br /><xsl:value-of select="$superheroes/superheroes/profile[$pos]/name"/>
					</xsl:for-each>

					<xsl:catch><!-- ERROR -->
						<p>Could not open: <xsl:value-of select="$path"/></p>
					</xsl:catch>
				</xsl:try>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="superheroes/profile">
		<li>
			<span class="label label-danger"><xsl:value-of select="@source"/></span>
			<xsl:value-of select="./name"/> - <xsl:value-of select="alias"/>
		</li>
	</xsl:template>

	<xsl:template match="superheroes/profile[@source='DC']">
		<li>
			<span class="label label-warning"><xsl:value-of select="@source"/></span> 
			<xsl:value-of select="./name"/> - <xsl:value-of select="alias"/>
		</li>
	</xsl:template>
</xsl:stylesheet>