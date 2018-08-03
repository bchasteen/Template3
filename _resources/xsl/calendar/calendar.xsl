<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE stylesheet[
<!ENTITY nbsp   "&#160;">
]>
<!-- 
CALENDAR XSL

Contributors: Bryan Chasteen
Last Updated: Enter Date Here
-->
<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:ou="http://omniupdate.com/XSL/Variables" 
	xmlns:fn="http://omniupdate.com/XSL/Functions" 
	xmlns:functx="http://www.functx.com" 
	xmlns:ouc="http://omniupdate.com/XSL/Variables" 
	exclude-result-prefixes="ou xsl xs fn ouc functx">
	
	<xsl:mode name="calendar-scripts" on-no-match="shallow-skip" />
	
	<xsl:template match="calendar|calendar-only">
		<xsl:if test="$ou:action != 'pub'">
			<p style="padding:20px;border:3px black double" class="bg-info">
				<span style="font-size:22px" class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
				Calendar will display on publish.
			</p>
		</xsl:if>
		<div id="eitscalendar"></div>
	</xsl:template>
	
	<xsl:template match="calendar-events|calendar-events-only">
		<xsl:if test="$ou:action != 'pub'">
			<p style="padding:20px;border:3px black double" class="bg-info">
				<span style="font-size:18px" class="glyphicon glyphicon-list" aria-hidden="true"></span>
				Calendar Events will display on publish.
			</p>
		</xsl:if>
		<div id="eitscalendar-events"></div>
	</xsl:template>
	
	<xsl:template match="calendar|calendar-only|calendar-events-only" mode="calendar-scripts">
		<xsl:if test="$ou:action = 'pub'">
			<!-- 
			There are two types of parameters here: Javascript and PHP.
			The PHP parameters are passed to events.php via the URL.
			The Javascript parameters are put into an object and passed to the script via the Cal.init() function.
			-->
			<xsl:variable name="sort" select="if(normalize-space(@sort) != '') then concat('&amp;sort=', @sort) else '&amp;sort=desc'"/>
			<xsl:variable name="category" select="if(normalize-space(@category) != '') then concat('&amp;category=', @category) else ''"/>
			<xsl:variable name="searchby" select="if(normalize-space(@searchby) != '') then concat('&amp;searchby=', @searchby) else ''"/>
			<xsl:variable name="phpParams" select="concat($sort, $searchby, $category)"/>
			<xsl:variable name="ignore-attributes" select="('sort', 'feed', 'searchby', 'category')"/>

			<script src="/_resources/js/calendar/calendar.min.js"></script>
			<script src="/_resources/js/calendar/pagination.min.js"></script>
			<script>
				Cal.read("/_resources/js/calendar/events.php?feed=<xsl:value-of select="@feed"/><xsl:value-of select="$phpParams"/>", function(text){
				Cal.init({
				data :  JSON.parse(text),
				calendar : document.getElementById("eitscalendar"),
				events : document.getElementById("eitscalendar-events")
				<xsl:for-each select="@*[not(index-of($ignore-attributes, name()))]">
					<xsl:text>, </xsl:text>
					<xsl:choose>
						<xsl:when test="name() = 'eventStartDate'">
							<xsl:value-of select="name()"/> : new Date("<xsl:value-of select="."/>")
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="name()"/> : "<xsl:value-of select="."/>"
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>					
				});
				});
			</script>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="calendar-headcode">
		<xsl:if test="descendant::calendar|descendant::calendar-only|descendant::calendar-events-only"><link rel="stylesheet" href="{{f:18817503}}" /></xsl:if>
	</xsl:template>
	
	<xsl:template name="calendar-footcode">
		<xsl:if test="descendant::calendar|descendant::calendar-only|descendant::calendar-events-only"><xsl:apply-templates mode="calendar-scripts"/></xsl:if>
	</xsl:template>
</xsl:stylesheet>
