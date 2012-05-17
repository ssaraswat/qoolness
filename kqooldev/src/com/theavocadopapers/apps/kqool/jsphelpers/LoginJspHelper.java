package com.theavocadopapers.apps.kqool.jsphelpers;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.Date;

import com.theavocadopapers.apps.kqool.control.Controller;
import com.theavocadopapers.apps.kqool.entity.ClientToBackendUserMapping;
import com.theavocadopapers.apps.kqool.entity.PreRegistrationUserData;
import com.theavocadopapers.apps.kqool.entity.Site;
import com.theavocadopapers.apps.kqool.entity.User;
import com.theavocadopapers.apps.kqool.util.GeneralUtils;

public class LoginJspHelper {

	
	
	
	public static void processPPReturn(final Controller controller) {
		// final String username=GeneralUtils.wDecrypt(controller.getParam("u"));
		String username=controller.getCookieValue("u");
		if (username!=null) {
			try {
				username=URLDecoder.decode(username, "UTF-8");
			}
			catch (final UnsupportedEncodingException e) {}
			username=GeneralUtils.wDecrypt(username);
		}
		
		final PreRegistrationUserData userData=PreRegistrationUserData.getByUsername(username);
	
		User user;
		if (User.exists(username)) {
			user=User.getByUsername(username);
			// userData will be null if user was created by admin (but in that case, fields already exist in User):
			if (userData!=null) {
				user.setFields(userData);
			}
			user.setStatus(User.STATUS_ACTIVE);
			user.setJoinDate(new Date());
			user.setUserType(User.USER_TYPE_USER);
			user.store();	
		}
		else {
			// userData should always be non-null in this case:

			if (userData!=null) {
				user=new User(userData);
			}
			else {
				user=new User();
			}
			user.setStatus(User.STATUS_ACTIVE);
			user.setJoinDate(new Date());
			user.setUserType(User.USER_TYPE_USER);
			user.store();
		}
		// add a mapping to the site's primary backend user:
		final Site site=Site.getById(controller.getSiteIdInt());
		final boolean mappingExists=ClientToBackendUserMapping.mappingExists(user.getId(), site.getPrimaryContactUserId());
		if (!mappingExists) {
			final ClientToBackendUserMapping mapping=new ClientToBackendUserMapping(user.getId(), site.getPrimaryContactUserId());
			mapping.store();
		}
	
		controller.getSessionInfo().setUser(user);
	
		try {
			userData.delete();
		}
		catch (final Exception e) {
		}
	}
}
