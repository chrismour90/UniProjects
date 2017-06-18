'user strict'

var express = require('express');
var router = express.Router();
var bodyParser = require('body-parser');

var sqlite3 = require('sqlite3').verbose();  
var db = new sqlite3.Database('./db/transportdb.db');  

/* GET main page. */
router.get('/', function(req, res, next) {
  var sess=req.session;
  console.log(sess.username, sess.user_id); 
  var s_flag = true; 
  var t_flag = true;
  
   db.serialize(function(){
	    var stmt = db.prepare("select user.username, user.email, matching.matching_id, transporter.* from user join transporter on user.user_id=transporter.user_id join matching on transporter.transporter_id=matching.transporter_id where matching.sender_user_id = (?)");
		stmt.all(sess.user_id, function(err, row) { 
		 if (err) throw err;
		 if (row.length == 0){s_flag=false;}
		 console.log(s_flag);
		 stmt.finalize(function (err) {
			if (err) throw err;
			var stmt2 = db.prepare("select user.username, user.email, matching.matching_id, transporter.* from user join transporter on transporter.user_id= (?) join matching on transporter.transporter_id=matching.transporter_id where user.user_id = matching.sender_user_id");	
			stmt2.all(sess.user_id, function(err, rows) { 
				if (err) throw err;
				if (rows.length == 0){t_flag=false;}	
				    console.log(t_flag);
					stmt2.finalize(function (err) {
					if (err) throw err;
					res.header('Content-Type', 'application/xhtml+xml'); 					
					res.render('mainpage.html',{username: sess.username, senderflag: s_flag, senderResult: row, transporterflag: t_flag, transporterResult: rows}); 	
					});
						
			}); 
		});
		 
		});
		
	}); 
	
	
	
});

/* GET home page. */
router.get('/idea', function(req, res, next) {
  res.header('Content-Type', 'application/xhtml+xml'); 
  res.render('idea.html');
});

/* GET home page. */
router.get('/report', function(req, res, next) {
  res.header('Content-Type', 'application/xhtml+xml'); 
  res.render('report.html');
});



/* POST cancel. */
router.post('/cancel', bodyParser.urlencoded({ extended: true }), function(req, res, next) {
  var cancel_id = req.body.cancel;
   
  console.log(cancel_id);	 
  var sess=req.session;  

 db.serialize(function(){   	
    console.log("Deleting matchind id: "+cancel_id);	
	var stmt = db.prepare("DELETE FROM matching WHERE matching_id = (?)");
	stmt.run(cancel_id, function(err) { 
		if (err) throw err;
		stmt.finalize(function(err){
		console.log("Deleted");
		res.header('Content-Type', 'application/xhtml+xml'); 
		res.redirect("/mainpage");	
		});
		
	});
 });
});		

module.exports = router;
