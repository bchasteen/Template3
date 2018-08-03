<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE stylesheet>
<!-- 
CAS protected Pages.  Set by a parameter in _props.pcf  the local .pcf file that you want to protect.

Dependencies: 
	ouvariables.xsl (for $props-path)
	functions.xsl
-->
<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:ou="http://omniupdate.com/XSL/Variables" 
	xmlns:fn="http://omniupdate.com/XSL/Functions" 
	xmlns:ouc="http://omniupdate.com/XSL/Variables"
	exclude-result-prefixes="ou xsl xs fn ouc">

	<xsl:param name="props-protection">
		<xsl:try>
			<xsl:value-of select="if(ou:pcfparam('protection') != 'none' and ou:pcfparam('protection') != '') then ou:pcfparam('protection') else doc($props-path)/document/ouc:properties[@label='config']/parameter[@name='protection']/option[@selected='true']/@value"/>
			<xsl:catch></xsl:catch>
		</xsl:try>
	</xsl:param>
	
	<xsl:function name="ou:hasCas" as="xs:boolean">
		<xsl:param name="protection"/>
		
		<xsl:value-of select="if($protection != 'none' and $protection != '') then 'true' else 'false'"/>	
	</xsl:function>
	
	<xsl:function name="ou:casMessage">
		<xsl:param name="protection"/>
		
		<div style="background-color:#ffc;border:2px solid #990;padding:10px;color:#550;font-size:1.5em;">
			This page will have CAS Protection on Publish.
			Level of protection: <b><xsl:value-of select="$protection" /></b>
		</div>
	</xsl:function>
	
	<xsl:template name="cas-protect">
		<xsl:param name="protection"/>
		
		<xsl:processing-instruction name="php">require_once(dirname($_SERVER["DOCUMENT_ROOT"])."/src/CAS/CAS.app.php");
			$cas = new CasController("<xsl:value-of select="$protection" />"); ?</xsl:processing-instruction>
	</xsl:template>
</xsl:stylesheet>