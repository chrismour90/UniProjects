<?php
include "Connect_Web.php";
include "Connect.php";
if( isset( $_SESSION[ 'manager_id' ] ) ){
    $mid = $_SESSION[ 'manager_id' ]; 
    $tr=mysql_query( "SELECT ΟΝΟΜΑ, ΦΥΛΟ, ΠΡΑΚΤΟΡΕΣ.ID AS ID, ΑΠΟΣΤΟΛΕΣ.ID AS ΑΠΟΣΤΟΛΗ_ID FROM ΠΡΑΚΤΟΡΕΣ, ΑΠΟΣΤΟΛΕΣ, ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ  WHERE ID_ΔΙΑΧΕΙΡΙΣΤΗ = '$mid' AND ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ.ID_ΠΡΑΚΤΟΡΑ = ΠΡΑΚΤΟΡΕΣ.ID AND ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ.ID_ΑΠΟΣΤΟΛΗΣ = ΑΠΟΣΤΟΛΕΣ.ID ;", $cbb_db );
    echo mysql_error();
?>
<table>
<tr><td>Όνομα</td><td>Φύλο</td><td>Τρέχουσα αποστολή</td></tr>
<?php
    $td=mysql_fetch_array($tr);
    $ai = 0;
    while($td)
    {
?>
<tr id = "agent<?php echo $td['ID']; ?>"><td><?php echo $td['ΟΝΟΜΑ']; ?></td><td><?php echo $td['ΦΥΛΟ']; ?></td><td class = "mission_declar"><span class = "display_member_info">##<?php echo $td['ΑΠΟΣΤΟΛΗ_ID']; ?></span></td></tr>
<?php
        $Agents[$ai] = $td['ID'];
        $ai ++;
        $td=mysql_fetch_array($tr);
    }
    $tr=mysql_query( "SELECT ΟΝΟΜΑ, ΦΥΛΟ FROM ΠΡΑΚΤΟΡΕΣ WHERE ID_ΔΙΑΧΕΙΡΙΣΤΗ = '$mid' AND ID NOT IN (SELECT ID_ΠΡΑΚΤΟΡΑ FROM ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ);", $cbb_db );
    $td=mysql_fetch_array($tr);
    while($td)
    {
?>
<tr><td><?php echo $td['ΟΝΟΜΑ']; ?></td><td><?php echo $td['ΦΥΛΟ']; ?></td><td><span>---</span></td></tr>
<?php
        $td=mysql_fetch_array($tr);
    }
?>
</table>
<div class = "alert_box"><span class = "close_alert_box">OK</span></div>
<div class = "mission_information"></div>
<p class = "close_mission_information">X Κλείσιμο</p>

<?php
}
else{

    header( 'Location: http://dbagent.comyr.com/index.php' );
}
?>


<script type="text/javascript">
var mission = "";

$('div.alert_box').click(function(){
    $('div.alert_box').html('<span class = "close_alert_box">OK</span>');
    $('div.alert_box').hide("fast");
});

$('p.close_mission_information').click(function(){
    $('div.mission_information').hide("fast");
    $('p.close_mission_information').hide("fast");
});

<?php 
for($i = 0; $i < $ai; $i ++)
{
?>

    $( 'tr#agent<?php echo $Agents[$i]; ?> td.mission_declar' ).click(function(){
        var temp_msid = $( 'tr#agent<?php echo $Agents[$i]; ?> td.mission_declar' ).text();
        temp_msid = temp_msid.split("##");
        var msid = temp_msid[1];
        $.post("get_mission_info.php", {msid: msid}, function(outms){
            $('div.mission_information').html(outms).show();
            $('p.close_mission_information').show("fast");
        });
    });
<?php 
}
?>
</script>


