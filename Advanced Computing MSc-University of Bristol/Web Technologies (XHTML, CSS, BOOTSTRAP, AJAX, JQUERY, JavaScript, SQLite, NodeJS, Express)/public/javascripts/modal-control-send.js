'user strict'

var sender_form=$("#sender-form");
var results=$("#search-results");
var divForms=$("#forms");
var modalAnimateTime = 300;


/*
$('#search-btn').click( function () { 
        var oldH = sender_form.height();
        var newH = results.height();
        divForms.css("height",oldH);
        sender_form.fadeToggle(modalAnimateTime, function(){
            divForms.animate({height: newH}, modalAnimateTime, function(){
                results.fadeToggle(modalAnimateTime);
            });
        });
  
    });
*/

$("#back-to-item-btn").click(function(){
     var oldH = results.height();
        var newH = sender_form.height();
		$("table").remove();
		$("#fail").remove();
        divForms.css("height",oldH);
        results.fadeToggle(modalAnimateTime, function(){
            divForms.animate({height: newH}, modalAnimateTime, function(){
                sender_form.fadeToggle(modalAnimateTime);
		
            });
        });

});

 $(function(){
        sender_form.on('submit',function(e) {
            e.preventDefault();
            var data = sender_form.serialize();
            $.post('/sender', data, function(result) {
                if(result.valid == true)
                {   
					searchResults=result.rows;
										
					//Initialise the table's head
					var table_init=$("<table class=\"table table-hover table-bordered\"><thead><tr><th>&#160;</th> <th>Username</th> <th> From </th> <th> To </th> <th> Arrival Date </th> <th> Arrival Time </th> <th> Travelling By</th></tr></thead></table>")
					
					//Initialise the table's body
					var results_table=$(" <tbody id=\"results-table\"></tbody>");
					
					
					for(i=0; i<searchResults.length;i++)
					{
						var input_form=$("<form method=\"post\" id=\"selected-transp\" action=\"/sender/matching\"> </form>");
						
						var data0=document.createElement("td");
						
						var selbut=$("<input type=\"submit\" class=\"btn btn-primary\" value=\"Select\" />");
						var rad=$("<input type=\"hidden\" name=\"transporter\" />");
						$(rad).attr("value",searchResults[i].transporter_id);
						
						$(input_form).append(rad);
						$(input_form).append(selbut);						
						$(data0).append(input_form);
						
						
						var data1=document.createElement("td");
						var data2=document.createElement("td");
						var data3=document.createElement("td");
						var data4=document.createElement("td");
						var data5=document.createElement("td");
						var data6=document.createElement("td");
						var row=document.createElement("tr");
						
						data1.innerHTML=searchResults[i].username;
						data2.innerHTML=searchResults[i].from_;
						data3.innerHTML=searchResults[i].destination;
						data4.innerHTML=searchResults[i].arrival_date;
						data5.innerHTML=searchResults[i].arrival_time;
						data6.innerHTML=searchResults[i].transportation;
						
						$(row).append(data0,data1,data2,data3,data4,data5,data6);
						//Append the rows to the body
						$(results_table).append(row);
					}
						//Append the body to the initial table
					   $(table_init).append(results_table);
					   //Append the table to the div
					   $("#final-results").append(table_init);				  
					   
					   
					//$(sender_form).css({"display":"none"});
					//$(results).css({"display":"initial"});
					 var result_height = results.height();
					 divForms.css("height","611");
					 sender_form.fadeToggle(modalAnimateTime, function(){						
			         divForms.animate({height: result_height}, modalAnimateTime, function(){
				      results.fadeToggle(modalAnimateTime);
					 });
					 });
                }
                else
                {   
					$("#final-results").html("<br/> <div id=\"fail\" class=\"alert alert-danger\"> <strong>No results found! </strong>We are sorry but there are not transporters matching your search. Click the button below to update your search!</div>");
													
					divForms.css("height","611");
					sender_form.fadeToggle(modalAnimateTime, function(){						
			        divForms.animate({height: 247}, modalAnimateTime, function(){
				      results.fadeToggle(modalAnimateTime);
					});
					});
                }
				
				/*var response=$("#response");
				div_form.css("height","672");
			    transporter_form.fadeToggle(modalAnimateTime, function(){						
			    div_form.animate({height: 233}, modalAnimateTime, function(){
				response.fadeToggle(modalAnimateTime);*/	
            });
        });
    });

	