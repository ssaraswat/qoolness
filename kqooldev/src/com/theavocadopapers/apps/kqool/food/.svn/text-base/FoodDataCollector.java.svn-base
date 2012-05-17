package com.theavocadopapers.apps.kqool.food;

import java.util.List;

import com.theavocadopapers.apps.kqool.food.ck.CkFoodDataCollector;
import com.theavocadopapers.apps.kqool.util.MailUtils;
import com.theavocadopapers.core.logging.Logger;

public class FoodDataCollector {
	
	private static final Logger logger = Logger.getLogger(FoodDataCollector.class);
	
	public static int CALORIEKING_REST_API=1;
	
	public static int FOOD_DATA_SOURCE=CALORIEKING_REST_API;
	
	/** Null return value always means there was an exception (probably API is down)
	 * @param keywords
	 * @param controller 
	 * @param pageContext 
	 * @return
	 */
	public static List<Food> searchForFoodsByKeywords(final String keywords) {
		try {
			if (FOOD_DATA_SOURCE==CALORIEKING_REST_API) {
				return CkFoodDataCollector.searchForFoodsByKeywords(keywords);
			}
			throw new RuntimeException("The FOOD_DATA_SOURCE value ("+FOOD_DATA_SOURCE+") is not recognized.");
		}
		catch (final Exception e) {
			MailUtils.sendExceptionReport(e);
			logger.error("Exception getting results for keywords "+keywords+"; sending exception mail and returning null", e);
			return null;
		}
	}
	
	/** Null return value always means there was an exception (probably API is down)
	 * @param food
	 * @param controller 
	 * @param pageContext 
	 * @return
	 */
	public static List<Serving> getNutrientDataForServings(final String foodId) {
		try {
			if (FOOD_DATA_SOURCE==CALORIEKING_REST_API) {
				return CkFoodDataCollector.getNutrientDataForServings(foodId);
			}
			throw new RuntimeException("The FOOD_DATA_SOURCE value ("+FOOD_DATA_SOURCE+") is not recognized.");
		}
		catch (final Exception e) {
			MailUtils.sendExceptionReport(e);
			logger.error("Exception getting nutritional info for Food with ID "+foodId+"; sending exception mail and returning null", e);
			return null;			
		}
	}
	
	
	
	public static void main(final String[] arr) {
		final List<Food> foods=searchForFoodsByKeywords("milk");
		logger.info("Foods list (size="+foods.size()+"):");
		for (final Food food : foods) {
			logger.info(food);
		}
		// get nutrients for first Food item:
		//final List<Serving> servings=getNutrientDataForServings(foods.get(0));
		//logger.info("\n\nServings list for first Food in list: (size="+servings.size()+"):");
		//for (final Serving serving : servings) {
		//	logger.info(serving);
		//}		
	}
	
}
