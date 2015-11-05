var User = require('../utils/db').User;

module.exports = {


  /**
   * Insert a new user to the database
   * Method would throw an error that is caught by the router if user already exists
   *
   * @param {object} newUser - user object receieved from client
   * @return {Promise <object>} - user instance retrieved from database
   */
  registerNewUser: function (newUser) {
    return User.create(newUser);
  },

  /**
   * Checks whether user exists in the database
   *
   * @param {object} - user object 
   * @return {Promise <object>} - user instance retrieved from database
   */
  isUser: function (user) {
    return User.findOne({
      where: {
        email: user.email,
        facebookId: user.facebookId
      }
    });
  },


  /**
   * Filters out users that does not exist in the database
   *
   * @param {array} list - array of facebook id's
   * @return {Promise <object>} - object with a key "user" that maps to 
   *                              an array of filtered facebook id's
   */
  userList: function (list) {
    return User.findAll().then(function (returnList) {

      var users = returnList.map(function (user) {
        return user.facebookId;
      }).filter(function (fbid) {
        for (var i = 0; i < list.length; i++) {
          if(list[i] === fbid){
            return true;
          }
        }
        return false;
      });

      return {users: users};
    });
  }
};
