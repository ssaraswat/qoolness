package com.theavocadopapers.hibernate.acp;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.ListIterator;
import java.util.Properties;
import java.util.Timer;
import java.util.TimerTask;

import com.theavocadopapers.apps.kqool.util.MailUtils;
import com.theavocadopapers.core.logging.Logger;

 

/**
 * @author z0067456
 *
 */
public class ConnectionPool {

	private static final Logger logger = Logger.getLogger(ConnectionPool.class);
	
	
	
	// should only contain one instance ever, at least with use by hibernate;
	// we keep this list so we can shut down and release all conns on server
	// shutdown:
	private static List<ConnectionPool> instances=new LinkedList<ConnectionPool>();

	private static final int NO_AVAILABLE_CONNECTIONS_WAIT_INTERVAL_MS=600;
	private static final int NO_AVAILABLE_CONNECTIONS_TRIES=200;
	
	public static final int DEFAULT_MIN_POOL_SIZE=2;
	public static final int DEFAULT_MAX_POOL_SIZE=5;
	public static final int DEFAULT_EXPIRE_AFTER_MILLIS_IDLE=120000;
	public static final int DEFAULT_NONPOOLED_CONNECTIONS_LIMIT=0;
	public static final int DEFAULT_CLEANUP_TASK_INTERVAL_MILLIS=10000;
	
	

	private final List<ConnectionWrapper> pool=new LinkedList<ConnectionWrapper>();
	private final List<ConnectionWrapper> checkedOutUnpooledConnections=new LinkedList<ConnectionWrapper>();
	private Timer timer;
	private TimerTask poolCleanerTask;
	private boolean poolActivated=false;
	
	private String dbUsername;
	private String dbPassword;
	private String jdbcUrl;
	private int minPoolSize=DEFAULT_MIN_POOL_SIZE;
	private int maxPoolSize=DEFAULT_MAX_POOL_SIZE;
	private long expireAfterMillisIdle=DEFAULT_EXPIRE_AFTER_MILLIS_IDLE;
	private int nonpooledConnectionsLimit=DEFAULT_NONPOOLED_CONNECTIONS_LIMIT;
	private long cleanupTaskIntervalMillis=DEFAULT_CLEANUP_TASK_INTERVAL_MILLIS;
	

	
	
	
	private final Object lock=new Object();


	public ConnectionPool() {}
	
	public ConnectionPool(final Properties props) {
		this(props, "");
	}
	
	public ConnectionPool(final Properties props, final String propNamePrefix) {
		this.dbUsername=ConnectionPoolUtil.getPropValue(props, propNamePrefix, "connection.username", null);
		this.dbPassword=ConnectionPoolUtil.getPropValue(props, propNamePrefix, "connection.password", null);	
		this.jdbcUrl=ConnectionPoolUtil.getPropValue(props, propNamePrefix, "connection.url", null);
		this.minPoolSize=ConnectionPoolUtil.getIntPropValue(props, propNamePrefix, "connection.min_pool_size", DEFAULT_MIN_POOL_SIZE);
		this.maxPoolSize=ConnectionPoolUtil.getIntPropValue(props, propNamePrefix, "connection.pool_size", DEFAULT_MAX_POOL_SIZE);
		this.expireAfterMillisIdle=ConnectionPoolUtil.getIntPropValue(props, propNamePrefix, "connection.expire_after_millis_idle", DEFAULT_EXPIRE_AFTER_MILLIS_IDLE);
		this.nonpooledConnectionsLimit=ConnectionPoolUtil.getIntPropValue(props, propNamePrefix, "connection.nonpooled_connections_limit", DEFAULT_NONPOOLED_CONNECTIONS_LIMIT);
		this.cleanupTaskIntervalMillis=ConnectionPoolUtil.getIntPropValue(props, propNamePrefix, "connection.cleanup_task_interval_millis", DEFAULT_CLEANUP_TASK_INTERVAL_MILLIS);
	}
	


