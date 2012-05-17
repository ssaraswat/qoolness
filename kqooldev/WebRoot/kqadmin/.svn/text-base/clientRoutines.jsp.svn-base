<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% /* PageUtils.setRequiredLoginStatus("backenduser",request); */  %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_USERS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%! 
static DateFormat workoutDateTimeFormat=new SimpleDateFormat("MM/dd/yyyy 'at' hh:mm a");
static int numRoutinesToShow=5;
%>

<%

int clientId=controller.getParamAsInt("id");

User viewingUser=null;

if (clientId>0) {
	viewingUser=User.getById(clientId);

	
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
	List allUsers=User.getAll();
	if (allUsers==null) {
		allUsers=new ArrayList(0);
	}
	Map allUsersMap=User.getAllAsMap();
	Map allSitesMap=Site.getAllAsMap();
	
	
	request.setAttribute("intensityCodesToNamesMap", intensityCodesToNamesMap);
	request.setAttribute("quantityCodesToNamesMap", quantityCodesToNamesMap);
	request.setAttribute("allUsers", allUsers);
	request.setAttribute("allUsersMap", allUsersMap);
	
	User user=controller.getSessionInfo().getUser();
	
	
	
	
	
	List routines;
	//if (mode.equals("routines")) {
		routines=Workout.getAdministratorAssignedByUserId(viewingUser.getId(), numRoutinesToShow, true);
	//}
	//else {
	//	routines=Workout.getUserCreated(viewingUser.getId(), false, numRoutinesToShow);
	//}
	routines=(routines==null?new ArrayList():routines);
	
	%>
	
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
	<html>
	<head>
	
	<%@ include file="/global/headInclude.jsp" %>
	<%@ include file="/global/validationJs.jsp" %>
	
	<script type="text/javascript">
	
	</script>
	
	<style type="text/css">
	body {background-image: url(none); background-color:#ffffff;}
	</style>
	</head>
	
	<body link="#ff9900" vlink="#ff9900;">
	
	
	
	<font class="bodyFont">
	<div id="loading">
	<b style="color:#990000;">[Loading client's past routines...]</b>
	<%
	out.flush();
	response.flushBuffer();
	%>
	</div> 
	
	<div id="loadedData" style="display:none;">
	
	<%
	
	long nowTime;
	Workout routine;
	Workout workoutStoredFromRoutine;
	boolean completed;
	boolean pastDue;
	int c;
	
	if (routines.size()==0) {
		%><i>No routines have been assigned to this client.</i><br/><br/><%
	}
	
	else {
		%><i>Here are the last <%=numRoutinesToShow%> routines assigned to this user.</i><br/><br/><%
		Iterator it=routines.iterator();
		nowTime=new Date().getTime();
		c=1;
		int workoutStoredFromRoutineId;
		while (it.hasNext()) {
			routine=(Workout)it.next();
			completed=(routine.getRecordedAsWorkoutDate()!=null);
			pastDue=(!completed && routine.getDueDate()!=null && routine.getDueDate().getTime()<nowTime);
			workoutStoredFromRoutine=null;
			workoutStoredFromRoutineId=0;
			if (completed) {
				workoutStoredFromRoutine=Workout.getBySourceWorkoutId(routine.getId());	
				workoutStoredFromRoutineId=workoutStoredFromRoutine.getId();
			}
			%>
			<div style="font-weight:bold; padding:3px; background-color:#eeeeee;"><%=c%>. <%=routine.getName()%> <span style="font-weight:normal;"><%
			
			if (completed) {
				%><span style="color:#009900;">[routine is completed<%
				if (workoutStoredFromRoutineId>0) {
					%>; <a style="color:#009900;" target="_blank" href="showWorkout.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=workoutStoredFromRoutineId%>">open the workout in a new window</a>]<%
				}
				%></span><%
			}
			else if (pastDue) {
				%><span style="color:#cc0000;">[routine is past-deadline; it was due on <%=workoutDateTimeFormat.format(routine.getDueDate())%>.</span><%
			}
			else if (routine.getDueDate()!=null) {
				%><span style="color:#ff9900;">[routine is due on <%=workoutDateTimeFormat.format(routine.getDueDate())%>.]</span><%
			}
			else if (routine.getDueDate()==null) {
				%><span style="color:#ff9900;">[routine does not have a due date.]</span><%
			}
			%></span></div>
	
			<%
			pageContext.include("showWorkoutInclude.jsp?"+controller.getSiteIdNVPair()+"&prescriptive=true&showDetails=false&showIntroText=false&showTagline=false&containInBox=false&mode=view&isPopup=false&id="+routine.getId());
			c++;
			%>
			<br/>
			<%
		}
	}
	%>
	<script>
	document.getElementById("loading").style.display="none";
	document.getElementById("loadedData").style.display="block";
	</script>
	</div>
	
	</div>
	
	
	
	
	</div>
	
	</font>
	
	</span>
	
	
	</body>
	
	</html>
	<%
} // end if clientId > 0)
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

