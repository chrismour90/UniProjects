<?php
include "Connect_Web.php";
include "Connect.php";
session_start();
if( isset( $_SESSION[ 'agency_ref' ] ) ){
    header( 'Location: http://dbagent.comyr.com/agency_account.php' );
}
else if( isset( $_POST[ 'agency_ref' ] ) ){
    $a_r=mysql_real_escape_string($_POST[ 'agency_ref' ]);
    $p_w=mysql_real_escape_string($_POST[ 'password' ]);
    $tr=mysql_query( "SELECT password, agency_ref, agency_title FROM Agencies WHERE agency_ref ='$a_r' ;", $web_db );
    echo mysql_error();
    $td=mysql_fetch_array($tr);
    if($td){
        if( MD5($p_w) != $td['password'] ){
            header( 'Location: http://dbagent.comyr.com/index.php?log_error_2' );
        }
        else{
            $_SESSION[ 'agency_ref' ]=$a_r;
            $name=$td['agency_title'];
            $_SESSION[ 'name' ]=$name;
            header( 'Location: http://dbagent.comyr.com/agency_account.php' );
        }	  
    }
    else{

        header( 'Location: http://dbagent.comyr.com/index.php?log_error_1' );
    }
}
else{
    header( 'Location: http://dbagent.comyr.com/index.php' );
}



?>

