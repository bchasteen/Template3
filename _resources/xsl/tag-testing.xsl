<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY amp   "&#38;">
<!ENTITY copy   "&#169;">
<!ENTITY gt   "&#62;">
<!ENTITY hellip "&#8230;">
<!ENTITY laquo  "&#171;">
<!ENTITY lsaquo   "&#8249;">
<!ENTITY lsquo   "&#8216;">
<!ENTITY lt   "&#60;">
<!ENTITY nbsp   "&#160;">
<!ENTITY quot   "&#34;">
<!ENTITY raquo  "&#187;">
<!ENTITY rsaquo   "&#8250;">
<!ENTITY rsquo   "&#8217;">
]>
<!--
ADMIN UTILITY PAGE

Contributors: Bryan Chasteen
Last Updated: 10/05/2017
-->
<xsl:stylesheet version="3.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ou="http://omniupdate.com/XSL/Variables"
    xmlns:fn="http://omniupdate.com/XSL/Functions"
    xmlns:ouc="http://omniupdate.com/XSL/Variables"
    exclude-result-prefixes="ou xsl xs fn ouc">
							
	<xsl:import href="_shared/common.xsl"/>
	
	<xsl:variable name="ifiles" select="('robots.txt', 'index.pcf', 'index.html', 'search.pcf')"/>
	<xsl:variable name="idirs" select="('OMNI-ASSETS', 'images')"/>
	<xsl:variable name="iprefix" select="('_', '.')"/>
	
	<xsl:param name="ignore-dirs" select="if(normalize-space(ou:pcfparam('ignore-dirs'))) then ou:value-union($idirs, ou:sequence(ou:pcfparam('ignore-dirs'), ',')) else $idirs"/>
	<xsl:param name="ignore-files" select="if(normalize-space(ou:pcfparam('ignore-files'))) then ou:value-union($ifiles, ou:sequence(ou:pcfparam('ignore-files'), ',')) else $ifiles"/>
	<xsl:param name="ignore-prefix" select="if(normalize-space(ou:pcfparam('ignore-prefix'))) then ou:sequence(ou:pcfparam('ignore-prefix'), ',') else $iprefix"/>
	<xsl:param name="directory-order" select="if(normalize-space(ou:pcfparam('directory-order'))) then ou:sequence(ou:pcfparam('directory-order'), ',') else 'false'"/>
	
	
	<xsl:template name="template-headcode"/>
	<xsl:template name="template-footcode"/>
	<xsl:template name="page-content"/> 
	
	<xsl:template match="/document">
		<html>
			<head>
				<title>Tag Testing</title>
			</head>
			<body>
				<h3>Tags</h3>
				<p>Returns all tags that have been created in the site, shows whether the tag has been disabled, and lists if the tag has any children (which means it's a collection).</p>
				<ul>
					<xsl:apply-templates select="ou:get-all-tags()"/>
				</ul>
				
				
				<h3>Pages with Tags</h3>
				<ul>
					<xsl:apply-templates select="doc(concat($ou:root, $ou:site, ''))/list">
						<xsl:with-param name="path" select="''"/>
					</xsl:apply-templates>
				</ul>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="tags">
		<xsl:apply-templates select="tag"/>
	</xsl:template>

	<xsl:template match="tag">
		<li>Name="<xsl:value-of select="name"/>", Disabled=<xsl:value-of select="disabled"/><xsl:apply-templates select="children" /></li>
	</xsl:template>

	<xsl:template match="tag" mode="list">
		<xsl:param name="path" select="''"/>
		
		<xsl:text> </xsl:text><a href="#{name}"><xsl:value-of select="name"/></a>,
	</xsl:template>
	
	<xsl:template match="children">
		<xsl:choose>
			<xsl:when test="xs:integer(.) gt 0">
				, This tag is a collection. Children=<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="pages">
		<p><xsl:apply-templates select="page"/></p>
	</xsl:template>

	<xsl:template match="page">
		<xsl:variable name="pubdate">
			<xsl:copy-of select="last-pub-date/node()"/>
		</xsl:variable>
		Path="<xsl:value-of select="path"/>" Last Published Date=<xsl:value-of select="format-dateTime($pubdate, '[M01]/[D01]/[Y0001] at [h1]:[m1] [P]')"/><br/>
	</xsl:template>

	<xsl:template match="list/file">
		<xsl:param name="path" />
		<xsl:choose>
			<xsl:when test="ou:checkFile(.)">
				<li>
					<xsl:value-of select="concat($path, '/', .)"/><br/>
					<xsl:apply-templates select="ou:get-combined-tags(concat($path, '/', .))/tag" mode="list">
						<xsl:with-param name="path" select="$path"/>
					</xsl:apply-templates>
				</li>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="list/directory">
		<xsl:param name="path" />
		
		<xsl:variable name="new-path" select="concat($path,'/',.)" />
		<xsl:if test="ou:checkDirectory(.)">
			<li>
				<xsl:value-of select="."/>
				<xsl:apply-templates select="ou:get-combined-tags(concat($path, '/', .))/tag" mode="list">
					<xsl:with-param name="path" select="$path"/>
				</xsl:apply-templates>
				<ul>
					<xsl:apply-templates select="doc(concat($ou:root, $ou:site, $new-path))/list/element()">
						<xsl:with-param name="path" select="$new-path"/>
					</xsl:apply-templates>
				</ul>
			</li>
		</xsl:if>
	</xsl:template>
	
	<!-- Check a directory to see if it is not in the ignore list.  Returns true or false -->
	<xsl:function name="ou:checkDirectory" as="xs:boolean">
		<xsl:param name="dir"/>
		
		<xsl:value-of select="if(not(index-of($ignore-prefix, substring($dir, 1, 1))) and not(index-of($ignore-dirs, $dir))) then 'true' else 'false'"/>
	</xsl:function>
	
	<!-- Check a file to see if it is not in the ignore list.  Returns true or false -->
	<xsl:function name="ou:checkFile" as="xs:boolean">
		<xsl:param name="file"/>
		
		<xsl:value-of select="if(not(index-of($ignore-prefix, substring($file, 1, 1))) and not(index-of($ignore-files, $file))) then 'true' else 'false'"/>
	</xsl:function>
</xsl:stylesheet>