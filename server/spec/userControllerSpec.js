var expect = require('chai').expect;
var userController = require('../user/userController');
var sinon = require('sinon');
var User = require('../db/db').User;

// User.create
// User.findOne

describe('User Controller', function () {

  var UserA = {
                email: "cantilevered.marshmallow@gmail.com",
                facebookId: "118724648484592",
                oauthToken: "CAABlq42VOg0BAPDz6Yw5Kc68CMXHSArMiIJfrO2U5czOZC8yFxbdUYfOaXjiX0ZB1TziPpuKjK4AmNboilObJfvijODZAYw6xsabYRB5WBxTfdddm5okDreDDk2nTvMhEZCQqHtbK3snPbyDbSTA9lzpC8g6PMOGDcR4aGEzzVTkDo0uonIzKwZCDpvsjhE2wI9BLNkHaZCPS40PCxZAo9vNjKjWSBUqrMALo5eZBoWZBkgZDZD",
              };
  var falseUserA = { email: 'cantilevered.marshmallow@gmail.com', facebookId: '111222333444555'};
  var falseUserB = { email: 'fake.marshmallow@gmail.com', facebookId: '118724648484592'};

  var userStub;

  afterEach(function (done) {
    userStub.restore();
    done();
  });

  it('should create a new user', function (done) {
    userStub = sinon.stub(User, 'create', function (newUser) {
      return new Promise(function (resolve) {
        resolve(newUser);
      });
    });

    userController.registerNewUser(UserA)
      .then(function (user) {
        expect(user.email).to.equal(UserA.email);
        expect(user.facebookId).to.equal(UserA.facebookId);
        done();
      });
  });

  it('should not create the same user twice', function (done) {
    userStub = sinon.stub(User, 'create', function (newUser) {
      return new Promise(function (resolve, reject) {
        var e = new Error();
        e.name = 'SequelizeUniqueConstraintError';
        reject(e);
      });
    });

    userController.registerNewUser(UserA)
      .catch(function (err) {
        expect(err.name).to.equal('SequelizeUniqueConstraintError');
        done();
      });
  });

  it('should find an existing user', function (done) {
    userStub = sinon.stub(User, 'findOne', function (query) {
      return new Promise(function (resolve, reject) {
        if (query.where.email === UserA.email && query.where.facebookId === UserA.facebookId) {
          resolve(UserA);
        }
      });
    });

    userController.isUser(UserA)
      .then(function (user) {
        expect(user.email).to.equal(UserA.email);
        expect(user.facebookId).to.equal(UserA.facebookId);
        done();
      });
  });

  it('should not find a non-existant user', function (done) {
    userStub = sinon.stub(User, 'findOne', function (query) {
      return new Promise(function (resolve, reject) {
        if (query.where.email === UserA.email && query.where.facebookId === UserA.facebookId) {
          resolve(UserA);
        } else {
          resolve(null);
        }
      });
    });

    userController.isUser(falseUserA)
      .then(function (user) {
        expect(user).to.not.deep.equal(UserA);
        expect(user).to.not.deep.equal(falseUserA);
      });

    userController.isUser(falseUserB)
      .then(function (user) {
        expect(user).to.not.deep.equal(UserA);
        expect(user).to.not.deep.equal(falseUserB);
        done();
      });
  });

  it('should return a list of facebookIds', function (done) {
    var postBody = {users: ['213432123450987', '653496787465543', '365425430798645']};
    var findAllMock = sinon.stub(User, 'findAll').returns(
        new Promise(function (resolve) {
          resolve([
          {email: 'testemail@test.com', facebookId: '653496787465543'},
          {email: 'test2@test2.com', facebookId: '653523446554453'}
          ]);
        })
      );

    userController.userList(postBody.users).then(function (returnObject) {
      expect(returnObject).to.deep.equal(
          {users: ['653496787465543']}
        );
      done();
    });

  });

});
