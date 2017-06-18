<?php
include "Connect_Web.php";
include "Connect.php";
session_start();
if(isset($_SESSION['agency_ref']))
{
    if( isset( $_POST[ 'aid' ] ) ){
        $aid=mysql_real_escape_string($_POST[ 'aid' ]);
        $an=mysql_real_escape_string($_POST[ 'an' ]);
        $ag=mysql_real_escape_string($_POST[ 'ag' ]);
        $aman=mysql_real_escape_string($_POST[ 'aman' ]);
        $mission=mysql_real_escape_string($_POST[ 'mission' ]);
        $tr = mysql_query( "SELECT manager_id FROM Managers WHERE manager_ref = '$aman';", $web_db);
        //    echo mysql_error();
        $td = mysql_fetch_array($tr);
        if($td)
        {
            $mid = $td['manager_id'];
            mysql_query( "UPDATE ΠΡΑΚΤΟΡΕΣ SET ΟΝΟΜΑ = '$an', ΦΥΛΟ = '$ag', ID_ΔΙΑΧΕΙΡΙΣΤΗ = '$mid' WHERE ID ='$aid' ;", $cbb_db );
            echo mysql_error();
            $tr = mysql_query( "SELECT ID FROM ΑΠΟΣΤΟΛΕΣ WHERE ID = '$mission';", $cbb_db);
            //    echo mysql_error();
            $td = mysql_fetch_array($tr);
            if($td)
            {
                mysql_query( "UPDATE ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ SET ID_ΑΠΟΣΤΟΛΗΣ = '$mission' WHERE ID_ΠΡΑΚΤΟΡΑ ='$aid' ;", $cbb_db );
                echo mysql_error();
                echo "1";
            }
            else
            {
                echo "-1";
            }
        }
        else
        {
            echo "0";
        }
?>
<?php
    }
    else{

        header( 'Location: http://dbagent.comyr.com/manage_members.php' );
    }
}
elseif(isset($_SESSION['manager_id']))
{
    if(isset($_POST['gender']))
    {
        $mid = $_SESSION['manager_id'];
        $ag = $_POST['gender'];
        $aag = $_POST['age'];
        mysql_query( "UPDATE ΔΙΑΧΕΙΡΙΣΤΕΣ SET ΦΥΛΟ = '$ag', ΗΛΙΚΙΑ = '$aag' WHERE ID ='$mid' ;", $cbb_db );
        echo mysql_error();
        header( 'Location: http://dbagent.comyr.com/manager_account.php' );
    }
    else
    {
        header( 'Location: http://dbagent.comyr.com/manager_account.php' );
    }
}
else
{
    header( 'Location: http://dbagent.comyr.com/index.php' );
}



?>