	public synchronized void activatePool() throws ConnectionPoolException {
		if (this.poolActivated) {
			throw new ConnectionPoolException("Can't activate pool; pool already activated.");
		}
		if (this.dbUsername==null) {
			throw new ConnectionPoolException("dbUsername is null.");
		}
		if (this.jdbcUrl==null) {
			throw new ConnectionPoolException("jdbcUrl is null.");
		}
		if (this.maxPoolSize<0) {
			throw new ConnectionPoolException("maxPoolSize must be at least zero (current value="+this.maxPoolSize+").");
		}
		if (this.minPoolSize<0) {
			throw new ConnectionPoolException("minPoolSize must be at least zero (current value="+this.minPoolSize+").");
		}
		if (this.minPoolSize>this.maxPoolSize) {
			this.minPoolSize=this.maxPoolSize;
			logger.warn("minPoolSize was larger than maxPoolSize, so setting minPoolSize to maxPoolSize ("+this.maxPoolSize+")");
		}
		if (this.expireAfterMillisIdle<=0) {
			throw new ConnectionPoolException("expireAfterMillisIdle must be a positive number (current value="+this.expireAfterMillisIdle+").");
		}
		if (this.cleanupTaskIntervalMillis<=0) {
			throw new ConnectionPoolException("cleanupTaskIntervalMillis must be a positive number (current value="+this.cleanupTaskIntervalMillis+").");
		}
		if (this.nonpooledConnectionsLimit<-1) {
			throw new ConnectionPoolException("nonpooledConnectionsLimit must be -1 (unlimited unpooled connections), 0 (no unpooled connections) or a positive number.");
		}
		this.nonpooledConnectionsLimit=(this.nonpooledConnectionsLimit==-1?99999999:this.nonpooledConnectionsLimit);
		
		if (this.maxPoolSize==0 && this.nonpooledConnectionsLimit==0) {
			throw new ConnectionPoolException("The maxPoolSize is 0 and the nonpooledConnectionsLimit " +
					"is 0, so the ConnectionPool will not be able to furnish any connections.  Please " +
					"set one of these values to a positive number (or set nonpooledConnectionsLimit to -1, " +
					"indicating that the ConnectionPool should furnish an unlimited number of unpooled " +
					"connections.");
		}
		
		ConnectionWrapper connectionWrapper;
		for (int i=0; i<this.minPoolSize; i++) {
			try {
				connectionWrapper=createConnectionWrapper(true);
				logger.info("In activatePool(), adding a connection with id "+connectionWrapper.getId()+" to fill the pool to its minimum size");
				//logger.debug("In constructor, adding conn with ID "+connectionWrapper.getId()+"; pool size="+pool.size()+"...");
				this.pool.add(connectionWrapper);
			}
			catch (final SQLException e) {
				logger.fatal("Fatal error trying to get JDBC connection from "+jdbcUrl+" with username "+dbUsername+", password ********.  Rethrowing SQLException as ConnectionPoolException.", e);
				throw new ConnectionPoolException(e);
			}
		}
		synchronized (instances) {
			instances.add(this);
			timer=new Timer(false);
			
			if (this.cleanupTaskIntervalMillis>0) {
				final Date taskStartTime=new Date();
				taskStartTime.setTime(taskStartTime.getTime()+this.cleanupTaskIntervalMillis);
				this.poolCleanerTask=new PoolCleanerTask(this);
				logger.info("PoolCleanerTask instance scheduled to run every "+this.cleanupTaskIntervalMillis+"ms, starting at "+taskStartTime);
				timer.schedule(poolCleanerTask, taskStartTime, this.cleanupTaskIntervalMillis);
			}
		}
		logger.info("ConnectionPool activated with dbUsername="+this.dbUsername+"; dbPassword=********; " +
				"jdbcUrl="+this.jdbcUrl+"; minPoolSize="+this.minPoolSize+"; maxPoolSize="+this.maxPoolSize+"; " +
				"expireAfterMillisIdle="+this.expireAfterMillisIdle+"; nonPooledConnectionsLimit="+this.nonpooledConnectionsLimit+"; " +
				"cleanupTaskIntervalMillis="+this.cleanupTaskIntervalMillis+"; current pool size="+this.pool.size());
		this.poolActivated=true;

	}



