<% 



//NOTE: NO INADVERTENT WHITESPACE ON THIS PAGE PLEASE.


//Copyright (c) Steve Schneider 2002-2005..
//All rights reserved.

PageUtils.jspStart(request); 
PageUtils.forceNoCache(response); 

PageUtils.setRequiredLoginStatus("user",request); 
PageUtils.setPathToAppRoot("../",request); 
PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request);
%><%@ include file="/global/topInclude.jsp" %><%

User user=controller.getSessionInfo().getUser();

double numServings=controller.getParamAsDouble("numServings");
int dateYear=controller.getParamAsInt("dateYear");
int dateMonth=controller.getParamAsInt("dateMonth");
int dateDate=controller.getParamAsInt("dateDate");
int weekId=controller.getParamAsInt("weekId");
String rawData=controller.getParam("escapedRawData");
String chosenFood=URLDecoder.decode(rawData.substring(rawData.indexOf("\"chosenFood\":\"")+"\"chosenFood\":\"".length(), rawData.indexOf("\",\"name\"")), "UTF-8");
rawData=rawData.replaceAll("\\%22", "__QUOT__");
rawData=URLDecoder.decode(rawData.replaceAll("\\+", "%20"));
rawData=rawData.replaceAll("\\+", " ").replaceAll("\\_\\_QUOT\\_\\_", "&quot;");

rawData=rawData.substring(1, rawData.length()-1);
String foodName=controller.getParam("foodName");

// WHY did I decide to pass JSON back to the server?  Fucking pain in the ass: the "name" attr
// can have a comma in it, but we split on commas.  THIS IS A FUCKING CLUSTERFUCK.  So:
//String rawDataPart1=rawData.substring(0, rawData.indexOf("\"name\":"));
//String rawDataPart2=rawData.substring(rawDataPart1.length(), rawData.length());

String rawDataPart1=rawData.substring(0, rawData.indexOf("\"chosenFood\":"));
String rawDataPart2=rawData.substring(rawDataPart1.length(), rawData.indexOf(",\"name\":"));
String rawDataPart3=rawData.substring(rawDataPart1.length()+rawDataPart2.length()+1, rawData.length());


rawDataPart2=rawDataPart2.replaceAll("\\,", "__COMMA__");
rawDataPart3=rawDataPart3.replaceAll("\\,", "__COMMA__");
rawData=rawDataPart1+rawDataPart2+","+rawDataPart3;

String[] rawDataSplit=rawData.split(",");
String[] rawDataNVPair;
String key;
String value;
CalorieHour calorieHour=new CalorieHour();
calorieHour.setWeekId(weekId);
calorieHour.setDateDate(dateDate);
calorieHour.setDateMonth(dateMonth);
calorieHour.setDateYear(dateYear);
calorieHour.setExpendedLabel("");
calorieHour.setHour(0); // we don't care about hours anymore.

for (int i=0; i<rawDataSplit.length; i++) {
	rawDataNVPair=rawDataSplit[i].split(":");
	key=rawDataNVPair[0].substring(1, rawDataNVPair[0].length()-1);
	value=rawDataNVPair[1].substring(1, rawDataNVPair[1].length()-1);
	if (key.equals("name")) {
		value=value.replaceAll("__COMMA__",",");
		calorieHour.setServingName(URLDecoder.decode(value.replaceAll("\\+"," "), "UTF-8"));
	}
	else if (key.equals("cholesterol")) {
		calorieHour.setTotalIngestedCholesterol(Double.parseDouble(value)*numServings);
	}
	else if (key.equals("satfat")) {
		calorieHour.setTotalIngestedSatfat(Double.parseDouble(value)*numServings);
	}
	else if (key.equals("calcium")) {
		calorieHour.setTotalIngestedCalcium(Double.parseDouble(value)*numServings);
	}
	else if (key.equals("sodium")) {
		calorieHour.setTotalIngestedSodium(Double.parseDouble(value)*numServings);
	}
	else if (key.equals("protein")) {
		calorieHour.setTotalIngestedProtein(Double.parseDouble(value)*numServings);
	}
	else if (key.equals("fiber")) {
		calorieHour.setTotalIngestedFiber(Double.parseDouble(value)*numServings);
	}
	else if (key.equals("carb")) {
		calorieHour.setTotalIngestedCarb(Double.parseDouble(value)*numServings);
	}
	else if (key.equals("sugar")) {
		calorieHour.setTotalIngestedSugar(Double.parseDouble(value)*numServings);
	}
	else if (key.equals("calories")) {
		calorieHour.setTotalIngestedCalories(Double.parseDouble(value)*numServings);
	}
	else if (key.equals("fat")) {
		calorieHour.setTotalIngestedFat(Double.parseDouble(value)*numServings);
	}

}
calorieHour.setNumServings(numServings);
calorieHour.setIngestedLabel(chosenFood);

int calorieHourId=calorieHour.store();

CalorieWeek calorieWeek=CalorieWeek.getById(weekId);
calorieWeek.adjustIngestedValuesBasedOnCalorieHour(calorieHour, true);
calorieWeek.store();




%>{
	"numServings":"<%=numServings%>","chosenFood":"<%=chosenFood.replaceAll("\"","&quot;")%>","rawData":{<%=URLDecoder.decode(rawData.replaceAll("__COMMA__",","), "UTF-8").replaceAll("\\+"," ")%>}
}<%
request.setAttribute("suppressRenderedTimeComment","true");
%><%@ include file="/global/bottomInclude.jsp" %><%
if (pageException!=null)
{
	%>
	<%@ include file="/global/jspErrorDialogLaunch.jsp" %>
	<%
}
%><% PageUtils.jspEnd(request); %>

