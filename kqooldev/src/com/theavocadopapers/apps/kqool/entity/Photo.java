/*
 * Created on Apr 10, 2004
 * Copyright (c) 2004 Steve Schneider.  All rights reserved.
 */
package com.theavocadopapers.apps.kqool.entity;

import java.io.File;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.theavocadopapers.apps.kqool.GenericProperties;
import com.theavocadopapers.core.logging.Logger;
import com.theavocadopapers.hibernate.SessionWrapper;



/** 
 * @author sschneider
 *
 */
public class Photo extends AbstractDbObject {
	
	private static final Class currentClass=Photo.class;
	
	private static final Logger logger = Logger.getLogger(currentClass);
	
	private static GenericProperties genericProperties=new GenericProperties();

	protected String filenamePrefix;  // a sequence of numbers
	protected String filenameExtension; // this is also the identifier for the file type; will ALWAYS be gif, jpg, or png (regardless of if it was uploaded as, say, 'jpeg'
	protected Date uploadDate;
	protected boolean primaryPhoto;
	protected int userId;
	protected int uploadingUserId;
	protected int mainHeight;
	protected int mainWidth;
	protected int thumbHeight;
	protected int thumbWidth;
	protected String caption;
	


	public static Photo getById(final int id) {
		return (Photo)getById(currentClass, id, false);
	}
	

	@Override
	protected Comparable getComparableValue() {
		return uploadDate;
	}


	public static List getByUserId(final int userId) {
		return getByField("userId", ""+userId, FIELD_TYPE_NUMERIC, currentClass, false);
	} 
	
	public static Photo getPrimaryByUserId(final int userId) {
		List photos=getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.userId = "+userId+" and i.primaryPhoto = 1", false);
		if (photos==null || photos.size()==0) {
			// no primary photo, so take the most recent one, if there are any at all:
			photos=getByUserId(userId);
		}
		if (photos==null || photos.size()==0) {
			return null;
		}
		// there's at least one photo; sort the list by the default sort field (upload date) and then reverse the list and then return the first element (i.e. the latest):
		Collections.sort(photos);
		Collections.reverse(photos);
		return (Photo)photos.get(0);
	} 
	
	public static void setPrimaryPhotoByUserIdAndPhotoId(final int userId, final int photoId) {
		final List allUserPhotos=getByUserId(userId);
		if (allUserPhotos!=null) {
			final Iterator i=allUserPhotos.iterator();
			Photo photo;
			boolean primary;
			while (i.hasNext()) {
				photo=(Photo)i.next();
				primary=(photo.getId()==photoId);
				if (primary!=photo.isPrimaryPhoto()) {
					photo.setPrimaryPhoto(primary);
					photo.store();
				}
			}
		}
	}
	
	public static void unsetPrimaryPhotoByUserId(final int userId) {
		final List allUserPhotos=getByUserId(userId);
		if (allUserPhotos!=null) {
			final Iterator i=allUserPhotos.iterator();
			Photo photo;
			while (i.hasNext()) {
				photo=(Photo)i.next();
				if (photo.isPrimaryPhoto()) {
					photo.setPrimaryPhoto(false);
					photo.store();
				}
			}
		}
	}
	
	public static List getAll() {
		return getAll(currentClass);
	}
	
	public static Map<Integer,AbstractDbObject> getUserIdToPrimaryPhotoMap() {
		return getUserIdToPrimaryPhotoMap(null);
	}
	public static Map<Integer,AbstractDbObject> getUserIdToPrimaryPhotoMap(final SessionWrapper sessionWrapper) {
    	try {
	    	final List all=getByHQLQuery("from "+getClassNameOnly(currentClass)+" as i where i.primaryPhoto = 1", true, sessionWrapper);
	    	final Map map=new LinkedHashMap(all.size()*2);
	    	final Iterator i=all.iterator();
	    	AbstractDbObject obj;
	    	while (i.hasNext()) {
	    		obj=(AbstractDbObject)i.next();
	    		map.put(new Integer(((Photo)obj).getUserId()), obj);
	    	}
	    	return map;
    	}
    	catch (final Exception e) {
    		return new LinkedHashMap(0);
    	}
    }  
	
