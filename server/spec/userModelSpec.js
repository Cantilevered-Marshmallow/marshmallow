var expect = require('chai').expect;
var sequelize = require('../controllers/db').sequelize;
var User = require('../controllers/db').User;

describe('User Model', function () {

var UserA = {
              email: "cantilevered.marshmallow@gmail.com",
              facebookId: "118724648484592"
            };
var falseUserA = { email: 'test@testing.com', facebookId: '118724648484592'};
var falseUserB = { email: 'test@testing.com'};

  before(function (done) {
    sequelize.sync({force:true}).then(function () { done(); });
  });

  after(function (done) {
    sequelize.drop().then(function() { done(); });
  });

  it('should a create new user', function (done) {
    User.create(UserA)
      .then(function (user) {
        expect(user.email).to.equal(UserA.email);
        expect(user.facebookId).to.equal(UserA.facebookId);
        done();
      });
  });

  it('should find an existing user', function (done) {

    User.findOne({where: {email: UserA.email}})
      .then(function (user) {
        expect(user).to.not.equal(UserA);
        done();
      });

  });

  it('should not find a non-existant user', function (done) {

    User.findOne({where: {email: falseUserA.email}})
      .then(function (user) {
        expect(user).to.not.equal(falseUserA);
      });

    User.findOne({where: {email: falseUserB.email}})
      .then(function (user) {
        expect(user).to.not.equal(falseUserB);
        done();
      });

  });
});
