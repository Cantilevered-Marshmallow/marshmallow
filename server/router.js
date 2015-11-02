var router = require('express').Router();

var auth = require('./auth');
var userController = require('./user/userController');
var chatController = require('./chat/chatController');
var trendsController = require('./trends/trendsController');

router.post('/signup', auth.authFacebook, auth.signup);

router.post('/login', auth.authFacebook, auth.login);

router.post('/userlist', auth.authenticate, function (req, res) {
  userController.userList(req.body.users)
    .then(function (users) {
      res.status(200).send(users);
    });
});

router.get('/messages', auth.authenticate, function (req, res) {
  if (!req.query.timestamp){
    res.status(400).send('No timestamp sent');
  }
  chatController.getMessagesByTime(req.user.facebookId, req.query.timestamp)
    .then(function (messages) {
      res.status(200).send({messages: messages});
    });
});

router.post('/chat', auth.authenticate, function (req, res) {
  chatController.createChat(req.body.users)
    .then(function (chat) {
      var chatId = chat.id.toString();
      var jsonResponse = {chatId: chatId};
      res.status(201).send(jsonResponse);
    })
    .catch(function (err) {
      console.log('err', err);
      res.status(400).send(err.message);
    });
});

router.get('/chat', auth.authenticate, function (req, res) {
  chatController.retrieveChats(req.user)
    .then(function (chats) {
      var jsonResponse = {chats: chats};
      res.status(200).send(jsonResponse);
    });
});

router.get('/chat/:id', auth.authenticate, function (req, res) {
  chatController.getMessages(req.params.id)
    .then(function (messages) {
      res.status(200).send({ messages: messages });
    });
});

router.post('/chat/:id', auth.authenticate, function (req, res) {
  chatController.postMessage(req.params.id, req.user.facebookId, req.body)
    .then(function () {
      res.status(201).send();
    });
});

router.get('/trends', auth.authenticate, function (req, res) {
  trendsController.getTrends()
    .then(function (links) {
      res.status(200).send({links: links});
    })
    .catch(function (err) {
      res.status(500).send("Error getting trends: ", err);
    });
});

module.exports = router;