	public static void deleteById(final int id) {
		deleteById(currentClass, id);
	}

	
	@Override
	public int store() { 
		if (this.getUploadingUserId()==0) {
			throw new IllegalStateException("Can't store a photo with no uploadingUserId specified.");
		}
		return super.store();
	}




	public String getFilenameExtension() {
		return filenameExtension;
	}


	public void setFilenameExtension(final String filenameExtension) {
		this.filenameExtension = filenameExtension;
	}


	public Date getUploadDate() {
		return uploadDate;
	}


	public void setUploadDate(final Date uploadDate) {
		this.uploadDate = uploadDate;
	}


	public boolean isPrimaryPhoto() {
		return primaryPhoto;
	}


	public void setPrimaryPhoto(final boolean primaryPhoto) {
		this.primaryPhoto = primaryPhoto;
	}


	public int getUserId() {
		return userId;
	}


	public void setUserId(final int userId) {
		this.userId = userId;
	}


	public int getUploadingUserId() {
		return uploadingUserId;
	}


	public void setUploadingUserId(final int uploadingUserId) {
		this.uploadingUserId = uploadingUserId;
	}


	public int getMainHeight() {
		return mainHeight;
	}


	public void setMainHeight(final int mainHeight) {
		this.mainHeight = mainHeight;
	}


	public int getMainWidth() {
		return mainWidth;
	}


	public void setMainWidth(final int mainWidth) {
		this.mainWidth = mainWidth;
	}


	public int getThumbHeight() {
		return thumbHeight;
	}


	public void setThumbHeight(final int thumbHeight) {
		this.thumbHeight = thumbHeight;
	}


	public int getThumbWidth() {
		return thumbWidth;
	}


	public void setThumbWidth(final int thumbWidth) {
		this.thumbWidth = thumbWidth;
	}

	
	public String getFilenamePrefix() {
		return filenamePrefix;
	}


	public void setFilenamePrefix(final String filenamePrefix) {
		this.filenamePrefix = filenamePrefix;
	}


	public String getCaption() {
		return caption;
	}


	public void setCaption(final String caption) {
		this.caption = caption;
	}

	
	/** Convenience method
	 * @return filename based on filename prefix and extension
	 */
	public String getThumbnailFilename() {
		return new StringBuilder(filenamePrefix+"thumb."+filenameExtension).toString();
	}

	/** Convenience method
	 * @return filename based on filename prefix and extension
	 */
	public String getMainFilename() {
		return new StringBuilder(filenamePrefix+"main."+filenameExtension).toString();
	}

	/** Convenience method
	 * @return File object representing (currently existing or not) file, based on generic.properties, userId and filename
	 */
	public File getThumbnailFile() {
		return new File(genericProperties.getUserPhotoFilesysRoot()+"/"+userId+"/"+getThumbnailFilename());
	}

	/** Convenience method
	 * @return File object representing (currently existing or not) file, based on generic.properties, userId and filename
	 */
	public File getMainFile() {
		return new File(genericProperties.getUserPhotoFilesysRoot()+"/"+userId+"/"+getMainFilename());
	}

	/** Convenience method
	 * @return Relative-to-root URL (including context path) to image file, based on generic.properties, userId and filename (e.g. /kqool/images/userimages/342/23983792238947298347thumb.jpg)
	 */
	public String getRelativeToRootThumbnailURL(final HttpServletRequest request) {
		return request.getContextPath()+genericProperties.getUserPhotoHttpPath()+"/"+userId+"/"+getThumbnailFilename();
	}

	/** Convenience method
	 * @return Relative-to-root URL (including context path) to image file, based on generic.properties, userId and filename (e.g. /kqool/images/userimages/342/23983792238947298347main.jpg)
	 */
	public String getRelativeToRootMainURL(final HttpServletRequest request) {
		return request.getContextPath()+genericProperties.getUserPhotoHttpPath()+"/"+userId+"/"+getMainFilename();
	}





}
