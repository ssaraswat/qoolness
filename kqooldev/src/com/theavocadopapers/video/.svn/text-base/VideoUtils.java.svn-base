package com.theavocadopapers.video;

import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Date;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.theavocadopapers.apps.kqool.GenericProperties;
import com.theavocadopapers.core.logging.Logger;


public class VideoUtils {

	private static final Logger logger = Logger.getLogger(VideoUtils.class);

	public static final String VALID_FILENAME_CHARS="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.-_";
	
	public static final int THUMB_IMG_HEIGHT=83;
	public static final int THUMB_IMG_WIDTH=111;
	
	public static GenericProperties genericProps=new GenericProperties();
	
	public static void saveUploadedFile(final FileItem fileItem, final File file, final HttpServletRequest request) throws Exception {
		if (!ServletFileUpload.isMultipartContent(request)) {
			throw new RuntimeException("Form submission is not type multipart.");
		}
		final InputStream in=fileItem.getInputStream();
		final BufferedOutputStream out=new BufferedOutputStream(new FileOutputStream(file));
		final byte[] bytes=new byte[65535];
		int bytesRead=in.read(bytes);
		int totalBytesRead=0;
		final long start=new Date().getTime();
		while (bytesRead>-1) {
			totalBytesRead+=bytesRead;
			out.write(bytes, 0, bytesRead);
			bytesRead=in.read(bytes);
		}
		logger.info("Upload took "+(new Date().getTime()-start)+" millis.");
		//fileItem.write(file);
	}
	
	public static String saveVideoAndGenericThumbnail(final FileItem fileItem, final String filenameExt, final HttpServletRequest request) throws Exception {
		String videoFilename=new String(fileItem.getName());
		videoFilename=videoFilename.substring(0, videoFilename.lastIndexOf("."))+new Date().getTime()+videoFilename.substring(videoFilename.lastIndexOf("."), videoFilename.length());
		if (videoFilename.indexOf("/")>-1) {
			videoFilename=videoFilename.substring(videoFilename.lastIndexOf("/")+1, videoFilename.length());
		}
		if (videoFilename.indexOf("\\")>-1) {
			videoFilename=videoFilename.substring(videoFilename.lastIndexOf("\\")+1, videoFilename.length());
		}
		onlyValidChars(videoFilename, VALID_FILENAME_CHARS);
		String thumbFilename=new String(videoFilename);
		thumbFilename=thumbFilename.substring(0, thumbFilename.lastIndexOf("."))+".jpg";

		final File videoDir=new File(genericProps.getVideoFilesysRoot());
		if (!videoDir.exists()) {
			videoDir.mkdirs();
		}
		final File videoFile=new File(videoDir, videoFilename);

		if (videoFile.exists()) {
			videoFile.deleteOnExit();
		}
		final File thumbnailDir=new File(genericProps.getVideoThumbFilesysRoot());
		if (!thumbnailDir.exists()) {
			thumbnailDir.mkdirs();
		}
		final File thumbFile=new File(thumbnailDir, thumbFilename);
		if (thumbFile.exists()) {
			thumbFile.delete();
		}
		saveUploadedFile(fileItem, videoFile, request);
		saveGenericThumbFile(thumbFile);

		return videoFilename;
	}
	
	public static void saveThumbnail(final FileItem fileItem, final String thumbFilename, final HttpServletRequest request) throws Exception {
		final File thumbDir=new File(genericProps.getVideoThumbFilesysRoot());
		final File thumbFile=new File(thumbDir, thumbFilename);
		
		InputStream fileItemIn=fileItem.getInputStream();
		final BufferedImage img=ImageIO.read(fileItemIn);
		fileItemIn.close();
		if (img.getHeight()!=THUMB_IMG_HEIGHT) {
			throw new Exception("This image's height is "+img.getHeight()+", but the required height for thumbnail images is "+THUMB_IMG_HEIGHT+".");
		}
		if (img.getWidth()!=THUMB_IMG_WIDTH) {
			throw new Exception("This image's width is "+img.getWidth()+", but the required width for thumbnail images is "+THUMB_IMG_WIDTH+".");
		}
		fileItemIn=fileItem.getInputStream();
		final BufferedInputStream in=new BufferedInputStream(fileItemIn);
		copyFile(in, new BufferedOutputStream(new FileOutputStream(thumbFile)), true, true);
	}




	private static void saveGenericThumbFile(final File destFile) throws IOException {
		final File srcFile=new File(genericProps.getGenericVideoThumbImage());
		final BufferedInputStream in=new BufferedInputStream(new FileInputStream(srcFile));
		final BufferedOutputStream out=new BufferedOutputStream(new FileOutputStream(destFile));
		copyFile(in, out, true, true);
	}
	

	private static void copyFile(final BufferedInputStream in, final BufferedOutputStream out, final boolean closeInStream, final boolean closeOutStream) throws IOException {

		try {
			boolean endOfStreamReached=false;
			final int blockSize=8096;
			final byte[] bytes=new byte[blockSize];
			while (!endOfStreamReached) {
				if (in.read(bytes, 0, blockSize)!=-1) {
					out.write(bytes);					
				}
				else {
					endOfStreamReached=true;
				}
			}
		}
		finally {
			try {
				if (closeInStream) {
					in.close();
				}
			}
			catch (final Exception e) {}
			try {
				if (closeOutStream) {
					out.close();
				}
			}
			catch (final Exception e) {}
		}

	}


	private static void onlyValidChars(String s, final String validChars) {
		if (s!=null) {
			final StringBuilder b=new StringBuilder(s.length()*2);
			final int sLength=s.length();
			char c;
			for (int i=0; i<sLength; i++)
			{
				c=s.charAt(i);
				if (validChars.indexOf(c)>-1) {
					b.append(c);
				}
			}
			s=b.toString();
		}
		
	}
}
