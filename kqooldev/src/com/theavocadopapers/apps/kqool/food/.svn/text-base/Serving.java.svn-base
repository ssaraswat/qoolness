package com.theavocadopapers.apps.kqool.food;

public abstract class Serving {

	private String name;
	private double calories;
	private double fat;
	private double carb;
	private double protein;
	private double fiber;
	private double sugar;
	private double sodium;
	private double calcium;
	private double satfat;
	private double cholesterol;
	public double getCalories() {
		return calories;
	}
	
	public Serving() {}
	
	public Serving(final String name, final double calories, final double fat, final double carb, final double protein, final double fiber, final double sugar, final double sodium, final double calcium, final double satfat, final double cholesterol) {
		setName(name);
		this.calories = calories;
		this.fat = fat;
		this.carb = carb;
		this.protein = protein;
		this.fiber = fiber;
		this.sugar = sugar;
		this.sodium = sodium;
		this.calcium = calcium;
		this.satfat = satfat;
		this.cholesterol = cholesterol;
	}






	public void setCalories(final double calories) {
		this.calories = calories;
	}
	public double getFat() {
		return fat;
	}
	public void setFat(final double fat) {
		this.fat = fat;
	}
	public double getCarb() {
		return carb;
	}
	public void setCarb(final double carb) {
		this.carb = carb;
	}
	public double getProtein() {
		return protein;
	}
	public void setProtein(final double protein) {
		this.protein = protein;
	}
	public double getFiber() {
		return fiber;
	}
	public void setFiber(final double fiber) {
		this.fiber = fiber;
	}
	public double getSugar() {
		return sugar;
	}
	public void setSugar(final double sugar) {
		this.sugar = sugar;
	}
	public double getSodium() {
		return sodium;
	}
	public void setSodium(final double sodium) {
		this.sodium = sodium;
	}
	public double getCalcium() {
		return calcium;
	}
	public void setCalcium(final double calcium) {
		this.calcium = calcium;
	}
	public double getSatfat() {
		return satfat;
	}
	public void setSatfat(final double satfat) {
		this.satfat = satfat;
	}
	public double getCholesterol() {
		return cholesterol;
	}
	public void setCholesterol(final double cholesterol) {
		this.cholesterol = cholesterol;
	}
	public void setName(final String name) {
		String parsedName=new String(name);
		if (parsedName.trim().equalsIgnoreCase("fl. oz (1 fl.oz)")) {
			parsedName="fl. oz";
		}
		else if (parsedName.trim().equalsIgnoreCase("fl. oz (1 fl. oz)")) {
			parsedName="fl. oz";
		}
		else if (parsedName.trim().equalsIgnoreCase("oz (1 oz)")) {
			parsedName="oz";
		}

		parsedName=parsedName.replaceAll("\\.0.", " ");

		this.name = parsedName;
	}
	public String getName() {
		return name;
	}

	@Override
	public String toString() {
		return new StringBuilder("[Serving: name="+name+"; calories="+calories+"; fat="+fat+"; carb="+carb+"; "
				+"protein="+protein+"; fiber="+fiber+"; sugar="+sugar+"; sodium="+sodium+"; calcium="+calcium+"; "
				+"satfat="+satfat+"; cholesterol="+cholesterol+"; ]").toString();
	}
	
}
