<%



/********** PLEASE NOTE *********
This file is statically (that is, compile-time) included by one or more JSPs.
********************************/



%><% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>
<%!
static GenericProperties genProps=new GenericProperties();
%>
<%

Client headIncludeClient=new Client(request);

String currentSectionName=PageUtils.nonNull(PageUtils.getSection(request)).trim().toLowerCase();
String currentSubsectionName=PageUtils.nonNull(PageUtils.getSubsection(request)).trim().toLowerCase();
boolean isPopup=(controller.getParamAsBoolean("isPopup") || currentSectionName.equals("feedback") || currentSectionName.equals("issuespopup") || currentSectionName.equals("adminpopup") || currentSectionName.equals("about") || currentSectionName.equals("help"));


boolean showHeaderElements=(controller.getParam("showHeaderEls","true").equals("true"));
boolean isAdmin=currentSectionName.equals("admin");

String ctxPath=request.getContextPath();


%>

<% // Include c/r notice on all client-visible pages: %>
<!--
<%=siteProps.getCopyrightNoticeHtmlCode()%>
-->
<title><%=siteProps.getDefaultPageTitle()%></title>

<%
if (!PageUtils.isErrorPage(request))
{
	%>
	<noscript>
	<META HTTP-EQUIV="refresh" content="0;URL=<%=PageUtils.getPathToAppRoot(request)%>errors/error.jsp?e=noJs"> 
	</noscript>
	<%
}
%>

<script src=<%=ctxPath%>/global/Calendar.js></script>
<script src=<%=ctxPath%>/global/HashMap.js></script>
<script type="text/javascript" src="<%=PageUtils.getPathToAppRoot(request)%>global/prototype-1.6.0.3.js"></script>
<script type="text/javascript" src="<%=PageUtils.getPathToAppRoot(request)%>global/logger.js"></script>

<script>

document.domain="<%=genProps.getJavascriptDocumentDomain()%>"

<%
String[] errorPrefixes=siteProps.getErrorPrefixes();
%>
var ERROR_PREFIXES=[<%

for (int i=0; i<errorPrefixes.length; i++) {
	if(i>0) {
		%>,<%
	}
	%>"<%=errorPrefixes[i]%>"<%
}
%>]

var isDemo=<%=""+session.getAttribute("isDemoAttr")%>

function demoCheck() {

}

// client properties:
var clientIsExp=<%=""+headIncludeClient.isExp()%>
var clientIsNav=<%=""+headIncludeClient.isNav()%>
var clientIsMac=<%=""+headIncludeClient.isMac()%>
var clientIsWin=<%=""+headIncludeClient.isWin()%>
var clientFullVersion="<%=headIncludeClient.getFullVersion()%>"

// holds values that are "in transit" from a function to its callback function while a dialog is open in browsers that don't support modal wins (or don't properly support them)
var callbackValuesHolder=new Object()


window.focus()

// these are here so as not to get method-not-foundish errors; the "real" versions are in modalFrameset.jsp:
function doModalClose() {}
function setModalReturnValue() {}

var keepaliveImage=new Image()

var pathToAppRoot="<%=controller.getPathToAppRoot()%>"
function getVideo(id, filename) {
	var vidWin=window.open(pathToAppRoot+"video/exercises/"+filename,"video"+id, "scrollbars=0, status=1, location=0, menus=0, resizable=0, resizeable=0, directories=0, width=360, height=290")
	vidWin.focus()
}


function launchCalendar(formObj, yearElName, monthElName, dateElName)
{
	var els=formObj.elements
	var date=els[dateElName].options[els[dateElName].selectedIndex].value
	var month=els[monthElName].options[els[monthElName].selectedIndex].value
	var year=els[yearElName].options[els[yearElName].selectedIndex].value

	if (date=="") {date=1}
	else {date=parseInt(date)}
	
	if (month=="") {month=0}
	else {month=parseInt(month)}
	
	if (year=="") {year=new Date(window.now).getFullYear()}
	else {year=parseInt(year)}
	
	// have to make sure date of month is valid for month:
	var dateTestCal=new Calendar()
	dateTestCal.set(dateTestCal.DATE,1)
	dateTestCal.set(dateTestCal.MONTH,month)
	dateTestCal.set(dateTestCal.YEAR,year)
	date=Math.min(date,dateTestCal.getDaysInMonth())
	
	var url="global/calendar.jsp?<%=controller.getSiteIdNVPair()%>%date="+date+"&month="+month+"&year="+year+"&showTime=false&yearElName="+yearElName+"&monthElName="+monthElName+"&dateElName="+dateElName+"&formObjName="+formObj.name
	callbackValuesHolder.els=els
	openDialogWithCallback(url, "calendarWin", 281, 258, false, true,"launchCalendarCALLBACK")
}

