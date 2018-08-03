<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE stylesheet>
<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ou="http://omniupdate.com/XSL/Variables"
	xmlns:fn="http://omniupdate.com/XSL/Functions"
	xmlns:ouc="http://omniupdate.com/XSL/Variables"
	xmlns:media="http://search.yahoo.com/mrss/"
	xmlns:functx="http://www.functx.com"
	exclude-result-prefixes="ou xsl xs fn">
	
	<xsl:import href="../_shared/common.xsl"/>	
	
	<!-- Default: for HTML5 use below output declaration -->
	<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8"/>
	<xsl:template name="page-content"/>
	<xsl:template match="/document">
		<rss version="2.0" xmlns:media="http://search.yahoo.com/mrss/" xmlns:ouc="http://omniupdate.com/XSL/Variables">
			<channel>
				<title>Faculty Profiles</title>
				<link><xsl:value-of select="concat($domain, $dirname, ou:setExt($ou:filename, 'xml'))"/></link>
				<description/>
				<language>en-us</language>

				<xsl:variable name="tags" select="ou:get-page-tags()/tag/name"/> <!-- Get the page's tags -->
				<xsl:for-each select="$tags">
					<xsl:sort select="name"/>
					
					<xsl:variable name="files" select="ou:get-files-with-all-tags(string-join(., ', '))"/> <!-- Get profiles with this tag -->

					<xsl:for-each select="$files/page">

						<xsl:variable name="content" select="doc(concat($ou:root, $ou:site, path))/document"/>
						<xsl:if test="$content/profile">
							<xsl:variable name="link" select="concat($domain, ou:setExt(path, 'html'))"/>
							<xsl:variable name="name" select="$content/profile/ouc:div[@label='name']/text()"/>
							<xsl:variable name="job-title" select="$content/profile/ouc:div[@label='job-title']/text()"/>
							<xsl:variable name="degrees" select="ou:sequence($content/profile/ouc:div[@label='degrees-held']/text(), ';')"/>
							<xsl:variable name="bio" select="$content/profile/ouc:div[@label='bio']"/>
							<xsl:variable name="img" select="$content/profile/ouc:div[@label='photo']//img"/>
							<xsl:variable name="cv" select="$content/profile/ouc:div[@label='cv']/text()"/>
							<xsl:variable name="email" select="normalize-space($content/profile/ouc:div[@label='email']/text())"/>
							<xsl:variable name="phone" select="normalize-space($content/profile/ouc:div[@label='phone-number']/text())"/>
							<xsl:variable name="street" select="normalize-space($content/profile/ouc:div[@label='street']/text())"/>
							<xsl:variable name="room" select="$content/profile/ouc:div[@label='room-number']/text()"/>
							<xsl:variable name="tags" select="ou:get-page-tags(path)/tag"/> <!-- Get the profile's tags -->
							<item>
								<name><xsl:value-of select="$name"/></name>
								<job-title><xsl:value-of select="$job-title"/></job-title>
								<degrees>
									<xsl:for-each select="$degrees">
										<xsl:variable name="pos" select="position()"/>
										<degree><xsl:value-of select="$degrees[$pos]"/></degree>
									</xsl:for-each>
								</degrees>
								<phone><xsl:value-of select="$phone"/></phone>
								<email><xsl:value-of select="$email"/></email>
								<photo><xsl:value-of select="$img/@src"/></photo>
								<link><xsl:value-of select="$link"/></link>
								<street><xsl:value-of select="$street"/></street>
								<room><xsl:value-of select="$room"/></room>
								<xsl:for-each select="$tags">
									<category><xsl:value-of select="name"/></category>
								</xsl:for-each>
								<description>
									<xsl:apply-templates select="$bio"/>
									<xsl:apply-templates select="$content/ouc:div[@label='maincontent']" />
								</description>
								<media:content url="{concat($domain, $img/@src)}">
									<media:title><xsl:value-of select="$img/alt"/></media:title>
									<media:description><xsl:value-of select="concat($name, ' profile image')"/></media:description>
									<media:thumbnail url="{concat($domain, $img/@src)}"></media:thumbnail>
									<media:keywords><xsl:value-of select="lower-case(concat($name, ', ', ou:lastName($name)))"/></media:keywords>
								</media:content>
							</item>
						</xsl:if>

					</xsl:for-each>
				</xsl:for-each>

			</channel>
		</rss>
	</xsl:template>
</xsl:stylesheet>
