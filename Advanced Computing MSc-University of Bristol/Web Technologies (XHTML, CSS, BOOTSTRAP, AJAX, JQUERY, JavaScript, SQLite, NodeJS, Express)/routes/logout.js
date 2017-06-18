'use strict'

var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
  req.session.destroy(function(err)	{
	  if (err) throw err;
	  else 
	  {
		res.header('Content-Type', 'application/xhtml+xml'); 
		res.redirect('/');  
	  }
  });  
});

module.exports = router;
