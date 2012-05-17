package com.theavocadopapers.apps.kqool;

import java.io.IOException;
import java.util.List;

import javax.servlet.jsp.JspWriter;

import com.theavocadopapers.apps.kqool.entity.User;
import com.theavocadopapers.apps.kqool.entity.UserToWorkoutMapping;
import com.theavocadopapers.apps.kqool.entity.Workout;

public class TempUserWorkoutDemapper {



	public static void deMap(final JspWriter out) throws IOException {
		final List allUserWorkoutMappings=UserToWorkoutMapping.getAll();
		UserToWorkoutMapping mapping;
		Workout workout=null;
		User user=null;
		int userId;
		int workoutId;
		String msg=null;
		int userNull=0;
		int workoutNull=0;
		int nonNullUserId=0;
		int stored=0;
		for (int i=0; i<allUserWorkoutMappings.size(); i++) {
			mapping=(UserToWorkoutMapping)allUserWorkoutMappings.get(i);
			userId=mapping.getUserId();
			workoutId=mapping.getWorkoutId();
			try {
				workout=Workout.getById(workoutId);
			}
			catch (final Exception e) {}
			try {
				user=User.getById(userId);
			}
			catch (final Exception e) {}
			if (workout==null) {
				msg="Mapping of User with id "+userId+" to workout  with id "+workoutId+" skipped because Workout was null.";
				workoutNull++;
			}
			else if (user==null) {
				msg="Mapping of User with id "+userId+" to workout  with id "+workoutId+" skipped because User was null.";
				userNull++;
			}
			else if (workout.getUserId()>0) {
				msg="Mapping of User with id "+userId+" to workout  with id "+workoutId+" skipped because Workout already had a non-zero userId ("+workout.getUserId()+").";
				nonNullUserId++;
			}
			else {
				workout.setUserId(userId);
				workout.store();
				msg="Workout '"+workout.getName()+"' (id "+workout.getId()+") set to user '"+user.getUsername()+"' (id "+user.getId()+") and stored.";
				stored++;
			}
			System.out.println(msg);
			out.println(msg+"<br/>");
			out.flush();
		}
		msg=""+stored+" Workouts were stored with userIds; "+userNull+" were skipped because the User was null; "+workoutNull+" were skilled because the Workout was null; "+nonNullUserId+" were skipped because the Workout already had a non-zero userId.";
		System.out.println(msg);
		out.println(msg+"<br/>");
	}

}
