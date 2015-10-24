var userController = require('./user/userController');
var request = require('request');
var jwt = require('jsonwebtoken');

module.exports = {

  authFacebook: function (req, res, next) {
    var user = req.body;
    request('https://graph.facebook.com/me?access_token=' + user.oauthToken,
      function (err, _, body) {
        body = JSON.parse(body);
        if (body.id === user.facebookId){
          next();
        } else {
          res.status(400).send('Invalid Facebook access token');
        }
      });
  },

  signup: function (req, res) {
    var user = {
      email:      req.body.email,
      facebookId: req.body.facebookId
    };

    userController.registerNewUser(user)
      .then(function (user) {
        res.status(201);
        module.exports._authToken(req, res, user);
      })
      .catch(function (err) {
        console.log(err);
        if (err) {
          module.exports.login(req, res);
        }
      });
  },

  login: function (req, res) {
    var user = {
      email:      req.body.email,
      facebookId: req.body.facebookId
    };

    userController.isUser(user)
      .then(function (user) {
        res.status(200);
        module.exports._authToken(req, res, user);
      })
      .catch(function (err) {
        if (err) {
          res.status(400).send('User does not exist');
        }
      });
  },

  authenticate: function (req, res, next) {
    jwt.verify(req.get('token'), process.env.JWT_SECRET, function (err, user) {
      if (err){
        res.status(400).send('Unauthorized use of endpoint. Please signup or login.');
      } else {
        req.user = user;
        next();
      }
    });
  },

  _authToken: function (req, res, user) {
    user.dataValues.token = jwt.sign(user, process.env.JWT_SECRET, { expiresIn: '1d' });
    res.send(user);
  }
};
