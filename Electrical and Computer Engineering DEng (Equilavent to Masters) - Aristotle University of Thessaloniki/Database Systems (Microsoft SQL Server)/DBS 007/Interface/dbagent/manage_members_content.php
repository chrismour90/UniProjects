<?php
include "Connect_Web.php";
include "Connect.php";
if( isset( $_SESSION[ 'agency_ref' ] ) ){
    $a_r = $_SESSION[ 'name' ]; 
?>
<div id = "manage_agents_tab" class = "manage_members_tabs">
<?php
    $tr=mysql_query( "SELECT A.ID, A.ΟΝΟΜΑ, A.ΦΥΛΟ, A.ID_ΔΙΑΧΕΙΡΙΣΤΗ, ΑΠΟΣΤΟΛΕΣ.ID AS ΑΠΟΣΤΟΛΗ_ID, ΑΠΟΣΤΟΛΕΣ.ΠΕΡΙΓΡΑΦΗ AS ΠΕΡΙΓΡΑΦΗ FROM (SELECT ΠΡΑΚΤΟΡΕΣ.ID AS ID, ΠΡΑΚΤΟΡΕΣ.ΟΝΟΜΑ AS ΟΝΟΜΑ, ΠΡΑΚΤΟΡΕΣ.ΦΥΛΟ AS ΦΥΛΟ, ΠΡΑΚΤΟΡΕΣ.ID_ΔΙΑΧΕΙΡΙΣΤΗ AS ID_ΔΙΑΧΕΙΡΙΣΤΗ FROM ΠΡΑΚΤΟΡΕΣ LEFT JOIN ΔΙΑΧΕΙΡΙΣΤΕΣ ON ΠΡΑΚΤΟΡΕΣ.ID_ΔΙΑΧΕΙΡΙΣΤΗ = ΔΙΑΧΕΙΡΙΣΤΕΣ.ID WHERE ΔΙΑΧΕΙΡΙΣΤΕΣ.ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ IN (SELECT ΤΙΤΛΟΣ FROM ΥΠΗΡΕΣΙΕΣ WHERE ΤΙΤΛΟΣ = '$a_r')) A, ΑΠΟΣΤΟΛΕΣ, ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ WHERE (ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ.ID_ΠΡΑΚΤΟΡΑ = A.ID AND ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ.ID_ΑΠΟΣΤΟΛΗΣ = ΑΠΟΣΤΟΛΕΣ.ID) OR (A.ID_ΔΙΑΧΕΙΡΙΣΤΗ = 0);", $cbb_db );
    echo mysql_error();
    $td=mysql_fetch_array($tr);
?>
<p class = "manage_tabs_titles">Πράκτορες</p>
<table>
<tr id = "agen_list_title"><td>Όνομα</td><td>Φύλο</td><td>Διαχειριστής</td><td>Αποστολή</td></tr>

<?php
    $ai = 0;
    while($td)
    {
        $manid = $td['ID_ΔΙΑΧΕΙΡΙΣΤΗ'];
        $tr1 = mysql_query("SELECT manager_ref FROM Managers WHERE manager_id = '$manid';", $web_db);
        echo mysql_error();
        $td1 = mysql_fetch_array($tr1);
?>
    <tr id = "agent<?php echo $td['ID']; ?>" class = "agen_list_main">
<td><span class = "display_member_info"><?php echo $td['ΟΝΟΜΑ']; ?></span><input id = "update_name" class = "update_member_info" type="text" value = "<?php echo $td['ΟΝΟΜΑ']; ?>"/></td>
<td><span class = "display_member_info"><?php echo $td['ΦΥΛΟ']; ?></span><select id = "update_gender" class = "update_member_info"><option <?php if($td['ΦΥΛΟ'] == "ΑΝΔΡΑΣ"){ ?> selected = "selected"<?php } ?>>ΑΝΔΡΑΣ</option><option <?php if($td['ΦΥΛΟ'] == "ΓΥΝΑΙΚΑ"){ ?> selected = "selected"<?php } ?>>ΓΥΝΑΙΚΑ</option></select></td>
    <td><span class = "display_member_info"><?php echo $td1['manager_ref']; ?></span><input id = "update_manager" class = "update_member_info" type="text" value = "<?php echo $td1['manager_ref']; ?>"/></td>
    <td class = "mission_declar"><span class = "display_member_info">##<?php echo $td['ΑΠΟΣΤΟΛΗ_ID']; ?></span><input id = "update_mission" class = "update_member_info" type="text" value = "<?php echo $td['ΑΠΟΣΤΟΛΗ_ID']; ?>"/></td></tr>
<?php
        $Agents[$ai] = $td['ID'];
        $ai ++;
        $td=mysql_fetch_array($tr);
    }
    $tr = mysql_query("SELECT ΠΡΑΚΤΟΡΕΣ.ΟΝΟΜΑ, ΠΡΑΚΤΟΡΕΣ.ΦΥΛΟ, ID_ΔΙΑΧΕΙΡΙΣΤΗ, ΠΡΑΚΤΟΡΕΣ.ID FROM ΠΡΑΚΤΟΡΕΣ, ΔΙΑΧΕΙΡΙΣΤΕΣ WHERE ID_ΔΙΑΧΕΙΡΙΣΤΗ = ΔΙΑΧΕΙΡΙΣΤΕΣ.ID AND ΔΙΑΧΕΙΡΙΣΤΕΣ.ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ = '$a_r' AND ΠΡΑΚΤΟΡΕΣ.ID NOT IN (SELECT ID_ΠΡΑΚΤΟΡΑ FROM ΠΡΑΚΤΟΡΕΣ_ΑΠΟΣΤΟΛΕΣ); ");
    $td = mysql_fetch_array($tr);
    while($td)
    {
        $manid = $td['ID_ΔΙΑΧΕΙΡΙΣΤΗ'];
        $tr1 = mysql_query("SELECT manager_ref FROM Managers WHERE manager_id = '$manid';", $web_db);
        echo mysql_error();
        $td1 = mysql_fetch_array($tr1);
?>
    <tr id = "agent<?php echo $td['ID']; ?>" class = "agen_list_main">
<td><span class = "display_member_info"><?php echo $td['ΟΝΟΜΑ']; ?></span><input id = "update_name" class = "update_member_info" type="text" value = "<?php echo $td['ΟΝΟΜΑ']; ?>"/></td>
<td><span class = "display_member_info"><?php echo $td['ΦΥΛΟ']; ?></span><select id = "update_gender" class = "update_member_info"><option <?php if($td['ΦΥΛΟ'] == "ΑΝΔΡΑΣ"){ ?> selected = "selected"<?php } ?>>ΑΝΔΡΑΣ</option><option <?php if($td['ΦΥΛΟ'] == "ΓΥΝΑΙΚΑ"){ ?> selected = "selected"<?php } ?>>ΓΥΝΑΙΚΑ</option></select></td>
    <td><span class = "display_member_info"><?php echo $td1['manager_ref']; ?></span><input id = "update_manager" class = "update_member_info" type="text" value = "<?php echo $td1['manager_ref']; ?>"/></td>
    <td class = "mission_declar"><span class = "display_member_info">---</span><input id = "update_mission" class = "update_member_info" type="text" value = ""/></td></tr>
<?php
        $Agents[$ai] = $td['ID'];
        $ai ++;
        $td=mysql_fetch_array($tr);
    }
?>
</table>
</div>
<div id = "manage_managers_tab" class = "manage_members_tabs">
<?php
    $tr=mysql_query( "SELECT ID, ΟΝΟΜΑ, ΦΥΛΟ FROM ΔΙΑΧΕΙΡΙΣΤΕΣ WHERE ΤΙΤΛΟΣ_ΥΠΗΡΕΣΙΑΣ IN (SELECT ΤΙΤΛΟΣ FROM ΥΠΗΡΕΣΙΕΣ WHERE ΤΙΤΛΟΣ = '$a_r') ;", $cbb_db );
    echo mysql_error();
    $td=mysql_fetch_array($tr);
?>
<p class = "manage_tabs_titles">Διαχειριστές</p>
<table>
<tr id = "agen_list_title"><td>Αναγνωριστικό</td><td>Όνομα</td><td>Φύλο</td></tr>

<?php
    $mi = 0;
    while($td)
    {
        $manid = $td['ID'];
        $tr1 = mysql_query("SELECT manager_ref FROM Managers WHERE manager_id = '$manid';", $web_db);
        $td1 = mysql_fetch_array($tr1);
?>
<tr id = "manager<?php echo $td['ID']; ?>" class = "agen_list_main"><td><?php echo $td1['manager_ref']; ?></td><td><?php echo $td['ΟΝΟΜΑ']; ?></td><td><?php echo $td['ΦΥΛΟ']; ?></td></tr>
<?php
        $Managers[$mi] = $td['ID'];
        $mi ++;
        $td=mysql_fetch_array($tr);
    }
?>
</table>
</div>
<div id = "manage_missions_tab" class = "manage_members_tabs">
<?php
    $tr=mysql_query( "SELECT ID, ΠΕΡΙΓΡΑΦΗ FROM ΑΠΟΣΤΟΛΕΣ;", $cbb_db );
    echo mysql_error();
    $td=mysql_fetch_array($tr);
?>
<p class = "manage_tabs_titles">Αποστολές</p>
<table>
<tr id = "agen_list_title"><td>Αναγνωριστικό</td><td>Περιγραφή</td></tr>

<?php
    $msni = 0;
    while($td)
    {
?>
<tr id = "mission<?php echo $td['ID']; ?>" class = "agen_list_main"><td>##<?php echo $td['ID']; ?></td><td><?php echo $td['ΠΕΡΙΓΡΑΦΗ']; ?></td></tr>
<?php
        $Missions[$msni] = $td['ID'];
        $msni ++;
        $td=mysql_fetch_array($tr);
    }
?>
</table>
</div>
<div class = "delete_selection_button">X</div>
<div class = "change_selection_button">C</div>
<div class = "ok_selection_button">OK</div>
<div class = "alert_box"><span class = "close_alert_box">OK</span></div>
<div class = "mission_information"></div>
<p class = "close_mission_information">X Κλείσιμο</p>

<?php
}
else{

    header( 'Location: http://dbagent.comyr.com/index.php' );
}
?>


