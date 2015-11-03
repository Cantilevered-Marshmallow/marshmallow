var Chat = require('../db/db').Chat;
var User = require('../db/db').User;
var Message = require('../db/db').Message;
var RedditAttachment = require('../db/db').RedditAttachment;

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
      include: [{model: Message, as: 'messages',
                include: [{model: User, as: 'user'},
                          {model: RedditAttachment, as: 'redditAttachment'}]}]
    }).then(function (chat) {
        return chat.messages;
      });
  },

  postMessage: function (chatId, facebookId, message) {
    return Message.create(message)
      .then(function (messageInstance) {
        if (message.hasOwnProperty('redditAttachment')) {
          return messageInstance.createRedditAttachment(message.redditAttachment);
        } else {
          return messageInstance;
        }
      })
      .then(function (messageInstance) {
        return Promise.all([
            messageInstance.setChat(chatId),
            messageInstance.setUser(facebookId)
          ]);
      });
  },

  getMessagesByTime: function (facebookId, timestamp) {
    return User.findById(facebookId)
      .then(function (user) {
        return user.getChats({include: [{model: Message, as: 'messages', where: {createdAt: {$gt: timestamp}}}]});
      }).then(function (chats) {
        var messages = [];
        for (var i = 0; i < chats.length; i++) {
          messages = messages.concat(chats[i].messages);
        }
        return messages;
      });
  }
};
