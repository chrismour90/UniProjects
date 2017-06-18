
<?php

include "Connect.php";
session_start();
if( isset( $_POST[ 'aid' ] ) ){
    $aid=mysql_real_escape_string($_POST[ 'aid' ]);
    $tr=mysql_query( "SELECT ΠΡΑΚΤΟΡΕΣ.ΟΝΟΜΑ, ΠΡΑΚΤΟΡΕΣ.ΦΥΛΟ FROM ΠΡΑΚΤΟΡΕΣ, ΔΙΑΧΕΙΡΙΣΤΕΣ WHERE ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ ='$aid' AND ID_ΔΙΑΧΕΙΡΙΣΤΗ = ΔΙΑΧΕΙΡΙΣΤΕΣ.ID ;" );
    echo mysql_error();
    $td=mysql_fetch_array($tr);
?>
<tr id = "agen_list_title"><td>Όνομα</td><td>Φύλο</td></tr>

<?php
    while($td)
    {
?>
<tr class = "agen_list_main"><td><?php echo $td['ΟΝΟΜΑ']; ?></td><td><?php echo $td['ΦΥΛΟ']; ?></td></tr>
<?php

        $td=mysql_fetch_array($tr);
    }
?>
<?php
}
else{

    header( 'Location: http://dbagent.comyr.com/agency_account.php' );
}



?>

