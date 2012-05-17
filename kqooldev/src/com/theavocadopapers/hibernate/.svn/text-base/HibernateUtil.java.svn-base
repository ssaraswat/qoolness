package com.theavocadopapers.hibernate;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import com.theavocadopapers.core.logging.Logger;

public class HibernateUtil {

	private static final SessionFactory sessionFactory;
	
	private static final Logger logger = Logger.getLogger(HibernateUtil.class);

	static {
		try {

			logger.info("About to build session factory...");
			// Create the SessionFactory from hibernate.cfg.xml
			sessionFactory = new Configuration().configure().buildSessionFactory();
		}
		catch (final Throwable ex) {
			logger.fatal("Initial SessionFactory creation failed; please fix and restart container.", ex);
			throw new ExceptionInInitializerError(ex);
		}
	}

	public static SessionFactory getSessionFactory() {
		return sessionFactory;
	}
}
