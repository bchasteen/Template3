<ouc:editor wysiwyg="yes"/>
<script>
	$(window).scroll(function(){
		if ( ($(window).height() + 100) < $(document).height() )
			$('#top-link-block').removeClass('hidden').affix({ offset: {top:100} });
	});		
</script>
<div id="top-link-block" class="hidden">
	<a href="#top" class="well well-sm"  onclick="$('html,body').animate({scrollTop:0},'slow');return false;">
		<span class="glyphicon glyphicon-chevron-up" aria-hidden="true"></span>
		<span class="sr-only sr-only-focusable">Back to Top</span>
	</a>
</div>