function launchCalendarCALLBACK(newDateArray)
{
	// if user didn't choose a date, then newDateArray will equal []; otherwise it will be
	// a four-el array of nums: year, month, date (using array instead of object or
	// custom object b/c have had trouble in the past with objects returned by modal
	// dialogs; also passing values as vars, not array, to setNewDate(), for same reason):

	if (newDateArray!=null && newDateArray.length==7)
	{
		setNewDate(callbackValuesHolder.els,newDateArray[0],newDateArray[1],newDateArray[2],newDateArray[3],newDateArray[4],newDateArray[5],newDateArray[6])
	}

}

function setNewDate(els,year,month,date, formName, yearElName ,monthElName ,dateElName)
{

	setSelect(els[yearElName],""+year)
	setSelect(els[monthElName],""+month)
	setSelect(els[dateElName],""+date)

}

function setSelect(selectObj,s)
{
	for (var i=0; i<selectObj.options.length; i++)
	{
		var thisOption=selectObj.options[i]
		if (thisOption.value==s)
		{
			thisOption.selected=true
		}
		else
		{
			thisOption.selected=false
		}
	}
}






var currentSectionName="<%=currentSectionName%>"
var currentSubsectionName="<%=currentSubsectionName%>"

function sessionKeepalive()
{
	var url=pathToAppRoot+"global/kp.jsp?x="+new Date().getTime()
	window.keepaliveImage.src=url
}

var pathToAppRoot="<%=PageUtils.getPathToAppRoot(request)%>"

setInterval(sessionKeepalive,1000*60*5)

var FILTER_WIN_HEIGHT=520

function init()
{} // override this as needed.



function hidePageAndShowPleaseWait()
{
	if (document.getElementById("mainDiv")!=null)
	{
		document.getElementById("mainDiv").style.display="none"
	}
	if (document.getElementById("popupMainDiv")!=null)
	{
		document.getElementById("popupMainDiv").style.display="none"
	}
	if (document.getElementById("adminYouAreLoggedIn")!=null)
	{
		document.getElementById("adminYouAreLoggedIn").style.display="none"
	}

	document.getElementById("genericPleaseWaitDiv").style.display="block"
	window.scroll(0,0)
}


function showPageAndHidePleaseWait()
{
	if (document.getElementById("mainDiv")!=null)
	{
		document.getElementById("mainDiv").style.display="block"
	}
	if (document.getElementById("popupMainDiv")!=null)
	{
		document.getElementById("popupMainDiv").style.display="block"
	}
	document.getElementById("genericPleaseWaitDiv").style.display="none"
}

function toTwoDigit(n)
{
	var s=""+n
	if (s.length==2)
	{
		return s
	}
	if (s.length==1)
	{
		return "0"+s
	}
	return "00"
}

function errorAlert(s,el)
{
	// el is optional; if passed, it must be a form-element reference to be focused:
	var doFocus=(arguments.length>1 && !(el.type=="hidden"))
	if (doFocus)
	{
		doElementFocus(el)
	}
	var prefixIdx=randomInt(ERROR_PREFIXES.length);
	if (prefixIdx==0) {
		// the "child is crying because" one; this should run a a sentence into the first sentence of the msg, so the first letter of the msg should be lowercased:
		s=s.charAt(0).toLowerCase()+s.substring(1,s.length);
	}
	alertConfirm(ERROR_PREFIXES[prefixIdx]+" "+s,true,true)
	// focus twice becasue the first scrolls the field into view before the alert, and the 
	// second actually keeps focus after the user closes the alert:
	if (doFocus)
	{
		doElementFocus(el)
	}	
}


function randomInt(lessThan) {
	lessThan=parseInt(lessThan)
	var rnd=Math.random()
	rnd*=lessThan
	rnd=Math.floor(rnd)
	return rnd
}



