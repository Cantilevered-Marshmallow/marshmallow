var sequelize = require('../db/db');
var expect = require('chai').expect;
var User = require('../user/userModel.js');

describe('User Model', function () {

  var newUser = { email: 'test@testing.com', oauthToken: '4ecf21412412a8f0d9ec3242' };
  var falseUserA = { email: 'test@testing.com', oauthToken: 'fakefake' };
  var falseUserB = { email: 'fake@fake.com', oauthToken: '4ecf21412412a8f0d9ec3242' };

  before(function (done) {
    sequelize.sync({force:true}).then(function () { done() });
  });

  after(function (done) {
    sequelize.drop().then(function() { done() });
  });

  it('should a create new user', function (done) {
    User.create(newUser)
      .then(function (user) {
        expect(user.email).to.equal(newUser.email);
        expect(user.oauthToken).to.equal(newUser.oauthToken);
        done();
      })
      .catch(function (err) {
        throw new Error(err);
      });
  });

  it('should find an existing user', function (done) {
    User.findOne({where: {email: newUser.email}})
      .then(function (user) {
        expect(user).to.not.equal(newUser);
        done();
      })
      .catch(function (err) {
        throw new Error(err);
      });
  });

  it('should not find a non-existant user', function (done) {
    User.findOne({where: {email: falseUserA.email}})
      .then(function (user) {
        expect(user).to.not.equal(falseUserA);
      })
      .catch(function (err) {
        throw new Error(err);
      });
    User.findOne({where: {email: falseUserB.email}})
      .then(function (user) {
        expect(user).to.not.equal(falseUserB);
        done();
      })
      .catch(function (err) {
        throw new Error(err);
      });
  });
});
