var Chat = require('../db/db').Chat;
var User = require('../db/db').User;
var Message = require('../db/db').Message;

module.exports = {

  createChat: function (userList) {
    if (userList.length < 2) {
      return new Promise(function (resolve, reject) {
        reject(new Error('Cannot create chat for less than two person'));
      });
    }
    return Chat.create().then(function (chat) {
      User.findAll({
        where: { facebookId: { in: userList } }
      })
      .then(function (users) {
        chat.setUsers(users);
      });
      return chat;
    });
  },

  retrieveChats: function (user) {
    return User.findOne({ where:{
      email: user.email,
      facebookId: user.facebookId
    }}).then(function (userInstance) {
      return userInstance.getChats();
    }).then(function (chats) {
      return chats.map(function (chat) {
        return chat.id;
      });
    });
  },

  getMessages: function (chatId) {
    return Chat.findOne({
      where: {id: parseInt(chatId)},
      include: [{model: Message, as: 'messages', include: [{model: User, as: 'user'}]}]
    }).then(function (chat) {
        return chat.messages;
      });
  },

  postMessage: function (chatId, facebookId, message) {
    return Message.create(message)
      .then(function (message) {
        return Promise.all([
            message.setChat(chatId),
            message.setUser(facebookId)
          ]);
      });
  },

  _cleanMessageInstance: function () {
  }

};
