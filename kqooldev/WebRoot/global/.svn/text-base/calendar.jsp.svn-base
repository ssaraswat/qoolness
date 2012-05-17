<%@ page import="com.theavocadopapers.apps.kqool.control.Controller" %>

<%
Controller controller=new Controller();
controller.doGlobalControl(pageContext);
%>






<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
<title>Kqool&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</title>

<% // Re following js include: "Calendar" emulates java.util.Calendar to some extent; it is not a set of scripts specific to this popup calendar module: %>
<SCRIPT src="../global/Calendar.js"></script>

<% // Cross-browser API: %>
<SCRIPT src="../global/X.js"></script>
<SCRIPT src="../global/HashMap.js"></script>


<script type="text/javascript">
top.focus()


var HOUR_MS=1000*60*60








var abbrevMonths=["Jan.","Feb.","Mar.","Apr.","May","Jun.","Jul.","Aug.","Sep.","Oct.","Nov.","Dec."]

var nowInMillis=<%=new java.util.Date().getTime()%>
var nowCalendar=new Calendar(nowInMillis)

var date=<%=request.getParameter("date")%>
var month=<%=request.getParameter("month")%>
var year=<%=request.getParameter("year")%>

var chosenDate=date
var chosenMonth=month
var chosenYear=year

var initialDate=new Date(year,month,date,0,0,0,0)

var initialDateCal=new Calendar(initialDate)
initialDate=null // don't be tempted to use this.



var currentDateCal=initialDateCal.clone()


var currentDatesArray;

top.setModalReturnValue([])

function setDateOnOpener()
{
	var retVal=[]
	retVal[0]=window.chosenYear
	retVal[1]=window.chosenMonth
	retVal[2]=window.chosenDate
	retVal[3]="<%=controller.getParam("formObjName")%>"
	retVal[4]="<%=controller.getParam("yearElName")%>"
	retVal[5]="<%=controller.getParam("monthElName")%>"
	retVal[6]="<%=controller.getParam("dateElName")%>"
	top.setModalReturnValue(retVal)
	top.doModalClose()
}





function createDatesArray(cal)
{
	var datesArray=new Array()
	var firstDayInMonth=cal.getFirstDayInMonth()
	var daysInMonth=cal.getDaysInMonth()
	var currDate=0-firstDayInMonth
	for (var r=0; r<6; r++)
	{
		var rowArray=new Array()
		for (var c=0; c<7; c++)
		{
			currDate++
			if (currDate>=1 && currDate<=daysInMonth)
			{
				rowArray[c]=currDate
			}
			else
			{
				rowArray[c]=0
			}
		}
		datesArray[r]=rowArray
	}
	window.currentDatesArray=datesArray
}

function currentDateCellsHTML()
{
	var s="<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"
	for (var row=0; row<6; row++)
	{
		s+="<tr align=\"center\" valign=\"middle\">"
		for (var col=0; col<7; col++)
		{
			var isToday=isTodaysDate(window.currentDatesArray[row][col],currentDateCal)
			var isChosen=isChosenDate(window.currentDatesArray[row][col],currentDateCal)
		
			s+="<td nowrap=\"nowrap\" width=31 height=17 "
			if (isChosen && isToday)
			{
				s+=" background=\"../images/bg_chosenDateTodaysDate.gif\""
			}
			else if (isChosen)
			{
				s+=" background=\"../images/bg_chosenDate.gif\""
			}
			else if (isToday)
			{
				s+=" background=\"../images/bg_todaysDate.gif\""
						}
			s+=">"
			var showLink=false
			if (parseInt(window.currentDatesArray[row][col])>0) {
				showLink=true
			}
			s+="<a "+(showLink?"":"x")+"href=\"#\" xondblclick=\"selectYearMonthDate("+window.currentDateCal.get(currentDateCal.YEAR)+","+window.currentDateCal.get(currentDateCal.MONTH)+","+window.currentDatesArray[row][col]+"); setDateOnOpener(); return false;\" onclick=\"selectYearMonthDate("+window.currentDateCal.get(currentDateCal.YEAR)+","+window.currentDateCal.get(currentDateCal.MONTH)+","+window.currentDatesArray[row][col]+"); return false\">"
			s+="<span class="+(isChosen?"dateFontChosen":"dateFont")+">"
			s+=(window.currentDatesArray[row][col]>0?""+window.currentDatesArray[row][col]:"&nbsp;")
			s+="</span></a><br /></td>"
		}
		s+="</tr>"
	}
	s+="</table>"
	return s
}

function selectYearMonthDate(year,month,date)
{
	if (parseInt(date)>0) {
		window.chosenYear=year
		window.chosenMonth=month
		window.chosenDate=date
		updateCalendar()
	}
}

function isTodaysDate(date,cal)
{
	if (date==0)
	{
		return false
	}
	if (parseInt(nowCalendar.get(nowCalendar.DATE))!=parseInt(date))
	{
		return false
	}
	if (parseInt(nowCalendar.get(nowCalendar.MONTH))!=parseInt(cal.get(cal.MONTH)))
	{
		return false
	}
	if (parseInt(nowCalendar.get(nowCalendar.YEAR))!=parseInt(cal.get(cal.YEAR)))
	{
		return false
	}
	return  true
}

function isChosenDate(date,cal)
{
	date=parseInt(date)
	if (date!=window.chosenDate)
	{
		return false
	}

	if (parseInt(cal.get(cal.MONTH))!=window.chosenMonth)
	{
		return false
	}
	if (parseInt(cal.get(cal.YEAR))!=window.chosenYear)
	{
		return false
	}
	return  true
}