function doElementFocus(el)
{
	if (el.focus)
	{
		el.focus()
	}
}

function generalAlert(s,height)
{
	if (arguments.length==1)
	{
		height=-1
	}
	alertConfirm(s,true,false,height)
}

function generalConfirm(s,height)
{
	if (arguments.length==1)
	{
		height=-1
	}
	return alertConfirm(s,false,false,height)
}

function isDoCustomAlertConfirm()
{
	// no more pretty alerts; very 2002, and popup blockers get them sometimes now --
	return false;
	//return (window.showModalDialog && navigator.appVersion.toLowerCase().indexOf("win")>-1)
}

function alertConfirm(msgText, isAlert, isError, height)
{
	if (arguments.length==3 || height==-1)
	{
		height=240
	}
	if (isDoCustomAlertConfirm())
	{
		var url
		var props
		url=pathToAppRoot+"global/alertConfirm.jsp?<%=controller.getSiteIdNVPair()%>&error="+(isError?"true":"false")+"&text="+escape(msgText)+"&type="+(isAlert?"alert":"confirm")
		props="dialogHeight:"+height+"px; dialogWidth:340px; center:yes; edge:raised; help:no; resizable:no; scroll:no; status:no; unadorned:no; "

		if (isAlert)
		{
			window.showModalDialog(url,null,props)
		}
		else
		{
			return window.showModalDialog(url,null,props)
		}
	}
	else
	{
		if (isAlert)
		{
			alert(msgText)
		}
		else
		{
			return confirm(msgText)
		}
	}
}

function dontShowHTML(cookieSuffix,isAsk)
{
	if (isDoCustomAlertConfirm())
	{
		return "</B><font style=\"font-size:6px; \"><BR><BR></font><input style=\"border-width:0px; width:auto; background-color:transparent;\" onclick=\"window.focusOkButton?focusOkButton():void(0)\" type=checkbox id=dontShow name=dontShow value=\""+cookieSuffix+"\"><label for=dontShow>Don't "+(isAsk?"ask":"tell")+" me this again during this session.</label><B>"
	}
	else
	{
		return ""
	}
}


function okToShowDialog(cookieSuffix)
{
	return (getCookie("suppress"+cookieSuffix)==null || getCookie("suppress"+cookieSuffix)=="false")
}


function checkRadioWithNameAndValue(formName, elName, elValue)
{
	var els=document.forms[formName].elements
	for (var i=0; i<els.length; i++)
	{
		if (""+els[i].name==""+elName && ""+els[i].value==""+elValue)
		{
			els[i].checked=true
		}
	}
}

function trim(str)
{
	s=new String(str)
	while (s.charAt(0)==" " || s.charAt(0)=="\t" || s.charAt(0)=="\r" || s.charAt(0)=="\n")
	{
		s=s.substring(1,s.length)
	}
	while (s.charAt(s.length-1)==" " || s.charAt(s.length-1)=="\t" || s.charAt(s.length-1)=="\r" || s.charAt(s.length-1)=="\n")
	{
		s=s.substring(0,s.length-1)
	}
	return ""+s
}

function openWin(winUrl, winName, height, width, scrollbars, customProps) // scrollbars is boolean, not a String
{
	var props
	if (arguments.length==6) // note: if customProps is passed, then scrollbars is ignored
	{
		props=""+customProps
	}
	else
	{
		props="toolbar=0, location=0, directories=0, status=0, menubar=0, scrollbars="+(scrollbars?"1":"0")+", resizable=1, "
	}
	props+="height="+height+", width="+width
	var win=window.open(winUrl,winName,props)
	var winOpen=false
	if (win.opener) {
		if (win.opener==window) {
			return win
		}
	}
	alert("You appear to have software that is blocking popups from Kqool. Kqool can't function properly unless it can use popup windows to display information to you.  (Note: Kqool does not launch popup ads.)")
}

function openModalWin(winUrl, height, width, scrollbars)
{
	var props="dialogHeight:"+height+"px; dialogWidth:"+width+"px; center:yes; edge:raised; help:no; resizable:no; scroll:"+(scrollbars?"yes":"no")+"; status:no; unadorned:no; "
	var url=window.pathToAppRoot+"global/modalFrameset.jsp?u="+escape(winUrl)+"&s="+(scrollbars?"yes":"no")+"&p="+escape(window.pathToAppRoot)
	return window.showModalDialog(url,null,props)
}

