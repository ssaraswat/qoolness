<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>


function duplicateObjFound(formObj, totalNumObjs, fieldLabel, objsArray, elNamePrefix, okValue)
{
	if (arguments.length==5) {
		okValue=null
	}
	for (var i=0; i<totalNumObjs; i++)
	{
		for (var j=0; j<objsArray.length; j++)
		{
			var existingFieldVal=trim(objsArray[j])
			var newFieldVal=trim(formObj.elements[elNamePrefix+i].value)
			if (okValue!=null && okValue.length>0 && newFieldVal==okValue) {
				continue
			}
			if ((""+existingFieldVal).toLowerCase()==(""+newFieldVal).toLowerCase())
			{
				errorAlert("The "+fieldLabel+" \""+newFieldVal+"\" is already taken; please choose another one and try again.",formObj.elements[elNamePrefix+i])
				return true
			}
		}
	}
	return false

}

function confirmDuplicateWorkoutNameFoundOk(el) {
	for (var i=0; i<allNames.length; i++) {
		if (el.value==allNames[i]) {
				return generalConfirm("The routine name \""+el.value+"\" already exists; okay to create a new routine with the same name?",el)
		}
	}
	return true
}

function duplicateUsernameFound(formObj,totalNumUsers,okUsername)
{
	if (arguments.length==2) {
		okUsername=null
	}
	return duplicateObjFound(formObj, totalNumUsers, "username", allUsernames, "username", okUsername)
}
function duplicateFullnameFound(formObj,totalNumUsers)
{
	return duplicateObjFound(formObj, totalNumUsers, "full name", allFullnames, "fullname")
}


function duplicateExerciseNameFound(formObj,totalNumExercises)
{
	return duplicateObjFound(formObj, totalNumExercises, "name", allNames, "name")
}

function duplicateActivityNameFound(formObj,totalNumActivities)
{
	return duplicateObjFound(formObj, totalNumActivities, "name", allNames, "name")
}


function duplicateProjectNameFound(formObj,totalNumProjects)
{
	return duplicateObjFound(formObj, totalNumProjects, "name", allProjectNames, "name")
}





function duplicateFieldsInForm(formObj,totalNumObjs, fieldLabel, elNamePrefix)
{
	for (var i=0; i<totalNumObjs; i++)
	{
		for (var j=0; j<totalNumObjs; j++)
		{
			var field1=trim(formObj.elements[elNamePrefix+i].value)
			var field2=trim(formObj.elements[elNamePrefix+j].value)
			if ((""+field1).toLowerCase()==(""+field2).toLowerCase() && i!=j && field1!="")
			{
				errorAlert("You have entered the "+fieldLabel+" \""+field1+"\" more than once on this page; please fix and try again.",formObj.elements[elNamePrefix+i])
				return true
			}
		}
	}
	return false
}


function launchCaloriesExpendedCalculator()
{
	var url=top.location.href
	if (url.indexOf("/help/")>-1)
	{
		url=""
	}
	openWin(pathToAppRoot+"userutils/caloriesExpendedPopup.jsp?currUrl="+escape(url), "kqoolCaloriesExpended", 390, 320, false)
}




function duplicateUsernamesInForm(formObj,totalNumUsers)
{
	return duplicateFieldsInForm(formObj,totalNumUsers, "username", "username")
}
function duplicateExerciseNamesInForm(formObj,totalNumExercises)
{
	return duplicateFieldsInForm(formObj,totalNumExercises, "name", "name")
}
function duplicateActivityNamesInForm(formObj,totalNumActivities)
{
	return duplicateFieldsInForm(formObj,totalNumActivities, "name", "name")
}




function badUsernameFound(formObj,totalNumUsers)
{
	for (var i=0; i<totalNumUsers; i++)
	{
		var username=formObj.elements["username"+i].value
		if (username.length>0 && !isValidUsername(username))
		{
			errorAlert("The username \""+username+"\" is not valid; usernames may contain only letters, numbers, underscores, dashes, and periods, and must be between "+USERNAME_MIN_LENGTH+" and "+USERNAME_MAX_LENGTH+" characters long. Please fix and try again.",formObj.elements["username"+i])
			return true
		}
	}
	return false
}

