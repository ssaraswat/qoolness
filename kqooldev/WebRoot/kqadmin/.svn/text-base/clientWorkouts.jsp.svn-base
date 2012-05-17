<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_USERS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%! 
static DateFormat workoutDateFormat=new SimpleDateFormat("EEEE, MMMM d, yyyy");
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
	
	
	List workouts=Workout.getUserCreated(viewingUser.getId(), false, numRoutinesToShow);//}
	
	workouts=(workouts==null?new ArrayList():workouts);
	
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
	<b style="color:#990000;">[Loading client's stored workouts...]</b>
	<%
	out.flush();
	response.flushBuffer();
	%>
	</div>
	
	<div id="loadedData" style="display:none;">
	
	
	<%
	
	long nowTime;
	Workout routine;
	boolean completed;
	boolean pastDue;
	int c;
	
	
	if (workouts==null) {
		%><i>This client has not stored any workouts.</i><%
	}
	
	else {
		%><i>Here are the last <%=numRoutinesToShow%> workouts stored by this user.</i><br/><br/><%
		Iterator it=workouts.iterator();
		nowTime=new Date().getTime();
		Workout workout;
		Workout sourceRoutine;
		String sourceRoutineNote;
		
		c=1;
		while (it.hasNext()) {
			workout=(Workout)it.next();
			sourceRoutineNote="";
			if (workout.getSourceWorkoutId()>0) {
				sourceRoutine=Workout.getById(workout.getSourceWorkoutId());
				if (sourceRoutine!=null) {
					sourceRoutineNote="[stored from the <a target=\"_blank\" href=\"showWorkout.jsp?"+controller.getSiteIdNVPair()+"&id="+sourceRoutine.getId()+"\">"+sourceRoutine.getName()+"</a> routine]";
				}
			}
			%>
			<div style="font-weight:bold; padding:3px; background-color:#eeeeee;"><%=c%>. <%=workoutDateFormat.format(workout.getPerformedDate())%> <span style="font-weight:normal;"><%=sourceRoutineNote%></span><%
			/*
			if (completed) {
				%><span style="color:#00cc00;">[routine is completed; <a target="_blank" href="showWorkout.jsp?<%=controller.getSiteIdNVPair()%>&id=<%=completedWorkout.getId()%>">open the workout in a new window</a>]</span><%
			}
			*/
		
			%></div>
			<%
			pageContext.include("showWorkoutInclude.jsp?"+controller.getSiteIdNVPair()+"&prescriptive=false&showDetails=false&showIntroText=false&showTagline=false&containInBox=false&mode=view&isPopup=false&id="+workout.getId());
			c++;
			%>
			<br/><br/>
			<%
		}
	}
	
	%><script>
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

