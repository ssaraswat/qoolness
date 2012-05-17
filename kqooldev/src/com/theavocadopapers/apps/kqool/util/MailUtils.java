/*
 * Created on Dec 30, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.util;

import java.io.UnsupportedEncodingException;
import java.net.InetAddress;
import java.text.DateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.PageContext;

import com.theavocadopapers.apps.kqool.GenericProperties;
import com.theavocadopapers.apps.kqool.PfdProperties;
import com.theavocadopapers.apps.kqool.SiteProperties;
import com.theavocadopapers.apps.kqool.control.Controller;
import com.theavocadopapers.apps.kqool.entity.ClientToBackendUserMapping;
import com.theavocadopapers.apps.kqool.entity.Site;
import com.theavocadopapers.apps.kqool.entity.User;
import com.theavocadopapers.apps.kqool.entity.Workout;
import com.theavocadopapers.apps.kqool.exception.FatalApplicationException;
import com.theavocadopapers.apps.kqool.session.SessionInfo;
import com.theavocadopapers.core.mail.Mailer;
import com.theavocadopapers.core.mail.SimpleMailMessageBody;
import com.theavocadopapers.core.util.URLEncoder;


/**
 * @author Steve Schneider
 *
 */
public class MailUtils {


	/**
	 * must be all lowercase
	 */
	public static final String[] RELEVANT_USER_AGENT_SUBSTRS_FOR_EXCEPTION_MSGS={
		"internet explorer","mozilla","safari","firefox","netscape","opera","[unknown]"
	};
	
	public static final String EOL=System.getProperty("line.separator","\n");
	
	protected static PfdProperties pfdProperties=new PfdProperties();
	
	protected static GenericProperties genericProps=new GenericProperties();


	private MailUtils() {} 
	

	public static void sendPfpRequest(final User user, final String emailAddr, final PageContext pageContext, final Controller controller)  {
		final int siteId=user.getSiteId();
		final Site site=Site.getById(siteId);
		final SiteProperties siteProps=new SiteProperties(siteId);
		final HttpServletRequest request=(HttpServletRequest)pageContext.getRequest();
		final StringBuffer text=new StringBuffer();
		
		String profileLink;
		if (genericProps.isUseNewPfpForm()) {
			profileLink=siteProps.getBaseSiteUrl()+"/login/pfd.jsp?n="+URLEncoder.encode(GeneralUtils.wEncrypt(user.getUsername()), "UTF-8")+"&siteId="+user.getSiteId()+"&"+Controller.FORCE_LOGOUT_PARAM+"=true";
		}
		else {
			profileLink=siteProps.getBaseSiteUrl()+"/login/pfp.jsp?n="+user.getUsername()+"&siteId="+user.getSiteId()+"&"+Controller.FORCE_LOGOUT_PARAM+"=true";
		}
		
		text.append(site.getLabel()+" requests that you fill out an online personal fitness profile.  We need to know more about your personal fitness and fitness goals, so that we can tailor your workouts to your needs.  Please click the \"continue\" button below to continue.<br/><br/><br/>");
		text.append("<a href=\""+profileLink+"\" target=_blank>"+mailButton("buttonContinue.gif", request, controller)+"</a><br/><br/>");
		final String tagline="Tell us about yourself.";
		final String subjectText=siteProps.getDefaultMailSubjectPrefix()+" So tell us..."
		;


		final KqoolMessageBody message=new KqoolMessageBody(
			tagline,
			text.toString(),
			request,
			siteId,
			controller
		);
		final InternetAddress[] toAddr=new InternetAddress[1];
		InternetAddress fromAddress=null;
		
		try {
			try {
				fromAddress=new InternetAddress(siteProps.getDefaultMailFrom(), siteProps.getDefaultMailFromLabel());
			}
			catch (final UnsupportedEncodingException e1) {				
			}
			toAddr[0]=new InternetAddress(emailAddr);

		}
		catch (final AddressException e) {
		}
		try {
			//Mailer.sendWithoutWaiting(
			Mailer.send(
				true,
				toAddr, 
				null, 
				null, 
				fromAddress, 
				subjectText, 
				message, 
				Mailer.MIME_TYPE_HTML, 
				null, 
				null, 
				siteProps
			);
		}
		catch (final AddressException e) {
			throw new FatalApplicationException(e);
		}
		catch (final Exception e) {
			throw new FatalApplicationException(e);
		}		
	}
	
	
	public static void sendActivationNotification(final User user, final int previousStatus, final PageContext pageContext, final Controller controller)  {
		final int siteId=user.getSiteId();
		final Site site=Site.getById(siteId);
		final SiteProperties siteProps=new SiteProperties(siteId);
		final HttpServletRequest request=(HttpServletRequest)pageContext.getRequest();
		final StringBuffer text=new StringBuffer();
		String tagline="";
		String subjectText=siteProps.getDefaultMailSubjectPrefix()+" ";

		if (previousStatus==User.STATUS_SUSPENDED) {
			subjectText+="Your "+site.getLabel()+" account has been reactivated";
			tagline="Your account is no longer suspended.";
			text.append("Your "+site.getLabel()+" username remains as it was before (\""+user.getUsername()+"\", without the quotes), so we'll see you soon!<br/><br/>");
		}
		else if (previousStatus==User.STATUS_DEACTIVATED) {
			subjectText+="Your "+site.getLabel()+" account has been reactivated";
			tagline="Your account has been reactivated.";
			text.append("Your "+site.getLabel()+" username remains as it was before (\""+user.getUsername()+"\", without the quotes), so we'll see you soon!<br/><br/>");
		}
		else {
			tagline="Your "+site.getLabel()+" account is active! Prepare to get pretty active yourself.";
			subjectText+="Your "+site.getLabel()+" account is active";
			text.append("Your username is \""+user.getUsername()+"\" (without the quotes); if you haven't chosen a password yet, you won't need one the first time you log in.<br/><br/>");
			
			String profileLink;
			if (genericProps.isUseNewPfpForm()) {
				profileLink=siteProps.getBaseSiteUrl()+"/login/pfd.jsp?n="+URLEncoder.encode(GeneralUtils.wEncrypt(user.getUsername()), "UTF-8")+"&siteId="+user.getSiteId()+"&"+Controller.FORCE_LOGOUT_PARAM+"=true";
			}
			else {
				profileLink=siteProps.getBaseSiteUrl()+"/login/pfp.jsp?n="+user.getUsername()+"&siteId="+user.getSiteId()+"&"+Controller.FORCE_LOGOUT_PARAM+"=true";
			}

			text.append("<b>Important:</b> if you have yet to complete a personal-fitness profile, please do that "+anchor(profileLink,"here", controller)+".<br/><br/>");
			text.append("If you've already completed a personal-fitness profile - or if you just can't wait another minute to access your new account - you may log in here...<br/><br/>");
			text.append(anchor(siteProps.getBaseSiteUrl()+"?"+Controller.FORCE_LOGOUT_PARAM+"=true", siteProps.getBaseSiteUrl(), controller)+"<br/><br/>");
			
			text.append("...and we'll see you soon!<br/><br/>");
			text.append("Oh, and by the way, all the email you receive from "+site.getLabel()+" will have a subject line that starts with  "+siteProps.getDefaultMailSubjectPrefix()+", just like this one does.  So, if you have a spam filter, you might want to set it up to recognize these emails. You wouldn't want some silly little filter to come between us, now would you?");
		}

		final KqoolMessageBody message=new KqoolMessageBody(
			tagline,
			text.toString(),
			request,
			siteId,
			controller
		);
		final InternetAddress[] toAddr=new InternetAddress[1];
		InternetAddress fromAddress=null;
		
		try {
			try {
				fromAddress=new InternetAddress(siteProps.getDefaultMailFrom(), siteProps.getDefaultMailFromLabel());
			}
			catch (final UnsupportedEncodingException e1) {}
			toAddr[0]=new InternetAddress(user.getEmailAddress());

		}
		catch (final AddressException e) {
		}
		try {
			//Mailer.sendWithoutWaiting(
			Mailer.send(
				true,
				toAddr, 
				null, 
				null, 
				fromAddress, 
				subjectText, 
				message, 
				Mailer.MIME_TYPE_HTML, 
				null, 
				null, 
				siteProps
			);
		}
		catch (final AddressException e) {
			throw new FatalApplicationException(e);
		}
		catch (final Exception e) {
			throw new FatalApplicationException(e);
		}
		
	}
	
