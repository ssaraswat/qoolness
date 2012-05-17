/*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/

package com.theavocadopapers.apps.kqool.session;


import com.theavocadopapers.apps.kqool.control.Controller;
import com.theavocadopapers.apps.kqool.entity.User;
import com.theavocadopapers.core.logging.Logger;


public class SessionInfo
implements com.theavocadopapers.apps.kqool.Constants
{


	private static final Logger logger = Logger.getLogger(SessionInfo.class);

	
	String loginStatus="none"; // may be redefined to "user" or "backenduser"
	User user=null;
	String requiredUserTypeForLogin;
	String postLoginDestinationUrl;
	boolean show;

	
	public String getLoginStatus()
	{
		return loginStatus;
	}
	public String getRequiredUserTypeForLogin()
	{
		return requiredUserTypeForLogin;
	}
	public String getPostLoginDestinationUrl()
	{
		return postLoginDestinationUrl;
	}
	public User getUser()
	{
		return user;
	}
	
	public void setShowDisplayPasswordPage(final boolean show) {
	    this.show=show;
	}

	public boolean isShowDisplayPasswordPage() {
	    return show;
	}



	public void setLoginStatus(final String loginStatus)
	{
		this.loginStatus=loginStatus;
	}
	public void setRequiredUserTypeForLogin(final String requiredUserTypeForLogin)
	{
		this.requiredUserTypeForLogin=requiredUserTypeForLogin;
	}
	public void setPostLoginDestinationUrl(final String postLoginDestinationUrl)
	{
		String url=""+(postLoginDestinationUrl!=null?postLoginDestinationUrl:"");
		final String forceLogoutNvPair=Controller.FORCE_LOGOUT_PARAM+"=true";
		if (url.indexOf(forceLogoutNvPair)>-1) {
			final String pre=url.substring(0, url.indexOf(forceLogoutNvPair));
			final String post=url.substring(url.indexOf(forceLogoutNvPair)+forceLogoutNvPair.length(), url.length());
			url=pre+post;
		}
		logger.info("Setting postLoginDestinationUrl to "+url);
		this.postLoginDestinationUrl=url;
	}
	public void setUser(final User user)
	{
		this.user=user;
	}


}