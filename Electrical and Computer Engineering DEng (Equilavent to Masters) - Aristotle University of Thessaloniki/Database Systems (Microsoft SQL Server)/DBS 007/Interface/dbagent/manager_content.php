<?php
if( isset( $_SESSION[ 'manager_id' ] ) )
{
    include "Connect.php";
    $m_r = $_SESSION[ 'manager_id' ]; 
    $tr=mysql_query( "SELECT ID, ΟΝΟΜΑ, ΗΛΙΚΙΑ, ΦΥΛΟ, ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ FROM ΔΙΑΧΕΙΡΙΣΤΕΣ WHERE ID ='$m_r';" );
    echo mysql_error();
    $td=mysql_fetch_array($tr);
?>
<div id = "sidebar">
<p id = "agen_img_sidebar">
<img src = "icons/_Secret_Agent_Man__by_LiteFireDark.jpg" title = "agent"/>
<span><?php echo $td['ΟΝΟΜΑ']; ?></span>
</p>
<p id = "agen_personal_info" class = "agen_options_sidebar">
<span>Προσωπικά στοχεία</span>
</p>
<p id = "agen_settings" class = "agen_options_sidebar">
<span>Μεταβολή προσωπικών στοιχείων</span>
</p>
<p id = "agen_show_agents" class = "agen_options_sidebar">
<a href = "agents_management.php">Διαχείριση των πρακτόρων μου</a>
</p>
<p id = "agen_make_review" class = "agen_options_sidebar">
<a href = "agents_reviewing.php">Αξιολόγηση πρακτόρων για ολοκληρωμένες αποστολές</a>
</p>
</div>
<div id = "account_main_content">
<p>Όνομα: <?php echo $td['ΟΝΟΜΑ']; ?></p>
<p>Φύλο: <?php echo $td['ΦΥΛΟ']; ?></p>
<p>Ηλικία: <?php echo $td['ΗΛΙΚΙΑ']; ?></p>
<p>Υπηρεσία: <?php echo $td['ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ']; ?></p>
<form method = "post" action = "update_manager.php" id = "manager_personal_setting">
Φύλο: <select name = "gender" id = "update_manager_gender">
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
Ηλικία: <input type = "text"  name = "age" id = "update_manager_age" value = "<?php echo $td['ΗΛΙΚΙΑ']; ?>"/>
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
    $( 'div#account_main_content form#manager_personal_setting' ).show("fast");
    $( '.ok_selection_button' ).show("fast");
});

$( 'div#sidebar p#agen_personal_info' ).click(function(){
    if(infkept)
        $( 'div#account_main_content' ).html(info);
    $( 'div#account_main_content p' ).show("fast");
    $( 'div#account_main_content form#manager_personal_setting' ).hide("fast");
    $( '.ok_selection_button' ).hide("fast");
});

//$('div#sidebar p#agen_show_agents').click(function(){
//    if(!infkept)
//        info = $( 'div#account_main_content' ).html();
//    $.post("display_manager_agents_info.php",{mid: "<?php echo $td['ID']; ?>"},function(out1){
//        infkept = 1;
//        $( 'div#account_main_content' ).html(out1);
//    });
//});
</script>