function badPasswordFound(formObj,totalNumUsers)
{
	for (var i=0; i<totalNumUsers; i++)
	{
		var username=formObj.elements["username"+i].value
		var password=formObj.elements["password"+i].value
		if (password.length>0 && !isValidPassword(password))
		{
			errorAlert("The password \""+password+"\" (for username \""+username+"\") is not valid; passwords may contain only letters, numbers, underscores, dashes, and periods, and must be between "+PASSWORD_MIN_LENGTH+" and "+PASSWORD_MAX_LENGTH+" characters long. Please fix and try again.",formObj.elements["password"+i])
			return true
		}
	}
	return false
}

function badEmailFound(formObj,totalNumUsers)
{
	for (var i=0; i<totalNumUsers; i++)
	{
		var username=formObj.elements["username"+i].value
		var email=formObj.elements["emailAddress"+i].value
		if (email.length>0 && !isValidEmail(email))
		{
			errorAlert("The e-mail address \""+email+"\" is not valid; an example of a valid e-mail address is \"name@mydomain.com\". Please fix and try again.",formObj.elements["emailAddress"+i])
			return true
		}
	}
	return false
}


function noExercisesEntered(formObj,totalNumExercises)
{
	var exercisesFound=0;
	for (var i=0; i<totalNumExercises; i++)
	{
		var name=trim(formObj.elements["name"+i].value)
		if (name.length>0)
		{
			exercisesFound++
		}
	}
	if (exercisesFound==0)
	{
		errorAlert("You have not entered any exercises.  If you do not wish to enter any new exercises now, please press the \"cancel\" button.  Otherwise, please enter at least one user and try again.");
		return true
	}
	return false

}

function noActivitiesEntered(formObj,totalNumActivities)
{
	var activitiesFound=0;
	for (var i=0; i<totalNumActivities; i++)
	{
		var name=trim(formObj.elements["name"+i].value)
		if (name.length>0)
		{
			activitiesFound++
		}
	}
	if (activitiesFound==0)
	{
		errorAlert("You have not entered any activities.  If you do not wish to enter any new activities now, please press the \"cancel\" button.  Otherwise, please enter at least one activity and try again.");
		return true
	}
	return false

}

function noUsersEntered(formObj,totalNumUsers)
{
	var usersFound=0;
	for (var i=0; i<totalNumUsers; i++)
	{
		var name=formObj.elements["username"+i].value
		if (name.length>0)
		{
			usersFound++
		}
	}
	if (usersFound==0)
	{
		errorAlert("You have not entered any users.  If you do not wish to enter any new users now, please press the \"cancel\" button.  Otherwise, please enter at least one user and try again.");
		return true
	}
	return false

}

function noInstancesEntered(formObj,totalNumInstances)
{
	var instancesFound=0;
	for (var i=0; i<totalNumInstances; i++)
	{
		var instanceName=formObj.elements["name"+i].value
		if (instanceName.length>0)
		{
			instancesFound++
		}
	}
	if (instancesFound==0)
	{
		errorAlert("You have not entered any instances.  If you do not wish to enter any new instances now, please press the \"cancel\" button.  Otherwise, please enter at least one instance and try again.");
		return true
	}
	return false

}


function noProjectsEntered(formObj,totalNumProjects)
{
	var projectsFound=0;
	for (var i=0; i<totalNumProjects; i++)
	{
		var projectName=formObj.elements["name"+i].value
		if (projectName.length>0)
		{
			projectsFound++
		}
	}
	if (projectsFound==0)
	{
		errorAlert("You have not entered any projects.  If you do not wish to enter any new projects now, please press the \"cancel\" button.  Otherwise, please enter at least one project and try again.");
		return true
	}
	return false

}




function associatedInstancesRadioClick(radioObj, index)
{
	var buttonValue=radioObj.value
	var selectedBoolean=(buttonValue=="all")
	var menuObj=document.forms["mainForm"].elements["associatedInstances"+index]
	var menuOptions=menuObj.options
	for (var i=0; i<menuOptions.length; i++)
	{
		menuOptions[i].selected=selectedBoolean
	}
}

function associatedInstancesSelectClick(selectObj, index)
{
	checkRadioWithNameAndValue("mainForm","instanceChoice"+index,"some")
}

function checkRadioWithNameAndValue(formName, elName, elValue)
{
	var els=document.forms[formName].elements
	for (var i=0; i<els.length; i++)
	{
		if (""+els[i].name==""+elName && ""+els[i].value==""+elValue)
		{
			els[i].checked=true
		}
	}
}