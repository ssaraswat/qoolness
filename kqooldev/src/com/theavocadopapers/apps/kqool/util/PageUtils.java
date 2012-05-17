/*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/

package com.theavocadopapers.apps.kqool.util;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.theavocadopapers.apps.kqool.control.Controller;
import com.theavocadopapers.apps.kqool.entity.User;
import com.theavocadopapers.apps.kqool.session.SessionInfo;
import com.theavocadopapers.core.logging.Logger;

public class PageUtils
implements com.theavocadopapers.apps.kqool.Constants
{
	
	private static final Logger logger = Logger.getLogger(PageUtils.class);

	static final int DISGUISE_FACTOR=9;
	static final int DISGUISE_INCREMENT=29304;
	static final String[] DISGUISE_KEY=
	{
		"dpK3sVom28",
		"qrs7Oi8MNj",
		"9ft0AeuBdZ",
		"WXcMY2ab1N",
		"AB7vDESTt5",
		"s0tnv89ARS",
		"kvEwxslopy",
		"wx3J245KLM",
		"vw5M7LiNh6",
		"op9nrs0AqC",
	};

	public static final String[] JSP_FILENAMES=
	{
		"global/alertConfirm.jsp",
		"global/jspError.jsp",
		"global/kp.jsp",
		"global/modalFrameset.jsp",		
		"help/helpItem.jsp",
		"help/index.jsp",
		"help/list.jsp",
		"help/topFrame.jsp",
		"admin/ic/createInitialInstances.jsp",
		"admin/ic/createInitialProject.jsp",
		"admin/ic/createBackendUser.jsp",
		"admin/ic/getInitialInstancesConfig.jsp",
		"admin/ic/getInitialProjectConfig.jsp",
		"admin/ic/getBackendUserConfig.jsp",
		"admin/ic/initialConfigFinished.jsp",
		"admin/ic/saveInstallationConfig.jsp",
		"admin/includes/writeAllFullnamesArray.jsp",
		"admin/includes/writeAllInstanceNamesArray.jsp",
		"admin/includes/writeAllProjectNamesArray.jsp",
		"admin/includes/writeAllProjectNamesArray.jsp",
		"admin/includes/writeNumActiveBackendUsers.jsp",
		"index.jsp",
		"about/about.jsp",
		"admin/addInstances.jsp",
		"admin/addProjects.jsp",
		"admin/addUsers.jsp",
		"admin/confirmUpdateKey.jsp",
		"admin/emailConfig.jsp",
		"admin/generalConfig.jsp",
		"admin/instances.jsp",
		"admin/menu.jsp",
		"admin/processAddInstances.jsp",
		"admin/processAddProjects.jsp",
		"admin/processAddUsers.jsp",
		"admin/processEmailConfig.jsp",
		"admin/processGeneralConfig.jsp",
		"admin/processInstances.jsp",
		"admin/processProjects.jsp",
		"admin/processTestNotifications.jsp",
		"admin/processUpdateKey.jsp",
		"admin/processUsers.jsp",
		"admin/projects.jsp",
		"admin/projectSummaries.jsp",
		"admin/showEmailConfigChanges.jsp",
		"admin/showGeneralConfigChanges.jsp",
		"admin/showInstanceChanges.jsp",
		"admin/showProjectChanges.jsp",
		"admin/showUserChanges.jsp",
		"admin/systemSummary.jsp",
		"admin/testNotifications.jsp",
		"admin/testNotificationsResults.jsp",
		"admin/updateKey.jsp",
		"admin/users.jsp",
		"admin/userSummaries.jsp",
		"errors/error.jsp",
		"feedback/compose.jsp",
		"feedback/send.jsp",
		"issues/addAttachments.jsp",
		"issues/attredirect/index.jsp",
		"issues/addURLs.jsp",
		"issues/calendar.jsp",
		"issues/closed.jsp",
		"issues/closeIssue.jsp",
		"issues/displayDownloadUrl.jsp",
		"issues/export.jsp",
		"issues/exportDialog.jsp",
		"issues/filterInput.jsp",
		"issues/filters.jsp",
		"issues/importDialog.jsp",
		"issues/importFailure.jsp",
		"issues/importSuccess.jsp",
		"issues/index.jsp",
		"issues/issueInput.jsp",
		"issues/list.jsp",
		"issues/listBasic.jsp",
		"issues/listContent.jsp",
		"issues/listFooter.jsp",
		"issues/listHeader.jsp",
		"issues/previewImportedIssues.jsp",
		"issues/printableList.jsp",
		"issues/printPrefsDialog.jsp",
		"issues/processCloseIssue.jsp",
		"issues/processAddAttachments.jsp",
		"issues/processAddURLs.jsp",
		"issues/processFilterInput.jsp",
		"issues/processImport.jsp",
		"issues/processImportInsert.jsp",
		"issues/processIssueInput.jsp",
		"issues/processReopenIssue.jsp",
		"issues/removeFilter.jsp",
		"issues/removeAttachment.jsp",
		"issues/removeURL.jsp",
		"issues/removeFilter.jsp",
		"issues/reopenIssue.jsp",
		"issues/viewImportErrors.jsp",
		"login/answerSecretQuestion.jsp",
		"login/displayPassword.jsp",
		"login/forgotPassword.jsp",
		"login/login.jsp",
		"login/loginConfirm.jsp",
		"login/loginSecretQuestion.jsp",
		"login/logout.jsp",
		"login/processLogin.jsp",
		"login/processLoginSecretQuestion.jsp",
		"login/processSecretQuestion.jsp",
		"userprefs/prefs.jsp",
		"userprefs/processPrefs.jsp",
		"userprefs/showPrefsChanges.jsp",
	};

	static final String PATH_TO_APP_ROOT_ATTR_NAME="pathToAppRoot";
	static final String REQUIRED_LOGIN_STATUS_ATTR_NAME="requiredLoginStatus";
	static final String SKIP_DB_PROPS_POINTER_EXISTENCE_CHECK_ATTR_NAME="skipDbPropsPointerCheck";
	static final String SHOW_TOP_NAV_ATTR_NAME="showTopNav";
	static final String SKIP_TRIAL_PERIOD_EXPIRE_CHECK_ATTR_NAME="skipTrialPeriodExpireCheck";
	static final String SKIP_MAX_USERS_EXCEEDED_CHECK_ATTR_NAME="maxUsersExceededCheck";
	static final String SKIP_SITE_ID_CHECK_ATTR_NAME = "skipSiteIdCheck";
	
	static final String SECTION_ATTR_NAME="section";
	static final String SUBSECTION_ATTR_NAME="subsection";
	static final String REQUIRED_REQUEST_METHOD_ATTR_NAME="requiredRequestMethod";
	static final String ERROR_PAGE_ATTR_NAME="errorPage";



	public static void setPathToAppRoot(String path, final HttpServletRequest request)
	{
		if (path==null)
		{
			path="";
		}
		path=path.trim();
		if (path.length()>0 && path.indexOf("../")!=0)
		{
			throw new IllegalArgumentException("path \""+path+"\" is invalid; must be nullstring (or null, taken to mean nullstring), or a series of the sequence \"../\".");
		}
		setRequestAttribute(PATH_TO_APP_ROOT_ATTR_NAME, path, request);
	}
	public static void setRequiredLoginStatus(final String requiredLoginStatus, final HttpServletRequest request)
	{
		if
		(
			requiredLoginStatus==null ||
			(
				!(requiredLoginStatus.trim().toLowerCase().equals("none")) &&
				!(requiredLoginStatus.trim().toLowerCase().equals("user")) &&
				!(requiredLoginStatus.trim().toLowerCase().equals("backenduser"))
			)
		)
		{
			throw new IllegalArgumentException("setRequiredLoginStatus() takes only \"none\", \"user\", or \"backenduser\" as its first argument.");
		}
		setRequestAttribute(REQUIRED_LOGIN_STATUS_ATTR_NAME, requiredLoginStatus, request);
	}
	public static void setSection(final String section, final HttpServletRequest request)
	{
		setRequestAttribute(SECTION_ATTR_NAME, section, request);
	}
	public static void setSubsection(final String subsection, final HttpServletRequest request)
	{
		setRequestAttribute(SUBSECTION_ATTR_NAME, subsection, request);
	}
	public static void setRequiredRequestMethod(final String requiredRequestMethod, final HttpServletRequest request)
	{
		setRequestAttribute(REQUIRED_REQUEST_METHOD_ATTR_NAME, requiredRequestMethod, request);
	}
	public static void setErrorPage(final boolean errorPage, final HttpServletRequest request)
	{
		request.setAttribute(ERROR_PAGE_ATTR_NAME, new Boolean(errorPage));
	}

	public static void setSkipDBPropsPointerExistenceCheck(final boolean skip, final HttpServletRequest request)
	{
		request.setAttribute(SKIP_DB_PROPS_POINTER_EXISTENCE_CHECK_ATTR_NAME, new Boolean(skip));
	}
	public static void setShowTopNav(final boolean show, final HttpServletRequest request)
	{
		request.setAttribute(SHOW_TOP_NAV_ATTR_NAME, new Boolean(show));
	}
	public static void setSkipTrialPeriodExpireCheck(final boolean skip, final HttpServletRequest request)
	{
		request.setAttribute(SKIP_TRIAL_PERIOD_EXPIRE_CHECK_ATTR_NAME, new Boolean(skip));
	}
	public static void setSkipMaxUsersExceededCheck(final boolean skip, final HttpServletRequest request)
	{
		request.setAttribute(SKIP_MAX_USERS_EXCEEDED_CHECK_ATTR_NAME, new Boolean(skip));
	}
	public static void setSkipSiteIdCheck(final HttpServletRequest request) {
		request.setAttribute(SKIP_SITE_ID_CHECK_ATTR_NAME, new Boolean(true));
	}



	public static String getPathToAppRoot(final HttpServletRequest request)
	{
		return getRequestAttribute(PATH_TO_APP_ROOT_ATTR_NAME, "./", request);
	}
	public static String getRequiredLoginStatus(final HttpServletRequest request)
	{
		return getRequestAttribute(REQUIRED_LOGIN_STATUS_ATTR_NAME, "none", request);
	}
	public static String getSection(final HttpServletRequest request)
	{
		return getRequestAttribute(SECTION_ATTR_NAME, "", request);
	}
	public static String getSubsection(final HttpServletRequest request)
	{
		return getRequestAttribute(SUBSECTION_ATTR_NAME, "", request);
	}
	public static String getRequiredRequestMethod(final HttpServletRequest request)
	{
		return getRequestAttribute(REQUIRED_REQUEST_METHOD_ATTR_NAME, "", request);
	}
	public static boolean isErrorPage(final HttpServletRequest request)
	{
		if (request.getAttribute(ERROR_PAGE_ATTR_NAME)==null)
		{
			return false;
		}
		return ((Boolean)request.getAttribute(ERROR_PAGE_ATTR_NAME)).booleanValue();
	}

	public static boolean isSkipDBPropsPointerExistenceCheck(final HttpServletRequest request)
	{
		if (request.getAttribute(SKIP_DB_PROPS_POINTER_EXISTENCE_CHECK_ATTR_NAME)==null)
		{
			return false;
		}
		return ((Boolean)request.getAttribute(SKIP_DB_PROPS_POINTER_EXISTENCE_CHECK_ATTR_NAME)).booleanValue();
	}
	public static boolean isShowTopNav(final HttpServletRequest request)
	{
		if (request.getAttribute(SHOW_TOP_NAV_ATTR_NAME)==null)
		{
			return true;
		}
		return ((Boolean)request.getAttribute(SHOW_TOP_NAV_ATTR_NAME)).booleanValue();
	}
	
	public static boolean isSkipSiteIdCheck(final HttpServletRequest request) 
	{
		if (request.getAttribute(SKIP_SITE_ID_CHECK_ATTR_NAME)==null)
		{
			return false;
		}
		return ((Boolean)request.getAttribute(SKIP_SITE_ID_CHECK_ATTR_NAME)).booleanValue();
	}


	public static boolean isSkipTrialPeriodExpireCheck(final HttpServletRequest request)
	{
		if (request.getAttribute(SKIP_TRIAL_PERIOD_EXPIRE_CHECK_ATTR_NAME)==null)
		{
			return false;
		}
		return ((Boolean)request.getAttribute(SKIP_TRIAL_PERIOD_EXPIRE_CHECK_ATTR_NAME)).booleanValue();
	}
	public static boolean isSkipMaxUsersExceededCheck(final HttpServletRequest request)
	{
		if (request.getAttribute(SKIP_MAX_USERS_EXCEEDED_CHECK_ATTR_NAME)==null)
		{
			return false;
		}
		return ((Boolean)request.getAttribute(SKIP_MAX_USERS_EXCEEDED_CHECK_ATTR_NAME)).booleanValue();
	}


	private static void setRequestAttribute(final String name, final String value, final HttpServletRequest request)
	{
		request.setAttribute(name,value);
	}
	private static String getRequestAttribute(final String name, final String defaultValue, final HttpServletRequest request)
	{
		return (request.getAttribute(name)!=null?(String)request.getAttribute(name):defaultValue);
	}


	public static void loginUser(final User user, final Controller controller)
	{
		final HttpServletResponse response=controller.getResponse();
		final SessionInfo sessionInfo=controller.getSessionInfo();
		sessionInfo.setLoginStatus(user.isBackendUser()?"backenduser":"user");
		sessionInfo.setRequiredUserTypeForLogin(null);
		sessionInfo.setPostLoginDestinationUrl(null);
		controller.setSessionInfo(sessionInfo);
		user.setLastAccessDate(new Date());
		user.store();
	}

	public static void logoutUser(final Controller controller)
	{
		try {
			final HttpServletResponse response=controller.getResponse();
			final SessionInfo sessionInfo=controller.getSessionInfo();
			final User user = sessionInfo.getUser();
	
			sessionInfo.setUser(null);
			sessionInfo.setLoginStatus("none");
			controller.setSessionInfo(sessionInfo);
		}
		catch (final RuntimeException e) {
		}
	}


	public static String getDisguisedStringFromInt(final int pInt)
	{
		long n=pInt;
		n+=DISGUISE_INCREMENT;
		n*=DISGUISE_FACTOR;
		final String nStr=""+n;
		String ret="";
		for (int i=0; i<nStr.length(); i++)
		{
			final int thisChar=Integer.parseInt(""+nStr.charAt(i));
			ret+=DISGUISE_KEY[i].charAt(thisChar);
		}
		return ret;
	}

	public static int getIntFromDisguisedString(final String s)
	{
		String newStr="";
		for (int i=0; i<s.length(); i++)
		{
			final char thisChar=s.charAt(i);
			newStr+=DISGUISE_KEY[i].indexOf(""+thisChar);
		}
		long ret=Long.parseLong(newStr);
		ret/=DISGUISE_FACTOR;
		ret-=DISGUISE_INCREMENT;
		return (int)ret;
	}

	public static void jspStart(final HttpServletRequest request)
	{
		if (!isCompileOnly(request))
		{
			//logger.info(LINE_SEPARATOR+LINE_SEPARATOR+">>> BEGIN "+getCurrentUrl(request));
		}
	}
	public static void jspEnd(final HttpServletRequest request)
	{
		if (!isCompileOnly(request))
		{
			//logger.info(">>> END "+getCurrentUrl(request)+LINE_SEPARATOR+LINE_SEPARATOR);
		}
	}

	public static String getCurrentUrl(final HttpServletRequest request)
	{
		return request.getRequestURI()+(request.getQueryString()!=null?"?"+request.getQueryString():"");
	}

	public static void forceNoCache(final HttpServletResponse response)
	{
		response.setHeader("Cache-Control", "no-cache");
		response.setHeader("Pragma", "no-cache");
		response.setHeader("Expires", "0");
	}

	public static String nonNull(final String s)
	{
		return GeneralUtils.nonNull(s);
	}

	public static void doCompileOnlyCheck(final HttpServletRequest request)
	{
		if (isCompileOnly(request))
		{
			// deliberately throw an exception; we don't want this page to execute, just be compiled:
			logger.info("Compiled.");
			throw new RuntimeException("(Ignore Exception; deliberately thrown during precompile.");
		}
	}

	public static boolean isCompileOnly(final HttpServletRequest request)
	{
		return (request.getParameter("compileOnly")!=null && request.getParameter("compileOnly").equals("true"));
	}
	
	public static String truncate(final String s, final int maxLength, final String suffix) {
		if (s.length()<=maxLength) {
			return new String(s);
		}
		return s.substring(0,maxLength)+(suffix!=null?suffix:"");
	}
	
	public static String truncate(final String s, final int maxLength) {
		return truncate(s, maxLength, "...");
	}




}