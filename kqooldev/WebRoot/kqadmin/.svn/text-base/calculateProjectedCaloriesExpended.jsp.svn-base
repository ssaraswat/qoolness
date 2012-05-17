<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>

<% request.setAttribute("suppressRenderedTimeComment", "true"); %>

<%@ include file="/global/topInclude.jsp" %>
<%
try {
%>
<%=Exercise.calculateProjectedCaloriesExpended(
		controller.getParamAsInt("exerciseId"), 
		controller.getParamAsDouble("currentClientWeight"), 
		controller.getParamAsDouble("intensity"), 
		controller.getParamAsDouble("quantity"), 
		controller.getParamAsInt("reps")
	)%>|<%=controller.getParamAsInt("idx")%>
<%
}
catch (Exception e) {
	com.theavocadopapers.core.logging.Logger.getRootLogger().error("Exception trying to calculateProjectedCaloriesExpended()", e);
}
%>
<%@ include file="/global/bottomInclude.jsp" %>