	public static void sendWorkoutAssignmentMail(final User assignedToUser, final Workout workout, final PageContext pageContext, final Controller controller)  {
		final int siteId=assignedToUser.getSiteId();
		final SiteProperties siteProps=new SiteProperties(siteId);
		final HttpServletRequest request=(HttpServletRequest)pageContext.getRequest();
		final StringBuffer text=new StringBuffer();
		text.append("For details, please click the \"view routines\" button:<br/><br/>");
		text.append(anchor(
				siteProps.getBaseSiteUrl()+"/workouts/workoutList.jsp?selfAssign=false&prescriptive=true&id="+workout.getId()+"&siteId="+assignedToUser.getSiteId()+"&"+Controller.FORCE_LOGOUT_PARAM+"=true",
				mailButton("buttonViewRoutine.gif", request, controller), 
				controller)
			);  

		final KqoolMessageBody message=new KqoolMessageBody(
			"We are pleased to announce "+assignedToUser.getFirstName()+" "+assignedToUser.getLastName()+" as the proud recipient of a new fitness routine.",
			text.toString(),
			request,
			siteId,
			controller
		);
		final InternetAddress[] toAddr=new InternetAddress[1];
		InternetAddress fromAddress=null;
		final String subjectText=siteProps.getDefaultMailSubjectPrefix()+" You've got Qool.";
		try {
			try { 
				fromAddress=new InternetAddress(siteProps.getDefaultMailFrom(), siteProps.getDefaultMailFromLabel());
			}
			catch (final UnsupportedEncodingException e1) {}
			toAddr[0]=new InternetAddress(assignedToUser.getEmailAddress());

		}
		catch (final AddressException e) {
		}
		try {
			//Mailer.sendWithoutWaiting(
			Mailer.send(
				true,
				toAddr, 
				null, 
				null, 
				fromAddress, 
				subjectText, 
				message, 
				Mailer.MIME_TYPE_HTML, 
				null, 
				null, 
				siteProps
			);
		}
		catch (final AddressException e) {
			throw new FatalApplicationException(e);
		}
		catch (final Exception e) {
			throw new FatalApplicationException(e);
		}
	}

	
	public static void sendExceptionReport(final Throwable exception) throws NumberFormatException {
		sendExceptionReport(null, null, exception);
	}	
	
