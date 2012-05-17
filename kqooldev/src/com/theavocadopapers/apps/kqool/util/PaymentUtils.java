/*
 * Created on Jan 4, 2005
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.util;

import java.text.NumberFormat;

import com.theavocadopapers.apps.kqool.SiteProperties;
import com.theavocadopapers.apps.kqool.control.Controller;
import com.theavocadopapers.core.util.URLEncoder;


/**
 * @author Steve Schneider
 *
 */
public class PaymentUtils {
 
	public static String getPayPalSubscriptionURL(final String itemName, final String itemNumber, final double monthlyCost, final String returnURL, final Controller controller) throws NumberFormatException {
		final int siteId=Integer.parseInt(controller.getSiteId());
		final SiteProperties siteProps=new SiteProperties(siteId);


		final NumberFormat fmt=NumberFormat.getInstance();
		fmt.setMinimumFractionDigits(2);
		fmt.setGroupingUsed(false);
		final StringBuffer url=new StringBuffer(siteProps.getPaypalSubscriptionsUrlPrefix());
		url.append("business="+URLEncoder.encode(siteProps.getPaypalBusiness())+"&");
		url.append("item_name="+URLEncoder.encode(itemName)+"&");
		url.append("item_number="+URLEncoder.encode(itemNumber)+"&");
		url.append("no_shipping=1&");
		url.append("return="+URLEncoder.encode(returnURL)+"&");
		url.append("no_note=1&");
		url.append("currency_code=USD&");
		url.append("a3="+URLEncoder.encode(fmt.format(monthlyCost))+"&");
		url.append("p3=1&t3=M&src=1&sra=1");
		return url.toString();
	}

}
