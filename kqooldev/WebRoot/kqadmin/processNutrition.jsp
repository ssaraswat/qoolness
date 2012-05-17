<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>


<% PageUtils.setRequiredLoginStatus("backenduser",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setRequiredRequestMethod("POST",request); %>
<% PageUtils.setSection(AppConstants.SECTION_ADMIN,request); %>
<% PageUtils.setSubsection(AppConstants.SUB_SECTION_USERS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%

int id=controller.getParamAsInt("id");
int userid=controller.getParamAsInt("userid");
String retUrl=controller.getParam("retUrl");

String sec = controller.getParam("brk");

String secc = controller.getParam("lunch");

String brkRec = controller.getParam("txt1");
String lunRec = controller.getParam("txt2");
String snRec = controller.getParam("txt3");
String dinRec = controller.getParam("txt4");
String desRec = controller.getParam("txt5");


String sdate = controller.getParam("selected_date");
int selectedDayOfWeek = controller.getParamAsInt("selected_day");

Date selectedDate = java.sql.Date.valueOf(sdate);

ClientToMeal cmForBrk;
ClientToMeal cm2;
//NutritionPlan np = NutritionPlan.getByUserId(userid);
//if (np == null) {
//   np = new NutritionPlan();
//   np.setUserId(userid);
//}


 
//ClientToMeal cmForBrk = ClientToMeal.getByUserId(userid,selectedDate);

//ClientToMeal cm2 = new ClientToMeal();
//cm2.setClientId(userid);


//np.setSundayRec(sunRec);
//np.setMondayRec(monRec);
//np.setTuesdayRec(tuesRec);
//np.setWednesdayRec(wedRec);
//np.setThursdayRec(thursRec);
//np.setFridayRec(friRec);
//np.setSaturdayRec(satRec);
//np.setInstructions(instr);
//np.store();


if(brkRec!=null){
	cmForBrk = ClientToMeal.getByUserId(userid,selectedDate);
	cm2 = new ClientToMeal();
	cm2.setClientId(userid);
	Breakfast bk = new Breakfast();
	bk.setAdminUserId(userid);
	bk.setData(brkRec);
	bk.saveBreakfast();
	cm2.setMealId(bk.getBreakfastId());
	cm2.setMealType("Breakfast");
	cm2.setDate(selectedDate);
	int orderNumber=0;
	if(cmForBrk!=null){
		orderNumber=cmForBrk.getMealOrder();
	}
	
	if(orderNumber==0){
		cm2.setMealOrder(1);
	}else{
		orderNumber = orderNumber+1;
			cm2.setMealOrder(orderNumber);
	}
	cm2.store();

}

	

if(lunRec!=null){
	cmForBrk = ClientToMeal.getByUserId(userid,selectedDate);
	cm2 = new ClientToMeal();
	cm2.setClientId(userid);
	Lunch lc = new Lunch();
	lc.setAdminUserId(userid);
	lc.setData(lunRec);
	lc.saveLunch();
	cm2.setMealId(lc.getLunchId());
	cm2.setMealType("Lunch");
	cm2.setDate(selectedDate);
	int orderNumber=0;
	if(cmForBrk!=null){
		orderNumber=cmForBrk.getMealOrder();
	}
	
	if(orderNumber==0){
		cm2.setMealOrder(1);
	}else{
		orderNumber = orderNumber+1;
		cm2.setMealOrder(orderNumber);
	}
	cm2.store();
}

	





%>
<script type="text/javascript">
alert("Your changes have been saved.")
location.replace("<%=retUrl%>");
</script>


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

