<?php
include "Connect.php";
if( isset( $_SESSION[ 'manager_id' ] ) ){
    $mid = $_SESSION[ 'manager_id' ]; 
    $tr=mysql_query( "SELECT ΠΡΑΚΤΟΡΕΣ.ID AS ID, ΠΡΑΚΤΟΡΕΣ.ΟΝΟΜΑ AS ΟΝΟΜΑ, ΑΠΟΣΤΟΛΕΣ.ID AS ΑΠΟΣΤΟΛΗ_ID FROM ΠΡΑΚΤΟΡΕΣ, ΑΠΟΣΤΟΛΕΣ, ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ  WHERE ID_ΔΙΑΧΕΙΡΙΣΤΗ = '$mid' AND ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ.ID_ΠΡΑΚΤΟΡΑ = ΠΡΑΚΤΟΡΕΣ.ID AND ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ.ID_ΑΠΟΣΤΟΛΗΣ = ΑΠΟΣΤΟΛΕΣ.ID AND ΑΠΟΣΤΟΛΕΣ.ΑΠΟΤΕΛΕΣΜΑ IS NOT NULL;", $cbb_db );
    echo mysql_error();
?>
<table>
<tr><td>Όνομα Πράκτορα</td><td>Αποστολή</td><td>Βαθμός</td><td>Καταχώρηση αξιολόγησης</td><td></td></tr>
<?php
    $td=mysql_fetch_array($tr);
    $ai = 0;
    while($td)
    {
?>
    <tr id = "agent<?php echo $td['ID']; ?>"><td><?php echo $td['ΟΝΟΜΑ']; ?> </td><td class = "mission_declar"><span class = "display_member_info">##<?php echo $td['ΑΠΟΣΤΟΛΗ_ID']; ?></span></td><td><select class = "grade_select"><?php for($gri = 1;$gri<= 10; $gri ++){ ?><option><?php echo $gri; ?></option><?php } ?> </select></td><td><textarea name="review" cols="40" rows="5" maxlength="120"></textarea></td><td><span class = "submit_review_button">Submit >></span></td></tr>
<?php
        $Agents[$ai] = $td['ID'];
        $Missions[$ai] = $td['ΑΠΟΣΤΟΛΗ_ID'];
        $ai ++;
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

    $( 'tr#agent<?php echo $Agents[$i]; ?> span.submit_review_button' ).click(function(){
        alert("fjfd");
        var gr = $('tr#agent<?php echo $Agents[$i]; ?> select').val();
        var rev = $('tr#agent<?php echo $Agents[$i]; ?> textarea').val();
        if(rev == '')
            $('tr#agent<?php echo $Agents[$i]; ?> textarea').css("background-color", "red");
        else
        {
            $.post("place_review.php", {aid: "<?php echo $Agents[$i]; ?>", msid: "<?php echo $Missions[$i]; ?>", mid: "<?php echo $_SESSION['manager_id']; ?>", gr: gr, rev: rev}, function(outrev){
                $( 'tr#agent<?php echo $Agents[$i]; ?>).hide("fast");
            });
        }

    });
<?php 
}
?>
</script>



