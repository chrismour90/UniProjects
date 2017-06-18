'use strict'

var express = require('express');
var router = express.Router();
var bodyParser = require('body-parser');
var bcrypt = require('bcrypt');

var sqlite3 = require('sqlite3').verbose();  
var db = new sqlite3.Database('./db/transportdb.db');  

/* GET Profile Page. */
router.get('/', function(req, res, next) {
  var sess=req.session;
  db.get("SELECT * FROM user WHERE username = '"+ sess.username + "'", function(err, row) { 
			if (err) throw err;
			console.log("Profile for : "+sess.username);	
			res.header('Content-Type', 'application/xhtml+xml'); 
			res.render('profile.html',{result: row});  
		});

});

/* POST change profile */
router.post('/change', bodyParser.urlencoded({ extended: true }), function(req, res, next) {
  var sess=req.session;
  
  var password  = req.body.user_password;
  var phone = req.body.user_cellphone;
  var address = req.body.user_address;

  if (password=='')  
  {
	hash = null;  
  }
  else
  {
    var salt = bcrypt.genSaltSync(10);
    var hash = bcrypt.hashSync(password, salt);  
  }
  
  if (phone=='')  
  {
	phone = null;  
  }
	
	if (address=='')  
  {
	address = null;  
  }
   db.serialize(function(){   	
	console.log('Updating profile for '+sess.username);
	var stmt = db.prepare("UPDATE user SET hash = coalesce((?), hash), phone = coalesce((?), phone), address = coalesce((?), address) WHERE username = (?)");
	stmt.run(hash,phone,address,sess.username);
	stmt.finalize(function (err) {
					 if (err) throw err;
					 console.log("Updated");
					 res.header('Content-Type', 'application/xhtml+xml'); 
					 res.redirect('/profile'); 
	}); 
   }); 	
  
});

module.exports = router;
