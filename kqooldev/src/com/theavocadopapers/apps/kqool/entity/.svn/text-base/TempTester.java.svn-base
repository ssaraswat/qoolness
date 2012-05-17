package com.theavocadopapers.apps.kqool.entity;

import java.util.Iterator;
import java.util.List;


public class TempTester {

	/**
	 * @param args
	 */
	public static void main(final String[] args) {
		if (false) {
			final List users=PreRegistrationUserData.getAll();
			final Iterator i=users.iterator();
			while (i.hasNext()) {
				final PreRegistrationUserData user=(PreRegistrationUserData) i.next();
				String email=user.getEmailAddress();
				if (email==null || email.trim().length()==0) {
					continue;
				}
				final String okchars="abcdefghijklmnopqrstuvwxyzANCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
				final StringBuilder b=new StringBuilder();
				for (int e=0; e<email.length(); e++) {
					final char c=email.charAt(e);
					if (okchars.indexOf(c)>=1) {
						b.append(c);
					}
				}
				email="scs-"+b.toString()+"@theavocadopapers.com";
				user.setEmailAddress(email);
				System.out.println(email);
				user.store();
			}
		}
	}

}
