'use strict'

var login=$("#login-form");
var register=$("#register-form");
var divForms = $('#forms');
var modalAnimateTime = 300;

$('#register-btn').click( function () { 
		var oldH = login.height();
        var newH = register.height();
        divForms.css("height",oldH);
        login.fadeToggle(modalAnimateTime, function(){
            divForms.animate({height: newH}, modalAnimateTime, function(){
                register.fadeToggle(modalAnimateTime);
            });
        });
	});
$('#back-login-btn').click( function () { 
		var oldH = register.height();
        var newH = login.height();
        divForms.css("height",oldH);
        register.fadeToggle(modalAnimateTime, function(){
            divForms.animate({height: newH}, modalAnimateTime, function(){
                login.fadeToggle(modalAnimateTime);
            });
        });
	});

	
$("#password").on("change",function(){
    var oldH=register.height();
	console.log(oldH);
    var password=$("#password").val();
if(password.length<8){
    $("#alert-msg").show();
    $('#forms').css({"height":"684px"});
    $("#alert-msg").html("The password needs to be at least 8 characters long!");
    $("#password").val("");
}
else{
    $("#alert-msg").hide();
    $('#forms').css({"height":"612px"});
}

});

 $(function(){
        login.on('submit',function(e) {
            e.preventDefault();
            var data = login.serialize();
            $.post('/login', data, function(result) {
                if(result.valid == true)
                {
                    window.location.href = '/mainpage';
                }
                else
                {   console.log(result);
                    $('#alert-msg-login').show();
					$('#forms').css({"height":"330px"});
					$("#alert-msg-login").html(result);
                }
            });
        });
    });

	$(function(){
        register.on('submit', function(e) {
            e.preventDefault();
			var form = new FormData($("#register-form")[0]);
			$.ajax({
				method: "POST", url: '/signup/upload', data: form, processData: false, contentType: false, success: function (response) {
					if(response.valid == true)
					{ console.log(response);
						var oldH = register.height();
						var newH = login.height();
						divForms.css("height",oldH);
						register.fadeToggle(modalAnimateTime, function(){
							divForms.animate({height: newH}, modalAnimateTime, function(){
							login.fadeToggle(modalAnimateTime);
							});
						});
					}
					else
					{   console.log(response);
                    $('#alert-msg').show();
					$('#forms').css({"height":"450px"});
					$("#alert-msg").html(response);
					}	
					}, error: function() {
						alert('Error');
						}
			});   
			return false;
        });
    });