package com.theavocadopapers.hibernate;

import java.io.Serializable;
import java.sql.Connection;

import org.hibernate.CacheMode;
import org.hibernate.Criteria;
import org.hibernate.EntityMode;
import org.hibernate.Filter;
import org.hibernate.FlushMode;
import org.hibernate.HibernateException;
import org.hibernate.LockMode;
import org.hibernate.Query;
import org.hibernate.ReplicationMode;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.stat.SessionStatistics;

import com.theavocadopapers.core.logging.Logger;

@SuppressWarnings("serial")
public class SessionWrapper implements Session {

	private static final Logger logger = Logger.getLogger(SessionWrapper.class);

	//private long time=0;
	
	Session backingSession;
	private int depth;
	
	
	
	public static SessionWrapper openIfNotOpen(SessionWrapper sessionWrapper) {
		//final long start=new Date().getTime();
		if (sessionWrapper==null || sessionWrapper.backingSession==null || !sessionWrapper.isOpen()) {
			//throw new NullPointerException("Can't pass a null SessionWrapper; rather, pass a new SessionWrapper instance.");
			sessionWrapper=new SessionWrapper();
			sessionWrapper.backingSession=HibernateUtil.getSessionFactory().openSession();
			//logger.debug("constructed new SessionWrapper; got new Session; sessionWrapper.isOpen()="+sessionWrapper.isOpen()); 
		}
		else {
			sessionWrapper.depth++;
		}
		//final long dur=new Date().getTime()-start;
		//sessionWrapper.time+=dur;
		//System.out.println("End openIfNotOpen(): took "+dur+" time="+sessionWrapper.time);
		return sessionWrapper;
	}
	
	public static void closeIfNotNested(final SessionWrapper sessionWrapper) {
		//final long start=new Date().getTime();
		if (sessionWrapper.getDepth()==0) {
			sessionWrapper.backingSession.close();
		}
		else {
			sessionWrapper.depth--;
		}
		//final long dur=new Date().getTime()-start;
		//sessionWrapper.time+=dur;
		//System.out.println("End closeIfNotNested(): took "+dur+" time="+sessionWrapper.time);
	}
		


	public Transaction beginTransaction() throws HibernateException {
		return backingSession.beginTransaction();
	}

	public void cancelQuery() throws HibernateException {
		backingSession.cancelQuery();
	}

	public void clear() {
		backingSession.clear();
	}

	public Connection close() throws HibernateException {
		return backingSession.close();
	}

	@SuppressWarnings("deprecation")
	public Connection connection() throws HibernateException {
		return backingSession.connection();
	}

	public boolean contains(final Object object) {
		return backingSession.contains(object);
	}

	@SuppressWarnings("unchecked")
	public Criteria createCriteria(final Class persistentClass) {
		return backingSession.createCriteria(persistentClass);
	}

	public Criteria createCriteria(final String entityName) {
		return backingSession.createCriteria(entityName);
	}

	@SuppressWarnings("unchecked")
	public Criteria createCriteria(final Class persistentClass, final String alias) {
		return backingSession.createCriteria(persistentClass, alias);
	}

	public Criteria createCriteria(final String entityName, final String alias) {
		return backingSession.createCriteria(entityName, alias);
	}

	public Query createFilter(final Object collection, final String queryString) throws HibernateException {
		return backingSession.createFilter(collection, queryString);
	}

	public Query createQuery(final String queryString) throws HibernateException {
		return backingSession.createQuery(queryString);
	}

	public SQLQuery createSQLQuery(final String queryString) throws HibernateException {
		return backingSession.createSQLQuery(queryString);
	}

	public void delete(final Object object) throws HibernateException {
		backingSession.delete(object);
	}

	public void delete(final String entityName, final Object object) throws HibernateException {
		backingSession.delete(entityName, object);
	}

	public void disableFilter(final String filterName) {
		backingSession.disableFilter(filterName);
	}

	public Connection disconnect() throws HibernateException {
		return backingSession.disconnect();
	}

	public Filter enableFilter(final String filterName) {
		return backingSession.enableFilter(filterName);
	}

	public void evict(final Object object) throws HibernateException {
		backingSession.evict(object);
	}

	public void flush() throws HibernateException {
		backingSession.flush();
	}

	@SuppressWarnings("unchecked")
	public Object get(final Class clazz, final Serializable id) throws HibernateException {
		return backingSession.get(clazz, id);
	}

	public Object get(final String entityName, final Serializable id) throws HibernateException {
		return backingSession.get(entityName, id);
	}

	@SuppressWarnings("unchecked")
	public Object get(final Class clazz, final Serializable id, final LockMode lockMode) throws HibernateException {
		return backingSession.get(clazz, id, lockMode);
	}

	public Object get(final String entityName, final Serializable id, final LockMode lockMode) throws HibernateException {
		return backingSession.get(entityName, id, lockMode);
	}

