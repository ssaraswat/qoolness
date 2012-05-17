<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_EXERCISES,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%



String mode=controller.getParam("mode"); // "add" or "edit"
boolean success=controller.getParamAsBoolean("success",true);


List allExercises=Exercise.getAll();
if (allExercises==null)
{
	allExercises=new ArrayList();
}

Collections.sort(allExercises);

List intensityMeasuresList=ExerciseIntensityMeasure.getAll();
List quantityMeasuresList=ExerciseQuantityMeasure.getAll();
HashMap intensityCodesToNamesMap=new HashMap(intensityMeasuresList.size());
HashMap quantityCodesToNamesMap=new HashMap(quantityMeasuresList.size());
for (int i=0; i<intensityMeasuresList.size(); i++) {
	ExerciseIntensityMeasure m=(ExerciseIntensityMeasure)intensityMeasuresList.get(i);
	intensityCodesToNamesMap.put(m.getCode(),m.getName());
}
for (int i=0; i<quantityMeasuresList.size(); i++) {
	ExerciseQuantityMeasure m=(ExerciseQuantityMeasure)quantityMeasuresList.get(i);
	quantityCodesToNamesMap.put(m.getCode(),m.getName());
}


String[] names=new String[allExercises.size()];
String[] quantityMeasures=new String[allExercises.size()];
String[] intensityMeasures=new String[allExercises.size()];
String[] descriptions=new String[allExercises.size()];
int[] ids=new int[allExercises.size()];

for (int i=0; i<allExercises.size(); i++)
{
	Exercise exercise=(Exercise)allExercises.get(i);
	names[i]=exercise.getName();
	quantityMeasures[i]=exercise.getQuantityMeasure();
	intensityMeasures[i]=exercise.getIntensityMeasure();
	descriptions[i]=exercise.getDescription();
	ids[i]=exercise.getId();
}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
 
<%@ include file="/global/headInclude.jsp" %>

<script type="text/javascript">

</script>

<style type="text/css">

</style>
</head>

<%@ include file="/global/bodyOpen.jsp" %>

<div id="mainDiv">
<span class="standardAdminTextBlockWidth">
<form>
<font class="bodyFont">


<%
if (success)
{
	%>
	<span class="firstSentenceFont">Edit exercises here.</span> The current list of exercises appears below.
	<%
}
else
{
	%>
	<span class="firstSentenceFont">There was a problem.</span> Some or all of your data may not have been saved. The current list of instances is below.

	<%
}
%>

<table border="0" cellspacing="0" cellpadding="0" width="650"> 
<%@ include file="exercisesTableHeaderRow.jsp" %>
 
<% 

for (int i=0; i<names.length; i++)
{
	%>
	<input type="hidden" name="id<%=i%>" id="id<%=i%>" value="<%=ids[i]%>">
	<tr valign="top" class=<%=((((double)i/2)==(double)((int)(i/2)))?"evenDataRow":"oddDataRow")%>>
	<%=HtmlUtils.getSingleRuleCell(request)%>
	<td align="left" style="padding-top:4px; padding-bottom:4px;"><font class="columnDataFont">&nbsp;<br /></font></td>
	<td align="left" style="padding-top:4px; padding-bottom:4px;"><font class="columnDataFont">&nbsp;<%=names[i]%>&nbsp;&nbsp;&nbsp;<br /></font></td>
	<td align="left" style="padding-top:4px; padding-bottom:4px;"><font class="columnDataFont"><nobr>&nbsp;<%=intensityCodesToNamesMap.get(intensityMeasures[i])%>&nbsp;&nbsp;&nbsp;<br /></nobr></font></td>
	<td align="left" style="padding-top:4px; padding-bottom:4px;"><font class="columnDataFont"><nobr>&nbsp;<%=quantityCodesToNamesMap.get(quantityMeasures[i])%>&nbsp;&nbsp;&nbsp;<br /></nobr></font></td>
	<td align="left" style="padding-top:4px; padding-bottom:4px;"><font class="columnDataFont"><%=descriptions[i]%>&nbsp;&nbsp;&nbsp;<br /></font></td>
	<%=HtmlUtils.getSingleRuleCell(request)%>
	</tr>
	<%=HtmlUtils.getHorizRuleTr(7, request)%>
	<%
}

%>

<tr>
<td nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1" /><br /></td>
<td nowrap="nowrap" width="5"><img src="../images/spacer.gif" height="1" width="1" /><br /></td>
<td nowrap="nowrap" width="133"><img src="../images/spacer.gif" height="1" width="1" /><br /></td>
<td nowrap="nowrap" width="110"><img src="../images/spacer.gif" height="1" width="1" /><br /></td>
<td nowrap="nowrap" width="140"><img src="../images/spacer.gif" height="1" width="1" /><br /></td>
<td nowrap="nowrap" width="260"><img src="../images/spacer.gif" height="1" width="1" /><br /></td>
<td nowrap="nowrap" width="1"><img src="../images/spacer.gif" height="1" width="1" /><br /></td>
</tr>
</table><br />

<%=HtmlUtils.doubleLB(request)%><br />


<br /></font>

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

