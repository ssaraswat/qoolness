<%
/********** PLEASE NOTE *********
This file is statically (that is, compile-time) included by one or more JSPs.
********************************/
%>

<%@ page import="com.theavocadopapers.apps.kqool.util.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.control.*" %>


<%!

// three parallel arrays:
static final String[] NAV_SECTION_NAMES=
{
	AppConstants.SECTION_WORKOUTS,
	AppConstants.SECTION_USER_PREFS,
	AppConstants.SECTION_VIDEOS,
	AppConstants.SECTION_ARTICLES,
	"home",

};
static final String[] NAV_URLS=
{
	"workouts/index.jsp",
	"userprefs/prefs.jsp",
	"videos/index.jsp",
	"articles/index.jsp",
	"index.jsp",
};



static final int[] NAV_IMG_WIDTHS={138,111,133,138,67,};




	%><%
	if (PageUtils.isShowTopNav(request)) {
	%><script>
	var navSectionNames=<%=JsUtils.getJsArray(NAV_SECTION_NAMES)%>
	var currSectionName="<%=PageUtils.getSection(request)%>"
	var pathToAppRoot="<%=PageUtils.getPathToAppRoot(request)%>"
	var navImagesOver=new Object()
	var navImagesOut=new Object()
	for (var i=0; i<navSectionNames.length; i++) {
		navImagesOver[navSectionNames[i]]=new Image()
		navImagesOver[navSectionNames[i]].src=pathToAppRoot+"images/topnav/"+navSectionNames[i]+"_"+(currSectionName==navSectionNames[i]?"on":"over")+".gif"
		navImagesOut[navSectionNames[i]]=new Image()
		navImagesOut[navSectionNames[i]].src=pathToAppRoot+"images/topnav/"+navSectionNames[i]+"_"+(currSectionName==navSectionNames[i]?"on":"off")+".gif"
	}
	function navSwitch(isOver, navImgName) {
		document.images["navImg"+navImgName].src=window["navImages"+(isOver?"Over":"Out")][navImgName].src
	}
	</script>
	<div style="z-index:20;  position:absolute; top:94px; left:13px; width:800;">
	<%
	for (int i=0; i<NAV_SECTION_NAMES.length; i++) {
		String state=(PageUtils.getSection(request).equals(NAV_SECTION_NAMES[i])?"on":"off");
		%><a onmouseover="navSwitch(true, '<%=NAV_SECTION_NAMES[i]%>')" onmouseout="navSwitch(false, '<%=NAV_SECTION_NAMES[i]%>')" href="<%=PageUtils.getPathToAppRoot(request)%><%=NAV_URLS[i]%>?<%=controller.getSiteIdNVPair()%>" hidefocus="true"><img src="<%=PageUtils.getPathToAppRoot(request)%>images/topnav/<%=NAV_SECTION_NAMES[i]%>_<%=state%>.gif" name="navImg<%=NAV_SECTION_NAMES[i]%>" id="navImg<%=NAV_SECTION_NAMES[i]%>" height="71" width="<%=NAV_IMG_WIDTHS[i]%>" border="0" /></a><%
	}
	if (controller.getSessionInfo().getUser().isBackendUser()) {
		%><a href="<%=PageUtils.getPathToAppRoot(request)%>kqadmin/menu.jsp?<%=controller.getSiteIdNVPair()%>" hidefocus="true"><img style="margin-left:20px;" src="<%=PageUtils.getPathToAppRoot(request)%>images/topnav/control_panel_off.gif" height="71" width="124" border="0" /></a><%
	}
	%><br/>
	</div><%
}	
%>
