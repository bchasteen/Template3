<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<!-- 
Implementations Skeletor v3 - 5/10/2014

FUNCTIONS 
Repository of active functions
See GIT for more functions

Variable Dependencies: (see vars xsl)
$server-type

Contributors: Your Name Here
last Updated: Enter Date Here
-->
<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ou="http://omniupdate.com/XSL/Variables"
	xmlns:fn="http://omniupdate.com/XSL/Functions"
	xmlns:ouc="http://omniupdate.com/XSL/Variables"
	exclude-result-prefixes="ou xsl xs fn ouc">

	<!--
	ou:includeFile()
	The following function takes in two parameters
	(directory name and file name) and outputs the 
	proper code to include the file on the page.
	-->
	<xsl:function name="ou:includeFile">
		<!-- directory name + file name -->
		<xsl:param name="fullpath" />
		<!-- on publish, it will output the proper SSI code, but on staging we require the omni div tag -->
		<xsl:choose>
			<xsl:when test="$ou:action = 'pub'">
				<xsl:copy-of select="ou:ssi($fullpath)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment> ouc:div label="<xsl:value-of select="$fullpath"/>" path="<xsl:value-of select="$fullpath"/>"</xsl:comment> <xsl:comment> /ouc:div </xsl:comment> 
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<xsl:function name="ou:ssi">
		<xsl:param name="fullpath"/>
		<xsl:if test="$ou:action = 'pub'">
			<xsl:processing-instruction name="php"> include($_SERVER['DOCUMENT_ROOT'] . "<xsl:value-of select="$fullpath" />"); ?</xsl:processing-instruction>
		</xsl:if>
	</xsl:function>
	
	<!-- function that is the full include path to a script -->
	<xsl:function name="ou:ssi-full">
		<xsl:param name="fullpath"/>
		<!-- example of c#, read file in as a string and display the content from two levels, you might have to change if you go up a different amount of levels -->
		<!-- <xsl:text disable-output-escaping="yes">&lt;% </xsl:text> 
			wwwftproot = @"<xsl:value-of select="$ou:www-ftproot"/>";
			fullpath = @"<xsl:value-of select="$fullpath"/>";
			root = Server.MapPath("~");
			parent = System.IO.Path.GetDirectoryName(root);
			grandParent = System.IO.Path.GetDirectoryName(System.IO.Path.GetDirectoryName(parent));
			global = string.Concat(grandParent,wwwftproot, fullpath);
			contents = System.IO.File.ReadAllText(global);
			Response.Write(contents);
		<xsl:text disable-output-escaping="yes">%&gt;</xsl:text> -->
		<xsl:processing-instruction name="php"> include("<xsl:value-of select="$fullpath" />"); ?</xsl:processing-instruction>
	</xsl:function>
	
	<!-- 
	Grab file from production on staging and output a server side include on publish 
	-->
	<xsl:template name="include-file">
		<xsl:param name="path"/>
		
		<xsl:try>
			<xsl:choose>
				<xsl:when test="not($ou:action = 'pub')">
					<xsl:apply-templates select="doc(concat($domain, $path))"/>
				</xsl:when>
				<xsl:otherwise><xsl:copy-of select="ou:ssi($path)" /></xsl:otherwise>
			</xsl:choose>	
			<xsl:catch>
				<xsl:if test="not($ou:action = 'pub')">
					<p><xsl:value-of select="concat('File not available. Please make sure the path ( ' , concat($domain, $path),' ) is correct and the file is published.')" /></p>
				</xsl:if>
			</xsl:catch>
		</xsl:try>
	</xsl:template>
	
	<!-- 
	Grab file from production on staging and output a server side include on publish 
	-->
	<xsl:template name="unparsed-include-file">
		<xsl:param name="path"/>
		
		<xsl:try>
			<xsl:choose>
				<xsl:when test="not($ou:action = 'pub')">
					<xsl:value-of select="doc(concat($domain, $path))" disable-output-escaping="yes"/>
				</xsl:when>
				<xsl:otherwise><xsl:copy-of select="ou:ssi($path)" /></xsl:otherwise>
			</xsl:choose>	
			<xsl:catch>
				<xsl:if test="not($ou:action = 'pub')">
					<p><xsl:value-of select="concat('File not available. Please make sure the path ( ' , concat($domain, $path),' ) is correct and the file is published.')" /></p>
				</xsl:if>
			</xsl:catch>
		</xsl:try>
	</xsl:template>
	
	<!-- 
	PCF PARAMS
	An extremely useful function for getting page properties without needing to type the full xpath.
	How to use:
	The pcf has a parameter, name="pagetype". To get the value and store it in an XSL param : 
	<xsl:param name="pagetype" select="ou:pcfparam('pagetype')"/> 
	Use wherever you need it
	-->
	<xsl:param name="pcfparams" select="/document/descendant::parameter"/> <!-- save all page properties in a variable -->

	<xsl:function name="ou:pcfparam">
		<xsl:param name="name"/>
		<xsl:variable name="parameter" select="$pcfparams[@name=$name]"/>
		<xsl:choose>
			<xsl:when test="$parameter/@type = 'select' or $parameter/@type = 'radio'">
				<xsl:value-of select="$parameter/option[@selected = 'true']/@value"/>
			</xsl:when>
			<xsl:when test="$parameter/@type = 'checkbox'">
				<xsl:copy-of select="$parameter/option[@selected = 'true']/@value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="normalize-space($parameter/text())"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- 
	SECTION PARAMS
	An extremely useful function for getting page properties without needing to type the full xpath.
	How to use:
	The _props.pcf has a parameter, name="pagetype". To get the value and store it in an XSL param : 
	<xsl:param name="pagetype" select="ou:sectionparam('pagetype')"/> 
	Use wherever you need it
	-->
	<xsl:param name="sectionparams" select="doc($props-path)/descendant::parameter"/> <!-- save all page properties in a variable -->

	<xsl:function name="ou:sectionparam">
		<xsl:param name="name"/>
		<xsl:variable name="parameter" select="$sectionparams[@name=$name]"/>
		<xsl:try>
			<xsl:choose>
				<xsl:when test="$parameter/@type = 'select' or $parameter/@type = 'radio'">
					<xsl:value-of select="$parameter/option[@selected = 'true']/@value"/>
				</xsl:when>
				<xsl:when test="$parameter/@type = 'checkbox'">
					<xsl:copy-of select="$parameter/option[@selected = 'true']/@value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($parameter/text())"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:catch></xsl:catch>
		</xsl:try>
	</xsl:function>
	<!-- 
	ASSIGN VARIABLE
	Concisely assign fallback variables to prevent unexpected errors in development and post implementation.
	
	How to use:
	<xsl:param name="galleryType" select="ou:assignVariable('galleryType','PrettyPhoto')"/>	
	<xsl:variable name="navfile" select="ou:assignVariable('page-nav',$ou:navigation,$local-nav)"/>
	
	Third parameter may be a string or variable. The first parameter must always be a string, as required by the pcfparam function.
	
	Second version requires overwriteDirectory variable, which is typically defined in vars xsl.
	
	<xsl:variable name="overwriteDirectory" select="ou:assignVariable('overwriteDirectory','no')"/> 
	
	
	Note: requires the function ou:pcfparams
	-->
	<xsl:function name="ou:assignVariable"> <!-- test if page property has value, give default value if none -->
		<xsl:param name="var"/>
		<xsl:param name="fallback"/>
		<xsl:variable name="pcf-var" select="ou:pcfparam($var)"/>
		<xsl:choose>	
			<xsl:when test="string-length($pcf-var) > 0"><xsl:value-of select="$pcf-var"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$fallback"/></xsl:otherwise>
		</xsl:choose>	
	</xsl:function>		
	
	<xsl:function name="ou:assignVariable"> <!-- pcf - dir var - fallback precedence, also tests if there is a value for each -->
		<xsl:param name="var"/>
		<xsl:param name="dir-var"/>
		<xsl:param name="fallback"/>
		<xsl:variable name="overwriteDirectory" select="ou:pcfparam('overwriteDirectory')"/>
		<xsl:variable name="pcf-var" select="ou:pcfparam($var)"/>
		<xsl:choose>	
			<xsl:when test="string-length($pcf-var) > 0 and $overwriteDirectory='yes'"><xsl:value-of select="$pcf-var"/></xsl:when>
			<xsl:when test="string-length($dir-var) > 0 and $dir-var!='[auto]'" ><xsl:value-of select="$dir-var"/></xsl:when> 
			<xsl:otherwise><xsl:value-of select="$fallback"/></xsl:otherwise>
		</xsl:choose>	
	</xsl:function>
		
	<!-- 
	TEST VARIABLE
	A simpler version of Assign Variable, if you are not dealing with page properties.
	-->		
	<xsl:function name="ou:testVariable"> <!-- test if variable has value, give default value if none -->
		<xsl:param name="var"/>
		<xsl:param name="fallback"/>
		<xsl:choose>	
			<xsl:when test="string-length($var) > 0"><xsl:value-of select="$var"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$fallback"/></xsl:otherwise>
		</xsl:choose>	
	</xsl:function>	
		
	<!--
	FIND PREVIOUS DIRECTORY
	Used by breadcrumbs xsl.
	-->
	<xsl:function name="ou:findPrevDir"> <!-- outputs parent directory path with trailing '/': /path/to/parent/ -->
		<xsl:param name="path" />
		<xsl:variable name="tokenPath" select="tokenize(substring($path, 2), '/')[if(substring($path,string-length($path)) = '/') then position() != last() else position()]" />
		<xsl:variable name="newPath" select="concat('/', string-join(remove($tokenPath, count($tokenPath)), '/') ,'/')"/>
		<xsl:value-of select="if($newPath = '//') then '/' else $newPath" />
	</xsl:function>
	
	<!--
	OUC MULTIEDIT
	Manually create multiedit button so that users can access multiedit, if no multiedit nodes are being copied (ie, value-of is used)
	-->		
	<xsl:function name="ou:multieditButton"> <!-- call function to activate the multiedit button in edit mode -->
		<xsl:if test="$ou:action='edt'">
			<ouc:div label="multiedit" group="everyone" button="hide"><ouc:multiedit /></ouc:div>
		</xsl:if>
	</xsl:function>

	<!--
	HAS CLASS
	boolean that returns whether an element contains a class, much like JQuery's hasClass function
	-->
	<xsl:function name="ou:hasClass">
		<xsl:param name="element"/>
		<xsl:param name="classname"/>
		<xsl:value-of select="boolean($element/@class) and contains(concat(' ', $element/@class, ' '), concat(' ', $classname, ' '))"/>
	</xsl:function>	
	
	<!--
	GET CURRENT FOLDER
	-->
	<xsl:function name="ou:current_folder">
		<xsl:param name="string"/>
		<xsl:variable name="chars" select="tokenize(substring-after($string,'/'), '/')"/>
		<xsl:for-each select="$chars">
			<xsl:if test="position()=last()">
				<xsl:variable name="result"><xsl:value-of select="."/></xsl:variable>
				<!-- <xsl:value-of select="ou:capital(replace($result,'-',' '))" /> -->
				<!-- copy the when statement for more cleaning options -->
				<xsl:choose>
					<xsl:when test="contains($result,'_')">
						<xsl:value-of select="ou:clean($result,'_')"/>
					</xsl:when>
					<xsl:when test="contains($result,'-')">
						<xsl:value-of select="ou:clean($result,'-')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ou:capital($result)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:function>
	
	<!--
	CAPITALIZE THE FIRST LETTER OF EVERY WORD
	-->
	<xsl:function name="ou:capital">
		<xsl:param name="string"/>
		<xsl:variable name="chars" select="tokenize($string, ' ')"/>
		<xsl:for-each select="$chars">
			<xsl:variable name="key"><xsl:value-of select="."/></xsl:variable>
			<xsl:variable name="firstletter1"><xsl:value-of select="upper-case(substring($key,1,1))" /></xsl:variable>
			<xsl:variable name="rest1"><xsl:value-of select="lower-case(substring($key,2))" /></xsl:variable>
			<xsl:variable name="result"><xsl:value-of select="concat($firstletter1,$rest1,' ')" /> </xsl:variable>
			<xsl:value-of select="$result" />
		</xsl:for-each>
	</xsl:function>
	
	<!--
	Clean content by replacing content with space
	-->
	<xsl:function name="ou:clean">
		<xsl:param name="string"/>
		<xsl:param name="deliminator"/>
		<xsl:variable name="chars" select="tokenize($string,$deliminator)"/>
		<xsl:for-each select="$chars">
			<xsl:variable name="key"><xsl:value-of select="."/></xsl:variable>
			<xsl:variable name="firstletter1"><xsl:value-of select="upper-case(substring($key,1,1))" /></xsl:variable>
			<xsl:variable name="rest1"><xsl:value-of select="lower-case(substring($key,2))" /></xsl:variable>
			<xsl:variable name="result"><xsl:value-of select="concat($firstletter1,$rest1,' ')" /> </xsl:variable>
			<xsl:value-of select="$result" />
		</xsl:for-each>
	</xsl:function>
	
	<xsl:function name="ou:doubleDigit">
		<xsl:param name="num"/>
		<xsl:value-of select="format-number(number($num), '00')"/>
	</xsl:function>
	
	<!--use format-dateTime() with ou:toDateTime eg: <xsl:value-of select="format-dateTime($dateTime, ', [D01] [M] [Y0001] [H01]:[m01]:[s01] [z]')"/>-->
	<xsl:function name="ou:toDateTime" as="xs:dateTime">
		<xsl:param name="pcfDate"/>
		<!--define time zone-->
		<xsl:variable name="timeZone" select="'-08:00'"/>
		<!--tokenize date from PCF, which uses datetime param-->
		<xsl:variable name="tokenDate" select="tokenize($pcfDate, ' ')"/>
		<!--calculate date depending on TCF or PCF dateTime-->
		<xsl:variable name="date">
			<xsl:choose>
				<xsl:when test="matches($pcfDate,'^\S+, \S+ \d{1,2}, \d{4} \d{1,2}:\d{2}:\d{2} [AP]M [A-Z]{3}$')">
					<!--TCF format 'Monday, January 26, 2015 2:13:39 PM PST' to '2015-01-26'-->
					<xsl:value-of select="concat($tokenDate[4], '-', ou:monthNum($tokenDate[2], 'long'), '-', ou:doubleDigit(substring-before($tokenDate[3], ',')))"/>
				</xsl:when>
				<xsl:when test="matches($pcfDate,'^\d{4}-\d{1,2}-\d{2}$')">
					<!--If format is YYYY-MM-DD, return date e.g. '2015-01-26'-->
					<xsl:value-of select="$pcfDate"/>
				</xsl:when>
				<!-- format Wed, 09 Dec 2015 00:00:00 -0500 -->
				<xsl:when test="matches($pcfDate, '^\S+, \d{1,} \S+ \d{4} \d{1,2}:\d{2}:\d{2} -\d{3,}$')">
					<xsl:value-of select="concat($tokenDate[4], '-', ou:monthNumA($tokenDate[3]), '-', ou:doubleDigit($tokenDate[2]))"/>
				</xsl:when>
				<xsl:otherwise>
					<!--PCF format '01/26/2015 08:26:39 PM' to '2015-01-26'-->
					<xsl:value-of select="concat(tokenize($tokenDate[1], '/')[3], '-', ou:doubleDigit(tokenize($tokenDate[1], '/')[1]), '-', ou:doubleDigit(tokenize($tokenDate[1], '/')[2]))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="time">
			<xsl:choose>
				<xsl:when test="matches($pcfDate,'^\S+, \S+ \d{1,2}, \d{4} \d{1,2}:\d{2}:\d{2} [AP]M [A-Z]{3}$')">
					<!--convert 'Monday, January 26, 2015 2:13:39 PM PST' to '2015-01-26'-->
					<xsl:value-of select="concat(ou:doubleDigit(if ($tokenDate[6] = 'PM' and number(tokenize($tokenDate[5], ':')[1]) &lt; 12) then number(tokenize($tokenDate[5], ':')[1]) + 12 else if ($tokenDate[6] = 'PM' and number(tokenize($tokenDate[5], ':')[1]) = 12) then '00' else tokenize($tokenDate[5], ':')[1]), ':', ou:doubleDigit(tokenize($tokenDate[5], ':')[2]), ':', ou:doubleDigit(tokenize($tokenDate[5], ':')[3]))"/>
				</xsl:when>
				<xsl:when test="matches($pcfDate,'^\d{4}-\d{1,2}-\d{2}$')">
					<xsl:value-of select="'12:00:00'"/>
				</xsl:when>
				<!-- format Wed, 09 Dec 2015 00:00:00 -0500 -->
				<xsl:when test="matches($pcfDate, '^\S+, \d{1,} \S+ \d{4} \d{1,2}:\d{2}:\d{2} -\d{3,}$')">
					<xsl:value-of select="$tokenDate[5]"/>
				</xsl:when>
				<xsl:otherwise>
					<!--convert '01/26/2015 08:26:39 PM' to '20:26:39'-->
					<xsl:value-of select="concat(ou:doubleDigit(if ($tokenDate[3] = 'PM' and number(tokenize($tokenDate[2], ':')[1]) &lt; 12) then number(tokenize($tokenDate[2], ':')[1]) + 12 else if ($tokenDate[3] = 'PM' and number(tokenize($tokenDate[2], ':')[1]) = 12) then '00' else tokenize($tokenDate[2], ':')[1]), ':', ou:doubleDigit(tokenize($tokenDate[2], ':')[2]), ':', ou:doubleDigit(tokenize($tokenDate[2], ':')[3]))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--new object xs:dateTime('2015-01-01T20:26:39-08:00')-->
		<xsl:value-of select="dateTime(xs:date($date), xs:time(concat($time, $timeZone)))" />
	</xsl:function>
	
	<xsl:function name="ou:monthName">
		<xsl:param name="monthNum" />
		<xsl:value-of select="ou:monthName($monthNum,'long')" />	
	</xsl:function>
	
	<xsl:function name="ou:monthName">
		<xsl:param name="monthNum" />
		<xsl:param name="length" />
		<xsl:variable name="months" select="('January','February','March','April','May','June','July','August','September','October','November','December')" />
		<xsl:variable name="months-short" select="('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')" />
		<xsl:value-of select="if($length = 'short') then $months-short[number($monthNum)] else $months[number($monthNum)]" />
	</xsl:function>
	
	<xsl:function name="ou:monthNum">
		<xsl:param name="monthName" />
		<xsl:value-of select="ou:monthNum($monthName,'long')" />	
	</xsl:function>
	
	<xsl:function name="ou:monthNum">
		<xsl:param name="monthName" />
		<xsl:param name="length" />
		<xsl:variable name="months" select="('January','February','March','April','May','June','July','August','September','October','November','December')" />
		<xsl:variable name="months-short" select="('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')" />
		<xsl:value-of select="ou:doubleDigit(if ($length = 'short') then index-of($months-short,$monthName) else index-of($months,$monthName))" />
	</xsl:function>
	
	<xsl:function name="ou:monthNumA">
		<xsl:param name="monthName" />	
		<xsl:variable name="months" select="('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')" />
		<xsl:value-of select="ou:doubleDigit(index-of($months, substring($monthName, 1, 3)))" />
	</xsl:function>
	
	<xsl:function name="ou:dayOfWeek" as="xs:integer?">
		<xsl:param name="date" as="xs:anyAtomicType?"/>
		<xsl:sequence select="if (empty($date)) then () else xs:integer((xs:date($date) - xs:date('1901-01-06')) div xs:dayTimeDuration('P1D')) mod 7"/>
	</xsl:function>
	
	<!--Monday, March 16, 2015-->
	<xsl:function name="ou:displayLongDate">
		<xsl:param name="str" />
		<xsl:variable name="dateTime" select="ou:toDateTime($str)"/>
		<xsl:variable name="dayName" select="format-dateTime($dateTime, '[F]')"/>
		<xsl:variable name="day" select="format-dateTime($dateTime, '[D1]')"/>
		<xsl:variable name="month" select="format-dateTime($dateTime, '[M1]')"/>
		<xsl:variable name="year" select="format-dateTime($dateTime, '[Y0001]')"/>
		<xsl:try>
			<xsl:value-of select="concat($dayName, ', ', ou:monthName($month),' ',$day,', ',$year)" />
			<xsl:catch />
		</xsl:try>
	</xsl:function>
</xsl:stylesheet>
