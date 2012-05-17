<%@ page import="java.util.*" %><%@ page import="java.text.*" %><%@ page import="com.theavocadopapers.apps.kqool.control.Controller" %><%!
static boolean finalYearReached(int i, int menuEndYear, boolean ascendingYears) {
	if (ascendingYears) {
		return (i<=menuEndYear);
	}
	return (i>=menuEndYear);
}
%><%
Controller controller=new Controller();
controller.doGlobalControl(pageContext);

NumberFormat fmt=NumberFormat.getInstance();
fmt.setMinimumIntegerDigits(2);
String[] months={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec",};
String yearElName=controller.getParam("yearElName","y");
String monthElName=controller.getParam("monthElName","m");
String dateElName=controller.getParam("dateElName","d");
String yearParamName=controller.getParam("yearParamName","y");
String monthParamName=controller.getParam("monthParamName","m");
String dateParamName=controller.getParam("dateParamName","d");
int currYear=new GregorianCalendar().get(Calendar.YEAR);
int currMonth=new GregorianCalendar().get(Calendar.MONTH);
int currDate=new GregorianCalendar().get(Calendar.DAY_OF_MONTH);
int year=controller.getParamAsInt(yearParamName, currYear);
int month=controller.getParamAsInt(monthParamName, currMonth);
int day=controller.getParamAsInt(dateParamName, currDate);
boolean showCalendarLauncher=controller.getParamAsBoolean("showCalendarLauncher", true);
boolean ascendingYears=controller.getParamAsBoolean("ascendingYears", true);
int startYear=controller.getParamAsInt("startYear", 0);
int endYear=controller.getParamAsInt("endYear", 0);


if (startYear==0) {
	startYear=currYear-1;
}
if (endYear==0) {
	endYear=currYear+1;
}

int menuStartYear;
int menuEndYear;
int incrementer;
if (ascendingYears) {
	menuStartYear=startYear;
	menuEndYear=endYear;
	incrementer=1;
}
else {
	int tempEndYear=endYear;
	menuEndYear=startYear;
	menuStartYear=tempEndYear;
	
	incrementer=-1;
}

%><table border="0" cellspacing="0" cellpadding="0">
<tr valign="middle">

<td><select name="<%=monthElName%>" class="selectText">
<%

for (int i=0; i<12; i++) {
	%><option value="<%=i%>" <%=month==i?"selected":""%>><%=months[i]%></option><%
}
%>
</select><br/></td>
<td>&nbsp;<br/></td>
<td><select name="<%=dateElName%>" class="selectText">
<%

for (int i=1; i<=31; i++) {
	%><option value="<%=i%>" <%=day==i?"selected":""%>><%=i%></option><%
}
%>
</select></td>
<td>&nbsp;<br/></td>
<td><select name="<%=yearElName%>" class="selectText">
<%


for (int i=menuStartYear; finalYearReached(i, menuEndYear, ascendingYears); i+=incrementer) {
	%><option value="<%=i%>" <%=year==i?"selected":""%>><%=i%></option><%
}
%>
</select></td>
<td>&nbsp;<br/></td>
<td><%
if (showCalendarLauncher) {
	%><a hidefocus="true" href="#" onclick="launchCalendar(document.forms[0],'<%=yearElName%>','<%=monthElName%>','<%=dateElName%>'); return false;"><img align="absmiddle" src="../images/calendarIcon.gif" width="19" height="17" border="0" /></a><%
}
%><br/></td>
</tr>
</table>