
package com.theavocadopapers.core.logging;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class LogWriter {

	private static final String EOL=System.getProperty("line.separator", "\n");
	
	protected static final String PROPERTIES_FILENAME="/logger.properties";
	protected static final long MAX_BYTES_PER_FILE=1024l*1024l*256l; // 0.25 mb
	
	private static long bytesWritten=0;
	private static LogWriter instance=new LogWriter();
	
	private BufferedWriter bufferedWriter;
	private Properties props=new Properties();
	private File logFile;
	private final boolean logAllToStdout;

	private LogWriter() {
		InputStream is=null;
		final String propsFilename=PROPERTIES_FILENAME;
		try {
			props=new Properties();
			is=this.getClass().getResourceAsStream(propsFilename);
			props.load(is);
		} 
		catch(final Exception e) {
			e.printStackTrace();
			throw new RuntimeException("Cannot load "+propsFilename+".");			
		}
		finally {
			try {
				is.close();
			}
			catch (final Exception e) {}
		}
		logAllToStdout=(props.getProperty("log.all.to.stdout","false").trim().equalsIgnoreCase("true"));
		final String filename=props.getProperty("logger.file");
		try {
			logFile=new File(filename);
			if (!logFile.exists()) {
				final boolean created=logFile.createNewFile();
				if (!created) {
					throw new RuntimeException("Couldn't create file "+filename+"");
				}
			}
			setUpBufferedWriter();
			System.out.println("Logging initialized for "+filename);
		}
		catch (final Throwable t) {
			System.out.println("Could not initialize Logger; swallowing exception...");
			t.printStackTrace();			
		}

	}

	private synchronized void setUpBufferedWriter() {
		try {
			this.bufferedWriter.close();
		}
		catch (final Exception e) {}
		try {
			this.bufferedWriter=new BufferedWriter(new FileWriter(this.logFile, true));
		}
		catch (final Exception e) {}
	}

	protected static LogWriter getInstance() {
		return instance;
	}



	protected void log(final String prefix, final String msg, final Throwable throwable, final boolean logToStdout) {
		synchronized(this) {
			final StringBuilder outMsg=new StringBuilder((int)((""+msg).length()+(throwable==null?0:5000)*1.25));

			if (msg!=null) {
				outMsg.append(prefix+" - ");
				outMsg.append(msg);
				outMsg.append(EOL);
			}
			if (throwable!=null) {
				Throwable t=new Throwable(throwable); 
				// we don't want the first trace, so:
				t=t.getCause();
				outMsg.append(prefix+" - ");
				while (t!=null) {
					final String throwableToString=t+": "+t.getMessage();
					outMsg.append(throwableToString);
					outMsg.append(EOL);
					final StackTraceElement[] els=t.getStackTrace();
					if (els!=null) {
						final int elsLength=els.length;
						String elToString;
						for (int i=0; i<elsLength; i++) {
							if (i!=0) {
								outMsg.append("\t");
							}
							elToString=els[i].toString();
							outMsg.append(elToString);
							outMsg.append(EOL);
						}
						if (this.logAllToStdout || logToStdout) {
							t.printStackTrace();
						}
					}
					else {
						outMsg.append(EOL);
					}
					t=t.getCause();
					if (t!=null) {
						outMsg.append("caused by...");
						outMsg.append(EOL);
					}
				}
			}

			try {
				bufferedWriter.write(outMsg.toString());
				bufferedWriter.flush();
			}
			catch (final IOException e) {
				e.printStackTrace();
			}
			if (this.logAllToStdout || logToStdout) {
				System.out.print(outMsg); // print instead of println because msg already has the linebreaks in it (so it can be written to the log)
			}
			bytesWritten+=outMsg.length();
			if (bytesWritten>=MAX_BYTES_PER_FILE) {
				try {
					this.bufferedWriter.flush();
				}
				catch (final IOException e) {
					e.printStackTrace();
				}
				try {
					this.bufferedWriter.close();
				}
				catch (final IOException e) {
					e.printStackTrace();
				}
				final File oldFile=new File(props.getProperty("logger.file")+".old");
				if (oldFile.exists()) {
					oldFile.delete();
				}
				final boolean renamed=this.logFile.renameTo(oldFile);
				if (!renamed) {
					this.logFile.delete();
				}
				setUpBufferedWriter();
				bytesWritten=0;
				Logger.getLogger(getClass()).info("Cycled log after size reached "+MAX_BYTES_PER_FILE+" bytes");
			} // end if
		} // end synchronized
	} // end method

	@Override
	protected void finalize() throws Throwable {
		/*
		super.finalize();
		try {
			bufferedWriter.flush();
		}
		catch (final Throwable t) {}
		try {
			bufferedWriter.close();
		}
		catch (final Throwable t) {}
		*/
	}
	
	


	

}
