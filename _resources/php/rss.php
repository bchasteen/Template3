<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');
libxml_use_internal_errors(true);

function compare($a, $b) 
{
    return ($a['pubDate'] == $b['pubDate']) ? 0 : ($a['pubDate'] > $b['pubDate']) ? -1 : 1;
}

function outputAsListItem($items, $obj, &$format){
	$title = htmlentities($items[$i]["title"]);
	$alt = isset($items[$i]["image"]["alt"]) ? $items[$i]["image"]["alt"] : $title;
	$img = '<img class="media-object" src="'.($items[$i]["image"] ? $items[$i]["image"]["thumb"] : "/_resources/images/template/placeholder.png").'" alt="'.$alt.'" />';
	$datetime = DateTime::createFromFormat("U", intval($items[$i]["pubDate"]), new DateTimeZone("America/New_York"));
	
	echo '<li>';
	echo (isset($opt->images) && filter_var($opt->images, FILTER_VALIDATE_BOOLEAN)) ? sprintf('<div class="list-image">%s</div>', ($items[$i]["link"] ? '<a href="'.$items[$i]["link"].'">'.$img.'</a>' : $img)) : ''; 
	echo '<strong><a href="'.$items[$i]["link"].'">'.$title.'</a></strong>';
	echo (isset($opt->dates) && filter_var($opt->dates, FILTER_VALIDATE_BOOLEAN)) ? '<p class="date">'. $datetime->format($format) .'</p>' : '';
	echo (isset($opt->description) && filter_var($opt->description, FILTER_VALIDATE_BOOLEAN)) ? '<p>'.htmlentities($items[$i]["description"]).'</p>' : '';
	echo '</li>';
}

function outputAsMediaObject($items, $obj, &$format)
{
	$title = htmlentities($items[$i]["title"]);
	$alt = isset($items[$i]["image"]["alt"]) ? $items[$i]["image"]["alt"] : $title;
	$img = '<img class="media-object" src="'.($items[$i]["image"] ? $items[$i]["image"]["thumb"] : "/_resources/images/template/placeholder.png").'" alt="'.$alt.'" />';
	$datetime = DateTime::createFromFormat("U", intval($items[$i]["pubDate"]), new DateTimeZone("America/New_York"));
	echo '
	<div class="media">
		<div class="media-left">
			<a href="'.$items[$i]["link"].'">'.$img.'</a>
		</div>
		<div class="media-body">
			<h4 class="media-heading"><a href="'.$items[$i]["link"].'">'.$title.'</a></h4>
			<div class="media-description">';
				echo (isset($opt->dates) && filter_var($opt->dates, FILTER_VALIDATE_BOOLEAN)) ? '<p class="date">'. $datetime->format($format) .'</p>' : '';
				echo (isset($opt->description) && filter_var($opt->description, FILTER_VALIDATE_BOOLEAN)) ? '<p>'.htmlentities($items[$i]["description"]).'</p>' : '';
	echo 	'</div>
		</div>
	</div>';	
}

function pagination($page, $numberOfPages)
{
	$link = '?page=';
	$range = 50;
	$ret = "";
	if($numberOfPages > 1){
		$ret = '<nav><ul class="pagination">';
		if ($page > 1) {
			#
			# get previous page num
			$prevpage = $page - 1;
			$ret .= '<li><a href="'.$link.$prevpage.'" aria-label="Previous"><span aria-hidden="true">&#139;</span></a></li>';
		}

		#
		# loop to show links to range of pages around current page
		#	page=12 range=40 
		$start = (($page - $range) < 0) ? 0 : $page - $range;
		for ($x = $start; $x < (($page + $range) + 1); $x++) {
			#
			# if it's a valid page number...
			if (($x > 0) && ($x <= $numberOfPages))
				$ret.= ($x == $page)
					? "<li class=\"active\"><a href=\"#\">$x <span class=\"sr-only\">(current)</span></a></li>" 
					: "<li><a href=\"$link$x\">$x</a></li>";
		}
		
		#
		# if not on last page, show forward and last page links        
		if ($page < $numberOfPages) {
			#
			# get next page
			$nextpage = $page + 1;
			$ret.= '<li><a href="'.$link.$nextpage.'" aria-label="Next"><span aria-hidden="true">&#155;</span></a></li>';
		}
		$ret.= "</ul></nav>";
	}
	echo $ret;
}