	public static void sendExceptionReport(final PageContext pageContext, final Controller controller, final Throwable exception) throws NumberFormatException {
		HttpServletRequest request=null;
		HttpSession session=null;
		if (pageContext!=null) {
			request=(HttpServletRequest)pageContext.getRequest();
			session=pageContext.getSession();			
		}
		

		
		String lcUserAgent;
		if (request!=null) {
			lcUserAgent=(""+request.getHeader("User-Agent")).toLowerCase();
		}
		else {
			lcUserAgent="[unknown]";
		}
		

		final boolean sendMail=true;
		/*
		for (int i=0; i<RELEVANT_USER_AGENT_SUBSTRS_FOR_EXCEPTION_MSGS.length; i++) {
			if (lcUserAgent.indexOf(RELEVANT_USER_AGENT_SUBSTRS_FOR_EXCEPTION_MSGS[i])>-1) {
				sendMail=true;
				break;
			}
		}
		*/
		if (sendMail) {
			final StringBuffer text=new StringBuffer();
			try {
				try {
					text.append("<b><br/>Exception:</b><br/>");
					text.append("<pre style=\"font-size:10px;\">"+getStackTrace(exception)+"");
					text.append("</pre>");
				}
				catch (final Throwable t) {
				}
				
				if (request!=null) {
					try {
						text.append("<b>request.getContextPath():</b> "+request.getContextPath()+"<br/>");
						text.append("<b>request.getMethod():</b> "+request.getMethod()+"<br/>");
						text.append("<b>request.getPathInfo():</b> "+request.getPathInfo()+"<br/>");
						text.append("<b>request.getPathTranslated():</b> "+request.getPathTranslated()+"<br/>");
						text.append("<b>request.getProtocol():</b> "+request.getProtocol()+"<br/>");
						text.append("<b>request.getQueryString():</b> "+request.getQueryString()+"<br/>");
						text.append("<b>request.getRemoteAddr():</b> "+request.getRemoteAddr()+"<br/>");
						text.append("<b>request.getRemoteHost():</b> "+request.getRemoteHost()+"<br/>");
						text.append("<b>request.getRemoteUser():</b> "+request.getRemoteUser()+"<br/>");
						text.append("<b>request.getRequestedSessionId():</b> "+request.getRequestedSessionId()+"<br/>");
						text.append("<b>request.getRequestURI():</b> "+request.getRequestURI()+"<br/>");
						text.append("<b>request.getScheme():</b> "+request.getScheme()+"<br/>");
						text.append("<b>request.getServerName():</b> "+request.getServerName()+"<br/>");
						text.append("<b>request.getServerPort():</b> "+request.getServerPort()+"<br/>");
						text.append("<b>request.getServletPath():</b> "+request.getServletPath()+"<br/>");
						try {
							text.append("<b>request.getLocale().getCountry():</b> "+request.getLocale().getCountry()+"<br/>");
						}
						catch (final Exception e) {
						}
						text.append("<b>request.isRequestedSessionIdValid():</b> "+request.isRequestedSessionIdValid()+"<br/>");
					
					}
					catch (final Throwable t) {
					}
				
		
					try {
					
						
						text.append("<b><br/>Request parameters:</b><br/>");
						final Enumeration names=request.getParameterNames();
						while (names!=null && names.hasMoreElements()) {
							final String name=(String)names.nextElement();
							text.append(name+"=");
							final String[] values=request.getParameterValues(name);
							for (int i=0; (values!=null && i<values.length); i++) {
								if (i>0) {
									text.append(", ");
								}
								text.append("\""+values[i]+"\"");
							}	
							text.append("<br/>");
						}
					}
					catch (final Throwable t) {
					}
		
					try {
						
						text.append("<b><br/>Request cookies:</b><br/>");
						final Cookie[] cookies=request.getCookies();
						for (int i=0; (cookies!=null && i<cookies.length); i++) {
							text.append(cookies[i].getName()+"="+cookies[i].getValue()+"<br/>");
						}
					}
					catch (final Throwable t) {
					}
		
					try {
						
						text.append("<b><br/>Request attributes:</b><br/>");
						final Enumeration names=request.getAttributeNames();
						while (names!=null && names.hasMoreElements()) {
							final String name=(String)names.nextElement();
							final Object value=request.getAttribute(name);
							if (value!=null) {
								text.append(name+"=\""+value+"\" ("+value.getClass().getName()+")<br/>");
							}
							else {
								text.append(name+"=null<br/>");
							}
					
						}
					}
					catch (final Throwable t) {
					}
		
					try {
						
						text.append("<b><br/>Request headers:</b><br/>");
						final Enumeration names=request.getHeaderNames();
						while (names!=null && names.hasMoreElements()) {
							final String name=(String)names.nextElement();
							final Object value=request.getHeader(name);
							if (value!=null) {
								text.append(name+"=\""+value+"\"<br/>");
							}
							else {
								text.append(name+"=null<br/>");
							}
					
						}
					}
					catch (final Throwable t) {
					}
				}
				
				if (session!=null) {
					try {
						
						text.append("<b><br/>Session attributes:</b><br/>");
						final Enumeration names=session.getAttributeNames();
						while (names!=null && names.hasMoreElements()) {
							final String name=(String)names.nextElement();
							final Object value=session.getAttribute(name);
							if (value!=null) {
								text.append(name+"=\""+value+"\" ("+value.getClass().getName()+")<br/>");
							}
							else {
								text.append(name+"=null<br/>");
							}
					
						}
					}
					catch (final Throwable t) {
					}
				}
	
				try {
					if (controller!=null) {
						final SessionInfo sessionInfo=controller.getSessionInfo();
						if (sessionInfo!=null) {
							text.append("<b><br/>SessionInfo:</b><br/>");
							text.append("getLoginStatus()=\""+sessionInfo.getLoginStatus()+"\"<br/>");
							text.append("getPostLoginDestinationUrl()=\""+sessionInfo.getPostLoginDestinationUrl()+"\"<br/>");
							text.append("getRequiredUserTypeForLogin()=\""+sessionInfo.getRequiredUserTypeForLogin()+"\"<br/>");
							text.append("getUser()=\""+sessionInfo.getUser()+"\"<br/>");
							final User user=sessionInfo.getUser();
							if (user!=null) {
								text.append("<b><br/>User in session:</b><br/>");
								text.append("getUsername()=\""+user.getUsername()+"\"<br/>");
								text.append("getFirstName()=\""+user.getFirstName()+"\"<br/>");
								text.append("getLastName()=\""+user.getLastName()+"\"<br/>");
								text.append("getEmailAddress()=\""+user.getEmailAddress()+"\"<br/>");
								text.append("getCommentsUserHidden()=\""+user.getCommentsUserHidden()+"\"<br/>");
								text.append("getCommentsUserVisible()=\""+user.getCommentsUserVisible()+"\"<br/>");
								text.append("getEmergencyContact()=\""+user.getEmergencyContact()+"\"<br/>");
								text.append("getGender()="+user.getGender()+"<br/>");
								text.append("getId()="+user.getId()+"<br/>");
								text.append("getStatus()="+user.getStatus()+"<br/>");
								text.append("getUserType()="+user.getUserType()+"<br/>");
								text.append("getBirthDate()=\""+user.getBirthDate()+"\"<br/>");
								text.append("getJoinDate()=\""+user.getJoinDate()+"\"<br/>");
								text.append("getLastAccessDate()=\""+user.getLastAccessDate()+"\"<br/>");
							}
						}
					}
				}
				catch (final Throwable t) {
				}
	
	
				
			
	
			
			}
			catch (final Throwable t) {
				text.append("Exception getting exception info: "+t+": "+(t.getMessage()!=null?t.getMessage():"null"));
			}
			
			
			
			
			
			
			final KqoolMessageBody message=new KqoolMessageBody(
					("There was an Exception on the kqool site; details:"),
					text.toString(),
					request,
					1,
					controller
				);
			final InternetAddress[] toAddr=new InternetAddress[1];
			InternetAddress fromAddress=null;
			String localhostStr;
			try {
				final InetAddress localhost=InetAddress.getLocalHost();
				localhostStr=""+localhost.getHostName()+"/"+localhost.getHostAddress();
			}
			catch (final Exception e) {
				localhostStr="unknown-host";
			}
			final String subjectText="Kqool application exception report {"+localhostStr+"}";
			
			
			try {
				fromAddress=new InternetAddress(genericProps.getExceptionEmailAddress());
				toAddr[0]=new InternetAddress(genericProps.getExceptionEmailAddress());
			}
			catch (final AddressException e) {
			}
			try {
				//Mailer.sendWithoutWaiting(
				Mailer.send(
					false,
					toAddr, 
					null, 
					null, 
					fromAddress, 
					subjectText, 
					message, 
					Mailer.MIME_TYPE_HTML, 
					null, 
					null, 
					null
					
				);
			}
			catch (final AddressException e) {
				throw new FatalApplicationException(e);
			}
			catch (final Exception e) {
				throw new FatalApplicationException(e);
			}
		}
	}

