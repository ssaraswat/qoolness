/*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/

package com.theavocadopapers.apps.kqool.util;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

import com.theavocadopapers.apps.kqool.SiteProperties;
import com.theavocadopapers.apps.kqool.entity.CalorieWeek;
import com.theavocadopapers.apps.kqool.exception.FatalApplicationException;


public class GeneralUtils
implements com.theavocadopapers.apps.kqool.Constants
{
	private static final char[] KSQE1={'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','1','2','3','4','5','6','7','8','9','0','-','_','.',' ',};
	private static final char[] KSQE2={'D','M','_','d','e','k','l','2','t','u','v','T','U','K','L','P','7','r','s','O','E','F','S','Q','R','6','3','p','q','W','H','I','y','z','j','5','8','A','B','C','m','n','J','h','i','b','c','9','4','.','o','N','-','a','Z','1','X','Y','0','G','w','x','V','f',' ','g',};
	private static final String KSQE1S=new String(KSQE1);
	private static final String KSQE2S=new String(KSQE2);
	
	
	private static final int W_ENCRYPT_PADDING_FACTOR=5;


	static final int[] TIER_DIVISORS={0,211,212,213,214}; // tier 1, 2, 3, and 4 (ignore first element)
	
	static final int SALE_ID_PADDING=1029384;
	
	static final int RANDOM_MULTIPLIER=10;

	public static String getRequestURL(final HttpServletRequest request, final int siteId) {
		final SiteProperties siteProps=new SiteProperties(siteId);
		final StringBuffer b=new StringBuffer(siteProps.getBaseSiteUrl());
		b.append(removeCtxPath(request.getRequestURI(), request));
		if (request.getQueryString()!=null && request.getQueryString().trim().length()>0) {
			b.append("?"+request.getQueryString());
		}
	    return ""+b.toString();
	}

	private static Object removeCtxPath(final String requestURI,
			final HttpServletRequest request) {
		final String ctxPath=request.getContextPath();
		return requestURI.substring(ctxPath.length(), requestURI.length());
	}

	private static char randomChar()
	{
		final char[] key=(Math.random()>0.5?KSQE1:KSQE2);
		final double randomDouble=Math.random()*key.length;
		final int randomInt=(int)Math.floor(randomDouble);
		return key[randomInt];
	}
	
	private static int getIndexOf(final char[] chars, final char c)
	{
		for (int i=0; i<chars.length; i++)
		{
			if (chars[i]==c)
			{
				return i;
			}
		}
		return -1;
	}

	public static String wEncrypt(final String s)
	{
		final String unencrypted=""+s;
		final StringBuffer encrypted=new StringBuffer(unencrypted.length()*W_ENCRYPT_PADDING_FACTOR);
		for (int i=0; i<unencrypted.length(); i++) {
			for (int j=0; j<W_ENCRYPT_PADDING_FACTOR; j++) {
				if (j==0) {
					encrypted.append(wGetTwin(unencrypted.charAt(i), KSQE1S, KSQE2));
				}
				else {
					try {    
						encrypted.append(KSQE2[(int)Math.floor(Math.random()*KSQE2.length)]);
					}
					catch (final Exception e) {
						encrypted.append('n');
					}
				}
			}
		}
		return encrypted.toString();
	}

	/**
	 * @param c
	 * @param ksqe12
	 * @param ksqe22
	 * @return
	 */
	private static char wGetTwin(final char c, final String from, final char[] to) {
		for (int i=0; i<from.length(); i++) {
			if (from.charAt(i)==c) {
				return to[i];
			}
		}
		throw new FatalApplicationException("Invalid character '"+c+"'.");
	}

	public static final String wDecrypt(final String s)
	{
		final String encrypted=""+s;
		final StringBuffer unencrypted=new StringBuffer((encrypted.length()/W_ENCRYPT_PADDING_FACTOR));
		for (int i=0; i<encrypted.length(); i+=W_ENCRYPT_PADDING_FACTOR) {
			unencrypted.append(wGetTwin(encrypted.charAt(i), KSQE2S, KSQE1));
		}
		return unencrypted.toString();
	}


	
	public static boolean arrayContainsElement(final int[] array, final int value)
	{
		if (array==null)
		{
			return false;
		}
		for (int i=0; i<array.length; i++)
		{
			if (array[i]==value)
			{
				return true;
			}
		}
		return false;
	}





	public static int[] getIntArrayFromStringArray(final String[] stringArray)
	{
		if (stringArray==null)
		{
			return null;
		}
		final int[] intArray=new int[stringArray.length];
		for (int i=0; i<stringArray.length; i++)
		{
			intArray[i]=Integer.parseInt(stringArray[i]);
		}
		return intArray;
	}


	/**
	* Passed a String delimited by delimiter, returns a long[], or null if the String is null or nullstring
	*/
	public static long[] getLongArrayFromString(final String str, final String delimiter)
	{
		long[] longArray=null;
		if (str==null || str.length()==0)
		{
			return null;
		}

		final StringTokenizer tokenizer=new StringTokenizer(str,delimiter);
		final ArrayList list=new ArrayList(tokenizer.countTokens());
		while (tokenizer.hasMoreTokens())
		{
			list.add(tokenizer.nextToken());
		}
		longArray=new long[list.size()];
		for (int i=0; i<list.size(); i++)
		{
			longArray[i]=Long.parseLong((String)list.get(i));
		}
		return longArray;
	}
	/**
	* Passed a String delimited by DEFAULT_ARRAY_DELIMITER, returns a long[], or null if the String is null or nullstring
	*/
	public static long[] getLongArrayFromString(final String str)
	{
		return getLongArrayFromString(str, DEFAULT_ARRAY_DELIMITER);
	}


	/**
	* Passed a String delimited by delimiter, returns a String[], or null if the String is null or nullstring
	*/
	public static String[] getStringArrayFromString(final String str, final String delimiter)
	{
		String[] stringArray=null;
		if (str==null || str.length()==0)
		{
			return null;
		}
		final StringTokenizer tokenizer=new StringTokenizer(str,delimiter);
		final ArrayList list=new ArrayList(tokenizer.countTokens());
		while (tokenizer.hasMoreTokens())
		{
			list.add(tokenizer.nextToken());
		}
		stringArray=new String[list.size()];
		for (int i=0; i<list.size(); i++)
		{
			stringArray[i]=(String)list.get(i);
		}
		return stringArray;
	}
	/**
	* Passed a String delimited by DEFAULT_ARRAY_DELIMITER, returns a String[], or null if the String is null or nullstring
	*/
	public static String[] getStringArrayFromString(final String str)
	{
		return getStringArrayFromString(str, DEFAULT_ARRAY_DELIMITER);
	}




	/**
	* Passed a long[], returns a String delimited by delimiter, or nullstring if the long[] is null
	*/
	public static String getStringFromArray(final long[] array, final String delimiter)
	{
		if (array==null)
		{
			return "";
		}
		final StringBuffer retStr=new StringBuffer(array.length+array.length*7);
		for (int i=0; i<array.length; i++)
		{
			retStr.append(array[i]);
			if (i<array.length-1)
			{
				retStr.append(delimiter);
			}
		}
		return retStr.toString();
	}
	/**
	* Passed a long[], returns a String delimited by DEFAULT_ARRAY_DELIMITER, or nullstring if the long[] is null
	*/
	public static String getStringFromArray(final long[] array)
	{
		return getStringFromArray(array, DEFAULT_ARRAY_DELIMITER);
	}

	/**
	* Passed a String[], returns a String delimited by delimiter, or nullstring if the String[] is null
	*/
	public static String getStringFromArray(final String[] array, final String delimiter)
	{
		final StringBuffer retStr=new StringBuffer();
		if (array==null)
		{
			return "";
		}
		for (int i=0; i<array.length; i++)
		{
			retStr.append(array[i]);
			if (i<array.length-1)
			{
				retStr.append(delimiter);
			}
		}
		return retStr.toString();
	}
	/**
	* Passed a String[], returns a String delimited by DEFAULT_ARRAY_DELIMITER, or nullstring if the String[] is null
	*/
	public static String getStringFromArray(final String[] array)
	{
		return getStringFromArray(array, DEFAULT_ARRAY_DELIMITER);
	}



	public static String stringReplace(final String s, final String replaceStr, final String withStr)
	{
		if (s==null || replaceStr==null || withStr==null)
		{
			throw new IllegalArgumentException("in stringReplace(String,String,String), no params may be null.");
		}
		String ret=""+s;
		// Look for efficiencies:
		if (replaceStr.length()==1 && withStr.length()==1)
		{
			// very efficient:
			return s.replace(replaceStr.charAt(0),withStr.charAt(0));
		}
		if (replaceStr.length()==1)
		{
			// less efficient but still better than multi-multi:
			return stringReplace(s, replaceStr.charAt(0), withStr);
		}
		
		// least efficient:
		while (ret.indexOf(replaceStr)>-1)
		{
			ret=ret.substring(0,ret.indexOf(replaceStr))+withStr+ret.substring(ret.indexOf(replaceStr)+replaceStr.length(),ret.length());
		}
		return ret;
	}


	/**
	*  Passed String s, returns it with all instances of replaceChar replaced by withStr
	*/
	public static String stringReplace(final String s, final char replaceChar, final String withStr)
	{
		final StringBuffer buffer=new StringBuffer(s.length()*2);
		for (int i=0; i<s.length(); i++)
		{
			if (s.charAt(i)==replaceChar)
			{
				buffer.append(withStr);
			}
			else
			{
				buffer.append(s.charAt(i));
			}
		}
		return buffer.toString();
	}


	public static String nonNull(final String s)
	{
		return nonNull(s,"");
	}

	public static String nonNull(final String s, final String ifNullString)
	{
		return (s==null?ifNullString:s);
	}
	
	public static SimpleDateFormat getDateFormat(final int formatType, final boolean includeTime)
	{
		SimpleDateFormat ret=null;
		String timeStr="";
		if (includeTime)
		{
			timeStr=" HH:mm:ss";
		}
		if (formatType==DATE_FORMAT_MMDDYYYY_SLASHES)
		{
			ret=new SimpleDateFormat("MM/dd/yyyy"+timeStr);
		}
		if (formatType==DATE_FORMAT_MMDDYY_SLASHES)
		{
			ret=new SimpleDateFormat("MM/dd/yy"+timeStr);
		}
		if (formatType==DATE_FORMAT_YYYYMMDD_DASHES)
		{
			ret=new SimpleDateFormat("yyyy-MM-dd"+timeStr);
		}
		if (formatType==DATE_FORMAT_DDMMYYYY_SLASHES)
		{
			ret=new SimpleDateFormat("dd/MM/yyyy"+timeStr);
		}
		if (formatType==DATE_FORMAT_DDMMYY_SLASHES)
		{
			ret=new SimpleDateFormat("dd/MM/yy"+timeStr);
		}
		if (ret!=null)
		{
			if (formatType==DATE_FORMAT_MMDDYY_SLASHES || formatType==DATE_FORMAT_DDMMYY_SLASHES)
			{
				final Calendar cal=Calendar.getInstance();
				cal.set(Calendar.YEAR,1990);
				ret.set2DigitYearStart(cal.getTime());
			}
			return ret;
		}

		throw new IllegalArgumentException("formatType "+formatType+" is not valid; use one of the DATE_FORMAT_* constants in Constants.");
	}
	
	
	public static SimpleDateFormat getDateFormat(final int formatType)
	{
		return getDateFormat(formatType, false);
	}


	
	public static String getDateFormatLabel(final int formatType)
	{
		if (formatType==DATE_FORMAT_MMDDYYYY_SLASHES)
		{
			return "mm/dd/yyyy";
		}
		if (formatType==DATE_FORMAT_MMDDYY_SLASHES)
		{
			return "mm/dd/yy";
		}
		if (formatType==DATE_FORMAT_YYYYMMDD_DASHES)
		{
			return "yyyy-mm-dd";
		}
		if (formatType==DATE_FORMAT_DDMMYYYY_SLASHES)
		{
			return "dd/mm/yyyy";
		}
		if (formatType==DATE_FORMAT_DDMMYY_SLASHES)
		{
			return "dd/mm/yy";
		}
		throw new IllegalArgumentException("formatType "+formatType+" is not valid; use one of the DATE_FORMAT_* constants in Constants.");
	}
	
	
	public static int randomInt(final int minInclusive, final int maxInclusive)
	{
		final double randomNum=Math.random()*(maxInclusive-minInclusive);
		int randomInteger=(int)Math.round(randomNum);
		randomInteger+=(maxInclusive-minInclusive);
		return randomInteger;
	}
	
	private static String getQuotedPrintable(final String header, final String s)
	{
		if (s==null || header==null)
		{
			return "";
		}
		final StringBuffer buf=new StringBuffer();
		final int lineLength=74;
		String src=header+";ENCODING=QUOTED-PRINTABLE:"+s;
		src=stringReplace(src,"\r\n","\n"); // for pc
		src=src.replace('\r','\n'); // for mac
		src=src.replace('"',' ');
		src=src.replace('<',' ');
		src=src.replace('>',' ');
		String segment=null;
		while (src.length()>lineLength)
		{
			segment=src.substring(0,lineLength);
			segment=stringReplace(segment,"=","=3D");
			segment=stringReplace(segment,"ENCODING=3DQUOTED-PRINTABLE","ENCODING=QUOTED-PRINTABLE");
			segment=stringReplace(segment,"\n","=0D=0A");
			buf.append(segment+"=\r\n"); // crlf regardless of pc/mac/unix, per spec
			src=src.substring(lineLength,src.length());
		}
		segment=""+src;
		segment=stringReplace(segment,"=","=3D");
		segment=stringReplace(segment,"ENCODING=3DQUOTED-PRINTABLE","ENCODING=QUOTED-PRINTABLE");
		segment=stringReplace(segment,"\n","=0D=0A");	
		buf.append(segment);
		
		String ret=buf.toString();
		ret=stringReplace(ret,"ENCODING=3DQUOTED-PRINTABLE","ENCODING=QUOTED-PRINTABLE");
		return ret;
	}
	
	public static String getICalendarText(final String subjectText, final String bodyText, final Date dueDate, final String assignedByEmail, final int sequence, final String uid)
	{
		/* Format is as follows:
		BEGIN:VCALENDAR[cr/lf]
		PRODID:-//Kqool//com.theavocadopapers.apps.kqool.util.GeneralUtils//EN[cr/lf]
		VERSION:1.0[cr/lf]
		METHOD:PUBLISH[cr/lf]
		BEGIN:VEVENT[cr/lf]
		ORGANIZER:MAILTO:XXXAssignedby@xxx.xxx[cr/lf]
		DTSTART:yyyymmddThhmmss[cr/lf]
		DTEND:yyyymmddThhmmss[cr/lf]
		TRANSP:TRANSPARENT[cr/lf]
		SEQUENCE:0[cr/lf]
		UID:yyyymmddThhmmssZ-rrrrrr@host.com[cr/lf]
		DTSTAMP:yyyymmddThhmmss[cr/lf]
		DESCRIPTION;ENCODING=QUOTED-PRINTABLE:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=[cr/lf]
		xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=[cr/lf]
		xxxxxxxxxxxx[cr/lf]
		SUMMARY;ENCODING=QUOTED-PRINTABLE:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=[cr/lf]
		xxxxxxxxxxxxxx[cr/lf]
		PRIORITY:5[cr/lf]
		CLASS:PUBLIC[cr/lf]
		END:VEVENT[cr/lf]
		END:VCALENDAR[cr/lf]
		*/
		final StringBuffer buf=new StringBuffer(subjectText.length()*2);		
		
		final SimpleDateFormat fmt=new SimpleDateFormat("yyyyMMdd'T'HHmmss");
		final Calendar dueDateCal=Calendar.getInstance();
		dueDateCal.setTime(dueDate);
		dueDate.setTime(dueDate.getTime()-dueDateCal.get(Calendar.ZONE_OFFSET)-dueDateCal.get(Calendar.DST_OFFSET));
		final String dueDateTime=fmt.format(dueDate);
		final Date endDate=new Date(dueDate.getTime()+(1000l*60l*30l));
		final String endDateTime=fmt.format(endDate);
		final Date stamp=new Date();
		final Calendar stampCal=Calendar.getInstance();
		stampCal.setTime(stamp);
		stamp.setTime(stamp.getTime()-stampCal.get(Calendar.ZONE_OFFSET)-stampCal.get(Calendar.DST_OFFSET));
		final String dateStamp=fmt.format(stamp);

		buf.append("BEGIN:VCALENDAR\r\n");
		buf.append("PRODID:-//Kqool//com.theavocadopapers.apps.kqool.util.GeneralUtils//EN\r\n");
		buf.append("VERSION:1.0\r\n");
		buf.append("METHOD:PUBLISH\r\n");
		buf.append("BEGIN:VEVENT\r\n");
		buf.append("ORGANIZER:MAILTO:"+assignedByEmail+"\r\n");
		buf.append("DTSTART:"+dueDateTime+"Z\r\n");
		buf.append("DTEND:"+endDateTime+"Z\r\n");
		buf.append("TRANSP:TRANSPARENT\r\n");
		buf.append("SEQUENCE:"+sequence+"\r\n");
		buf.append("UID:"+uid+"\r\n");
		buf.append("DTSTAMP:"+dateStamp+"\r\n");
		buf.append(getQuotedPrintable("DESCRIPTION",bodyText)+"\r\n");
		buf.append(getQuotedPrintable("SUMMARY",subjectText)+"\r\n");
		buf.append("PRIORITY:5\r\n");
		buf.append("CLASS:PUBLIC\r\n");
		buf.append("END:VEVENT\r\n");
		buf.append("END:VCALENDAR\r\n");
		return buf.toString();
	}

    /**
     * @param request
     * @return
     */
    public static String getBaseSiteUrl(final HttpServletRequest request, final int siteId) {
        return new SiteProperties(siteId).getBaseSiteUrl();
    }
    /**
     * @param siteId
     * @return
     */
    public static String getBaseSiteUrl(final int siteId) {
        return new SiteProperties(siteId).getBaseSiteUrl();
    }
    public static Date getFirstDayOfWeekDate(final Date date) {
    	if (date==null) {
    		return null;
    	}
    	final Calendar cal=new GregorianCalendar();
    	cal.setTime(new Date(date.getTime()));
		while (cal.get(Calendar.DAY_OF_WEEK)!=CalorieWeek.FIRST_DAY_OF_WEEK_CALENDAR_CONSTANT) {
			cal.add(Calendar.DATE, -1);
		}
		return getZeroHoursDate(cal.getTime());
    } 
    
	public static Date getZeroHoursDate(final Date date) {
		if (date==null) {
			return null;
		}
		final GregorianCalendar cal=new GregorianCalendar();
		cal.setTime(new Date(date.getTime()));
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		cal.set(Calendar.AM_PM, Calendar.AM);
		return cal.getTime();
	}
}