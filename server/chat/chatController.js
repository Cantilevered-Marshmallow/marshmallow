var Chat = require('../db/db').Chat;
var User = require('../db/db').User;
var Message = require('../db/db').Message;

module.exports = {

  sockets: {},

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
    return User.findOne(
      {
        where:{
          email: user.email,
          facebookId: user.facebookId
        },
        include: [{model: Chat, as: 'chats', include: [{model: User, as: 'users'}]}]
      }).then(function (userInstance) {
        return userInstance.chats.map(function (chat) {
          var json = {chatId: chat.id, users: chat.users.map(function (userInChat) {
            return userInChat.facebookId;
          })};
          return json;
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

  broadcastMessage: function (chatId, message) {
    Chat.findOne({
      where: {id: chatId},
      include: [{model: User, as: 'users'}]
    }).then(function (chat) {
      chat.users.forEach(function (user) {
        if (module.exports.sockets[user.facebookId]) {
          module.exports.sockets[user.facebookId].emit('message', message);
        }
      });
    });
  },

  postMessage: function (chatId, facebookId, message) {
    this.broadcastMessage(chatId, message);
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
