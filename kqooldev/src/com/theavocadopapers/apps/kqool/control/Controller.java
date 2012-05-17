/*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
 */

package com.theavocadopapers.apps.kqool.control;

import java.io.IOException;
import java.util.Properties;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.PageContext;

import com.theavocadopapers.apps.kqool.AppException;
import com.theavocadopapers.apps.kqool.client.Client;
import com.theavocadopapers.apps.kqool.entity.Site;
import com.theavocadopapers.apps.kqool.session.SessionInfo;
import com.theavocadopapers.apps.kqool.util.GeneralUtils;
import com.theavocadopapers.apps.kqool.util.PageUtils;
import com.theavocadopapers.core.logging.Logger;

public class Controller implements com.theavocadopapers.apps.kqool.Constants {

	private static final Logger logger = Logger.getLogger(Controller.class);

	private static final String DEFAULT_LOGIN_PAGE_URL = "login/login.jsp";

	public static final String SESSION_INFO_ATTR = com.theavocadopapers.apps.kqool.Constants.SESSION_ATTRIBUTE_NAME_PREFIX
			+ "sessionInfo";

	public static final String SITE_ID_PARAM = "siteId";
	public static final String SITE_ID_ATTR = "siteId";
	public static final String SITE_ATTR = "site";
	public static final String FORCE_LOGOUT_PARAM = "fl";

	private static Properties systemProperties = new Properties();

	private static boolean systemPropertiesInitialized = false;

	HttpServletRequest request;
	HttpServletResponse response;
	HttpSession session;
	boolean initialized = false;
	String pathToAppRoot;
	int loginRequirement;
	boolean responseRedirected = false;
	Site site;

	public boolean doGlobalControl(final PageContext pageContext)
			throws IOException {
		initController(pageContext);

		if (!PageUtils.isErrorPage(request) && !isValidClient(getClient())) {
			redirect(pathToAppRoot + "errors/error.jsp?" + getSiteIdNVPair()
					+ "&e=invalidBrowser");
		}
		String siteIdParam = request.getParameter(SITE_ID_PARAM);
		if (siteIdParam == null) {
			// don't throw anymore; we must allow for users with old URLs
			// bookmarked:
			// throw new SiteIdMissingException();
			siteIdParam = "1"; // assume kqool
		}
		if (!PageUtils.isSkipSiteIdCheck(request)) {
			// make this available to all dynamically included pages:
			request.setAttribute(SITE_ID_ATTR, siteIdParam);
			this.site = (Site) session.getAttribute(SITE_ATTR);
		} else {
			final String url = request.getRequestURL().toString();
			if (url.indexOf("localhost") > -1) {
				// throw new
				// RuntimeException("localhost is not a valid URL; please use the format subdomain.domain.com.");
			}
			if (url.indexOf(".kqool") == -1) {
				// throw new
				// RuntimeException("no subdomain found; please use format subdomain.domain.com.");
			}
			//final String domainPrefix = url.substring(url.indexOf("://")
			//		+ "://".length(), url.indexOf("."));
			//final Site site = Site.getById(Integer.parseInt(siteIdParam));
			//session.setAttribute(SITE_ATTR, site);
			//this.site = site;
			// make this available to all dynamically included pages:
			//request.setAttribute(SITE_ID_ATTR, "" + site.getId());

		}

		return loginCheck();

	}

	public void initController(final PageContext pageContext) {
		this.request = (HttpServletRequest) pageContext.getRequest();
		this.response = (HttpServletResponse) pageContext.getResponse();
		this.session = pageContext.getSession();

		this.pathToAppRoot = PageUtils.getPathToAppRoot(request);
		this.initialized = true;
	}

