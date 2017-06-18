<?php

include "Connect_Web.php";
include "Connect.php";
include "rand_unq.php";
session_start();
if( isset( $_POST[ 'aid' ] ) AND isset( $_POST[ 'mn' ] ) AND isset( $_POST[ 'mg' ] ) ){
    $aid=mysql_real_escape_string($_POST[ 'aid' ]);
    $mn=mysql_real_escape_string($_POST[ 'mn' ]);
    $mag=mysql_real_escape_string($_POST[ 'mag' ]);
    $mxp=mysql_real_escape_string($_POST[ 'mxp' ]);
    $mpr=mysql_real_escape_string($_POST[ 'mpr' ]);
    $mg=mysql_real_escape_string($_POST[ 'mg' ]);
    echo $mpr;
    mysql_query( "INSERT INTO ΔΙΑΧΕΙΡΙΣΤΕΣ (ΟΝΟΜΑ, ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ, ΦΥΛΟ, ΗΛΙΚΙΑ, ΧΡΟΝΙΑ_ΕΜΠΕΙΡΙΑΣ, ΑΞΙΩΜΑ) VALUES ('$mn', '$aid', '$mg', '$mag', '$mxp', '$mpr') ;", $cbb_db );
    echo mysql_error();
    $nid = mysql_insert_id($cbb_db);
    $mr = getToken(8);
    $pw = "12345";
    mysql_query( "INSERT INTO Managers (manager_ref, manager_id) VALUES ('$mr', '$nid') ;", $web_db );
    echo mysql_error();
}
else{

    header( 'Location: http://dbagent.comyr.com/agency_account.php' );
}



?>

