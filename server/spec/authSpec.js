var expect = require('chai').expect;
var sinon = require('sinon');
var auth = require('../auth');
var User = require('../user/userModel');

describe('Signup - Auth Service', function () {

  var UserA = { email: 'test@testing.com', oauthToken: '4ecf21412412a8f0d9ec3242' };
  var falseUserA = { email: 'test@testing.com' };
  var res = {};
  var req = {};
  before(function (done) {
    User.sync({ force: true })
    .then(function () {
      done();
    });
  });

  beforeEach(function (done) {
    res = {
      send: function () {},
      status: 0
    };

    done();
  });

  it('should create a new user, create session object on req, and send back user data', function (done) {
    req.body = UserA;

    var sendStub = sinon.stub(res, 'send', function(data){

      expect(res.status).to.equal(201);
      expect(data).to.deep.equal(UserA);
      expect(req).to.have.property('session');

      User.findOne(UserA).then(function (user) {
        expect(user).to.deep.equal(UserA);
        done();
      })
      .catch(function (err) {
        throw new Error('User model findOne error.', err);
      });

    });

    auth.signup(req, res);
  });

  it('should return an error on signup with incomplete information', function (done) {
    req.body = falseUserA;

    var sendStub = sinon.stub(res, 'send', function(data){

      expect(res.status).to.equal(400);
      expect(data).to.not.deep.equal(falseUserA);
      expect(req).to.not.have.property('session');

      User.findOne(falseUserA).then(function (user) {
        expect(user).to.not.deep.equal(falseUserA);
        done();
      })
      .catch(function (err) {
        throw new Error('User model findOne error.', err);
      });

    });

    auth.signup(req, res);
  });
});

describe('Login - Auth Service', function () {

  var UserA = { email: 'test@testing.com', oauthToken: '4ecf21412412a8f0d9ec3242' };
  var falseUserA = { email: 'test@testing.com', oauthToken: 'faketokenfaketoken'};
  var res = {};
  var req = {};
  before(function (done) {
    User.sync({ force: true })
      .then(function () {
        User.create(UserA).then(function () {
          done();
        });
      });
  });

  beforeEach(function (done) {
    res = {
      send: function () {},
      status: 0
    };

    done();
  });

  it('should authenticate user and send back user data', function (done) {
    req.body = UserA;

    var sendStub = sinon.stub(res, 'send', function(data){

      expect(res.status).to.equal(200);
      expect(data).to.deep.equal(UserA);
      expect(req).to.have.property('session');

      User.findOne(UserA).then(function (user) {
        expect(user).to.deep.equal(UserA);
        done();
      })
      .catch(function (err) {
        throw new Error('User model findOne error.', err);
      });

    });

    auth.login(req, res);
  });

  it('should return an error on login with false information', function (done) {
    req.body = falseUserA;

    var sendStub = sinon.stub(res, 'send', function(data){

      expect(data).to.not.deep.equal(falseUserA);
      expect(req).to.not.have.property('session');

      User.findOne(falseUserA).then(function (user) {
        expect(user).to.not.deep.equal(UserA);
        done();
      })
      .catch(function (err) {
        throw new Error('User model findOne error.', err);
      });

    });

    auth.login(req, res);
  });
});
