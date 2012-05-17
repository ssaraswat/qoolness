/*
 * Created on Jan 2, 2005
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.core.mail;



/**
 * @author Steve Schneider
 *
 */
public class SimpleMailMessageBody extends MailMessageBody {



	/**
	 * @param head
	 * @param foot
	 * @param tagline
	 * @param text
	 */
	public SimpleMailMessageBody(String text) {
		super("", "", "", text);
	}
	

	/**
	 * @return Returns the text.
	 */
	public String getText() {
		return text;
	}
	/**
	 * @param text The text to set.
	 */
	public void setText(String text) {
		this.text = text;
	}
	
	public String toString() {
		return text;
	}


	
}
