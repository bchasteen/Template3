/**
* Set classes and accessibility attributes for side menu
*/
String.prototype.endsWith = function(suffix) {
    return this.indexOf(suffix, this.length - suffix.length) !== -1;
};
function findParents(el){
	if(!el) return 0;

	if(el.parentElement.nodeName == "LI") setClass(el.parentElement, "active");
	if(el.parentElement.nodeName !== "NAV") findParents(el.parentElement);
}
function fixPath(url){
	if(!url) return 0;

	// Remove file extension
	if(url.indexOf(".") >= 0) url.substring(url.indexOf(".") , -1);

	// Add slash if it doesn't have one;
	return url.endsWith("/") ? url : url + "/"; 
}
function setClass(el, val){
	el.setAttribute("class", (el.getAttribute("class") && el.getAttribute("class") != val) ? el.getAttribute("class") + " " + val : val);
}

var li = document.querySelectorAll("#left-column ul li");
var path = fixPath(location.pathname);

Array.prototype.forEach.call(li, function(el, i){

	var	link = el.getElementsByTagName("a").length ? fixPath(el.getElementsByTagName("a")[0].pathname) : "";

	if(link &&  link == path){
		setClass(el, "active");
		el.setAttribute("aria-current", "page");
		findParents(el);
	}
});