/**
* Get either all the RSS items, or items based on a tag and search parameter passed
* to the function.  If no search parameter, then the search will be performed by 
* category.
*
* @param $path String - Either relative or absolute path to an XML file to display
* @param $searchby String - XML node to search for (default:<category>)
* @param $tag String - Value to search for within XML node
*/
function getRSScategory($path, $tag="", $searchby="")
{
	if(!$path) return [];
	
	$xpath = "/rss/channel/item";
	$posts = $xml = [];
	$path = substr($path, 0, 1) == "/" ? $_SERVER["DOCUMENT_ROOT"].$path : $path;
	if(!$xml = simplexml_load_file($path)) return [];
	
	#
	# Create the XPATH
	if($tag){
		#
		# If tag was passed to the function, create a xPath to search by it.
		# $searchby is a parameter that can possibly be given if you want to search by some other tag in the RSS file than <category>
		$tag = strpos($tag, ",") ? explode(",", $tag) : $tag;	
		$tag = is_array($tag) ? trim($tag[0]) : trim($tag);  // If tag is an array, get the first index only
		$xpath .= "[" . (empty($searchby) ? "category" : $searchby) . "='" . $tag . "']";
	} else {
		#
		# Tag could come from the URL.  In this case, create an xPath to search by that category.  If no "tag" parameter, get all items in the RSS feed
		$xpath .= filter_input(INPUT_GET, "tag", FILTER_SANITIZE_STRING) 
			? "[" . (empty($searchby) ? "category" : $searchby) . "='" . filter_input(INPUT_GET, "tag", FILTER_SANITIZE_STRING) . "']" 
			: "";
	}
	
	$items = $xml->xpath($xpath);

	foreach($items as $item){
		$item->registerXPathNamespace("media", "http://search.yahoo.com/mrss/");
		$img = $item->xpath('./media:content');
		$pubDate = (new DateTime($item->pubDate, new DateTimeZone("America/New_York")))->getTimestamp();
		$endDate = isset($item->endDate) ? (new DateTime($item->endDate, new DateTimeZone("America/New_York")))->getTimestamp() : NULL;
		
		$posts[] = [
			"title" => strval($item->title),
			"description" => strval($item->description),
			"author" => strval($item->author),
			"link"  => strval($item->link),
			"pubDate" => $pubDate,
			"endDate" => $endDate,
			"category" => $item->category,
			"image" => isset($img[0]) ? [
				"src" => strval($img[0]->attributes()->url),
				"thumb" => strval($item->xpath('./media:content/media:thumbnail')[0]->attributes()->url),
				"alt" => strval($item->xpath('./media:content/media:title')[0])
			] : []
		];
	}
	usort($posts, "compare"); // Sort items descending by pubDate;
	return $posts;	
}	

/**
* Options: 
* limit: Integer - number of items to show
* images: Boolean - show or hide images
* dates: Boolean - show or hide dates
* dateFormat: String - PHP Date Format to use (default:'n/j/y')
* description: Boolean - show or hide description
* style: String - CSS class to add to the <ul>
* json: Boolean - Return output as JSON encoded string instead of HTML (default: false)
*
* Parameters:
* @rss SimpleXMLObject - the Feed to output
* @config String - JSON encoded String with options for displaying output
* @param rss Array - RSS Items to display
* @param config Array
* @return String - data to display
**/
function displayRSS($items, $config)
{
	if(!$items || !count($items)){
		echo "<p>No events found</p>";
		return 0;
	} 
	
	#
	# Get/Set Inputs/Defaults
	$opt = json_decode($config);
	$json = isset($opt->json) ? filter_var($opt->json, FILTER_VALIDATE_BOOLEAN) : 0; // boolean - display as JSON 
	$limit = (isset($opt->limit) && filter_var($opt->limit, FILTER_VALIDATE_INT) > 0) ? filter_var($opt->limit, FILTER_VALIDATE_INT) : count($items);  // int - number of items to display
	$format = isset($opt->dateFormat) ? $opt->dateFormat : "Y-m-d"; // String - date format 
	$page = filter_input(INPUT_GET, "page", FILTER_VALIDATE_INT); // Get the current page number from URL
	$pagination = isset($opt->pagination) ? filter_var($opt->pagination, FILTER_VALIDATE_BOOLEAN) : 0; // boolean - show Pagination

	#
	# Display output as JSON
	if ($json) return json_encode($limit > 0 ? array_slice($items, 0, $limit) : $items);
	
	#
	# Pagination variables
	$pgcnt = count($items) > 0 && $limit > 0 ? ceil(count($items) / $limit) : 0;
	$page  = ($page > 0 && $page <= $pgcnt) ? $page : 1;
	$start = ($page - 1) * $limit;
	$end   = $start + $limit;
	
	if(filter_input(INPUT_GET, "tag", FILTER_SANITIZE_STRING))
		printf("<h2 class=\"filtered-category\"><small>categorized as: %s</small></h2>", filter_input(INPUT_GET, "tag", FILTER_SANITIZE_STRING));
	
	if($opt->media){
		for( $i = $start; $i < $end; $i++ ){
			if( $i >= count($items) ) break;
			
			outputAsMediaObject($items, $obj, $format);
		}
	} else {
		echo '<ul'.(isset($opt->style) ? ' class="'.$opt->style.'">' : ">");
		for( $i = $start; $i < $end; $i++ ){
			if( $i >= count($items) ) break;
			
			ouputAsListItem($items, $obj, $format);
		}
		echo '</ul>';
	}
	
	if($pagination)
		pagination($page, $pgcnt);
}
?>