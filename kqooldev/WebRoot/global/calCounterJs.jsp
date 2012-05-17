<%



/********** PLEASE NOTE *********
This file is statically (that is, compile-time) included by one or more JSPs.
********************************/



%><% /*
Copyright (c) Steve Schneider 2002-2005..
All rights reserved.
*/ %>

<script>
// this is calCounterJs.jsp

var calsForChosenServing=0;
var rawDataForChosenServing=null
var currentNumServings=0;



function setCalsForChosenServing(cals) {
	//alert("setting setCalsForChosenServing to "+cals)
	calsForChosenServing=cals
}
function setCurrentNumServings(n) {
	//alert("setting currentNumServings to "+n)
	currentNumServings=n
}

function addFood() {
	document.getElementById("searchMain").style.display="block"
	document.getElementById("searchShadow").style.display="block"
	// force a scroll-into-view:
	setTimeout("focusHiddenFocusReceiver()", 20)
	setTimeout("focusSearchbox()", 50)
}

function focusSearchbox() {
	try {
		window.frames["searchMainIframe"].document.getElementById("kqfoodquery").focus()
	}
	catch (e) {}
}

function focusHiddenFocusReceiver() {
	try {
		document.getElementById("hiddenFocusReceiver").focus()
	}
	catch (e) {}
}

function chooseFood(selectObj, doSubmit) {
	if (typeof selectObj=="undefined") {
		alert("in chooseFood(), selectObj is undefined; about to throw error.")
		throw new Error("in chooseFood(), selectObj is undefined");
	} 
	if (selectObj==null) {
		alert("in chooseFood(), selectObj is null; about to throw error.")
		throw new Error("in chooseFood(), selectObj is null");
	}
	if (selectObj.selectedIndex>-1) {
		chosenFd=selectObj.options[selectObj.selectedIndex].text
		if (chosenFd==null || chosenFd=="null") {
			chosenFd=selectObj.options[selectObj.selectedIndex].innerHTML
		}
		if (chosenFd==null || chosenFd=="null") {
			chosenFd=selectObj.options[selectObj.selectedIndex].innerText
		}
		if (chosenFd==null || chosenFd=="null") {
			alert("in chooseFood(), chosenFd is null; about to throw error.")
			throw new Error("in chooseFood(), chosenFd is null");
		}
		chosenFood=chosenFd
		document.getElementById("chosenFood").value=chosenFd
		if (doSubmit) {
			document.getElementById("searchResultsForm").submit()
		}
	}
}

function isValidSearchResultsForm(formObj) {
	if (formObj.elements.foodId.selectedIndex==-1) {
		alert("Please choose a food first and try again.")
		return false;
	}
	servingsLoading()
	return true; 
}

function servingsLoading() {
	document.getElementById("servingsDiv").innerHTML="<span style=\"font-weight:bold; color:#cc0000;\">[Loading data...]</span>"
}

function hideSearch(win) {
	if (typeof win=="undefined") {
		win=window
	}
	win.document.getElementById("searchMain").style.display="none"
	win.document.getElementById("searchShadow").style.display="none"	
}

function doSearch() {
	document.getElementById("searchResultsDiv").innerHTML="<span style=\"font-weight:bold; color:#cc0000;\">[Loading data...]</span>"
	document.getElementById("servingsDiv").innerHTML=""
	return true;
}
function cancelSearch() {
	document.getElementById("searchResultsDiv").innerHTML=""
	document.getElementById("servingsDiv").innerHTML=""
	document.getElementById("kqfoodquery").value=""
	hideSearch(window.parent)
		
}

function showSearchResults(resultsHtml) {
	resultsHtml=resultsHtml.replace(/Average All Brands\: /g, "")
	document.getElementById("searchResultsDiv").innerHTML=resultsHtml
}



function showServings(servingsHtml) {
	document.getElementById("servingsDiv").innerHTML=servingsHtml
	setTimeout("doInitialCalValPopulation()",50)
}

function doInitialCalValPopulation() {
	numServingsBlur(document.getElementById("numServings"))
	servingDataChange(document.getElementById("servingData"))	
}

function numServingsBlur(numServingsTextboxObj) {
	try {
		var numServingsStr=numServingsTextboxObj.value
		var numServingsFloat=""+parseFloat(numServingsStr)
		if (numServingsFloat.toLowerCase().indexOf("nan")>-1) {
			numServingsFloat=1
		}
		numServingsTextboxObj.value=numServingsFloat
		setCurrentNumServings(parseFloat(numServingsFloat))
		updateCaloriesDisplay()
	}
	catch (e) {}
}
 
function servingDataChange(servingDataSelectObj) {
	try {
		var unparsedServingData=servingDataSelectObj.options[servingDataSelectObj.selectedIndex].value
		unparsedServingData=unescape(unparsedServingData);
		// unparsedServingData is in JSON format: {'calories':'123'... etc.
		var cals=unparsedServingData.substring(unparsedServingData.indexOf(":")+2, unparsedServingData.indexOf(",")-1)
		setCalsForChosenServing(parseFloat(cals))
		rawDataForChosenServing=unparsedServingData
		updateCaloriesDisplay()
	}
	catch (e) {}
}

function updateCaloriesDisplay() {
	//alert("In updateCaloriesDisplay(), calsForChosenServing="+calsForChosenServing+"; currentNumServings="+currentNumServings);
	var calsSpan=document.getElementById("caloriesSpan");
	//alert(calsSpan); 
	if (calsSpan!=null) {
		var newTotalCals=calsForChosenServing*currentNumServings;
		calsSpan.innerHTML=""+parseInt(""+Math.floor(newTotalCals));
	}
	
}

function saveFoodItem() {
	//alert(rawDataForChosenServing)

	//alert(1)
	parent.saveFood(currentNumServings, escape(rawDataForChosenServing))
	//alert(2)
	setTimeout("showOrHideAddMoreFoodDialog(true)", 20);	
	//alert(3)
}

function showOrHideAddMoreFoodDialog(doShow) {
	document.getElementById("moreFoodConfirmMain").style.display=(doShow?"block":"none")
	document.getElementById("moreFoodConfirmShadow").style.display=(doShow?"block":"none")
	document.getElementById("moreFoodConfirmUndermask").style.display=(doShow?"block":"none")
}

function addMore() {
	document.getElementById("searchResultsDiv").innerHTML=""
	document.getElementById("servingsDiv").innerHTML=""
	document.getElementById("kqfoodquery").value=""
	document.getElementById("kqfoodquery").focus()
	showOrHideAddMoreFoodDialog(false)
}

function doneAdding() {
	showOrHideAddMoreFoodDialog(false)
	cancelSearch()
}


</script>

