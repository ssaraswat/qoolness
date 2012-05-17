package com.theavocadopapers.apps.kqool;

import java.util.Iterator;
import java.util.List;

import javax.servlet.jsp.JspWriter;

import com.theavocadopapers.apps.kqool.entity.Workout;

public class TempWorkoutToAndrewMapper {

	// same in dev as prod db:
	public static final int ANDREW_ID=6;
	
	public static void map(final JspWriter out) {
		final List routines=Workout.getAllAdministratorAssigned();
		final Iterator i=routines.iterator();
		while (i.hasNext()) {
			final Workout workout=(Workout) i.next();
			if (workout.getAssigningBackendUserId()!=0) {
				System.out.println("Skipping routine "+workout.getName()+" because its assigningBackendUserId is not 0.");
				continue;
			}
			System.out.println("Setting assigningBackendUserId to "+ANDREW_ID+" for "+workout.getName());
			workout.setAssigningBackendUserId(ANDREW_ID);
			workout.store();
		}
	}
	


}
