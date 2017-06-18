'use strict'

var express = require('express');
var router = express.Router();
var formidable = require('formidable');
var fs = require('fs-extra');
var bcrypt = require('bcrypt');
var nodemailer = require("nodemailer");

var sqlite3 = require('sqlite3').verbose();  
var db = new sqlite3.Database('./db/transportdb.db');  


/* GET singUp Page. */
router.get('/', function(req, res, next) {
  res.header('Content-Type', 'application/xhtml+xml'); 
  res.render('signup.html', {error: ''});  
});

/* POST signUp. */
router.post('/upload', function(req, res, next) {

  var form = new formidable.IncomingForm();	
  form.uploadDir = './public/images/userimages';
  form.keepExtensions = true; 
  
  form.parse(req, function(err, fields, files){
	var name = fields.user_name;
	var surname = fields.user_surname;
	var username   = fields.user_username;
	var password  = fields.user_password; 
	var address  = fields.user_address;
	var cellphone  = fields.user_cellphone;
	var email   = fields.user_email;  
	
	console.log(name);	
	
	
	db.serialize(function()
	{   	db.get("SELECT username, email FROM user WHERE username = '"+ username + "'OR  email= '" + email +"'", function(err, row) { 
			if (err) throw err;
			if (row !== undefined){
				  if (row.username == username){
					console.log("Username exists : "+row.username);	
					res.send('Username already exists!');					
				  }
				  else if (row.email == email){
					console.log("Email exists : "+row.email);	
					res.send('Email already exists!');	
				  }
					
			}
			else {
				 console.log('Writing in the database');	
				 fs.rename(files.ID_photo.path, './public/images/userimages/'+username+'.png', function(err) {
				  if (err)
					throw err;
				  console.log('Renamed complete');
				 });	
    
				 var id_photo = username+'.png';
	
				 var salt = bcrypt.genSaltSync(10);
				 var hash = bcrypt.hashSync(password, salt);
				 
				 var stmt = db.prepare("INSERT INTO user VALUES (NULL,?,?,?,?,?,?,?,?)");
				 stmt.run(name, surname, username, hash, address, cellphone, email, id_photo);  
				 stmt.finalize(function (err) {
					 if (err) throw err;
					 console.log("Signup completed for: "+username);
					 var smtpTransport = nodemailer.createTransport({
						service: "Gmail",
						auth: {
								user: "transportit17@gmail.com",
								pass: "transportit2017"
						}
					 });
					 var mailOptions;
					 
					 mailOptions={
					 to : email,
					 subject : "Welcome to TransportIT",
					 html : "Hello " +username+",<br/> <br/> Your account has been successfully created. <br/> You may now enjoy TransportIT.  <br/> <br/> Thank you for choosing TransportIT, <br/> The TransportIT team"	
					 }					 
					 
					 smtpTransport.sendMail(mailOptions, function(error){
						if(error)
						{
							console.log(error);						
						}
						else
						{
							console.log("Message sent at "+email);						
						}
					 });
					 res.send({valid:true});
				 }); 
				 			 
			}
		});
	});  
	
  });
  
  	
  
});

module.exports = router;
