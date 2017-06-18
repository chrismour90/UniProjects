// Get the modal
var modal = document.getElementById('imageModal');

// Get the image and insert it inside the modal - use its "alt" text as a caption
var img = document.getElementById('userImage');
var modalImg = document.getElementById("img01");
var captionText = document.getElementById("caption");
img.onclick = function(){
    modal.style.display = "block";
    modalImg.src = this.src;
    captionText.innerHTML = this.alt;
}

// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];

// When the user clicks on <span> (x), close the modal
span.onclick = function() { 
    modal.style.display = "none";
}

$("#new_password").on("change",function(){
    var oldH=$("#change-form").height();
    var password=$("#new_password").val();
if(password.length<8){
    $("#alert-msg").show();
    $('#forms').css({"height":"400px"});
    $("#alert-msg").html("The password needs to be at least 8 characters long!");
    $("#new_password").val("");
}
else{
    $("#alert-msg").hide();
    $('#forms').css({"height":"323px"});
}

});