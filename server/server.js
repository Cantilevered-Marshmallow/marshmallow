// Import dependencies
var express = require('express');
var bodyParser = require('body-parser');
var morgan = require('morgan');
var session = require('express-session');

var router = require('./router');

// Mount middleware
var app = express();

app.set('port', process.env.PORT || 8080);

app.use('/', router);


var server = app.listen(process.env.PORT || 8080, function () {
  var port = server.address().port;
  console.log('App listening at port', port);
});

module.exports = server;
