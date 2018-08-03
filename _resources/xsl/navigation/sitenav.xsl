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
<xsl:stylesheet 
				version="3.0" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:xs="http://www.w3.org/2001/XMLSchema" 
				xmlns:ou="http://omniupdate.com/XSL/Variables" 
				xmlns:fn="http://omniupdate.com/XSL/Functions" 
				xmlns:functx="http://www.functx.com" 
				xmlns:ouc="http://omniupdate.com/XSL/Variables" 
				exclude-result-prefixes="ou xsl xs fn ouc functx">

	<xsl:import href="../_shared/common.xsl"/>

	<xsl:mode name="bootstrap" on-no-match="shallow-copy"/>
	<xsl:mode name="yamm-patch" on-no-match="shallow-copy"/>
	<xsl:mode name="yamm-copy" on-no-match="shallow-skip"/>

	<xsl:output method="html" version="4.0" indent="yes" encoding="UTF-8" include-content-type="no" omit-xml-declaration="yes"/>	
	<xsl:strip-space elements="*"/>

	<xsl:template name="page-content"/>

	<xsl:template match="ul/li//li/a" mode="yamm-copy">
		<strong><a href="{@href}" data-toggle="dropdown"><xsl:value-of select="text()"/></a></strong>
	</xsl:template>

	<xsl:template match="li/ul/li" mode="yamm-copy">
		<div class="col-sm-4">
			<xsl:apply-templates select="a"/>
			<xsl:if test="descendant::ul">
				<xsl:apply-templates select="ul"/>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="li/ul" mode="yamm-copy">
		<ul class="dropdown-menu yamm-content">
			<li class="submenu-item">
				<xsl:apply-templates select="li" mode="yamm-copy"/>
			</li>
		</ul>
	</xsl:template>

	<xsl:template match="ul" mode="yamm-patch">
		<xsl:for-each select="li">
			<li class="dropdown yamm-fullwidth">
				<xsl:if test="a">
					<a class="dropdown-toggle disabled" href="{a/@href}" data-toggle="dropdown"><xsl:value-of select="a/text()"/></a>
				</xsl:if>
				<xsl:if test="ul">
					<xsl:apply-templates select="ul" mode="yamm-copy"/>
				</xsl:if>
			</li>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="ouc:div[@label='maincontent']/ul" mode="bootstrap">
		<xsl:for-each select="li">
			<li>
				<xsl:if test="descendant::ul"><xsl:attribute name="class">dropdown</xsl:attribute></xsl:if>
				<xsl:choose>
					<xsl:when test="descendant::ul">
						<a tabindex="0" data-target="#" href="{a/@href}" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
							<xsl:apply-templates select="a/text()"/>
							<span class="caret"></span>
						</a>
						<ul class="dropdown-menu">
							<xsl:apply-templates select="ul/li"/>
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="a" />
					</xsl:otherwise>
				</xsl:choose>
			</li>
		</xsl:for-each>
	</xsl:template>

	<!-- Get rid of any stray paragraphs -->
	<xsl:template match="p" mode="yamm-patch"/>
	<xsl:template match="p" mode="bootstrap"/>

	<xsl:template match="/document">
		<xsl:call-template name="select-nav"/>
	</xsl:template>

	<xsl:template name="select-nav">
		<xsl:variable name="use-generated-nav" select="ou:pcfparam('use-generated-nav')"/>

		<nav class="navbar-menu  navbar navbar-inverse{if(ou:pcfparam('use-menu') = 'yamm') then ' yamm' else ''}" aria-label="Main Navigation" role="navigation">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-menubuilder"><span class="sr-only">Toggle navigation</span><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>
			</div>
			<div class="collapse navbar-collapse navbar-menubuilder">
				<ul class="nav navbar-nav navbar-collapsing">
					<xsl:choose>
						<xsl:when test="ou:pcfparam('use-menu') = 'yamm'">
							<xsl:call-template name="yamm-nav"><xsl:with-param name="use-generated-nav" select="$use-generated-nav"/></xsl:call-template>
						</xsl:when>
						<xsl:when test="ou:pcfparam('use-menu') = 'bootstrap'">
							<xsl:call-template name="bootstrap-nav"><xsl:with-param name="use-generated-nav" select="$use-generated-nav"/></xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="simple-nav"><xsl:with-param name="use-generated-nav" select="$use-generated-nav"/></xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</ul>
				<form accept-charset="UTF-8" action="/search" method="get" class="navbar-form navbar-left visible-xs">
					<div class="input-group">
						<label for="search-query" class="sr-only sr-only-focusable">Search by keyword(s)</label>
						<xsl:text disable-output-escaping="yes">&lt;input id="search-query" type="text" name="q" class="form-control" placeholder="search by keyword(s)" aria-label="search by keyword(s)"/&gt;</xsl:text>
						<span class="input-group-btn">
							<button id="search-button" type="submit" class="btn btn-default">
								<span class="glyphicon glyphicon-search" aria-hidden="true"></span>
								<span class="sr-only sr-only-focusable">Search</span>
							</button>
						</span>
					</div>
				</form>
			</div>
		</nav>
		<xsl:if test="$ou:action != 'pub'">
			<div class="bg-warning" style="padding:10px;border:1px solid #990">
				<h1 class="text-warning">About the Menu</h1>
				<p>This menu will provide a simple listing of the items on your website for a mega menu with SOME options. </p>
				<pre style="padding:10px 0;">&lt;ul&gt;
					&lt;li&gt;
					&lt;a href="/directory/"&gt;Directory&lt;/a&gt;
					&lt;ul&gt;
					&lt;li&gt;&lt;a href="/directory/faculty/"&gt;Faculty&lt;/a&gt;&lt;/li&gt;
					&lt;li&gt;&lt;a href="/directory/staff/"&gt;Staff&lt;/a&gt;&lt;/li&gt;
					&lt;/ul&gt;
					&lt;/li&gt;
					&lt;li&gt;
					&lt;a href="/events"&gt;Events&lt;/a&gt;
					&lt;/li&gt;
					&lt;/ul&gt;
				</pre>
			</div>
		</xsl:if>
		<xsl:try>
			<xsl:copy-of select="ouc:div[@label='autopublish']"/>
			<xsl:catch></xsl:catch>
		</xsl:try>
	</xsl:template>

	<xsl:template name="yamm-nav">
		<xsl:param name="use-generated-nav" select="'true'"/>

		<xsl:if test="$use-generated-nav = 'true'">
			<xsl:call-template name="yamm-sitenav"><xsl:with-param name="rootRel" select="''"/></xsl:call-template>
		</xsl:if>

		<xsl:try>
			<xsl:apply-templates select="ouc:div[@label='maincontent']" mode="yamm-patch"/>
			<xsl:catch></xsl:catch>
		</xsl:try>
	</xsl:template>

	<xsl:template name="bootstrap-nav">
		<xsl:param name="use-generated-nav" select="'true'"/>

		<xsl:if test="$use-generated-nav = 'true'">
			<xsl:call-template name="bootstrap-sitenav"><xsl:with-param name="rootRel" select="''"/></xsl:call-template>
		</xsl:if>

		<xsl:try>
			<xsl:apply-templates select="ouc:div[@label='maincontent']" mode="bootstrap" />
			<xsl:catch></xsl:catch>
		</xsl:try>
	</xsl:template>

	<xsl:template name="simple-nav">
		<xsl:param name="use-generated-nav" select="'true'"/>

		<xsl:if test="$use-generated-nav = 'true'">
			<xsl:call-template name="simple-sitenav"><xsl:with-param name="rootRel" select="''"/></xsl:call-template>
		</xsl:if>

		<xsl:try>
			<xsl:apply-templates select="ouc:div[@label='maincontent']" mode="bootstrap"/>
			<xsl:catch></xsl:catch>
		</xsl:try>
	</xsl:template>
</xsl:stylesheet>
