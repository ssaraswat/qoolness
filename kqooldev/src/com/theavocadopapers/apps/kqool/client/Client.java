package com.theavocadopapers.apps.kqool.client;


// this is the only package that may be imported with a wildcard; all others
// must specify a class:
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

/**
* This class contains information about the user's browser and system - note that any changes to this class should be reflected in the Client.js JavaScript object
*/
public class Client
{

	// interface versions
	public static final int BASIC=1;
	public static final int STANDARD=2;
	public static final int NONE=3;

	/**
	* String of JavaScript code defining constants in this class that the client needs to operate:
	*/
	public static String CONSTANTS_FOR_CLIENT=""
		+"BASIC="+BASIC+"\n"
		+"STANDARD="+STANDARD+"\n"
		+"NONE="+NONE+"\n"
	;

	public boolean exp=false;
	public boolean nav=false;
	public boolean mac=false;
	public boolean win=false;
	public int interfaceVersion=0;
	public int majorVersion=0;
	public double minorVersion=0;
	public double fullVersion=0;


	public Client (final HttpServletRequest request)
	{
		try {
			final String userAgent=request.getHeader("User-agent");
			final StringTokenizer userAgentTok=new StringTokenizer(userAgent,"(");
			final String userAgentSeg1=userAgentTok.nextToken(); // e.g. Mozilla/4.0
			final String userAgentSeg2=userAgentTok.nextToken(); // e.g. compatible; MSIE 5.5; Windows 98)
			if (userAgentSeg1.toLowerCase().indexOf("mozilla")>-1)
			{
				// then this is either netscape or ie (unless it's a crawler or other agent
				// impersonating "mozilla", but we don't care about those), but which one (we
				// don't care about other agents because we only support these two, so the
				// rest of this constructor is in this if clause and non-accepted browsers
				// will just have the default field values (all false or zero):
				this.exp=(userAgentSeg2.toLowerCase().indexOf("msie")>-1);
				this.nav=!exp;
				this.win=(userAgentSeg2.toLowerCase().indexOf("win")>-1);
				this.mac=(userAgentSeg2.toLowerCase().indexOf("mac")>-1);
				if (this.nav)
				{
					// if this is netscape, then we can just take the number after "Mozilla/"
					// as the fullVersion:
					this.fullVersion=Double.parseDouble(parseSeg1ForFullVersion(userAgentSeg1));
				}
				else
				{
					// else this is ie, so we can't trust the number after the "/"; what
					// we want is the "5.5" in "(compatible; MSIE 5.5; Windows 98)"
					this.fullVersion=Double.parseDouble(parseSeg2ForFullVersion(userAgentSeg2));
				}
	
				// calculate other fields:
				this.majorVersion=(int)Math.floor(fullVersion);
				this.minorVersion=fullVersion-this.majorVersion;
	
				// determine the interface version (we support netscape 4 only, both OS's and
				// ie/win v4+ and ie/mac v4.5+ (ie/win c4+ is full version, others are basic
				// version):
				if(this.win && this.exp && this.fullVersion>=4)
				{
					// if ie/win v4+:
					this.interfaceVersion=STANDARD;
				}
				else if(this.mac && this.exp && this.fullVersion>=4.5)
				{
					// if ie/mac v4.5+
					this.interfaceVersion=BASIC;
				}
				else if((this.mac || this.win) && this.nav && this.fullVersion>=4.0 && this.fullVersion<5.0)
				{
					// if netscape, either mac or win, version 4.x only:
					this.interfaceVersion=BASIC;
				}
				else
				{
					// else sorry:
					this.interfaceVersion=NONE;
				}
			}
			else
			{
				this.interfaceVersion=NONE;
			}
		}
		catch (final Exception e) {
			this.interfaceVersion=NONE;
		}
	}

	private static String parseSeg1ForFullVersion(final String s)
	{
		final StringBuffer buffer=new StringBuffer();
		if (s==null)
		{
			return null;
		}
		for (int i=0; i<s.length(); i++)
		{
			final char c=s.charAt(i);
			if ("0123456789.".indexOf(c)>-1)
			{
				buffer.append(c);
			}
		}
		return buffer.toString();
	}


	private static String parseSeg2ForFullVersion(final String s)
	{
		final StringBuffer buffer=new StringBuffer();
		if (s==null)
		{
			return null;
		}
		final StringTokenizer tokenizer=new StringTokenizer(s,"MSIE ");
		// discard the first token...
		tokenizer.nextToken();
		// ...what we want is the second token, e.g. "5.5; Windows 98)"
		final String tok2=tokenizer.nextToken();
		// loop through it until we encounter the first non-numeric char:
		for (int i=0; i<tok2.length(); i++)
		{
			final char c=tok2.charAt(i);
			if ("0123456789.".indexOf(c)>-1)
			{
				buffer.append(c);
			}
			else
			{
				break;
			}
		}
		return buffer.toString();
	}

	/**
	* Is the browser Internet Explorer
	*/
	public boolean isExp()
	{
		return this.exp;
	}
	/**
	* Is the browser Netscape
	*/
	public boolean isNav()
	{
		return this.nav;
	}
	/**
	* Is the OS MacOS
	*/
	public boolean isMac()
	{
		return this.mac;
	}
	/**
	* Is the OS Windows
	*/
	public boolean isWin()
	{
		return this.win;
	}
	/**
	* The integer part of the browser version
	*/
	public int getMajorVersion()
	{
		return this.majorVersion;
	}
	/**
	* The UI interface version that we use for this browser/OS (see constants in this class)
	*/
	public int getInterfaceVersion()
	{
		return this.interfaceVersion;
	}

	/**
	* The fractional part of the browser version
	*/
	public double getMinorVersion()
	{
		return this.minorVersion;
	}
	/**
	* The full browser version
	*/
	public double getFullVersion()
	{
		return this.fullVersion;
	}
}