	private static String getStackTrace(Throwable exception) {
		try {
			final StringBuilder b=new StringBuilder(4096);
			int c=0;
			while (c<10) {
				final String description=exception.getClass().getName()+": "+exception.getMessage();
				final StackTraceElement[] els=exception.getStackTrace();
				b.append(description+EOL);
				if (els!=null) {
					for (int i=0; i<els.length; i++) {
						b.append("\t"+els[i].toString()+EOL);
					}
				}
				exception=exception.getCause();
				if (exception==null) {
					break;
				}
				b.append("Caused by..."+EOL);
				c++;
			}
			return b.toString();
		}
		catch (final Exception e) {
			return "[unavailable]";
		}
	}


	private static StringBuffer medConditionsGroup(final String subhead, final String[][] medConditions, final HttpServletRequest request) {
		StringBuffer text;
		if (subhead!=null) {
			text=new StringBuffer(subhead+"<br/>");
		}
		else {
			text=new StringBuffer();
		}
		for (int i=0; i<medConditions.length; i++) {
			String value=request.getParameter(medConditions[i][0]);
			if (value.equals("true")) {
				value="<font color=cc0000>Yes</font>";
			}
			else {
				value="No";
			}
			text.append(medConditions[i][1]+"? <b>"+value+"</b><br/>");
		}
		text.append("<br/>");
		return text;
	}
	
	public static void sendAssignmentMailToBackendUser(final User backendUser, final User client, final User assigningUser, final PageContext pageContext, final Controller controller) {
		final int siteId=backendUser.getSiteId();
		final SiteProperties siteProps=new SiteProperties(siteId);
		final Site site=Site.getById(siteId);
		final Site backendUserSite=site;
		final Site clientSite=Site.getById(client.getSiteId());
		final HttpServletRequest request=(HttpServletRequest)pageContext.getRequest();
		final String contextPath=(request).getContextPath();
		final String userPageLink=siteProps.getBaseSiteUrl()+"/kqadmin/user.jsp?id="+client.getId()+"&siteId="+siteId+"&"+Controller.FORCE_LOGOUT_PARAM+"=true";

		final StringBuffer text=new StringBuffer(assigningUser.getFormattedNameAndUsername()+", a "+assigningUser.getDefaultBackendUserTypeLabel()
				+" at "+site.getLabel()+", has shared "+client.getFormattedNameAndUsername()+", a client of "+clientSite.getLabel()
				+", with you.  Please be in contact with this client as soon as possible.  The client's details are <a href=\""+userPageLink+"\">here</a>.<br/><br/>");


		final KqoolMessageBody message=new KqoolMessageBody(
			assigningUser.getFormattedNameAndUsername()+" has shared a client with you.",
			text.toString(),
			request,
			siteId,
			controller
		);
		final InternetAddress[] toAddr=new InternetAddress[1];
		InternetAddress fromAddress=null;
		final String subjectText="New client shared with you by "+assigningUser.getFormattedNameAndUsername();
		try {
			try { 
				fromAddress=new InternetAddress(siteProps.getDefaultMailFrom(), siteProps.getDefaultMailFromLabel());
			}
			catch (final UnsupportedEncodingException e1) {}
			toAddr[0]=new InternetAddress(backendUser.getEmailAddress());

		}
		catch (final AddressException e) {
		}
		try {
			Mailer.send(
				true,
				toAddr, 
				null, 
				null, 
				fromAddress, 
				siteProps.getDefaultMailSubjectAdminPrefix()+" "+subjectText, 
				message, 
				Mailer.MIME_TYPE_HTML, 
				null, 
				null, 
				siteProps,
				false
			);
		}
		catch (final AddressException e) {
			throw new FatalApplicationException(e);
		}
		catch (final Exception e) {
			throw new FatalApplicationException(e);
		}		
		
	}
	
	public static void sendWorkoutNotification(final boolean existingWorkout, final Workout workout, final User user, final PageContext pageContext, final Controller controller)  {
		final int siteId=user.getSiteId();
		final SiteProperties siteProps=new SiteProperties(siteId);
		final HttpServletRequest request=(HttpServletRequest)pageContext.getRequest();
		final String contextPath=(request).getContextPath();
		final String workoutLink=siteProps.getBaseSiteUrl()+"/kqadmin/viewUserWorkouts.jsp?showLink=true&uid="+user.getId()+"&wid="+workout.getId()+"&siteId="+user.getSiteId()+"&"+Controller.FORCE_LOGOUT_PARAM+"=true";

		final StringBuffer text=new StringBuffer("Please click \"continue\" to view it.<br/><br/><br/>");
		text.append("<a href=\""+workoutLink+"\" target=_blank>"+mailButton("buttonContinue.gif", request, controller)+"</a><br/><br/>");


		final KqoolMessageBody message=new KqoolMessageBody(
			""+user.getFormattedNameAndUsername()+" "+(existingWorkout?"edited":"saved")+" a workout.",
			text.toString(),
			request,
			siteId,
			controller
		);
		
		final User toUser=User.getById(workout.getAssigningBackendUserId());
		final InternetAddress[] toAddr=new InternetAddress[1];
		InternetAddress fromAddress=null;
		final String subjectText=siteProps.getDefaultMailSubjectAdminPrefix()+" User "+(existingWorkout?"made changes to a stored workout":"saved a new workout ("+user.getFormattedNameAndUsername()+")");
		try {
			try { 
				fromAddress=new InternetAddress(siteProps.getDefaultMailFrom(), siteProps.getDefaultMailFromLabel());
			}
			catch (final UnsupportedEncodingException e1) {}
			toAddr[0]=new InternetAddress(toUser==null?siteProps.getProprietorEmailAddress():toUser.getEmailAddress());

		}
		catch (final AddressException e) {
		}
		try {
			Mailer.send(
				true,
				toAddr, 
				null, 
				null, 
				fromAddress, 
				subjectText, 
				message, 
				Mailer.MIME_TYPE_HTML, 
				null, 
				null, 
				siteProps,
				false
			);
		}
		catch (final AddressException e) {
			throw new FatalApplicationException(e);
		}
		catch (final Exception e) {
			throw new FatalApplicationException(e);
		}		

	}
	
	public static void sendHtmlMessage(final boolean doBccToDeveloper, final String to, final String from, final String subject, final String message, final PageContext pageContext, final int siteId) throws Exception {
		final SimpleMailMessageBody body=new SimpleMailMessageBody(message);
		Mailer.send(doBccToDeveloper, new InternetAddress(to), new InternetAddress(from), subject, body, "text/html", null, null, new SiteProperties(siteId), true);
	}
	
