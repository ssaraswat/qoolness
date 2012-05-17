package com.theavocadopapers.apps.kqool;

import java.util.Iterator;
import java.util.List;

import javax.servlet.jsp.JspWriter;

import com.theavocadopapers.apps.kqool.entity.ClientToBackendUserMapping;
import com.theavocadopapers.apps.kqool.entity.User;

public class TempClientToAndrewMapper {

	// same in dev as prod db:
	public static final int ANDREW_ID=6;
	
	public static void map(final JspWriter out) {
		final List allUsers=User.getAll();
		final Iterator i=allUsers.iterator();
		while (i.hasNext()) {
			final User user=(User) i.next();
			if (user.getUserType()==User.USER_TYPE_BACKENDUSER) {
				System.out.println("Skipping user "+user.getUsername()+" because this user is a backend user");
				continue;
				// we're only mapping clients to Andrew here
			}
			System.out.println("Mapping user "+user.getUsername()+" (id="+user.getId()+") to user "+ANDREW_ID+" (Andrew's ID");
			final ClientToBackendUserMapping mapping=new ClientToBackendUserMapping(user.getId(), ANDREW_ID);
			mapping.store();
		}
	}

}
