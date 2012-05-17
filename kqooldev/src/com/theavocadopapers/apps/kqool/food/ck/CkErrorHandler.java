package com.theavocadopapers.apps.kqool.food.ck;

import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public class CkErrorHandler implements ErrorHandler {

	public void error(final SAXParseException e) throws SAXException {
		throw e;
	}

	public void fatalError(final SAXParseException e) throws SAXException {
		throw e;
	}

	public void warning(final SAXParseException e) throws SAXException {
		throw e;
	}

}
