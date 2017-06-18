'use strict'

var express = require('express');
var router = express.Router();
var bodyParser = require('body-parser');
var bcrypt = require('bcrypt');
var nodemailer = require("nodemailer");

var sqlite3 = require('sqlite3').verbose();  
var db = new sqlite3.Database('./db/transportdb.db');  

/* GET sender. */
router.get('/', function(req, res, next) {
  res.header('Content-Type', 'application/xhtml+xml'); 
  res.render('sender.html');  
});

/* POST sender. */
router.post('/', bodyParser.urlencoded({ extended: true }), function(req, res, next) {
  var sender_from = req.body.sender_from;
  var sender_to  = req.body.sender_to;
  var sender_from_date = req.body.sender_from_date;
  var sender_until_date = req.body.sender_until_date;
  var sender_weight = req.body.sender_weight;
  var sender_volume = req.body. sender_volume;  

  var sess=req.session;  

 db.serialize(function(){   	
    console.log("Searching the database for transporters");	
	var stmt = db.prepare("SELECT user.username, transporter.* FROM user JOIN transporter on user.user_id=transporter.user_id WHERE transporter.arrival_date BETWEEN (?) AND (?) AND transporter.from_= (?) AND transporter.destination=(?) AND transporter.max_weight >= (?) AND transporter.max_dimension >= (?) AND transporter.user_id != (?) ORDER by transporter.arrival_date");
	stmt.all(sender_from_date, sender_until_date, sender_from, sender_to, sender_weight, sender_volume, sess.user_id, function(err, rows) { 
		if (err) throw err;
		if (rows.length == 0) 
		{
			stmt.finalize(function (err) {
			if (err) throw err;
			console.log("Didnt find anything");
			res.send({valid:false}); 			
			}); 
		}
		else 
		{
			stmt.finalize(function (err) {
			if (err) throw err;
			console.log("Transporters found");
			res.send({valid:true, rows}); 	
			});
		}						
	}); 		
 }); 
});

 router.post('/matching', bodyParser.urlencoded({ extended: true }), function(req, res, next) {
  var sess=req.session;
  var transporter_id = req.body.transporter;  

  var smtpTransport = nodemailer.createTransport({
	service: "Gmail",
	auth: {
			user: "transportit17@gmail.com",
			pass: "transportit2017"
		   }
   });

 db.serialize(function(){   	
    console.log("Writing in the matching table");	
	var stmt = db.prepare("INSERT INTO matching VALUES (NULL,?,?)");
	stmt.run(transporter_id, sess.user_id, function(err, rows) { 
		if (err) throw err;
			stmt.finalize(function (err) {
			if (err) throw err;		
			var stmt2 = db.prepare("SELECT user.username, user.email, transporter.from_, transporter.destination, transporter.arrival_date, transporter.arrival_time FROM user JOIN transporter on user.user_id=transporter.user_id where transporter.transporter_id = (?)");
			stmt2.get(transporter_id, function(err, rows) {
				var mailOptionsSender;
				var mailOptionsTransporter;	
			
				mailOptionsSender={
				to : sess.email,
				subject : "TransportIT: Transaction confirmation",
				html : "Hello "+sess.username+",<br/> <br/> You have successfully selected "+rows.username+" to transfer an item for you from "+rows.from_+" to "+rows.destination+" on "+rows.arrival_date+" at "+rows.arrival_time+". <br/> <br/> You may contact "+rows.username+" at "+rows.email+"to keep in touch. <br/> <br/> Thank you for choosing TransportIT, <br/> The TransportIT team"	
				}

				mailOptionsTransporter={
				to : rows.email,
				subject : "TransportIT: Transaction confirmation",
				html : "Hello "+rows.username+",<br/> <br/> You have successfully been selected from "+sess.username+" to transfer an item from "+rows.from_+" to "+rows.destination+" on "+rows.arrival_date+" at "+rows.arrival_time+".<br/> <br/> You may contact "+sess.username+" at "+sess.email+"to keep in touch. <br/> <br/> Thank you for choosing TransportIT, <br/> The TransportIT team"	
				}	
			
				smtpTransport.sendMail(mailOptionsSender, function(error){
					if(error) console.log(error);						
					else console.log("Message sent to sender at "+sess.email);								
				});
			
				smtpTransport.sendMail(mailOptionsTransporter, function(error){
					if(error) console.log(error);						
					else console.log("Message sent to transporter at "+rows.email);								
				});
			
				stmt2.finalize(function (err) {
					if (err) throw err;
					console.log("Matching has be done");
					res.header('Content-Type', 'application/xhtml+xml'); 
					res.redirect("/mainpage"); 
				});
			}); 						
		}); 		
	}); 

  });
});

module.exports = router;
