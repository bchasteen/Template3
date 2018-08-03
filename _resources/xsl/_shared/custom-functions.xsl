<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<!-- 
Custom functions from http://www.xsltfunctions.com/xsl/
-->
<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ou="http://omniupdate.com/XSL/Variables"
	xmlns:fn="http://omniupdate.com/XSL/Functions"
	xmlns:functx="http://www.functx.com"
	xmlns:ouc="http://omniupdate.com/XSL/Variables"
	exclude-result-prefixes="ou xsl xs fn ouc">

	<!-- 
		FIND WHETHER A PAGE HAS A TAG ASSOCIATED WITH IT
		(Dependency on functx:is-value-in-sequence() being installed)
	-->
	<xsl:function name="ou:findByTags" as="xs:boolean">
		<!--	<xsl:value-of select="doc(concat($ou:root, $ou:site, encode-for-uri(path)))/document/ouc:properties[@label='metadata']/title[@name='breadcrumb']" /> -->
		<xsl:param name="tag"/>
		<xsl:param name="file"/>
				
		<xsl:variable name="encoded-name" select="encode-for-uri($tag)"/>
		<xsl:variable name="link" select="concat('/', replace($file, $ou:httproot, ''))"/>
		<xsl:variable name="paths" select="doc(concat('ou:/Tag/GetFilesWithAnyTags?site=', $ou:site, '&amp;tag=', $encoded-name))//path" />
		
		<!-- Search for needle in haystack, replacing the $link's current extension with '.pcf' for searching the paths returned by ou:/Tag -->
		<xsl:value-of select="functx:is-value-in-sequence(replace($link, concat('.', ou:getExt($link)), '.pcf'), $paths)"/>
	</xsl:function>
	
	<!--
	Returns a sequence (Array) with empty values removed
	@param val string 
	-->
	<xsl:function name="ou:sequence">
		<xsl:param name="val"/>
		<xsl:param name="delim"/>
		
		<xsl:sequence>
			<xsl:for-each select="tokenize($val, $delim)[not(normalize-space(.) = '')]">
				<xsl:value-of select="normalize-space(.)"/>
			</xsl:for-each>
		</xsl:sequence>
	</xsl:function>
	
	<!-- Returns a sequence of a tokenized Root-relative directory with empty values removed -->
	<xsl:function name="ou:urlSequence">
		<xsl:param name="dir"/>
		
		<xsl:sequence select="tokenize($dir, '/')[normalize-space(.) != '']"/>
	</xsl:function>
	
	<!-- 
	GET FILE NAME MINUS DIRECTORY NAME
	-->
	<xsl:function name="ou:basename">
		<xsl:param name="path"/>
		<xsl:variable name="arr" select="tokenize($path, '/')"/>
		<xsl:value-of select="$arr[last()]"/>
	</xsl:function>
	
	<!--
	GET LAST NAME
	-->
	<xsl:function name="ou:lastName">
		<xsl:param name="name"/>
		<xsl:variable name="arr" select="tokenize($name, ' ')"/>
		<xsl:value-of select="$arr[last()]"/>
	</xsl:function>
	
	<!-- 
	GET FILE EXTENSION
	-->
	<xsl:function name="ou:getExt">
		<xsl:param name="filename"/>
		<xsl:value-of select="substring-after($filename, '.')"/>
	</xsl:function>
	
	<!-- 
	SET FILE EXTENSION
	-->
	<xsl:function name="ou:setExt">
		<xsl:param name="filename"/>
		<xsl:param name="ext"/>
		<xsl:variable name="first">
			<xsl:value-of select="substring-before($filename, '.')"/>
		</xsl:variable>
		<xsl:value-of select="concat($first, '.', $ext)"/>
	</xsl:function>
	
	<!-- 
	REMOVE FILE EXTENSION
	-->
	<xsl:function name="ou:removeExt">
		<xsl:param name="filename"/>
		<xsl:value-of select="substring-before($filename, '.')"/>
	</xsl:function>
	
	<!-- 
	REPLACE SEMICOLON (OR ANY OTHER SPECIFIED DELIMITER) WITH <BR/> IN TEXT
	-->
	<xsl:function name="ou:split">
		<xsl:param name="text"/>
		<xsl:param name="delim"/>
		
		<xsl:variable name="line" select="tokenize($text, $delim)"/>
		
		<xsl:for-each select="$line">
			<xsl:value-of select="normalize-space(.)"/><br/>
		</xsl:for-each>
	</xsl:function>
	
	<!-- 
	FORMAT PHONE NUMBERS
	-->
	<xsl:function name="ou:split">
		<xsl:param name="text"/>
		<xsl:param name="delim"/>
		<xsl:param name="type"/>
		
		<xsl:variable name="line" select="tokenize($text, $delim)"/>
		<xsl:for-each select="$line">
			<xsl:variable name="val" select="normalize-space(.)"/>
			<xsl:choose>
				<!-- Format for phone number -->
				<xsl:when test="$type = 'phone'">
					<xsl:variable name="plain" select="replace($val, '[^\d]', '')"/>
					<a href="tel: {$plain}"><xsl:value-of select="$val"/></a><br/>
				</xsl:when>
				
				<!-- If type not found, format as text -->
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($val)"/><br/>	
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:function>
	
	<!-- CUSTOM DATE FUNCTIONS -->
	<xsl:function name="ou:monthNum2">
		<xsl:param name="monthName" />	
		<xsl:variable name="months" select="('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')" />
		<xsl:value-of select="ou:doubleDigit(index-of($months, substring($monthName, 1, 3)))" />
	</xsl:function>
	
	<!-- fix the date!!!! -->
	<xsl:function name="ou:fixDate">
		<xsl:param name="pubDate"/>
		
		<xsl:variable name="tokenDate" select="tokenize(string($pubDate), ' ')"/>
		<xsl:variable name="date" select="concat($tokenDate[4], '-', ou:monthNum2($tokenDate[3]), '-', ou:doubleDigit($tokenDate[2]))"/>
		<xsl:variable name="time" select="$tokenDate[5]"/>
		<xsl:variable name="timeZone" select="$tokenDate[6]"/>
		
		<xsl:variable name="dateTime" select="dateTime(xs:date($date), xs:time(concat($time, 'Z')))" />
		<xsl:variable name="dayName" select="format-dateTime($dateTime, '[F]')"/>
		<xsl:variable name="day" select="format-dateTime($dateTime, '[D1]')"/>
		<xsl:variable name="month" select="format-dateTime($dateTime, '[M1]')"/>
		<xsl:variable name="year" select="format-dateTime($dateTime, '[Y0001]')"/>
		<xsl:try>
			<xsl:value-of select="concat(ou:monthName($month),' ',$day,', ',$year)" />
			<xsl:catch />
		</xsl:try>
	</xsl:function>
	
	<!-- format date as YYYY-MM-DDTHH:MM:SSZ -->
	<xsl:function name="ou:dateAsYMD">
		<xsl:param name="pubDate"/>
		
		<xsl:variable name="tokenDate" select="tokenize(string($pubDate), ' ')"/>
		<xsl:variable name="date" select="concat($tokenDate[4], '-', ou:monthNum2($tokenDate[3]), '-', ou:doubleDigit($tokenDate[2]))"/>
		<xsl:variable name="time" select="$tokenDate[5]"/>
		<xsl:variable name="timeZone" select="$tokenDate[6]"/>
		
		<xsl:variable name="dateTime" select="dateTime(xs:date($date), xs:time(concat($time, 'Z')))" />
		<xsl:variable name="dayName" select="format-dateTime($dateTime, '[F]')"/>
		<xsl:variable name="day" select="format-dateTime($dateTime, '[D1]')"/>
		<xsl:variable name="month" select="format-dateTime($dateTime, '[M1]')"/>
		<xsl:variable name="year" select="format-dateTime($dateTime, '[Y0001]')"/>
		<xsl:try>
			<xsl:value-of select="concat($year,'-',$month,'-',$day,'T',$time,'Z')" />
			<xsl:catch />
		</xsl:try>
	</xsl:function>
	
	<!--11.08.15-->
	<xsl:function name="ou:prettyDate">
		<xsl:param name="str" />
		<xsl:variable name="dateTime" select="ou:toDateTime($str)"/>
		<xsl:variable name="dayName" select="format-dateTime($dateTime, '[F]')"/>
		<xsl:variable name="day" select="format-dateTime($dateTime, '[D1]')"/>
		<xsl:variable name="month" select="format-dateTime($dateTime, '[M1]')"/>
		<xsl:variable name="year" select="format-dateTime($dateTime, '[Y0001]')"/>
		<xsl:try>
			<xsl:value-of select="concat(ou:monthName($month),' ',$day,', ',$year)" />
			<xsl:catch />
		</xsl:try>
	</xsl:function>
	
</xsl:stylesheet>
