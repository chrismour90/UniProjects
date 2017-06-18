<?php
include "Connect.php";
session_start();
if( isset( $_POST[ 'aid' ] ) ){
    $aid=mysql_real_escape_string($_POST[ 'aid' ]);
    $tr=mysql_query( "DELETE FROM ΠΡΑΚΤΟΡΕΣ WHERE ID ='$aid' ;" );
    echo mysql_error();
?>
<?php
}
else{

    header( 'Location: http://dbagent.comyr.com/manage_members.php' );
}



?>
