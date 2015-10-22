var router = require('express').Router();

var auth = require('./auth');
var userController = require('./user/userController');
var chatController = require('./chat/chatController');

router.use(function timeLog (req, res, next) {
  console.log('Time :', Date.now());
  next();
});

router.post('/signup', auth.authFacebook, auth.signup);

router.post('/login', auth.authFacebook, auth.login);

router.get('/logout', auth.logout);

router.post('/chat', auth.authenticate, function (req, res) {
  chatController.createChat(req.body.users)
    .then(function (chat) {
      var jsonResponse = {chatId: chat.id};
      res.status(201).send(jsonResponse);
    })
    .catch(function (err) {
      console.log('err', err);
      res.status(400).send(err.message);
    });
});

router.get('/chat', auth.authenticate, function (req, res) {
  chatController.retrieveChats(req.session.user)
    .then(function (chats) {
      var jsonResponse = {chats: chats};
      res.status(200).send(jsonResponse);
    });
});

router.get('/chat/:id', auth.authenticate, function (req, res) {
  console.log('chat router called');
  console.log(req.params.id);
  chatController.getMessages(req.params.id)
    .then(function (messages) {
      res.status(200).send({ messages: messages });
    });
});

router.post('/chat/:id', auth.authenticate, function (req, res) {
  chatController.postMessage(req.params.id, req.session.user.facebookId, req.body)
    .then(function () {
      res.status(201).send();
    });
});

// router.get('/youtube', );

// router.get('/gimages', );

module.exports = router;
