<?php
include "Connect_Web.php";
include "Connect.php";
session_start();
if( isset( $_SESSION[ 'manager_id' ] ) ){
    header( 'Location: http://dbagent.comyr.com/manager_account.php' );
}
else if( isset( $_POST[ 'manager_ref' ] ) ){
    $m_r=mysql_real_escape_string($_POST[ 'manager_ref' ]);
    $p_w=mysql_real_escape_string($_POST[ 'password' ]);
    $tr=mysql_query( "SELECT password, manager_ref, manager_id FROM Managers WHERE manager_ref ='$m_r' ;", $web_db );
    echo mysql_error();
    $td=mysql_fetch_array($tr);
    if($td){
        if( MD5($p_w) != $td['password'] ){
            header( 'Location: http://dbagent.comyr.com/index.php?log_error_2' );
        }
        else{
            $_SESSION[ 'manager_id' ]=$td['manager_id'];
            header( 'Location: http://dbagent.comyr.com/manager_account.php' );
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

