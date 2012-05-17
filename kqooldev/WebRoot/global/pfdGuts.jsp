<%@ page import="com.theavocadopapers.apps.kqool.*" %>
<%
PfdProperties pfdProps=(PfdProperties)request.getAttribute("pfdProps");

String viewSuffix=(String)request.getAttribute("viewSuffix");
boolean highlightTrueMedicalConditionBooleans;
try {
	highlightTrueMedicalConditionBooleans=(request.getAttribute("highlightTrueMedicalConditionBooleans")!=null && ((Boolean)request.getAttribute("highlightTrueMedicalConditionBooleans")).booleanValue());
}
catch (RuntimeException e) {
	highlightTrueMedicalConditionBooleans=false;
}
%>
	<%
	request.setAttribute("fieldName","activityLevel");
	request.setAttribute("pfdProps",pfdProps);
	pageContext.include("pfdSelect"+viewSuffix+".jsp");
	%><br/>
	<br/>

	<%
	request.setAttribute("fieldName","currentlyExercise");
	pageContext.include("pfdSelect"+viewSuffix+".jsp");
	%><br/>
	<br/>
	
	<%
	request.setAttribute("fieldName","howLongExercise");
	pageContext.include("pfdSelect"+viewSuffix+".jsp");
	%><br/>
	<br/>

	
	<table border="0" cellspacing="0" width="300" cellspacing="0" cellpadding="0">
	<% 
	request.setAttribute("currGroup", pfdProps.getItemsGroupCodes("pastExercise"));
	request.setAttribute("subhead",null);
	request.setAttribute("postNote",null);
	request.setAttribute("indent",new Boolean(false));
	request.setAttribute("bold",new Boolean(true));
	request.setAttribute("highlightTrueMedicalConditionBooleans", new Boolean(false));
	pageContext.include("pfdItemsGroup"+viewSuffix+".jsp");
	%>
	
	<tr>
	<td colspan="3"><br />
	<%
	request.setAttribute("subhead", pfdProps.getQuestion("currentWorkout"));
	request.setAttribute("fieldName","currentWorkout");
	pageContext.include("pfdTextarea"+viewSuffix+".jsp");
	%>
	</td>
	</tr>

	<tr>
	<td colspan="3">
	<%
	request.setAttribute("subhead", pfdProps.getQuestion("goals"));
	request.setAttribute("fieldName","goals");
	pageContext.include("pfdTextarea"+viewSuffix+".jsp");
	%>
	</td>
	</tr>

	<tr>
	<td colspan="3">
	<%
	request.setAttribute("subhead", pfdProps.getQuestion("comments"));
	request.setAttribute("fieldName","comments");
	pageContext.include("pfdTextarea"+viewSuffix+".jsp");
	%>
	</td>
	</tr>


	<% 
	request.setAttribute("currGroup", pfdProps.getItemsGroupCodes("medConditions1"));
	request.setAttribute("subhead","Have you ever been diagnosed with, or suffered from:");
	request.setAttribute("postNote","If you answered \"yes\" to any of the above conditions you <i>must have medical clearance before joining any exercise program.</i>");
	request.setAttribute("indent",new Boolean(false));
	request.setAttribute("bold",new Boolean(false));
	request.setAttribute("highlightTrueMedicalConditionBooleans", new Boolean(highlightTrueMedicalConditionBooleans));
	pageContext.include("pfdItemsGroup"+viewSuffix+".jsp");
	%>
	
	<tr>
	<td colspan="3"><br /></td>
	</tr>

	<% 
	request.setAttribute("currGroup", pfdProps.getItemsGroupCodes("medConditions2"));
	request.setAttribute("subhead","Have you ever been diagnosed with or do you have any of the following:");
	request.setAttribute("postNote",null);
	request.setAttribute("indent",new Boolean(false));
	request.setAttribute("bold",new Boolean(false));
	request.setAttribute("highlightTrueMedicalConditionBooleans", new Boolean(highlightTrueMedicalConditionBooleans));
	pageContext.include("pfdItemsGroup"+viewSuffix+".jsp");
	%>
	
	<tr>
	<td colspan="3"><br /><br /></td>
	</tr>

	<% 
	request.setAttribute("currGroup", pfdProps.getItemsGroupCodes("medConditions3"));
	request.setAttribute("subhead","Do you frequently experience any of the following:");
	request.setAttribute("postNote",null);
	request.setAttribute("indent",new Boolean(false));
	request.setAttribute("bold",new Boolean(false));
	request.setAttribute("highlightTrueMedicalConditionBooleans", new Boolean(highlightTrueMedicalConditionBooleans));
	pageContext.include("pfdItemsGroup"+viewSuffix+".jsp");
	%>
	
	<tr>
	<td colspan="3"><br /><br /></td>
	</tr>

	<% 
	request.setAttribute("currGroup", pfdProps.getItemsGroupCodes("medConditions4"));
	request.setAttribute("subhead",null);
	request.setAttribute("postNote",null);
	request.setAttribute("indent",new Boolean(false));
	request.setAttribute("bold",new Boolean(true));
	request.setAttribute("highlightTrueMedicalConditionBooleans", new Boolean(highlightTrueMedicalConditionBooleans));
	pageContext.include("pfdItemsGroup"+viewSuffix+".jsp");
	%>
	

	<tr>
	<td colspan="3"><br />
	<%
	request.setAttribute("subhead",pfdProps.getQuestion("takingMedications"));
	request.setAttribute("fieldName","takingMedications");
	pageContext.include("pfdTextarea"+viewSuffix+".jsp");
	%>
	</td>
	</tr>

	<tr>
	<td colspan="3">
	<%
	request.setAttribute("subhead",pfdProps.getQuestion("specialDiet"));
	request.setAttribute("fieldName","specialDiet");
	pageContext.include("pfdTextarea"+viewSuffix+".jsp");
	%>
	</td>
	</tr>

	<tr>
	<td colspan="3">
	<%
	request.setAttribute("subhead",pfdProps.getQuestion("specialPhysicalConditions"));
	request.setAttribute("fieldName","specialPhysicalConditions");
	pageContext.include("pfdTextarea"+viewSuffix+".jsp");
	%>
	</td>
	</tr>


	
	
	</table>
	<%
	request.setAttribute("fieldName","whyOnlineTraining");
	pageContext.include("pfdSelect"+viewSuffix+".jsp");
	%><br/>
	<br/>

	<%
	request.setAttribute("fieldName","whatMotivatesAboutPersonalTraining");
	pageContext.include("pfdSelect"+viewSuffix+".jsp");
	%><br/>
	<br/>


	<%
	request.setAttribute("fieldName","whatsImprovedMost");
	pageContext.include("pfdSelect"+viewSuffix+".jsp");
	%>

