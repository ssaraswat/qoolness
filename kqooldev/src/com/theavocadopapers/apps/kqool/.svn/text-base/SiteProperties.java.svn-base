package com.theavocadopapers.apps.kqool;

import java.io.InputStream;
import java.util.HashMap;
import java.util.Properties;

public class SiteProperties {

	
	public static final String PROPERTIES_FILENAME_PREFIX="/site";
	
	protected static HashMap<Integer, Properties> allSiteProperties=new HashMap<Integer, Properties>(50);
	
	protected int siteId;
	
	public SiteProperties(final int siteId) {
		this.siteId=siteId;
		synchronized (allSiteProperties) {
			Properties siteProperties=allSiteProperties.get(new Integer(siteId));
			if (siteProperties==null) {
				InputStream is=null;
				final String propsFilename=PROPERTIES_FILENAME_PREFIX+siteId+".properties";
				try {
					siteProperties=new Properties();
					is=this.getClass().getResourceAsStream(propsFilename);
					siteProperties.load(is);
					allSiteProperties.put(new Integer(siteId), siteProperties);
				} 
				catch(final Exception e) {
					e.printStackTrace();
					throw new RuntimeException("Cannot load "+propsFilename+".");			
				}
				finally {
					try {
						is.close();
					}
					catch (final Exception e) {
						// ignore; either a harmless nullpointer or something we can't do anything about.
					}
				}
			}
		}
	}
	
	protected String getProperty(final String name) {
		return allSiteProperties.get(new Integer(this.siteId)).getProperty(name);
	}
	protected int getIntProperty(final String name) {
		return Integer.parseInt(getProperty(name));
	}
	protected boolean getBooleanProperty(final String name) {
		return Boolean.parseBoolean(getProperty(name));
	}
	protected double getDoubleProperty(final String name) {
		return Double.parseDouble(getProperty(name));
	}
	
	
	public boolean propertyExists(final String name) {
		return getProperty(name)!=null;
	}
	
	
	public String getDefaultMailFrom() {
		return getProperty("default.mail.from");
	}
	public String getDefaultMailFromLabel() {
		return getProperty("default.mail.from.label");
	}
	public String getSmtpHost() {
		return getProperty("smtp.host");
	}
	public String getSmtpPort() {
		return getProperty("smtp.port");
	}
	public String getSmtpUsername() {
		return getProperty("smtp.username");
	}
	public String getSmtpLocalhost() {
		return getProperty("smtp.localhost");
	}
	public String getSmtpPassword() {
		return getProperty("smtp.password");
	}
	
	public String getDefaultMailSubjectPrefix() {
		return getProperty("default.mail.subject.prefix");
	}
	public String getDefaultMailSubjectAdminPrefix() {
		return getProperty("default.mail.subject.admin.prefix");
	}
	public String getPaypalBusiness() {
		return getProperty("paypal.business");
	}
	public String getPaypalSubscriptionsUrlPrefix() {
		return getProperty("paypal.subscriptions.url.prefix");
	}
	public String getPaypalStandardMonthlySubscriptionItemNumber() {
		return getProperty("paypal.standard.monthly.subscription.item.number");
	}
	public String getPaypalStandardMonthlySubscriptionItemName() {
		return getProperty("paypal.standard.monthly.subscription.item.name");
	}
	public double getStandardMonthlyCost() {
		return getDoubleProperty("standard.monthly.cost");
	}
	public String getCommentsEmailAddress() {
		return getProperty("comments.email.address");
	}
	public String getProprietorEmailAddress() {
		return getProperty("proprietor.email.address");
	}
	public String getDeveloperEmailAddress() {
		return getProperty("developer.email.address");
	}
	public String getDeveloperName() {
		return getProperty("developer.name");
	}
	public String getCopyrightNoticeHtmlCode() {
		return getProperty("copyright.notice.html.hode");
	}
	public String getCopyrightNoticeTextCode() {
		return getProperty("copyright.notice.text.code");
	}
	public String getCopyrightNoticeWebDisplay() {
		return getProperty("copyright.notice.web.display");
	}
	public String getCopyrightNoticeEmailDisplay() {
		return getProperty("copyright.notice.email.display");
	}
	public String getSiteUrlForMailDisplay() {
		return getProperty("site.url.for.mail.display");
	}
	public String getBaseSiteUrl() {
		return getProperty("base.site.url");
	}
	public String getDefaultMailLinkColor() {
		return getProperty("default.mail.link.color");
	}
	public String[] getErrorPrefixes() {
		return getProperty("error.prefixes").split("~");
	}
	public String getMailImagesDir() {
		return getProperty("mail.images.dir");
	}
	public String getDefaultPageTitle() {
		return getProperty("default.page.title");
	}
	public String getDefaultPageTitleDialog() {
		return getProperty("default.page.title.dialog");
	}
	public String getDefaultEmailSigText() {
		return getProperty("default.email.sig.text");
	}
	public String getDefaultEmailSigHtml() {
		return getProperty("default.email.sig.html");
	}

}
