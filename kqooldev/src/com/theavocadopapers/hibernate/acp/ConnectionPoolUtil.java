package com.theavocadopapers.hibernate.acp;

import java.util.Properties;

public class ConnectionPoolUtil {

	private ConnectionPoolUtil() {}

	protected static int getIntPropValue(final Properties props, final String propNamePrefix, final String basePropName, final int defaultValue) {
		final String value=getPropValue(props, propNamePrefix, basePropName, ""+defaultValue);
		try {
			return Integer.parseInt(value);
		}
		catch (final NumberFormatException e) {
			throw new NumberFormatException("Property '"+basePropName+"' found, but couldn't parse value '"+value+"' as int.");
		}
	}

	protected static double getDoublePropValue(final Properties props, final String propNamePrefix, final String basePropName, final double defaultValue) {
		final String value=getPropValue(props, propNamePrefix, basePropName, ""+defaultValue);
		try {
			return Double.parseDouble(value);
		}
		catch (final NumberFormatException e) {
			throw new NumberFormatException("Property '"+basePropName+"' found, but couldn't parse value '"+value+"' as double.");
		}
	}

	protected static boolean getBooleanPropValue(final Properties props, final String propNamePrefix, final String basePropName, final boolean defaultValue) {
		return Boolean.parseBoolean(getPropValue(props, propNamePrefix, basePropName, ""+defaultValue));
	}

	protected static String getPropValue(final Properties props, final String propNamePrefix, final String basePropName, final String defaultValue) {
		if (props==null) {
			// Happens if no-arg constructor used:
			return defaultValue;
		}
		String value=props.getProperty(propNamePrefix+basePropName);
		if (value==null) {
			// try without the prefix, if there is a prefix (help clients who are using systems with 
			// potentially confusing naming structures for prop names, e.g. Hibernate:
			if (propNamePrefix.length()>0) {
				value=props.getProperty(basePropName);
			}
		}
		if (value==null) {
			value=defaultValue;
		}
		return value;
	}


}
