<?php
session_start();
include "Connect.php";
if( isset( $_POST[ 'rev' ] ) ){
    $aid=mysql_real_escape_string($_POST[ 'aid' ]);
    $msid=mysql_real_escape_string($_POST[ 'msid' ]);
    $mid=mysql_real_escape_string($_POST[ 'mid' ]);
    $rev=mysql_real_escape_string($_POST[ 'rev' ]);
    $gr=mysql_real_escape_string($_POST[ 'gr' ]);
    $tr=mysql_query( "INSERT INTO ΑΞΙΟΛΟΓΗΣΕΙΣ (ID_ΔΙΑΧΕIΡΙΣΤΗ, ID_ΠΡΑΚΤΟΡΑ, ID_ΑΠΟΣΤΟΛΗΣ, ΒΑΘΜΟΣ, ΣΧΟΛΙΟ) VALUES ('$mid', '$aid', '$msid', '$gr', '$rev') ;" );
    echo mysql_error();
}
else{

    header( 'Location: http://dbagent.comyr.com/agents_reviewing_content.php' );
}

?>
