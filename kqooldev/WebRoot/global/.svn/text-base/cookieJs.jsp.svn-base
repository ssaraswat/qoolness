<%



/********** PLEASE NOTE *********
This file is statically (that is, compile-time) included by one or more JSPs.
********************************/



%><script>

function setCookie (name,value,expires,path,domain,secure)
{
	document.cookie = name + "=" + escape (value) +
		((expires && expires!=null) ? "; expires=" + expires.toGMTString() : "") +
		((path) ? "; path=" + path : "") +
		((domain) ? "; domain=" + domain : "") +
		((secure) ? "; secure" : "");
}


// do not call this function directly:
function _getCookieVal (offset) {
	var endstr = document.cookie.indexOf (";", offset);
	if (endstr == -1) endstr = document.cookie.length;
	return unescape(document.cookie.substring(offset, endstr))
}

function getCookie (name) {
	var arg = name + "=";
	var alen = arg.length;
	var clen = document.cookie.length;
	var i = 0;
	while (i < clen) { 
		var j = i + alen;
		if (document.cookie.substring(i, j) == arg) return _getCookieVal (j);
		i = document.cookie.indexOf(" ", i) + 1;
		if (i == 0) break;
	}
	return null
}
</script>



