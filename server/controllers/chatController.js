var Chat = require('../utils/db').Chat;
var User = require('../utils/db').User;
var Message = require('../utils/db').Message;
var RedditAttachment = require('../utils/db').RedditAttachment;
var sockets = require('../utils/sockets');

module.exports = {

  /**
   * Creates a chat with list of users provided
   *
   * @param {array} userList - List of user facebookIds
   * @return {Promise <object>} - Chat instance object
   */
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

  /**
   * Retrieves chats that the user belongs to
   *
   * @param {object} user - User object with email and facebookId properties
   * @return {Promise <array>} - Array of chat objects
   */
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

  /**
   * Retrieves messages for a single chat
   *
   * @param {string} chatId - ID of the chat you want messages of
   * @return {Promise <array>} - Array of message objects
   */
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

  /**
   * Broadcasts message using socket.io to all users in the chat
   *
   * @param {string} chatId - ID of the chat you want to broadcast to
   * @param {object} message - Message object to be broadcasted
   */
  broadcastMessage: function (chatId, message) {
    Chat.findOne({
      where: {id: chatId},
      include: [{model: User, as: 'users'}]
    }).then(function (chat) {
      chat.users.forEach(function (user) {
        if (sockets[user.facebookId]) {
          sockets[user.facebookId].emit('message', message);
        }
      });
    });
  },

  /**
   * Posts a message to a chat by a single user
   *
   * @param {string} chatId - ID of the chat that will receive the message
   * @param {string} facebookId - Facebook ID of the poster
   * @param {object} message - Message object to be posted
   * @return {Promise <array>} - Array of message instance objects
   */
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
        var bcMessage = messageInstance.toJSON();
        bcMessage.redditAttachment = message.redditAttachment || {};
        this.broadcastMessage(chatId, bcMessage);
        return Promise.all([
            messageInstance.setChat(chatId),
            messageInstance.setUser(facebookId)
          ]);
      }.bind(this));
  },

  /**
   * Retrieves all relevant messages for a user filtered by a cut-off timestamp
   *
   * @param {string} facebookId - Facebook ID of the relevant user
   * @param {string} timestamp - ISO-8601 time from which messages are required
   * @return {Promise <array>} - Array of message objects
   */
  getMessagesByTime: function (facebookId, timestamp) {
    return User.findById(facebookId)
      .then(function (user) {
        return user.getChats({include: [
            {model: Message, as: 'messages', where: {createdAt: {$gt: timestamp} },
              include: [{model: RedditAttachment, as: 'redditAttachment'}] }
          ]});
      }).then(function (chats) {
        var messages = [];
        for (var i = 0; i < chats.length; i++) {
          messages = messages.concat(chats[i].messages);
        }
        return messages;
      });
  }
};
