/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import com.theavocadopapers.core.logging.Logger;


/**
 * @author sschneider
 *
 */
public class Article extends AbstractDbObject {



	private static final Class currentClass=Article.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);


	protected String title="";
	protected String author="";
	protected String text="";
	protected String keywords=""; // comma-delimited list
	protected String abstractText="";
	protected Date originalPublicationDate=new Date(0);
	protected Date sitePublicationDate=new Date(0);
	protected String copyrightNotice="";
	protected String externalUrl; // null means kqool-db article


	public static Article getById(final int id) {
		return (Article)getById(currentClass, id, true);
	}
	


	public boolean isExternalLink() {
		return (externalUrl!=null && externalUrl.trim().length()>0);
	}

	
	

	@Override
	protected Comparable getComparableValue() {
		return title;
	}












	public static Article getByTitle(final String title) {
		return (Article)getUniqueByField("title", title, FIELD_TYPE_TEXTUAL, currentClass, true);
	} 
	


	public String getTitle() {
		return title;
	}
	public void setTitle(final String title) {
		this.title = title;
	}


	public String getAbstractText() {
		return abstractText;
	}
	public void setAbstractText(final String abstractText) {
		this.abstractText = abstractText;
	}
	public String getAuthor() {
		return author;
	}
	public void setAuthor(final String author) {
		this.author = author;
	}
	public String getCopyrightNotice() {
		return copyrightNotice;
	}
	public void setCopyrightNotice(final String copyrightNotice) {
		this.copyrightNotice = copyrightNotice;
	}
	public List<String> getKeywordsList() {
		if (keywords==null || keywords.trim().length()==0) {
			return new ArrayList<String>(0);
		}
		if (keywords.indexOf(",")==-1) {
			final List<String> keywordsList=new ArrayList<String>(1);
			keywordsList.add(keywords.trim());
			return keywordsList;
		}
		// we have a comma-delimited list, so:
		return Arrays.asList(keywords.split(","));
	}
	public void setKeywordsList(final List<String> keywordsList) {
		final StringBuilder b=new StringBuilder();
		if (keywordsList!=null && keywordsList.size()>0) {
			final Iterator<String> i=keywordsList.iterator();
			boolean firstElement=true;
			while (i.hasNext()) {
				if (!firstElement) {
					b.append(",");
					firstElement=false;
				}
				b.append(i.next());
			}
		}
		setKeywords(b.toString());
	}
	
	public Date getOriginalPublicationDate() {
		return originalPublicationDate;
	}
	public void setOriginalPublicationDate(final Date originalPublicationDate) {
		this.originalPublicationDate = originalPublicationDate;
	}
	public Date getSitePublicationDate() {
		return sitePublicationDate;
	}
	public void setSitePublicationDate(final Date sitePublicationDate) {
		this.sitePublicationDate = sitePublicationDate;
	}
	public String getText() {
		return text;
	}
	public void setText(final String text) {
		this.text = text;
	}
	
	public static List getAll() {
		return getAll(currentClass);
	}

	
	/**
	 * @return Returns the externalUrl.
	 */
	public String getExternalUrl() {
		return externalUrl;
	}
	/**
	 * @param externalUrl The externalUrl to set.
	 */
	public void setExternalUrl(final String externalUrl) {
		this.externalUrl = externalUrl;
	}



	public String getKeywords() {
		return keywords;
	}



	public void setKeywords(final String keywords) {
		this.keywords = keywords;
	}
}
