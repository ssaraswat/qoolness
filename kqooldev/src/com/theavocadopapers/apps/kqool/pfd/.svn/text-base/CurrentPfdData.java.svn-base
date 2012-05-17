package com.theavocadopapers.apps.kqool.pfd;

import java.util.HashMap;
import java.util.Map;

import com.theavocadopapers.apps.kqool.entity.PfdItem;

public class CurrentPfdData {
	
	private int userId;
	private int settingUserId;
	private int heightFeet;
	private int heightInches;
	private int weight;
	private int targetWeight;
	private String activityLevel="";
	private String currentlyExercise="";
	private String howLongExercise="";
	private boolean exercisedInPast;
	private boolean previousTrainingProgram;
	private boolean previousPersonalTrainingProgram;
	private String currentWorkout="";
	private String goals="";
	private String comments="";
	private boolean heartAttackOrDisease;
	private boolean coronaryBypass;
	private boolean otherCardiacSurgery;
	private boolean pacemaker;
	private boolean embolism;
	private boolean stroke;
	private boolean aneurysm;
	private boolean anginaPectoris;
	private boolean peripheralVascularDisease;
	private boolean thyroidProblems;
	private boolean phlebitis;
	private boolean chronicBronchitis;
	private boolean emphysema;
	private boolean diabetes;
	private boolean asthma;
	private boolean chestPain;
	private boolean lightheadednessFainting;
	private boolean palpitations;
	private boolean heartMurmur;
	private boolean breathlessnessWakesYouUp;
	private boolean ankleSwelling;
	private boolean shortnessOfBreath;
	private boolean dizziness;
	private boolean highBP;
	private boolean highCholesterol;
	private boolean smokedCigarettes;
	private boolean atheroscleroticDiseaseHistory;
	private boolean pregnant;
	private String takingMedications="";
	private String specialDiet="";
	private String specialPhysicalConditions="";
	private String whyOnlineTraining="";
	private String whatMotivatesAboutPersonalTraining="";
	private String whatsImprovedMost="";
	
	private boolean noExistingData;
	
	private Map<String,PfdItem> currentItemsMap;
	
	
	private CurrentPfdData() {}
	
	public static boolean isCurrentPfdDataExists(final int userId) {
		return PfdItem.isUserHasCurrentItems(userId);
	}
	
