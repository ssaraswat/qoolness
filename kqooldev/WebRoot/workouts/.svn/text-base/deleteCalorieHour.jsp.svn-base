<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%

User user=controller.getSessionInfo().getUser();

int id=controller.getParamAsInt("id",0);
CalorieHour calorieHour=CalorieHour.getById(id);

double calories=calorieHour.getTotalIngestedCalories();
CalorieHour.deleteById(id);

CalorieWeek calorieWeek=CalorieWeek.getById(calorieHour.getWeekId());
calorieWeek.adjustIngestedValuesBasedOnCalorieHour(calorieHour, false);
calorieWeek.store();



%><% PageUtils.jspEnd(request); %>
<%@ include file="/global/bottomInclude.jsp" %>