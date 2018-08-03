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
	
	<xsl:param name="ignore-dirs" select="if(normalize-space(ou:pcfparam('ignore-dirs'))) then ou:value-union($idirs, ou:sequence(ou:pcfparam('ignore-dirs'), ',')) else $idirs"/>
	<xsl:param name="ignore-files" select="if(normalize-space(ou:pcfparam('ignore-files'))) then ou:value-union($ifiles, ou:sequence(ou:pcfparam('ignore-files'), ',')) else $ifiles"/>
	<xsl:param name="ignore-prefix" select="if(normalize-space(ou:pcfparam('ignore-prefix'))) then ou:sequence(ou:pcfparam('ignore-prefix'), ',') else $iprefix"/>
	<xsl:param name="directory-order" select="if(normalize-space(ou:pcfparam('directory-order'))) then ou:sequence(ou:pcfparam('directory-order'), ',') else 'false'"/>
	<xsl:param name="hide-children" select="if(normalize-space(ou:pcfparam('hide-children'))) then ou:sequence(ou:pcfparam('hide-children'), ',') else 'false'"/>
	<xsl:key name="sort-key" match="$directory-order" use="*" />
	
	<xsl:template name="simple-sitenav">
		<xsl:param name="rootRel"/>
		
		<!-- Root Level -->
		<xsl:for-each select="ou:listAll(concat($ou:root, $ou:site, $rootRel))">
			<xsl:variable name="newPath" select="concat($ou:root, $ou:site, $rootRel, '/', .)"/>
			<xsl:variable name="newRoot" select="concat($rootRel,  '/', .)"/>
			<li> <!--  class="dropdown" -->
				<xsl:choose>
					<xsl:when test="name() = 'directory'">
						<xsl:apply-templates select="ou:fileLink($newRoot)" />
					</xsl:when>
					<xsl:otherwise> <!-- if the root isn't a directory, then it's a file. Just list the file link in the menu -->
						<xsl:apply-templates select="ou:fileLink(ou:removeExt($newRoot))" />
					</xsl:otherwise>
				</xsl:choose>
			</li>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="bootstrap-sitenav">
		<xsl:param name="rootRel"/>
		
		<!-- Root Level -->
		<xsl:for-each select="ou:listAll(concat($ou:root, $ou:site, $rootRel))">
			<xsl:variable name="newPath" select="concat($ou:root, $ou:site, $rootRel, '/', .)"/>
			<xsl:variable name="newDir" select="concat($rootRel, '/', replace(., '.pcf', ''))"/>
			<xsl:variable name="showDropdown" select="boolean(ou:listAll($newPath))"/>
			
			<li> <!--  class="dropdown" -->
				<xsl:choose>
					<xsl:when test="name() = 'directory'">
						<xsl:variable name="showChildren" select="not(index-of($hide-children, .))"/>
						<xsl:if test="$showDropdown and $showChildren"><xsl:attribute name="class">dropdown</xsl:attribute></xsl:if>
						<a tabindex="0" role="button">
							<xsl:attribute name="href" select="if($showDropdown and $showChildren) then '#' else $newDir"/>
							<xsl:if test="$showDropdown and $showChildren">
								<xsl:attribute name="data-toggle">dropdown</xsl:attribute>
								<xsl:attribute name="aria-haspopup">true</xsl:attribute>
								<xsl:attribute name="aria-expanded">false</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="ou:getBreadcrumb($newDir)"/><xsl:text> </xsl:text>
							<xsl:if test="$showDropdown and $showChildren"><span class="caret"></span></xsl:if>
						</a>
						<xsl:if test="$showDropdown and $showChildren">
							<ul class="dropdown-menu">
								<xsl:for-each select="ou:listAll($newPath)">
									<li><xsl:apply-templates select="ou:fileLink(concat($newDir,  '/', replace(., '.pcf', '')))" /></li>
								</xsl:for-each>
							</ul>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise><xsl:apply-templates select="ou:fileLink($newDir)" /></xsl:otherwise>
				</xsl:choose>
			</li>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="yamm-sitenav">
		<xsl:param name="rootRel"/>
		
		<!-- Root Level -->
		<xsl:for-each select="ou:listDirs(concat($ou:root, $ou:site, $rootRel))">

			<xsl:variable name="newPath" select="concat($ou:root, $ou:site, $rootRel, '/', .)"/>
			<xsl:variable name="newRoot" select="concat($rootRel,  '/', .)"/>
			<xsl:variable name="showChildren" select="not(index-of($hide-children, .))"/>
			
			<li class="dropdown yamm-fullwidth">
				<xsl:apply-templates select="ou:fileLink($newRoot, 'dropdown-toggle disabled', 'dropdown')" />
				<xsl:if test="boolean(ou:listAll($newPath)) and $showChildren">

					<ul class="dropdown-menu yamm-content">
						<li class="submenu-item">
							<xsl:for-each select="ou:listDirs($newPath)">
								<xsl:sort select="."/>

								<xsl:variable name="newPath1" select="concat($newPath, '/', .)"/>
								<xsl:variable name="newRoot1" select="concat($newRoot,  '/', .)"/>

								<div class="second-li first-div col-sm-4">
									<strong><xsl:apply-templates select="ou:fileLink($newRoot1)" /></strong>
									
									<xsl:if test="boolean(ou:listAll($newPath1))">
										<ul>
											<xsl:for-each select="ou:listDirs($newPath1)">
												<xsl:sort select="."/>

												<xsl:variable name="newPath2" select="concat($newPath1, '/', .)"/>
												<xsl:variable name="newRoot2" select="concat($newRoot1,  '/', .)"/>
												<li>
													<strong><xsl:apply-templates select="ou:fileLink($newRoot2)" /></strong>
													<xsl:if test="boolean(ou:listAll($newPath2))">
														<ul class="submenu">
															<xsl:for-each select="ou:listDirs($newPath2)">
																<xsl:sort select="."/>

																<xsl:variable name="newPath3" select="concat($newPath2, '/', .)"/>
																<xsl:variable name="newRoot3" select="concat($newRoot2,  '/', .)"/>

																<li>
																	<xsl:apply-templates select="ou:fileLink($newRoot3)" />
																	<xsl:if test="boolean(ou:listAll($newPath3))">
																		<ul class="submenu">
																			<xsl:for-each select="ou:listDirs($newPath3)">
																				<xsl:sort select="."/>
																				<xsl:sort select="concat($newPath3,  '/', .)"/>

																				<xsl:variable name="newPath4" select="concat($newPath3, '/', .)"/>
																				<xsl:variable name="newRoot4" select="concat($newRoot3,  '/', .)"/>

																				<li>
																					<xsl:if test="ou:listFiles($newPath4) != ''">
																						<xsl:apply-templates select="ou:listItems($newRoot4, doc($newPath4)/list/file)"/>
																					</xsl:if>
																				</li>
																			</xsl:for-each>
																			<xsl:if test="ou:listFiles($newPath3) != ''">
																				<xsl:apply-templates select="ou:listItems($newRoot3, doc($newPath3)/list/file)"/>
																			</xsl:if>
																		</ul>
																	</xsl:if>
																</li>
															</xsl:for-each>
															<xsl:if test="ou:listFiles($newPath2) != ''">
																<xsl:apply-templates select="ou:listItems($newRoot2, doc($newPath2)/list/file)"/>
															</xsl:if>
														</ul>
													</xsl:if>
												</li>
											</xsl:for-each>
											<xsl:if test="boolean(ou:listFiles($newPath1))">
												<xsl:apply-templates select="ou:listItems($newRoot1, doc($newPath1)/list/file)"/>
											</xsl:if>
										</ul>
									</xsl:if>
								</div>

							</xsl:for-each>
							
							<xsl:if test="boolean(ou:listFiles($newPath))">
								<xsl:apply-templates select="ou:listItemDivs($newRoot, doc($newPath)/list/file, 'col-sm-4')"/>
							</xsl:if>
						</li>
					</ul>
				</xsl:if>
				</li>
		</xsl:for-each>
		<!-- Hide files on main level -->
		<xsl:if test="boolean(ou:listFiles(concat($ou:root, $ou:site, $rootRel)))">
			<xsl:apply-templates select="ou:listItems($rootRel, doc(concat($ou:root, $ou:site, $rootRel))/list/file)"/>
		</xsl:if>
	</xsl:template>
	
	<!-- 
	Section Navigation: begin with the root relative path.
	Get files and directories. List the files. For each directory, list the 
	directories and files and so forth for each subsequent directory up to 
	four levels deep.
	-->	
	<xsl:template name="sectionNav">
		<xsl:param name="rootRel"/>
		
		<xsl:variable name="dirprops" select="doc(concat($ou:root, $ou:site, $rootRel, '/_props.pcf'))/document/ouc:properties[@label='config']"/>
		<li>
			<a href="{$rootRel}"><xsl:value-of select="$dirprops/parameter[@name='breadcrumb']"/></a>
			<xsl:if test="boolean(ou:listAll(concat($ou:root, $ou:site, $rootRel)))">
			<ul class="submenu">
				<xsl:for-each select="ou:listDirs(concat($ou:root, $ou:site, $rootRel))">
					<xsl:variable name="newPath" select="concat(concat($ou:root, $ou:site, $rootRel), '/', .)"/>
					<xsl:variable name="newRoot" select="concat($rootRel,  '/', .)"/>
					<li>
						<xsl:apply-templates select="ou:fileLink($newRoot)" />
						<xsl:if test="boolean(ou:listAll($newPath))">
							<ul class="submenu">
								<xsl:for-each select="ou:listDirs($newPath)">
									<xsl:variable name="newPath1" select="concat($newPath, '/', .)"/>
									<xsl:variable name="newRoot1" select="concat($newRoot,  '/', .)"/>
									<li>
										<xsl:apply-templates select="ou:fileLink($newRoot1)" />
										<xsl:if test="boolean(ou:listAll($newPath1))">
											<ul class="submenu">
												<xsl:for-each select="ou:listDirs($newPath1)">
													<xsl:variable name="newPath2" select="concat($newPath1, '/', .)"/>
													<xsl:variable name="newRoot2" select="concat($newRoot1,  '/', .)"/>
													<li>
														<xsl:apply-templates select="ou:fileLink($newRoot2)" />
														<xsl:if test="boolean(ou:listAll($newPath2))">
															<ul class="submenu">
																<xsl:for-each select="ou:listDirs($newPath2)">
																	<xsl:variable name="newPath3" select="concat($newPath2, '/', .)"/>
																	<xsl:variable name="newRoot3" select="concat($newRoot2,  '/', .)"/>

																	<li>
																		<xsl:apply-templates select="ou:fileLink($newRoot3)" />
																		<xsl:if test="boolean(ou:listAll($newPath3))">
																			<ul class="submenu">
																				<xsl:for-each select="ou:listDirs($newPath3)">
																					<xsl:variable name="newPath4" select="concat($newPath3, '/', .)"/>
																					<xsl:variable name="newRoot4" select="concat($newRoot3,  '/', .)"/>
																					<li>
																						<xsl:if test="boolean(ou:listFiles($newPath4))">
																							<xsl:apply-templates select="ou:listItems($newRoot4, doc($newPath4)/list/file)"/>
																						</xsl:if>
																					</li>
																				</xsl:for-each>
																				<xsl:if test="boolean(ou:listFiles($newPath3))">
																					<xsl:apply-templates select="ou:listItems($newRoot3, doc($newPath3)/list/file)"/>
																				</xsl:if>
																			</ul>
																		</xsl:if>
																	</li>
																</xsl:for-each>
																<xsl:if test="boolean(ou:listFiles($newPath2))">
																	<xsl:apply-templates select="ou:listItems($newRoot2, doc($newPath2)/list/file)"/>
																</xsl:if>
															</ul>
														</xsl:if>
													</li>
												</xsl:for-each>
												<xsl:if test="boolean(ou:listFiles($newPath1))">
													<xsl:apply-templates select="ou:listItems($newRoot1, doc($newPath1)/list/file)"/>
												</xsl:if>
											</ul>
										</xsl:if>
									</li>
								</xsl:for-each>
								<xsl:if test="boolean(ou:listFiles($newPath))">
									<xsl:apply-templates select="ou:listItems($newRoot, doc($newPath)/list/file)"/>
								</xsl:if>
							</ul>
						</xsl:if>
					</li>
				</xsl:for-each>
				<xsl:if test="boolean(ou:listFiles(concat($ou:root, $ou:site, $rootRel)))">
					<xsl:apply-templates select="ou:listItems($rootRel, doc(concat($ou:root, $ou:site, $rootRel))/list/file)"/>
				</xsl:if>
			</ul>
			</xsl:if>
		</li>
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
			<xsl:for-each select="directory">
				<xsl:sort select="if($directory-order) then index-of($directory-order, .) else ."/>
				<xsl:if test="ou:checkDirectory(.)"><xsl:apply-templates select="."/></xsl:if>
			</xsl:for-each>
			
			<xsl:for-each select="file">
				<xsl:sort select="if($directory-order) then index-of($directory-order, .) else ."/>
				<xsl:if test="ou:checkFile(.)"><xsl:apply-templates select="."/></xsl:if>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:function>
	
	<!-- Returns a listing of directories in the directory, with some ignored. Files will be returned as XML <directory>dirname</directory> -->
	<xsl:function name="ou:listDirs">
		<xsl:param name="docpath"/>
		
		<xsl:for-each select="doc($docpath)/list/directory">
			<xsl:sort select="if($directory-order) then index-of($directory-order, .) else ."/>
			
			<xsl:if test="ou:checkDirectory(.)">
				<xsl:apply-templates select="."/>	
			</xsl:if>
		</xsl:for-each>
	</xsl:function>
	
	<!-- Returns a listing of files in the directory, with some ignored. Files will be returned as XML <file>filename</file> -->
	<!-- Returns a listing of files in the directory, with some ignored. Files will be returned as XML <file>filename</file> -->
	<xsl:function name="ou:listFiles">
		<xsl:param name="docpath"/>
		
		<xsl:value-of select="$docpath"/>
		<xsl:for-each select="doc($docpath)/list/file">
				<xsl:sort select="if($directory-order) then index-of($directory-order, ou:removeExt(.)) else ."/>

				<xsl:if test="ou:checkFile(.)">
					<xsl:apply-templates select="."/>
				</xsl:if>
		</xsl:for-each>
	</xsl:function>
	
	<!-- Create list items for filenames in a Sequence (Array) -->
	<xsl:function name="ou:listItems">
		<xsl:param name="root"/>
		<xsl:param name="files"/>
		
		<xsl:for-each select="$files">
			<xsl:sort select="if($directory-order) then index-of($directory-order, ou:removeExt(.)) else ."/>
			
			<xsl:if test="ou:checkFile(.)">
				<li>
					<xsl:copy-of select="ou:fileLink(concat($root, '/', ou:removeExt(.)))"/>
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
			<xsl:sort select="if($directory-order) then index-of($directory-order, ou:removeExt(.)) else ."/>
			<xsl:if test="ou:checkFile(.)">
				<div class="{$class}">
					<xsl:copy-of select="ou:fileLink(concat($root, '/', ou:removeExt(.)))"/>
				</div>
			</xsl:if>
		</xsl:for-each>
	</xsl:function>
	
	<xsl:function name="ou:getBreadcrumb">
		<xsl:param name="file"/>
		
		<xsl:choose>
			<xsl:when test="doc-available(concat($ou:root, $ou:site, $file, '.pcf'))">

				<xsl:value-of select="doc(concat($ou:root, $ou:site, $file , '.pcf'))/document/*[@label='config']/parameter[@name='breadcrumb']"/>
			</xsl:when>
			<xsl:when test="doc-available(concat($ou:root, $ou:site, $file , '/_props.pcf'))">
				<xsl:value-of select="doc(concat($ou:root, $ou:site, $file , '/_props.pcf'))/document/*[@label='config']/parameter[@name='breadcrumb']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$file"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- Create a link using the page or sections props as name -->
	<xsl:function name="ou:fileLink">
		<xsl:param name="file"/>
		
		<a href="{concat($file, '/')}"><xsl:value-of select="ou:getBreadcrumb($file)"/></a>
	</xsl:function>
	
	<!-- Create a link using the page or sections props as name -->
	<xsl:function name="ou:fileLink">
		<xsl:param name="file"/>
		<xsl:param name="class"/>
		<xsl:param name="data-toggle"/>
		
		<a class="{$class}" href="{concat($file, '/')}" data-toggle="{$data-toggle}"><xsl:value-of select="ou:getBreadcrumb($file)"/></a>
	</xsl:function>
	
	<!-- Create a link using the page or sections props as name -->
	<xsl:function name="ou:bootstrapDropdownLink">
		<xsl:param name="file"/>
		
		
	</xsl:function>
	
	<xsl:function name="ou:value-union" as="xs:anyAtomicType*">
		<xsl:param name="arg1" as="xs:anyAtomicType*"/>
		<xsl:param name="arg2" as="xs:anyAtomicType*"/>

		<xsl:sequence select="distinct-values(($arg1, $arg2))"/>
	</xsl:function>
</xsl:stylesheet>