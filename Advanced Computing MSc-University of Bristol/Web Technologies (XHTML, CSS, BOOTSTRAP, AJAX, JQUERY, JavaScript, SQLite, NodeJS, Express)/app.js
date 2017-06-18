'use strict'

var express = require('express');
var path = require('path');
var logger = require('morgan');
var session = require('express-session');
var favicon = require('serve-favicon');

var start = require('./routes/start');
var login = require('./routes/login');
var signup = require('./routes/signup');
var logout = require('./routes/logout');
var profile = require('./routes/profile');
var sender = require('./routes/sender');
var transporter = require('./routes/transporter');
var mainpage = require('./routes/mainpage');

var app = express();

app.use(function(req, res, next) {
    if (req.path.substr(-1) == '/' && req.path.length > 1) {
        var query = req.url.slice(req.path.length);
        res.redirect(301, req.path.slice(0, -1) + query);
    } else {
        next();
    }
});

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.engine('html', require('ejs').renderFile);
app.set('view engine', 'html');

app.use(favicon(path.join(__dirname, 'public','images', 'favicon.ico')));
app.use(session({secret: 'no one steals me', saveUninitialized: true,resave: true, cookie: {secure:true}}));
app.set('strict routing', true);
app.use(logger('dev'));
//app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public'), {'dotfiles' : 'deny'}));

function redirectSecure(req, res, next){
  if(req.secure){
    return next();
  };
  res.redirect('https://'+req.host+':' + 8443 + req.url);
};
app.all('*', redirectSecure);

app.use('/', start);
app.use('/login', login);
app.use('/signup', signup);
app.use('/logout', logout);
app.use('/profile', profile);
app.use('/sender', sender);
app.use('/transporter', transporter);
app.use('/mainpage', mainpage);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error.html');
});

module.exports = app;