	// Note: after we switch permanently from the old "pfp" to the new db-driven "pfd,"
	// we can get rid of this method (sendPfdResults() will take its place):
	public static void sendPfpResults(final User user, final String[][] medConditions1, final String[][] medConditions2, final String[][] medConditions3, final String[][] medConditions4, final PageContext pageContext, final Controller controller) throws NumberFormatException {
		final int siteId=user.getSiteId();
		final SiteProperties siteProps=new SiteProperties(siteId);
		final HttpServletRequest request=(HttpServletRequest)pageContext.getRequest();

		final StringBuffer text=new StringBuffer("Here is the completed form.  You sent this form to the user, and "+(user.getGender()==User.MALE?"he":"she")+" returned it. The user's answers appear in <b>bold</b>; \"yes\" answers to yes/no medical questions appear in <font color=#cc0000><b>red bold</b></font>:");
		text.append("<blockquote>");

		text.append("Your age? <b>"+request.getParameter("age")+"</b><br/>");
		text.append("Your height? <b>"+request.getParameter("height")+"</b><br/>");
		text.append("Your weight? <b>"+request.getParameter("weight")+"</b><br/><br/>");
		text.append("Your target weight? <b>"+request.getParameter("targetWeight")+"</b><br/><br/>");
		text.append("What is your level of physical activity? <b>"+request.getParameter("activityLevel")+"</b><br/>");
		text.append("Do you currently exercise? <b>"+request.getParameter("currentlyExercise")+"</b><br/>");
		text.append("If \"yes,\" for how much per day? <b>"+request.getParameter("howLongExercise")+"</b><br/>");
		text.append("If \"no,\" have you exercised in the past? <b>"+((""+request.getParameter("exercisedInPast")).equals("true")?"Yes":"No")+"</b><br/>");
		text.append("Have you previously trained in any training program? <b>"+((""+request.getParameter("previousTrainingProgram")).equals("true")?"Yes":"No")+"</b><br/>");
		text.append("Have you ever participated in a personal training program? <b>"+((""+request.getParameter("previousPersonalTrainingProgram")).equals("true")?"Yes":"No")+"</b><br/><br/>");
		text.append("If you currently exercise, what exercises does your workout include? <b>"+request.getParameter("currentWorkout")+"</b><br/><br/>");
		text.append("What are your short and long term goals for exercise, health and fitness? <b>"+request.getParameter("goals")+"</b><br/><br/>");
		text.append("Do you have any other comments regarding your level of fitness or your fitness needs? <b>"+request.getParameter("comments")+"</b><br/><br/>");

		text.append(medConditionsGroup("Have you ever been diagnosed with, or suffered from:", medConditions1, request).toString());
		text.append(medConditionsGroup("Have you ever been diagnosed with or do you have any of the following:", medConditions2, request).toString());
		text.append(medConditionsGroup("Do you frequently experience any of the following:", medConditions3, request).toString());
		text.append(medConditionsGroup(null, medConditions4, request).toString());
		
		
		text.append("Are you currently taking any medications? If so please specify. <b>"+request.getParameter("takingMedications")+"</b><br/><br/>");
		text.append("Are you currently on a special diet? If yes, please explain. <b>"+request.getParameter("specialDiet")+"</b><br/><br/>");
		text.append("Do you have any physical condition, impairment or disability that might affect your ability to under take an exercise program? <b>"+request.getParameter("specialPhysicalConditions")+"</b><br/><br/>");
		text.append("What prompted you to pursue online training? <b>"+request.getParameter("whyOnlineTraining")+"</b><br/>");
		text.append("What do you value most about personal training? <b>"+request.getParameter("whatMotivatesAboutPersonalTraining")+"</b><br/>");
		text.append("What aspect of your health and well-being has improved the most from personal training? <b>"+request.getParameter("whatsImprovedMost")+"</b><br/><br/>");

		
		text.append("</blockquote>");


		final KqoolMessageBody message=new KqoolMessageBody(
			""+user.getFormattedNameAndUsername()+" completed "+(user.getGender()==User.MALE?"his":"her")+" personal-fitness profile.",
			text.toString(),
			request,
			siteId,
			controller
		);
		final InternetAddress[] toAddr=new InternetAddress[1];
		InternetAddress fromAddress=null;
		final String subjectText=siteProps.getDefaultMailSubjectAdminPrefix()+" User completed personal-fitness profile ("+user.getFormattedNameAndUsername()+")";
		try {
			try { 
				fromAddress=new InternetAddress(siteProps.getDefaultMailFrom(), siteProps.getDefaultMailFromLabel());
			}
			catch (final UnsupportedEncodingException e1) {}
			final List mappings=ClientToBackendUserMapping.getByClientUserId(user.getId());
			if (mappings==null || mappings.size()==0) {
				toAddr[0]=new InternetAddress(siteProps.getProprietorEmailAddress());
			}
			else {
				// for now, just using the first mapping; this is a little ugly...
				final ClientToBackendUserMapping mapping=(ClientToBackendUserMapping)mappings.get(0);
				final User trainer=User.getById(mapping.getBackendUserId());
				toAddr[0]=new InternetAddress(trainer.getEmailAddress());
			}
			

		}
		catch (final AddressException e) {
		}
		try {
			Mailer.send(
				true, 
				toAddr, 
				null, 
				null, 
				fromAddress, 
				subjectText, 
				message, 
				Mailer.MIME_TYPE_HTML, 
				null, 
				null, 
				siteProps,
				false
			);
		}
		catch (final AddressException e) {
			throw new FatalApplicationException(e);
		}
		catch (final Exception e) {
			throw new FatalApplicationException(e);
		}		
	}

	
	
	
	public static void sendInitialPfdResults(final User user, final PageContext pageContext, final Controller controller) throws NumberFormatException {
		final int siteId=user.getSiteId();
		final SiteProperties siteProps=new SiteProperties(siteId);
		final HttpServletRequest request=(HttpServletRequest)pageContext.getRequest();
		
		final StringBuilder text=new StringBuilder("You may view the client's completed fitness-data form <a href=\""+siteProps.getBaseSiteUrl()+"/kqadmin/user.jsp?siteId=1&id="+user.getId()+"&activeTab=pfd&"+Controller.FORCE_LOGOUT_PARAM+"=true\">here</a>.<br/>");

		final KqoolMessageBody message=new KqoolMessageBody(
			""+user.getFormattedNameAndUsername()+" completed a personal-fitness profile.",
			text.toString(),
			request,
			siteId,
			controller
		);
		final InternetAddress[] toAddr=new InternetAddress[1];
		InternetAddress fromAddress=null;
		final String subjectText=siteProps.getDefaultMailSubjectAdminPrefix()+" User completed personal-fitness profile ("+user.getFormattedNameAndUsername()+")";
		try {
			try { 
				fromAddress=new InternetAddress(siteProps.getDefaultMailFrom(), siteProps.getDefaultMailFromLabel());
			}
			catch (final UnsupportedEncodingException e1) {
			}
			final List mappings=ClientToBackendUserMapping.getByClientUserId(user.getId());
			if (mappings==null || mappings.size()==0) {
				toAddr[0]=new InternetAddress(siteProps.getProprietorEmailAddress());
			}
			else {
				// for now, just using the first mapping; this is a little ugly...
				final ClientToBackendUserMapping mapping=(ClientToBackendUserMapping)mappings.get(0);
				final User trainer=User.getById(mapping.getBackendUserId());
				toAddr[0]=new InternetAddress(trainer.getEmailAddress());
			}
			

		}
		catch (final AddressException e) {
		}
		try {
			Mailer.send(
				true,
				toAddr, 
				null, 
				null, 
				fromAddress, 
				subjectText, 
				message, 
				Mailer.MIME_TYPE_HTML, 
				null, 
				null, 
				siteProps,
				false
			);
		}
		catch (final AddressException e) {
			throw new FatalApplicationException(e);
		}
		catch (final Exception e) {
			throw new FatalApplicationException(e);
		}		
	}
	
	
	public static void sendChangedPfdResults(final User user, final Map<String,String> changedItemCodesToValues, final PageContext pageContext, final Controller controller) {
		final int siteId=user.getSiteId();
		final SiteProperties siteProps=new SiteProperties(siteId);
		final HttpServletRequest request=(HttpServletRequest)pageContext.getRequest();
		
		final StringBuilder text=new StringBuilder("The client made the following change"+(changedItemCodesToValues.size()>1?"s":"")+":");
		text.append("<blockquote>");
		final Iterator<String> keysIt=changedItemCodesToValues.keySet().iterator();
		String key;
		String value;
		String question;
		Map optionsItemValueLabelMap;
		while (keysIt.hasNext()) {
			key=keysIt.next();
			value=changedItemCodesToValues.get(key);
			// deal with height question special case:
			if (key=="heightFeet") {
				question="What is your height? (feet)";
			}
			else if (key=="heightInches") {
				question="What is your height? (inches)";
			}
			else {
				question=pfdProperties.getQuestion(key);
			}
			
			// fix make values human-readable where they're not (applies to everything but
			// textarea entries and weight):
			if (value!=null) {
				if (value.equals("true")) {
					value="Yes";
				}
				else if (value.equals("false")) {
					value="No";
				}
				else {
					optionsItemValueLabelMap=pfdProperties.getOptionsItemValueLabelMap(key);
					if (optionsItemValueLabelMap!=null) {
						final String temp=(String)optionsItemValueLabelMap.get(value);
						if (temp!=null) {
							value=temp;
						}
					}
				}
			}

			text.append("<b>"+question+"</b> "+value+"<br/>");
		}
		
		text.append("</blockquote>");
		text.append("You may view the client's current fitness-data profile <a href=\""+siteProps.getBaseSiteUrl()+"/kqadmin/user.jsp?siteId=1&id="+user.getId()+"&activeTab=pfd&"+Controller.FORCE_LOGOUT_PARAM+"=true\">here</a>.<br/>");

		final KqoolMessageBody message=new KqoolMessageBody(
			""+user.getFormattedNameAndUsername()+" completed a personal-fitness profile.",
			text.toString(),
			request,
			siteId,
			controller
		);
		final InternetAddress[] toAddr=new InternetAddress[1];
		InternetAddress fromAddress=null;
		final String subjectText=siteProps.getDefaultMailSubjectAdminPrefix()+" Client made changes to their personal-fitness profile ("+user.getFormattedNameAndUsername()+")";
		try {
			try { 
				fromAddress=new InternetAddress(siteProps.getDefaultMailFrom(), siteProps.getDefaultMailFromLabel());
			}
			catch (final UnsupportedEncodingException e1) {}
			final List mappings=ClientToBackendUserMapping.getByClientUserId(user.getId());
			if (mappings==null || mappings.size()==0) {
				toAddr[0]=new InternetAddress(siteProps.getProprietorEmailAddress());
			}
			else {
				// for now, just using the first mapping; this is a little ugly...
				final ClientToBackendUserMapping mapping=(ClientToBackendUserMapping)mappings.get(0);
				final User trainer=User.getById(mapping.getBackendUserId());
				toAddr[0]=new InternetAddress(trainer.getEmailAddress());
			}
			

		}
		catch (final AddressException e) {
		}
		try {
			Mailer.send(
				true,
				toAddr, 
				null, 
				null, 
				fromAddress, 
				subjectText, 
				message, 
				Mailer.MIME_TYPE_HTML, 
				null, 
				null, 
				siteProps,
				false
			);
		}
		catch (final AddressException e) {
			throw new FatalApplicationException(e);
		}
		catch (final Exception e) {
			throw new FatalApplicationException(e);
		}		
	}

	
	public static void sendFeedbackMessage(final User user, final String fullname, final String emailAddress, final String username, final String queryType, final String comments, final String browserInfo, final PageContext pageContext, final Controller controller) throws NumberFormatException {
		final int siteId=(user==null?controller.getSiteIdInt():user.getSiteId());
		final SiteProperties siteProps=new SiteProperties(siteId);
		final HttpServletRequest request=(HttpServletRequest)pageContext.getRequest();
		final boolean  isUser=user!=null;
		final String messageText=(comments.trim().length()==0?"<i>(No message entered.)</i>":"<tt style=\"font-size:12px;\">"+comments+"</tt>");
		final StringBuffer text=new StringBuffer("<blockquote>"+messageText+"</blockquote><br/><br/>");
		if (isUser) {
			text.append("The sender was logged in as a user; user details are as follows:<blockquote>");
			text.append("<b>Full name: </b>"+user.getFirstName()+" "+user.getLastName()+"<br/>");
			text.append("<b>Username: </b>"+user.getUsername()+"<br/>");
			text.append("<b>Email address: </b>"+anchor("mailto:"+user.getEmailAddress(),user.getEmailAddress(), controller)+"<br/>");
			text.append("<b>Join date: </b>"+DateFormat.getDateInstance(DateFormat.MEDIUM).format(user.getJoinDate())+"<br/>");
			String status;
			switch  (user.getStatus()) {
				case User.STATUS_PREACTIVE: status="preactive"; break;
				case User.STATUS_ACTIVE: status="active"; break;
				case User.STATUS_SUSPENDED: status="suspended"; break;
				case User.STATUS_DEACTIVATED: status="deactivated"; break;
				default: status="unknown";
			}
			text.append("<b>Status: </b>"+status+"<br/>");
			text.append("</blockquote>");
			text.append("The user also entered this information, which may or may not match the details above:<br/><br/>");

		
		}

		text.append("<b>Full name: </b>"+fullname+"<br/>");
		text.append("<b>Username: </b>"+username+"<br/>");
		text.append("<b>Email address: </b>"+anchor("mailto:"+emailAddress, emailAddress, controller)+"<br/><br/>");
		text.append("<b>Comment type: </b>"+queryType+"<br/>");
		text.append("<b>Browser info: </b>"+browserInfo+"<br/>");

		final Site site=Site.getById(siteId);
		final KqoolMessageBody message=new KqoolMessageBody(
			(isUser?fullname+" (a registered user) sent the following message from kqool.com ("+site.getLabel()+"):":fullname+" (a non-logged-in visitor) sent the following message from the site:"),
			text.toString(),
			request,
			siteId,
			controller
		);
		final InternetAddress[] toAddr=new InternetAddress[1];
		InternetAddress fromAddress=null;
		
		final boolean messageToTrainer=(queryType.indexOf("backendUser_")>-1);
		
		String subjectText;
		if (!messageToTrainer) {
			subjectText=siteProps.getDefaultMailSubjectAdminPrefix()+" Message from site visitor ("+queryType+")";
		}
		else {
			subjectText=siteProps.getDefaultMailSubjectAdminPrefix()+" Message from client";
		}
		
		try {
			try { 
				fromAddress=new InternetAddress(siteProps.getDefaultMailFrom(), siteProps.getDefaultMailFromLabel());
			}
			catch (final UnsupportedEncodingException e1) {}
			if (!messageToTrainer) {
				toAddr[0]=new InternetAddress(siteProps.getProprietorEmailAddress());
			}
			else {
				// queryType has format backendUser_xxx if messageToTrainer is true, where xxx is the trainer's user ID:
				final String[] qtSplit=queryType.split("_");
				toAddr[0]=new InternetAddress(User.getById(Integer.parseInt(qtSplit[1])).getEmailAddress());
			}

		}
		catch (final AddressException e) {
		}
		try {
			Mailer.send(
				true,
				toAddr, 
				null, 
				null, 
				fromAddress, 
				subjectText, 
				message, 
				Mailer.MIME_TYPE_HTML, 
				null, 
				null, 
				siteProps,
				false
			);
		}
		catch (final AddressException e) {
			throw new FatalApplicationException(e);
		}
		catch (final Exception e) {
			throw new FatalApplicationException(e);
		}		
	}

	
	