	public CacheMode getCacheMode() {
		return backingSession.getCacheMode();
	}

	public LockMode getCurrentLockMode(final Object object) throws HibernateException {
		return backingSession.getCurrentLockMode(object);
	}

	public Filter getEnabledFilter(final String filterName) {
		return backingSession.getEnabledFilter(filterName);
	}

	public EntityMode getEntityMode() {
		return backingSession.getEntityMode();
	}

	public String getEntityName(final Object object) throws HibernateException {
		return backingSession.getEntityName(object);
	}

	public FlushMode getFlushMode() {
		return backingSession.getFlushMode();
	}

	public Serializable getIdentifier(final Object object) throws HibernateException {
		return backingSession.getIdentifier(object);
	}

	public Query getNamedQuery(final String queryName) throws HibernateException {
		return backingSession.getNamedQuery(queryName);
	}

	public Session getSession(final EntityMode entityMode) {
		return backingSession.getSession(entityMode);
	}

	public SessionFactory getSessionFactory() {
		return backingSession.getSessionFactory();
	}

	public SessionStatistics getStatistics() {
		return backingSession.getStatistics();
	}

	public Transaction getTransaction() {
		return backingSession.getTransaction();
	}

	public boolean isConnected() {
		return backingSession.isConnected();
	}

	public boolean isDirty() throws HibernateException {
		return backingSession.isDirty();
	}

	public boolean isOpen() {
		return backingSession.isOpen();
	}

	@SuppressWarnings("unchecked")
	public Object load(final Class theClass, final Serializable id) throws HibernateException {
		return backingSession.load(theClass, id);
	}

	public Object load(final String entityName, final Serializable id) throws HibernateException {
		return backingSession.load(entityName, id);
	}

	public void load(final Object object, final Serializable id) throws HibernateException {
		backingSession.load(object, id);
	}

	@SuppressWarnings("unchecked")
	public Object load(final Class theClass, final Serializable id, final LockMode lockMode) throws HibernateException {
		return backingSession.load(theClass, id, lockMode);
	}

	public Object load(final String entityName, final Serializable id, final LockMode lockMode) throws HibernateException {
		return backingSession.load(entityName, id, lockMode);
	}

	public void lock(final Object object, final LockMode lockMode) throws HibernateException {
		backingSession.lock(object, lockMode);
	}

	public void lock(final String entityName, final Object object, final LockMode lockMode) throws HibernateException {
		backingSession.lock(entityName, object, lockMode);
	}

	public Object merge(final Object object) throws HibernateException {
		return backingSession.merge(object);
	}

	public Object merge(final String entityName, final Object object) throws HibernateException {
		return backingSession.merge(entityName, object);
	}

	public void persist(final Object object) throws HibernateException {
		backingSession.persist(object);
	}

	public void persist(final String entityName, final Object object) throws HibernateException {
		backingSession.persist(entityName, object);
	}

	@SuppressWarnings("deprecation")
	public void reconnect() throws HibernateException {
		backingSession.reconnect();
	}

	public void reconnect(final Connection connection) throws HibernateException {
		backingSession.reconnect(connection);
	}

	public void refresh(final Object object) throws HibernateException {
		backingSession.refresh(object);
	}

	public void refresh(final Object object, final LockMode lockMode) throws HibernateException {
		backingSession.refresh(object, lockMode);
	}

	public void replicate(final Object object, final ReplicationMode replicationMode) throws HibernateException {
		backingSession.replicate(object, replicationMode);
	}

	public void replicate(final String entityName, final Object object, final ReplicationMode replicationMode) throws HibernateException {
		backingSession.replicate(entityName, object, replicationMode);
	}

	public Serializable save(final Object object) throws HibernateException {
		return backingSession.save(object);
	}

	public Serializable save(final String entityName, final Object object) throws HibernateException {
		return backingSession.save(entityName, object);
	}

	public void saveOrUpdate(final Object object) throws HibernateException {
		backingSession.saveOrUpdate(object);
	}

	public void saveOrUpdate(final String entityName, final Object object) throws HibernateException {
		backingSession.saveOrUpdate(entityName, object);
	}

	public void setCacheMode(final CacheMode cacheMode) {
		backingSession.setCacheMode(cacheMode);
	}

	public void setFlushMode(final FlushMode flushMode) {
		backingSession.setFlushMode(flushMode);
	}

	public void setReadOnly(final Object entity, final boolean readOnly) {
		backingSession.setReadOnly(entity, readOnly);
	}

	public void update(final Object object) throws HibernateException {
		backingSession.update(object);
	}

	public void update(final String entityName, final Object object) throws HibernateException {
		backingSession.update(entityName, object);
	}

	public void setDepth(final int depth) {
		this.depth = depth;
	}

	public int getDepth() {
		return depth;
	}
	
	@Override
	public String toString() {
		return this.getClass().getSimpleName()+"/depth="+getDepth();
	}

}
