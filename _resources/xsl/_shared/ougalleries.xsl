<?xml version="1.0" encoding="utf-8"?>
<!--
OU GALLERIES

Transforms gallery asset XML into a dynamic gallery on the web page. 
Type of gallery is determined by page property.

Dependencies: 
- ou:pcfparams (See kitchensink functions.xsl)			

Contributors: Your Name Here
Last Updated: Enter Date Here
-->
<!DOCTYPE xsl:stylesheet SYSTEM "http://commons.omniupdate.com/dtd/standard.dtd">
<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ou="http://omniupdate.com/XSL/Variables"
	xmlns:fn="http://omniupdate.com/XSL/Functions"
	xmlns:ouc="http://omniupdate.com/XSL/Variables"
	exclude-result-prefixes="ou xsl xs fn ouc">

	<!--	
The following template matches the LDP gallery nodes and outputs the proper HTML Code based on a specified parameter. 
This will work with existing apply-templates. 
-->
	<xsl:template match="gallery">

		<xsl:param name="gallery-type" select="ou:pcfparam('gallery-type')" />
		<xsl:variable name="galleryId" select="@asset_id"/>

		<xsl:choose>
			<xsl:when test="$gallery-type = 'flex'">
				<div class="flex-nav-container">
					<div class="flexslider">
						<ul class="slides"> 
							<xsl:for-each select="images/image">
								<li data-thumb="{@url}">
									<xsl:choose>
										<!-- Determine if caption field is empty -->
										<xsl:when test="link != ''"> 
											<!-- Not empty, create a link -->
											<a href="{link}">
												<img src="{@url}" alt="{title}" title="{title}" />
											</a>
										</xsl:when>
										<xsl:otherwise>	
											<img src="{@url}" alt="{title}" title="{title}" />                 
										</xsl:otherwise>
									</xsl:choose>
									<xsl:if test="title != '' or description != ''">
										<!-- Only create a div caption for a div one that has a title or description -->
										<p class="flex-caption">
											<xsl:choose>
												<!-- Determine if caption field is empty -->
												<xsl:when test="link != ''"> 
													<!-- Not empty, create a link -->
													<a href="{link}">
														<xsl:value-of select="title" />
														<xsl:if test="description != ''">
															- <xsl:value-of select="description" />
														</xsl:if>
													</a>
												</xsl:when>
												<xsl:otherwise>	
													<!-- Just output caption, no link -->
													<xsl:value-of select="title" /> 
													<xsl:if test="description != ''">
														- <xsl:value-of select="description" />
													</xsl:if>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:comment> Do not allow div to self close </xsl:comment>
										</p>
									</xsl:if>							

								</li>
							</xsl:for-each>

						</ul>
					</div>
				</div>
			</xsl:when>
			<xsl:when test="$gallery-type = 'pretty'">
				<ul class="thumbnails">
					<xsl:for-each select="images/image">
						<li>
							<a href="{@url}" rel="prettyPhoto[{$galleryId}]" title="{title}"  class="thumbnail">
								<img src="{thumbnail/@url}" alt="{title}" style="height:{thumbnail/height}px; width:{thumbnail/width}px;"/>
							</a>
						</li>
					</xsl:for-each>	
				</ul>
			</xsl:when>
			<xsl:when test="$gallery-type = 'bootstrap'">
				<div class="carousel-container">
					<!-- Bootstrap Carousel -->
					<div id="carousel{$galleryId}" class="carousel slide" data-ride="carousel{$galleryId}">
						<ol class="carousel-indicators">
							<xsl:for-each select="images/image">
								<xsl:variable name="pos" select="position() - 1"/>
								<li data-target="#carousel{$galleryId}" data-slide-to="{$pos}" class="{if($pos=0) then 'active' else ''}"></li>
							</xsl:for-each>
						</ol>
						<div class="carousel-inner" role="listbox">
							<xsl:for-each select="images/image">
								<xsl:variable name="pos" select="position() - 1"/>
								<div class="item {if($pos=0) then 'active' else ''}" tabindex="0">
									<img src="{if(ou:action = 'pub') then @url else @staging_url}" alt="{caption}"/>
									<div class="carousel-caption">
										<a href="{link}">
											<h3><xsl:value-of select="title"/></h3>
											<h4><xsl:value-of select="description"/>&nbsp;&nbsp;&nbsp;<span class="fullstory">full story</span></h4>
										</a>
									</div>
								</div>
							</xsl:for-each>
						</div>
						<!-- Left and right controls -->
						<a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
							<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
							<span class="sr-only">Previous</span>
						</a>
						<a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
							<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
							<span class="sr-only">Next</span>
						</a>
						<a class="left carousel-control" href="#carousel{$galleryId}" role="button" data-slide="prev">
							<i class="glyphicon glyphicon-chevron-left" aria-hidden="true"></i>
						</a>
						<a class="right carousel-control" href="#carousel{$galleryId}" role="button" data-slide="next">
							<i class="glyphicon glyphicon-chevron-right" aria-hidden="true"></i>
						</a>
					</div>
				</div>
			</xsl:when>
			<!-- optionally, set a fallback output -->
			<xsl:otherwise>
				<xsl:comment>Undefined parameter for gallery match.</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--

Gallery Headcode

This is the CSS styling for displaying galleries.
Include this in the common headcode as follows:

<xsl:if test="content/descendant::gallery"> 
<xsl:copy-of select="ou:gallery-headcode($gallery-type)"/>
</xsl:if>	

-->
	<!-- optionally, remove  -->
	<xsl:function name="ou:gallery-headcode">
		<xsl:param name="gallery-type" />

		<xsl:choose>
			<xsl:when test="$gallery-type = 'flex'">
				<link rel="stylesheet" href="{{f:18817534}}" type="text/css"/>
				<link rel="stylesheet" href="{{f:18817533}}" type="text/css"/>
			</xsl:when>
			<xsl:when test="$gallery-type = 'pretty'">			
				<link rel="stylesheet" href="{{f:18817524}}"/> 			
				<link rel="stylesheet" href="{{f:18817555}}" type="text/css" media="screen" title="prettyPhoto main stylesheet" charset="utf-8" />
			</xsl:when>
		</xsl:choose>
	</xsl:function>
	<!--

Gallery Footcode

This is the javascript for displaying galleries.
Include this in the footcode after jquery is loaded.

<xsl:if test="content/descendant::gallery"> 
<xsl:copy-of select="ou:gallery-footcode($gallery-type)"/>
</xsl:if>	

-->
	<!-- optionally, remove  -->
	<xsl:function name="ou:gallery-footcode">
		<xsl:param name="gallery-type" />

		<xsl:choose>
			<xsl:when test="$gallery-type='flex'">
				<script src="/_resources/ldp/galleries/flex-slider/jquery.flexslider-min.js"></script>
				<script type="text/javascript">
					$(document).ready(function() {
					$('.flexslider').flexslider({
					animation: "slide"
					});
					$('.flex-active').trigger( "click" );
					});
				</script>		
			</xsl:when>	
			<xsl:when test="$gallery-type = 'pretty'">			
				<script src="/_resources/ldp/galleries/pretty-photo/jquery.prettyPhoto.js" type="text/javascript" charset="utf-8"></script>
				<script type="text/javascript">
					$(document).ready(function() {
					$("a[rel^='prettyPhoto']").prettyPhoto();
					});
				</script>
			</xsl:when>
			<xsl:when test="$gallery-type='bootstrap'">
				<script type="text/javascript">
					$('.carousel').carousel({ interval: 5000 });
				</script>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>


	</xsl:function>

</xsl:stylesheet>	
