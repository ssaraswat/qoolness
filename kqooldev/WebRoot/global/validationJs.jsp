<%



/********** PLEASE NOTE *********
This file is statically (that is, compile-time) included by one or more JSPs.
********************************/



%><% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<script>

var OK_USERNAME_CHARS="<%=AppConstants.OK_USERNAME_CHARS%>"
var OK_PASSWORD_CHARS="<%=AppConstants.OK_PASSWORD_CHARS%>"
var USERNAME_MIN_LENGTH=<%=AppConstants.USERNAME_MIN_LENGTH%>
var USERNAME_MAX_LENGTH=<%=AppConstants.USERNAME_MAX_LENGTH%>
var PASSWORD_MIN_LENGTH=<%=AppConstants.PASSWORD_MIN_LENGTH%>
var PASSWORD_MAX_LENGTH=<%=AppConstants.PASSWORD_MAX_LENGTH%>

function isValidUsernameOrPasswordOrSA(s,minLength,maxLength,okChars)
{
	if (s.length>maxLength || s.length<minLength)
	{
		return false
	}
	for (var i=0; i<s.length; i++)
	{
		var c=s.charAt(i)
		if (okChars.indexOf(c)==-1)
		{
			return false
		} 
	}
	return true
}

function isValidUsername(s)
{
	return isValidUsernameOrPasswordOrSA(s,USERNAME_MIN_LENGTH,USERNAME_MAX_LENGTH,OK_USERNAME_CHARS)
}
function isValidPassword(s)
{
	return isValidUsernameOrPasswordOrSA(s,PASSWORD_MIN_LENGTH,PASSWORD_MAX_LENGTH,OK_PASSWORD_CHARS)
}
function isValidSecretAnswer(s)
{ 
	return isValidUsernameOrPasswordOrSA(s, 1, 16, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890-_. ")
}

function isValidEmail(s)
{
	s=""+s
	if (s.length==0 || s.indexOf("@")==-1 || s.indexOf(".")==-1)
	{
		return false
	}
	var splitOnAt=s.split("@")
	if (splitOnAt.length!=2)
	{
		return false
	}
	var preAt=splitOnAt[0]
	var postAt=splitOnAt[1]
	if (preAt.length==0)
	{
		return false
	}
	if (postAt.length==0)
	{
		return false
	}
	if (postAt.indexOf(".")==-1)
	{
		return false
	}
	var splitOnDot=postAt.split(".")
	if (splitOnDot[splitOnDot.length-1].length<2)
	{
		return false
	}
	for (var i=0; i<splitOnDot.length; i++)
	{
		if (splitOnDot.length==0)
		{
			return false
		}
	}
	return true
}

function isValidURL(s)
{
	var validProtocols=["http://","https://","ftp://","mailto:","file://"]
	for (var i=0; i<validProtocols.length; i++)
	{
		if (s.indexOf(validProtocols[i])==0) // i.e. starts with...
		{
			return true
		}
	}
	return false
}

function radioGroupValue(formObj,elName)
{
	var els=formObj.elements
	for (var i=0; i<els.length; i++)
	{
		if (""+els[i].name==""+elName && els[i].checked)
		{
			return els[i].value
		}
	}
	return "";
}


function isInteger(s)
{
	return containsOnly(s,"01234567890")
}

function isNumber(s)
{
	return containsOnly(s,".01234567890-")
}


function isValidZIP(s) {
	if (!(isInteger(s))) {
		return false
	}
	if (!(s.length==5)) {
		return false
	}
	return true
}

function containsOnly(s,okChars)
{
	for (var i=0; i<s.length; i++)
	{
		if (okChars.indexOf(s.charAt(i))==-1)
		{
			return false
		}
	}
	return true
}

function selectMenuOption(menuObj,value)
{
	for (var i=0; i<menuObj.options.length; i++)
	{
		if (menuObj.options[i].value==value)
		{
			menuObj.selectedIndex=i
			return
		}
	}
}


function selectValue(selectObj)
{
	if (selectObj.selectedIndex==-1)
	{
		return null
	}
	return selectObj.options[selectObj.selectedIndex].value
}
</script>

