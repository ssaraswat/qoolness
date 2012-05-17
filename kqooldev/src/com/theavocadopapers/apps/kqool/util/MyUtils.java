package com.theavocadopapers.apps.kqool.util;


import java.text.ParseException;

import java.text.SimpleDateFormat;

import java.util.Calendar;

import java.util.Date;

import java.util.LinkedHashMap;

import java.util.Map;



public class MyUtils {

	public static String[] populateDates(String startDate) {

		Calendar cal = Calendar.getInstance();

		cal.add(Calendar.DAY_OF_MONTH, -(cal.getInstance().get(Calendar.DAY_OF_WEEK) - 1));

		startDate = "".equals(startDate)?cal.get(Calendar.YEAR) + "-" + (cal.get(Calendar.MONTH) + 1) + "-" + cal.get(Calendar.DAY_OF_MONTH):startDate;

		Map m = new LinkedHashMap();

		String dates[]=new String[7];

		String date="";

		for (int i = 0; i < 7; i++){

			date=addToDate(startDate, i);

			String dateFormat[]=date.split("-");

			date=dateFormat[2]+" "+getMonth(new Integer(dateFormat[1]));

			dates[i] = date;

			

		}

		//System.out.println(m.toString());

	return dates;

	}



	public static String addToDate(String fromDate, int numberOfDays) {

		String date[] = fromDate.split("-");

		// String DATE_FORMAT = "yyyy-MM-dd";

		String DATE_FORMAT = "yyyy-MM-dd"; // Refer Java DOCS for formats

		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(DATE_FORMAT);

		// Date d = sdf.parse(fromDate);

		Calendar c1 = Calendar.getInstance();

		// c1.setTime(d);

		c1.set(Integer.parseInt(date[0]), (Integer.parseInt(date[1]) - 1), Integer.parseInt(date[2])); // (year,month,date)

		c1.add(Calendar.DATE, numberOfDays);

		return sdf.format(c1.getTime());

	}



	public static void main(String[] args) {

		//populateDates();

	}

	

	public static String getMonth(int month) {

		String m = "";

		switch(month) {

			case 1:  m = "January"; break;

	        case 2:  m = "February"; break;

	        case 3:  m = "March"; break;

	        case 4:  m = "April"; break;

	        case 5:  m = "May"; break;

	        case 6:  m = "June"; break;

	        case 7:  m = "July"; break;

	        case 8:  m = "August"; break;

	        case 9:  m = "September"; break;

	        case 10: m = "October"; break;

	        case 11: m = "November"; break;

	        case 12: m = "December"; break;



		}

		return m;

	}

	

	public static Integer getMonth(String curr_month){

		Integer month = -1;

		if(curr_month.equalsIgnoreCase("January"))

			month=1;

		else if(curr_month.equalsIgnoreCase("February"))

			month=2;

		else if(curr_month.equalsIgnoreCase("March"))

			month=3;

		else if(curr_month.equalsIgnoreCase("April"))

			month=4;

		else if(curr_month.equalsIgnoreCase("May"))

			month=5;

		else if("June".equalsIgnoreCase(curr_month)){

			month=6;

		}

		else if(curr_month.equalsIgnoreCase("July"))

			month=7;

		else if(curr_month.equalsIgnoreCase("August"))

			month=8;

		else if(curr_month.equalsIgnoreCase("September"))

			month=9;

		else if(curr_month.equalsIgnoreCase("October"))

			month=10;

		else if(curr_month.equalsIgnoreCase("November"))

			month=11;

		else if(curr_month.equalsIgnoreCase("December"))

			month=12; 

		return month;

	}

	

	public static String formatDate(String strDate) {

		String formattedDate = "";

		int minimumLength = 7;



		if (strDate != null && strDate.trim() != "00000000" && strDate.trim().length() == minimumLength) {

			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");

			Date date = null;

			try {

				date = dateFormat.parse(strDate);

				dateFormat = new SimpleDateFormat("MM/dd/yyyy");

				formattedDate = dateFormat.format(date);

			} catch (ParseException pe) {

				// don't do anything

			}

		}

		return formattedDate;

	}

}