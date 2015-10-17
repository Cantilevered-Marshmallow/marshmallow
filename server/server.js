// Import dependencies
var express = require('express');
var bodyParser = require('body-parser');
var morgan = require('morgan');
var session = require('express-session');

var router = require('./router');

// Mount middleware
var app = express();

app.use('/', router);
