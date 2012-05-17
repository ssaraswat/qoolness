package com.theavocadopapers.apps.kqool.entity;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;
import org.hibernate.Transaction;

import com.theavocadopapers.core.logging.Logger;
import com.theavocadopapers.hibernate.HibernateUtil;
import com.theavocadopapers.hibernate.SessionWrapper;


public abstract class AbstractDbObject implements Comparable {

	private static final Logger logger = Logger.getLogger(AbstractDbObject.class);
	 
	public static final Integer ZERO_INTEGER_OBJECT=new Integer(0);
	
	public static final int FIELD_TYPE_BOOLEAN=1;
	public static final int FIELD_TYPE_TEXTUAL=2;
	public static final int FIELD_TYPE_NUMERIC=3;
	
	

	static {
        try {
        	try {
        		Class.forName("com.mysql.jdbc.Driver");
        	}
        	catch (final Throwable e) {
                logger.fatal("In AbstractDbObject static initializer, could not load com.mysql.jdbc.Driver; this is fatal.", e);
                e.printStackTrace();
                throw new ExceptionInInitializerError("In AbstractDbObject static initializer, could not load com.mysql.jdbc.Driver: Exception: "+e+": "+e.getMessage());     		
        	}
            


        } catch (final Throwable e) {
            logger.fatal("Initial SessionFactory creation failed; this is a fatal problem.  Fix and restart server (otherwise NoClassDefFoundExceptions will follow). Rethrowing as ExceptionInInitializerError", e);
            e.printStackTrace();
            throw new ExceptionInInitializerError("Initial SessionFactory creation failed; this is fatal.  Fix and restart server (otherwise NoClassDefFoundExceptions will follow). Rethrowing as ExceptionInInitializerError: Exception: "+e+": "+e.getMessage()+"");
        }
    }
	
	protected int id;
	protected Date createDate;
	protected Date lastModifiedDate;
    

    protected abstract Comparable getComparableValue();
    

    

    
    
    
	public static AbstractDbObject getUniqueByField(final String fieldName, final String fieldValue, final int fieldType, final Class<AbstractDbObject> currentClass, final boolean cacheable) {
		return getUniqueByField(fieldName, fieldValue, fieldType, currentClass, cacheable, new SessionWrapper());
	}   
	
	protected static AbstractDbObject getUniqueByField(final String fieldName, final String fieldValue, final int fieldType, final Class<AbstractDbObject> currentClass, final boolean cacheable, final SessionWrapper session) {
		final List<AbstractDbObject> objects=getByField(fieldName, fieldValue, fieldType, currentClass, cacheable, session);
		return (objects==null?null:objects.get(0));
	}
	
	
	

	
	public static List<AbstractDbObject> getByField(final String fieldName, final String fieldValue, final int fieldType, final Class<AbstractDbObject> currentClass, final boolean cacheable) {
		return getByField(fieldName, fieldValue, fieldType, currentClass, cacheable, new SessionWrapper());

	}
	
	protected static List<AbstractDbObject> getByField(final String fieldName, final String fieldValue, final int fieldType, final Class<AbstractDbObject> currentClass, final boolean cacheable, final SessionWrapper session) {
		final String className=getClassNameOnly(currentClass);
		final StringBuilder b=new StringBuilder(512);
		b.append("from "+className+" as i where i."+fieldName+" =");
		final boolean quoteFieldValue=(fieldType==FIELD_TYPE_TEXTUAL);
		if (quoteFieldValue) {
			b.append("'");
		}
		b.append(fieldValue);
		if (quoteFieldValue) {
			b.append("'");
		}	
		return getByHQLQuery(b.toString(), cacheable, session);
	}

	
	
	
	
	public static List<AbstractDbObject> getByField(final String fieldName, final Number fieldValue, final int fieldType, final Class<AbstractDbObject> currentClass, final boolean cacheable) {
		return getByField(fieldName, fieldValue, fieldType, currentClass, cacheable, new SessionWrapper());
	}
	
	protected static List<AbstractDbObject> getByField(final String fieldName, final Number fieldValue, final int fieldType, final Class<AbstractDbObject> currentClass, final boolean cacheable, final SessionWrapper session) {
		return getByField(fieldName, fieldValue.toString(), fieldType, currentClass, cacheable, session);
	}


	

	public static List<AbstractDbObject> getByIds(final Class<AbstractDbObject> clazz, final Collection<Integer> ids, final boolean cacheable) {
		return getByIds(clazz, ids, cacheable, new SessionWrapper());
	}
	
