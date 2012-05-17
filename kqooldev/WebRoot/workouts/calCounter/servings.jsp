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

String foodId=controller.getParam("foodId");
String chosenFood=controller.getParam("chosenFood");


 
List<Serving> servings=null;


servings=FoodDataCollector.getNutrientDataForServings(foodId);


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



<BODY onload="parent.showServings(document.getElementById('data').innerHTML)">



<%
out.flush();
response.flushBuffer();
%>

<div id="data" style="display:none; position:absolute; top:0px; left:0px; z-index:10">

<%
 
if (servings==null) {
	// null means there was an error:
	%>Hmm... Couldn't connect to the CalorieKing database.  Please try again later.<%
}
else if (servings.size()==0) {
	// null means there was an error:
	%>Sorry, no nutritional information available from the CalorieKing database for this food; please try another food. <%
}
else {
	%><b>3. How much of this food did you eat?</b><br/>
	<form style="margin:0px; padding:0px;" action="#" onsubmit="saveFoodItem(); return false">
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td>
	<input type="text" onblur="numServingsBlur(this)" name="numServings" value="1" id="numServings" class="inputText" style="width:20px" /><br/></td>
	<td> 
	<select class="inputText" style="margin-left:4px;" id="servingData" name="servingData" onchange="servingDataChange(this)">
	<%
	StringBuilder servingData;
	for (Serving serving : servings) {
		servingData=new StringBuilder();
		servingData.append("{\"calories\":\""+serving.getCalories()+"\",");
		servingData.append("\"calcium\":\""+serving.getCalcium()+"\",");
		servingData.append("\"carb\":\""+serving.getCarb()+"\",");
		servingData.append("\"cholesterol\":\""+serving.getCholesterol()+"\",");
		servingData.append("\"fat\":\""+serving.getFat()+"\",");
		servingData.append("\"fiber\":\""+serving.getFiber()+"\",");
		servingData.append("\"protein\":\""+serving.getProtein()+"\",");
		servingData.append("\"satfat\":\""+serving.getSatfat()+"\",");
		servingData.append("\"sodium\":\""+serving.getSodium()+"\","); 
		servingData.append("\"sugar\":\""+serving.getSugar()+"\",");
		servingData.append("\"chosenFood\":\""+URLEncoder.encode(chosenFood, "UTF-8")+"\",");
		servingData.append("\"name\":\""+URLEncoder.encode(serving.getName(), "UTF-8")+"\"}");
		%>
		<option value="<%=URLEncoder.encode(servingData.toString(), "UTF-8")%>"><%=serving.getName()%></option>
		<%
	}
	%>
	</select><br/></td>
	<td>&nbsp;(<span id="caloriesSpan">0</span> calories)</td>
	<td><input style="margin:4px 0px 0px 3px;" type="image" border="0" src="../../images/smallerButtons/save.gif" width="49" height="19" /><br/></td>
	</tr>
	</table> 
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

