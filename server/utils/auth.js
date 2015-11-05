var userController = require('../controllers/userController');
var request = require('request');
var jwt = require('jsonwebtoken');

module.exports = {

  /**
   * Middleware for authenticating using user's Facebook access token
   *
   * @param {object} req - Express request object
   * @param {object} res - Express response object
   * @param {function} next - Express next callback function
   */
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

  /**
   * Creates a user - forward to login if user already exists
   *   otherwise, forwards on to _authToken method once created
   *
   * @param {object} req - Express request object
   * @param {object} res - Express response object
   */
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

  /**
   * Checks whether user exists then forwards to _authToken method
   *
   * @param {object} req - Express request object
   * @param {object} res - Express response object
   */
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

  /**
   * Middleware for authenticating users by verifying their JWT on the
   * 'token' HTTP header value
   *
   * @param {object} req - Express request object
   * @param {object} res - Express response object
   * @param {function} next - Express next function
   */
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

  /**
   * Creates a new JWT using user credentials and sends it back to the client
   *
   * @param {object} req - Express request object
   * @param {object} res - Express response object
   * @param {object} user - User object
   */
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
