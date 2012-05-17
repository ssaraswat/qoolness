/*
 * Created on Jan 6, 2005
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.util;

import com.theavocadopapers.apps.kqool.entity.PreRegistrationUserData;
import com.theavocadopapers.apps.kqool.entity.User;


/**
 * @author Steve Schneider
 *
 */
public class UserUtils {

	
	public static boolean usernameInUse(final String username) {
		if (User.exists(username)) {
			return true;
		}
		if (PreRegistrationUserData.exists(username)) {
			return true;
		}
		return false;
	}
	
}
