'use strict'

var express = require('express');
var router = express.Router();
var bodyParser = require('body-parser');
var bcrypt = require('bcrypt');

var sqlite3 = require('sqlite3').verbose();  
var db = new sqlite3.Database('./db/transportdb.db');  

/* GET login. */
router.get('/', function(req, res, next) {
  var sess=req.session;  
  console.log(sess.username);
  db.serialize(function(){
		db.get("SELECT * FROM user WHERE username = '"+ sess.username + "' LIMIT 1", function(err, row) { 
		if (err) throw err;
		res.header('Content-Type', 'application/xhtml+xml'); 
		res.render('mainpage.html',{username: sess.username, result: row, error: 'Test'}); 		
		});
	}); 	

});

/* POST login. */
router.post('/', bodyParser.urlencoded({ extended: true }), function(req, res, next) {
  var username   = req.body.account;
  var password  = req.body.password;


  db.serialize(function()
	{
		db.get("SELECT * FROM user WHERE username = '"+ username + "' LIMIT 1", function(err, row) { 
			if (row !== undefined){
			      console.log("Username : "+row.username);
				  
				  if (bcrypt.compareSync(password, row.hash))
				  {
					var sess=req.session;  
					sess.username = row.username;
					sess.user_id = row.user_id;
					sess.email= row.email;
					
					console.log("Successful login for: "+sess.username+" with user id: "+sess.user_id + " email: "+sess.email);	
					res.send({valid:true}) ;
				  }
				  else
				  {
					console.log("Wrong password");	
					res.send("Wrong Password. Please try again!");					
				  }

			}
			else {
				 console.log("Not exists");	
				 res.send("User does not exist.");	
			}
		});
	});    

});


module.exports = router;
