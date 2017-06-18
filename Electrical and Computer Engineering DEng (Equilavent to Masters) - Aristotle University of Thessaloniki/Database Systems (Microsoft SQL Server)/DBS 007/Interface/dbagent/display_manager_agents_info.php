<?php
include "Connect.php";
session_start();
if( isset( $_POST[ 'mid' ] ) ){
    $mid=mysql_real_escape_string($_POST[ 'mid' ]);
    $tr=mysql_query( "SELECT ΟΝΟΜΑ, ΦΥΛΟ FROM ΠΡΑΚΤΟΡΕΣ  WHERE ID_ΔΙΑΧΕΙΡΙΣΤΗ = '$mid' ;" );
    echo mysql_error();
?>
<table>
<tr><td>Όνομα</td><td>Φύλο</td></tr>
<?php
    $td=mysql_fetch_array($tr);
    while($td)
    {
?>
<tr><td><?php echo $td['ΟΝΟΜΑ']; ?></td><td><?php echo $td['ΦΥΛΟ']; ?></td></tr>
<?php
        $td=mysql_fetch_array($tr);
    }
?>
</table>
<?php
}
else{

    header( 'Location: http://dbagent.comyr.com/manager_account.php' );
}



?>

