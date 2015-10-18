var express = require('express');
var router = express.Router();
var auth = require('./auth');

router.use(function timeLog (req, res, next) {
  console.log('Time :', Date.now());
  next();
});

router.post('/signup', auth.authFacebook, auth.signup);

router.post('/login', auth.authFacebook, auth.login);

module.exports = router;
