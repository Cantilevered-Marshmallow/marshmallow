var sequelize = require('../db/db');
var expect = require('chai').expect;
var userController = require('../user/userController');
var User = require('../user/userModel');

describe('User Controller', function () {

var UserA = {
              email: "cantilevered.marshmallow@gmail.com",
              facebookId: "118724648484592",
              oauthToken: "CAABlq42VOg0BAPDz6Yw5Kc68CMXHSArMiIJfrO2U5czOZC8yFxbdUYfOaXjiX0ZB1TziPpuKjK4AmNboilObJfvijODZAYw6xsabYRB5WBxTfdddm5okDreDDk2nTvMhEZCQqHtbK3snPbyDbSTA9lzpC8g6PMOGDcR4aGEzzVTkDo0uonIzKwZCDpvsjhE2wI9BLNkHaZCPS40PCxZAo9vNjKjWSBUqrMALo5eZBoWZBkgZDZD",
            };
var falseUserA = { email: 'cantilevered.marshmallow@gmail.com', facebookId: '111222333444555'};
var falseUserB = { email: 'fake.marshmallow@gmail.com', facebookId: '118724648484592'};

  beforeEach(function (done) {
    sequelize.sync({force:true}).then(function () { done(); });
  });

  after(function (done) {
    sequelize.drop().then(function() { done(); });
  });

  it('should create a new user', function (done) {
    userController.registerNewUser(UserA)
      .then(function (user) {
        expect(user.email).to.equal(UserA.email);
        expect(user.facebookId).to.equal(UserA.facebookId);
        done();
      });
  });

  it('should not create the same user twice', function (done) {
    User.create(UserA).then(function () {
      userController.registerNewUser(UserA)
        .catch(function (err) {
          expect(err.name).to.equal('SequelizeUniqueConstraintError');
          done();
        });
    });
  });

  it('should find an existing user', function (done) {
    User.create(UserA).then(function () {
      userController.isUser(UserA)
        .then(function (user) {
          expect(user.email).to.equal(UserA.email);
          expect(user.facebookId).to.equal(UserA.facebookId);
          done();
        });
    });
  });

  it('should not find a non-existant user', function (done) {
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
});