function openModelessWin(winUrl, height, width, scrollbars)
{
	var props="dialogHeight:"+height+"px; dialogWidth:"+width+"px; center:yes; edge:raised; help:no; resizable:no; scroll:"+(scrollbars?"yes":"no")+"; status:no; unadorned:no; "
	return window.showModelessDialog(window.pathToAppRoot+"global/modalFrameset.jsp?u="+escape(winUrl)+"&s="+(scrollbars?"yes":"no")+"&p="+escape(window.pathToAppRoot),null,props)
}


function openDialog(winUrl, winName, height, width, scrollbars, modal, callbackFunctionName)
{
	if (arguments.length==6)
	{
		callbackFunctionName=""
	}
	if (window.showModalDialog)
	{
		if (modal)
		{
			return openModalWin(winUrl, height, width, scrollbars)
		}
		else
		{
			openModelessWin(winUrl, height, width, scrollbars)
		}
	}
	else
	{
		openWin(window.pathToAppRoot+"global/modalFrameset.jsp?cfn="+callbackFunctionName+"&u="+escape(winUrl)+"&s="+(scrollbars?"yes":"no")+"&p="+escape(window.pathToAppRoot), winName, height, width, scrollbars)
	}
}


function openDialogWithCallback(winUrl, winName, height, width, scrollbars, modal, callbackFunctionName)
{
	if (window.showModalDialog)
	{
		// treat this as a normal model win; it will return a value (don't pass the last fn-name arg)
		retVal=openDialog(winUrl, winName, height, width, scrollbars, modal)
		window[callbackFunctionName](retVal)
	}
	else
	{
		// else the win itself will call the callback fn:
		openDialog(winUrl, winName, height, width, scrollbars, modal, callbackFunctionName)
	}
	
}
 



function launchFeedback(isSupportRequest)
{
	var url=top.location.href
	if (url.indexOf("/help/")>-1)
	{
		url=""
	}
	openWin(pathToAppRoot+"feedback/compose.jsp?<%=controller.getSiteIdNVPair()%>&isSupportRequest="+(isSupportRequest?"true":"false")+"&currUrl="+escape(url), "kqoolFeedback", 490, 320, false)
	
	
	//openWin(window.pathToAppRoot+"feedback/compose.jsp?<%=controller.getSiteIdNVPair()%>&isSupportRequest="+(isSupportRequest?"true":"false")+"&currUrl="+escape(url), (isSupportRequest?"supportWindow":"helpWindow"), 580, 340, true)

}

function showWorkout(id, prescriptive)
{

	if (arguments.length==1) {
		prescriptive=true
	}
	openWin("showWorkout.jsp?<%=controller.getSiteIdNVPair()%>&prescriptive="+prescriptive+"&isPopup=true&mode=view&id="+trim(id), "workout"+trim(id), 600, 450, true)
	
	
	//openWin(window.pathToAppRoot+"feedback/compose.jsp?isSupportRequest="+(isSupportRequest?"true":"false")+"&currUrl="+escape(url), (isSupportRequest?"supportWindow":"helpWindow"), 580, 340, true)

}

  

function urlDecode(s) 
{
	return unescape(s).replace(/\+/g," ")
}
	