	public boolean loginCheck() {
		initCheck();
		final String requiredLoginStatus = PageUtils
				.getRequiredLoginStatus(request);
		if (!(requiredLoginStatus == null || requiredLoginStatus.trim()
				.toLowerCase().equals("none"))) {
			// some sort of login is required, so:

			final SessionInfo sessionInfo = getSessionInfo();
			final String loginStatus = sessionInfo.getLoginStatus();
			if (loginStatus == null
					|| loginStatus.trim().toLowerCase().equals("none")) {
				// user is not logged in; need login, then need to return to
				// this page:
				getLoginFromUser(sessionInfo, requiredLoginStatus);
				return false;
			} else {
				// else the user is logged in, but we need to make sure it's not
				// just a
				// user if a backend user is required; also need to make sure
				// that the user id
				// matches the current user's user-id cookie:
				if (requiredLoginStatus.trim().toLowerCase().equals(
						"backenduser")
						&& !(loginStatus.trim().toLowerCase()
								.equals("backenduser"))) {
					getLoginFromUser(sessionInfo, requiredLoginStatus);
					return false;
				}
			}
		}
		return true;
	}

	public String getSiteId() {
		initCheck();
		String siteId = (String) request.getAttribute(SITE_ID_ATTR);
		if (siteId == null) {
			// don't throw anymore; need to acct for users with old URLs
			// bookmarked:
			// throw new SiteIdMissingException();
			siteId = "1";
			request.setAttribute(SITE_ID_ATTR, siteId);
		}
		return siteId;
	}

	public int getSiteIdInt() {
		return Integer.parseInt(getSiteId());
	}

	public String getSiteIdNVPair() {
		return SITE_ID_PARAM + "=" + getSiteId();
	}

	public Cookie getCookie(final String name) {
		initCheck();
		final Cookie[] cookies = request.getCookies();
		if (name == null || cookies == null) {
			return null;
		}
		for (int i = 0; i < cookies.length; i++) {
			if (cookies[i].getName().equals(name)) {
				return cookies[i];
			}
		}
		return null;
	}

	public String getCookieValue(final String name) {
		initCheck();
		final Cookie cookie = getCookie(name);
		if (cookie == null) {
			return null;
		}
		return cookie.getValue();
	}

	public void setCookieValue(final String name, final String value) {
		final Cookie cookie = new Cookie(name, value);
		cookie.setMaxAge(60 * 60 * 24);
		cookie.setPath("/");
		response.addCookie(cookie);
	}

	public String getLoginPageUrl(final String requiredLoginStatus) {
		initCheck();
		final String currentSectionName = PageUtils.getSection(request);
		// hack hack hack --
		final boolean isPopup = (currentSectionName.equals("feedback")
				|| currentSectionName.equals("issuespopup")
				|| currentSectionName.equals("adminpopup")
				|| currentSectionName.equals("about") || currentSectionName
				.equals("help"));
		return pathToAppRoot + DEFAULT_LOGIN_PAGE_URL + "?" + getSiteIdNVPair()
				+ (isPopup ? "&isPopup=true" : "");
	}

	public void getLoginFromUser(final SessionInfo sessionInfo,
			final String requiredLoginStatus) {
		initCheck();
		sessionInfo
				.setPostLoginDestinationUrl(PageUtils.getCurrentUrl(request));
		sessionInfo.setRequiredUserTypeForLogin(requiredLoginStatus);
		setSessionInfo(sessionInfo);
		try {
			redirect(getLoginPageUrl(requiredLoginStatus));
		} catch (final IOException ioe) {
			logger.error("trying to redirect to login page", ioe);
		}
	}

	public void redirect(final String url) throws IOException {
		initCheck();
		if (!responseRedirected) {
			responseRedirected = true;
			response.getWriter().println(
					LINE_SEPARATOR + "</script>" + LINE_SEPARATOR + "<script>"
							+ LINE_SEPARATOR + "location.replace(\"" + url
							+ "\");" + LINE_SEPARATOR + "</script>");
		} else {
			logger
					.warn("Response has already been redirected so no action has been taken.");
		}
	}

