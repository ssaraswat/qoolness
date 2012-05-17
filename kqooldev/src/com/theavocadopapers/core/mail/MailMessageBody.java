/*
 * Created on Jan 2, 2005
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.core.mail;



/**
 * @author Steve Schneider
 *
 */
public class MailMessageBody {


	protected String head;
	protected String foot;
	protected String tagline;
	protected String text;

	/**
	 * @param head
	 * @param foot
	 * @param tagline
	 * @param text
	 */
	public MailMessageBody(String head, String foot, String tagline, String text) {
		super();
		this.head = head;
		this.tagline = tagline;
		this.text = text;
		this.foot = foot;
	}
	
	
	/**
	 * @param tagline
	 * @param text
	 */
	public MailMessageBody(String tagline, String text) {
		super();
		this.tagline = tagline;
		this.text = text;
	}
	/**
	 * @return Returns the foot.
	 */
	public String getFoot() {
		return foot;
	}
	/**
	 * @param foot The foot to set.
	 */
	public void setFoot(String foot) {
		this.foot = foot;
	}
	/**
	 * @return Returns the head.
	 */
	public String getHead() {
		return head;
	}
	/**
	 * @param head The head to set.
	 */
	public void setHead(String head) {
		this.head = head;
	}
	/**
	 * @return Returns the tagline.
	 */
	public String getTagline() {
		return tagline;
	}
	/**
	 * @param tagline The tagline to set.
	 */
	public void setTagline(String tagline) {
		this.tagline = tagline;
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
		StringBuffer b=new StringBuffer(head);
		b.append("<b>"+tagline+"</b><br/><br/>");
		b.append(text);
		b.append(foot);
		return b.toString();
	}


	
}
