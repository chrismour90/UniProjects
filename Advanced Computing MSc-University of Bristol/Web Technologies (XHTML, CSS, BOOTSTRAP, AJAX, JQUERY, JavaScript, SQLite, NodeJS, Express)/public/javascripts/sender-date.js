'use strict'

function autofill()
{

var today = new Date();
var dd = today.getDate();
var mm = today.getMonth()+1; //January is 0!

var yyyy = today.getFullYear();
if(dd<10){dd='0'+dd} if(mm<10){mm='0'+mm} today = yyyy+'-'+mm+'-'+dd;

var x=today;

document.getElementById("dateFrom").value = x;
document.getElementById("dateUntil").value=document.getElementById("dateFrom").value ;
document.getElementById("dateUntil").stepUp(2);
}

function checkDate() {
   if (document.getElementById('urgentyes').checked) {autofill(); return;}
   document.getElementById('dateFrom').value=check(document.getElementById('dateFrom').value);
   document.getElementById('dateUntil').value=check(document.getElementById('dateUntil').value);
   }
 

function check(selectedText)
{
   var selectedDate = new Date(selectedText);
   var today = new Date();
   if (selectedDate < today) {
    var dd = today.getDate();
	var mm = today.getMonth()+1; //January is 0!

	var yyyy = today.getFullYear();
	if(dd<10){dd='0'+dd} if(mm<10){mm='0'+mm} today = yyyy+'-'+mm+'-'+dd;

	var x=today;
	return x;
	}
   else return selectedText;
} 


function empty()
{
	document.getElementById("dateFrom").value="";
	document.getElementById("dateUntil").value="";
}

function upper(id)
{
	document.getElementById(id).value = document.getElementById(id).value.toUpperCase();
}