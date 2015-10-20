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

  userList: function (list) {
    return User.findAll().then(function (users) {
      return users.map(function (user) {
        return user.facebookId;
      }).filter(function (fbid) {
        for (var i = 0; i < list.length; i++) {
          if(list[i] === fbid){
            return true;
          }
        }
        return false;
      });
    });
  }
};
