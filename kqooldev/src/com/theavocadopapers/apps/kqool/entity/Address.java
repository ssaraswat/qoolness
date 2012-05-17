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
public class Address extends AbstractDbObject {
	
	private static final Class currentClass=Address.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);

	protected String addressLine1;
	protected String addressLine2;
	protected String city;
	protected String stateProvinceCode;
	protected String region;
	protected String countryCode;
	protected String postalCode;
	protected String homeTelephone;
	protected String workTelephone;
	protected String mobileTelephone;	
	protected int userId;
	


	public static Address getById(final int id) {
		return (Address)getById(currentClass, id, false);
	}
	

	@Override
	protected Comparable getComparableValue() {
		return new Integer(getId());
	}

	public String getAddressLine1() {
		return this.addressLine1;
	}
	public void setAddressLine1(final String addressLine1) {
		this.addressLine1 = addressLine1;
	}
	public String getAddressLine2() {
		return this.addressLine2;
	}
	public void setAddressLine2(final String addressLine2) {
		this.addressLine2 = addressLine2;
	}
	public String getCity() {
		return this.city;
	}
	public void setCity(final String city) {
		this.city = city;
	}
	public String getCountryCode() {
		return this.countryCode;
	}
	public void setCountryCode(final String countryCode) {
		this.countryCode = countryCode;
	}
	public String getHomeTelephone() {
		return this.homeTelephone;
	}
	public void setHomeTelephone(final String homeTelephone) {
		this.homeTelephone = homeTelephone;
	}
	public String getMobileTelephone() {
		return this.mobileTelephone;
	}
	public void setMobileTelephone(final String mobileTelephone) {
		this.mobileTelephone = mobileTelephone;
	}
	public String getPostalCode() {
		return this.postalCode;
	}
	public void setPostalCode(final String postalCode) {
		this.postalCode = postalCode;
	}
	public String getRegion() {
		return this.region;
	}
	public void setRegion(final String region) {
		this.region = region;
	}
	public String getStateProvinceCode() {
		return this.stateProvinceCode;
	}
	public void setStateProvinceCode(final String stateProvinceCode) {
		this.stateProvinceCode = stateProvinceCode;
	}
	public int getUserId() {
		return this.userId;
	}
	public void setUserId(final int userId) {
		this.userId = userId;
	}
	public String getWorkTelephone() {
		return this.workTelephone;
	}
	public void setWorkTelephone(final String workTelephone) {
		this.workTelephone = workTelephone;
	}

	


	public static Address getByUserId(final int userId) {
		return (Address)getUniqueByField("userId", ""+userId, FIELD_TYPE_NUMERIC, currentClass, false);
	}


	public static List getAll() {
		return getAll(currentClass);
	}


	

	


}
