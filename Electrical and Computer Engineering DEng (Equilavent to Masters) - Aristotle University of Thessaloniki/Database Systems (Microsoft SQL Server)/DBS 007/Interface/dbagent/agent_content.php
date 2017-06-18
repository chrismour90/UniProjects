<?php
if( isset( $_SESSION[ 'agent_id' ] ) )
{
    include "Connect.php";
    $a_r = $_SESSION[ 'agent_id' ]; 
    $tr=mysql_query( "SELECT ΠΡΑΚΤΟΡΕΣ.ID AS ID, ΠΡΑΚΤΟΡΕΣ.ΟΝΟΜΑ AS ΟΝΟΜΑ, ΠΡΑΚΤΟΡΕΣ.ΗΛΙΚΙΑ AS ΗΛΙΚΙΑ, ΠΡΑΚΤΟΡΕΣ.ΦΥΛΟ AS ΦΥΛΟ, ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ FROM ΠΡΑΚΤΟΡΕΣ, ΔΙΑΧΕΙΡΙΣΤΕΣ WHERE ΠΡΑΚΤΟΡΕΣ.ID ='$a_r' AND ID_ΔΙΑΧΕΙΡΙΣΤΗ = ΔΙΑΧΕΙΡΙΣΤΕΣ.ID ;" );
    echo mysql_error();
    $td=mysql_fetch_array($tr);
?>
<div id = "sidebar">
<p id = "agen_img_sidebar">
<img src = "icons/james_bond_secret_agent_007_black_amp_white_silo_120175.jpg" title = "agent"/>
<span><?php echo $td['ΟΝΟΜΑ']; ?></span>
</p>
<p id = "agen_personal_info" class = "agen_options_sidebar">
<span>Προσωπικά στοχεία</span>
</p>
<p id = "agen_settings" class = "agen_options_sidebar">
<span>Μεταβολή προσωπικών στοιχείων</span>
</p>
<p id = "agen_show_mission" class = "agen_options_sidebar">
<span>Η αποστολή μου</span>
</p>
</div>
<div id = "account_main_content">
<p>Όνομα: <?php echo $td['ΟΝΟΜΑ']; ?></p>
<p>Φύλο: <?php echo $td['ΦΥΛΟ']; ?></p>
<p>Ηλικία: <?php echo $td['ΗΛΙΚΙΑ']; ?></p>
<p>Υπηρεσία: <?php echo $td['ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ']; ?></p>
<form method = "post" action = "update_agent.php" id = "agent_personal_setting">
Φύλο: <select name = "gender" id = "update_agent_gender">
<?php 
    if($td['ΦΥΛΟ'] == "ΑΝΔΡΑΣ")
    {
?>
<option value = "ΑΝΔΡΑΣ">Άνδρας</option>
<option value = "ΓΥΝΑΙΚΑ">Γυναίκα</option>
<?php
    }
    else
    {
?>
<option value = "ΓΥΝΑΙΚΑ">Γυναίκα</option>
<option value = "ΑΝΔΡΑΣ">Άνδρας</option>
<?php
    }
?>
</select>
Ηλικία: <input type = "text"  name = "age" id = "update_agent_age" value = "<?php echo $td['ΗΛΙΚΙΑ']; ?>"/>
<input class = "ok_selection_button" type = "submit" value = "OK"/>
</form>
</div>
<?php
}
else
{
    header( 'Location: http://dbagent.comyr.com/index.php' );
}
?>

<script type="text/javascript">
var infkept = 0;
var info;
$( 'div#sidebar p#agen_settings' ).click(function(){
    if(infkept)
        $( 'div#account_main_content' ).html(info);
    $( 'div#account_main_content p' ).hide("fast");
    $( 'div#account_main_content form#agent_personal_setting' ).show("fast");
    $( '.ok_selection_button' ).show("fast");
});

$( 'div#sidebar p#agen_personal_info' ).click(function(){
    if(infkept)
        $( 'div#account_main_content' ).html(info);
    $( 'div#account_main_content p' ).show("fast");
    $( 'div#account_main_content form#agent_personal_setting' ).hide("fast");
    $( '.ok_selection_button' ).hide("fast");
});

$('div#sidebar p#agen_show_mission').click(function(){
    if(!infkept)
        info = $( 'div#account_main_content' ).html();
    $.post("display_mission_info.php",{aid: "<?php echo $td['ID']; ?>"},function(out1){
        infkept = 1;
        $( 'div#account_main_content' ).html(out1);
    });
});
</script>
