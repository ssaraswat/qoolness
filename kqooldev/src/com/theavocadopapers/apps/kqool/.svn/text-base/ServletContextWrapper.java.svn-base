/*
 * Created on Nov 12, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool;

import javax.servlet.ServletContext;
 

/**
 * @author Steve Schneider
 *
 */
public class ServletContextWrapper {

	private static Object ctx=new Object();
	
	private ServletContextWrapper() {}
	
	public static void init(final ServletContext context) {
		if (!(ctx instanceof ServletContext)) {
			synchronized(ctx) {
				ctx=context;
			}
		}
	}
	
	private static void initCheck() {
		if (!(ctx instanceof ServletContext)) {
			throw new IllegalStateException("ServletContextWrapper has not been initialized; call init() first.");
		}
	}
	
	public static ServletContext getCtx() {
		initCheck();
		return (ServletContext)ctx;
	}
	
	
}
