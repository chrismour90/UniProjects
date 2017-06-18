<?php
if( isset( $_SESSION[ 'agency_ref' ] ) )
{
    include "Connect.php";
    $a_r = $_SESSION[ 'name' ]; 
    $tr=mysql_query( "SELECT ΤΙΤΛΟΣ, ΕΙΔΟΣ, ΕΤΟΣ_ΙΔΡΥΣΗΣ, EMAIL, ΤΗΛΕΦΩΝΟ FROM ΥΠΗΡΕΣΙΕΣ WHERE ΤΙΤΛΟΣ ='$a_r' ;" );
    echo mysql_error();
    $td=mysql_fetch_array($tr);
?>
<div id = "sidebar">
<p id = "agen_img_sidebar">
<img src = "icons/FreeAgencyWebImageboarder.gif" title = "agency"/>
<span><?php echo $a_r; ?></span>
</p>
<p id = "agen_settings_sidebar" class = "agen_options_sidebar">
<span>Μεταβολή πληροφοριών υπηρεσίας</span>
</p>
<p id = "agen_show_agents_sidebar" class = "agen_options_sidebar">
<span>Προβολή των πρακτόρων της υπηρεσίας</span>
</p>
<p id = "agen_show_managers_sidebar" class = "agen_options_sidebar">
<span>Προβολή των διαχειριστών της υπηρεσίας</span>
</p>
<p id = "agen_delete_members_sidebar" class = "agen_options_sidebar">
<a href = "manage_members.php">Περιβάλλον διαχείρισης των πρακτόρων και των διαχειριστών της υπηρεσίας</a>
</p>
</div>
<div id = "account_main_content">
</div>
<div id = "add_agent" class = "add_subject_button">
<span class = "add_declar_button">+</span><span class = "add_button">Προσθήκη Πράκτορα</span><span class = "cancel_button">Ακύρωση</span>
<p>
<form>
<input type = "text"  name = "name" id = "add_agent_name" value = "ΟΝΟΜΑ"/>
<input type = "text"  name = "age" id = "add_agent_age" value = "ΗΛΙΚΙΑ"/>
<select name = "gender" id = "add_agent_gender">
<option value = "ΑΝΔΡΑΣ">Άνδρας</option>
<option value = "ΓΥΝΑΙΚΑ">Γυναίκα</option>
</select>
</form>
</p>
</div>
<div id = "add_manager" class = "add_subject_button">
<span class = "add_declar_button">+</span><span class = "add_button">Προσθήκη Διαχειριστή</span><span class = "cancel_button">Ακύρωση</span>
<p>
<form>
<input type = "text"  name = "name" id = "add_manager_name" value = "ΟΝΟΜΑ"/>
<input type = "text"  name = "age" id = "add_manager_age" value = "ΗΛΙΚΙΑ"/>
<input type = "text"  name = "priv" id = "add_manager_priv" value = "ΑΞΙΩΜΑ"/>
<input type = "text"  name = "exp" id = "add_manager_exp" value = "ΧΡΟΝΙΑ ΕΜΠΕΙΡΙΑΣ"/>
<select name = "gender" id = "add_manager_gender">
<option value = "ΑΝΔΡΑΣ">Άνδρας</option>
<option value = "ΓΥΝΑΙΚΑ">Γυναίκα</option>
</select>
</form>
</p>
</div>
<?php
}
else
{
    header( 'Location: http://dbagent.comyr.com/index.php' );
}
?>

<script type="text/javascript">
var str1 = "<table class = \"agen_list\">";
var str2 = "</table>";
var res;
$( 'div#sidebar p#agen_show_agents_sidebar' ).click(function(){
    $.post("display_agents.php",{aid: "<?php echo $td['ΤΙΤΛΟΣ']; ?>"},function(out1){
        res = out1;
        out1 = str1.concat(out1);
        out1 = out1.concat(str2);
        $( 'div#account_main_content' ).html(out1);
    });
    $( 'div.add_subject_button' ).hide("fast");
    $( 'div#add_agent' ).show("fast");
});

$( 'div#sidebar p#agen_show_managers_sidebar' ).click(function(){
    $.post("display_managers.php",{aid: "<?php echo $td['ΤΙΤΛΟΣ']; ?>"},function(out11){
        res1 = out11;
        out11 = str1.concat(out11);
        out11 = out11.concat(str2);
        $( 'div#account_main_content' ).html(out11);
    });
    $( 'div.add_subject_button' ).hide("fast");
    $( 'div#add_manager' ).show("fast");
});

