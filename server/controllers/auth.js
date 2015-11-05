var userController = require('./userController');
var request = require('request');
var jwt = require('jsonwebtoken');

module.exports = {

  authFacebook: function (req, res, next) {
    var user = req.body;
    if (!(user.oauthToken && user.facebookId)){

      res.status(401).send('Error: empty request body.');

    } else {

      request('https://graph.facebook.com/me?access_token=' + user.oauthToken,
        function (err, _, body) {
          body = JSON.parse(body);
          if (body.id === user.facebookId){
            next();
          } else {
            res.status(401).send('Error: invalid Facebook access token');
          }
        });

    }
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
        module.exports.login(req, res);
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
        res.status(500).send('Error: database error when trying to find user');
      });
  },

  authenticate: function (req, res, next) {
    jwt.verify(req.get('token'), process.env.JWT_SECRET, function (err, user) {
      if (err){
        res.status(401).send('Unauthorized use of endpoint. Please signup or login.');
      } else {
        req.user = user;
        next();
      }
    });
  },

  _authToken: function (req, res, user) {
    user = user.toJSON();
    var token = jwt.sign(user, process.env.JWT_SECRET, { expiresIn: '1d' });

    var responseObj = {
      email: user.email,
      facebookId: user.facebookId,
      token: token
    };
    res.send(responseObj);
  }
};
