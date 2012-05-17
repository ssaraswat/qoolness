<% PageUtils.jspStart(request); %>
<% PageUtils.forceNoCache(response); %>

<% PageUtils.setRequiredLoginStatus("user",request); %>
<% PageUtils.setPathToAppRoot("../",request); %>
<% PageUtils.setSection(AppConstants.SECTION_WORKOUTS,request); %>

<%@ include file="/global/topInclude.jsp" %>

<%!

static final String[] DAY_LABELS={"Sun","Mon","Tues","Wed","Thu","Fri","Sat"};

static final DateFormat monthDateFormat=new SimpleDateFormat("MM/dd");
static final NumberFormat standardFmt=NumberFormat.getInstance();
static final NumberFormat doubleFormat=new DecimalFormat("#,##0.00");
static final NumberFormat doubleFormatNoFractions=new DecimalFormat("#,##0");
static final NumberFormat doubleFormatOptionalFractions=new DecimalFormat("#,##0.##");


static {
	standardFmt.setMinimumFractionDigits(0);
	standardFmt.setMaximumFractionDigits(2);
}

%>

<%



User user=controller.getSessionInfo().getUser();

boolean advancedViewMode=controller.getParamAsBoolean("advancedViewMode", false);
boolean allowViewModeChange=controller.getParamAsBoolean("allowViewModeChange", true);




int viewUserId;
User viewUser;
try {
	viewUserId=Integer.parseInt(request.getParameter("viewUserId"));
	if (viewUserId>0) {
		viewUser=User.getById(viewUserId);
	}
	else {
		viewUser=user;
	}
}
catch (RuntimeException e) {
	viewUserId=0;
	viewUser=user;
}



int dayIndex=Integer.parseInt(request.getParameter("dayIndex"));
int weekId=Integer.parseInt(request.getParameter("weekId"));
CalorieWeek week=CalorieWeek.getById(weekId);

double weekTotalIn=week.getTotalCalIntake();
double weekTotalOut=week.getTotalCalExpended();
int numWeekDaysThruToday=dayIndex;

Calendar cal=new GregorianCalendar(week.getStartDateYear(), week.getStartDateMonth(), week.getStartDateDate());
cal.add(Calendar.DATE, dayIndex);

List ingestedCalorieHours=CalorieHour.getByWeekAndDayIndex(week, dayIndex, true);
ingestedCalorieHours=(ingestedCalorieHours==null?new ArrayList(0):ingestedCalorieHours);
List expendedCalorieHours=CalorieHour.getByWeekAndDayIndex(week, dayIndex, false);
expendedCalorieHours=(expendedCalorieHours==null?new ArrayList(0):expendedCalorieHours);


%>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<HTML>
<HEAD>
<TITLE></TITLE>

<script type="text/javascript">

document.domain="<%=new com.theavocadopapers.apps.kqool.GenericProperties().getJavascriptDocumentDomain()%>"

var advancedViewMode=<%=advancedViewMode%>;
parent.advancedViewMode=advancedViewMode;

var allowViewModeChange=<%=allowViewModeChange%>;

function changeDay(dayIndex) {
	location.replace("spreadsheetFrame.jsp"
		+"?allowViewModeChange="+allowViewModeChange+"&advancedViewMode="+advancedViewMode+"&siteId=<%=controller.getSiteId()%>&viewUserId=<%=viewUserId%>&weekId=<%=weekId%>&dayIndex="+dayIndex)
	;
}






function init() {}



</script>

<%@ include file="/global/calCounterJs.jsp" %>

