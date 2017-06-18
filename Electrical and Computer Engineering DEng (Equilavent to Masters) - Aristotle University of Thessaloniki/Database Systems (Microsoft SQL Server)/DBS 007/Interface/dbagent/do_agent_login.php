<?php
include "Connect_Web.php";
include "Connect.php";
session_start();
if( isset( $_SESSION[ 'agent_id' ] ) ){
    header( 'Location: http://dbagent.comyr.com/agent_account.php' );
}
else if( isset( $_POST[ 'agent_ref' ] ) ){
    $a_r=mysql_real_escape_string($_POST[ 'agent_ref' ]);
    $p_w=mysql_real_escape_string($_POST[ 'password' ]);
    $tr=mysql_query( "SELECT password, agent_ref, agent_id FROM Agents WHERE agent_ref ='$a_r' ;", $web_db );
    echo mysql_error();
    $td=mysql_fetch_array($tr);
    if($td){
        if( MD5($p_w) != $td['password'] ){
            header( 'Location: http://dbagent.comyr.com/index.php?log_error_2' );
        }
        else{
            $_SESSION[ 'agent_id' ]=$td['agent_id'];
            header( 'Location: http://dbagent.comyr.com/agent_account.php' );
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
