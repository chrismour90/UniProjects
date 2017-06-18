<?php
if(!isset($_SESSION['agent_id']) AND !isset($_SESSION['agency_ref']) AND !isset($_SESSION['manager_id']))
{
?>
<div class = "description_login_boxes" id = "desc_box1">
<p class = "description_login_titles">
Είσοδος πράκτορα
</p>
<p class = "description_login_titles_form" style = "display:none;">
Είσοδος πράκτορα
</p>
<p class = "description_login_main">
Πράκτορες μπορούν να εισέρχονται για την λήψη πληροφοριών σχετικά με την τρέχουσα αποστολή τους, με το ιστορικό των εγκληματιών που καταδιώκουν, με τα στοιχεία επικοινωνίας του διαχειριστή τους κ.α. 
</p>
<p class = "description_login_main_form">
      <form method="post" action="do_agent_login.php" class = "description_login_main_form" style = "display:none;>
           <p class="declar_1">Αναγνωριστικό Πράκτορα:</p>
           <p class="declar_2"><input type="text" name="agent_ref"/></p>
           <p class="declar_1">Κωδικός Πρόσβασης:</p>
           <p class="declar_2"><input type="password" name="password"/></p>
           <p class="declar_2"><input type="submit" value="Είσοδος"/></p>
      </form>
</p>
<p class = "cancel_button" style = "display:none;">Άκυρο</p>
</div>
<div class = "description_login_boxes" id = "desc_box2">
<p class = "description_login_titles">
Είσοδος διαχειριστή
</p>
<p class = "description_login_main">
Διαχειριστές μπορούν να βλέπουν τους πράκτορες που συντονίζουν, την πρόοδο τους, καθώς και να επιτελέσουν την αναγκαία αξιολόγηση τους, μετά το πέρας μιας αποστολής.
</p>
<p class = "description_login_main_form">
      <form method="post" action="do_manager_login.php" class = "description_login_main_form" style = "display:none;>
           <p class="declar_1">Αναγνωριστικό Διαχειριστή</p>
           <p class="declar_2"><input type="text" name="manager_ref"/></p>
           <p class="declar_1">Κωδικός Πρόσβασης:</p>
           <p class="declar_2"><input type="password" name="password"/></p>
           <p class="declar_2"><input type="submit" value="Είσοδος"/></p>
      </form>
</p>
<p class = "cancel_button" style = "display:none;">Άκυρο</p>
</div>
<div class = "description_login_boxes" id = "desc_box3">
<p class = "description_login_titles">
Είσοδος με προνόμια διαχειριστή υπηρεσίας  
</p>
<p class = "description_login_titles_form" style = "display:none;">
Καταχωρήστε το αναγνωριστικό και το συνθηματικό που έχετε παραλάβει.  
</p>
<p class = "description_login_main">
Ως διαχειριστής μιας υπηρεσίας έχετε τη δυνατότητα οργάνωσης και εποπτείας των διαχειριστών και των πρακτόρων που απασχολεί η υπηρεσία σας. Επίσης, έχετε τη δυνατότητα καταχώρησης νέων μελών της υπηρεσία σας.
</p>
<p class = "description_login_main_form">
      <form method="post" action="do_agency_login.php" class = "description_login_main_form" style = "display:none;>
           <p class="declar_1">Αναγνωριστικό:</p>
           <p class="declar_2"><input type="text" name="agency_ref"/></p>
           <p class="declar_1">Συνθηματικό:</p>
           <p class="declar_2"><input type="password" name="password"/></p>
           <p class="declar_2"><input type="submit" value="Είσοδος"/></p>
      </form>
</p>
<p class = "cancel_button" style = "display:none;">Άκυρο</p>
</div>
<?php
}
elseif(isset($_SESSION['agent_id']))
{
    header( 'Location: http://dbagent.comyr.com/agent_account.php' );
}
elseif(isset($_SESSION['manager_id']))
{
    header( 'Location: http://dbagent.comyr.com/manager_account.php' );
}
else
{
    header( 'Location: http://dbagent.comyr.com/agency_account.php' );
}

?>

<script type="text/javascript">
var form_displayed = [];
var form_displayed1 = [];
<?php 
for($i = 1; $i < 4; $i ++)
{ 
?>
    form_displayed[<?php echo $i; ?>] = 0;
    form_displayed1[<?php echo $i; ?>] = 0;
    $( 'div.description_login_boxes#desc_box<?php echo $i; ?>' ).click(function(){
        if(form_displayed[<?php echo $i; ?>] == 0)
        {
            $( 'div.description_login_boxes#desc_box<?php echo $i; ?> p.description_login_titles' ).hide("fast");
            $( 'div.description_login_boxes#desc_box<?php echo $i; ?> p.description_login_titles_form' ).show("fast");
            $( 'div.description_login_boxes#desc_box<?php echo $i; ?> p.description_login_main' ).hide("fast");
            $( 'div.description_login_boxes#desc_box<?php echo $i; ?> form.description_login_main_form' ).show("fast");
            $( 'div.description_login_boxes#desc_box<?php echo $i; ?> p.cancel_button' ).show("fast");
            form_displayed[<?php echo $i; ?>] = 1;
            form_displayed1[<?php echo $i; ?>] = 1;
        }
        if(form_displayed1[<?php echo $i; ?>] == 0 )
        {
            form_displayed[<?php echo $i; ?>] = 0;
        }
    });

    $( 'div.description_login_boxes#desc_box<?php echo $i; ?> p.cancel_button' ).click(function(){
        $( 'div.description_login_boxes#desc_box<?php echo $i; ?> p.description_login_titles_form' ).hide("fast");
        $( 'div.description_login_boxes#desc_box<?php echo $i; ?> p.description_login_titles' ).show("fast");
        $( 'div.description_login_boxes#desc_box<?php echo $i; ?> form.description_login_main_form' ).hide("fast");
        $( 'div.description_login_boxes#desc_box<?php echo $i; ?> p.description_login_main' ).show("fast");
        $( 'div.description_login_boxes#desc_box<?php echo $i; ?> p.cancel_button' ).hide("fast");
        form_displayed1[<?php echo $i; ?>] = 0;
    });
<?php
} 
?>
</script>
