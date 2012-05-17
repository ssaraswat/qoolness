<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

    
<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_VIDEOS,request); %>

<%@ include file="/global/topInclude.jsp" %>



<%




User user=controller.getSessionInfo().getUser();
String category=controller.getParam("category","");

List categories=ExerciseCategory.getAll();
Collections.sort(categories);
Map categoryCodesToCategoriesMap=new HashMap(categories.size());

String[] categoryCodes=new String[categories.size()];
for (int i=0; i<categories.size(); i++) {
	ExerciseCategory cat=(ExerciseCategory)categories.get(i);
	categoryCodes[i]=cat.getCode();
	categoryCodesToCategoriesMap.put(cat.getCode(), cat);
}

List exercisesWithVideos=null;
if (category.length()>0) {
	exercisesWithVideos=Exercise.getByCategory(category, true);
}
exercisesWithVideos=(exercisesWithVideos==null?new ArrayList():exercisesWithVideos);

Map videosMap=ExerciseVideo.getAllAsMap();

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>
<%@ include file="/global/validationJs.jsp" %>


<script type="text/javascript">

function getNewCategory(selectEl) {
	var selectedValue=selectEl.options[selectEl.selectedIndex].value
	if (selectedValue=="") {
		selectEl.selectedIndex=0
		return
	}
	else {
		location.href="index.jsp?<%=controller.getSiteIdNVPair()%>&category="+selectedValue
	}
}



</script> 

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">
<span class="standardTextBlockWidth">
<form action="processPrefs.jsp?<%=controller.getSiteIdNVPair()%>" method="post" onsubmit="return isValidForm(this)" name="mainForm" id="mainForm">

<font class="bodyFont">
<span class="standardTextBlockWidth">




<span class="firstSentenceFont">Ah, video. The wave of the future...</span><br />
  Drop-kick your DVD player and watch all the 
workout video you can get.
<%
if (category.length()==0) {
	// no category selected:
	%>Choose a category of exercise videos from the menu.<%
}
else {
	%>Click a video below to view it, or choose another category of exercises from the menu below  (the current category is "<%=((ExerciseCategory)categoryCodesToCategoriesMap.get(category)).getName()%>").<%
}
%><%=HtmlUtils.doubleLB(request)%>
<select class="selectText" name="category" onchange="getNewCategory(this)">
<option value="">Choose <%=category.length()==0?"a":"another"%> category...</option>
<%
for (int i=0; i<categoryCodes.length; i++) {
	if (categoryCodes[i]==null || categoryCodes[i].equals(category) || categoryCodes[i].equals("NONE")) {
		continue;
	}

	ExerciseCategory cat=(ExerciseCategory)categoryCodesToCategoriesMap.get(categoryCodes[i]);
	
	%>
	<option value="<%=categoryCodes[i]%>"><%=cat.getName()%></option>
	<%
}
%>
</select>
</span>
<br />
<br /><br />




<table border="0" cellspacing="0" cellpadding="0">

<%
for (int i=0; i<exercisesWithVideos.size(); i+=3) {
	Exercise exercise=(Exercise)exercisesWithVideos.get(i);
	ExerciseVideo video=(ExerciseVideo)videosMap.get(new Integer(exercise.getExerciseVideoId()));
	%>
	<tr valign="top">
	<td><%HtmlUtils.getVideoThumb(exercise, video, pageContext, controller); %></td>
	<td nowrap="nowrap" width="60">&nbsp;</td>
	<%
	if (i+1<exercisesWithVideos.size()) {
		exercise=(Exercise)exercisesWithVideos.get(i+1);
		video=(ExerciseVideo)videosMap.get(new Integer(exercise.getExerciseVideoId()));
		%>
		<td><%HtmlUtils.getVideoThumb(exercise, video, pageContext, controller); %></td>
		<td nowrap="nowrap" width="60">&nbsp;</td>		
		<%
	}
	if (i+2<exercisesWithVideos.size()) {
		exercise=(Exercise)exercisesWithVideos.get(i+2);
		video=(ExerciseVideo)videosMap.get(new Integer(exercise.getExerciseVideoId()));
		%>
		<td><%HtmlUtils.getVideoThumb(exercise, video, pageContext, controller); %></td>
		<%
	}
	%>
	</tr>
	<%
}
%>


</table>	




</div>

<%=HtmlUtils.doubleLB(request)%></font>

</form></span>
</div>

<%@ include file="/global/bodyClose.jsp" %>

</html>





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

