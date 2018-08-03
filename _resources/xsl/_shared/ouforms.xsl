<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp   "&#160;">
<!ENTITY lsaquo   "&#8249;">
<!ENTITY rsaquo   "&#8250;">
<!ENTITY laquo  "&#171;">
<!ENTITY raquo  "&#187;">
<!ENTITY copy   "&#169;">
]>
<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:ou="http://omniupdate.com/XSL/Variables"
	xmlns:ouc="http://omniupdate.com/XSL/Variables"
	exclude-result-prefixes="xsl xs ou ouc">
    
    <xsl:import href="datasets.xsl"/>
	<xsl:param name="server-type">php</xsl:param> <!-- Either: php or asp (for checkboxes and drop-down menus)-->
	
	<xsl:template match="ouform">
		<!--
		***Predefined Attributes:***
		1.legend : To create a placeholder text inside a form. Format: legend=true;
		2.addclass: To add a class to an element block. Format: addclass=[CLASS NAME];
		3.fieldset_start: Defines the statring block for a fieldset. Format: fieldset_start=true;
		4.fieldset_end: Defines the ending block for a fieldset. Format: fieldset_end=true;
		5.fieldset_label: Defines the label of the fieldset. Format: fieldset_label=[FIELDSET LABEL];
		7.size :To add a size attribute to a single-line or multi-line text field. Format: size=10;
		8.cols :To add a cloumns attribute to a multi-line text field. Format: cols=10;
		9.rows :To add a rows attribute to a multi-line text field. Format: rows=10;
		10.dataset: To add a pre-defined dataset to a radio button, checkbox, single-select and multi-select. Format: dataset=[DATASET_NAME];
		(state, state_ab, country, year, month, alphabet, numbers)
		11.form_classes:To add classes to the form node. Format: form_classes=well well-raised;
		12. To add the "class=form-horizontal". Format:  form_classes=form-horizontal;
		13. To add class="btn btw-mini" . Format:  reset_btn_classes=btn btn-mini;
		14. To add a class to the submit button. Format: submit_btn_classes=class name; 
		15. If a "required" checkbox is available for a form element it will need to be selected
		if a "required" checkbox is NOT available. Format: required=true;
		
		Rules:
		1. Every declaration in the advanced field must be terminated with a semicolon. Eg. legend=true;addclass=form_legend;
		2. Attributes are always lowercase.
		-->
		
		<div id="status_{@uuid}"></div>
		
		<!-- check if form_classes is present in advanced fields, apply to form's class attribute
