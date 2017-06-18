<?php
//    $cbb_db = mysql_connect("localhost","root","", true);
//    mysql_select_db("temp_dbagent", $cbb_db);
      $cbb_db = mysql_connect("dbagent.cjehxaxuen4q.us-west-2.rds.amazonaws.com", "dbagent", "vgkx12345", "3306", true);
    mysql_select_db("dbagent", $cbb_db);
    echo mysql_error();	
    mysql_query("SET NAMES 'utf8'");
?>