	public static void sendInitialUserContactNotification(final User user, final String comments, final PageContext pageContext, final Controller controller)  {
		final int siteId=user.getSiteId();
		final SiteProperties siteProps=new SiteProperties(siteId);
		final HttpServletRequest request=(HttpServletRequest)pageContext.getRequest();
		final String createAccountLink=siteProps.getBaseSiteUrl()+"/kqadmin/addUsers.jsp?single=true&siteId="+user.getSiteId()
			+"&firstName="+URLEncoder.encode(user.getFirstName())
			+"&lastName="+URLEncoder.encode(user.getLastName())
			+"&emailAddress="+URLEncoder.encode(user.getEmailAddress())
			+"&username="+URLEncoder.encode(user.getUsername())	
			+"&"+Controller.FORCE_LOGOUT_PARAM+"=true"
		;
		final Site site=Site.getById(siteId);
		final StringBuffer text=new StringBuffer(""+(user.getGender()==User.MALE?"He":"She")+" supplied the following details:<br/><br/>");
		text.append("<b>Sign-up time: </b>"+DateFormat.getDateTimeInstance().format(new Date())+"<br/>");
		text.append("<b>First name: </b>"+user.getFirstName()+"<br/>");
		text.append("<b>Last name: </b>"+user.getLastName()+"<br/>");
		text.append("<b>Username: </b>"+user.getUsername()+"<br/>");
		text.append("<b>Email address: </b>"+user.getLinkedEmailAddress(siteId)+"<br/>");
		text.append("<b>Site: </b>"+site.getLabel()+"<br/><br/>");
		if (comments!=null && comments.trim().length()>0) {
			text.append(""+user.getFirstName()+" also included the following comment:<blockquote><tt style=\"font-size:12px;\">"+comments+"</tt></blockquote>");
		}
		text.append("Please press the \"continue\" button below to continue.<br/><br/><br/>");
		text.append("<a href=\""+createAccountLink+"\" target=_blank>"+mailButton("buttonContinue.gif", request, controller)+"</a><br/><br/>");

		final KqoolMessageBody message=new KqoolMessageBody(
			"A new user has signed up on "+site.getLabel()+".",
			text.toString(),
			request,
			siteId,
			controller
		);
		final InternetAddress[] toAddr=new InternetAddress[1];
		InternetAddress fromAddress=null;
		final String subjectText=siteProps.getDefaultMailSubjectAdminPrefix()+" New user signed up on "+site.getLabel()+" ("+user.getFormattedNameAndUsername()+")";
		try {
			try { 
				fromAddress=new InternetAddress(siteProps.getDefaultMailFrom(), siteProps.getDefaultMailFromLabel());
			}
			catch (final UnsupportedEncodingException e1) {}
			final User toUser=User.getById(site.getPrimaryContactUserId());
			toAddr[0]=new InternetAddress(toUser==null?siteProps.getProprietorEmailAddress():toUser.getEmailAddress());

		}
		catch (final AddressException e) {
		}
		try {
			Mailer.send(
				true,
				toAddr, 
				null, 
				null, 
				fromAddress, 
				subjectText, 
				message, 
				Mailer.MIME_TYPE_HTML, 
				null, 
				null, 
				siteProps,
				false
			);
		}
		catch (final AddressException e) {
			throw new FatalApplicationException(e);
		}
		catch (final Exception e) {
			throw new FatalApplicationException(e);
		}
		
	}


