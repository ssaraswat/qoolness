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

List vids=ExerciseVideo.selectAll(cw);
Collections.sort(vids, new ExerciseVideoComparator(ExerciseVideoComparator.NAME));

for (int i=0; i<vids.size(); i++) {
	ExerciseVideo v=(ExerciseVideo)vids.get(i);
	v.setName(controller.getParam("name"+v.getId()));
	v.update(cw);
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
