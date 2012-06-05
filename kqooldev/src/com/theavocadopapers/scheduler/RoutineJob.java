package com.theavocadopapers.scheduler;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.theavocadopapers.apps.kqool.control.Controller;
import com.theavocadopapers.apps.kqool.entity.User;
import com.theavocadopapers.apps.kqool.entity.Workout;
import com.theavocadopapers.apps.kqool.util.MailUtils;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.PageContext;


public class RoutineJob implements Job {
 
    public void execute(JobExecutionContext context) throws JobExecutionException {

    	Controller controller= null;
    	
    	//get all the workouts for the given date
    	List routines = Workout.getAllRoutinesForDate();
       	routines=(routines==null?new ArrayList():routines);
		final Iterator it=routines.iterator();
		Workout workout;
		User assignToUser=null;
		
		while (it.hasNext()) {
			workout=(Workout)it.next();
			
			assignToUser=User.getById(workout.getUserId());
			
			MailUtils.sendWorkoutAssignmentMail(assignToUser, workout, controller);
		
		}

    }
 
}