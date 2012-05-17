package com.theavocadopapers.apps.kqool.food.ck;

import org.xml.sax.SAXException;

import com.theavocadopapers.core.logging.Logger;
 
	
	public class CkServingsContentHandler extends CkContentHandler {

		
		private static final Logger logger = Logger.getLogger(CkServingsContentHandler.class);
		
		public static final String FOOD_ELEMENT_NAME="food";
		public static final String ID_ELEMENT_NAME="id";
		public static final String NAME_ELEMENT_NAME="name";
		public static final String SERVINGS_ELEMENT_NAME="servings";
		public static final String SERVING_ELEMENT_NAME="serving";
		public static final String NUTRIENTS_ELEMENT_NAME="nutrients";
		public static final String CALORIES_ELEMENT_NAME="calories";
		public static final String FAT_ELEMENT_NAME="fat";
		public static final String CARB_ELEMENT_NAME="carb";
		public static final String PROTEIN_ELEMENT_NAME="protein";
		public static final String FIBER_ELEMENT_NAME="fiber";
		public static final String SUGAR_ELEMENT_NAME="sugar";
		public static final String SODIUM_ELEMENT_NAME="sodium";
		public static final String CALCIUM_ELEMENT_NAME="calcium";		
		public static final String SATFAT_ELEMENT_NAME="satfat";
		public static final String CHOLESTEROL_ELEMENT_NAME="cholesterol";
	

		private boolean foodNameParsed=false;
		


		private String currentServingName;
		private String currentServingCalories;
		private String currentServingFat;
		private String currentServingCarb;
		private String currentServingProtein;
		private String currentServingFiber;
		private String currentServingSugar;
		private String currentServingSodium;
		private String currentServingCalcium;
		private String currentServingSatfat;
		private String currentServingCholesterol;



		public void endElement(final String uri, final String localName, final String qName) throws SAXException {
			logger.info("endElement: " + localName + "\n");

			if (localName.equals(FOOD_ELEMENT_NAME)) {
				// do nothing; this is the end of the document
			}
			else if (localName.equals(ID_ELEMENT_NAME)) {
				// do nothing; we already know what this Food's id is
			}
			else if (localName.equals(NAME_ELEMENT_NAME)) {
				// this could be the food's name or the serving's name; if the former, we dont' care; if the latter, we do (we know that the former also comes first in the doc):
				if (!foodNameParsed) {
					foodNameParsed=true;
				}
				else {
					currentServingName=new String(currentElementValue);
				}
			}
			else if (localName.equals(SERVINGS_ELEMENT_NAME)) {
				// do nothing
			}
			else if (localName.equals(NUTRIENTS_ELEMENT_NAME)) {
				// the end of a serving element, so add a Food to our list:
				listItems.add(new CkServing(
						currentServingName, 
						parseDouble(currentServingCalories), 
						parseDouble(currentServingFat), 
						parseDouble(currentServingCarb), 
						parseDouble(currentServingProtein), 
						parseDouble(currentServingFiber), 
						parseDouble(currentServingSugar), 
						parseDouble(currentServingSodium), 
						parseDouble(currentServingCalcium), 
						parseDouble(currentServingSatfat), 
						parseDouble(currentServingCholesterol)
						)
				); 
			}
			else if (localName.equals(SERVING_ELEMENT_NAME)) {
				//do nothing
			}
			
			// Deal with the nutrients (the remaining fields):
			else if (localName.equals(CALORIES_ELEMENT_NAME)) {
				currentServingCalories=new String(currentElementValue);
			}
			else if (localName.equals(FAT_ELEMENT_NAME)) {
				currentServingFat=new String(currentElementValue);
			}
			else if (localName.equals(CARB_ELEMENT_NAME)) {
				currentServingCarb=new String(currentElementValue);
			}
			else if (localName.equals(PROTEIN_ELEMENT_NAME)) {
				currentServingProtein=new String(currentElementValue);
			}
			else if (localName.equals(FIBER_ELEMENT_NAME)) {
				currentServingFiber=new String(currentElementValue);
			}
			else if (localName.equals(SUGAR_ELEMENT_NAME)) {
				currentServingSugar=new String(currentElementValue);
			}
			else if (localName.equals(SODIUM_ELEMENT_NAME)) {
				currentServingSodium=new String(currentElementValue);
			}
			else if (localName.equals(CALCIUM_ELEMENT_NAME)) {
				currentServingCalcium=new String(currentElementValue);
			}
			else if (localName.equals(SATFAT_ELEMENT_NAME)) {
				currentServingSatfat=new String(currentElementValue);
			}
			else if (localName.equals(CHOLESTEROL_ELEMENT_NAME)) {
				currentServingCholesterol=new String(currentElementValue);
			}
			else {
				throw new SAXException("Unknown element name: "+localName);
			}

		}





		

		
	}