	public Connection checkOutConnection() throws SQLException, ConnectionPoolException {
		if (poolActivated) {
			int tries=0;
			while (tries<NO_AVAILABLE_CONNECTIONS_TRIES) {
				if (tries>0) {
					try {
						// Let someone return a connection to the pool if they feel like it...
						Thread.sleep(NO_AVAILABLE_CONNECTIONS_WAIT_INTERVAL_MS);
						Thread.yield();
					}
					catch (final InterruptedException e) {}
				}
				synchronized (this.lock) {
					ConnectionWrapper conn=null;
					final int poolSize=this.pool.size();
					for (int i=0; i<poolSize; i++) {
						conn=this.pool.get(i);
						if (conn.isAvailable()) {
							if (conn.isClosed()) {
								this.pool.remove(conn);
								try {
									conn=createConnectionWrapper(true);
									//logger.debug(">>>>> In checkOutConnection(), adding a connection with id "+conn.getId()+" because conn "+conn.getId()+" was closed");
									this.pool.add(conn);
								}
								catch (final SQLException e) {
									logger.fatal("Fatal error trying to get JDBC connection from "+jdbcUrl+" with username "+dbUsername+", password ********.  Rethrowing SQLException as ConnectionPoolException.", e);
									throw new ConnectionPoolException(e);
								}
							}
							// put it at the end of the line (it was almost certainly at the beginning, i.e. idx 0:
							this.pool.add(this.pool.remove(i));
							conn.setAvailable(false);
							logger.info("  --> checking out pooled connection (idx "+i+"), id="+conn.getId()+", after "+tries+" sleep/yields. Pool size="+pool.size()); 
							return conn;
						}
					} // end for (int i=0; i<poolSize; i++)
					// nothing in the pool to check out now, but the pool may not be its max size; if not, add a conn and return it:
					if (this.pool.size()<getMaxPoolSize()) {
						try {
							final ConnectionWrapper newConnectionWrapper=createConnectionWrapper(true);
							this.pool.add(newConnectionWrapper);
							logger.info("  --> Created new conn and now checking out pooled connection, id="+newConnectionWrapper.getId()+", after "+tries+" sleep/yields. Pool size="+pool.size()); 
							return newConnectionWrapper;
						}
						catch (final SQLException e) {
							logger.fatal("Fatal error trying to get JDBC connection from "+jdbcUrl+" with username "+dbUsername+", password ********.  Rethrowing SQLException as RuntimeException.", e);
							throw new RuntimeException(e);
						}
					} // end if (this.pool.size()<getMaxPoolSize())
					// No pooled conns available this go-round, but we may be able to check out an unpooled one:
					if (checkedOutUnpooledConnections.size()<getNonpooledConnectionsLimit()) {
						// return an unpooled connection after storing it in the list (we need
						// to keep a reference to unpooled connex so we can shut them down when
						// the context is unloaded if necessary):
						try {
							final ConnectionWrapper unpooledConn=createConnectionWrapper(false);
							logger.warn("--> No pooled connections available, so checking out an unpooled connection (unpooled conns out="+checkedOutUnpooledConnections.size()+".");
							//logger.debug(">>>>> In checkOutConnection(), returning unpooled conn id="+unpooledConn.getId());
	
							this.checkedOutUnpooledConnections.add(unpooledConn);
							return unpooledConn;
						}
						catch (final SQLException e) {
							logger.fatal("Fatal error trying to get JDBC connection from "+jdbcUrl+" with username "+dbUsername+", password ********.  Rethrowing SQLException as RuntimeException.", e);
							throw new RuntimeException(e);
						}
					}
					tries++;
				} // end synchronized block
			} // end while (tries<NO_AVAILABLE_CONNECTIONS_TRIES)
			
			
			throw new ConnectionPoolException("No pooled connections available (pool size="+getMaxPoolSize()+") and the maximum number of unpooled connections ("+getNonpooledConnectionsLimit()+") is currently in use by other clients.");
		}
		else {
			throw new IllegalStateException("Pool must be activated before use (call activatePool()).");
		}

	}





	










	
	




	protected void checkInPooledConnection(final ConnectionWrapper connectionWrapper) throws SQLException {
		if (poolActivated) {
			synchronized (this.lock) {
				logger.info("<--   Pooled conn with id "+connectionWrapper.getId()+" checked into pool");
				final boolean connIsClosed=connectionWrapper.isClosed();
				if (connIsClosed) {
					this.pool.remove(connectionWrapper);
					try {
						final ConnectionWrapper newConnectionWrapper=createConnectionWrapper(true);
						//logger.debug(">>>>> In checkInPooledConnection(), adding a conn with id "+newConnectionWrapper.getId()+" because it was closed");
						this.pool.add(0, newConnectionWrapper);
					}
					catch (final SQLException e) {
						logger.fatal("Fatal error trying to get JDBC connection from "+jdbcUrl+" with username "+dbUsername+", password ********.  Rethrowing SQLException as RuntimeException.", e);
						throw new RuntimeException(e);
					}
				}
				else {
					connectionWrapper.setAvailable(true);
					this.pool.remove(connectionWrapper);
					this.pool.add(0, connectionWrapper);
				}
			}
			// This may or may not be necessary, but can't hurt: explicitly yield to other
			// threads who may be waiting on a con to be returned to the pool:
			Thread.yield();
		}
		else {
			throw new IllegalStateException("Pool must be activated before use (call activatePool()).");
		}
		//logger.debug("At end of checkInPooledConnection(), pool size is "+this.pool.size());
	}



