var userController = require('./user/userController');
var request = require('request');

module.exports = {

  authFacebook: function (req, res, next) {
    var user = req.body;
    request('https://graph.facebook.com/me?access_token=' + user.oauthToken,
      function (err, _, body) {
        body = JSON.parse(body);
        if (body.id === user.facebookId){
          next();
        } else {
          console.log(user);
          console.log(body);
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
        module.exports._authSession(req, res, user);
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
        module.exports._authSession(req, res, user);
      })
      .catch(function (err) {
        if (err) {
          res.status(400).send('User does not exist');
        }
      });
  },

  logout: function (req, res) {
    if (req.session) {
      req.session.destroy();
    }
    res.status(200).end();
  },

  authenticate: function (req, res, next) {
    if (req.session.user && req.session.auth) {
      next();
    } else {
      res.status(400).send('Unauthorized use of endpoint. Please signup or login.');
    }
  },

  _authSession: function (req, res, user) {
    req.session.user = user;
    req.session.auth = true;
    res.send(user);
  }

};
