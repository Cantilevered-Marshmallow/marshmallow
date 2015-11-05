var router = require('express').Router();

var auth = require('./auth');
var userController = require('../controllers/userController');
var chatController = require('../controllers/chatController');
var trendsController = require('../controllers/trendsController');

/* Handle user signup */
router.post('/signup', auth.authFacebook, auth.signup);

/* Handle user login */
router.post('/login', auth.authFacebook, auth.login);

/**
 * Handle POST to /userlist
 * This route supports filtering a client's facebook freinds that are not 
 * signed up with marshmallow
 */
router.post('/userlist', auth.authenticate, function (req, res) {
  userController.userList(req.body.users)
    .then(function (users) {
      res.status(200).send(users);
    })
    .catch(function (err) {
      res.status(500).send('Error filtering user list: ' + err);
    });
});

/* Handle GET to /messages */
router.get('/messages', auth.authenticate, function (req, res) {
  if (!req.query.timestamp){
    res.status(400).send('No timestamp sent');
  }
  chatController.getMessagesByTime(req.user.facebookId, req.query.timestamp)
    .then(function (messages) {
      res.status(200).send({messages: messages});
    })
    .catch(function (err) {
      res.status(500).send('Error getting all messages: ' + err);
    });
});

/**
 * Handle POST to /chat 
 * Creates a new chat room between list of users
 */
router.post('/chat', auth.authenticate, function (req, res) {
  chatController.createChat(req.body.users)
    .then(function (chat) {
      var chatId = chat.id.toString();
      var jsonResponse = {chatId: chatId};
      res.status(201).send(jsonResponse);
    })
    .catch(function (err) {
      res.status(400).send('Error creating chat: ' + err);
    });
});

/**
 * Handle GET to /chat
 * Respond with list of chat rooms a particular client is in
 */
router.get('/chat', auth.authenticate, function (req, res) {
  chatController.retrieveChats(req.user)
    .then(function (chats) {
      var jsonResponse = {chats: chats};
      res.status(200).send(jsonResponse);
    })
    .catch(function (err) {
      res.status(500).send('Error fetching chats: ' + err);
    });
});

/**
 * Handle GET to /chat/:id
 * Respond with all messages in a particular chat
 */
router.get('/chat/:id', auth.authenticate, function (req, res) {
  chatController.getMessages(req.params.id)
    .then(function (messages) {
      res.status(200).send({ messages: messages });
    })
    .catch(function (err) {
      res.status(500).send('Error finding the chat room: ' + err);
    });
});

/**
 * Handle POST to /chat/:id
 * Posts a message to a particular chat room
 */
router.post('/chat/:id', auth.authenticate, function (req, res) {
  chatController.postMessage(req.params.id, req.user.facebookId, req.body)
    .then(function () {
      res.status(201).send();
    })
    .catch(function (err) {
      res.status(500).send('Error posting chat message: ' + err);
    });
});

/* Handle GET to /trends */
router.get('/trends', auth.authenticate, function (req, res) {
  trendsController.getTrends()
    .then(function (links) {
      res.status(200).send({links: links});
    })
    .catch(function (err) {
      res.status(500).send("Error getting trends: " + err);
    });
});

module.exports = router;
