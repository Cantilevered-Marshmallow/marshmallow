var sequelize = require('../db/db');
var expect = require('chai').expect;
var userController = require('../user/userController');

describe('User Controller', function () {

  var newUser = { email: 'test@testing.com', oauthToken: '4ecf21412412a8f0d9ec3242' };
  var falseUserA = { email: 'test@testing.com', oauthToken: 'fakefake' };
  var falseUserB = { email: 'fake@fake.com', oauthToken: '4ecf21412412a8f0d9ec3242' };

  before(function (done) {
    sequelize.sync({force:true}).then(function () { done() });
  });

  after(function (done) {
    sequelize.drop().then(function() { done() });
  });

  it('should create a new user', function (done) {
    userController.registerNewUser(newUser)
      .then(function (user) {
        expect(user.email).to.equal(newUser.email);
        expect(user.oauthToken).to.equal(newUser.oauthToken);
        done();
      })
      .catch(function (err) {
        throw new Error(err);
      });
  });

  it('should not create the same user twice', function (done) {
    userController.registerNewUser(newUser)
      .then(function (user) {
        expect(user).to.not.equal(newUser);
        done();
      })
      .catch(function (err) {
        expect(err.name).to.equal('SequelizeUniqueConstraintError');
        done();
      });
  });

  it('should find an existing user', function (done) {
    userController.isUser(newUser)
      .then(function (user) {
        expect(user.email).to.equal(newUser.email);
        expect(user.oauthToken).to.equal(newUser.oauthToken);
        done();
      })
      .catch(function (err) {
        throw new Error(err);
      });
  });

  it('should not find a non-existant user', function (done) {
    userController.isUser(falseUserA)
      .then(function (user) {
        expect(user).to.not.equal(falseUserA);
      })
      .catch(function (err) {
        throw new Error(err);
      });

    userController.isUser(falseUserB)
      .then(function (user) {
        expect(user).to.not.equal(falseUserB);
      })
      .catch(function (err) {
        throw new Error(err);
      });
      done();
  });
});