function currentMonthLabelHTML()
{
	var currMonth=currentDateCal.get(currentDateCal.MONTH)
	return currentDateCal.getName(currentDateCal.MONTH,currMonth,true)+", "+currentDateCal.get(currentDateCal.YEAR)
}

function init()
{
	updateCalendar()
}


function updateCalendar()
{
	createDatesArray(window.currentDateCal)
	X.writeToDiv("dateCells",currentDateCellsHTML())
	X.writeToDiv("monthYearSpan",currentMonthLabelHTML())

}

function changeMonth(rollValue) // rollValue will be 1 or -1
{
	// we leave the date of the month the same, rolling only the month and, if needed, the year:
	var currMonth=window.currentDateCal.get(currentDateCal.MONTH)
	var yearRoll=0;
	if (rollValue==1 && currMonth==11)
	{
		yearRoll=1
	}
	else if (rollValue==-1 && currMonth==0)
	{
		yearRoll=-1
	}
	
	window.currentDateCal.roll(currentDateCal.MONTH,rollValue)
	if (yearRoll!=0)
	{
		window.currentDateCal.roll(currentDateCal.YEAR,yearRoll)
	}
	updateCalendar()
}




</script>

<style type="text/css">

a {text-decoration:none;}


.monthYearFont {font-size:11px; font-family:arial,helvetica; color:#ffffff; xfont-style:italic; }
.weekdayHeaderFont {font-size:12px; font-family:arial,helvetica; color:#4a4a4a; }
.dateFont {font-size:11px; font-family:arial,helvetica; color:#4a4a4a; }
.dateFontChosen {font-size:11px; font-family:arial,helvetica; color:#000000; }
.todaysDateFont {font-size:11px; font-family:arial,helvetica; color:#ffffff; }
.instruxFont {font-size:11px; font-family:arial,helvetica;  color:#6A6A6a;  }
.firstSentenceFont {color:#000000; font-weight:bold; }
.timelineFont {font-size:9px; font-family:arial,helvetica; color:#cccccc;  }
.timelineFontChosen {font-size:9px; font-family:arial,helvetica; color:#000000;  }
.timelineTextFont {font-size:9px; font-family:arial,helvetica; color:#cccccc;  }
.dateTimeTextFont {font-family:arial,helvetica; font-size:11px; color:#000000; }


#baseCalendar {position:absolute; top:58px; left:15px; }
#timeline {z-index:10; position:absolute; top:216px; left:15px; }
#timelineTextRow1 {z-index:10; position:absolute; top:218px; left:23px; }
#timelineTextRow2 {z-index:10; position:absolute; top:227px; left:23px; }
#timelineTextRow3 {z-index:10; position:absolute; top:254px; left:22px; }
#monthYearText {position:absolute; top:59px; left:33px; width:178px;}
#instrux {position:absolute; top:40px; left:15px; width:214px;}
#weekdayHeaders {position:absolute; top:77px; left:16px; width:214px;}
#dateCells {position:absolute; top:94px; left:16px; width:214px;}
#buttons {position:absolute; top:210px; left:15px; width:214px;}
#dateTimeText {position:absolute; top:285px; left:15px; width:218px;}
#timelinePointer {z-index:20; position:absolute; top:239px; left:-100px; width:7px;}
#innerDateText {border:1px solid #000000; background-color:#DBDBdb; padding: 2px; padding-left:4px; width:218px; }


</style>
</head>

<body onload="init()" bgcolor="#FFFFFF" background="../images/dialogBg.gif" link="#cccccc" alink="#cccccc" vlink="#cccccc">

<MAP NAME="baseCalendarMap">
<AREA SHAPE="CIRCLE" COORDS="9,9,7" HREF="" onclick="changeMonth(-1);return false;">
<AREA SHAPE="CIRCLE" COORDS="208,10,7" HREF="" onclick="changeMonth(1);return false;">
</MAP>



<div id="baseCalendar">
<img hidefocus="true" usemap="#baseCalendarMap" src="../images/baseCalendar.gif" height="138" width="218" border="0"><br />
</div>



<div id="monthYearText">
<table border="0" cellspacing="0" cellpadding="0" height="18" width="178">
<tr>
<td align="center" valign="middle"><span id="monthYearSpan" class="monthYearFont"></span></td>
</tr>
</table>
</div>





<div id="weekdayHeaders">
<table border="0" cellspacing="0" cellpadding="0" height="17">
<tr align="center" valign="middle">
<%
char[] headers={'S','M','T','W','T','F','S',};
for (int i=0; i<headers.length; i++)
{
	%>
	<td nowrap="nowrap" width="31"><font class="weekdayHeaderFont"><%=headers[i]%><br /></font></td>
	<%
}
%>
</tr>
</table>

</div>

<div id="dateCells">
</div>

<div id="instrux">
<font class="instruxFont">
<span class="firstSentenceFont">Please choose a date</span> 





and press "ok":<br />
</font>
</div>

<form action="#" onsubmit="return false;">
<div id="buttons">
<table border="0" cellspacing="0" cellpadding="0" width="214">
<tr>
<td align="left">
<img src="../images/spacer.gif" height="2" width="23"  /><a href="#" onclick="setDateOnOpener(); return false"><img src="../images/smallButtons/ok.gif" height="19" width="81" border="0" hidefocus="true" /></a>&nbsp;
<a href="#" onclick="top.setModalReturnValue([]); top.doModalClose(); return false"><img src="../images/smallButtons/cancel.gif" height="19" width="81" border="0" hidefocus="true" /></a>&nbsp;<br />
</td>
</tr>
</table>
</div>
</form>


</body>
</html>
