'use strict'

function checkDate() {
   document.getElementById('date').value=check(document.getElementById('date').value);    
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

   
function upper(id)
{
	document.getElementById(id).value = document.getElementById(id).value.toUpperCase();
}