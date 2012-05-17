package com.theavocadopapers.apps.kqool.food;

import java.net.Authenticator;
import java.net.PasswordAuthentication;

public class HttpAuthenticator extends Authenticator {

	private static final char[] EMPTY_CHAR_ARRAY = {};
	
	private final String username;
	private final String password;
	
	public HttpAuthenticator(final String username, final String password) {
		this.username=username;
		this.password=password;
	}
	
	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		return new PasswordAuthentication(username, password==null?EMPTY_CHAR_ARRAY:password.toCharArray());
	}

	
}
