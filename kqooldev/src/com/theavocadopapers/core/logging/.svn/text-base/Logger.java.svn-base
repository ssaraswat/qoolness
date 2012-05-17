package com.theavocadopapers.core.logging;

import java.net.InetAddress;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Logger {

	public static enum Type {DEBUG, INFO, WARN, ERROR, FATAL};
	public static final DateFormat DATE_FORMAT=new SimpleDateFormat("yy/MM/dd HH:mm:ss");
	private static boolean errorOnInit=false;
	private static Throwable errorOnInitThrowable=null;

	 
	
	public LogWriter writer=LogWriter.getInstance();
	
	Class clazz;
	String fullyQualifiedClazzName;
	String unqualifiedClazzName;
	String unqualifiedClazshold;
	String hostname;

	
	
	
	
	private Logger(final Class clazz) {
		try {
			this.hostname=null;
			try {
				// try for the domain name (this operation does a DNS lookup)...
				this.hostname=InetAddress.getLocalHost().getCanonicalHostName();
				// ...and then use just the subdomain:
				if (hostname.indexOf(".")>-1) {
					hostname=hostname.substring(0, hostname.indexOf("."));
				}
			}
			catch (final Exception e) {
				// no domain name, so try for the IP address...
				try {
					this.hostname=InetAddress.getLocalHost().getHostAddress();
				}
				catch (final Exception e1) {
					// ...can't get the IP, so go with this:
					this.hostname="unknown-host";
				}
			}
			
			if (clazz==null) {
				this.clazz=Object.class;
			}
			else {
				this.clazz=clazz;
			}
			this.fullyQualifiedClazzName=""+this.clazz.getName();
			try {
				this.unqualifiedClazzName=this.fullyQualifiedClazzName.substring(this.fullyQualifiedClazzName.lastIndexOf(".")+1, this.fullyQualifiedClazzName.length());
			}
			catch (final Exception e) {
				this.unqualifiedClazzName="unknown-class";
			}
		}
		catch (final Exception e) {
			errorOnInit=true;
			errorOnInitThrowable=e;
			System.out.println("Error initializing Logger...");
			e.printStackTrace();
		}
	}
	
	public static Logger getLogger(final Class clazz) {
		return new Logger(clazz);
	}
	
	public static Logger getRootLogger() {
		return new Logger(null);
	}
	
	protected void log(final Type type, final Object message, final Throwable t) {
		if (!errorOnInit) {
			try {
				final boolean logToStdout=type.equals(Type.FATAL);
				writer.log("["+hostname+"] "+new StringBuilder(DATE_FORMAT.format(new Date())).toString()+" - "+type.toString()+" "+this.unqualifiedClazzName, message.toString(), t, logToStdout);
			}
			catch (final Exception e) {}			
		}
	}

	public void debug(final Object message, final Throwable t) {
		log(Type.DEBUG, message, t);
	}
	public void info(final Object message, final Throwable t) {
		log(Type.INFO, message, t);
	}
	public void warn(final Object message, final Throwable t) {
		log(Type.WARN, message, t);
	}
	public void error(final Object message, final Throwable t) {
		log(Type.ERROR, message, t);
	}
	public void fatal(final Object message, final Throwable t) {
		log(Type.FATAL, message, t);
	}
	
	
	public void debug(final Object message) {
		debug(message, null);
	}
	public void info(final Object message) {
		info(message, null);
	}
	public void warn(final Object message) {
		warn(message, null);
	}
	public void error(final Object message) {
		error(message, null);
	}
	public void fatal(final Object message) {
		fatal(message, null);
	}

	

}
