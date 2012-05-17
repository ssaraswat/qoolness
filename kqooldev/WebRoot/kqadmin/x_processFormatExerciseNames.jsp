<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>
<% PageUtils.setRequiredLoginStatus("superuser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>

<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<%@ include file="/global/topInclude.jsp" %>
<%
ConnectionWrapper cw=DatabaseManager.getConnection();

List exes=Exercise.selectAll(cw);
Collections.sort(exes, new ExerciseComparator(ExerciseComparator.NAME));

for (int i=0; i<exes.size(); i++) {
	Exercise ex=(Exercise)exes.get(i);
	ex.setName(controller.getParam("name"+ex.getId()));
	ex.update(cw);
}


DatabaseManager.closeConnection(cw);
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