	public void checkInConnection(final Connection connection) throws SQLException {
		if (poolActivated) {
			if (!(connection instanceof ConnectionWrapper)) {
				throw new IllegalArgumentException("Foreign connection returned to ConnectionPool; connections returned to checkInConnection() must be of type ConnectionWrapper.");
			}
			final ConnectionWrapper connectionWrapper=(ConnectionWrapper)connection;
			if (connectionWrapper.isPooled()) {
				checkInPooledConnection(connectionWrapper);
			}
			else {
				handleUnpooledConnectionReturn(connectionWrapper);
			}
		}
		else {
			throw new IllegalStateException("Pool must be activated before use (call activatePool()).");
		}

	}






	protected void handleUnpooledConnectionReturn(final ConnectionWrapper connectionWrapper) throws SQLException {
		if (poolActivated) {
			synchronized (lock) {
				final boolean connIsClosed=connectionWrapper.isClosed();
				logger.info("<--   Unpooled conn with id "+connectionWrapper.getId()+" checked into pool; connIsClosed="+connIsClosed);
				if (!connIsClosed) {
					connectionWrapper.close();
				}
				//logger.info("Removing unpooled conn with id "+connectionWrapper.getId()+" checked into pool; connIsClosed="+connIsClosed);
				this.checkedOutUnpooledConnections.remove(connectionWrapper);
			}
		}
		else {
			throw new IllegalStateException("Pool must be activated before use (call activatePool()).");
		}

	}




	/** MUST be called from within a synchronized block or method
	 * @param pooled false if this connection is not pooled and will be discarded when returned to this provider
	 * @return
	 * @throws SQLException
	 */
	protected ConnectionWrapper createConnectionWrapper(final boolean pooled) throws SQLException {
		try {
			final ConnectionWrapper conn=new ConnectionWrapper(DriverManager.getConnection(this.jdbcUrl, this.dbUsername, this.dbPassword), pooled);
			return conn;
		}
		catch (final SQLException e) {
			logger.error("SQLException ("+e.getClass().getName()+": "+e.getMessage()+") encountered trying to DriverManager.getConnection(); sent dev mail; about to rethrow (see below for stack trace when Exception is caught by this method's client).");
			MailUtils.sendExceptionReport(e);
			throw e;
		}
	}



	public void closeAllConnections() {
		synchronized(lock) {
			try {
				timer.cancel();
			}
			catch (final Throwable t) {
				t.printStackTrace();
			}
			try {
				poolCleanerTask.cancel();
			}
			catch (final Throwable t) {
				t.printStackTrace();
			}

			int closedConnections=0;
			int failedCloseAttempts=0;
			logger.info("In closeAllConnections(), about to close all connections in the pool (and all unpooled, outstanding connections), regardless of whether they are checked out or not.");
			final List<ConnectionWrapper> allConnections=new LinkedList<ConnectionWrapper>();
			logger.info("Connections in pool: "+this.pool.size());
			logger.info("Unpooled, outstanding connections: "+this.checkedOutUnpooledConnections.size());
			allConnections.addAll(this.pool);
			allConnections.addAll(this.checkedOutUnpooledConnections);
			
			final Iterator<ConnectionWrapper> i=allConnections.iterator();
			ConnectionWrapper connectionWrapper;
			while (i.hasNext()) {
				connectionWrapper=i.next();
				logger.info("About to close connection with id "+connectionWrapper.getId()+" (pooled="+connectionWrapper.isPooled()+") if not closed.");
				try {
					if (!connectionWrapper.isClosed()) {
						logger.info("Connection with id "+connectionWrapper.getId()+" is not closed; attempting to close...");
						connectionWrapper.close();
						logger.info("Connection with id "+connectionWrapper.getId()+" successfully closed.");
						closedConnections++;
					}
					
					i.remove();
					if (connectionWrapper.isPooled()) {
						this.pool.remove(connectionWrapper);
					}
					else {
						this.checkedOutUnpooledConnections.remove(connectionWrapper);
					}
				}
				catch (final SQLException e) {
					failedCloseAttempts++;
					logger.error("Connection with id "+connectionWrapper.getId()+" close failed; stack trace follows...", e);
				}
			}
			logger.info("At end of closeAllConnections(), "+closedConnections+" connections closed; "+failedCloseAttempts+" connections attempted but resulted in SQLExceptions; "+this.pool.size()+" total connections in the pool; "+this.checkedOutUnpooledConnections.size()+" unpooled connections remain open (i.e., they could not be closed).");
		}
	}
	

