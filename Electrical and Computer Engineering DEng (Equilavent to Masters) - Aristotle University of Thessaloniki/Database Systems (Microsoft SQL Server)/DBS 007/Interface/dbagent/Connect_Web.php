<?php
//    $web_db = mysql_connect("localhost","root","");
//    mysql_select_db("web_dbagent", $web_db);
      $web_db = mysql_connect("dbagent.cjehxaxuen4q.us-west-2.rds.amazonaws.com", "dbagent", "vgkx12345", "3306");
      mysql_select_db("web_dbagent", $web_db);
    echo mysql_error();	
?>

