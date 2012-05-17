package com.theavocadopapers.apps.kqool.food.ck;

import org.xml.sax.SAXException;

import com.theavocadopapers.core.logging.Logger;

	
	public class CkFoodSearchContentHandler  extends CkContentHandler {
 
		
		private static final Logger logger = Logger.getLogger(CkFoodSearchContentHandler.class);
		
		public static final String SEARCHRESULTS_ELEMENT_NAME="searchresults";
		public static final String CATEGORY_ELEMENT_NAME="category";
		public static final String NAME_ELEMENT_NAME="name";
		public static final String FOODS_ELEMENT_NAME="foods";
		public static final String FOOD_ELEMENT_NAME="food";
		public static final String ID_ELEMENT_NAME="id";
		public static final String DISPLAY_ELEMENT_NAME="display";


		private String currentCategoryName;
		


		private String currentFoodId;
		private String currentFoodLabel;
		



		public void endElement(final String uri, final String localName, final String qName) throws SAXException {
			logger.info("endElement: " + localName + "\n");

			if (localName.equals(SEARCHRESULTS_ELEMENT_NAME)) {
				// do nothing; this is the end of the document
			}
			else if (localName.equals(CATEGORY_ELEMENT_NAME)) {
				// do nothing; we'll wait for the next element, which is the category's name
			}
			else if (localName.equals(NAME_ELEMENT_NAME)) {
				currentCategoryName=new String(currentElementValue);
			}
			else if (localName.equals(FOODS_ELEMENT_NAME)) {
				// do nothing; we're treating this doc as a flat list of food elements, just using the category element's name element as a prefix for the food's label
			}
			else if (localName.equals(FOOD_ELEMENT_NAME)) {
				// the end of a food element, so add a Food to our list:
				listItems.add(new CkFood(currentFoodId, currentFoodLabel)); 
			}
			else if (localName.equals(ID_ELEMENT_NAME)) {
				// a food element's id:
				currentFoodId=new String(currentElementValue); 
			}
			else if (localName.equals(DISPLAY_ELEMENT_NAME)) {
				// a food element's display, which we'll prefix with the current category name:
				currentFoodLabel=currentCategoryName+": "+currentElementValue.toString();
			}
		}

		
	}
