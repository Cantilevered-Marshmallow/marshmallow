var expect = require('chai').expect;
var sinon = require('sinon');
var chatController = require('../controllers/chatController');
var Chat = require('../controllers/db').Chat;
var User = require('../controllers/db').User;
var Message = require('../controllers/db').Message;
var sockets = require('../controllers/sockets');

describe('Chat Controller', function () {

  describe('Create chat', function () {
    var userStub;
    var chatStub;

    beforeEach(function (done) {
      userStub = sinon.stub(User, 'findAll');
      chatStub = sinon.stub(Chat, 'create');
      done();
    });

    afterEach(function (done) {
      userStub.restore();
      chatStub.restore();
      done();
    });

    it('should not create a chat with only one user', function (done) {
      var inputList = ['6253463547456459'];
      chatController.createChat(inputList)
        .then(function () {
          done(new Error('Resolved promise'));
        })
        .catch(function (err) {
          expect(err).to.be.an.instanceof(Error);
          done();
        });
    });

    it('should create a chat with correct users', function (done) {
      var setUsersList;

      var usersList = [
          {email: 'test3@test.com', facebookId: '5253463547456458'},
          {email: 'test4@test.com', facebookId: '6253463547456459'}
        ];

      userStub.returns(new Promise (function (resolve, reject) {
        resolve(usersList);
      }));

      var chatInstance = {
          id: 12341245,
          setUsers: function (list) {
            setUsersList = list;
          }
        };

      chatStub.returns(
          new Promise( function (resolve) { resolve(chatInstance);} )
        );

      var inputList = ['6253463547456459', '5253463547456458'];

      chatController.createChat(inputList)
        .then(function (resolveObj) {
          expect(setUsersList).to.deep.equal(usersList);
          expect(userStub.called).to.equal(true);
          expect(chatStub.called).to.equal(true);
          expect(resolveObj).to.deep.equal(chatInstance);
          done();
        });
    });
  });

  describe('Retrieve chats', function () {

    var user = {
      email: 'test1@test.com',
      facebookId: '142363545876534'
    };

    var chats = [
        {id: '1',
         users: [{facebookId: '234324535'}]},
        {id: '2',
         users: [{facebookId: '565475675'}]},
      ];

    var userInstance = {
      chats: chats
    };

    var userStub;

    beforeEach(function (done) {

      userStub = sinon.stub(User, 'findOne', function (query) {
        return new Promise (function (resolve, reject) {
          if(query.where.email === user.email && query.where.facebookId === user.facebookId){
            resolve(userInstance);
          } else {
            resolve(null);
          }
        });
      });

      done();
    });

    afterEach(function (done) {
      userStub.restore();
      done();
    });

    var resultObj = [
      {chatId: '1', users: ['234324535']},
      {chatId: '2', users: ['565475675']}
    ];

    it('should resolve all chats', function (done) {
      chatController.retrieveChats(user)
        .then(function (resolveObj) {
          expect(resolveObj).to.deep.equal(resultObj);
          done();
        });
    });
  });

  describe('Get messages', function () {
    var chatId = 1234;
    var chats = {
      1234: {id: chatId, messages: []},
      5678: {id: 5678, messages: []}
    };
    var userStub;
    beforeEach(function (done) {
      chatStub= sinon.stub(Chat, 'findOne', function (query) {
        return new Promise (function (resolve, reject) {
          resolve(chats[query.where.id]);
        });
      });
      done();
    });

    afterEach(function (done) {
      chatStub.restore();
      done();
    });

    it('should retrieve all messages in the chat', function (done) {
      chatController.getMessages(chatId)
        .then(function (messages) {
          expect(messages).to.deep.equal(chats[chatId].messages);
          done();
        });
    });
  });

  describe('Post messages', function () {
    var facebookId = '1234';
    var chatId = '5678';
    var messageA = {
      text: 'hello world'
    };
    var messageB = {
      text: 'test number two',
      redditAttachment: {
        url: 'http://www.google.com',
        thumbnail: 'http://www.photos.com/image.jpg',
        title: 'Google Website'
      }
    };
    var setChat = false;
    var setUser = false;
    var attached = false;
    var inputMessage;
    var messageStub;
    var broadcastStub;

    beforeEach(function (done) {
      messageStub = sinon.stub(Message, 'create', function (messageObj) {
        inputMessage = messageObj;
        return new Promise (function (resolve, reject) {
          messageObj.createRedditAttachment = function (attachmentObj) {
            attached = true;
            return new Promise (function (resolve, reject) {
              resolve(messageObj);
            });
          };
          messageObj.setChat = function (chatId) {
            setChat = true;
            return new Promise (function (resolve, reject) {
              resolve(messageObj);
            });
          };
          messageObj.setUser = function (facebookId) {
            setUser = true;
            return new Promise (function (resolve, reject) {
              resolve(messageObj);
            });
          };
          messageObj.toJSON = function () {
            return this;
          };
          resolve(messageObj);
        });
      });

      broadcastStub = sinon.stub(chatController, 'broadcastMessage', function () {
        void 0;
      });

      done();
    });

    afterEach(function (done) {
      setChat = false;
      setUser = false;
      attached = false;
      inputMessage = {};
      messageStub.restore();
      broadcastStub.restore();
      done();
    });

    it('should post a message with correct information', function (done) {
      chatController.postMessage(chatId, facebookId, messageA)
        .then(function () {
          expect(setChat).to.equal(true);
          expect(setUser).to.equal(true);
          expect(messageA).to.deep.equal(inputMessage);
          done();
        });
    });

    it('should post a message with a reddit attachment', function (done) {
      chatController.postMessage(chatId, facebookId, messageB)
        .then(function () {
          expect(setChat).to.equal(true);
          expect(setUser).to.equal(true);
          expect(attached).to.equal(true);
          expect(messageB).to.deep.equal(inputMessage);
          done();
        });
    });
  });

  describe('Broadcast Messages to each socket', function () {
    var chatId = 123;
    var facebookId = '9876';
    var message = {text: 'hello world'};
    var chatStub;

    beforeEach(function (done) {
      sockets[facebookId] = {
        emit: function () { void 0; }
      };
      chatStub = sinon.stub(Chat, 'findOne', function () {
        return new Promise (function (resolve, reject) {
          resolve({users: [{facebookId: facebookId}, {facebookId: 'non-existant'}]});
        });
      });
      done();
    });

    afterEach(function (done) {
      chatStub.restore();
      done();
    });

    it('should emit messages to the relevant sockets', function (done) {
      chatController.broadcastMessage(chatId, message);
      done();
    });
  });

  describe('Get all messages by user\'s chats', function () {
    var facebookId = '1234';
    var timestamp = new Date().toISOString();

    var messagesA = [{'message': 'object', 'is': 'here'}];
    var messagesB = [{'another': 'message', 'object': 'here'}];

    var chats = [
      {messages: messagesA},
      {messages: messagesB}
    ];

    var user = {
      getChats: function () {
        return new Promise (function (resolve, reject) {
          resolve(chats);
        });
      }
    };
    var userStub = sinon.stub(User, 'findById', function () {
      return new Promise (function (resolve, reject) {
        resolve(user);
      });
    });

    after(function (done) {
      userStub.restore();
      done();
    });

    it('should return all messages in one array', function (done) {
      chatController.getMessagesByTime()
        .then(function (messages) {
          expect(messages).to.deep.equal(messagesA.concat(messagesB));
          done();
        });
    });
  });

});

