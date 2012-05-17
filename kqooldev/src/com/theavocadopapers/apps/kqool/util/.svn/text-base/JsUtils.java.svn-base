/*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/

package com.theavocadopapers.apps.kqool.util;

import java.util.List;

public class JsUtils
implements com.theavocadopapers.apps.kqool.Constants
{


	/**
	*  Returns a JS array of quoted strings with quotes within the strings escaped as needed (or "null" if passed array is null)
	*/
	public static String getJsArray(final String[] array)
	{
		if (array==null)
		{
			return "null";
		}
		final StringBuffer sb=new StringBuffer("[");
		for (int i=0; i<array.length; i++)
		{
			if (i>0)
			{
				sb.append(",");
			}
			if (array[i]==null)
			{
				sb.append("null");
			}
			else
			{
				sb.append("\"");
				sb.append(escapeQuotes(array[i]));
				sb.append("\"");
			}
		}
		sb.append("]");
		return sb.toString();
	}

	/**
	*  Returns a JS array of List elements' toString() values, quoted or not depending on value of quoteElements (or "null" if passed array is null)
	*/
	public static String getJsArray(final List list, final boolean quoteElements)
	{
		if (list==null)
		{
			return "null";
		}
		final StringBuffer sb=new StringBuffer("[");
		for (int i=0; i<list.size(); i++)
		{
			if (i>0)
			{
				sb.append(",");
			}
			if (list.get(i)==null)
			{
				sb.append("null");
			}
			else
			{
				sb.append(quoteElements?"\"":"");
				sb.append(escapeQuotes(list.get(i).toString()));
				sb.append(quoteElements?"\"":"");
			}
		}
		sb.append("]");
		return sb.toString();
	}


	/**
	*  Returns a JS array of numbers from an int[] (or "null" if passed array is null)
	*/
	public static String getJsArray(final int[] array)
	{
		if (array==null)
		{
			return "null";
		}
		final StringBuffer sb=new StringBuffer("[");
		for (int i=0; i<array.length; i++)
		{
			if (i>0)
			{
				sb.append(",");
			}
			sb.append(array[i]);
		}
		sb.append("]");
		return sb.toString();
	}

	/**
	*  Returns a JS array of numbers from a long[] (or "null" if passed array is null)
	*/
	public static String getJsArray(final long[] array)
	{
		if (array==null)
		{
			return "null";
		}
		final StringBuffer sb=new StringBuffer("[");
		for (int i=0; i<array.length; i++)
		{
			if (i>0)
			{
				sb.append(",");
			}
			sb.append(array[i]);
		}
		sb.append("]");
		return sb.toString();
	}


	/**
	*  Returns a JS array of booleans from a boolean[] (or "null" if passed array is null)
	*/
	public static String getJsArray(final boolean[] array)
	{
		if (array==null)
		{
			return "null";
		}
		final StringBuffer sb=new StringBuffer("[");
		for (int i=0; i<array.length; i++)
		{
			if (i>0)
			{
				sb.append(",");
			}
			sb.append(array[i]);
		}
		sb.append("]");
		return sb.toString();
	}


	/**
	*  Returns s with the following escapes: "=\", '=\', \=\\
	*/
	public static String escapeQuotes(final String str)
	{
		if (str==null)
		{
			return "";
		}
		String s=new String(str);
		s=GeneralUtils.stringReplace(s,BACKSLASH_CHAR,"\\\\");
		s=GeneralUtils.stringReplace(s,DOUBLE_QUOTE_CHAR,BACKSLASH_CHAR+""+DOUBLE_QUOTE_CHAR);
		s=GeneralUtils.stringReplace(s,SINGLE_QUOTE_CHAR,BACKSLASH_CHAR+""+SINGLE_QUOTE_CHAR);


		return s;
	}


	// returns the string in double quotes, with quotes in the string escaped if needed, or the string "null" if the passed string is null.
	public static String quotedString(final String s)
	{
		if (s==null)
		{
			return "null";
		}
		return "\""+escapeQuotes(s)+"\"";
	}









}