	public static CurrentPfdData getByUserId(final int userId, final int settingUserId) {
		final CurrentPfdData data=new CurrentPfdData();
		data.setUserId(userId);
		data.setSettingUserId(settingUserId);
		data.currentItemsMap=PfdItem.getCurrentByUserIdAsMap(userId);
		if (data.currentItemsMap!=null && data.currentItemsMap.size()>0) {
			data.setNoExistingData(false);
			data.setActivityLevel(getNonNullStringItemValue(data.currentItemsMap.get(PfdConstants.CODE_ACTIVITY_LEVEL)));
			data.setAneurysm(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_ANEURISM)));
			data.setAnginaPectoris(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_ANGINA_PECTORIS)));
			data.setAnkleSwelling(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_ANKLE_SWELLING)));
			data.setAsthma(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_ASTHMA)));
			data.setAtheroscleroticDiseaseHistory(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_ATHEROSCLEROTIC_DISEASE_HISTORY)));
			data.setBreathlessnessWakesYouUp(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_BREATHLESSNESS_WAKES_YOU_UP)));
			data.setChestPain(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_CHEST_PAIN)));
			data.setChronicBronchitis(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_CHRONIC_BRONCHITIS)));
			data.setComments(getNonNullStringItemValue(data.currentItemsMap.get(PfdConstants.CODE_COMMENTS)));
			data.setCoronaryBypass(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_CORONARY_BYPASS)));
			data.setCurrentlyExercise(getNonNullStringItemValue(data.currentItemsMap.get(PfdConstants.CODE_CURRENTLY_EXERCISE)));
			data.setCurrentWorkout(getNonNullStringItemValue(data.currentItemsMap.get(PfdConstants.CODE_CURRENT_WORKOUT)));
			data.setDiabetes(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_DIABETES)));
			data.setDizziness(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_DIZZINESS)));
			data.setEmbolism(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_EMBOLISM)));
			data.setEmphysema(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_EMPHYSEMA)));
			data.setExercisedInPast(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_EXERCISED_IN_PAST)));
			data.setGoals(getNonNullStringItemValue(data.currentItemsMap.get(PfdConstants.CODE_GOALS)));
			data.setHeartAttackOrDisease(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_HEART_ATTACK_OR_DISEASE)));
			data.setHeartMurmur(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_HEART_MURMUR)));
			data.setHeightFeet(getIntItemValue(data.currentItemsMap.get(PfdConstants.CODE_HEIGHT_FEET)));
			data.setHeightInches(getIntItemValue(data.currentItemsMap.get(PfdConstants.CODE_HEIGHT_INCHES)));
			data.setHighBP(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_HIGH_BP)));
			data.setHighCholesterol(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_HIGH_CHOLESTEROL)));
			data.setHowLongExercise(getNonNullStringItemValue(data.currentItemsMap.get(PfdConstants.CODE_HOW_LONG_EXERCIST)));
			data.setLightheadednessFainting(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_LIGHTHEADEDNESS_FAINTING)));
			data.setOtherCardiacSurgery(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_OTHER_CARDIAC_SURGERY)));
			data.setPacemaker(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_PACEMAKER)));
			data.setPalpitations(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_PALPITATIONS)));
			data.setPeripheralVascularDisease(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_PERIPHERAL_VASCULAR_DISEASE)));
			data.setPhlebitis(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_PHLEBITIS)));
			data.setPregnant(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_PREGNANT)));
			data.setPreviousPersonalTrainingProgram(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_PREVIOUS_PERSONAL_TRAINING_PROGRAM)));
			data.setPreviousTrainingProgram(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_PREVIOUS_TRAINING_PROGRAM)));
			data.setShortnessOfBreath(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_SHORTNESS_OF_BREATH)));
			data.setSmokedCigarettes(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_SMOKED_CIGARETTES)));
			data.setSpecialDiet(getNonNullStringItemValue(data.currentItemsMap.get(PfdConstants.CODE_SPECIAL_DIET)));
			data.setSpecialPhysicalConditions(getNonNullStringItemValue(data.currentItemsMap.get(PfdConstants.CODE_SPECIAL_PHYSICAL_CONDITIONS)));
			data.setStroke(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_STROKE)));
			data.setTakingMedications(getNonNullStringItemValue(data.currentItemsMap.get(PfdConstants.CODE_TAKING_MEDICATIONS)));
			data.setThyroidProblems(getBooleanItemValue(data.currentItemsMap.get(PfdConstants.CODE_THYROID_PROBLEMS)));
			data.setWeight(getIntItemValue(data.currentItemsMap.get(PfdConstants.CODE_WEIGHT)));
			data.setTargetWeight(getIntItemValue(data.currentItemsMap.get(PfdConstants.CODE_TARGET_WEIGHT)));
			data.setWhatMotivatesAboutPersonalTraining(getNonNullStringItemValue(data.currentItemsMap.get(PfdConstants.CODE_WHAT_MOTIVATED_ABOUT_PERSONAL_TRAINING)));
			data.setWhatsImprovedMost(getNonNullStringItemValue(data.currentItemsMap.get(PfdConstants.CODE_WHATS_IMPROVED_MOST)));
			data.setWhyOnlineTraining(getNonNullStringItemValue(data.currentItemsMap.get(PfdConstants.CODE_WHY_ONLINE_TRAINING)));
		}
		else {
			data.setNoExistingData(true);
		}
		return data;
	}

	public String getCurrentItemValue(final String code) {
		if (this.currentItemsMap==null) {
			// will be the case if this is a new user who has no data stored yet:
			return "";
		}
		final PfdItem item=this.currentItemsMap.get(code);
		if (item==null || item.getValue()==null) {
			return "";
		}
		return item.getValue();
	}
	
	public Map save(final Map params, final boolean noExistingData) {
		return save(params, noExistingData, false);
	}
	
	/** Returns a map of items whose values were changed; keys are item codes, values are values
	 * @param params
	 * @param noExistingData
	 * @return
	 */
	public Map save(final Map params, final boolean noExistingData, final boolean weightFieldsOnly) {
		String code;
		String value;
		final Map<String,String> changedItemCodesToValues=new HashMap<String,String>(100);
			
		
		code=PfdConstants.CODE_WEIGHT;
		value=((String[])params.get(code))[0];
		if (noExistingData || this.getWeight()!=Integer.parseInt(value)) {
			storeNewPfdItem(code, value, changedItemCodesToValues);
		}		
		code=PfdConstants.CODE_TARGET_WEIGHT;
		value=((String[])params.get(code))[0];
		if (noExistingData || this.getTargetWeight()!=Integer.parseInt(value)) {
			storeNewPfdItem(code, value, changedItemCodesToValues);
		}		
		if (!weightFieldsOnly) {
			code=PfdConstants.CODE_ACTIVITY_LEVEL;
			value=((String[])params.get(code))[0];
			if (!this.getActivityLevel().equals(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_ANEURISM;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isAneurysm()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_ANGINA_PECTORIS;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isAnginaPectoris()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_ANKLE_SWELLING;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isAnkleSwelling()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_ASTHMA;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isAsthma()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_ATHEROSCLEROTIC_DISEASE_HISTORY;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isAtheroscleroticDiseaseHistory()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_BREATHLESSNESS_WAKES_YOU_UP;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isBreathlessnessWakesYouUp()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_CHEST_PAIN;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isChestPain()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_CHRONIC_BRONCHITIS;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isChronicBronchitis()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_COMMENTS;
			value=((String[])params.get(code))[0];
			if (!this.getComments().equals(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}
			code=PfdConstants.CODE_CORONARY_BYPASS;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isCoronaryBypass()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_CURRENTLY_EXERCISE;
			value=((String[])params.get(code))[0];
			if (!this.getCurrentlyExercise().equals(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}
			code=PfdConstants.CODE_CURRENT_WORKOUT;
			value=((String[])params.get(code))[0];
			if (!this.getCurrentWorkout().equals(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}
			code=PfdConstants.CODE_DIABETES;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isDiabetes()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_DIZZINESS;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isDizziness()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_EMBOLISM;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isEmbolism()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_EMPHYSEMA;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isEmphysema()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_EXERCISED_IN_PAST;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isExercisedInPast()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_GOALS;
			value=((String[])params.get(code))[0];
			if (!this.getGoals().equals(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}
			code=PfdConstants.CODE_HEART_ATTACK_OR_DISEASE;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isHeartAttackOrDisease()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_HEART_MURMUR;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isHeartMurmur()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_HEIGHT_INCHES;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.getHeightInches()!=Integer.parseInt(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}		
			code=PfdConstants.CODE_HEIGHT_FEET;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.getHeightFeet()!=Integer.parseInt(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}		
			code=PfdConstants.CODE_HIGH_BP;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isHighBP()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_HIGH_CHOLESTEROL;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isHighCholesterol()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_HOW_LONG_EXERCIST;
			value=((String[])params.get(code))[0];
			if (!this.getHowLongExercise().equals(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}
			code=PfdConstants.CODE_LIGHTHEADEDNESS_FAINTING;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isLightheadednessFainting()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_OTHER_CARDIAC_SURGERY;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isOtherCardiacSurgery()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_PACEMAKER;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isPacemaker()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_PALPITATIONS;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isPalpitations()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_PERIPHERAL_VASCULAR_DISEASE;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isPeripheralVascularDisease()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_PHLEBITIS;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isPhlebitis()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_PREGNANT;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isPregnant()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_PREVIOUS_PERSONAL_TRAINING_PROGRAM;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isPreviousPersonalTrainingProgram()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_PREVIOUS_TRAINING_PROGRAM;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isPreviousTrainingProgram()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_SHORTNESS_OF_BREATH;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isShortnessOfBreath()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_SMOKED_CIGARETTES;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isSmokedCigarettes()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_SPECIAL_DIET;
			value=((String[])params.get(code))[0];
			if (!this.getSpecialDiet().equals(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}
			code=PfdConstants.CODE_SPECIAL_PHYSICAL_CONDITIONS;
			value=((String[])params.get(code))[0];
			if (!this.getSpecialPhysicalConditions().equals(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}
			code=PfdConstants.CODE_STROKE;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isStroke()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}				
			code=PfdConstants.CODE_TAKING_MEDICATIONS;
			value=((String[])params.get(code))[0];
			if (!this.getTakingMedications().equals(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}
			code=PfdConstants.CODE_THYROID_PROBLEMS;
			value=((String[])params.get(code))[0];
			if (noExistingData || this.isThyroidProblems()!=Boolean.parseBoolean(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}		
			code=PfdConstants.CODE_WHAT_MOTIVATED_ABOUT_PERSONAL_TRAINING;
			value=((String[])params.get(code))[0];
			if (!this.getWhatMotivatesAboutPersonalTraining().equals(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}
			code=PfdConstants.CODE_WHATS_IMPROVED_MOST;
			value=((String[])params.get(code))[0];
			if (!this.getWhatsImprovedMost().equals(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}
			code=PfdConstants.CODE_WHY_ONLINE_TRAINING;
			value=((String[])params.get(code))[0];
			if (!this.getWhyOnlineTraining().equals(value)) {
				storeNewPfdItem(code, value, changedItemCodesToValues);
			}
		}
		return changedItemCodesToValues;
	}
	
	
	private void storeNewPfdItem(final String itemCode, final String itemValue, final Map<String,String> changedItemCodesToValues) {
		PfdItem storedItem=null;
		if (this.currentItemsMap!=null) {
			storedItem=this.currentItemsMap.get(itemCode);
		}
		final PfdItem newItem;
		if (storedItem==null) {
			newItem=new PfdItem();
			newItem.setCode(itemCode);
			newItem.setUserId(userId);
		}
		else {
			newItem=new PfdItem(storedItem);
		}
		newItem.setValue(itemValue);
		newItem.store(this.settingUserId);
		changedItemCodesToValues.put(itemCode, itemValue);
	}

	protected static String getNonNullStringItemValue(final PfdItem item) {
		if (item==null || item.getValue()==null) {
			return "";
		}
		return item.getValue();
	}
	
	protected static boolean getBooleanItemValue(final PfdItem item) {
		if (item==null) {
			return false;
		}
		return item.getValue().equals("true");
	}
	
	protected static int getIntItemValue(final PfdItem item) {
		if (item==null || item.getValue().length()==0) {
			return 0;
		}
		try {
			return Integer.parseInt(item.getValue());
		}
		catch (final NumberFormatException e) {
			return (int)Double.parseDouble(item.getValue());
		}
	}
	
	protected static double getDoubleItemValue(final PfdItem item) {
		if (item==null || item.getValue().length()==0) {
			return 0.0;
		}
		return Double.parseDouble(item.getValue());
	}
	
		
		
	protected void setUserId(final int userId) {
		this.userId = userId;
	}
	protected void setHeightFeet(final int heightFeet) {
		this.heightFeet = heightFeet;
	}
	protected void setHeightInches(final int heightInches) {
		this.heightInches = heightInches;
	}
	protected void setWeight(final int weight) {
		this.weight = weight;
	}
	protected void setTargetWeight(final int targetWeight) {
		this.targetWeight = targetWeight;
	}
	protected void setActivityLevel(final String activityLevel) {
		this.activityLevel = activityLevel;
	}
	protected void setCurrentlyExercise(final String currentlyExercise) {
		this.currentlyExercise = currentlyExercise;
	}
	protected void setHowLongExercise(final String howLongExercise) {
		this.howLongExercise = howLongExercise;
	}
	protected void setExercisedInPast(final boolean exercisedInPast) {
		this.exercisedInPast = exercisedInPast;
	}
	protected void setPreviousTrainingProgram(final boolean previousTrainingProgram) {
		this.previousTrainingProgram = previousTrainingProgram;
	}
	protected void setPreviousPersonalTrainingProgram(
			final boolean previousPersonalTrainingProgram) {
		this.previousPersonalTrainingProgram = previousPersonalTrainingProgram;
	}
	protected void setCurrentWorkout(final String currentWorkout) {
		this.currentWorkout = currentWorkout;
	}
	protected void setGoals(final String goals) {
		this.goals = goals;
	}
	protected void setComments(final String comments) {
		this.comments = comments;
	}
	protected void setHeartAttackOrDisease(final boolean heartAttackOrDisease) {
		this.heartAttackOrDisease = heartAttackOrDisease;
	}
	protected void setCoronaryBypass(final boolean coronaryBypass) {
		this.coronaryBypass = coronaryBypass;
	}
	protected void setOtherCardiacSurgery(final boolean otherCardiacSurgery) {
		this.otherCardiacSurgery = otherCardiacSurgery;
	}
	protected void setPacemaker(final boolean pacemaker) {
		this.pacemaker = pacemaker;
	}
	protected void setEmbolism(final boolean embolism) {
		this.embolism = embolism;
	}
	protected void setStroke(final boolean stroke) {
		this.stroke = stroke;
	}
	protected void setAneurysm(final boolean aneurysm) {
		this.aneurysm = aneurysm;
	}
	protected void setAnginaPectoris(final boolean anginaPectoris) {
		this.anginaPectoris = anginaPectoris;
	}
	protected void setPeripheralVascularDisease(final boolean peripheralVascularDisease) {
		this.peripheralVascularDisease = peripheralVascularDisease;
	}
	protected void setThyroidProblems(final boolean thyroidProblems) {
		this.thyroidProblems = thyroidProblems;
	}
	protected void setPhlebitis(final boolean phlebitis) {
		this.phlebitis = phlebitis;
	}
	protected void setChronicBronchitis(final boolean chronicBronchitis) {
		this.chronicBronchitis = chronicBronchitis;
	}
	protected void setEmphysema(final boolean emphysema) {
		this.emphysema = emphysema;
	}
	protected void setDiabetes(final boolean diabetes) {
		this.diabetes = diabetes;
	}
	protected void setAsthma(final boolean asthma) {
		this.asthma = asthma;
	}
	protected void setChestPain(final boolean chestPain) {
		this.chestPain = chestPain;
	}
	protected void setLightheadednessFainting(final boolean lightheadednessFainting) {
		this.lightheadednessFainting = lightheadednessFainting;
	}
	protected void setPalpitations(final boolean palpitations) {
		this.palpitations = palpitations;
	}
	protected void setHeartMurmur(final boolean heartMurmur) {
		this.heartMurmur = heartMurmur;
	}
	protected void setBreathlessnessWakesYouUp(final boolean breathlessnessWakesYouUp) {
		this.breathlessnessWakesYouUp = breathlessnessWakesYouUp;
	}
	protected void setAnkleSwelling(final boolean ankleSwelling) {
		this.ankleSwelling = ankleSwelling;
	}
	protected void setShortnessOfBreath(final boolean shortnessOfBreath) {
		this.shortnessOfBreath = shortnessOfBreath;
	}
	protected void setDizziness(final boolean dizziness) {
		this.dizziness = dizziness;
	}
	protected void setHighBP(final boolean highBP) {
		this.highBP = highBP;
	}
	protected void setHighCholesterol(final boolean highCholesterol) {
		this.highCholesterol = highCholesterol;
	}
	protected void setSmokedCigarettes(final boolean smokedCigarettes) {
		this.smokedCigarettes = smokedCigarettes;
	}
	protected void setAtheroscleroticDiseaseHistory(
			final boolean atheroscleroticDiseaseHistory) {
		this.atheroscleroticDiseaseHistory = atheroscleroticDiseaseHistory;
	}
	protected void setPregnant(final boolean pregnant) {
		this.pregnant = pregnant;
	}
	protected void setTakingMedications(final String takingMedications) {
		this.takingMedications = takingMedications;
	}
	protected void setSpecialDiet(final String specialDiet) {
		this.specialDiet = specialDiet;
	}
	protected void setSpecialPhysicalConditions(final String specialPhysicalConditions) {
		this.specialPhysicalConditions = specialPhysicalConditions;
	}
	protected void setWhyOnlineTraining(final String whyOnlineTraining) {
		this.whyOnlineTraining = whyOnlineTraining;
	}
	protected void setWhatMotivatesAboutPersonalTraining(
			final String whatMotivatesAboutPersonalTraining) {
		this.whatMotivatesAboutPersonalTraining = whatMotivatesAboutPersonalTraining;
	}
	protected void setWhatsImprovedMost(final String whatsImprovedMost) {
		this.whatsImprovedMost = whatsImprovedMost;
	}
	protected void setSettingUserId(final int settingUserId) {
		this.settingUserId = settingUserId;
	}
	
	
	
	public int getUserId() {
		return userId;
	}
	public int getHeightFeet() {
		return heightFeet;
	}
	public int getHeightInches() {
		return heightInches;
	}
	public int getWeight() {
		return weight;
	}
	public int getTargetWeight() {
		return targetWeight;
	}
	public String getActivityLevel() {
		return activityLevel;
	}
	public String getCurrentlyExercise() {
		return currentlyExercise;
	}
	public String getHowLongExercise() {
		return howLongExercise;
	}
	public boolean isExercisedInPast() {
		return exercisedInPast;
	}
	public boolean isPreviousTrainingProgram() {
		return previousTrainingProgram;
	}
	public boolean isPreviousPersonalTrainingProgram() {
		return previousPersonalTrainingProgram;
	}
	public String getCurrentWorkout() {
		return currentWorkout;
	}
	public String getGoals() {
		return goals;
	}
	public String getComments() {
		return comments;
	}
	public boolean isHeartAttackOrDisease() {
		return heartAttackOrDisease;
	}
	public boolean isCoronaryBypass() {
		return coronaryBypass;
	}
	public boolean isOtherCardiacSurgery() {
		return otherCardiacSurgery;
	}
	public boolean isPacemaker() {
		return pacemaker;
	}
	public boolean isEmbolism() {
		return embolism;
	}
	public boolean isStroke() {
		return stroke;
	}
	public boolean isAneurysm() {
		return aneurysm;
	}
	public boolean isAnginaPectoris() {
		return anginaPectoris;
	}
	public boolean isPeripheralVascularDisease() {
		return peripheralVascularDisease;
	}
	public boolean isThyroidProblems() {
		return thyroidProblems;
	}
	public boolean isPhlebitis() {
		return phlebitis;
	}
	public boolean isChronicBronchitis() {
		return chronicBronchitis;
	}
	public boolean isEmphysema() {
		return emphysema;
	}
	public boolean isDiabetes() {
		return diabetes;
	}
	public boolean isAsthma() {
		return asthma;
	}
	public boolean isChestPain() {
		return chestPain;
	}
	public boolean isLightheadednessFainting() {
		return lightheadednessFainting;
	}
	public boolean isPalpitations() {
		return palpitations;
	}
	public boolean isHeartMurmur() {
		return heartMurmur;
	}
	public boolean isBreathlessnessWakesYouUp() {
		return breathlessnessWakesYouUp;
	}
	public boolean isAnkleSwelling() {
		return ankleSwelling;
	}
	public boolean isShortnessOfBreath() {
		return shortnessOfBreath;
	}
	public boolean isDizziness() {
		return dizziness;
	}
	public boolean isHighBP() {
		return highBP;
	}
	public boolean isHighCholesterol() {
		return highCholesterol;
	}
	public boolean isSmokedCigarettes() {
		return smokedCigarettes;
	}
	public boolean isAtheroscleroticDiseaseHistory() {
		return atheroscleroticDiseaseHistory;
	}
	public boolean isPregnant() {
		return pregnant;
	}
	public String getTakingMedications() {
		return takingMedications;
	}
	public String getSpecialDiet() {
		return specialDiet;
	}
	public String getSpecialPhysicalConditions() {
		return specialPhysicalConditions;
	}
	public String getWhyOnlineTraining() {
		return whyOnlineTraining;
	}
	public String getWhatMotivatesAboutPersonalTraining() {
		return whatMotivatesAboutPersonalTraining;
	}
	public String getWhatsImprovedMost() {
		return whatsImprovedMost;
	}
	public int getSettingUserId() {
		return settingUserId;
	}

	public boolean isNoExistingData() {
		return noExistingData;
	}

	public void setNoExistingData(final boolean noExistingData) {
		this.noExistingData = noExistingData;
	}


	
	
	
	
	

	
}
