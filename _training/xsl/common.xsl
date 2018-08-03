<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp   "&#160;">
<!ENTITY copy   "&#169;">
]>
<!-- 
Implementations Skeletor v3 - 4/7/2016
-
IMPLEMENTATION VARIABLES 
Define global implementation variables here, so that they may be accessed by all page types and in the info/debug tabs.
This also provides a convenient area for complicated logic to exist without clouding up the general xsl/html structure.
-
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

	<!--

OU CAMPUS SYSTEM PARAMETERS - don't edit 

-->
	<!-- Current Page Info -->
	<xsl:param name="ou:action"/>		<!-- Page 'state' in OU Campus 
(prv = Preview, pub = Publish, edt = Edit, cmp = Compare) -->
	<xsl:param name="ou:uuid"/>		<!-- Unique Page ID -->
	<xsl:param name="ou:path"/>		<!-- Root-relative path to page output -->
	<xsl:param name="ou:dirname"/>		<!-- Root-relative path to current folder (USE "dirname" BELOW INSTEAD) -->
	<xsl:param name="ou:filename"/>		<!-- Filename of output -->
	<xsl:param name="ou:created" as="xs:dateTime"/>		<!-- Page Creation date/time -->
	<xsl:param name="ou:modified" as="xs:dateTime"/> 	<!-- Last Page Modification date/time -->
	<xsl:param name="ou:feed"/>		<!-- Path (root-relative) to RSS Feed that's assigned to current page -->

	<!-- Staging Server Info -->
	<xsl:param name="ou:servername"/>	<!-- Staging Server's Domain Name -->
	<xsl:param name="ou:root"/>		<!-- Path from root of staging server -->
	<xsl:param name="ou:site"/>		<!-- Site Name (same as foldername on staging server) -->

	<!-- Production Server Info -->
	<xsl:param name="ou:target"/>		<!-- Name of Target Production Server -->
	<xsl:param name="ou:httproot"/>		<!-- Address of Target Production Server (from site settings) -->
	<xsl:param name="ou:ftproot"/>		<!-- Folder path to site root on Production Server (from site settings) -->
	<xsl:param name="ou:ftphome"/>		<!-- Initial subdirectory for site root on Production Server (from site settings) -->

	<!-- User Info -->
	<xsl:param name="ou:username"/>		<!-- Active user/publisher -->
	<xsl:param name="ou:lastname"/>		<!-- Active user/publisher -->
	<xsl:param name="ou:firstname"/> 	<!-- Active user/publisher -->
	<xsl:param name="ou:email"/>		<!-- Active user/publisher -->


	<!-- 

DIRECTORY VARIABLES (add "ou:" before variable name - in XSL only) 

Example: 
<xsl:param name="ou:theme-color" /> 
... Where "theme-color" is the actual Directory Variable name
-->

	<!-- for the following, all are set with start and end slash: /folder/ -->
	<xsl:param name="ou:breadcrumb-start"/> <!-- top level breadcrumb -->
	<xsl:param name="ou:theme-color" />

	<xsl:variable name="theme-color" select="if (string-length($ou:theme-color) gt 0) then $ou:theme-color else 'primary'" />
	<!-- 

GLOBAL VARIABLES - Implementation Specific 

