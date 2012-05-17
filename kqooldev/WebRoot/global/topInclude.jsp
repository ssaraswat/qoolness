<%



/********** PLEASE NOTE *********
This file is statically (that is, compile-time) included by one or more JSPs.
********************************/



%><%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>





<%@ page import="com.theavocadopapers.apps.kqool.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.entity.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.entity.staticdata.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.entity.comparator.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.control.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.exception.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.session.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.util.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.client.*" %>
<%@ page import="com.theavocadopapers.apps.kqool.jsphelpers.*" %>
<% /*
Copyright (c) Steve Schneider 2004-2005.
All rights reserved.
*/ %>


<%!




static final String[] SPEED_LABELS=ExerciseDetail.SPEED_LABELS;
  



String[] MONTHS_ABBREV={"Jan.","Feb.","Mar.","Apr.","May","Jun.","Jul.","Aug.","Sep.","Oct.","Nov.","Dec.",};
String[] MONTHS_VERBOSE={"January","February","March","April","May","June","July","August","September","October","November","December",};
int[] MONTH_LENGTHS={31,28,31,30,31,30,31,31,30,31,30,31};

int[] LEAP_YEARS={2000, 2004, 2008, 2012, 2016, 2020, 2024, 2028, 2032, 2036, 2040, 2044, 2048, 2052};

String[] WEEKDAYS_ABBREV={"Sun.","Mon.","Tue.","Wed.","Thu.","Fri.","Sat.",};
String[] WEEKDAYS_VERBOSE={"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday",};

static final int LAYOUT_GENERIC=1;
static final int LAYOUT_WORKOUTS_HOME=2;
static final int LAYOUT_WORKOUTS_INTERIOR=3;
static final int LAYOUT_VIDEOS_HOME=4;
static final int LAYOUT_VIDEOS_INTERIOR=5;
static final int LAYOUT_LOGIN=6;

static String getUserStatusText(String username, String pathToAppRoot, Controller controller)
{
	boolean isBackendUser=controller.getSessionInfo().getUser().isBackendUser();
	if (!isBackendUser) {
		StringBuffer b=new StringBuffer();
		b.append("<img src="+pathToAppRoot+"images/usernameletters/youAreLoggedInAs.gif width=14 height=127 /><br/>");
		b.append("<img src="+pathToAppRoot+"images/spacer.gif width=1 height=5 /><br/>");
		for (int i=0; i<username.length(); i++) {
			String imgSrc;
			char c=username.charAt(i);
			if ((""+c).toUpperCase().equals((""+c).toLowerCase())) {
				// not a letter, so:
				if (c=='_') {
					imgSrc="underscore";
				}
				else if (c=='.') {
					imgSrc="dot";
				}
				else if (c=='-') {
					imgSrc="dash";
				}
				else {
					imgSrc=""+c;
				}
			}
			else {
				// it's a letter: lc or uc? --
				if ((""+c).toUpperCase().equals(""+c)) {
					imgSrc=("uc/"+c).toLowerCase();
				}
				else {
					imgSrc="lc/"+c;
				}
			}
			b.append("<img src="+pathToAppRoot+"images/usernameletters/"+imgSrc+".gif width=14 /><br/>");
		}
		b.append("<img src="+pathToAppRoot+"images/usernameletters/dot.gif width=14 /><br/>");
		b.append("<img src="+pathToAppRoot+"images/spacer.gif width=14 height=27 /><br/>");
		b.append("<a href=\""+pathToAppRoot+"login/logout.jsp?"+controller.getSiteIdNVPair()+"\"><img src="+pathToAppRoot+"images/usernameletters/logOut.gif width=14 height=49 border=0 /></a><br/>");
		return b.toString();
	}
	return "";
}
	
%><%
com.theavocadopapers.core.logging.Logger logger = com.theavocadopapers.core.logging.Logger.getLogger(((Servlet)pageContext.getPage()).getClass());




PageUtils.forceNoCache(response);

GenericProperties genericProps=new GenericProperties();
String p3pHeaderValue="policyref=\""+genericProps.getP3pPolicyRefFqUrl()+"\", CP=\"NOI DSP CURa ADMa DEVa TAIa OUR BUS IND UNI COM NAV INT\"";
response.setHeader("P3P", p3pHeaderValue);
logger.info("P3P response header set to "+p3pHeaderValue+"");

