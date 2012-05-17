/*
 * Created on Apr 12, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.exception;


/**
 * @author sschneider
 *
 */
public class FatalApplicationException extends RuntimeException {

	/**
	 * 
	 */
	public FatalApplicationException() {
		super();
	}

	/**
	 * @param message
	 */
	public FatalApplicationException(String message) {
		super(message);
	}

	/**
	 * @param cause
	 */
	public FatalApplicationException(Throwable cause) {
		super(cause);
	}

	/**
	 * @param message
	 * @param cause
	 */
	public FatalApplicationException(String message, Throwable cause) {
		super(message, cause);
	}

}
