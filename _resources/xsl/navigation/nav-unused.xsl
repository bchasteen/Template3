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
Create an aphabetically sorted Navigation using the values either in _props.pcf(if it's an index) or the page properties.
Menu will be up to five levels deep.


Contributors: Bryan Chasteen
Last Updated: Enter Date Here
-->
<xsl:stylesheet 
	version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:ou="http://omniupdate.com/XSL/Variables" 
	xmlns:fn="http://omniupdate.com/XSL/Functions" 
	xmlns:ouc="http://omniupdate.com/XSL/Variables" 
	exclude-result-prefixes="ou xsl xs fn ouc">
	
	<!-- 
	Default files, directories and prefixes to ignore when creating listings 
	These parameters need to be in place for PCF files that do not have them.

	Certain directories should not be searched because either we don't want them to show up, 
	or they may not have a file with the 'breadcrumb' parameter.
	-->
	<xsl:variable name="ifiles" select="('robots.txt', 'index.pcf', 'index.html', 'search.pcf')"/>
	<xsl:variable name="idirs" select="('OMNI-ASSETS', 'images')"/>
	<xsl:variable name="iprefix" select="('_', '.')"/>
	
	<xsl:param name="ignore-dirs" select="if(normalize-space(ou:pcfparam('ignore-dirs'))) then ou:sequence(ou:pcfparam('ignore-dirs'), ',') else $idirs"/>
	<xsl:param name="ignore-files" select="if(normalize-space(ou:pcfparam('ignore-files'))) then ou:sequence(ou:pcfparam('ignore-files'), ',') else $ifiles"/>
	<xsl:param name="ignore-prefix" select="if(normalize-space(ou:pcfparam('ignore-prefix'))) then ou:sequence(ou:pcfparam('ignore-prefix'), ',') else $iprefix"/>
	<xsl:param name="directory-order" select="if(normalize-space(ou:pcfparam('directory-order'))) then ou:sequence(ou:pcfparam('directory-order'), ',') else false"/>
	
	<xsl:mode name="patch" on-no-match="shallow-copy"/>
	<xsl:mode name="copy" on-no-match="shallow-skip"/>
	
	<xsl:output method="html" indent="yes" encoding="UTF-8" include-content-type="no"/>
	<xsl:strip-space elements="*"/>
	
	<xsl:template name="page-content"/>

	<xsl:template match="ul/li//li/a" mode="copy">
		<strong><a href="{@href}" data-toggle="dropdown"><xsl:value-of select="text()"/></a></strong>
	</xsl:template>

	<xsl:template match="li/ul/li" mode="copy">
		<div class="col-sm-4">
			<xsl:apply-templates select="a"/>
			<xsl:if test="descendant::ul">
				<xsl:apply-templates select="ul"/>
			</xsl:if>
		</div>
	</xsl:template>
	
	<xsl:template match="li/ul" mode="copy">
		<ul class="dropdown-menu yamm-content">
			<li class="submenu-item">
			<xsl:apply-templates select="li" mode="copy"/>
			</li>
		</ul>
	</xsl:template>
	
	<xsl:template match="nav/ul" mode="patch">
		<xsl:for-each select="li">
			<li class="dropdown yamm-fullwidth">
				<xsl:if test="a">
					<a class="dropdown-toggle disabled" href="{a/@href}" data-toggle="dropdown"><xsl:value-of select="a/text()"/></a>
				</xsl:if>
				<xsl:if test="ul">
					<xsl:apply-templates select="ul" mode="copy"/>
				</xsl:if>
			</li>
		</xsl:for-each>
	</xsl:template>

	
	<xsl:template match="list/file">
		<xsl:param name="path" />
		<xsl:choose>
			<xsl:when test="ou:checkFile(.)">
				<li>
					<xsl:apply-templates select="ou:fileLink(concat($path, '/', ou:removeExt(.)), ou:removeExt(.))"/>
				</li>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>


	
	<xsl:template match="list/directory" mode="patch">
		<xsl:param name="path" />
		
		<xsl:variable name="new-path" select="concat($path,'/',.)" />
		<xsl:if test="ou:checkDirectory(.)">
			<li>
				<xsl:copy-of select="ou:fileLink($new-path, .)" />
				<ul>
					<xsl:apply-templates select="doc(concat($ou:root, $ou:site, $new-path))/list/element()">
						<xsl:with-param name="path" select="$new-path"/>
					</xsl:apply-templates>
				</ul>
			</li>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="siteNav2">
		<xsl:param name="currPath"/>
		<xsl:param name="rootRel"/>
		
		<ul>
			<xsl:apply-templates select="doc(concat($ou:root, $ou:site, $rootRel))/list" mode="patch">
				<xsl:with-param name="path" select="$rootRel"/>
			</xsl:apply-templates>
		</ul>
	</xsl:template>
	
	<!-- 

	Section Navigation: begin with current OU path and the root relative path.
	Get files and directories. List the files. For each directory, list the 
	directories and files and so forth for each subsequent directory up to 
	four levels deep.
	-->	
	<xsl:template name="sectionNav">
		<xsl:param name="currPath"/>
		<xsl:param name="rootRel"/>
		
		<ul>
			<xsl:apply-templates select="doc(concat($ou:root, $ou:site, $rootRel))/list/element()">
				<xsl:with-param name="path" select="$rootRel"/>
			</xsl:apply-templates>
		</ul>
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
	
	<!-- 
	OU returns XML all files and directories within a path with doc($docpath)/list.
	This function does the same thing, but using a filter to not return certain files/directories
	
	
	<file>filename1</file>
	<file>filename2</file>
	<directory>dirname1</directory>
	-->
	<xsl:function name="ou:listAll">
		<xsl:param name="docpath"/>
		
		<xsl:for-each select="doc($docpath)/list">
			<xsl:sort select="not(index-of($directory-order, .))"/>
			
			<xsl:for-each select="directory">
				<xsl:if test="ou:checkDirectory(.)">
					<xsl:apply-templates select="."/>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="file">
				<xsl:if test="ou:checkFile(.)">
					<xsl:apply-templates select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:function>
	
	<!-- Returns a listing of directories in the directory, with some ignored. Files will be returned as XML <directory>dirname</directory> -->
	<xsl:function name="ou:listDirs">
		<xsl:param name="docpath"/>
		
		
		<xsl:for-each select="doc($docpath)/list/directory">
			
			<xsl:sort select="index-of($directory-order, .)"/>
			
			<xsl:if test="ou:checkDirectory(.)">
				<xsl:apply-templates select="."/>	
			</xsl:if>
		</xsl:for-each>
	</xsl:function>
	
	<!-- Returns a listing of files in the directory, with some ignored. Files will be returned as XML <file>filename</file> -->
	<xsl:function name="ou:listFiles">
		<xsl:param name="docpath"/>
		
		<xsl:for-each select="doc($docpath)/list">
			<xsl:for-each select="file">
				<xsl:if test="ou:checkFile(.)">
					<xsl:apply-templates select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:function>
	
	<!-- Create list items for filenames in a Sequence (Array) -->
	<xsl:function name="ou:listItems">
		<xsl:param name="root"/>
		<xsl:param name="files"/>
		
		<xsl:for-each select="$files">
			<xsl:sort select="not(index-of($directory-order, .))"/>
			<xsl:if test="ou:checkFile(.)">
				<li>
					<xsl:copy-of select="ou:fileLink(concat($root, '/', ou:removeExt(.)), ou:removeExt(.))"/>
				</li>
			</xsl:if>
		</xsl:for-each>
	</xsl:function>
	
	<!-- Create divs for filenames in a Sequence (Array) -->
	<xsl:function name="ou:listItemDivs">
		<xsl:param name="root"/>
		<xsl:param name="files"/>
		<xsl:param name="class"/>
		
		<xsl:for-each select="$files">
			<xsl:if test="ou:checkFile(.)">
				<div class="{$class}">
					<xsl:copy-of select="ou:fileLink(concat($root, '/', ou:removeExt(.)), ou:removeExt(.))"/>
				</div>
			</xsl:if>
		</xsl:for-each>
	</xsl:function>
	
	<!-- Create a link using the page or sections props as name -->
	<xsl:function name="ou:fileLink">
		<xsl:param name="file"/>
		<xsl:param name="name"/>
		
		<xsl:variable name="title">
			<xsl:choose>
				<xsl:when test="doc-available(concat($ou:root, $ou:site, $file, '.pcf'))">
					<xsl:value-of select="doc(concat($ou:root, $ou:site, $file , '.pcf'))/document/ouc:properties[@label='config']/parameter[@name='breadcrumb']"/>
				</xsl:when>
				<xsl:when test="doc-available(concat($ou:root, $ou:site, $file , '/_props.pcf'))">
					<xsl:value-of select="doc(concat($ou:root, $ou:site, $file , '/_props.pcf'))/document/ouc:properties[@label='config']/parameter[@name='breadcrumb']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="boolean('false')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$title">
			<a href="{concat($file, '/')}"><xsl:value-of select="$title"/></a>
		</xsl:if>
	</xsl:function>
	
	<!-- Create a link using the page or sections props as name -->
	<xsl:function name="ou:fileLink">
		<xsl:param name="file"/>
		<xsl:param name="name"/>
		<xsl:param name="class"/>
		<xsl:param name="data-toggle"/>
		
		<xsl:variable name="title">
			<xsl:choose>
				<xsl:when test="doc-available(concat($ou:root, $ou:site, $file, '.pcf'))">
					<xsl:value-of select="doc(concat($ou:root, $ou:site, $file , '.pcf'))/document/ouc:properties[@label='config']/parameter[@name='breadcrumb']"/>
				</xsl:when>
				<xsl:when test="doc-available(concat($ou:root, $ou:site, $file , '/_props.pcf'))">
					<xsl:value-of select="doc(concat($ou:root, $ou:site, $file , '/_props.pcf'))/document/ouc:properties[@label='config']/parameter[@name='breadcrumb']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="boolean('false')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$title">
			<a class="{$class}" href="{concat($file, '/')}" data-toggle="{$data-toggle}">
				<xsl:value-of select="$title"/>
			</a>
		</xsl:if>
	</xsl:function>
</xsl:stylesheet>