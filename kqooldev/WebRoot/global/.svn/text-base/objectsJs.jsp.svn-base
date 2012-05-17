<% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<script>

// all these constructors take arrays as their arg:

function Instance(a)
{
	return new ClientObject(["id","name","rootUrl"],a)
}
function Issue(a)
{
	return new ClientObject(["id","descriptionText","assignedByUserId","assignedToUserId","status","priority","openDate","dueDate","url","projectId","instanceId"],a)
}
function Project(a)
{
	return new ClientObject(["id","name","suppressedInstanceIds"],a)
}
function User(a)
{
	return new ClientObject(["id","username","fullname","emailAddress","active","backendUser","dropUserCookie","sendMissedDeadlineReminder","sendICalendarFileWithNotification","preDeadlineReminderBeforeMillis"],a)
}
function InstallationConfig(a)
{
	return new ClientObject(["mailSubjectPrefixInitialNotification","mailSubjectPrefixChangeNotification","mailSubjectPrefixReminder","smtpHost","smtpUsername","companyName","adminName","adminEmail","smtpPort","issuesPerPage","installTimeInMillis","doNotifications","showAdministratorEmailLink"],a)
}



function ClientObject(fieldNames, fieldValues)
{
	if (fieldValues==null)
	{
		return null
	}
	for (var i=0; i<fieldNames.length; i++)
	{
		this[fieldNames[i]]=fieldValues[i]
	}
}


</script>