$( 'div#add_agent span.add_declar_button' ).click(function(){
    $( 'div#add_agent form' ).show("fast");
    $( 'div#add_agent span.add_declar_button' ).hide("fast");
    $( 'div#add_agent span.add_button' ).show("fast");
    $( 'div#add_agent span.cancel_button' ).show("fast");
});

$( 'div#add_manager span.add_declar_button' ).click(function(){
    $( 'div#add_manager form' ).show("fast");
    $( 'div#add_manager span.add_declar_button' ).hide("fast");
    $( 'div#add_manager span.add_button' ).show("fast");
    $( 'div#add_manager span.cancel_button' ).show("fast");
});

$( 'div#add_agent span.add_button' ).click(function(){
    var an = $('#add_agent_name').val();
    var aag = $('#add_agent_age').val();
    var ag = $('#add_agent_gender').val();
    var na = '<tr class = "agen_list_main"><td>';
    na = na.concat(an);
    na = na.concat("</td><td>");
    na = na.concat(ag);
    na = na.concat("</td></tr>");
    if(an == "ΟΝΟΜΑ" || an == "" )
        $('#add_agent_name').css("background-color", "red");
    else if(isNaN(parseFloat(aag)) || !isFinite(aag))
        $('#add_agent_age').css("background-color", "red");
    else
    {
        $.post("add_agent.php",{aid: "<?php echo $td['ΤΙΤΛΟΣ']; ?>", an: an, ag:ag, aag: aag},function(out2){
            alert(out2);
            var out1 = str1.concat(res);
            out1 = out1.concat(na);
            out1 = out1.concat(str2);
            $( 'div#account_main_content' ).html(out1);
        });
        $( 'div#add_agent form' ).hide("fast");
        $( 'div#add_agent span.add_declar_button' ).show("fast");
        $( 'div#add_agent span.add_button' ).hide("fast");
        $( 'div#add_agent span.cancel_button' ).hide("fast");
    }
});

$( 'div#add_manager span.add_button' ).click(function(){
    var mn = $('#add_manager_name').val();
    var mag = $('#add_manager_age').val();
    var mpr = $('#add_manager_priv').val();
    var mxp = $('#add_manager_exp').val();
    var mg = $('#add_manager_gender').val();
    var na = '<tr class = "agen_list_main"><td>';
    na = na.concat(mn);
    na = na.concat("</td><td>");
    na = na.concat(mg);
    na = na.concat("</td></tr>");
    if(mn == "ΟΝΟΜΑ" || mn == "")
        $('#add_manager_name').css("background-color", "red");
    else if(isNaN(parseFloat(mag)) || !isFinite(mag))
        $('#add_manager_age').css("background-color", "red");
    else if(isNaN(parseFloat(mxp)) || !isFinite(mxp))
        $('#add_manager_exp').css("background-color", "red");
    else if(mpr == '' || mpr == 'ΑΞΙΩΜΑ')
        $('#add_manager_priv').css("background-color", "red");
    else
    {
        $.post("add_manager.php",{aid: "<?php echo $td['ΤΙΤΛΟΣ']; ?>", mn: mn, mg:mg, mag: mag, mxp: mxp, mpr: mpr },function(out21){
            alert(out21);
            var out21 = str1.concat(res1);
            out21 = out21.concat(na);
            out21 = out21.concat(str2);
            $( 'div#account_main_content' ).html(out21);
        });
        $( 'div#add_manager form' ).hide("fast");
        $( 'div#add_manager span.add_declar_button' ).show("fast");
        $( 'div#add_manager span.add_button' ).hide("fast");
        $( 'div#add_manager span.cancel_button' ).hide("fast");
    }
});

$( 'div#add_agent span.cancel_button' ).click(function(){
    $( 'div#add_agent form' ).hide("fast");
    $( 'div#add_agent span.add_declar_button' ).show("fast");
    $( 'div#add_agent span.add_button' ).hide("fast");
    $( 'div#add_agent span.cancel_button' ).hide("fast");
});

$( 'div#add_manager span.cancel_button' ).click(function(){
    $( 'div#add_manager form' ).hide("fast");
    $( 'div#add_manager span.add_declar_button' ).show("fast");
    $( 'div#add_manager span.add_button' ).hide("fast");
    $( 'div#add_manager span.cancel_button' ).hide("fast");
});

</script>
