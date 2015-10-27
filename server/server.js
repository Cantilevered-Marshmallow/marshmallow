  // Import dependencies
var express = require('express');
var bodyParser = require('body-parser');
var morgan = require('morgan');

var app = express();
var router = require('./router');

// Socket dependencies
var httpServer = require('http').createServer(app);
var io = require('socket.io')(httpServer);
var socketioJwt = require('socketio-jwt');
var sockets = require('./chat/chatController').sockets;



io.use(socketioJwt.authorize({
  secret: process.env.JWT_SECRET,
  handshake: true,
}));

io.on('connection', function (socket) {
  // socket.id is a STRING
  sockets[socket.decoded_token.facebookId] = socket;
  socket.on('disconnect', function () {
    delete sockets[socket.decoded_token.facebookId];
  });
  console.log(socket.decoded_token.email + 'is now connected.');
});


// app.use(morgan('combined'));

app.use(bodyParser.json());

app.use('/', router);


var server = httpServer.listen(process.env.PORT || 8080, function () {
  var port = server.address().port;
  console.log('App listening at port', port);
});

module.exports = {
  server: server
};
