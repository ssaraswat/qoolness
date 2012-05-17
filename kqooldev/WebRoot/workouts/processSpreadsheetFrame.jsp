<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setRequiredRequestMethod("POST",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

%>

<%


User user=controller.getSessionInfo().getUser();

int viewUserId;
try {
	viewUserId=Integer.parseInt(request.getParameter("viewUserId"));
}
catch (RuntimeException e) {
	viewUserId=0;
}

String successParam;

int dayIndex=Integer.parseInt(request.getParameter("dayIndex"));
int weekId=Integer.parseInt(request.getParameter("weekId"));
int dayId=Integer.parseInt(request.getParameter("dayId"));
int dateYear=Integer.parseInt(request.getParameter("dateYear"));
int dateMonth=Integer.parseInt(request.getParameter("dateMonth"));
int dateDate=Integer.parseInt(request.getParameter("dateDate"));
String changedIds=request.getParameter("changedIds");

try
{
	CalorieWeek week=CalorieWeek.getById(weekId);
	
	CalorieDay day=CalorieDay.getById(dayId);
	day.setWeight(request.getParameter("weight").trim().length()==0?0:Float.parseFloat(request.getParameter("weight")));
	day.setWaist(request.getParameter("waist").trim().length()==0?0:Float.parseFloat(request.getParameter("waist")));
	day.setChest(request.getParameter("chest").trim().length()==0?0:Float.parseFloat(request.getParameter("chest")));
	day.setThigh(request.getParameter("thigh").trim().length()==0?0:Float.parseFloat(request.getParameter("thigh")));
	day.setHip(request.getParameter("hip").trim().length()==0?0:Float.parseFloat(request.getParameter("hip")));
	day.store();
	
	List calorieHours=CalorieHour.getByWeekAndDayIndex(week, dayIndex);
	calorieHours=(calorieHours==null?new ArrayList(0):calorieHours);
	Map hourIntsToCalorieHours=CalorieHour.getHourIntsToCalorieHours(calorieHours, true, week, dayIndex);
	
	StringTokenizer tzr=new StringTokenizer(changedIds, "_");
	int id;
	String idStr;
	CalorieHour hour;
	boolean isNew;
	int calsIn;
	int calsOut;
	int calsInIncrease;
	int calsOutIncrease;
	
	
	while (tzr.hasMoreTokens()) {
		idStr=tzr.nextToken();
		isNew=(idStr.indexOf("new")>-1);

		if (!isNew) {
			id=Integer.parseInt(idStr);
			hour=(CalorieHour)hourIntsToCalorieHours.get(new Integer(Integer.parseInt(request.getParameter("hour"+idStr))));
		}
		else {
			hour=new CalorieHour();
			hour.setDateYear(dateYear);
			hour.setDateMonth(dateMonth);
			hour.setDateDate(dateDate);
			hour.setWeekId(weekId);
		}


		hour.setIntakeComments(request.getParameter("commentsIn"+idStr).replaceAll("\"","'"));
		hour.setExpendedComments(request.getParameter("commentsOut"+idStr).replaceAll("\"","'"));
		if (request.getParameter("calsIn"+idStr)!=null && request.getParameter("calsIn"+idStr).trim().length()>0) {
			calsIn=Integer.parseInt(request.getParameter("calsIn"+idStr));
		}
		else {
			calsIn=0;
		}
		if (request.getParameter("calsOut"+idStr)!=null && request.getParameter("calsOut"+idStr).trim().length()>0) {
			calsOut=Integer.parseInt(request.getParameter("calsOut"+idStr));
		}
		else {
			calsOut=0;
		}
		calsInIncrease=calsIn-hour.getIntakeCalories();
		calsOutIncrease=calsOut-hour.getExpendedCalories();
		week.setTotalCalIntake(week.getTotalCalIntake()+(calsInIncrease));
		week.setTotalCalExpended(week.getTotalCalExpended()+(calsOutIncrease));
		hour.setIntakeCalories(calsIn);
		hour.setExpendedCalories(calsOut);
		
		hour.setHour(Integer.parseInt(request.getParameter("hour"+idStr)));
		if (!isNew) {
			hour.store();
		}
		else {
			hour.store();
		}
	}
	week.store();
	successParam="true";
}
catch (Exception e)
{
	successParam="false";
}



controller.redirect("spreadsheetFrame.jsp?"+controller.getSiteIdNVPair()+"&viewUserId="+viewUserId+"&dayIndex="+dayIndex+"&weekId="+weekId+"&saved=true&success="+successParam);

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