function endsWith(str, endStr) {
	return (str.lastIndexOf(endStr)==str.length-endStr.length)
}
function formatTextAsHTML(s, charLimit, issueId, listType, issueStatus)
{
	if (arguments.length==1) {
		charLimit=999999
		issueId=0
		listType=-1
		issueStatus=-1
	}
	if (charLimit<=0) {
		charLimit=999999
	}
	var isStandardList=(listType==0)
	var isPrintableList=(listType==1)
	var isExportList=(listType==2)
	var isImportPreviewList=(listType==3)
	var isClosed=(issueStatus>=30)
	
	var ret=""+s
	ret=ret.replace(/&amp;/g,"&amp;amp;")
	ret=ret.replace(/&nbsp;/g,"&amp;nbsp;")
	ret=ret.replace(/&quot;/g,"&amp;quot;")
	ret=ret.replace(/&copy;/g,"&amp;copy;")
	ret=ret.replace(/&gt;/g,"&amp;gt;")
	ret=ret.replace(/&lt;/g,"&amp;lt;")
	ret=ret.replace(/&reg;/g,"&amp;reg;")
	ret=ret.replace(/</g,"&lt;")
	ret=ret.replace(/>/g,"&gt;")
	ret=replaceEOLWithBR(ret)
	if (isStandardList) {
		var truncated=false
		if (ret.length>charLimit) {
			ret=ret.substring(0,charLimit)
			truncated=true
		}
		while (truncated && ret.length>0 && (endsWith(ret, " ") || endsWith(ret, "<BR") || endsWith(ret, "<B") || endsWith(ret, "<"))) {
			ret=ret.substring(0, ret.length-1)
		}
		if (truncated) {
			ret+="... <nobr>[<a href=\"#\" onclick=\""+(isClosed?"reopenIssue":"editIssue")+"("+issueId+")\">full description</a>]</nobr>"
		}
	}

	return ret
}

function replaceEOLWithBR(s)
{
	var ret=""+s
	ret=ret.replace(/\|\|\|\|\|eol\|\|\|\|\|/g,"\n")
	ret=ret.replace(/\r\n/g,"\n") // for pc
	ret=ret.replace(/\r/g,"\n") // for mac
	ret=ret.replace(/\n/g,"<BR>") // for mac, pc, unix
	return ret
}

function removeArrayElement(a,idx)
{
	var ret=[]
	for (var i=0; i<a.length; i++)
	{
		if (i!=idx)
		{
			ret[ret.length]=a[i]
		}
	}
	return ret
}

 
function launchTargetWeightCalculator()
{
	var url=top.location.href
	if (url.indexOf("/help/")>-1)
	{
		url=""
	}
	openWin(pathToAppRoot+"userutils/targetWeightPopup.jsp?<%=controller.getSiteIdNVPair()%>&currUrl="+escape(url), "kqoolTargetWeight", 500, 580, true)
}

function launchCaloriesExpendedCalculator(weight)
{
	if (arguments.length==0) {
		weight=""
	}
	var url=top.location.href
	if (url.indexOf("/help/")>-1)
	{
		url=""
	}
	openWin(pathToAppRoot+"userutils/caloriesExpendedPopup.jsp?<%=controller.getSiteIdNVPair()%>&weight="+weight+"&currUrl="+escape(url), "kqoolCaloriesExpended", 390, 320, false)
}

</script>

<style type=text/css>