	@SuppressWarnings("unchecked")
	protected static List<AbstractDbObject> getByIds(final Class<AbstractDbObject> clazz, final Collection<Integer> ids, final boolean cacheable, final SessionWrapper session) {
		final String className=getClassNameOnly(clazz);
		List<AbstractDbObject> objects=null;
    	final RuntimeException re=null;
    	/*
		if (ids==null) {
			Transaction transaction=null;
			try {
				// null signifies "get all":
		    	session=SessionWrapper.openIfNotOpen(session);
				transaction=beginTransaction(session);
				final Query query=session.createQuery("from "+className);
				query.setCacheable(cacheable);
				objects=query.list();
				transaction.commit();
				SessionWrapper.closeIfNotNested(session);
			}
			catch (final RuntimeException e) {
				try {
					logger.error("Exception getting by ids", e);
					transaction.rollback();
				}
				catch (final HibernateException he) {
					logger.error("HibernateException getting by ids", he);
				}
				re=e;
			}
		}
		*/
		//else {
			final StringBuilder b=new StringBuilder(ids.size()*10);
			boolean first=true;
			for (final Integer id : ids) {
				if (!first) {
					b.append(',');
				}
				else {
					first=false;
				}
				b.append(id);
			}
			final String query="from "+className+" as i where i.id in ("+b.toString()+")";
			objects=getByHQLQuery(query, cacheable, session);
		//}
			

		
		
    	
    	if (re!=null) {
			logger.error("Exception loading "+clazz.getName()+" instances with ID(s) "+ids+"; rethrowing...", re);
    		throw re;
    	}
    	if (objects!=null && objects.size()==0) {
    		objects=null;
    	}
    	return objects;
    }
  
	
	
	
	
	
	public static List<AbstractDbObject> getByHQLQuery(final String query, final boolean cacheable) {
		return getByHQLQuery(query, cacheable, new SessionWrapper());
	}
	
	protected static List<AbstractDbObject> getByHQLQuery(final String query, final boolean cacheable, final SessionWrapper session) {
		return getByHQLQuery(query, -1, cacheable, session);
	}

	
	
	
	
	
	public static List<AbstractDbObject> getByHQLQuery(final String query, final int maxResults, final boolean cacheable) {
		return getByHQLQuery(query, maxResults, cacheable, new SessionWrapper());
	}
	
	@SuppressWarnings("unchecked")
	protected static List<AbstractDbObject> getByHQLQuery(final String query, final int maxResults, final boolean cacheable, SessionWrapper session) {
		session=SessionWrapper.openIfNotOpen(session);
		List<AbstractDbObject> objects=null;
    	RuntimeException re=null;
    	
		final Transaction transaction=beginTransaction(session);
		
		try {
			final Query queryObj=session.createQuery(query);
			queryObj.setCacheable(cacheable);
			if (maxResults!=-1) {
				queryObj.setMaxResults(maxResults);
			}
			objects=queryObj.list();
			transaction.commit();
		}
		catch (final RuntimeException e) {
			transaction.rollback();
			re=e;
		}
		
		SessionWrapper.closeIfNotNested(session);
    	
    	if (re!=null) {
			logger.error("Exception loading by HQL query \""+query+"\"; rethrowing...", re);
    		throw re;
    	}
    	if (objects.size()==0) {
    		objects=null;
    	}

    	return objects;
    }
 
	private static Transaction beginTransaction(final SessionWrapper session) {
		Transaction transaction=null;
		try {
			transaction=session.beginTransaction();
		}
		catch (final Exception e) {
			logger.warn("Exception trying to beginTransaction() ("+e.getClass().getName()+": "+e.getMessage()+"); we get around it by trying again " +
					"repeatedly until we hit the limit specified" +
					"locally in this method, then we bail. " +
					"Exception="+e.getClass().getName()+": "+e.getMessage());
			// Why: well, for some reason if we haven't talked to the db in a while, the first attempt
			// to create a Transaction fails on acct of "org.hibernate.TransactionException: JDBC begin failed";
			// waiting and trying again seems to solve the issue:
			for (int i=0; i<10; i++) {
				//logger.info("trying after "+(millisWait*(i+1))+" millis...");
				logger.warn("try "+i+"...");
				try {
					transaction=session.beginTransaction();
					break;
				}
				catch (final Exception e1) {
					logger.error("Exception trying to beginTransaction() ("+e.getClass().getName()+": "+e.getMessage()+"); trying again...");
				}
			}
		}

		return transaction;
	}


