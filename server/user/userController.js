var User = require('./userModel');

module.exports = {

  registerNewUser: function (newUser) {
    return User.create(newUser);
  },

  isUser: function (user) {
    return User.findOne({
      where: { email: user.email }
    });
  },
};
