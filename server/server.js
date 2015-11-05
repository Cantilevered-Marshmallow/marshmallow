/* External dependencies */
var express = require('express');
var bodyParser = require('body-parser');
var morgan = require('morgan');
var jwt = require('jsonwebtoken');
var app = express();
var httpServer = require('http').Server(app);
var io = require('socket.io')(httpServer);

/* Internal dependencies */
var router = require('./utils/router');
var sockets = require('./utils/sockets');

app.use(morgan('dev'));

app.set('port', process.env.PORT || 8080);

app.use(bodyParser.json());

/* Use internal router for all incoming requests */
app.use('/', router);

/* Custom socket.io middleware to authenticate user based on their JWT */
io.use(function (socket, next) {
  jwt.verify(socket.handshake.query.token, process.env.JWT_SECRET, function (err, user) {
    if (err) {
      next(new Error(err));
    } else {
      socket.token = user;
      next();
    }
  });
});

/* Associate socket object with user facebookId on global sockets hash map */
io.on('connection', function (socket) {
  console.log('Socket connected: '+socket.id);
  sockets[socket.token.facebookId] = socket;

  /* Delete association when the socket disconnects */
  socket.on('disconnect', function () {
    console.log('Socket disconnected: '+ socket.id);
    delete sockets[socket.token.facebookId];
  });
});

var server = httpServer.listen(process.env.PORT || 8080, function () {
  var port = server.address().port;
  console.log('App listening at port', port);
});

module.exports = {
  server: server,
  io: io
};
