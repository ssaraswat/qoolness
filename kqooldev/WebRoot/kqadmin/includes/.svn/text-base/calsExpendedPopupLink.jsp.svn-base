<%@ page import="com.theavocadopapers.apps.kqool.control.*" %>
<%
Controller controller=(Controller)request.getAttribute("controller");
%>

<script>

function launchCaloriesExpendedCalculator()
{
	var url=top.location.href
	if (url.indexOf("/help/")>-1)
	{
		url=""
	}
	openWin(pathToAppRoot+"userutils/caloriesExpendedPopup.jsp?<%=controller.getSiteIdNVPair()%>&currUrl="+escape(url), "kqoolCaloriesExpended", 390, 320, false)
}
</script> (View the calories-expended popup <a href="#" onclick="launchCaloriesExpendedCalculator(); return false;">here.</a>)