<%
if (showHeaderElements)
{
	if (isPopup)
	{
		%>
		body {background-repeat:repeat-x; background-image:url(<%=PageUtils.getPathToAppRoot(request)%>images/bg_popup.gif); }

		<%
	}
	else if (!isAdmin) 
	{ 
		%>
		body {background-repeat:repeat-x; background-image:url(<%=PageUtils.getPathToAppRoot(request)%>images/bg.gif); }

		<%
	}
	else // is admin:
	{ 
		%>
		body {background-repeat:repeat-x; background-image:url(<%=PageUtils.getPathToAppRoot(request)%>images/adminBg.gif); }

		<%
	}
}
%>
a {text-decoration:underline; }
a:hover {color:#ff0000; }
           

#mainDiv {}
#popupHeaderDiv {position:absolute; top:46px; left:0px; width:250px; }
#popupMainDiv {position:absolute; top:76px; left:13px; width:300px; }
.popupFirstSentenceFont{color:#000000; font-weight:bold; font-size:14px; vertical-align:bottom;}
.inputText {background-color:#eeeeee; padding-top:1px; padding-bottom:1px; padding-left:2px; height:18px; border: 1px solid #666666; font-size:11px; font-family:arial,helvetica; }
.textareaText {background-color:#eeeeee; padding:2px; border: 1px solid #666666; font-size:11px; font-family:arial,helvetica; }
.noBorder {border:0px solid #ffffff; }
.headerRow {background-color:#ffffff; }
.dataRow {background-color:#cccccc; } 
.evenDataRow {background-color:#ffffff; color:#000000; cursor:default; xdisplay:block; } 
.oddDataRow {background-color:#ffffff; color:#000000; cursor:default; xdisplay:block;} 
.hiddenDataRow {display:none;} 
.selectedDataRow {background-color:#ff9900; color:#000000; cursor:default; display:block;} 
.ruleRow {background-color:#7f7f7f; }  
.ruleRowSelected {background-color:#7f7f7f; }  
.associatedInstancesSelect {width:200px; border: 1px solid #6A6A4F; font-size:12px; font-family:arial,helvetica; }
.selectText {background-color:#eeeeee; border: 1px solid #666666; font-size:11px; font-family:arial,helvetica; }

.boldishFont {color:#444444; font-family:arial,helvetica; font-size:12px; font-weight:bold; }
.boldishColumnHeaderFont {color:#444444; font-family:arial,helvetica; font-size:12px; font-weight:bold; }
 
.errorDiv {padding:4px; font-weight:bold; border:1px solid #000000; background-color:#ff6600;   width:250px; }

 
.firstSentenceFont {color:#000000; font-weight:bold; font-size:15px; vertical-align:bottom;}
.quickhelpHeaderFont {color:#000000; font-weight:bold; }
.formButton {background-color:#ff6600; border:1px solid #000000; color:ffffff; font-family:arial,helvetica; font-size:13px; width:65px; }
.standardTextBlockWidth {width:250px; display:block;}  
.standardAdminTextBlockWidth {width:675px; display:block; }  

.bodyFont {font-size:12px; font-family:arial,helvetica;  color:#000000;   }  
.leftNavFont {font-size:11px; font-family:arial,helvetica;  color:#666666;  text-decoration:none;  }  
.headerFont {font-size:16px; font-family:arial,helvetica; }
.topNavFont {font-size:10px; font-family:arial,helvetica; }
.activeSectionLinkFont {font-size:10px; font-family:arial,helvetica; color:#ffffff; }
.columnDataFont {font-size:11px; font-family:arial,helvetica; }
.statusFont {font-family:verdana, arial, helvetica; font-size:12px; color:#777777; }

.videoTitle {font-size:12px; font-family:arial,helvetica; font-weight:bold; }
.videoDescription {font-size:12px; font-family:arial,helvetica; }

.controlPanelSmallButton {margin:1px 0px 1px 0px; font-size:11px; font-family:arial,helvetica; xborder:1px solid #666666; background-color:#99CB00; width:115px}
.controlPanelButton {margin:1px 0px 1px 0px; font-size:16px; font-weight:bold; font-family:arial,helvetica; xborder:1px solid #666666; background-color:#99CB00; width:150px;}
/*below added by Rob D. 10/08*/

#homeButton01,
#homeButton02 {
	width:299px;
	height:125px;
	margin:20px 0 45px 0px;
}

#trial #homeButton02 {
	margin:0px 0 0px 0px;
}

#homeButton01 {
	background:url("<%=ctxPath%>/images/home_button_01.jpg") no-repeat;
}

#homeButton02 {
	background:url("<%=ctxPath%>/images/home_button_02.jpg") no-repeat;
}

#homeButton01 h2,
#homeButton02 h2 {
	text-indent:-4000px;
	margin:0px 0 20px 0px;
	position:relative;
	top:15px;
	left:20px;
}

#homeButton01 h2 {
	top:20px;
	width:225px;
	height:33px;
	background:url("<%=ctxPath%>/images/button1_h2.gif") no-repeat;
}

#homeButton02 h2 {
	width:166px;
	height:38px;
	background:url("<%=ctxPath%>/images/button2_h2.gif") no-repeat;
}

#homeButton01 p,
#homeButton02 p {
	font-size:11px;
	line-height:13px;
	color:#fff;
	font-family:arial;
	margin:0px 0 0 20px;
}

#homeButton01 a,
#homeButton02 a,
#homeButton01 a:visited,
#homeButton02 a:visited {
	display:block;
	height:125px;
	text-decoration:none;
}

#homeButton01 a:hover,
#homeButton02 a:hover {
	text-decoration:none;
}

/*end rob D. additions*/

<%
if (isAdmin) {
	%>#genericPleaseWaitDiv {position:absolute; top:-90px; left:-30px; display:none;}
	<%
}
else {
	%>#genericPleaseWaitDiv {position:absolute; top:0px; left:0px; display:none;}
	<%
}
%>







</style>

  