-->
	<xsl:variable name="body-class" />	<!-- Stores a CSS class to be assigned to a wysiwyg region -->

	<!-- server information -->
	<xsl:variable name="server-type" select="'php'"/> 
	<xsl:variable name="index-file" select="'index'"/> 
	<xsl:variable name="extension" select="'html'"/> 	 

	<!-- for various concatenation purposes -->
	<xsl:variable name="dirname" select="if(string-length($ou:dirname) = 1) then $ou:dirname else concat($ou:dirname,'/')" />
	<xsl:variable name="domain" select="substring($ou:httproot,1,string-length($ou:httproot)-1)" /> 				
	<xsl:variable name="path" select="substring($ou:root,1,string-length($ou:httproot)-1)"/>

	<!-- navigation info -->
	<xsl:variable name="nav-file" select="'_nav.inc'" />

	<!-- section property files -->
	<xsl:variable name="props-file" select="'_props.pcf'"/> 	
	<xsl:variable name="props-path" select="concat($ou:root, $ou:site, $dirname, $props-file)"/>		

	<!-- page information -->
	<xsl:variable name="page-title" select="/document/ouc:properties/title" />

	<!-- Tags -->
	<xsl:variable name="page-tags" select="doc(concat('ou:/Tag/GetTags?site=', $ou:site, '&amp;path=', replace($ou:path, $extension, 'pcf')))/tags"/>

	<!-- Miscellaneous -->
	<xsl:variable name="nbsp"><xsl:text disable-output-escaping="yes">&nbsp;</xsl:text></xsl:variable>
	<xsl:variable name="amp"><xsl:text disable-output-escaping="yes">&amp;</xsl:text></xsl:variable>					


	<!-- Begin building your page here -->
	<xsl:template match="/document">

		<html lang="en">
			<head>
				<meta charset="utf-8"/>
				<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
				<title>Robert's | <xsl:value-of select="ouc:properties[@label='metadata']/title" /></title>
				<xsl:copy-of select="ouc:properties[@label='metadata']/meta" />

				<xsl:comment> This is an HTML comment! </xsl:comment>
				<!-- Bootstrap -->
				<!-- Latest compiled and minified CSS -->
				<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous"/>

				<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
				<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
				<xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 9]&gt;</xsl:text>
				<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
				<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
				<xsl:text disable-output-escaping="yes">&lt;![endif]--&gt;</xsl:text>
			</head>
			<body>		
				<div class="container">
					<xsl:call-template name="header" />

					<xsl:call-template name="content" />

					<div class="row bg-info">
						<div class="col-sm-4">
							<h3>OmniUpdate Training</h3>
							<address>
								1320 Flynn Road Suite 201<br />
								Camarillo, CA 93012
							</address>
						</div>
						<div class="col-sm-4">
							<h3>Footer Links 1</h3>
							<ul>
								<li><a href="#test1">Link Me</a></li>
							</ul>
						</div>
						<div class="col-sm-4">
							<h3>Footer Links 2</h3>
							<ul>
								<li><a href="#test2">Link Me</a></li>
							</ul>
						</div>
					</div>
				</div>
				<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
				<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
				<!-- Include all compiled plugins (below), or include individual files as needed -->
				<!-- Latest compiled and minified JavaScript -->
				<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
			</body>
		</html>

	</xsl:template>


	<xsl:template name="header">
		<div class="row bg-{$theme-color}">
			<div class="col-xs-12">
				<h1>Common - <xsl:value-of select="ouc:properties[@label='config']/parameter[@name='heading']" /></h1>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="content">
		<p>Fix your template!</p>
	</xsl:template>




	<!-- TEMPLATE RULES -->

	<!-- Wrapping an item -->
	<xsl:template match="iframe" mode="copy">
		<div class="responsive-iframe">
			<xsl:element name="{name()}">
				<xsl:apply-templates select="node()|attribute()" mode="copy"/>
			</xsl:element>
		</div>
	</xsl:template>

	<!-- Stripping an item -->
	<xsl:template match="font" mode="copy">
		<xsl:apply-templates select="node()" mode="copy" />
	</xsl:template>

	<xsl:template match="gallery" mode="copy">
		<h2>TEST</h2>
	</xsl:template>

	<xsl:template match="ouc:div" mode="copy">
		<xsl:choose>
			<xsl:when test="not($ou:action ='edt')">
				<xsl:apply-templates select="node()[not(name()='ouc:editor')]" mode="copy"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="node()|attribute()" mode="copy"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="table[@class='accordion']" mode="copy">
		<xsl:param name="id" select="position()" />
		
		<div class="panel-group" id="accordion_{$id}" role="tablist" aria-multiselectable="true">

			<xsl:for-each select="./tbody/tr">
				<xsl:variable name="pos" select="position()" />
				<div class="panel panel-default">
					<div class="panel-heading" role="tab" id="heading_{$id}_{$pos}">
						<h4 class="panel-title">
							<a role="button" data-toggle="collapse" data-parent="#accordion_{$id}" href="#collapse_{$id}_{$pos}" aria-expanded="{if ($pos = 1) then 'true' else 'false'}" aria-controls="collapse_{$id}_{$pos}">
								<xsl:value-of select="td[1]"/>
							</a>
						</h4>
					</div>
					<div id="collapse_{$id}_{$pos}" class="panel-collapse collapse {if ($pos = 1) then 'in' else ''}" role="tabpanel" aria-labelledby="heading_{$id}_{$pos}">
						<div class="panel-body">
							<xsl:apply-templates select="td[2]/node()" mode="copy" />
						</div>
					</div>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>
	
	<xsl:template match="table[@class='ou-accordion']" mode="copy">
		<xsl:param name="id" select="position()" />
		
		<div class="panel-group" id="accordion_{$id}" role="tablist" aria-multiselectable="true">
				<!-- mod  
					1 mod 2 = 1
					2 mod 2 = 0
					3 mod 2 = 1
-->
				
				<!-- idiv
					0 idiv 3 = 0	
					1 idiv 3 = 0
					2 idiv 3 = 0
					3 idiv 3 = 1
					4 idiv 3 = 1
					5 idiv 3 = 1
					6 idiv 3 = 2
-->
			<xsl:for-each select="./tbody/tr[position() mod 2 = 1]">
				<xsl:variable name="pos" select="position()" />
				<div class="panel panel-default">
					<div class="panel-heading" role="tab" id="heading_{$id}_{$pos}">
						<h4 class="panel-title">
							<a role="button" data-toggle="collapse" data-parent="#accordion_{$id}" href="#collapse_{$id}_{$pos}" aria-expanded="{if ($pos = 1) then 'true' else 'false'}" aria-controls="collapse_{$id}_{$pos}">
								<xsl:value-of select="td[1]"/>
							</a>
						</h4>
					</div>
					<div id="collapse_{$id}_{$pos}" class="panel-collapse collapse {if ($pos = 1) then 'in' else ''}" role="tabpanel" aria-labelledby="heading_{$id}_{$pos}">
						<div class="panel-body">
							<xsl:apply-templates select="following-sibling::tr[1]/td[1]/node()" mode="copy" />
						</div>
					</div>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<!-- More Axis directives ... https://our.umbraco.org/wiki/reference/xslt/xpath-axes-and-their-shortcuts/ 

	<xsl:if test="td/descendant::img"> returns true/false for existence 
-->

	<xsl:function name="ou:day-abbreviation">
		<xsl:param name="day" />
		<xsl:variable name="map">Monday:Mon;Tuesday:Tues;Wednesday:Wed;Thursday:Thur;Friday:Fri;Saturday:Sat;Sunday:Sun</xsl:variable>
		<xsl:value-of select="substring-after(tokenize($map,';')[contains(.,$day)], ':')" />
	</xsl:function>
	
	<xsl:function name="ou:tel-link">
		<xsl:param name="number" />
		
		<xsl:value-of select="concat('tel:+1', replace($number, '[\D]', ''))" />
	</xsl:function>
	
</xsl:stylesheet>
