package com.theavocadopapers.hibernate;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.theavocadopapers.apps.kqool.entity.AbstractDbObject;
import com.theavocadopapers.apps.kqool.entity.Address;
import com.theavocadopapers.apps.kqool.entity.Article;
import com.theavocadopapers.apps.kqool.entity.CalorieExpendingActivity;
import com.theavocadopapers.apps.kqool.entity.ClientToBackendUserMapping;
import com.theavocadopapers.apps.kqool.entity.Exercise;
import com.theavocadopapers.apps.kqool.entity.ExerciseVideo;
import com.theavocadopapers.apps.kqool.entity.PreRegistrationUserData;
import com.theavocadopapers.apps.kqool.entity.Site;
import com.theavocadopapers.apps.kqool.entity.User;
import com.theavocadopapers.core.logging.Logger;

public class HibernateAppListener implements ServletContextListener	{

	private static final Logger logger = Logger.getLogger(HibernateAppListener.class);
	private static final String UTIL_CLASS="com.theavocadopapers.hibernate.HibernateUtil";
	
	// ugly that this is hard-coded, but fuck it:
	private static final String DRIVER_CLASS="com.mysql.jdbc.Driver";
	
	/* Application Startup Event */
	public void	contextInitialized(final ServletContextEvent ce) {

		logger.info("Container is loading the application context");
		try  {
			Class.forName(DRIVER_CLASS);
			logger.info("Load "+DRIVER_CLASS+" successful");
		}
		catch (final Exception e)  {
			logger.fatal("Load "+DRIVER_CLASS+" threw Exception; this is fatal.");
		}
		try  {
			Class.forName(UTIL_CLASS).newInstance();
			logger.info("Load "+UTIL_CLASS+" successful");
		}
		catch (final Exception e)  {
			logger.fatal("Load "+UTIL_CLASS+" threw Exception; this is fatal.");
		}
		// Load all cacheable objects:
		Address.getAll();
		Article.getAll();
		CalorieExpendingActivity.getAll();
		ClientToBackendUserMapping.getAll();
		Exercise.getAll();
		ExerciseVideo.getAll();
		PreRegistrationUserData.getAll();
		Site.getAll();
		User.getAll();

	}

	/* Application Shutdown	Event */
	public void	contextDestroyed(final ServletContextEvent ce) {
		boolean errors=false;

		try {
			AbstractDbObject.closeSessionFactory();
		}
		catch (final Exception e) {
			errors=true;
			logger.error("Exception invoking AbstractDbObject.closeCurrentSession()...", e);
		}
		logger.info("Container unloaded the application context"+(errors?"*** WITH ERRORS ***":"")+"...");
	}
	
	
}