	/** Called by PoolCleanerTask thread
	 * @throws SQLException 
	 * 
	 */
	protected void cleanPool() throws SQLException {
		synchronized(lock) {
			final ListIterator<ConnectionWrapper> poolIterator=this.pool.listIterator();
			ConnectionWrapper conn;
			int removedConns=0;
			boolean connIsClosed;
			while (poolIterator.hasNext()) {
				conn=poolIterator.next();
				connIsClosed=conn.isClosed();
				// if conn is not checked out...
				if (conn.isAvailable()) {
					// and conn is either old or closed...
					if (conn.getIdleMillis()+cleanupTaskIntervalMillis>this.expireAfterMillisIdle || connIsClosed) {
						//logger.info("in clean(), removing conn with ID "+conn.getId()+" because it's either stale or closed conn.getIdleMillis()+taskPeriodMillis-this.expireAfterMillisIdle="+(conn.getIdleMillis()+cleanupTaskIntervalMillis-this.expireAfterMillisIdle)+"; connIsClosed="+connIsClosed+")...");
						// close the conn  if it's open...
						if (!connIsClosed) {
							//logger.info("Closing conn "+conn.getId()+"...");
							conn.close();
						}
						// and then remove it from the pool:
						//logger.info("Removing conn "+conn.getId()+" from the pool...");
						poolIterator.remove();
						removedConns++;
					}
				}
			}
			// then replenish the pool:
			//logger.info("Re-filling the pool...");
			int c=0;
			ConnectionWrapper newConnectionWrapper;
			for (int i=pool.size(); i<minPoolSize; i++) {
				newConnectionWrapper=createConnectionWrapper(true);
				this.pool.add(newConnectionWrapper);
				//logger.debug(">>>>> In cleanPool(), adding a connection with id "+newConnectionWrapper.getId()+" to fill up the pool to its minimum size...");

				c++;
			}
			//logger.info("Re-filled the pool with "+c+" conns.");
		}
	}

	
	
	


	@Override
	public void finalize()  {
		/*
		try {
			timer.cancel();
		}
		catch (final Throwable t) {}
		try {
			poolCleanerTask.cancel();
		}
		catch (final Throwable t) {}
		try {
			closeAllConnections();
		}
		catch (final Throwable t) {}
		 */
		
	}
	
	
	
	
	




	
	
	
	
	
	
	



	public static List<ConnectionPool> getInstances() {
		return instances;
	}

	public boolean isPoolActivated() {
		return poolActivated;
	}

	public void setPoolActivated(final boolean poolActivated) {
		this.poolActivated = poolActivated;
	}

	public String getDbUsername() {
		return dbUsername;
	}

	public void setDbUsername(final String dbUsername) {
		this.dbUsername = dbUsername;
	}

	public String getDbPassword() {
		return dbPassword;
	}

	public void setDbPassword(final String dbPassword) {
		this.dbPassword = dbPassword;
	}

	public String getJdbcUrl() {
		return jdbcUrl;
	}

	public void setJdbcUrl(final String jdbcUrl) {
		this.jdbcUrl = jdbcUrl;
	}

	public int getMinPoolSize() {
		return minPoolSize;
	}

	public void setMinPoolSize(final int minPoolSize) {
		this.minPoolSize = minPoolSize;
	}

	public int getMaxPoolSize() {
		return maxPoolSize;
	}

	public void setMaxPoolSize(final int maxPoolSize) {
		this.maxPoolSize = maxPoolSize;
	}

	public long getExpireAfterMillisIdle() {
		return expireAfterMillisIdle;
	}

	public void setExpireAfterMillisIdle(final long expireAfterMillisIdle) {
		this.expireAfterMillisIdle = expireAfterMillisIdle;
	}

	public int getNonpooledConnectionsLimit() {
		return nonpooledConnectionsLimit;
	}

	public void setNonpooledConnectionsLimit(final int nonpooledConnectionsLimit) {
		this.nonpooledConnectionsLimit = nonpooledConnectionsLimit;
	}

	public long getCleanupTaskIntervalMillis() {
		return cleanupTaskIntervalMillis;
	}

	public void setCleanupTaskIntervalMillis(final long cleanupTaskIntervalMillis) {
		this.cleanupTaskIntervalMillis = cleanupTaskIntervalMillis;
	}

}
