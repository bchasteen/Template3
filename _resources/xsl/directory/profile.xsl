<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
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
	xmlns:media="http://search.yahoo.com/mrss/"
	xmlns:functx="http://www.functx.com"
	exclude-result-prefixes="ou xsl xs fn ouc functx media">

	<xsl:import href="../_shared/common.xsl"/>
	<xsl:import href="../navigation/sidenav.xsl"/>
	
	<xsl:param name="news_feed" select="if(ou:pcfparam('rss-feed') != '') then ou:pcfparam('rss-feed') else '/_resources/rss/news.xml'"/>
	
	<xsl:template name="template-headcode"/>
	
	<xsl:template name="page-content">
		<main role="main">
			<a id="maincontent"></a>
			<div class="container interior">
				<div class="row">
					<article id="right-column" class="{if (ou:pcfparam('layout') != 'full-width') then 'col-md-9 col-sm-9 col-xs-12' else 'col-md-12'}">
						<xsl:call-template name="content"/>
					</article>
					<xsl:if test="ou:pcfparam('layout') != 'full-width'"><xsl:call-template name="side-nav"><xsl:with-param name="cols" select="3"/></xsl:call-template></xsl:if>
				</div>
			</div>
		</main>
	</xsl:template>
	
	<xsl:template name="content">
		<xsl:variable name="link" select="ou:removeExt(path)"/>
		<xsl:variable name="tags" select="ou:get-page-tags()/tag/name"/>
		<xsl:variable name="exclude-tags" select="ou:get-page-tags(concat($dirname, 'index.pcf'))/tag/name"/> <!-- Exclude section tags from side feed -->
		<xsl:variable name="name" select="profile/ouc:div[@label='name']/text()"/>
		<xsl:variable name="job-title" select="ou:split(profile/ouc:div[@label='job-title']/text(), ';')"/>
		<xsl:variable name="degrees" select="ou:split(profile/ouc:div[@label='degrees-held']/text(), ';')"/>
		<xsl:variable name="img" select="profile/ouc:div[@label='photo']/node()"/>
		<xsl:variable name="bio" select="profile/ouc:div[@label='bio']/node()"/>
		<xsl:variable name="cv" select="profile/ouc:div[@label='cv']/text()"/>
		<xsl:variable name="email" select="normalize-space(profile/ouc:div[@label='email']/text())"/>
		<xsl:variable name="phone" select="ou:split(profile/ouc:div[@label='phone-number']/text(), ';', 'phone')"/>
		<xsl:variable name="street" select="profile//ouc:div[@label='street']/text()"/>
		<xsl:variable name="room" select="profile//ouc:div[@label='room-number']/text()"/>
		
		<!-- GET NEWS ITEMS sharing this page's tags -->
		<xsl:variable name="news-list">
			<xsl:try>
				<xsl:for-each select="doc(concat($domain, $news_feed))/rss/channel/item/category">
					<xsl:if test="index-of($tags, .) and not(index-of($exclude-tags, .))">
						<li>
							<strong><a href="{../link/text()}"><xsl:value-of select="../title"/></a></strong><br/>
							<xsl:value-of select="ou:fixDate(../pubDate)"/>
						</li>
					</xsl:if>
				</xsl:for-each>
				<xsl:catch>News Feed not entered</xsl:catch>
			</xsl:try>
		</xsl:variable>
		
		<div class="row">
			<div class="{if(normalize-space($news-list) = '') then 'col-sm-12' else 'col-sm-9'}">
				<div class="profile-contact pull-left padd-right">
					<xsl:if test="$img"><xsl:apply-templates select="$img" /></xsl:if>
					<xsl:if test="$cv != ''"><p><a href="{$cv}">Curriculum Vitae</a></p></xsl:if>
					<xsl:if test="$email != '' or $phone != '' or $street != ''"><h2>Contact</h2></xsl:if>
					<address>
						<xsl:if test="$email != ''">Email: <a href="mailto: {$email}"><xsl:apply-templates  select="$email"/></a><br/></xsl:if>
						<xsl:if test="$phone != ''">Phone: <a href="tel:{$phone}"><xsl:apply-templates select="$phone"/></a><br/></xsl:if>
						<xsl:for-each select="$street"><xsl:value-of select="."/></xsl:for-each>
					</address>
					<xsl:apply-templates select="ouc:div[@label='other']"/>
				</div>
				<h1><xsl:value-of select="$name"/></h1>
				<p><strong><xsl:value-of select="$job-title"/></strong></p>
				<p><em><xsl:apply-templates select="$degrees"/></em></p>
				<xsl:apply-templates select="$bio"/>
				<xsl:apply-templates select="ouc:div[@label='maincontent']" />
			</div>
			<xsl:if test="normalize-space($news-list) != ''">
				<xsl:call-template name="news-articles"><xsl:with-param name="list" select="$news-list"/></xsl:call-template>
			</xsl:if>
		</div>
	</xsl:template>
		
	<xsl:template name="news-articles">
		<xsl:param name="list"/>
		<xsl:param name="tags"/>
		
		<div class="col-sm-3">
			<h2>Publications</h2>
			<xsl:choose>
				<xsl:when test="$ou:action = 'pub'">
					<xsl:processing-instruction name="php">
					require_once($_SERVER['DOCUMENT_ROOT'] . "/_resources/php/rss.php");
					$feed =  "<xsl:value-of select="$news_feed"/>";
					$tag = "<xsl:value-of select="string-join(ou:get-page-tags()/tag/name, ',')"/>";
						
					$options = [];
					$options["limit"] = <xsl:value-of select="if(ou:pcfparam('rss-limit') != '') then ou:pcfparam('rss-limit') else '0'" />;
					$options["images"] = false;
					$options["dates"] = true;
					$options["dateFormat"] = "F d, Y";
					$options["description"] = false;
						
					displayRSS( getRSScategory($feed, $tag), json_encode($options));
					?</xsl:processing-instruction>
				</xsl:when>
				<xsl:otherwise>
					<ul><xsl:copy-of select="$list"/></ul>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
</xsl:stylesheet>
