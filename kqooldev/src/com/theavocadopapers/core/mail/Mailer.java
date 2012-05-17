/*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/

package com.theavocadopapers.core.mail;

import java.io.File;
import java.util.Properties;

import javax.mail.internet.InternetAddress;

import com.theavocadopapers.apps.kqool.SiteProperties;
import com.theavocadopapers.core.logging.Logger;


public class Mailer
implements com.theavocadopapers.apps.kqool.Constants
{

	private static final Logger logger = Logger.getLogger(Mailer.class);
	public static final int SUCCESS=0;
	public static final int FAILURE=1;

	// not currently used:
	public static final int INVALID_TEST_TO_ADDRESS=2;
	public static final int GENERIC_UNRECOVERABLE=3;
	public static final int TRANSPORT_SEND_EXCEPTION=4;
	
	public static final String MIME_TYPE_TEXT = "text/plain";
	public static final String MIME_TYPE_HTML = "text/html";


	public static boolean isJavaMailInstalled()
	{
		try
		{
			final Class testJavaMailClass=Class.forName("javax.mail.Transport");
			return true;
		}
		catch (final ClassNotFoundException cnfe)
		{
			logger.error("Exception caught in isJavaMailInstalled()",cnfe);
			return false;
		}
	}
	
	
	// not using these anymore because seeing exceptions in browser is more important than background sending --
	/*
	public static void sendWithoutWaiting(final String to, final String subject, final MailMessageBody body, final SiteProperties siteProps)
	throws Exception
	{
		send(new InternetAddress(to), subject, body, siteProps, false);
	}
	*/
	
	/*
	public static void sendWithoutWaiting(final InternetAddress[] to, final InternetAddress[] cc, final InternetAddress[] bcc, final InternetAddress from, final String subject, final MailMessageBody body, final String mimeType, final File[] attachments, final String[] attachmentMimeTypes, final SiteProperties siteProps)
	throws Exception
	{
		
		send(to, cc, bcc, from, subject, body, mimeType, attachments, attachmentMimeTypes, siteProps, false);
	}
	*/

	public static void send(final boolean doBccToDeveloper, final InternetAddress[] to, final InternetAddress[] cc, final InternetAddress[] bcc, final InternetAddress from, final String subject, final MailMessageBody body, final String mimeType, final File[] attachments, final String[] attachmentMimeTypes, final SiteProperties siteProps)
	throws Exception
	{
		
		send(doBccToDeveloper, to, cc, bcc, from, subject, body, mimeType, attachments, attachmentMimeTypes, siteProps, true);
	}


	public static void send(final boolean doBccToDeveloper, final String to, final String subject, final MailMessageBody body, final SiteProperties siteProps)
	throws Exception
	{
		send(doBccToDeveloper, new InternetAddress(to), subject, body, siteProps, true);
	}
	
	public static void send(final boolean doBccToDeveloper, final String to, final String subject, final MailMessageBody body, final SiteProperties siteProps, final boolean waitForThread)
	throws Exception
	{
		send(doBccToDeveloper, new InternetAddress(to), subject, body, siteProps, waitForThread);
	}
	
	public static void send(final boolean doBccToDeveloper, final InternetAddress to, final String subject, final MailMessageBody body, final SiteProperties siteProps, final boolean waitForThread)
	throws Exception
	{
		try {
			final InternetAddress[] toArray={to};
			final String fromAddress=(siteProps.getSmtpUsername()!=null && siteProps.getSmtpUsername().length()>0?siteProps.getSmtpUsername():"postmaster")+"@"+siteProps.getSmtpHost();
			send(doBccToDeveloper, toArray, null, null, new InternetAddress(fromAddress,"Message Dispatcher"), subject, body, MailerThread.MIME_TYPE_PLAIN, null, null, siteProps, waitForThread);		
		}
		catch (final Exception e) {
			logger.error("Excepton in send()", e);
		}
	}
	
	public static void send(final boolean doBccToDeveloper, final InternetAddress to, final InternetAddress from, final String subject, final MailMessageBody body, final SiteProperties siteProps, final boolean waitForThread)
	throws Exception
	{
		try {
			final InternetAddress[] toArray={to};
			send(doBccToDeveloper, toArray, null, null, from, subject, body, MailerThread.MIME_TYPE_PLAIN, null, null, siteProps, waitForThread);
		}
		catch (final Exception e) {
			logger.error("Excepton in send()", e);
		}

	}
	
	public static void send(final boolean doBccToDeveloper, final InternetAddress to, final InternetAddress from, final String subject, final MailMessageBody body, final String mimeType, final File[] attachments, final String[] attachmentMimeTypes, final SiteProperties siteProps, final boolean waitForThread)
	throws Exception
	{
		try {
			final InternetAddress[] toArray={to};
			send(doBccToDeveloper, toArray, null, null, from, subject, body, mimeType, attachments, attachmentMimeTypes, siteProps, waitForThread);
		}
		catch (final Exception e) {
			logger.error("Excepton in send()", e);
		}

	}
	
	public static void send(final boolean doBccToDeveloper, final InternetAddress[] to, final InternetAddress[] cc, final InternetAddress[] bcc, final InternetAddress from, final String subject, final MailMessageBody body, final String mimeType, final File[] attachments, final String[] attachmentMimeTypes, SiteProperties siteProps, final boolean waitForThread)
	throws Exception
	{
		
		try {
			final Properties p=new Properties();
			if (siteProps==null) {
				siteProps=new SiteProperties(1);
			}
			p.setProperty("mail.transport.protocol","smtp");
			p.setProperty("mail.smtp.host",siteProps.getSmtpHost());
			p.setProperty("mail.smtp.port",""+siteProps.getSmtpPort());
			if (siteProps.getSmtpUsername()!=null && siteProps.getSmtpUsername().length()>0)
			{
				p.setProperty("mail.smtp.user",siteProps.getSmtpUsername());
				p.setProperty("mail.smtp.auth","true"); 
			}
			else
			{
				p.setProperty("mail.smtp.auth","false"); 
			}
			if (siteProps.getSmtpLocalhost()!=null && siteProps.getSmtpLocalhost().length()>0)
			{
				p.setProperty("mail.smtp.localhost",siteProps.getSmtpLocalhost());
			}
			
			final String password=(siteProps.getSmtpPassword()!=null && siteProps.getSmtpPassword().length()>0?siteProps.getSmtpPassword():null);
			
			send(to, cc, bcc, from, subject, body, mimeType, attachments, attachmentMimeTypes, p, password, waitForThread);
			try {
				final MailMessageBody bccBody=new MailMessageBody(""+body.getTagline(), ""+body.getText());
				bccBody.setFoot(""+body.getFoot());
				bccBody.setHead(""+body.getHead());
	
				final String copyToDeveloperAddress=siteProps.getDeveloperEmailAddress();
				if (doBccToDeveloper && copyToDeveloperAddress!=null && copyToDeveloperAddress.trim().length()>0) {
					final InternetAddress[] toArray={new InternetAddress(copyToDeveloperAddress)};
					send(toArray, null, null, from, "[developer-bcc] "+subject, bccBody, mimeType, attachments, attachmentMimeTypes, p, ""+password, false);
				}
			}
			catch (final Throwable t) {
				logger.error("Excepton in send()", t);
			}
		}
		catch (final Exception e) {
			logger.error("Excepton in send()", e);
		}

	}
	
	public static void send(final InternetAddress[] to, final InternetAddress[] cc, final InternetAddress[] bcc, final InternetAddress from, final String subject, final MailMessageBody body, final String mimeType, final File[] attachments, final String[] attachmentMimeTypes, final Properties properties, final String password, final boolean waitForThread)
	throws Exception
	{
		try {
			final MailerThread thread=new MailerThread(to, cc, bcc, from, subject, body.toString(), mimeType, attachments, attachmentMimeTypes, properties, password);
			// start the thread:
			thread.start();
			if (waitForThread)
			{
				try
				{
					// wait for the thread to finish (if send() doesn't throw an Exception, this will be quick,
					// but if it fails, it will try several times:
					thread.join();
				}
				catch (final InterruptedException ie)
				{
					// this would be thrown if another thread interrupted this thread; won't happen but:
					logger.info("InterruptedException thrown by thread.join(): "+ie+": "+ie.getMessage()+"");
				}
			}
			final Exception thrownException=thread.getThrownException();
			if (thrownException!=null)
			{
				// this will return non-null if the thread wasn't able to send the message after several attempts:
				logger.info("send failed after several tries; the last Exception (about to re-throw) was "+thrownException+": "+thrownException.getMessage()+"");
				throw thrownException;
			}
			logger.info(">>>>>>>>>>>>>>>> send() succeeded.");
		}
		catch (final Exception e) {
			logger.error("Excepton in send()", e);
		}

	}
}