/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.util.Date;

import com.theavocadopapers.core.logging.Logger;


/**
 * @author sschneider
 *
 */
public class UserHealthData extends AbstractDbObject {

	private static final Class currentClass=UserHealthData.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);

	
	public static final int SEX_MALE=1;
	public static final int SEX_FEMALE=2;
	
	protected Date birthDate;
	protected Double weight;
	protected Double targetWeight;
	protected Integer heightFeet;
	protected Double heightInches;
	protected Integer sex;
	protected Integer targetCaloricIntake;
	
	protected int userId;
	

	public static UserHealthData getById(final int id) {
		return (UserHealthData)getById(currentClass, id, false);
	}
	


	@Override
	protected Comparable getComparableValue() {
		return new Integer(getId());
	}




	public Date getBirthDate() {
		return this.birthDate;
	}
	public void setBirthDate(final Date birthDate) {
		this.birthDate = birthDate;
	}
	public Integer getHeightFeet() {
		return this.heightFeet;
	}
	public void setHeightFeet(final Integer heightFeet) {
		this.heightFeet = heightFeet;
	}
	public Double getHeightInches() {
		return this.heightInches;
	}
	public void setHeightInches(final Double heightInches) {
		this.heightInches = heightInches;
	}
	public Integer getSex() {
		return this.sex;
	}
	public void setSex(final Integer sex) {
		this.sex = sex;
	}
	public Integer getTargetCaloricIntake() {
		return this.targetCaloricIntake;
	}
	public void setTargetCaloricIntake(final Integer targetCaloricIntake) {
		this.targetCaloricIntake = targetCaloricIntake;
	}
	public int getUserId() {
		return this.userId;
	}
	public void setUserId(final int userId) {
		this.userId = userId;
	}
	public Double getWeight() {
		return this.weight;
	}
	public void setWeight(final Double weight) {
		this.weight = weight;
	}



	public Double getTargetWeight() {
		return targetWeight;
	}



	public void setTargetWeight(final Double targetWeight) {
		this.targetWeight = targetWeight;
	}
}
