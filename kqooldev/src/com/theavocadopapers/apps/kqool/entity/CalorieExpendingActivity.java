/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.util.List;

import com.theavocadopapers.core.logging.Logger;

/**
 * @author sschneider
 *
 */
public class CalorieExpendingActivity extends AbstractDbObject {



	private static final Class currentClass=CalorieExpendingActivity.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);


	protected String name;
	protected double calsPerMinutePerLb;



	public static CalorieExpendingActivity getById(final int id) {
		return (CalorieExpendingActivity)getById(currentClass, id, true);
	}
	


	@Override
	protected Comparable getComparableValue() {
		return name;
	}

	public void delete()  {
		deleteById(currentClass, this.getId());
	}
	






	public static CalorieExpendingActivity getByName(final String name) {
		return (CalorieExpendingActivity)getUniqueByField("name", name, FIELD_TYPE_TEXTUAL, currentClass, true);
	}



	public String getName() {
		return name;
	}
	public void setName(final String name) {
		this.name = name;
	}



	
	public static List getAll() {
		return getAll(currentClass);
	}
		

	

	public double getCalsPerMinutePerLb() {
		return calsPerMinutePerLb;
	}
	public void setCalsPerMinutePerLb(final double calsPerMinutePerLb) {
		this.calsPerMinutePerLb = calsPerMinutePerLb;
	}
}
