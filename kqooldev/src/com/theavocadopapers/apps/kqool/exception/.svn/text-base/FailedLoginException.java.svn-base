/*
 * Created on Apr 13, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.exception;


/**
 * @author sschneider
 *
 */
public class FailedLoginException extends Exception {

	public static final int REASON_CODE_UNRECOGNIZED_USERNAME=1;
	public static final int REASON_CODE_USERNAME_PASSWORD_MISMATCH=2;
	public static final int REASON_CODE_PREACTIVE_USER=3;
	public static final int REASON_CODE_SUSPENDED_USER=4;
	public static final int REASON_CODE_DEACTIVATED_USER=5;
	public static final int REASON_CODE_FIRST_TIME_USER=6;
	public static final int REASON_CODE_OTHER=7;
	
	protected int reasonCode;
	

	public FailedLoginException(int reasonCode) {
		super();
		checkValidReasonCode(reasonCode);
		this.reasonCode=reasonCode;
	}

	
	public FailedLoginException(String message, int reasonCode) {
		super(message);
		checkValidReasonCode(reasonCode);
		this.reasonCode=reasonCode;
	}



	
	protected void checkValidReasonCode(int reasonCode) {
		if (reasonCode<1 || reasonCode>7) {
			throw new FatalApplicationException(new IllegalArgumentException("reasonCode must be one of the FailedLoginException.REASON_CODE_* values.  Passed value was "+reasonCode+"."));
		}
	}

	public int getReasonCode() {
		return reasonCode;
	}
	public void setReasonCode(int reasonCode) {
		this.reasonCode = reasonCode;
	}
}
