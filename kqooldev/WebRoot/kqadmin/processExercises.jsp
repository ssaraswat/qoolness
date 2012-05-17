<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

  
<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setRequiredRequestMethod("POST",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>


<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%

String successParam;

try
{
	int numExercises=controller.getParamAsInt("numExercises");
	for (int i=0; i<numExercises; i++)
	{
		Exercise exercise=Exercise.getById(controller.getParamAsInt("id"+i));
		exercise.setName(controller.getParam("name"+i));
		exercise.setQuantityMeasure(controller.getParam("quantityMeasure"+i));
		exercise.setIntensityMeasure(controller.getParam("intensityMeasure"+i));
		exercise.setDescription(controller.getParam("description"+i));
		exercise.setCategory(controller.getParam("category"+i));
		exercise.setCalorieFactor(controller.getParamAsDouble("calorieFactor"+i));
		exercise.setMaxLevel(controller.getParamAsInt("maxLevel"+i, 0)); // default to 0, which is the appropriate value whenever intensityMeasure isn't "LEVEL" (and we've already validated to see if that's the case)
		exercise.setCalorieCalculationMethod(controller.getParam("calorieCalculationMethod"+i));
		exercise.store();
	}
	successParam="true";
}
catch (Exception e)
{
	successParam="false";
}

controller.redirect("confirmExerciseAction.jsp?"+controller.getSiteIdNVPair()+"&mode=edit&id="+URLEncoder.encode(controller.getParam("id0"))+"&success="+successParam);
%>

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

