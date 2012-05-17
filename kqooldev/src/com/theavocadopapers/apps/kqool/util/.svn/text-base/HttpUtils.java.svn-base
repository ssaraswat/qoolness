package com.theavocadopapers.apps.kqool.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.Authenticator;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import com.theavocadopapers.apps.kqool.food.HttpAuthenticator;

public class HttpUtils {


	public static String getHttpResponse(final String fqUrl, final boolean post) throws IOException {
		return getHttpResponse(fqUrl, post, null, null);
	}
		
	public static String getHttpResponse(final String fqUrl, final boolean post, final String username, final String password) throws MalformedURLException, IOException {
		final URL url=new URL(fqUrl);
		final HttpURLConnection conn=(HttpURLConnection)url.openConnection();
		final HttpAuthenticator httpAuthenticator=new HttpAuthenticator(username, password);
		Authenticator.setDefault(httpAuthenticator);
		conn.setInstanceFollowRedirects(true);
		conn.setRequestMethod(post?"POST":"GET");
		conn.setAllowUserInteraction(true);
		conn.setUseCaches(false);
		conn.setRequestProperty("accept","text/plain,text/html,application/xml,text/xml");
		conn.setRequestProperty("accept-language","en");
		conn.setRequestProperty("content-type","application/x-www-form-urlencoded");
		conn.setRequestProperty("user-agent","Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.1.4322)");
		conn.setRequestProperty("connection","Keep-Alive");
		conn.setRequestProperty("cache-control","no-cache");
		
		conn.connect();
		final InputStream in=conn.getInputStream();
		final BufferedReader reader=new BufferedReader(new InputStreamReader(in));

		boolean more=true;
		String line;
		final StringBuffer response=new StringBuffer(1024*25);
		while (more) {
			line=reader.readLine();
			if (line==null) {
				more=false;
			}
			else {
				response.append(line);
			}
		}
		try {
			reader.close();
		}
		catch (final Exception e) {
		}
		try {
			in.close();
		}
		catch (final Exception e) {
		}
		try {
			conn.disconnect();
		}
		catch (final Exception e) {
		}
		return response.toString();

	}
	
}
