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


boolean error=false;
try {
	String changedVideoIds=controller.getParam("changedVideoIds");
	boolean videosChanged;
	if (changedVideoIds.endsWith(",")) {
		changedVideoIds=changedVideoIds.substring(0, changedVideoIds.length()-1);
		//System.out.println("changedVideoIds="+changedVideoIds);
		videosChanged=true;
	}
	else {
		videosChanged=false;
	}
	if (videosChanged) {
		StringTokenizer tzr=new StringTokenizer(changedVideoIds,",");
		int[] videoIds=new int[tzr.countTokens()];
		int c=0;
		while (tzr.hasMoreTokens()) {
			videoIds[c]=0;
			try {
				videoIds[c]=Integer.parseInt(tzr.nextToken());
			}
			catch (NumberFormatException e) {}
			c++;
		}
		for (int i=0; i<videoIds.length; i++) {
			
			int exerciseId=controller.getParamAsInt("id"+videoIds[i],0);
			//System.out.println(">>>>>>> videoId="+videoIds[i]+"; exerciseId="+exerciseId);
			boolean addMapping=(exerciseId>0 && videoIds[i]>0);
			VideoToExerciseMapping mapping;
			if (addMapping) {
				mapping=new VideoToExerciseMapping();
				mapping.setExerciseId(exerciseId);
				mapping.setExerciseVideoId(videoIds[i]);
				//System.out.println("Testing mapping exid "+exerciseId+" to vidid "+videoIds[i]+"");
				try {
					VideoToExerciseMapping.selectByExerciseVideoId(cw, videoIds[i]);
					VideoToExerciseMapping.selectByExerciseId(cw, exerciseId);
					mapping.update(cw);
				}
				catch (ExpectedDataNotFoundException e) {
					//System.out.println("Mapping exid "+exerciseId+" to vidid "+videoIds[i]+"");
					if (cw==null || cw.getConnection().isClosed()) {
						cw=DatabaseManager.getConnection();
					}
					mapping.insert(cw);
				}
			}
			else {
				if (videoIds[i]>0 && controller.getParamAsInt("currExerciseId"+videoIds[i],0)>0) {
					try {
						//System.out.println("Deleting exid "+controller.getParamAsInt("currExerciseId"+videoIds[i],0)+"/vidid "+videoIds[i]+"");
						if (cw==null || cw.getConnection().isClosed()) {
							cw=DatabaseManager.getConnection();
						}
						VideoToExerciseMapping.delete(cw, videoIds[i], controller.getParamAsInt("currExerciseId"+videoIds[i],0));
					}
					catch (Exception e) {
					}
				}
			}
		}
	}
}
catch (Exception e) {
	error=true;
	session.setAttribute("ex", e);
}
controller.redirect("x_manageVideos.jsp?c=true&e="+error);

%>



<%
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
