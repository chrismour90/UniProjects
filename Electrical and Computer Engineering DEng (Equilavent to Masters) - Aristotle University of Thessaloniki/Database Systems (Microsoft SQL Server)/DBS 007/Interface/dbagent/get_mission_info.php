<?php

include "Connect.php";
session_start();
if( isset( $_POST[ 'msid' ] ) ){
    $msid=mysql_real_escape_string($_POST[ 'msid' ]);
    $tr=mysql_query( "SELECT ΠΕΡΙΓΡΑΦΗ FROM ΑΠΟΣΤΟΛΕΣ WHERE ID ='$msid' ;" );
    echo mysql_error();
    $td=mysql_fetch_array($tr);
?>
    <p class = "mission_description">Περιγραφή: <?php echo $td['ΠΕΡΙΓΡΑΦΗ']; ?></p>
<?php
    $tr = mysql_query("SELECT ΟΝΟΜΑ FROM ΠΡΑΚΤΟΡΕΣ WHERE ID IN (SELECT ID_ΠΡΑΚΤΟΡΑ FROM ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ WHERE ID_ΑΠΟΣΤΟΛΗΣ = '$msid');");
    $td = mysql_fetch_array($tr);
?>
<div id = "agents_mission" class = "mission_info_object">
<p>Συμμετέχοντες Πράκτορες</p>
<table>
<tr><td>ΟΝΟΜΑ</td></tr>
<?php
    while($td)
    {
?>
    <tr><td><?php echo $td['ΟΝΟΜΑ']; ?></td></tr>
<?php
        $td = mysql_fetch_array($tr);
    }
?>
</table>
</div>
<?php
    $tr = mysql_query("SELECT ΟΝΟΜΑ FROM ΕΓΚΛΗΜΑΤΙΕΣ WHERE ID IN (SELECT ID_ΕΓΚΛΗΜΑΤΙΑ FROM ΑΠΟΣΤΟΛΕΣ_ΕΓΚΛΗΜΑΤΙΕΣ WHERE ID_ΑΠΟΣΤΟΛΗΣ = '$msid');");
    $td = mysql_fetch_array($tr);
?>
<div id = "criminals_mission" class = "mission_info_object">
<p>Εμπλεκόμενοι Εγκληματίες</p>
<table>
<tr><td>ΟΝΟΜΑ</td></tr>
<?php
    while($td)
    {
?>
    <tr><td><?php echo $td['ΟΝΟΜΑ']; ?></td></tr>
<?php
        $td = mysql_fetch_array($tr);
    }
?>
</table>
</div>
<?php
}
else{

    header( 'Location: http://dbagent.comyr.com/manage_members_content.php' );
}
?>

