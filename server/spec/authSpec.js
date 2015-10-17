var expect = require('chai').expect;
var sinon = require('sinon');
var auth = require('../auth');
var User = require('../user/userModel');
describe('Auth Service', function () {

  describe('Signup', function () {

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
        status: function () { return this; },
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

  describe('Login', function () {

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
        status: function () { return this; },
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

  describe('Authenticate Middleware', function () {
    var req;
    var res;

    var UserA = { email: 'test@testing.com', oauthToken: '4ecf21412412a8f0d9ec3242' };

    beforeEach(function (done) {
      req = {};
      res = {
        status: function () { return this; },
        send: sinon.spy()
      };

      User.sync({ force: true })
        .then(function () {
          User.create(UserA).then(function () {
            done();
          });
        });
    });

    it('should authenticate logged in user', function (done) {
      auth.login(UserA);
      var next = function () {
        // expect(req).to.have.property('session');
        expect(res.send.called).to.equal(false);
        done();
      };

      auth.authenticate(req, res, next);
    });

    it('should reject unauthenticated user', function (done) {
      var next = sinon.spy();
      res.status = function (statusCode) {
        expect(statusCode).to.equal(400);
        expect(next.called).to.equal(false);
        // expect(req).to.not.have.property('session');
        done();
      };

      auth.authenticate(req, res, next);
    });

  });

});
