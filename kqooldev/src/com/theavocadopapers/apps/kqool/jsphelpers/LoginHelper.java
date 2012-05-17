/*
 * Created on Dec 19, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.jsphelpers;

import java.util.Date;
import java.util.GregorianCalendar;

import javax.servlet.http.HttpServletRequest;

import com.theavocadopapers.apps.kqool.entity.Address;
import com.theavocadopapers.apps.kqool.entity.User;
import com.theavocadopapers.core.util.DatabaseEncryptionException;



public class LoginHelper {
	
	public static void popupateNewUserData(final HttpServletRequest request, final User user, final Address address) throws DatabaseEncryptionException {
		user.setFirstName(request.getParameter("firstName"));
		user.setLastName(request.getParameter("lastName"));
		user.setEmailAddress(request.getParameter("emailAddress"));
		user.setEmergencyContact(request.getParameter("emergencyContact"));
		user.setSecretQuestion(Integer.parseInt(request.getParameter("secretQuestion")));
		user.setSecretAnswer(request.getParameter("secretAnswer"));
		user.setLastAccessDate(new Date());
		user.setPassword(request.getParameter("password"));
		user.setStatus(User.STATUS_ACTIVE);
		user.setBirthDate(
			new GregorianCalendar(
					Integer.parseInt(request.getParameter("birthYear")),
					Integer.parseInt(request.getParameter("birthMonth")),
					Integer.parseInt(request.getParameter("birthDate"))
			).getTime()
		);
		address.setAddressLine1(request.getParameter("addressLine1"));
		address.setAddressLine2(request.getParameter("addressLine2"));
		address.setCity(request.getParameter("city"));
		address.setStateProvinceCode(request.getParameter("stateProvinceCode"));
		address.setPostalCode(request.getParameter("postalCode"));
		address.setCountryCode("US");
		address.setHomeTelephone(request.getParameter("homeTelephone"));
		address.setWorkTelephone(request.getParameter("workTelephone"));
		address.setMobileTelephone(request.getParameter("mobileTelephone"));
		address.setUserId(user.getId());
	}
	
}
