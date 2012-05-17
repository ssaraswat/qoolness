package com.theavocadopapers.core.mail;

import java.io.File;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.activation.MimetypesFileTypeMap;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import com.theavocadopapers.core.logging.Logger;

public class MailerThread
extends Thread
{


	private static final Logger logger = Logger.getLogger(MailerThread.class);
	
	public static final String MIME_TYPE_PLAIN="text/plain";
	public static final String MIME_TYPE_HTML="text/html";

	public static final int MAX_SEND_ATTEMPTS=10;
	public static final int INTERVAL_BETWEEN_SEND_ATTEMPTS_MILLIS=1000;

	volatile boolean keepRunning=true;

	protected InternetAddress[] to;
	protected InternetAddress[] cc;
	protected InternetAddress[] bcc;
	protected InternetAddress from;
	protected String subject;
	protected String message;
	protected String mimeType;
	protected File[] attachments;
	protected String[] attachmentMimeTypes;
	protected Properties properties;
	protected String password;

	protected int sendAttempts=0;
	protected Exception thrownException=null;


	
	public MailerThread(final InternetAddress[] to, final InternetAddress[] cc, final InternetAddress[] bcc, final InternetAddress from, final String subject, final String message, final String mimeType, final File[] attachments, final String[] attachmentMimeTypes, final Properties properties, final String password)
	{
		setDaemon(true); // thread will die when app server is shut down
		this.to=to;
		this.cc=cc;
		this.bcc=bcc;
		this.from=from;
		this.subject=subject;
		this.message=message;
		this.mimeType=mimeType;
		this.attachments=attachments;
		this.attachmentMimeTypes=attachmentMimeTypes;
		this.properties=properties;
		this.password=password;
		String testMsg="****************************************** MailerThread created with the following members:\n";
		try {
			testMsg+="to="+to[0].getAddress()+";\n";
		}
		catch (final Exception e) {
		}
		try {
			testMsg+="cc="+cc[0].getAddress()+";\n";
		}
		catch (final Exception e) {
		}
		try {
			testMsg+="bcc="+bcc[0].getAddress()+";\n";
		}
		catch (final Exception e) {
		}
		try {
			testMsg+="from="+from.getAddress()+";\n";
		}
		catch (final Exception e) {
		}
		try {
			testMsg+="properties="+properties.toString()+";\n";
		}
		catch (final Exception e) {
		}
		
		//log(testMsg);
	}


	
	@Override
	public void run()
	{
		try {
			while(keepRunning && sendAttempts<MAX_SEND_ATTEMPTS)
			{
				try
				{
					logger.info("About to send() to '"+to+"' (attempt: "+sendAttempts+" of "+MAX_SEND_ATTEMPTS+")");
					send();
					thrownException=null;
					keepRunning=false;
				}
				catch (final Exception e)
				{
					thrownException=e;
					sendAttempts++;
					logger.info("Exception thrown by send() (attempt: "+sendAttempts+" of "+MAX_SEND_ATTEMPTS+"): "+e+": "+e.getMessage()+"");
				}
				if (keepRunning && sendAttempts<MAX_SEND_ATTEMPTS)
				{
					try
					{
						Thread.sleep(INTERVAL_BETWEEN_SEND_ATTEMPTS_MILLIS);
					}
					catch (final InterruptedException ie)
					{
					}
				}
			}
		}
		catch (final Exception e) {
			logger.error("Excepton in run()", e);
		}

	}

	public void pleaseStop()
	{
		keepRunning=false;
	}

	public void send()
	throws MessagingException
	{
		try {
			if (to==null || to.length==0)
			{
				throw new IllegalArgumentException("'to' cannot be neither null nor an empty array.");
			}
			if (from==null)
			{
				throw new IllegalArgumentException("'from' cannot be null.");
			}
			if (properties==null)
			{
				throw new NullPointerException("properties can't be null.");
			}
	
			if (mimeType==null || (!(mimeType.equals(MIME_TYPE_PLAIN)) && !(mimeType.equals(MIME_TYPE_HTML))))
			{
				throw new IllegalArgumentException("mimeType cannot be null and must equal Mailer.MIME_TYPE_PLAIN or Mailer.MIME_TYPE_HTML");
			}
			// get everything to non-null state (for arrays, empty arrays if null):
			if (cc==null)
			{
				cc=new InternetAddress[0];
			}
			if (bcc==null)
			{
				bcc=new InternetAddress[0];
			}
			if (subject==null)
			{
				subject="";
			}
			if (message==null)
			{
				message="";
			}
			if (attachments==null)
			{
				attachments=new File[0];
				attachmentMimeTypes=new String[0];
			}
	
			// All params are now not null; set up message:
	
			Session session=null;
			if (properties.getProperty("mail.smtp.user")!=null && properties.getProperty("mail.smtp.user").trim().length()>0)
			{
				final Authenticator authenticator=new SMTPAuthenticator(new PasswordAuthentication(properties.getProperty("mail.smtp.user"),password));
				logger.info("About to get session instance with Authenticator("+properties.getProperty("mail.smtp.user")+","+password+"); properties="+properties);
				session=Session.getInstance(properties, authenticator);
			}
			else
			{
				session=Session.getInstance(properties);
			}
	
	
	
			final MimeMessage mimeMessage=new MimeMessage(session);
	
			mimeMessage.setRecipients(Message.RecipientType.TO,to);
			if (cc.length>0)
			{
				mimeMessage.setRecipients(Message.RecipientType.CC, cc);
			}
			if (bcc.length>0)
			{
				mimeMessage.setRecipients(Message.RecipientType.BCC, bcc);
			}
	
	
	
			mimeMessage.setFrom(from);
	
			mimeMessage.setSubject(subject);
	
			if (attachments.length==0)
			{
				mimeMessage.setContent(message, mimeType);
			}
			else
			{
				final Multipart multipart=new MimeMultipart(); 
				final MimeBodyPart messagePart=new MimeBodyPart();
				try
				{
					messagePart.setContent(message,mimeType);
				}
				catch (final Exception e)
				{
					// send the message as text/plain regardless:
					messagePart.setText(message);
				}
				multipart.addBodyPart(messagePart);
				try
				{
					for (int i=0; i<attachments.length; i++)
					{
						final FileDataSource fileDataSource=new FileDataSource(attachments[i]);
						String ext=new String(attachments[i].getName());
						try
						{
							ext=ext.substring(ext.lastIndexOf(".")+1,ext.length());
						}
						catch (final Exception e)
						{
							throw new IllegalArgumentException("All attachments must have filename extenseions (e.g. \"xxx.gif\")");
						}
						final MimetypesFileTypeMap fileTypeMap=new MimetypesFileTypeMap();
						fileTypeMap.addMimeTypes(attachmentMimeTypes[i]+" "+ext);
						fileDataSource.setFileTypeMap(fileTypeMap);
						final MimeBodyPart attachmentPart=new MimeBodyPart();
						attachmentPart.setDataHandler(new DataHandler(fileDataSource));
						attachmentPart.setFileName("wrissue.vcs");
						multipart.addBodyPart(attachmentPart);
					}
				}
				catch (final Exception e) 
				{
					logger.info("Setting up multipart: "+e+": "+e.getMessage());
				}
				mimeMessage.setContent(multipart);
			}
	
			// send the message:
	
			logger.info("About to Transport.send():\nfrom: "+mimeMessage.getFrom()[0]+"\nto (first addr): "+mimeMessage.getRecipients(Message.RecipientType.TO)[0]+"\n");
			Transport.send(mimeMessage);
		}
		catch (final Exception e) {
			logger.error("Excepton in send()", e);
		}


	}


	public Exception getThrownException()
	{
		return thrownException;
	}


}