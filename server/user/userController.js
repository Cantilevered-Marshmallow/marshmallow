var User = require('../db/db').User;

module.exports = {

  registerNewUser: function (newUser) {
    return User.create(newUser);
  },

  isUser: function (user) {
    return User.findOne({
      where: {
        email: user.email,
        facebookId: user.facebookId
      }
    });
  },
};