<script type="text/javascript">
var toDelete = 0;
var toChange = 0;
var agentsIDToChange = [];
var an = "";
var ag = "";
var aman = "";
var mission = "";
var changesNo = 0;
$( 'div.delete_selection_button' ).click(function(){
    if(toDelete == 0 && toChange == 0)
    {
        $("body").css("cursor", "not-allowed");
        toDelete = 1;
    }
    else if(toChange == 0)
    {
        $("body").css("cursor", "default");
        toDelete = 0;
    }
});

$( 'div.change_selection_button' ).click(function(){
    if( toChange == 0 && toDelete == 0)
    {
        $("body").css("cursor", "crosshair");
        toChange = 1;
        $('div.ok_selection_button').show("fast");
    }
    else if(toDelete == 0)
    {
        $( 'span.display_member_info' ).show("fast");
        $( '.update_member_info' ).hide("fast");
        $("body").css("cursor", "default");
        $('div.ok_selection_button').hide("fast");
        toChange = 0;
    }
});
$( 'div.ok_selection_button' ).click(function(){
    var i;
    for(i = 0; i < changesNo; i++)
    {
        an = $( 'tr#agent' + agentsIDToChange[i] + ' input#update_name' ).val();
        ag = $( 'tr#agent' + agentsIDToChange[i] + ' select#update_gender' ).val();
        aman = $( 'tr#agent' + agentsIDToChange[i] + ' input#update_manager' ).val();
        mission = $( 'tr#agent' + agentsIDToChange[i] + ' input#update_mission' ).val();
        //    alert(aman);
        $("body").css("cursor", "progress");
        $.post("update_agent.php",{aid: agentsIDToChange[i], an: an, ag: ag, aman: aman, mission: mission}, function(outu){
            $("body").css("cursor", "default");
            if(outu == 0)
            {
                $('div.alert_box').html('<span class = "close_alert_box">OK</span>');
                $('div.alert_box').hide("fast");
                $('div.alert_box').append("Manager with desired reference not found: "+ aman);
                $('div.alert_box').show("fast");
            }
            else if(outu == -1)
            {
                $('div.alert_box').html('<span class = "close_alert_box">OK</span>');
                $('div.alert_box').hide("fast");
                $('div.alert_box').append("Mission with desired reference not found: "+ mission);
                $('div.alert_box').show("fast");
            }

        });
    }
    changesNo = 0;
    agentsIDToChange.clear();
});

