<?php

include "Connect.php";
session_start();
if( isset( $_POST[ 'aag' ] ) AND isset( $_POST[ 'an' ] ) AND isset( $_POST[ 'ag' ] ) ){
    $aid = $_SESSION['name'];
    $tr = mysql_query("SELECT ID FROM ΔΙΑΧΕΙΡΙΣΤΕΣ WHERE ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ = '$aid';");
    echo mysql_error();
    $td = mysql_fetch_array($tr);
    $mid = $td['ID'];
    echo $mid;
    $an=mysql_real_escape_string($_POST[ 'an' ]);
    $ag=mysql_real_escape_string($_POST[ 'ag' ]);
    $aag=mysql_real_escape_string($_POST[ 'aag' ]);
    $tr=mysql_query( "INSERT INTO ΠΡΑΚΤΟΡΕΣ (ΟΝΟΜΑ, ΦΥΛΟ, ΗΛΙΚΙΑ, ID_ΔΙΑΧΕΙΡΙΣΤΗ, ΚΑΤΑΣΤΑΣΗ) VALUES ('$an', '$ag', '$aag', '$mid', 'ΔΙΑΘΕΣΙΜΟΣ') ;" );
    echo mysql_error();
}
else{

    header( 'Location: http://dbagent.comyr.com/agency_account.php' );
}



?>
