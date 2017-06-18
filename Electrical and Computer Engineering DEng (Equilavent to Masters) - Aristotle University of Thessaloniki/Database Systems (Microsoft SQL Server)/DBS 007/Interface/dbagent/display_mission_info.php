<?php
include "Connect.php";
session_start();
if( isset( $_POST[ 'aid' ] ) ){
    $aid=mysql_real_escape_string($_POST[ 'aid' ]);
    $tr=mysql_query( "SELECT ΔΙΑΧΕΙΡΙΣΤΕΣ.ΟΝΟΜΑ AS ΟΝΟΜΑ, ΥΠΗΡΕΣΙΕΣ.ΤΗΛΕΦΩΝΟ AS ΤΗΛΕΦΩΝΟ, ΑΠΟΣΤΟΛΕΣ.ΠΕΡΙΓΡΑΦΗ AS ΠΕΡΙΓΡΑΦΗ FROM ΥΠΗΡΕΣΙΕΣ, ΔΙΑΧΕΙΡΙΣΤΕΣ, ΑΠΟΣΤΟΛΕΣ, ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ WHERE ΔΙΑΧΕΙΡΙΣΤΕΣ.ID IN (SELECT ID_ΔΙΑΧΕΙΡΙΣΤΗ FROM ΠΡΑΚΤΟΡΕΣ WHERE ID = '$aid') AND ΥΠΗΡΕΣΙΕΣ.ΤΙΤΛΟΣ = ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ AND ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ.ID_ΠΡΑΚΤΟΡΑ = '$aid' AND ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ.ID_ΑΠΟΣΤΟΛΗΣ = ΑΠΟΣΤΟΛΕΣ.ID;" );
    echo mysql_error();
    $td=mysql_fetch_array($tr);
?>
<p>Όνομα διαχειριστή: <?php echo $td['ΟΝΟΜΑ']; ?></p>
<p>Τηλέφωνο υπηρεσίας: <?php echo $td['ΤΗΛΕΦΩΝΟ']; ?></p>
<p>Τρέχουσα αποστολή: <?php echo $td['ΠΕΡΙΓΡΑΦΗ']; ?></p>

<?php
}
else{

    header( 'Location: http://dbagent.comyr.com/agent_account.php' );
}



?>


