package com.theavocadopapers.img;

import java.awt.RenderingHints;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.sanselan.ImageFormat;
import org.apache.sanselan.ImageReadException;
import org.apache.sanselan.ImageWriteException;
import org.apache.sanselan.Sanselan;


public class ImgUtils {

	
	public static void streamFileToClient(final File file, final int blockSize, final String contentType, final HttpServletResponse response) throws IOException {
		response.setContentType(contentType);
		BufferedInputStream is=null;
		final ServletOutputStream os=response.getOutputStream();
		if (!file.exists() || !file.isFile() || !file.canRead()) {
			throw new IOException("File "+file+" does not exist, or is a directory, or is not readable.");
		}
		try {
			is=new BufferedInputStream(new FileInputStream(file));
			int offset=0;
			boolean endOfStreamReached=false;
			final byte[] bytes=new byte[blockSize];
			while (!endOfStreamReached) {
				if (is.read(bytes, offset, blockSize)!=-1) {
					os.write(bytes);
					offset+=blockSize;					
				}
				else {
					endOfStreamReached=true;
				}
			}
		}
		finally {
			try {
				is.close();
				os.close();
			}
			catch (final Exception e) {
			}
		}
	
		
	}

	public static void saveUploadedFile(final FileItem fileItem, final File file, final HttpServletRequest request) throws Exception {
		if (!ServletFileUpload.isMultipartContent(request)) {
			throw new RuntimeException("Form submission is not type multipart.");
		}
		fileItem.write(file);
	}
	
	public static int[] createResizedFile(final File sourceFile, File destFile, final int maxWidth, final String filenameExt) throws IOException, ImageWriteException, ImageReadException {
		String filenameExtension=filenameExt.toLowerCase();
		final boolean isGif=filenameExtension.equals("gif");
		BufferedOutputStream out=null;
		BufferedInputStream in=null;
		try {
			in=new BufferedInputStream(new FileInputStream(sourceFile));
			final BufferedImage img=ImageIO.read(in);
			if (isGif) {
				// AWT doesn't seem to be able to resize GIFs (???), so:
				filenameExtension="png";
				convertGifToPng(img);
				final String pngName=destFile.getName().substring(0, destFile.getName().indexOf("."))+".png";
				final File newFile=new File(destFile.getParentFile(), pngName);
				destFile=newFile;
			}	
			
			if (!destFile.exists()) {
				destFile.createNewFile();
			}
			out=new BufferedOutputStream(new FileOutputStream(destFile));

			float height=img.getHeight();
			float width=img.getWidth();
			if (width<=maxWidth) {
				// then we don't need to do any resizing and therefore just copy from temp dir to dest
				// dir (after getting a new InputStream):
				in.close();
				in=new BufferedInputStream(new FileInputStream(sourceFile));
				copyFile(in, out);
			}
			else {
				// we have to resize:
				width=maxWidth;
				height=resizeAndWrite(width, img, filenameExtension, isGif, out);

			}
			final int[] heightWidth={(int)height, (int)width};
			return heightWidth;
		}
		finally {
			try {
				in.close();
			}
			catch (final Exception ignore) {}
			try {
				out.close();
			}
			catch (final Exception ignore) {}
		}
	}



	private static int resizeAndWrite(final float width, final BufferedImage img, final String filenameExtension, final boolean isGif, final BufferedOutputStream out) throws IOException, ImageWriteException, ImageReadException {
		final float scaleFactor=width/img.getWidth();	
		final AffineTransform at=AffineTransform.getScaleInstance(scaleFactor,scaleFactor);
		final RenderingHints renderingHints=new RenderingHints(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_NEAREST_NEIGHBOR);
		renderingHints.put(RenderingHints.KEY_COLOR_RENDERING, RenderingHints.VALUE_COLOR_RENDER_QUALITY);
		renderingHints.put(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
		final AffineTransformOp op=new AffineTransformOp(at, renderingHints);
		final BufferedImage destImg=op.filter(img, null);
		ImageIO.write(destImg, filenameExtension, out);
		return destImg.getHeight();
	}
	
	private static void convertGifToPng(BufferedImage img) throws ImageWriteException, IOException, ImageReadException {
		final byte[] gifBytes=Sanselan.writeImageToBytes(img, ImageFormat.IMAGE_FORMAT_PNG, null);
		img=Sanselan.getBufferedImage(gifBytes);
	}

	private static void copyFile(final BufferedInputStream in, final BufferedOutputStream out) throws IOException {
		//int offset=0;
		boolean endOfStreamReached=false;
		final int blockSize=8096;
		final byte[] bytes=new byte[blockSize];
		while (!endOfStreamReached) {
			//if (in.read(bytes, offset, blockSize)!=-1) {
			if (in.read(bytes, 0, blockSize)!=-1) {
				out.write(bytes);
				//offset+=blockSize;					
			}
			else {
				endOfStreamReached=true;
			}
		}
	}

}
