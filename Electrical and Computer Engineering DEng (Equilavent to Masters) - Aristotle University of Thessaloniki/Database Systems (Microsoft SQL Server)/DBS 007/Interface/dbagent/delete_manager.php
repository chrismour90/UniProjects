<?php
include "Connect.php";
session_start();
if( isset( $_POST[ 'mid' ] ) ){
    $mid=mysql_real_escape_string($_POST[ 'mid' ]);
    $tr=mysql_query( "DELETE FROM ΔΙΑΧΕΙΡΙΣΤΕΣ WHERE ID ='$mid' ;" );
    echo mysql_error();
?>
<?php
}
else{

    header( 'Location: http://dbagent.comyr.com/manage_members.php' );
}



?>

