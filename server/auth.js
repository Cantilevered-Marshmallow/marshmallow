var userController = require('./user/userController');

module.exports = {

  signup: function (req, res) {
    var user = req.body;
    userController.registerNewUser(user)
      .then(function (user) {
        res.status(201);
        this._authSession(req, res, user);
      }.bind(this))
      .catch(function (err) {
        if (err) {
          this.login(req, res);
        }
      }.bind(this));
  },

  login: function (req, res) {
    var user = req.body;
    userController.isUser(user)
      .then(function (user) {
        res.status(200);
        this._authSession(req, res, user);
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
