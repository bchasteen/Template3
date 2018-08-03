<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- 
	PURE XSL TRANSFORMATION WITHOUT OU TAGS

	MODE and POSITION EXAMPLE
	Creates a table transform given the following XML:
<document>
	<nums>
		<num>01</num>
		<num>02</num>
		<num>03</num>
		<num>04</num>
		<num>05</num>
		<num>06</num>
		<num>07</num>
		<num>08</num>
		<num>09</num>
		<num>10</num>
		<num>11</num>
		<num>12</num>
	</nums>
</document>
	-->
	<xsl:output omit-xml-declaration="yes" indent="yes"/>
	
	<!-- 
	When template rules are applied with the copy and thead nodes, 
	anything unmatched by the calls
	to these modes will be copied after the matches 
	-->
	<xsl:mode name="copy" on-no-match="shallow-copy" />
	<xsl:mode name="thead" on-no-match="shallow-copy" />
	
	<!-- Remove unwanted spaces -->
	<xsl:strip-space elements="*"/>

	<!-- Create the table for the transform and select where to put the contents -->
	<xsl:template match="/document">
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
				<style>
					body *{box-sizing: border-box;}
					h1{font-size:13px;font-family:sans-serif;}
					table { width: 300px;text-align:center;border-collapse:collapse;border:1px solid black;}
					table thead tr {background-color:black;}
					table thead tr th{color: white;border:2px solid gray;}
					table tbody tr td{padding:5px;border:1px solid black;}
					table tbody tr:nth-child(odd) td{background-color:#eee;}
				</style>
			</head>
			<body>
				<h1>We want to make sure you know that this is a table.</h1>
				<table>
					<thead><tr><xsl:apply-templates mode="thead"/></tr></thead>
					<tbody><xsl:apply-templates /></tbody>
				</table>
			</body>
		</html>
	</xsl:template>
	
	<!-- Collect garbage unmatched by our modes -->
	<xsl:template match="num"/>
	<xsl:template match="num" mode="thead"/>
	<xsl:template match="info | info/node()"/>
	
	<!-- Create columns using the first three nums  -->
	<xsl:template match="num[position() &lt; 4]" mode="thead">
		<th>
			<xsl:number/>
		</th>
	</xsl:template>
	
	<!-- 
	every third num will be selected and then we will apply templates to it and to 
	the next two siblings after it, making a row with three num selected 
	-->
	<xsl:template match="num[position() mod 3 = 1]">
		<xsl:variable name="pos" select="position()"/>
		<tr>
			<!-- the "following-sibling::*" with position() must start the numbering over -->
			<xsl:apply-templates mode="copy" select=". | following-sibling::*[position() &lt; 3]"/>
		</tr>
	</xsl:template>

	<!--
	This will match anything with a mode of copy (which is the previous match above)
	and put a td tag around it 
	-->
	<xsl:template match="num" mode="copy">
		<td><xsl:value-of select="."/></td>
	</xsl:template>
</xsl:stylesheet>