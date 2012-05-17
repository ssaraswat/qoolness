package com.theavocadopapers.img;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class MultipartServletRequest {

	protected Map itemsMap=new HashMap();
	
	public MultipartServletRequest(final HttpServletRequest request) throws FileUploadException {
		// Create a factory for disk-based file items
		final FileItemFactory factory=new DiskFileItemFactory();
		// Create a new file upload handler
		final ServletFileUpload upload=new ServletFileUpload(factory);
		// Parse the request
		final List<FileItem> items=upload.parseRequest(request);
		
		// Process the uploaded items
		final boolean itemStored=false;
		final Iterator iter=items.iterator();
		while (iter.hasNext()) {
		    final FileItem item=(FileItem) iter.next();
		    if (item.isFormField()) {
		    	itemsMap.put(item.getFieldName(), item.getString());
		    }
		    else {
		    	itemsMap.put(item.getFieldName(), item);
		    }
		}
	}
	
	public String getParameter(final String name) {
		return (String)itemsMap.get(name);
	}
	public FileItem getFileItem(final String name) {
		return (FileItem)itemsMap.get(name);
	}
	

	public String getParam(final String paramName, final String defaultParamValue)
	{
		return (getParameter(paramName)!=null?getParameter(paramName):new String(defaultParamValue));
	}

	public String getParam(final String paramName)
	{
		return getParam(paramName, "");
	}

	public int getParamAsInt(final String paramName, final int defaultParamValue)
	{
		try {
			return (getParameter(paramName)!=null?Integer.parseInt(getParameter(paramName)):defaultParamValue);
		}
		catch (final NumberFormatException e) {
				return defaultParamValue;
		}
	}
	public int getParamAsInt(final String paramName)
	{
		return getParamAsInt(paramName,0);
	}

	public long getParamAsLong(final String paramName, final long defaultParamValue)
	{
		return (getParameter(paramName)!=null?Long.parseLong(getParameter(paramName)):defaultParamValue);
	}
	public long getParamAsLong(final String paramName)
	{
		return getParamAsLong(paramName,0);
	}

	public double getParamAsDouble(final String paramName, final double defaultParamValue)
	{
		return (getParameter(paramName)!=null?Double.parseDouble(getParameter(paramName)):defaultParamValue);
	}
	public double getParamAsDouble(final String paramName)
	{
		return getParamAsDouble(paramName,0);
	}

	public boolean getParamAsBoolean(final String paramName, final boolean defaultParamValue)
	{
		return (getParameter(paramName)!=null?(getParameter(paramName).trim().toLowerCase().equals("true")):defaultParamValue);
	}
	public boolean getParamAsBoolean(final String paramName)
	{
		return getParamAsBoolean(paramName,false);
	}



}