	@SuppressWarnings("unchecked")
	protected static List<AbstractDbObject> getBySQLQuery(final String query, final boolean cacheable, SessionWrapper session) {
    	List<AbstractDbObject> objects=null;
    	RuntimeException re=null;
    	session=SessionWrapper.openIfNotOpen(session);
		final Transaction transaction=beginTransaction(session);

		try {
			final Query queryObj=session.createSQLQuery(query);
			queryObj.setCacheable(cacheable);
			objects=queryObj.list();
			transaction.commit();
		}
		catch (final RuntimeException e) {
			transaction.rollback();
			re=e;
		}
   	
		SessionWrapper.closeIfNotNested(session);
    	
    	if (re!=null) {
			logger.error("Exception loading by SQL query \""+query+"\"; rethrowing...", re);
    		throw re;
    	}
    	if (objects.size()==0) {
    		objects=null;
    	}
    	return objects;
    }
    


	
	
	
	
	public static AbstractDbObject getById(final Class<AbstractDbObject> clazz, final int id, final boolean cacheable) {
		return getById(clazz, id, cacheable, new SessionWrapper());
	}
	
    protected static AbstractDbObject getById(final Class<AbstractDbObject> clazz, final int id, final boolean cacheable, final SessionWrapper session) {
    	return getUniqueByField("id", ""+id, FIELD_TYPE_NUMERIC, clazz, true, session);
    	/*
    	final List<Integer> ids=new ArrayList<Integer>(1);
    	ids.add(new Integer(id));
    	final List<AbstractDbObject> objects=getByIds(clazz, ids, cacheable, session);
    	if (objects==null || objects.size()==0) {
    		return null;
    	}
    	return objects.get(0);
    	*/
    }
    

    
    
    

    public static boolean deleteById(final Class<AbstractDbObject> clazz, final int id) {
    	return deleteById(clazz, id, new SessionWrapper());
    }

    protected static boolean deleteById(final Class<AbstractDbObject> clazz, final int id, final SessionWrapper session) {
    	final AbstractDbObject obj=getById(clazz, id, false, new SessionWrapper());
    	final int idToDelete=obj.getId();
    	if (obj==null) {
    		return false;
    	}
    	final List<AbstractDbObject> objs=new ArrayList<AbstractDbObject>(1);
    	objs.add(obj);
    	final Object[] deletedIds=delete(objs, session);
    	if (deletedIds==null || deletedIds.length==0) {
    		return false;
    	}
    	if (idToDelete!=((Integer)deletedIds[0]).intValue()) { 
    		// this would never happen, correct? --
    		return false;
    	}
    	return true;
    }

    
    
    
    public static List<AbstractDbObject> getAll(final Class<AbstractDbObject> clazz) {
    	return getAll(clazz, new SessionWrapper());
    }
    
    protected static List<AbstractDbObject> getAll(final Class<AbstractDbObject> clazz, final SessionWrapper session) {
    	return getByHQLQuery("from "+getClassNameOnly(clazz), true, session);
    	/*
    	return getByIds(clazz, null, true, session);
    	*/
    }  

    
    
    
    
    public static Map<Integer,AbstractDbObject> getAllAsMap(final Class<AbstractDbObject> clazz) {
    	return getAllAsMap(clazz, new SessionWrapper());
    }
    
    protected static Map<Integer,AbstractDbObject> getAllAsMap(final Class<AbstractDbObject> clazz, final SessionWrapper session) {
    	final List<?> all=getAll(clazz, session);
    	final Map<Integer, AbstractDbObject> map=new LinkedHashMap<Integer, AbstractDbObject>(all.size()*2);
    	for (final Object obj: all) {
    		map.put(new Integer(((AbstractDbObject)obj).getId()), (AbstractDbObject)obj);
    	}
    	return map;
    }  



 
    
    /** Calls close() on the SessionFactory, releasing resources associated with the current thread.
     * 
     */
    public static void closeSessionFactory() {
    	HibernateUtil.getSessionFactory().close();
    }

    
    protected static String getClassNameOnly(final Class<AbstractDbObject> clazz) {
		String fullClassName=new String(clazz.getName());
		if (fullClassName.indexOf('.')>-1) {
			fullClassName=fullClassName.substring(fullClassName.lastIndexOf('.')+1, fullClassName.length());
		}
		return fullClassName;
	}
    
    


    public int store() { 
    	return store(new SessionWrapper());
    }
    
