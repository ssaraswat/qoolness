package com.theavocadopapers.apps.kqool.food.ck;

import java.util.ArrayList;
import java.util.List;

import org.xml.sax.Attributes;
import org.xml.sax.ContentHandler;
import org.xml.sax.Locator;
import org.xml.sax.SAXException;

import com.theavocadopapers.core.logging.Logger;


public abstract class CkContentHandler implements ContentHandler {
	
	private static final Logger logger = Logger.getLogger(CkContentHandler.class);
	
	protected Locator locator;
	
	protected boolean parsed=false;
	
	protected List listItems;
	protected final StringBuilder currentElementValue=new StringBuilder(512);		
	
	
	
	
	public List getListItemsFromParsedXML() {
		if (!parsed) {
			throw new IllegalStateException("Can't call getListItemsFromParsedXML() before parent XMLReader's parse().");
		}
		return listItems;
	}

	public void setDocumentLocator(final Locator locator) {
		logger.info(" * setDocumentLocator() called");
		this.locator=locator;
	}		
	
	public void startDocument() throws SAXException {
		logger.info("Begin parse...");
		listItems=new ArrayList(100);				
	}

	public void startElement(final String namespaceURI, final String localName, final String rawName, final Attributes atts) throws SAXException {
		logger.info("startElement: " + localName);
		currentElementValue.delete(0, currentElementValue.length());
	}	
	
	public void characters(final char[] chars, final int start, final int length) throws SAXException {
		// note that the full characters content of an element may come to us in more than one call to characters().
		currentElementValue.append(new String(chars, start, length));
		logger.info("currentElementValue: " + currentElementValue.toString());
	}

	
	public void endDocument() throws SAXException {
		parsed=true;
	}

	public void startPrefixMapping(final String prefix, final String uri) {}
	
	public void endPrefixMapping(final String prefix) throws SAXException {}

	public void ignorableWhitespace(final char[] ch, final int start, final int length) {}

	public void processingInstruction(final String target, final String data) throws SAXException {}

	public void skippedEntity(final String name) throws SAXException {}

	
	
	protected double parseDouble(final String doubleStr) {
		try {
			return Double.parseDouble(doubleStr);
		}
		catch (final RuntimeException e) {
			return -1.0d;
		}
	}
}