	public static void sendBackendUserCreationNotification(final User user, final boolean isActive, final PageContext pageContext, final Controller controller)  {
		final int siteId=user.getSiteId();
		final Site site=Site.getById(siteId);
		final SiteProperties siteProps=new SiteProperties(siteId);

		final HttpServletRequest request=(HttpServletRequest)pageContext.getRequest();
		final StringBuffer text=new StringBuffer();
		final String tagline="You are now a "+(user.getBackendUserType()==User.BACKENDUSER_TYPE_TRAINER?"trainer":"site admin")+" at "+site.getLabel()+"!";
		final String itemName=siteProps.getPaypalStandardMonthlySubscriptionItemName();
		final String itemNumber=siteProps.getPaypalStandardMonthlySubscriptionItemNumber();

		final String controlPanelLink=siteProps.getBaseSiteUrl()+"/kqadmin/menu.jsp?siteId="+user.getSiteId()+"&"+Controller.FORCE_LOGOUT_PARAM+"=true";
		
		final String subjectText=siteProps.getDefaultMailSubjectAdminPrefix()+" "+tagline;
		text.append("Your username is \""+user.getUsername()+"\".  To access the \"control panel\" (the area of the site where you will manage your clients"+(user.getBackendUserType()==User.BACKENDUSER_TYPE_TRAINER?"":" and trainers")+"), please go here (you will want to bookmark this link):<blockquote><a href=\""+controlPanelLink+"\">"+controlPanelLink+"</a></blockquote>Note: you will not need a password the first time you log in; you will choose one after logging in for the first time.<br/><br/>");
		


		final KqoolMessageBody message=new KqoolMessageBody(
			tagline,
			text.toString(),
			request,
			siteId,
			controller
		);
		final InternetAddress[] toAddr=new InternetAddress[1];
		InternetAddress fromAddress=null;
		
		try {
			try {
				fromAddress=new InternetAddress(siteProps.getDefaultMailFrom(), siteProps.getDefaultMailFromLabel());
			}
			catch (final UnsupportedEncodingException e1) {}
			toAddr[0]=new InternetAddress(user.getEmailAddress());

		}
		catch (final AddressException e) {
		}
		try {
			//Mailer.sendWithoutWaiting(
			Mailer.send(
				true,
				toAddr, 
				null, 
				null, 
				fromAddress, 
				subjectText, 
				message, 
				Mailer.MIME_TYPE_HTML, 
				null, 
				null, 
				siteProps
			);
		}
		catch (final AddressException e) {
			throw new FatalApplicationException(e);
		}
		catch (final Exception e) {
			throw new FatalApplicationException(e);
		}

	
	}

