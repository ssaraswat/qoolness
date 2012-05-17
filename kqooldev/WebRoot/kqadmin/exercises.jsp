<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<%@ page import="com.theavocadopapers.apps.kqool.entity.comparator.ExerciseComparator" %>
<%@ page import="com.theavocadopapers.hibernate.SessionWrapper" %>

<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_EXERCISES,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

static final String[][] SORTS={
	{""+ExerciseComparator.NAME,"Name"},
	{""+ExerciseComparator.CATEGORY,"Category"},
};


static final String[][] VIDEO_MODES={
	{"0","all exercises, with or without videos"},
	{"1","exercises with videos"},
	{"2","exercises without videos"},
};


static final String[][] SHOW_FULL_DESCRIPTION={
	{"false","no"},
	{"true","yes"},
};


%>

<%

// Opening a session here in the JSP tier.  This should not usually be
// done; doing it here because this page makes many db queries.  When
// we do do this, the entire JSP MUST be enclosed in a try block (and
// not the try block provided by the framework; an explicit one), and
// the session MUST be closed in a finally block.
SessionWrapper sessionWrapper=SessionWrapper.openIfNotOpen(null);
try {
	boolean doDisplay=(request.getParameter("doDisplay")!=null && request.getParameter("doDisplay").equals("true"));

	
	String mode=controller.getParam("mode"); // "add" or "edit"
	

	
	
	
	
	
	
	boolean showFullDesc=controller.getParamAsBoolean("showFullDesc",false);
	String sortType=request.getParameter("sortType");
	sortType=(sortType!=null?sortType:SORTS[0][0]);
	String videoMode=request.getParameter("videoMode");
	videoMode=(videoMode!=null?videoMode:"0");
	String category=controller.getParam("category", "ABS");
	String contains=controller.getParam("contains", "").trim();
	int siteInt=controller.getParamAsInt("site", -1);
	
	List allExercises=new ArrayList();
	
	if (doDisplay) {
		List rawAllExercises=Exercise.getAll(sessionWrapper);
		
		if (rawAllExercises==null) {
			rawAllExercises=new ArrayList();
		}

		// FIRST, do sort:
		// sort by name first, regardless of sort type:
		Collections.sort(rawAllExercises);
		if (sortType.equals(""+ExerciseComparator.CATEGORY)) {
			Collections.sort(allExercises, new ExerciseComparator(ExerciseComparator.CATEGORY));
		}	
		allExercises=new ArrayList(rawAllExercises.size());
		
		ListIterator it=rawAllExercises.listIterator();
		int listSize=0;
		
	
		// SECOND, do all filtering:
		boolean doSearch=(contains.length()>0);
		String lcContains=contains.toLowerCase();
		int videoModeInt=Integer.parseInt(videoMode);
		while (it.hasNext()) {
			Exercise exercise=(Exercise)it.next();
			if (
				(videoModeInt==0 || (videoModeInt==1 && exercise.getExerciseVideoId()>0) || (videoModeInt==2 && exercise.getExerciseVideoId()==0)) &&
				(!doSearch || (exercise.getName().toLowerCase().indexOf(lcContains)>-1)) &&
				(category.equals("ALL") || category.equals(exercise.getCategory())) &&
				(siteInt==-1 || siteInt==exercise.getSiteId())
			) {
				allExercises.add(exercise);
				listSize++;
			}
		}
		
	
	}
	

	
	
	
	
	
	
	
	List intensityMeasuresList=ExerciseIntensityMeasure.getAll(sessionWrapper);
	//List intensityMeasuresList=ExerciseIntensityMeasure.getAll();
	List quantityMeasuresList=ExerciseQuantityMeasure.getAll(sessionWrapper);
	//List quantityMeasuresList=ExerciseQuantityMeasure.getAll();
	List categoriesList=ExerciseCategory.getAll(sessionWrapper);
	//List categoriesList=ExerciseCategory.getAll();
	HashMap intensityCodesToNamesMap=new HashMap(intensityMeasuresList.size());
	HashMap quantityCodesToNamesMap=new HashMap(quantityMeasuresList.size());
	HashMap categoryCodesToNamesMap=new HashMap(categoriesList.size());
	for (int i=0; i<intensityMeasuresList.size(); i++) {
		ExerciseIntensityMeasure m=(ExerciseIntensityMeasure)intensityMeasuresList.get(i);
		intensityCodesToNamesMap.put(m.getCode(),m.getName());
	}
	for (int i=0; i<quantityMeasuresList.size(); i++) {
		ExerciseQuantityMeasure m=(ExerciseQuantityMeasure)quantityMeasuresList.get(i);
		quantityCodesToNamesMap.put(m.getCode(),m.getName());
	}
	for (int i=0; i<categoriesList.size(); i++) {
		ExerciseCategory m=(ExerciseCategory)categoriesList.get(i);
		categoryCodesToNamesMap.put(m.getCode(),m.getName());
	}
	
	
	String[] names=new String[allExercises.size()];
	String[] quantityMeasures=new String[allExercises.size()];
	String[] intensityMeasures=new String[allExercises.size()];
	String[] categories=new String[allExercises.size()];
	String[] descriptions=new String[allExercises.size()];
	int[] ids=new int[allExercises.size()];
	String[] videoLinks=new String[allExercises.size()];
	double[] calorieFactors=new double[allExercises.size()];
	String[] calorieCalculationMethods=new String[allExercises.size()];
	

	List videosList=ExerciseVideo.getAll(sessionWrapper);
	//List videosList=ExerciseVideo.getAll();
	HashMap videos=new HashMap(videosList.size());
	for (int i=0; i<videosList.size(); i++) {
		ExerciseVideo vid=(ExerciseVideo)videosList.get(i);
		videos.put(new Integer(vid.getId()),vid);
	}
	
	
	for (int i=0; i<allExercises.size(); i++)
	{
		Exercise exercise=(Exercise)allExercises.get(i);
		names[i]=exercise.getName();
		quantityMeasures[i]=exercise.getQuantityMeasure();
		intensityMeasures[i]=exercise.getIntensityMeasure();
		calorieFactors[i]=exercise.getCalorieFactor();
		calorieCalculationMethods[i]=exercise.getCalorieCalculationMethod();
		categories[i]=exercise.getCategory();
		descriptions[i]=exercise.getDescription();
		if (!showFullDesc && descriptions[i]!=null && descriptions[i].length()>50) {
			descriptions[i]=descriptions[i].substring(0,50)+"...";
		}
		ids[i]=exercise.getId();
                videoLinks[i]="";
                ExerciseVideo video;
                String thumbFilename;
                if (exercise.getExerciseVideoId()>0) {
                        video=(ExerciseVideo)videos.get(exercise.getExerciseVideoId());
                        if (video != null) {
                        thumbFilename=video.getFilename().substring(0,video.getFilename().lastIndexOf("."))+".jpg";
                        thumbFilename = thumbFilename.replaceAll(" ","_");
                        videoLinks[i]="<a href=\"#\" onclick=\"getVideo("+video.getId()+", '"+video.getFilename()+"'); return false;\"><img src=../images/videograbs/"+thumbFilename+" width=55 height=41 border=1 /></a>";
                        }
                }
        }

	
	%>
	
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
	<html>
	<head>
	 
	<%@ include file="/global/headInclude.jsp" %>
	
	<script type="text/javascript">
	
	var showFullDesc=<%=showFullDesc%>;
	 

	function confirmSubmit(formObj) {
		var selectedCat=formObj.elements.category;
		var containsText=formObj.elements.contains.value;
		var selectedCategory=selectedCat.options[selectedCat.selectedIndex].value;
		if (containsText.length>0 || selectedCategory!="ALL") {
			return true;
		}
		return confirm("You have chosen to view exercises in all categories, without narrowing the list with a search, so this page may take a while to load; okay to proceed?");
	}

	</script>
	
	<style type="text/css">
	.evenDataRow {background-color:#ffffff;}
	.oddDataRow {background-color:#ffffff;}
	.columnDataFont {font-size:11px; font-family:arial,helvetica; padding:4px 12px 4px 0px;}
	
	</style>
	</head>
	
	<%@ include file="/global/bodyOpen.jsp" %>
	
	<div id="mainDiv">

	<form action="exercises.jsp" method="get" onsubmit="return confirmSubmit(this)" name="mainForm" id="mainForm">
	<input type="hidden" name="siteId" value="<%=controller.getSiteId()%>" />
	<input type="hidden" name="doDisplay" value="true" />
	
	<font class="bodyFont">
	<span class="standardAdminTextBlockWidth">
	<span class="firstSentenceFont">View all your clients here.</span><br />
	
	<%
	if (!doDisplay) {
		// user hadn't entered any display criteria yet:
		%>
		To view exercises, please choose view options below, and then press the "view client list" button.
		<%
	}
	else {
		%>The list of exercises, as filtered and sorted,
		 appears below. Click an "edit" button to edit an exercise, or an "add video" 
		 or "change/remove video" button to manage an exercise's video.<%
	}
	%>
	
	<br /><br />
	
	
	
	
	</span>
	
	<div style="border:1px solid #999999; xbackground-color:#eeeeee; padding:4px;">
	<div style="padding:2px; background-color:#cccccc; font-weight:bold;">View options:</div><br/>
	
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td align="right" nowrap="nowrap" class="bodyFont"><i>Filter by category: show...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
	<td colspan="8"><select class="selectText" name="category">
			<option value="ALL" <%="ALL".equals(category)?" selected ":""%>>exercises in all categories</option>
	
	<%
	
	
	for (int i=0; i<categoriesList.size(); i++) {
		ExerciseCategory cat=(ExerciseCategory)categoriesList.get(i);
		%>
		<option value="<%=cat.getCode()%>" <%=cat.getCode().equals(category)?" selected ":""%>>exercises in the '<%=cat.getName()%>' category only</option>
		<%
	}
	%>
	</select>
	
	
	</td>
	</tr>
	

	
	<tr>
	<td><img src="../images/spacer.gif" height="8" width="1"><br /></td>
	</tr>

	<tr>
	<td align="right" nowrap="nowrap" class="bodyFont"><i>Filter by site: show...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
	<td colspan="8"><select class="selectText" name="site">
			<option value="-1" <%=siteInt==-1?" selected ":""%>>exercises available to clients of all sites</option>
	
	<%
	
	List sites=Site.getAll();
	for (int i=0; i<sites.size(); i++) {
		Site site=(Site)sites.get(i);
		%>
		<option value="<%=site.getId()%>" <%=site.getId()==siteInt?" selected ":""%>>exercises available only to clients of <%=site.getLabel()%></option>
		<%
	}
	%>
	</select>
	
	
	</td>
	</tr>
	

	
	<tr>
	<td><img src="../images/spacer.gif" height="8" width="1"><br /></td>
	</tr>
	
	<tr>
	<td align="right" nowrap="nowrap" class="bodyFont"><i>Filter by video: show...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
	<td colspan="8"><select class="selectText" name="videoMode">
	<%
	
	
	for (int i=0; i<VIDEO_MODES.length; i++) {
		%>
		<option value="<%=VIDEO_MODES[i][0]%>" <%=videoMode.equals(VIDEO_MODES[i][0])?" selected ":""%>><%=VIDEO_MODES[i][1]%></option>
		<%
	}
	%>
	</select>
	
	
	</td>
	</tr>
	

	
	<tr>
	<td><img src="../images/spacer.gif" height="8" width="1"><br /></td>
	</tr>
	
	<tr>
	<td align="right" nowrap="nowrap" class="bodyFont"><i>Show full descriptions?...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
	<td colspan="8"><select class="selectText" name="showFullDesc">
	<%
	
	
	for (int i=0; i<SHOW_FULL_DESCRIPTION.length; i++) {
		%>
		<option value="<%=SHOW_FULL_DESCRIPTION[i][0]%>" <%=(""+showFullDesc).equals(SHOW_FULL_DESCRIPTION[i][0])?" selected ":""%>><%=SHOW_FULL_DESCRIPTION[i][1]%></option>
		<%
	}
	%>
	</select>
	
	
	</td>
	</tr>
	
	<tr>
	<td><img src="../images/spacer.gif" height="8" width="1"><br /></td>
	</tr>
	
	
	<tr>
	<td align="right" nowrap="nowrap" class="bodyFont"><i>Sort exercises by...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
	<td colspan="8"><select class="selectText" name="sortType">
	<%
	
	
	for (int i=0; i<SORTS.length; i++) {
		%>
		<option value="<%=SORTS[i][0]%>" <%=sortType.equals(SORTS[i][0])?" selected ":""%>><%=SORTS[i][1]%></option>
		<%
	}
	%>
	</select>
	</td>
	</tr>
	
	
		<tr>
		<td><img src="../images/spacer.gif" height="8" width="1"><br /></td>
		</tr>
	
	
		<tr>
		<td align="right" nowrap="nowrap" class="bodyFont"><i>Exercise name contains...&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</i></td>
		<td colspan="8"><input type="text" name="contains" value="<%=contains%>" class="inputText" style="width:130px;" /><br/>
		
		
		</td>
		</tr>	


	<tr>
	<td></td>
	<td colspan="4"><input style="margin-top:12px; " type="submit" value="view exercises list" class="controlPanelSmallButton"></td>
	</tr>
	</table>
	<br/>
	
	</div><br/>


	<%
	if (doDisplay && allExercises.size()==0) {
		%><i style="color:#ff6600;">No exercises match your "view options" criteria above.<br/></i><%
	}
	else if (doDisplay && allExercises.size()>0) {
		%>
		
		<table border="0" cellspacing="0" cellpadding="0" width="661"> 
		<%=HtmlUtils.getHorizRuleTr(12, request)%>
		<tr class="headerRow" height="20">
		<%=HtmlUtils.getSingleRuleCell(request)%>
		<td nowrap="nowrap" width="5" valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;<br /></font></td>
		<td nowrap="nowrap" width="107" valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Name&nbsp;&nbsp;&nbsp;<br /></font></td>
		<td nowrap="nowrap" width="100" valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Intensity Units&nbsp;&nbsp;&nbsp;<br /></font></td>
		<td nowrap="nowrap" width="100" valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Quantity Units&nbsp;&nbsp;&nbsp;<br /></font></td>
		<td nowrap="nowrap" width="70" valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Category&nbsp;&nbsp;&nbsp;<br /></font></td>
		<td nowrap="nowrap" width="100" valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Calorie Factor&nbsp;&nbsp;&nbsp;<br /></font></td>
		<td nowrap="nowrap" width="120" valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Cal. Calc. Method&nbsp;&nbsp;&nbsp;<br /></font></td>
		<td nowrap="nowrap" width="70" valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Video&nbsp;<br /></font></td>
		<td nowrap="nowrap" width="110" valign="middle" align="center"><font class="boldishColumnHeaderFont">&nbsp;Description&nbsp;&nbsp;&nbsp;<br /></font></td>
		<td nowrap="nowrap" width="90" valign="middle" align="center"><font class="boldishColumnHeaderFont"><img src="../images/spacer.gif" height="1" width="1" /><br /></font></td>
		<%=HtmlUtils.getSingleRuleCell(request)%>
		</tr>
		<%=HtmlUtils.getHorizRuleTr(12, request)%>
		
		
		<% 
		
		for (int i=0; i<names.length; i++)
		{
			%>
			<input type="hidden" name="id<%=i%>" id="id<%=i%>" value="<%=ids[i]%>">
			<tr valign="top" align="left" class=<%=((((double)i/2)==(double)((int)(i/2)))?"evenDataRow":"oddDataRow")%>>
			<%=HtmlUtils.getSingleRuleCell(request)%>
			<td class="columnDataFont">&nbsp;<br /></td>
			<td style="padding-left:4px;" class="columnDataFont"><%=names[i]%><br /></td>
			<td class="columnDataFont"><nobr>&nbsp;<%=intensityCodesToNamesMap.get(intensityMeasures[i])%><br /></nobr></td>
			<td class="columnDataFont"><nobr>&nbsp;<%=quantityCodesToNamesMap.get(quantityMeasures[i])%><br /></nobr></td>
			<td class="columnDataFont"><nobr>&nbsp;<%=categoryCodesToNamesMap.get(categories[i])%><br /></nobr></td>
			<td class="columnDataFont"><nobr>&nbsp;<%=calorieFactors[i]%><br /></nobr></td>
			<td class="columnDataFont"><nobr>&nbsp;<%=Exercise.calCalcMethodsToLabels.get(calorieCalculationMethods[i])%><br /></nobr></td>
			<td class="columnDataFont"><%=videoLinks[i]%>&nbsp;&nbsp;<br /></td>
			<td class="columnDataFont"><%=descriptions[i]%><br /></td>
			<td>
			
			<div style="margin:3px;"><%=HtmlUtils.smallCpFormButton(false, "edit", "location.href='editExercise.jsp?"+controller.getSiteIdNVPair()+"&id="+ids[i]+"'", request)%><br />
			<%=HtmlUtils.smallCpFormButton(false, videoLinks[i].length()>0?"change/remove video":"add video", "location.href='editExerciseVideo.jsp?"+controller.getSiteIdNVPair()+"&exerciseId="+ids[i]+"'", request)%><br /></font>
			</div></td>
			<%=HtmlUtils.getSingleRuleCell(request)%>
			</tr>
		
			<%=HtmlUtils.getHorizRuleTr(12, request)%>
			
			<%
			response.flushBuffer();
			out.flush();
		}
		
		
		%>
		</table>
	<%
	} // end if doDisplay
	%>
	<br />
	
	<%=HtmlUtils.doubleLB(request)%><br />
	
	
	<br /></font>
	
	</form></span>
	</div>
	
	<%@ include file="/global/bodyClose.jsp" %>
	
	
	
	</html>
	<%
}
finally {
	SessionWrapper.closeIfNotNested(sessionWrapper);
}
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

