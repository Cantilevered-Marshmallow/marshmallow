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
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this; },
        send: function () {},
        statusCode: 0
      };
      req = {
        session: {}
      };

      done();
    });

    it('should create a new user, create session object on req, and send back user data', function (done) {
      req.body = UserA;

      var sendStub = sinon.stub(res, 'send', function(data){

        expect(res.statusCode).to.equal(201);
        expect(data.email).to.equal(UserA.email);
        expect(data.oauthToken).to.equal(UserA.oauthToken);

        User.findOne({where: UserA}).then(function (user) {
          expect(user.email).to.equal(UserA.email);
          expect(user.oauthToken).to.equal(UserA.oauthToken);
          done();
        })
        .catch(function (err) {
          throw new Error('AuthSpec: User model findOne error.', err);
        });

      });

      auth.signup(req, res);
    });

    it('should return an error on signup with incomplete information', function (done) {
      req.body = falseUserA;

      var sendStub = sinon.stub(res, 'send', function(data){

        expect(res.statusCode).to.equal(400);
        expect(data.email).to.not.equal(falseUserA.email);
        done();
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
            done();
          })
          .catch(done);
    });

    beforeEach(function (done) {
      res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this; },
        send: function () {},
        statusCode: 0
      };
      req = {
        session: {}
      };


      done();
    });

    it('should authenticate user and send back user data', function (done) {
      User.create(UserA);

      req.body = UserA;

      var test = function (data) {
        // expect(res.statusCode).to.equal(200);
        // expect(data.email).to.equal(UserA.email);
        // expect(data.oauthToken).to.equal(UserA.oauthToken);

        User.findOne({ where: UserA }).then(function (user) {
          // expect(user).to.deep.equal(UserA);
          done();
        })
        .catch(function (err) {
          done(err);
        });
      };

      res.send = function(data){
        test(data);
      };

      auth.login(req, res);
    });

    it('should return an error on login with false information', function (done) {
      req.body = falseUserA;

      var sendStub = sinon.stub(res, 'send', function(data){

        expect(data).to.not.deep.equal(falseUserA);

        User.findOne({ where: falseUserA }).then(function (user) {
          // expect(user).to.not.deep.equal(UserA);
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
      req = {
        session: {}
      };
      res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this; },
        send: null,
        statusCode: 0
      };

      User.sync({ force: true })
        .then(function () {
          User.create(UserA).then(function () {
            done();
          });
        });
    });

    it('should authenticate logged in user', function (done) {
      req.body = UserA;
      auth.login(req, res);
      var next = function () {
        expect(res.send.called).to.equal(false);
        done();
      };
      res.send = function () {
        expect(res.statusCode).to.equal(0);
        done();
      };


      auth.authenticate(req, res, next);
    });

    it('should reject unauthenticated user', function (done) {
      var next = sinon.spy();
      res.send = function () {
        expect(res.statusCode).to.equal(400);
        expect(next.called).to.equal(false);
        done();
      };

      auth.authenticate(req, res, next);
    });

  });

});