	// note:returns the application-root url WITHOUT a trailing slash.
	public String getApplicationRootURL(final int siteId) {
		String ret = null;
		try {
			initCheck();
			// PageUtils.setPathToAppRoot() ensures that pathToAppRoot will
			// always be "" or "../" or "../../", etc (never, btw, relative from
			// root, e.g. "/" or "/app", or absolute, e.g.
			// "http://www.myurl.com/"); count instances of "../":
			int count = 0;
			String root = "" + (pathToAppRoot == null ? "" : pathToAppRoot);
			final String searchFor = "../";
			while (root.indexOf(searchFor) == 0) {
				count++;
				root = root.substring(searchFor.length(), root.length());
			}
			String currentUrl = GeneralUtils.getRequestURL(request, siteId)
					.toString();
			currentUrl = currentUrl.substring(0, currentUrl.lastIndexOf("/"));
			for (int i = 0; i < count; i++) {
				currentUrl = currentUrl.substring(0, currentUrl
						.lastIndexOf("/"));
			}
			ret = currentUrl;
		} catch (final Exception e) {
			logger.error("trying to get app root url", e);
		}
		return ret;
	}

	public SessionInfo getSessionInfo() {
		initCheck();
		SessionInfo sessionInfo = (SessionInfo) session
				.getAttribute(SESSION_INFO_ATTR);
		if (sessionInfo == null) {
			sessionInfo = new SessionInfo();
			setSessionInfo(sessionInfo);
		}
		return sessionInfo;
	}

	public Client getClient() {
		initCheck();
		Client client = (Client) session
				.getAttribute(com.theavocadopapers.apps.kqool.Constants.SESSION_ATTRIBUTE_NAME_PREFIX
						+ "client");
		if (client == null) {
			client = new Client(request);
		}
		return client;
	}

	public void setSessionInfo(final SessionInfo sessionInfo) {
		initCheck();
		session.setAttribute(SESSION_INFO_ATTR, sessionInfo);
	}

	public static Properties getSystemProperties() {
		try {
			if (!systemPropertiesInitialized) {
				synchronized (systemProperties) {
					systemProperties = (Properties) (System.getProperties()
							.clone());
					if (systemProperties == null) {
						systemProperties = new Properties();
					}
				}
				systemPropertiesInitialized = true;
			}
			return systemProperties;
		} catch (final Exception e) {
			logger
					.error(
							"Exception caught (rethrowing as RuntimeException) in getSystemProperties()",
							e);
			throw new RuntimeException("" + e + ": " + e.getMessage());
		}
	}

	public static boolean isValidClient(final Client client) {
		return true;
		/*
		 * if (client.isExp()) { if (client.getMajorVersion()<5) { return false;
		 * } if (!client.isWin() && !client.isMac()) { return false; } } else if
		 * (client.isNav()) { if (client.getMajorVersion()<5) // as currently
		 * implemented, Client identifies NN 6 and 7 as v 5 { return false; } }
		 * else { return false; } return true;
		 */
	}

	private void initCheck() {
		if (!this.initialized) {
			logger
					.info("about to throw AppException: This method of Controller may not be invoked until one of the following methods: get(), post(), doGlobalControl().");
			throw new AppException(
					"This method of Controller may not be invoked until one of the following methods: get(), post(), doGlobalControl().");
		}
	}

	public HttpServletRequest getRequest() {
		return request;
	}

	public void setRequest(final HttpServletRequest request) {
		this.request = request;
	}

	public HttpServletResponse getResponse() {
		return response;
	}

	public void setResponse(final HttpServletResponse response) {
		this.response = response;
	}

	public String getParam(final String paramName,
			final String defaultParamValue) {
		initCheck();
		return (request.getParameter(paramName) != null ? request
				.getParameter(paramName) : new String(defaultParamValue));
	}

	public String getParam(final String paramName) {
		return getParam(paramName, "");
	}

