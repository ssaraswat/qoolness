/*
 * Created on Jan 2, 2005
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.util;

import javax.servlet.http.HttpServletRequest;

import com.theavocadopapers.apps.kqool.SiteProperties;
import com.theavocadopapers.apps.kqool.control.Controller;
import com.theavocadopapers.core.mail.MailMessageBody;


/**
 * @author Steve Schneider
 *
 */
public class KqoolMessageBody extends MailMessageBody {




	
	public KqoolMessageBody(final String tagline, final String text, final HttpServletRequest request, final int siteId, final Controller controller) throws NumberFormatException {
		super("<table cellspacing=0 cellpadding=0 border=0 width=600>"+
			"<tr><td colspan=2><a href="+GeneralUtils.getBaseSiteUrl(request, siteId)+" target=_blank>"+
			MailUtils.mailImage("header.gif", 164, 340, request, controller)+"</a><br/></td></tr>"+
			"<tr><td nowrap width=10>&nbsp;<br/></td><td>"+
			"<font size=2 face=arial,helvetica style=\"font-family:arial,helvetica; size:11px;\"><br/>",				
			new SiteProperties(siteId).getDefaultEmailSigHtml()+
			"</font>"+
			MailUtils.mailImage("spacer_gray.gif", 1, 340, request, controller)+
			"</td></tr>"+
			"<tr><td nowrap width=10>&nbsp;<br/></td>"+
			"<td nowrap width=590>&nbsp;<br/></td></tr>"+
			"</table>", 
			tagline, 
			text
		);
	}
	public KqoolMessageBody(final String head, final String foot, final String tagline, final String text) {
		super(head, foot, tagline, text);
	}
}
