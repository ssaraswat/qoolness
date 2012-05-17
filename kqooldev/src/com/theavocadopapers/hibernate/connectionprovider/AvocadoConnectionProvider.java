package com.theavocadopapers.hibernate.connectionprovider;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

import org.hibernate.HibernateException;
import org.hibernate.connection.ConnectionProvider;

import com.theavocadopapers.apps.kqool.util.MailUtils;
import com.theavocadopapers.core.logging.Logger;
import com.theavocadopapers.hibernate.acp.ConnectionPool;
import com.theavocadopapers.hibernate.acp.ConnectionPoolException;



/**
 * @author z0067456
 *
 */
public class AvocadoConnectionProvider implements ConnectionProvider {

	private static final Logger logger = Logger.getLogger(AvocadoConnectionProvider.class);
	
	protected ConnectionPool avocadoConnectionPool;

	public AvocadoConnectionProvider() {
		super();
	}


	public void configure(final Properties props) throws HibernateException {
		this.avocadoConnectionPool=new ConnectionPool(props, "hibernate.");
		try {
			this.avocadoConnectionPool.activatePool();
		} 
		catch (final ConnectionPoolException e) {
			logger.fatal("Failed to activate the connection pool; this exception is fatal.  Rethrowing.", e);
		}
	}


	public Connection getConnection() throws SQLException {
		try {
			return this.avocadoConnectionPool.checkOutConnection();
		} 
		catch (final ConnectionPoolException e) {
			logger.error("Exception trying to get connection from AvocadoConnectionPool instance; sending dev error message, then rethrowing as RuntimeException.", e);
			MailUtils.sendExceptionReport(e);
			throw new RuntimeException(e);
		}
	}




	public void closeConnection(final Connection connection) throws SQLException {
		this.avocadoConnectionPool.checkInConnection(connection);
	}




	public void close() throws HibernateException {
		this.avocadoConnectionPool.closeAllConnections();
	}


	public boolean supportsAggressiveRelease() {
		return false;
	}



}
