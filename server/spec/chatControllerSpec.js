var expect = require('chai').expect;
var chatController = require('../chat/chatController');
var sinon = require('sinon');
var Chat = require('../db/db').Chat;
var User = require('../db/db').User;

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

    var chats = [ {id: '1'}, {id: '2'} ];

    var userInstance = {
      getChats: function () {
        return new Promise (function (resolve, reject) {
          resolve(chats);
        });
      }
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

    it('should resolve all chats', function (done) {
      chatController.retrieveChats(user)
        .then(function (resolveObj) {
          expect(resolveObj).to.deep.equal(['1','2']);
          done();
        });
    });
  });

});

