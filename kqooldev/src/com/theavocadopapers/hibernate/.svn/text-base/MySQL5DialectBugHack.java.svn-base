package com.theavocadopapers.hibernate;

import java.sql.Types;

import org.hibernate.dialect.MySQL5Dialect;


public class MySQL5DialectBugHack extends MySQL5Dialect {

	public MySQL5DialectBugHack() {
		super();
		registerHibernateType(Types.LONGVARCHAR, 65535, "text");
	}
	

	
}
