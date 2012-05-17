package com.theavocadopapers.hibernate.acp;

import java.sql.SQLException;
import java.util.TimerTask;

import com.theavocadopapers.core.logging.Logger;

	public class PoolCleanerTask extends TimerTask {

	private static final Logger logger = Logger.getLogger(PoolCleanerTask.class);

	ConnectionPool pool;
	
	public PoolCleanerTask(final ConnectionPool pool) {
		logger.info("PoolCleanerTask thread created");
		this.pool=pool;
	}

	@Override
	public void run() {
		//logger.info("Running PoolCleanerTask...");
		try {
			this.pool.cleanPool();
		}
		catch (final SQLException e) {
			logger.error("SQLException encountered trying to clean() pool; swallowing.", e);
		}
	}

	@Override
	public boolean cancel() {
		logger.warn("cancel() invoked on PoolCleanerTask");
		return super.cancel();
	}
	
	

}