if more than one form_classes is present the last one is used
-->
		<xsl:variable name="form-classes">
			<xsl:for-each select="elements/element">
				<xsl:if test="contains(advanced/text(),'form_classes')">
					<xsl:value-of select="ou:get-adv(advanced,'form_classes')"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		
		<!-- OU add 6/6/2013: variable created to apply correct class to reset button  -->
		<xsl:variable name="reset-btn-classes">
			<xsl:variable name="advanced-value">
				<xsl:for-each select="elements/element">
					<xsl:if test="contains(advanced/text(),'reset_btn_classes')">
						<xsl:value-of select="ou:get-adv(advanced,'reset_btn_classes')"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$advanced-value != ''"><xsl:value-of select="$advanced-value"/></xsl:when>
				<xsl:otherwise>btn</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- OU add 6/6/2013: variable created to apply correct class to submit button  -->
		<xsl:variable name="submit-btn-classes">
			<xsl:variable name="advanced-value-submit">
				<xsl:for-each select="elements/element">
					<xsl:if test="contains(advanced/text(),'submit_btn_classes')">
						<xsl:value-of select="ou:get-adv(advanced,'submit_btn_classes')"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$advanced-value-submit != ''"><xsl:value-of select="$advanced-value-submit"/></xsl:when>
				<xsl:otherwise>btn</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
	
		<xsl:variable name="uuid" select="//ouform/@uuid"/>
		<form id="form_{@uuid}" name="contact-form" method="post" class="{$form-classes}" autocomplete="off">
			
			<span class="{concat('hp',@uuid)}">
				<label class="{concat('hp',@uuid)}">If you see this don't fill out this input box.</label>                    	
				<input type="text" id="{concat('hp',@uuid)}"/>
			</span>
			
			<xsl:apply-templates select="elements/element" mode="ouforms"/>
							
			<input type="hidden" name="form_uuid" value ="{@uuid}"/>
			<input type="hidden" name="site_name" value ="{$ou:site}"/>
			<div class="form-actions">
				<button type="submit" id="btn_{@uuid}" class="{$submit-btn-classes}">Submit</button>&nbsp;
				<button type="reset" id="clr_{@uuid}" class="{$reset-btn-classes}">Cancel</button>
			</div>
		</form>
		<style>
			.<xsl:value-of select="concat('hp',@uuid)"/>{display:none;
			margin-left:-1000px;}
		</style>
	</xsl:template>
	
	<xsl:template name="form-headcode">
		<link rel="stylesheet" href="http://ugamail.uga.edu/_resources/css/ldp/ouforms-bootstrap.css"/>
	</xsl:template>
	
	<xsl:template name="form-footcode">
		<script type="text/javascript" src="/_resources/js/ldp/ouforms.js"></script>
	</xsl:template>
	
	<xsl:template match="element" mode="ouforms">
		<!-- This outputs the <fieldset> opening node, if the fieldset_start is set to true in the advanced field. -->
		<xsl:if test="contains(ou:get-adv(advanced,'fieldset_start'),'true')">
			<xsl:text disable-output-escaping="yes">&lt;fieldset&gt;</xsl:text>
			<legend class="none">
				<xsl:attribute name="class"><xsl:value-of select="ou:ldp-create-class(advanced,'none')"/></xsl:attribute>
				<xsl:value-of select="ou:get-adv(advanced,'fieldset_label')"/>
			</legend>
		</xsl:if>
		
		<!-- Creates the div that contains the input field, applies the template with 'ouforms-input' mode to process the actual fields -->
		<div id="{@name}" class="control-group">
			
			<xsl:if test="not(contains(ou:get-adv(advanced,'addclass'),'false'))">
				<xsl:attribute name="class">
					<xsl:value-of select="ou:ldp-create-class(advanced,'none')"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="." mode="ouforms-input" />
		</div>
		
		<!-- This outputs the </fieldset> closing node, if the fieldset_end is set to true in the advanced field. -->
		<xsl:if test="contains(ou:get-adv(advanced,'fieldset_end'),'true')">
			<xsl:text disable-output-escaping="yes">&lt;/fieldset&gt;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	
	<!-- ***FIELD TYPES *** -->
	<!-- Single-line Text Field -->
	<xsl:template match="element[attribute::type = 'input-text']" mode="ouforms-input">
		
		<label for="{concat('id_',@name)}" class="control-label"><xsl:if test="@required = 'true' or (contains(ou:get-adv(advanced,'required'),'true'))"><span class="required">*</span></xsl:if><xsl:value-of select="label"/></label>
		<div class="controls">
			<!-- if the document is HTML5 you can use placeholder attribute eg. placeholder="{default/node()}" -->
			
			<input type="text" name="{@name}" id="{concat('id_',@name)}" placeholder="{default/node()}">
				<xsl:if test="not(contains(ou:get-adv(advanced,'size'),'false'))">
					<xsl:attribute name="size"><xsl:value-of select="ou:get-adv(advanced,'size')" /></xsl:attribute>
				</xsl:if>
			</input>
		</div>
	</xsl:template>
	
	<!-- Single-line Text Field with Legend advanced attribute.  Takes priority over all over single-line text fields. -->
	<xsl:template match="element[attribute::type = 'input-text' and contains(ou:get-adv(advanced,'legend'),'true')]" mode="ouforms-input" priority="1">
		<xsl:copy-of select="default/node()"/>
	</xsl:template>
	
	<!-- Multi-line Text Field -->
	<xsl:template match="element[attribute::type = 'textarea']" mode="ouforms-input">
		
		<xsl:variable name="adv" select="advanced/node()"/>
		<label for="{concat('id_',@name)}" class="control-label"><xsl:if test="@required = 'true' or (contains(ou:get-adv(advanced,'required'),'true'))"><span class="required">*</span></xsl:if><xsl:value-of select="label"/></label>
		<div class="controls">
			<!-- if the document is HTML5 you can use placeholder attribute eg. placeholder="{default/node()}" -->
			<xsl:element name="textarea">
				<xsl:attribute name="name"><xsl:value-of select="./@name" /></xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="concat('id_',./@name)" /></xsl:attribute>
				
				<xsl:if test="not(contains(ou:get-adv($adv,'cols'),'false'))">
					<xsl:attribute name="cols"><xsl:value-of select="ou:get-adv($adv,'cols')" /></xsl:attribute>
				</xsl:if>
				
				<xsl:if test="not(contains(ou:get-adv($adv,'rows'),'false'))">
					<xsl:attribute name="rows"><xsl:value-of select="ou:get-adv($adv,'rows')" /></xsl:attribute>
				</xsl:if>
				
				<xsl:if test="not(contains(ou:get-adv($adv,'size'),'false'))">
					<xsl:attribute name="size"><xsl:value-of select="ou:get-adv($adv,'size')" /></xsl:attribute>
				</xsl:if>
				<xsl:attribute name="placeholder"><xsl:copy-of select="default/node()"/></xsl:attribute>
			</xsl:element>
		</div>
	</xsl:template>
	
	<!-- Radio buttons -->
	<xsl:template match="element[attribute::type = 'input-radio']" mode="ouforms-input">
		<label class="control-label"><xsl:if test="contains(ou:get-adv(advanced,'required'),'true')"><span class="required">*</span></xsl:if><xsl:value-of select="label"/></label>
		<div class="controls">
			
			<xsl:for-each select="options/option">
				<label class="radio">
					<input type="radio" name="{ancestor::element/attribute::name}" value="{@value}"/>
					<xsl:copy-of select="node()"/>
				</label>
			</xsl:for-each>
		</div>
	</xsl:template>
	
	<!-- Check boxes -->
	<xsl:template match="element[attribute::type = 'input-checkbox']" mode="ouforms-input">
		<xsl:variable name="field_name" select="if($server-type = 'php') then concat(@name,'[]') else @name "/>
		
		<label class="control-label"><xsl:if test="contains(ou:get-adv(advanced,'required'),'true')"><span class="required">*</span></xsl:if><xsl:value-of select="label"/></label>
		<div class="controls">
			
			<xsl:for-each select="options/option">
				<label class="checkbox">
					
					<input type="checkbox" name="{$field_name}" value="{@value}" >
						<xsl:if test="@selected = 'true'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
						
					</input>
					<xsl:copy-of select="node()"/>
				</label>
			</xsl:for-each>
		</div>
	</xsl:template>
	
	<!-- Single-select Drop Down Menus -->
	<xsl:template match="element[attribute::type = 'select-single']" mode="ouforms-input">
		<xsl:variable name="field_name" select="if($server-type = 'php') then concat(@name,'[]') else @name "/>
		
		<label for="{concat('id_',@name)}" class="control-label"><xsl:if test="contains(ou:get-adv(advanced,'required'),'true')"><span class="required">*</span></xsl:if><xsl:value-of select="label" /></label>
		<div class="controls">
			<select name="{$field_name}" id="{concat('id_',@name)}">
				<xsl:for-each select="options/option">
					
					<option value="{@value}" >
						<xsl:if test="@selected = 'true'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
						<xsl:copy-of select="node()"/>
					</option>
				</xsl:for-each>
			</select>
		</div>
	</xsl:template>
	
	<!-- Multi-select Drop Down Menus -->
	<xsl:template match="element[attribute::type = 'select-multiple']" mode="ouforms-input">
		<xsl:variable name="field_name" select="if($server-type = 'php') then concat(@name,'[]') else @name "/>
		
		<label for="{concat('id_',@name)}" class="control-label"><xsl:if test="contains(ou:get-adv(advanced,'required'),'true')"><span class="required">*</span></xsl:if><xsl:value-of select="label"/></label>
		<div class="controls">
			
			<select name="{$field_name}" multiple="multiple" size="5" id="{concat('id_',@name)}">
				<xsl:for-each select="options/option">
					<option value="{@value}" >
						<xsl:if test="@selected = 'true'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
						
						<xsl:copy-of select="node()"/>
					</option>
				</xsl:for-each>
			</select>
		</div>
	</xsl:template>
	
	<!-- DATASETS (radio, checkbox, and select options)  Higher priority than normal inputs. -->
	<xsl:template match="element[contains(child::advanced,'dataset')]" mode="ouforms-input" priority="1">
		<xsl:variable name="inputType" select="tokenize(@type,'-')" />
		<xsl:variable name="field_name" select="if($server-type = 'php' and @type != 'input-radio') then concat(@name,'[]') else @name " />
		
		<xsl:choose>
			<xsl:when test="$inputType[1] = 'input'">
				<label class="control-label"><xsl:value-of select="label"/></label>
				<div class="controls">
				<xsl:for-each select="tokenize(ou:create-dataset(advanced), ',')" >
					<label class="{$inputType[2]}">
						<input type="{$inputType[2]}" name="{$field_name}" value="{replace(normalize-space(.),'_D_','')}">
							<xsl:if test="contains(normalize-space(.),'_D_')">
							<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
						<xsl:copy-of select="replace(normalize-space(.),'_D_','')"/>
					</label>
				</xsl:for-each>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<label for="{concat('id_',@name)}" class="control-label"><xsl:value-of select="label"/></label>
				<div class="controls">
				<select name="{$field_name}" id="{concat('id_',@name)}">
					<xsl:if test="$inputType[2] = 'multiple'">
						<xsl:attribute name="multiple">multiple</xsl:attribute>
						<xsl:attribute name="size">5</xsl:attribute>
					</xsl:if>
					<xsl:for-each select="tokenize(ou:create-dataset(advanced), ',')" >
						
							<option  value="{replace(normalize-space(.),'_D_','')}" >
								<xsl:if test="contains(normalize-space(.),'_D_')">
								<xsl:attribute name="selected">true</xsl:attribute>
								</xsl:if>
								<xsl:copy-of select="normalize-space(replace(.,'_D_',''))"/>
							</option>
						
						
					</xsl:for-each>

				</select>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- catch-all (in case of future types) -->
	<xsl:template match="element" mode="ouforms-input"/>
	
	
	<!-- *** FUNCTIONS *** -->
	<!-- Function that parses advanced field for an attribute, and returns the value.  If no value is found, returns 'false'. -->
	<xsl:function name="ou:get-adv">
		<xsl:param name="adv"/>
		<xsl:param name="key"/>
		<xsl:choose>
			<xsl:when test="contains($adv,$key)">
				<xsl:value-of select="substring-before(substring-after($adv,concat($key,'=')),';')"/>
			</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- Function to create a class, uses ou:get-adv -->
	<xsl:function name="ou:ldp-create-class">
		<xsl:param name="adv" />
		<xsl:param name="predefined-class" />
		<xsl:variable name="class-name" select="if(contains($adv,'addclass')) then ou:get-adv($adv,'addclass') else ''" />
		<xsl:value-of select="normalize-space(concat($predefined-class,' ',$class-name))"/>
	</xsl:function>
    
   
    
</xsl:stylesheet>
