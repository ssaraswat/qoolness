/*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/

package com.theavocadopapers.apps.kqool.util;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;

import com.theavocadopapers.apps.kqool.control.Controller;
import com.theavocadopapers.apps.kqool.entity.Exercise;
import com.theavocadopapers.apps.kqool.entity.ExerciseVideo;
import com.theavocadopapers.core.util.URLEncoder;

public class HtmlUtils
implements com.theavocadopapers.apps.kqool.Constants
{
	

	public static String getYesNoRadios(final boolean yes, final String fieldName)
	{
		return getYesNoRadios(yes, fieldName, "Yes", "No", "");
	}

	public static String getYesNoRadios(final boolean yes, final String fieldName, final String altYesLabel, final String altNoLabel)
	{
		return getYesNoRadios(yes, fieldName, altYesLabel, altNoLabel, "");
	}

	public static String getYesNoRadios(final boolean yes, final String fieldName, final String altYesLabel, final String altNoLabel, final String addlAttrs)
	{
		return
			"<input class=noBorder "+addlAttrs+" type=radio name=\""+fieldName+"\" value=true "+(yes?"checked":"")+" id=\""+fieldName+"True\"><label for=\""+fieldName+"True\">"+altYesLabel+"</label> "
			+"<input class=noBorder "+addlAttrs+"  type=radio name=\""+fieldName+"\" value=false "+(!yes?"checked":"")+" id=\""+fieldName+"False\"><label for=\""+fieldName+"False\">"+altNoLabel+"</label>"
		;
	}
	
	public static String getMailtoLink(final String addr, final String linkText)
	{
		return "<a href=\"mailto:"+addr+"\">"+linkText+"</a>";
	}

	public static String getMailtoLink(final String addr)
	{
		return getMailtoLink(addr, addr);
	}

	public static String getLink(final String url, final String linkText)
	{
		return "<a href=\""+url+"\" target=_blank>"+linkText+"</a>";
	}

	public static String getLink(final String url)
	{
		return getLink(url,url);
	}


	public static String getHorizRuleTr(final int colspan, final int height, final String className, final HttpServletRequest request)
	{
		return "<tr><td colspan="+colspan+" class="+className+"><img src=\""+request.getAttribute(PageUtils.PATH_TO_APP_ROOT_ATTR_NAME)+"images/spacer.gif\" height="+height+" width=1><BR></td></tr>";
	}
	public static String getHorizRuleTr(final int colspan, final int height, final HttpServletRequest request)
	{
		return getHorizRuleTr(colspan, height, "ruleRow", request);
	}
	public static String getHorizRuleTr(final int colspan, final HttpServletRequest request)
	{
		return getHorizRuleTr(colspan, 1, request);
	}

	public static String getVertRuleTd(final int rowspan, final int width, final HttpServletRequest request)
	{
		return "<td rowspan="+rowspan+" class=ruleRow nowrap width="+width+"><img src=\""+request.getAttribute(PageUtils.PATH_TO_APP_ROOT_ATTR_NAME)+"images/spacer.gif\" height=1 width=1><br></td>";
	}
	public static String getVertRuleTd(final int rowspan, final HttpServletRequest request)
	{
		return getVertRuleTd(rowspan, 1, request);
	}

	public static String getSingleRuleCell(final int width, final HttpServletRequest request)
	{
		return "<td class=ruleRow nowrap width="+width+"><img src=\""+request.getAttribute(PageUtils.PATH_TO_APP_ROOT_ATTR_NAME)+"images/spacer.gif\" /><br></td>";
	}
	public static String getSingleRuleCell(final HttpServletRequest request)
	{
		return getSingleRuleCell(1, request);
	}

	public static String getPasswordAsterisks(final String password)
	{
		if (password==null)
		{
			return "";
		}
		final StringBuffer buffer=new StringBuffer();
		for (int i=0; i<password.length(); i++)
		{
			buffer.append("<b>&middot;</b>");
		}
		return buffer.toString();
	}


	/*
	public static String getAssociatedInstancesMenu(Project project, String fieldName, int size, int index, ArrayList allInstancesList)
	{
		int[] suppressedInstanceIds=project.getSuppressedInstanceIds();
		if (suppressedInstanceIds==null)
		{
			suppressedInstanceIds=new int[0];
		}

		// doing select-menu html first because have to count selected and unselected options:
		boolean unselectedFound=false;
		boolean selectedFound=false;
		StringBuffer selectBuffer=new StringBuffer("<select onclick=associatedInstancesSelectClick(this,"+index+") class=associatedInstancesSelect name=\""+fieldName+"\" id=\""+fieldName+"\" size="+size+" multiple=true>");
		if (allInstancesList!=null)
		{
			for (int i=0; i<allInstancesList.size(); i++)
			{
				Instance instance=(Instance)allInstancesList.get(i);
				boolean isSelected=(!GeneralUtils.arrayContainsElement(suppressedInstanceIds,instance.getId()));
				if (isSelected)
				{
					selectedFound=true;
				}
				else
				{
					unselectedFound=true;
				}
				selectBuffer.append("<option value=\""+instance.getId()+"\" "+(isSelected?"selected":"")+">"+instance.getName()+"</option>");
			}
		}
		selectBuffer.append("</select>");

		boolean checkAllRadio=(!unselectedFound || allInstancesList.size()<=1);
		boolean checkNoneRadio=(!selectedFound && !checkAllRadio);
		boolean checkSomeRadio=(!checkAllRadio && !checkNoneRadio);

		StringBuffer radioBuffer=new StringBuffer("<input "+(checkAllRadio?"checked":"")+" onclick=\"associatedInstancesRadioClick(this,"+index+")\" type=radio name=instanceChoice"+index+" value=all id=instanceChoiceAll"+index+"><label for=instanceChoiceAll"+index+">All instances</label><BR>");
		radioBuffer.append("<input "+(checkNoneRadio?"checked":"")+" onclick=\"associatedInstancesRadioClick(this,"+index+")\" type=radio name=instanceChoice"+index+" value=none id=instanceChoiceNone"+index+"><label for=instanceChoiceNone"+index+">No instances</label><BR>");
		radioBuffer.append("<input "+(checkSomeRadio?"checked":"")+" type=radio name=instanceChoice"+index+" value=some id=instanceChoiceSome"+index+"><label for=instanceChoiceSome"+index+">The selected instances below:</label><BR>");

		return radioBuffer.toString()+selectBuffer.toString();
	}


	public static String getAssociatedInstancesText(Project project, ArrayList allInstancesList)
	{
		int[] suppressedInstanceIds=project.getSuppressedInstanceIds();
		if (suppressedInstanceIds==null)
		{
			suppressedInstanceIds=new int[0];
		}

		boolean unselectedFound=false;
		boolean selectedFound=false;
		StringBuffer buffer=new StringBuffer();
		if (allInstancesList!=null)
		{
			for (int i=0; i<allInstancesList.size(); i++)
			{
				Instance instance=(Instance)allInstancesList.get(i);
				boolean isSelected=(!GeneralUtils.arrayContainsElement(suppressedInstanceIds,instance.getId()));
				if (isSelected)
				{
					selectedFound=true;
				}
				else
				{
					unselectedFound=true;
				}
				if (isSelected)
				{
					buffer.append("<nobr>&nbsp;"+instance.getName()+"&nbsp;&nbsp;&nbsp;</nobr><BR>");
				}
			}
		}

		boolean allSelected=(!unselectedFound || allInstancesList.size()<=1);
		boolean noneSelected=(!selectedFound && !allSelected);

		if (allSelected)
		{
			return "&nbsp;All&nbsp;&nbsp;&nbsp;";
		}
		if (noneSelected)
		{
			return "&nbsp;None&nbsp;&nbsp;&nbsp;";
		}
		// some were selected and some weren't, so return the contents of the buffer:
		return buffer.toString();

	}
	*/
	
	

	public static String spacer(final int height, final int width, final HttpServletRequest request)
	{
		String heightWidthAttr;
		if (height==1 && width==1) {
			heightWidthAttr="";
		}
		else {
			heightWidthAttr=" height="+height+" width="+width;
		}
		return "<img src="+PageUtils.getPathToAppRoot(request)+"images/spacer.gif "+heightWidthAttr+" />";
	};

	public static String doubleLB(final HttpServletRequest request)
	{
		return doubleLB(request,8);
	}

	public static String doubleLB(final HttpServletRequest request, final int altHeight)
	{
		return "<BR>"+spacer(altHeight,1,request)+"<BR>";
	}

	public static String capitalizeFirst(final String s)
	{
		if (s==null)
		{
			return null;
		}
		if (s.length()==0)
		{
			return "";
		}
		return s.substring(0,1).toUpperCase()+s.substring(1,s.length());
	}
	
	
	public static void dateFields(final String yearElName, final String monthElName, final String dateElName, final PageContext pageContext, final Controller controller)  {
		dateFields(yearElName, monthElName, dateElName, yearElName, monthElName, dateElName, pageContext, controller);
	}

	public static void dateFields(final PageContext pageContext, final Controller controller)  {
		dateFields("year", "month", "date", pageContext, controller);
	}
	
	public static void dateFields(final String yearElName, final String monthElName, final String dateElName, final String yearParamName, final String monthParamName, final String dateParamName, final PageContext pageContext, final Controller controller)  {
		dateFields(yearElName, monthElName, dateElName, yearParamName, monthParamName, dateParamName, true, false, 0, 0, pageContext, controller);
	}
	public static void dateFields(final String yearElName, final String monthElName, final String dateElName, final String yearParamName, final String monthParamName, final String dateParamName, final boolean showCalendarLauncher, final boolean ascendingYears, final int startYear, final int endYear, final PageContext pageContext, final Controller controller)  {
		try {
			final String includeStr="../global/calendarLauncherInclude.jsp?"+controller.getSiteIdNVPair()+"&ascendingYears="+ascendingYears+"&startYear="+startYear+"&endYear="+endYear+"&showCalendarLauncher="+showCalendarLauncher+"&yearElName="+yearElName+"&monthElName="+monthElName+"&dateElName="+dateElName+"&yearParamName="+yearParamName+"&monthParamName="+monthParamName+"&dateParamName="+dateParamName+"";
			pageContext.include(includeStr);
		}
		catch (final ServletException e) {
		}
		catch (final IOException e) {
		}	
	}
	
	public static void getVideoThumb(final Exercise exercise, final ExerciseVideo video, final PageContext pageContext, final Controller controller)  {
		getVideoThumb(exercise, video, true, pageContext, controller);
	}
	
	public static void getVideoThumb(final Exercise exercise, final ExerciseVideo video, final boolean portraitOrientation,final PageContext pageContext, final Controller controller)  {
		try {
			pageContext.include("/videos/videoThumb.jsp?"+controller.getSiteIdNVPair()+"&portraitOrientation="+portraitOrientation+"&category="+video.getExerciseCategory()+"&filename="+video.getFilename()+"&altIconImage="+(video.getAltIconImage()==null?"":video.getAltIconImage())+"&id="+video.getId()+"&name="+URLEncoder.encode(exercise.getName())+"&description="+URLEncoder.encode(video.getDescription()));
		}
		catch (final ServletException e) {
		}
		catch (final IOException e) {
		}
	}
	
	public static String formButton(final boolean submitButton, final String name, final String onclick, final HttpServletRequest request) {
		final StringBuffer buf=new StringBuffer();
		final String imgAttributes=" height=45 width=167 border=0 src=\""+PageUtils.getPathToAppRoot(request)+"images/buttons/"+name+".gif\" ";
		if (submitButton) {
			buf.append("<input hidefocus=true  "+(onclick!=null && onclick.length()>0?"onclick=\""+onclick+"\"":"")+" type=image "+imgAttributes+" />");
		} 
		else {
			buf.append("<a hidefocus=true href=# onclick=\""+onclick+"; return false;\"><img "+imgAttributes+" /></a>");
		}
		return buf.toString();
	}
	
	public static String formButton(final String name, final HttpServletRequest request) {
		return formButton(true, name, null, request);
	}

	
	public static String smallFormButton(final boolean submitButton, final String name, final String onclick, final HttpServletRequest request) {
		final StringBuffer buf=new StringBuffer();
		final String imgAttributes=" height=19 width=81 border=0 src=\""+PageUtils.getPathToAppRoot(request)+"images/smallButtons/"+name+".gif\" ";
		if (submitButton) {
			buf.append("<input hidefocus=true  "+(onclick!=null && onclick.length()>0?"onclick=\""+onclick+"\"":"")+" type=image "+imgAttributes+" />");
		} 
		else {
			buf.append("<a hidefocus=true href=# onclick=\""+onclick+"; return false;\"><img "+imgAttributes+" /></a>");
		}
		
		
		return buf.toString();
	}

	public static String smallCpFormButton(final boolean submitButton, final String label, final String onclick, final HttpServletRequest request) {
		return smallCpFormButton(submitButton, label, onclick, request, -1);
	}
	public static String smallCpFormButton(final boolean submitButton, final String label, final String onclick, final HttpServletRequest request, final int widthPx) {
		String styleAttr="";
		if (widthPx>-1) {
			styleAttr=" style=\"width:"+widthPx+"px;\" ";
		}
		return "<input type=\""+(submitButton?"submit":"button")+"\" value=\""+label+"\" "+(onclick!=null && onclick.length()>0?"onclick=\""+onclick+"\"":"")+" class=\"controlPanelSmallButton\" "+styleAttr+">";
	}

	public static String cpFormButton(final boolean submitButton, final String label, final String onclick, final HttpServletRequest request) {
		return "<input type=\""+(submitButton?"submit":"button")+"\" value=\""+label+"\" "+(onclick!=null && onclick.length()>0?"onclick=\""+onclick+"\"":"")+" class=\"controlPanelButton\">";
	}

	public static String cpFormButton(final String label, final HttpServletRequest request) {
		return cpFormButton(true, label, null, request);
	}	

	public static String smallCpFormButton(final String label, final HttpServletRequest request) {
		return smallCpFormButton(true, label, null, request);
	}	

	public static String smallerFormButton(final boolean submitButton, final String name, final String onclick, final HttpServletRequest request) {
		final StringBuffer buf=new StringBuffer();
		final String imgAttributes=" height=19 width=49 border=0 src=\""+PageUtils.getPathToAppRoot(request)+"images/smallerButtons/"+name+".gif\" ";
		if (submitButton) {
			buf.append("<input hidefocus=true  "+(onclick!=null && onclick.length()>0?"onclick=\""+onclick+"\"":"")+" type=image "+imgAttributes+" />");
		} 
		else {
			buf.append("<a hidefocus=true href=# onclick=\""+onclick+"; return false;\"><img "+imgAttributes+" /></a>");
		}
		return buf.toString();
	}
	
	public static String smallFormButton(final String name, final HttpServletRequest request) {
		return formButton(true, name, null, request);
	}


}