	public int getParamAsInt(final String paramName, final int defaultParamValue) {
		initCheck();
		try {
			return (request.getParameter(paramName) != null ? Integer
					.parseInt(request.getParameter(paramName))
					: defaultParamValue);
		} catch (final NumberFormatException e) {
			return defaultParamValue;
		}
	}

	public int getParamAsInt(final String paramName) {
		return getParamAsInt(paramName, 0);
	}

	public long getParamAsLong(final String paramName,
			final long defaultParamValue) {
		initCheck();
		return (request.getParameter(paramName) != null ? Long
				.parseLong(request.getParameter(paramName)) : defaultParamValue);
	}

	public long getParamAsLong(final String paramName) {
		return getParamAsLong(paramName, 0);
	}

	public double getParamAsDouble(final String paramName,
			final double defaultParamValue) {
		initCheck();
		return (request.getParameter(paramName) != null ? Double
				.parseDouble(request.getParameter(paramName))
				: defaultParamValue);
	}

	public double getParamAsDouble(final String paramName) {
		return getParamAsDouble(paramName, 0);
	}

	public boolean getParamAsBoolean(final String paramName,
			final boolean defaultParamValue) {
		initCheck();
		return (request.getParameter(paramName) != null ? (request
				.getParameter(paramName).trim().toLowerCase().equals("true"))
				: defaultParamValue);
	}

	public boolean getParamAsBoolean(final String paramName) {
		return getParamAsBoolean(paramName, false);
	}

	public int[] getParamsAsIntArray(final String paramName,
			final int[] defaultParamValue) {
		initCheck();
		final String[] paramValues = request.getParameterValues(paramName);
		if (paramValues == null || paramValues.length == 0) {
			final int[] ret = new int[defaultParamValue.length];
			System.arraycopy(defaultParamValue, 0, ret, 0,
					defaultParamValue.length);
			return ret;
		}
		final int[] ints = new int[paramValues.length];
		{
			for (int i = 0; i < paramValues.length; i++) {
				ints[i] = Integer.parseInt(paramValues[i]);
			}
		}
		return ints;
	}

	public int[] getParamsAsIntArray(final String paramName) {
		final int[] emptyArray = {};
		return getParamsAsIntArray(paramName, emptyArray);
	}

	public boolean getAttrAsBoolean(final String attrName) {
		return getAttrAsBoolean(attrName, false);
	}

	public boolean getAttrAsBoolean(final String attrName,
			final boolean defaultValue) {
		try {
			return ((Boolean) request.getAttribute(attrName)).booleanValue();
		} catch (final RuntimeException e) {
			return defaultValue;
		}
	}

	public int getAttrAsInt(final String attrName) {
		return ((Integer) request.getAttribute(attrName)).intValue();
	}

	public double getAttrAsDouble(final String attrName) {
		return ((Double) request.getAttribute(attrName)).doubleValue();
	}

	public Object getAttr(final String attrName) {
		return request.getAttribute(attrName);
	}

	// convenience instance methods calling static *Util methods:
	public String getPathToAppRoot() {
		initCheck();
		return PageUtils.getPathToAppRoot(this.request);
	}

	public String getRequiredLoginStatus() {
		initCheck();
		return PageUtils.getRequiredLoginStatus(this.request);
	}

	public String getSection() {
		initCheck();
		return PageUtils.getSection(this.request);
	}

	public String getSubsection() {
		initCheck();
		return PageUtils.getSubsection(this.request);
	}

	public String getRequiredRequestMethod() {
		initCheck();
		return PageUtils.getRequiredRequestMethod(this.request);
	}

	public boolean isSkipDBPropsPointerExistenceCheck() {
		initCheck();
		return PageUtils.isSkipDBPropsPointerExistenceCheck(this.request);
	}

	public Site getSite() {
		initCheck();
		if (site == null) {
			int siteIdInt = getSiteIdInt();
			if (siteIdInt == 0) {
				siteIdInt = 1;
			}
			site = Site.getById(siteIdInt);
		}
		return site;
	}

}
