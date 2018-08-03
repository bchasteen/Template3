<!-- ouc:editor wysiwyg="no" -->
<variable name="navigation" type="select" prompt="Add to Navigation?" alt="Do you want to create a link to this page in the local navigation?">
	<option value="add" selected="false">Add</option>
	<option value="cancel" selected="true">Cancel</option>
</variable>
<variable name="use-sidenav" type="select" prompt="Sidenav to use" alt="Select a Sidenav type or leave as Default to use the default menu" output="xml">
	<option value="default" selected="true">Default</option>
	<option value="simple-nav" selected="false">Simple Nav</option>
	<option value="script-nav" selected="false">Tree Nav</option>
	<option value="auto-nav" selected="false">Auto-Generated Tree Nav</option>
</variable>