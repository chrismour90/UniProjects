'use strict'

var express = require('express');
var router = express.Router();
var bodyParser = require('body-parser');
var bcrypt = require('bcrypt');

var sqlite3 = require('sqlite3').verbose();  
var db = new sqlite3.Database('./db/transportdb.db');  

/* GET transporter. */
router.get('/', function(req, res, next) {
  res.header('Content-Type', 'application/xhtml+xml'); 
  res.render('transporter.html');  
});



/* POST transporter. */
router.post('/', bodyParser.urlencoded({ extended: true }), function(req, res, next) {
  var transporter_from   = req.body.transporter_from;
  var transporter_to  = req.body.transporter_to;
  var transporter_date = req.body.transporter_date;
  var transporter_time = req.body.transporter_time;
  var transporter_weight = req.body.transporter_weight;
  var transporter_volume = req.body.transporter_volume;  
  var transporter_means = req.body.transporter_means; 
   
  var sess=req.session;  

 db.serialize(function(){   	
    console.log('Writing in the database for transporter');	
	var stmt = db.prepare("INSERT INTO transporter VALUES (NULL,?,?,?,?,?,?,?,?)");
	stmt.run(sess.user_id, transporter_from, transporter_to, transporter_date, transporter_time, transporter_weight, transporter_volume, transporter_means);  
	stmt.finalize(function (err) {
		if (err) throw err;
		console.log("Transporter has successfully been added");
		res.send({valid:true}); 
	}); 		
 }); 

});


module.exports = router;
