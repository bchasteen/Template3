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
	xmlns:ouc="http://omniupdate.com/XSL/Variables"
	xmlns:functx="http://www.functx.com"
	exclude-result-prefixes="ou xsl xs fn ouc">

	<!--
	The functx:substring-after-last function returns the part of $arg 
	that appears after the last occurrence of $delim. If $arg does not 
	contain $delim, the entire $arg is returned. If $arg is the empty 
	sequence, a zero-length string is returned.

	http://www.xsltfunctions.com/xsl/functx_substring-after-last.html
	-->
	<xsl:function name="functx:substring-after-last" as="xs:string">
		<xsl:param name="arg" as="xs:string?"/>
		<xsl:param name="delim" as="xs:string"/>

		<xsl:sequence select="replace ($arg,concat('^.*',functx:escape-for-regex($delim)),'')"/>
	</xsl:function>
	
	<!--
	The functx:substring-before-last function returns the part of $arg 
	that appears before the last occurrence of $delim. 
	If $arg does not contain $delim, a zero-length string is returned.

	http://www.xsltfunctions.com/xsl/functx_substring-before-last.html
	-->
	<xsl:function name="functx:substring-before-last" as="xs:string">
		<xsl:param name="arg" as="xs:string?"/>
		<xsl:param name="delim" as="xs:string"/>

		<xsl:sequence select="if(matches($arg, functx:escape-for-regex($delim))) then replace($arg, concat('^(.*)', functx:escape-for-regex($delim),'.*'), '$1') else '' "/>
	</xsl:function>
	
	<!-- 
	The functx:escape-for-regex function escapes a string that you wish to be taken 
	literally rather than treated like a regular expression. This is useful 
	when, for example, you are calling the built-in fn:replace function and 
	you want any periods or parentheses to be treated like literal characters rather 
	than regex special characters.
	
	http://www.xsltfunctions.com/xsl/functx_escape-for-regex.html
	-->
	<xsl:function name="functx:escape-for-regex" as="xs:string">
		<xsl:param name="arg" as="xs:string?"/>

		<xsl:sequence select="replace($arg,'(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')"/>
	</xsl:function>
	
	<!-- 
	The functx:is-value-in-sequence function returns a boolean value indicating whether or not an atomic value is equal 
	(based on typed values) to a value in the sequence. If $value or $seq is the empty sequence, it returns false.

	http://www.xsltfunctions.com/xsl/functx_is-value-in-sequence.html
	-->
	<xsl:function name="functx:is-value-in-sequence" as="xs:boolean">
		<xsl:param name="value" as="xs:anyAtomicType?"/>
		<xsl:param name="seq" as="xs:anyAtomicType*"/>

		<xsl:sequence select="$value = $seq"/>
	</xsl:function>
	
	<!--
	The functx:replace-element-values function takes a sequence of elements and 
	updates their values with the values specified in $values. It keeps all 
	the original attributes of the elements in tact. This is useful if you 
	would like to perform an operation on a sequence of elements, for example, 
	doubling them or taking a substring, without eliminating the elements 
	themselves. The two argument sequences are positionally related; i.e. the 
	first element in $elements takes on the first value in $values, the second 
	element takes on the second value, etc.

	http://www.xsltfunctions.com/xsl/functx_replace-element-values.html
	-->
	<xsl:function name="functx:replace-element-values" as="element()*">
		<xsl:param name="elements" as="element()*"/>
		<xsl:param name="values" as="xs:anyAtomicType*"/>

		<xsl:for-each select="$elements">
			<xsl:variable name="seq" select="position()"/>
			<xsl:element name="{node-name(.)}">
				<xsl:sequence select="@*, $values[$seq]"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:function>
	
	<!--
	The functx:value-except function returns the values in one sequence that do not 
	appear in the second sequence, in an implementation-defined order. It removes 
	duplicates, even among the values that appear only in the first sequence. This 
	function is useful because the built-in except operator only works on nodes, not 
	atomic values.

	http://www.xsltfunctions.com/xsl/functx_value-except.html
	-->
	<xsl:function name="functx:value-except" as="xs:anyAtomicType*">
		<xsl:param name="arg1" as="xs:anyAtomicType*"/>
		<xsl:param name="arg2" as="xs:anyAtomicType*"/>

		<xsl:sequence select="distinct-values($arg1[not( . = $arg2 )]) "/>
	</xsl:function>
</xsl:stylesheet>
