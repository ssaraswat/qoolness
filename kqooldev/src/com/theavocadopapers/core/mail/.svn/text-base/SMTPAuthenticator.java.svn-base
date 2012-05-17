/*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/

package com.theavocadopapers.core.mail;



import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class SMTPAuthenticator
extends Authenticator
implements com.theavocadopapers.apps.kqool.Constants
{

	private PasswordAuthentication passwordAuthentication;

	public SMTPAuthenticator(PasswordAuthentication passwordAuthentication)
	{
		this.passwordAuthentication=passwordAuthentication;
	}

	public PasswordAuthentication getPasswordAuthentication()
	{
		return passwordAuthentication;
	}




}