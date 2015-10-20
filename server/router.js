var router = require('express').Router();

var auth = require('./auth');
var userController = require('./user/userController');

router.use(function timeLog (req, res, next) {
  console.log('Time :', Date.now());
  next();
});

router.post('/signup', auth.authFacebook, auth.signup);

router.post('/login', auth.authFacebook, auth.login);

router.get('/logout', auth.logout);

router.post('/userlist', function (req, res) {
  userController.userList(req.body.users)
    .then(function (users) {
      res.status(200).send(users);
    });
});

// router.post('/chat', );

// router.get('/chat', );

// router.get('/chat/:id', );

// router.post('/chat/:id',);

// router.get('/youtube', );

// router.get('/gimages', );

module.exports = router;