    /** Inserts or updates this object (inserts if ID is zero, otherwise updates).
     * @return
     */
    protected int store(SessionWrapper session) { 
    	//boolean closeSession=false;
    	//if (session==null || !session.isOpen()) {
    	//	closeSession=true;
    	//	try {
    	//		SessionWrapper.closeIfNotNested(session);
    	//	}
    	//	catch (final RuntimeException e) {}
    	//	session=new SessionWrapper();
    	//}
    	int objectId=0;
    	RuntimeException re=null;
    	final Date now=new Date();
    	this.setLastModifiedDate(now);
    	session=SessionWrapper.openIfNotOpen(session);
    	//logger.debug("before beginRransaction(), session.isOpen()"+session.isOpen());
		final Transaction transaction=beginTransaction(session);
    	//logger.debug("AFTER beginRransaction(), session.isOpen()"+session.isOpen());

    	try {
	    	if (this.getId()==0) {
	    		this.setCreateDate(now);
	    		session.save(this);
	    		objectId=this.getId();
	    	}
	    	else {
	    		session.update(this);
	    		objectId=this.getId();
	    	}
			transaction.commit();
		}
		catch (final RuntimeException e) {
			transaction.rollback();
			re=e;
		}
		//if (closeSession) {
		//	session.close();
		//}
		//else {
			SessionWrapper.closeIfNotNested(session);
		//}
    	
    	if (re!=null) {
			logger.error("Exception storing "+this.getClass().getName()+" instance with ID "+this.getId()+"; rethrowing...", re);
    		throw re;
    	}
    	return objectId;
    }
    
    
    public static int[] store(final Collection<AbstractDbObject> objects) {
    	return store(objects, new SessionWrapper());
    }
    
    protected static int[] store(final Collection<AbstractDbObject> objects, SessionWrapper session) {
    	if (objects==null) {
    		return null;
    	}
    	final int[] ids=new int[objects.size()];
    	RuntimeException re=null;
    	final Date now=new Date();
    	session=SessionWrapper.openIfNotOpen(session);
    	final Transaction transaction=beginTransaction(session);

    	final Iterator<AbstractDbObject> i=objects.iterator();
    	AbstractDbObject object;
    	int objectId;
    	int c=0;
		try {
			while (i.hasNext()) {
				object=i.next();
				object.setLastModifiedDate(now);
		    	if (object.getId()==0) {
		    		object.setCreateDate(now);
		    		objectId=((Integer)session.save(object)).intValue();
		    	}
		    	else {
		    		session.update(object);
		    		objectId=object.getId();
		    	}	
		    	ids[c]=objectId;
		    	c++;
			}
			transaction.commit();
		}
		catch (final RuntimeException e) {
			transaction.rollback();
			re=e;
		}
   	
		SessionWrapper.closeIfNotNested(session);
    	
    	if (re!=null) {
			logger.error("Exception storing Collection; rethrowing...", re);
    		throw re;
    	}
    	return ids;
    }
    
    public static Object[] delete(final Collection<AbstractDbObject> objects) {
    	return delete(objects, new SessionWrapper());
    }
    
    protected static Object[] delete(final Collection<AbstractDbObject> objects, SessionWrapper session) {
    	if (objects==null) {
    		return null;
    	}
    	final List<Integer> ids=new ArrayList<Integer>(objects.size());
    	session=SessionWrapper.openIfNotOpen(session);
    	RuntimeException re=null;
    	final Transaction transaction=beginTransaction(session);

		final Iterator<AbstractDbObject> i=objects.iterator();

    	AbstractDbObject object;
    	int objectId;
		try {
			while (i.hasNext()) {
				object=i.next();
				try {
					objectId=object.getId();
					session.delete(object);
					ids.add(objectId);
				}
				catch (final Exception e) {
					logger.error("Exception deleting collection; swallowing", e);
				}
			}
			transaction.commit();
		}
		catch (final RuntimeException e) {
			transaction.rollback();
			re=e;
		}
   	
		SessionWrapper.closeIfNotNested(session);
    	
    	if (re!=null) {
			logger.error("Exception deleting Collection "+objects+"; rethrowing...", re);
    		throw re;
    	}
    	return ids.toArray();
    }

    


	@Override
	public boolean equals(final Object o) {
		if (o==null) {
			return false;
		}
		return this.getComparableValue().equals(((AbstractDbObject)o).getComparableValue());
	}



	public int compareTo(final Object o) {
		return this.getComparableValue().compareTo(((AbstractDbObject)o).getComparableValue());
	}
  
	
	
	
	

	public int getId() {
		return id;
	}
	/** Private per Hibernate documentation suggestion.
	 * @param id
	 */
	private void setId(final int id) {
		this.id=id;
	}
	
	// Not sure why setId() is supposed to be private but Hibernate docs "suggest" it, so here's a public convenience version:
	public void publicSetId(final int id) {
		setId(id);
	}
	
	@Override
	public int hashCode() {
		return Integer.parseInt(getComparableValue().toString());
	}

	public Date getCreateDate() {
		return createDate;
	}
	protected void setCreateDate(final Date createDate) {
		this.createDate = createDate;
	}

	public Date getLastModifiedDate() {
		return lastModifiedDate;
	}
	protected void setLastModifiedDate(final Date lastModifiedDate) {
		this.lastModifiedDate = lastModifiedDate;
	}
	
	
	
}
