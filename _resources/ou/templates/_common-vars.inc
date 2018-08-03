<!-- ouc:editor wysiwyg="no" -->
<variable section="Page Setup" name="layout" type="select" prompt="Page Layout" alt="Select a page layout." output="xml">
	<option value="full-width" selected="false">Full Width</option>
	<option value="two-column" selected="true">Two Column</option>
</variable>
<variable name="tags" type="tag" prompt="Tags" alt="Choose Tags to be added to the page. These can be updated in page properties to add more later."></variable>
<variable name="gallery-type" type="select" prompt="Gallery" alt="Select an LDP type to display, if a gallery asset is added to page." output="xml">
	<option value="pretty" selected="true">Pretty Photo</option>
</variable>
<variable name="protection" type="select" prompt="Page Protection" alt="Select Page Protection" output="xml">
	<option value="all-myids" selected="false">All MyIDs</option>
	<option value="none" selected="true">No Protection</option>
</variable>
		