<style type="text/css">
body, td {font-size:11px; font-family:arial,helvetica; color:#333333;}
.cellClass {text-align:right; font-size:11px; font-family:arial,helvetica;padding:0px 3px 0px 3px;border-left:1px solid #999999; border-bottom:1px solid #999999;}
.textInput {overflow:hidden; height:13px; margin:0px; padding:0px; font-size:10px; font-family:arial,helvetica; border:0px solid #999999; background-color:#ffffff;}
</style>

</HEAD>



<BODY onload="init()" BGCOLOR="#FFFFFF" TEXT="#000000" LINK="#99cc00" VLINK="#99cc00" ALINK="#99cc00">

<div style="position:absolute; top:0px; left:0px; z-index:10">
<table border="0" cellspacing="0" cellpadding="0" width="100%">

<tr>
<td><%
int numDataRows=Math.max(expendedCalorieHours.size(), ingestedCalorieHours.size())+1;
String monthDate;
Calendar monthDateCal=new GregorianCalendar(week.getStartDateYear(), week.getStartDateMonth(), week.getStartDateDate());
System.out.println(monthDateCal.getTime());
for (int i=0; i<DAY_LABELS.length; i++) {
	monthDate=monthDateFormat.format(monthDateCal.getTime());
	if (i>0) {
		%>&nbsp;&nbsp;<%
	}
	if (i!=dayIndex) {
		%><a href="#" style="text-decoration:underline;" onclick="changeDay(<%=i%>); return false;"><%=DAY_LABELS[i]%> <%=monthDate%></a><%
	}
	else {
		%><%=DAY_LABELS[i]%> <%=monthDate%><%
	}
	monthDateCal.add(Calendar.DATE, 1);
}

int extraColsForAdvancedView=9;	

if (allowViewModeChange) {
	String switchUrl="spreadsheetFrame.jsp?advancedViewMode="+(!advancedViewMode)+"&"+controller.getSiteIdNVPair()+"&viewUserId="+viewUserId+"&weekId="+weekId+"&dayIndex="+dayIndex;
	String switchLabel=(advancedViewMode?"Switch to basic view":"Switch to advanced view");
	
	%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a class="bodyFont" href="<%=switchUrl%>" onclick="window.parent.advancedViewMode=<%=(!advancedViewMode)%>; return true" style="xfont-weight:bold; xtext-decoration:none; color:#ff9900;"><%=switchLabel%></a><%
}


%></td>

</tr>
</table>

<table  style="width:100%; margin-top:1px;margin-bottom:0px;border-right:1px solid #999999; border-top:1px solid #999999;" cellspacing="0" cellpadding="0">

<tr align="center">
<td class="cellClass" style="font-size:11px; text-align:center;" colspan="2"><b>Exercise</b></td></td>
<td class="cellClass" rowspan="<%=(numDataRows+4)%>" bgcolor="#eeeeee">&nbsp;</td>
<td class="cellClass" style="font-size:11px; text-align:center;" colspan="<%=(3+(advancedViewMode?extraColsForAdvancedView:0))%>"><b>Food</b></td>

</tr>
<tr>

<td class="cellClass" style="text-align:center;" width="250"><i>Description</i></td>
<td class="cellClass" style="text-align:center;"><i><%=advancedViewMode?"Cals":"Calories"%></i></td>
<td class="cellClass" style="text-align:center;" width="250"><i>Description</i></td>
<td class="cellClass" style="text-align:center;"><i><%=advancedViewMode?"Cals":"Calories"%></i></td>
<%
if (advancedViewMode) {
	
	%>
	<td class="cellClass" style="text-align:center;"><i>Fat</i></td>
	<td class="cellClass" style="text-align:center;"><i>Carb</i></td>
	<td class="cellClass" style="text-align:center;"><i>Protein</i></td>
	<td class="cellClass" style="text-align:center;"><i>Fiber</i></td>
	<td class="cellClass" style="text-align:center;"><i>Sugar</i></td>
	<td class="cellClass" style="text-align:center;"><i>Sodium</i></td>
	<td class="cellClass" style="text-align:center;"><i>Calcium</i></td>
	<td class="cellClass" style="text-align:center;"><i>Sat.&nbsp;Fat</i></td>
	<td class="cellClass" style="text-align:center;"><i>Cholesterol</i></td>	
	<%
}
%>


</tr>
<%


String calsIn;
String calsOut;
String commentsIn;
String commentsOut;
String fat;
String carb;
String protein;
String fiber;
String sugar;
String sodium;
String calcium;
String satfat;
String cholesterol;
String numServings;
String servingName;

CalorieHour ingestedCalorieHour;
CalorieHour expendedCalorieHour;
double totalIngestedCaloriesForDay=0.0;
double totalExpendedCaloriesForDay=0.0;
double totalFatForDay=0.0;
double totalCarbForDay=0.0;
double totalProteinForDay=0.0;
double totalFiberForDay=0.0;
double totalSugarForDay=0.0;
double totalSodiumForDay=0.0;
double totalCalciumForDay=0.0;
double totalSatfatForDay=0.0;
double totalCholesterolForDay=0.0;

int i=0;
while (true) {
	if (i>=expendedCalorieHours.size() && i>=ingestedCalorieHours.size()) {
		break;
	}
	if (i<ingestedCalorieHours.size()) {
		ingestedCalorieHour=(CalorieHour)ingestedCalorieHours.get(i);
		calsIn=(ingestedCalorieHour.getTotalIngestedCalories()>=0?""+doubleFormatNoFractions.format(ingestedCalorieHour.getTotalIngestedCalories()):"?");
		commentsIn=(ingestedCalorieHour.getIngestedLabel()!=null?ingestedCalorieHour.getIngestedLabel()+": "+doubleFormatOptionalFractions.format(ingestedCalorieHour.getNumServings())+" "+ingestedCalorieHour.getServingName():"[unknown food]");
		fat=(ingestedCalorieHour.getTotalIngestedFat()>=0?doubleFormat.format(ingestedCalorieHour.getTotalIngestedFat()):"?");
		carb=(ingestedCalorieHour.getTotalIngestedCarb()>=0?doubleFormat.format(ingestedCalorieHour.getTotalIngestedCarb()):"?");
		protein=(ingestedCalorieHour.getTotalIngestedProtein()>=0?doubleFormat.format(ingestedCalorieHour.getTotalIngestedProtein()):"?");
		fiber=(ingestedCalorieHour.getTotalIngestedFiber()>=0?doubleFormat.format(ingestedCalorieHour.getTotalIngestedFiber()):"?");
		sugar=(ingestedCalorieHour.getTotalIngestedSugar()>=0?doubleFormat.format(ingestedCalorieHour.getTotalIngestedSugar()):"?");
		sodium=(ingestedCalorieHour.getTotalIngestedSodium()>=0?doubleFormat.format(ingestedCalorieHour.getTotalIngestedSodium()):"?");
		calcium=(ingestedCalorieHour.getTotalIngestedCalcium()>=0?doubleFormat.format(ingestedCalorieHour.getTotalIngestedCalcium()):"?");
		satfat=(ingestedCalorieHour.getTotalIngestedSatfat()>=0?doubleFormat.format(ingestedCalorieHour.getTotalIngestedSatfat()):"?");
		cholesterol=(ingestedCalorieHour.getTotalIngestedCholesterol()>=0?doubleFormat.format(ingestedCalorieHour.getTotalIngestedCholesterol()):"?");
		totalIngestedCaloriesForDay+=(ingestedCalorieHour.getTotalIngestedCalories()<0?0:ingestedCalorieHour.getTotalIngestedCalories());
		totalFatForDay+=(ingestedCalorieHour.getTotalIngestedFat()<0?0:ingestedCalorieHour.getTotalIngestedFat());
		totalCarbForDay+=(ingestedCalorieHour.getTotalIngestedCarb()<0?0:ingestedCalorieHour.getTotalIngestedCarb());
		totalProteinForDay+=(ingestedCalorieHour.getTotalIngestedProtein()<0?0:ingestedCalorieHour.getTotalIngestedProtein());
		totalFiberForDay+=(ingestedCalorieHour.getTotalIngestedFiber()<0?0:ingestedCalorieHour.getTotalIngestedFiber());
		totalSugarForDay+=(ingestedCalorieHour.getTotalIngestedSugar()<0?0:ingestedCalorieHour.getTotalIngestedSugar());
		totalSodiumForDay+=(ingestedCalorieHour.getTotalIngestedSodium()<0?0:ingestedCalorieHour.getTotalIngestedSodium());
		totalCalciumForDay+=(ingestedCalorieHour.getTotalIngestedCalcium()<0?0:ingestedCalorieHour.getTotalIngestedCalcium());
		totalSatfatForDay+=(ingestedCalorieHour.getTotalIngestedSatfat()<0?0:ingestedCalorieHour.getTotalIngestedSatfat());
		totalCholesterolForDay+=(ingestedCalorieHour.getTotalIngestedCholesterol()<0?0:ingestedCalorieHour.getTotalIngestedCholesterol());
	}
	else {
		calsIn="&nbsp;";
		commentsIn="&nbsp;";
		commentsOut="&nbsp;";
		fat="&nbsp;";
		carb="&nbsp;";
		protein="&nbsp;";
		fiber="&nbsp;";
		sugar="&nbsp;";
		sodium="&nbsp;";
		calcium="&nbsp;";
		satfat="&nbsp;";
		cholesterol="&nbsp;";
	}
	
	
	if (i<expendedCalorieHours.size()) {
		expendedCalorieHour=(CalorieHour)expendedCalorieHours.get(i);
		calsOut=(expendedCalorieHour.getTotalExpendedCalories()>0?""+doubleFormatNoFractions.format(expendedCalorieHour.getTotalExpendedCalories()):"?");
		commentsOut=(expendedCalorieHour.getExpendedLabel()!=null?expendedCalorieHour.getExpendedLabel():"[unknown exercise]");
		totalExpendedCaloriesForDay+=(expendedCalorieHour.getTotalExpendedCalories()<0?0:expendedCalorieHour.getTotalExpendedCalories());
	}
	else {
		calsOut="&nbsp;";
		commentsOut="&nbsp;";
	}
	%>
	<tr>
	<td class="cellClass" style="text-align:left; font-size:11px;"><%=commentsOut%></td>
	<td class="cellClass" style=" font-size:11px;"><%=calsOut%></td>
	<td class="cellClass" style="text-align:left; font-size:11px;"><%=commentsIn%></td>
	<td class="cellClass" style=" font-size:11px;"><%=calsIn%></td>
	<%
	if (advancedViewMode) {
		%>
		<td class="cellClass" style=" font-size:11px;"><%=fat%></td>
		<td class="cellClass" style=" font-size:11px;"><%=carb%></td>
		<td class="cellClass" style=" font-size:11px;"><%=protein%></td>
		<td class="cellClass" style=" font-size:11px;"><%=fiber%></td>
		<td class="cellClass" style=" font-size:11px;"><%=sugar%></td>
		<td class="cellClass" style=" font-size:11px;"><%=sodium%></td>
		<td class="cellClass" style=" font-size:11px;"><%=calcium%></td>
		<td class="cellClass" style=" font-size:11px;"><%=satfat%></td>
		<td class="cellClass" style=" font-size:11px;"><%=cholesterol%></td>		
		<%
	}
	%>


	</tr>

	<%	

	i++;
}
%>
<tr bgcolor="#cccccc">
<td class="cellClass" style="font-size:11px;">&nbsp;<i>Day&nbsp;Total:</i></td>
<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormatNoFractions.format(totalExpendedCaloriesForDay)%></span><br /></td>
<td class="cellClass" style="font-size:11px;">&nbsp;<i>Day&nbsp;Total<%=advancedViewMode?"s":""%>:</i></td>
<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormatNoFractions.format(totalIngestedCaloriesForDay)%></span><br /></td>
<%
if (advancedViewMode) {
	%>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(totalFatForDay)%></span><br /></td>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(totalCarbForDay)%></span><br /></td>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(totalProteinForDay)%></span><br /></td>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(totalFiberForDay)%></span><br /></td>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(totalSugarForDay)%></span><br /></td>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(totalSodiumForDay)%></span><br /></td>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(totalCalciumForDay)%></span><br /></td>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(totalSatfatForDay)%></span><br /></td>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(totalCholesterolForDay)%></span><br /></td>
	<%
}
%>
</tr>
<tr bgcolor="#cccccc">
<td class="cellClass" style="font-size:11px;">&nbsp;<i>Week&nbsp;Total:</i></td>
<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormatNoFractions.format(weekTotalOut)%></span><br /></td>
<td class="cellClass" style="font-size:11px;">&nbsp;<i>Week&nbsp;Total<%=advancedViewMode?"s":""%>:</i></td>
<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormatNoFractions.format(weekTotalIn)%></span><br /></td>
<%
if (advancedViewMode) {
	%>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(week.getTotalFatIntake())%></span><br /></td>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(week.getTotalCarbIntake())%></span><br /></td>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(week.getTotalProteinIntake())%></span><br /></td>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(week.getTotalFiberIntake())%></span><br /></td>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(week.getTotalSugarIntake())%></span><br /></td>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(week.getTotalSodiumIntake())%></span><br /></td>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(week.getTotalCalciumIntake())%></span><br /></td>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(week.getTotalSatfatIntake())%></span><br /></td>
	<td class="cellClass"><span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormat.format(week.getTotalCholesterolIntake())%></span><br /></td>
	<%
}
%>
</tr>


<tr>
<td  class="cellClass" bgcolor="#aaaaaa" colspan="<%=(6+(advancedViewMode?extraColsForAdvancedView:0))%>" style="font-size:11px; text-align:center;">
Calorie deficit/advantage for day: <span style="font-weight:bold; xcolor:#ff6600;" id="dailyTotalInOut"><%=doubleFormatNoFractions.format(totalExpendedCaloriesForDay-totalIngestedCaloriesForDay)%></span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Calorie deficit/advantage for week: <span style="xcolor:#ff6600;font-weight:bold;"><%=doubleFormatNoFractions.format(weekTotalOut-weekTotalIn)%></span>
</td>
</tr>


</form>
</table>
</div>

<%@ include file="/global/trackingCode.jsp" %>



</BODY>
</HTML>






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