	public static void sendCreationNotification(final User user, final boolean isActive, final PageContext pageContext, final Controller controller)  {
		final int siteId=user.getSiteId();
		final Site site=Site.getById(siteId);
		final SiteProperties siteProps=new SiteProperties(siteId);
		if (isActive) {
			sendActivationNotification(user, User.STATUS_PREACTIVE, pageContext, controller);
		}
		else {
			final HttpServletRequest request=(HttpServletRequest)pageContext.getRequest();
			final StringBuffer text=new StringBuffer();
			final String tagline="Welcome to "+site.getLabel()+", "+user.getFirstName()+"!";
			final String itemName=siteProps.getPaypalStandardMonthlySubscriptionItemName();
			final String itemNumber=siteProps.getPaypalStandardMonthlySubscriptionItemNumber();

			final String subjectText=siteProps.getDefaultMailSubjectPrefix()+" Welcome to "+site.getLabel()+", "+user.getFirstName()+".";
			text.append("Thank you for joining "+site.getLabel()+"! Your account has been created under the username \""+user.getUsername()+"\" but it is not yet active.  ");
			text.append("You see, \""+user.getUsername()+",\" we have not yet received notification from PayPal that you have scheduled monthly payments to "+site.getLabel()+". ");
			text.append("But we can work through this! Our relationship can, and <i>will</i>, prevail when you click on \"Pay with PayPal\" below! <b>Important: at the end of the payment process, you must click the \"Return To Merchant\" button to activate your account.</b>  Otherwise there will be further delays in processing your new membership.<br/><br/>");
			text.append("If you have, in fact, scheduled monthly PayPal payments, please send mail to "+anchor("mailto:"+siteProps.getCommentsEmailAddress(), siteProps.getCommentsEmailAddress(), controller)+".  Otherwise, hurry over to PayPal. Don't keep us apart any longer!<br/><br/>");
			
			final String payPalUrl=
				GeneralUtils.getBaseSiteUrl(request, siteId)+"/login/"
				+"paypalSubscriptionRedirector.jsp?itemName="
				+URLEncoder.encode(itemName)+"&itemNumber="
				+URLEncoder.encode(itemNumber)+"&username="
				+URLEncoder.encode(user.getUsername())
				+"&siteId="+user.getSiteId()
				+"&"+Controller.FORCE_LOGOUT_PARAM+"=true";
			;

			text.append(anchor(payPalUrl,mailButton("buttonPayWithPayPal.gif", request, controller)+"<br/>", controller));
			final KqoolMessageBody message=new KqoolMessageBody(
				tagline,
				text.toString(),
				request,
				siteId,
				controller
			);
			final InternetAddress[] toAddr=new InternetAddress[1];
			InternetAddress fromAddress=null;
			
			try {
				try {
					fromAddress=new InternetAddress(siteProps.getDefaultMailFrom(), siteProps.getDefaultMailFromLabel());
				}
				catch (final UnsupportedEncodingException e1) {}
				toAddr[0]=new InternetAddress(user.getEmailAddress());
	
			}
			catch (final AddressException e) {
			}
			try {
				//Mailer.sendWithoutWaiting(
				Mailer.send(
					true,
					toAddr, 
					null, 
					null, 
					fromAddress, 
					subjectText, 
					message, 
					Mailer.MIME_TYPE_HTML, 
					null, 
					null, 
					siteProps
				);
			}
			catch (final AddressException e) {
				throw new FatalApplicationException(e);
			}
			catch (final Exception e) {
				throw new FatalApplicationException(e);
			}
		}
		
		
	}
	
	private static String anchor(final String url, final String label, final Controller controller) throws NumberFormatException {
		final int siteId=Integer.parseInt(controller.getSiteId());
		final SiteProperties siteProps=new SiteProperties(siteId);
		return "<a style=\"color:#"+siteProps.getDefaultMailLinkColor()+"\" href=\""+url+"\" target=_blank>"+label+"</a>";
	}

	private static String anchor(final String url, final Controller controller) throws NumberFormatException {
		return anchor(url, url, controller);
	}
	
 
	public static String mailImage(final String src, final int height, final int width, final HttpServletRequest request, final Controller controller) throws NumberFormatException {
		int siteId;
		if (controller!=null) {
			siteId=Integer.parseInt(controller.getSiteId());
		}
		else {
			siteId=1;
		}
		final SiteProperties siteProps=new SiteProperties(siteId);


		return "<img src=\""+siteProps.getMailImagesDir()+src+"\" height=\""+height+"\" width=\""+width+"\" border=\"0\" />";
	} 
	
	private static String mailButton(final String src, final HttpServletRequest request, final Controller controller) throws NumberFormatException {
		return mailImage(src, 45, 167, request, controller);
	}


}
