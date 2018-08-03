<?php

// Show all errors
error_reporting(0);
ini_set('display_errors', 0);

function get_dirname($url){
	$dir = preg_replace('/[^\/]+\.[^\/]+$/', '', $url);
	return (substr($dir, -1, 1) == "/") ? substr($dir, 0, strlen($dir) - 1) : $dir;
}

function get_filename($file){
	return strrpos($file, ".") 
		? substr($file, 0, strrpos($file, ".")) 
		: (substr($file, -1, 1) == "/" ? substr($file, 0, strlen($file) - 1) : $file);
}

function insert_html_into_lis($prev, $lis, $html, $level){
	global $cur;
	
	if(empty($html)){
		foreach(simplexml_load_string("<items>$lis</items>")->xpath("/items/li") as $li)
			$html .= (!empty($cur) && (get_filename($cur) == get_filename($li->a["href"])))
				? "<li class=\"active\" aria-current=\"page\"><a href=\"".$li->a["href"]."\">".$li->a[0]."</a></li>"
				: $li->asXML();
		return $html;
	}
	
	$ret = "";
	foreach(simplexml_load_string("<items>$lis</items>")->xpath("/items/li") as $li)
		$ret .= (get_dirname($prev) == get_dirname($_SERVER["DOCUMENT_ROOT"].$li->a["href"]))
			? "<li class=\"active\"><a href=\"".$li->a["href"]."\">".$li->a[0]."</a><ul class=\"submenu level_". $level ."\">$html</ul></li>"
			: $li->asXML();
	return $ret;
}

function recurse($dir, $prev, &$html){
	global $nav;
	global $cnt;
	
	#
	# Get the file contents;
	# trim off space at the ends;
	# strip out everything but <li> <a> and <span> tags.
	$lis = file_exists($dir.$nav) ? strip_tags(trim(file_get_contents($dir.$nav)), "<li><a><span>") : '';
	
	if($dir > $_SERVER["DOCUMENT_ROOT"] && !empty($lis)){
		#
		# by the time $html has content, we are already in the parent.
		$html = insert_html_into_lis($prev, $lis, $html, $cnt);
		$cnt--;
		recurse(dirname($dir), $dir, $html);
	}
}
$cur = isset($_GET["page"]) ? filter_input(INPUT_GET, "page", FILTER_SANITIZE_STRING) : (isset($page) ? $page : "");
$dir = isset($_GET["path"]) ? filter_input(INPUT_GET, "path", FILTER_SANITIZE_STRING) : (isset($path) ? $path : "");
$cnt = count(explode("/", $dir)) - 1;

$nav = "/_nav.inc";
$html = "";
recurse($_SERVER["DOCUMENT_ROOT"].get_dirname($dir), "", $html);
echo '<ul class="parent list-unstyled script-menu level_'.$cnt.'">'.$html."</ul>";
?>