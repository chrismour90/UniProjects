var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.header('Content-Type', 'application/xhtml+xml'); 
  res.render('login.html', {errorlogin: ''});
});

module.exports = router;
