'use strict'

var transporter_form=$("#transporter-form");
var div_form=$("#forms");
var modalAnimateTime = 300;

 $(function(){
        transporter_form.on('submit',function(e) {
            e.preventDefault();
            var data = transporter_form.serialize();
            $.post('/transporter', data, function(result) {
                if(result.valid == true)
                {
                    div_form.html("<div id=\"response\"><p style=\"padding:10px;\"></p><legend style=\"text-align:center;\"> Confirmation message</legend> <br/> <div class=\"alert alert-success\"> <strong>Congratulations!</strong> Your journey details have been successfully stored in the database. All you have to do now is wait to be selected by a sender!!</div><p style=\"padding:20px;\"></p></div>");
                } 
            });
			
			var response=$("#response");
			div_form.css("height","672");
			transporter_form.fadeToggle(modalAnimateTime, function(){						
			div_form.animate({height: 233}, modalAnimateTime, function(){
				response.fadeToggle(modalAnimateTime);							
			});
			});
        });
    });

	