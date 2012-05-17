/*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/

package com.theavocadopapers.apps.kqool;

public class AppException
extends RuntimeException
implements com.theavocadopapers.apps.kqool.Constants
{ 


	String message;
	int code;

	public AppException()
	{
	}

	public AppException(final String message)
	{
		this.message=message;
	}

	public AppException(final String message, final int code)
	{
		this.message=message;
		this.code=code;
	}
	
	@Override
	public String getMessage()
	{
		return message;
	}
}