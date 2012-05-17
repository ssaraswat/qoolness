<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>

<%@ page import="com.theavocadopapers.apps.kqool.food.*" %>

<%@ include file="/global/topInclude.jsp" %>

<%!


%>

<%



User user=controller.getSessionInfo().getUser();

String kqfoodquery=controller.getParam("kqfoodquery", "");


List<Food> foods=null;


foods=FoodDataCollector.searchForFoodsByKeywords(kqfoodquery);


%>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<HTML>
<HEAD>
<TITLE></TITLE>

<script type="text/javascript">


document.domain="<%=new com.theavocadopapers.apps.kqool.GenericProperties().getJavascriptDocumentDomain()%>"

</script>

<%@ include file="/global/calCounterJs.jsp" %>



</HEAD>



<BODY onload="parent.showSearchResults(document.getElementById('data').innerHTML)">



<%
out.flush();
response.flushBuffer();
%>

<div id="data" style="display:none; position:absolute; top:0px; left:0px; z-index:10">

<%
 
if (foods==null) {
	// null means there was an error:
	%>Hmm... Couldn't connect to the CalorieKing database.  Please try again later.<br/><%
}
else if (foods.size()==0) {
	// null means there was an error:
	%>Sorry, no results returned by CalorieKing for "<%=kqfoodquery%>".  Please try another search.<br/><%
}
else { 
	%>

	  
	<b>2. Which one of these did you eat?</b>
	<form onsubmit="chooseFood(document.getElementById('foodIdSelect'), false); return isValidSearchResultsForm(this)" style="padding:0px; margin:0px; display:inline;" action="servings.jsp" target="hiddenIframe" name="searchResultsForm" id="searchResultsForm">
	<input type="hidden" name="siteId" value="<%=controller.getSiteId()%>" />
	<input type="hidden" name="chosenFood" id="chosenFood" value="[value not set]" />
	<select class="inputText" style="width:575px; height:130px;" size="15" name="foodId" id="foodIdSelect"  xondblclick="chooseFood(this, true); setTimeout('servingsLoading()', 10)">
	<%
	for (Food food: foods) { %>
		<option value="<%=food.getId()%>"><%=food.getLabel()%></option>
	<%
	}%>
	</select><br/>
	<input style="margin-top:3px;" type="image" border="0" src="../../images/smallerButtons/choose.gif" width="49" height="19" /><br/>
	<script type="text/javascript">
	try {
		window.document.getElementById('foodIdSelect').focus();
	}
	catch (e) {}
	</script>
	</form>
	<%
}

%>


</div>



<%@ include file="/global/trackingCode.jsp" %>



</BODY>
</HTML>






<%@ include file="/global/bottomInclude.jsp" %>


<%
if (pageException!=null)
{
	%>
	<%@ include file="/global/jspErrorDialogLaunch.jsp" %>
	<%
}
%>




<% PageUtils.jspEnd(request); %>

