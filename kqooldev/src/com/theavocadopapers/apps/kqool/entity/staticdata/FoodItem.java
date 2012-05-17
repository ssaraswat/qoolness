/*
 * Created on Apr 11, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity.staticdata;



/**
 * @author sschneider
 *
 */
public class FoodItem extends StaticDataObject {


	public FoodItem(final String name, final String servingUnit, final float servingSize, final int caloriesPerServing, final int proteinGramsPerServing, final int fatGramsPerServing, final int carbGramsPerServing) {
		super(TYPE_FOOD_ITEM);
		setLabel(name);
		setString255Char(servingUnit);
		setFloat1(servingSize);
		setInt1(caloriesPerServing);
		setInt2(proteinGramsPerServing);
		setInt3(fatGramsPerServing);
		setInt4(carbGramsPerServing);
	}
	
	public String getName() {
		return getLabel();
	}
	
	public String getServingUnit() {
		return getString255Char();
	}

	public Float getServingSize() {
		return getFloat1();
	}
	
	public int getCaloriesPerServing() {
		return getInt1();
	}

	public int getFatGramsPerServing() {
		return getInt2();
	}

	public int getProteinGramsPerServing() {
		return getInt3();
	}

	public int getCarbGramsPerServing() {
		return getInt4();
	}


}
