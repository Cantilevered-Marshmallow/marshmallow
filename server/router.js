var express = require('express');
var router = express.Router();
var auth = require('./auth');

router.use(function timeLog (req, res, next) {
  console.log('Time :', Date.now());
  next();
});

router.post('/signup', auth.authFacebook, auth.signup);

router.post('/login', auth.authFacebook, auth.login);

router.get('/logout', auth.logout);

// router.post('/userlist', );

// router.post('/chat', );

// router.get('/chat', );

// router.get('/chat/:id', );

// router.post('/chat/:id',);

// router.get('/youtube', );

// router.get('/gimages', );

module.exports = router;