$('div.alert_box').click(function(){
    $('div.alert_box').html('<span class = "close_alert_box">OK</span>');
    $('div.alert_box').hide("fast");
});

$('p.close_mission_information').click(function(){
    $('div.mission_information').hide("fast");
    $('p.close_mission_information').hide("fast");
});

<?php 
for($i = 0; $i < $ai; $i ++)
{
?>
    $( 'tr#agent<?php echo $Agents[$i]; ?>' ).mouseover(function(){
        if(toDelete)
        {
            $( 'tr#agent<?php echo $Agents[$i]; ?>' ).css("background-color", "red");
        }
        else if(toChange)
        {
            $( 'tr#agent<?php echo $Agents[$i]; ?>' ).css("background-color", "orange");
        }
    });

    $( 'tr#agent<?php echo $Agents[$i]; ?>' ).mouseleave(function(){
        if(toDelete)
        {
            $( 'tr#agent<?php echo $Agents[$i]; ?>' ).css("background-color", "#C8C8D2");
        }
        else if(toChange)
        {
            $( 'tr#agent<?php echo $Agents[$i]; ?>' ).css("background-color", "#C8C8D2");
        }
    });

    $( 'tr#agent<?php echo $Agents[$i]; ?>' ).click(function(){
        if(toDelete){
            $("body").css("cursor", "progress");
            $.post("delete_agent.php",{aid: "<?php echo $Agents[$i]; ?>"}, function(out1){
                $("body").css("cursor", "not-allowed");
                $( 'tr#agent<?php echo $Agents[$i]; ?>' ).hide("fast");
            });
        }
        else if(toChange)
        {
            $( 'tr#agent<?php echo $Agents[$i]; ?> span' ).hide("fast");
            $( 'tr#agent<?php echo $Agents[$i]; ?> .update_member_info' ).show("fast");
            changesNo ++;
            agentsIDToChange.push("<?php echo $Agents[$i]; ?>");
        }
    });

    $( 'tr#agent<?php echo $Agents[$i]; ?> td.mission_declar' ).click(function(){
        if(!toChange)
        {
            var temp_msid = $( 'tr#agent<?php echo $Agents[$i]; ?> td.mission_declar' ).text();
            temp_msid = temp_msid.split("##");
            var msid = temp_msid[1];
            $.post("get_mission_info.php", {msid: msid}, function(outms){
                $('div.mission_information').html(outms).show();
                $('p.close_mission_information').show("fast");
            });
        }
    });
<?php 
}
?>
<?php 
for($i = 0; $i < $mi; $i ++)
{
?>
    $( 'tr#manager<?php echo $Managers[$i]; ?>' ).mouseover(function(){
        if(toDelete){
            $( 'tr#manager<?php echo $Managers[$i]; ?>' ).css("background-color", "red");
        }
    });

    $( 'tr#manager<?php echo $Managers[$i]; ?>' ).mouseleave(function(){
        if(toDelete){
            $( 'tr#manager<?php echo $Managers[$i]; ?>' ).css("background-color", "#C8C8D2");
        }
    });

    $( 'tr#manager<?php echo $Managers[$i]; ?>' ).click(function(){
        if(toDelete){
            $("body").css("cursor", "progress");
            $.post("delete_manager.php",{mid: "<?php echo $Managers[$i]; ?>"}, function(out1){
                $("body").css("cursor", "not-allowed");
                $( 'tr#manager<?php echo $Managers[$i]; ?>' ).hide("fast");
            });
        }
    });
<?php 
}
?>
</script>