ServletContextWrapper.init(application);

long startTimeMillis=new Date().getTime();

Throwable pageException=null;

Controller controller=null;
logger.info("JSP "+((Servlet)pageContext.getPage()).getClass()+": entering global try clause");

try
{
	// Rest of the JSP is try/catched; if an exception is thrown, bottomInclude.jsp gives pageException a reference to it and some JavaScript that launches an error dialog containing the stack trace and other info is included:

	// for a reason that I don't understand, under Tomcat (and I've seen this also with WebLogic), when
	// pages are POSTed, sometimes the request happens twice, first as a POST and then as a GET.  Therefore,
	// a JSP can specify itself (via PageUtils.setRequiredRequestMethod()) as a "POST page" only, in which
	// case if the page gets the secondary GET request, it can ignore it:
	String requiredRequestMethod=PageUtils.nonNull(PageUtils.getRequiredRequestMethod(request)).trim().toUpperCase();
	String requestMethod=PageUtils.nonNull(request.getMethod()).trim().toUpperCase();

	boolean invalidRequestMethod=false;
	if (requiredRequestMethod.length()>0 && !(requiredRequestMethod.equals(requestMethod)))
	{
		invalidRequestMethod=true;

	}


	if (!invalidRequestMethod && !PageUtils.isCompileOnly(request))
	{	
		controller=new Controller();
		
		boolean forceLogout=(request.getParameter(Controller.FORCE_LOGOUT_PARAM)!=null && request.getParameter(Controller.FORCE_LOGOUT_PARAM).equals("true"));
		if (forceLogout) {
			try {
				session.removeAttribute(Controller.SITE_ATTR);
				session.removeAttribute(Controller.SITE_ID_ATTR);
				session.removeAttribute(Controller.SESSION_INFO_ATTR);
			}
			catch (Exception e) {} 
		}
		boolean executePage=controller.doGlobalControl(pageContext);
		
		//  make available to all runtime-included pages:
		request.setAttribute("controller", controller);
		
		SiteProperties siteProps=new SiteProperties(controller.getSiteIdInt());
		
		
		// determine which layout to use (irrelevant if we're on the homepage):
		int layoutType=LAYOUT_GENERIC;
		String subsctn=controller.getSubsection();
		if (subsctn==null) {
			subsctn=AppConstants.SUB_SECTION_OTHER;
		}
		if (controller.getSection().equals(AppConstants.SECTION_WORKOUTS)) {
			if (subsctn.equals(AppConstants.SUB_SECTION_SECTION_HOME)) {
				layoutType=LAYOUT_WORKOUTS_HOME;
			}
			else {
				layoutType=LAYOUT_WORKOUTS_INTERIOR;
			}
		}
		else if (controller.getSection().equals(AppConstants.SECTION_LOGIN)) {
			layoutType=LAYOUT_LOGIN;
		}
		else if (controller.getSection().equals(AppConstants.SECTION_VIDEOS)) {
			if (controller.getParam("category","NONE").equals("NONE")) {
				layoutType=LAYOUT_VIDEOS_HOME;
			}
			else {
				layoutType=LAYOUT_VIDEOS_INTERIOR;
			}
		}
		request.setAttribute("layoutType", new Integer(layoutType));
		

		// doGlobalControl() returns false if it redirects to another page; we only 
		// execute this page if it returns true (this mostly is here to prevent nullpointers
		// and similar exceptions that occur after the redirect):
		if (executePage)
		{

		String userStatusText;
		User currentUser=controller.getSessionInfo().getUser();
		String loginStatus=PageUtils.nonNull(controller.getSessionInfo().getLoginStatus()).trim().toLowerCase();
		boolean logoutPage=false;
		if (request.getAttribute("logoutPage")!=null) {
			if (((Boolean)request.getAttribute("logoutPage")).booleanValue()) {
				logoutPage=true;
			}
		}
		if (!logoutPage && (loginStatus.equals("user") || loginStatus.equals("backenduser")) && currentUser!=null)
		{
			userStatusText=getUserStatusText(currentUser.getUsername(), PageUtils.getPathToAppRoot(request), controller); //"logged in as <font color=#323213>"+currentUser.getUsername()+"</font>";
		}
		else 
		{
			userStatusText="";
		}
		

		%>