var expect = require('chai').expect;
var sinon = require('sinon');
var auth = require('../auth');
var userController = require('../user/userController');
var jwt = require('jsonwebtoken');

var UserA = {
              email: "cantilevered.marshmallow@gmail.com",
              facebookId: "118724648484592",
              oauthToken: "CAABlq42VOg0BAPDz6Yw5Kc68CMXHSArMiIJfrO2U5czOZC8yFxbdUYfOaXjiX0ZB1TziPpuKjK4AmNboilObJfvijODZAYw6xsabYRB5WBxTfdddm5okDreDDk2nTvMhEZCQqHtbK3snPbyDbSTA9lzpC8g6PMOGDcR4aGEzzVTkDo0uonIzKwZCDpvsjhE2wI9BLNkHaZCPS40PCxZAo9vNjKjWSBUqrMALo5eZBoWZBkgZDZD",
            };
var falseUserA = { email: 'test@testing.com', facebookId: '118724648484592'};
var falseUserB = { email: 'test@testing.com'};

describe('Auth Service', function () {

  describe('authFacebook method', function () {

    it('should call the next callback on legitimate request', function (done) {
      var req = {
        body: UserA
      };
      var res = {
        status: function () {
          return this;
        },
        send: function (data) {
          done(new Error(data));
        }
      };
      var next = function () {
        done();
      };
      auth.authFacebook(req, res, next);
    });

    it('should response to an invalid request with status code 401', function (done) {
      var req = {
        body: falseUserA
      };
      var statusCode;
      var res = {
        status: function (code) {
          statusCode = code;
          return this;
        },
        send: function () {
          expect(statusCode).to.equal(401);
          done();
        }
      };
      var next = function () {
        done(new Error('Allowed unauthorized access'));
      };

      auth.authFacebook(req, res, next);
    });

    it('should response to an empty request body with status code 401', function (done) {
      var req = {
        body: {}
      };
      var statusCode;
      var res = {
        status: function (code) {
          statusCode = code;
          return this;
        },
        send: function () {
          expect(statusCode).to.equal(401);
          done();
        }
      };
      var next = function () {
        done(new Error('Allowed unauthorized access'));
      };

      auth.authFacebook(req, res, next);
    });


  });

  describe('signup method', function () {

    var res = {};
    var req = {};
    var userControllerStub;

    beforeEach(function (done) {
      res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this; },
        send: function () {},
        statusCode: 0
      };
      req = {};

      done();
    });

    afterEach(function (done) {
      userControllerStub.restore();
      done();
    });

    it('should create a new user, amend session object on req, and send back user data', function (done) {
      userControllerStub = sinon.stub(userController, 'registerNewUser', function (newUser) {
        return new Promise(function (resolve, reject) {
          newUser.toJSON = function () {
            return this;
          };
          resolve(newUser);
        });
      });

      req.body = UserA;

      res.send = function (data) {
        expect(res.statusCode).to.equal(201);
        expect(data.email).to.equal(UserA.email);
        expect(data.facebookId).to.equal(UserA.facebookId);
        done();
      };
      auth.signup(req, res);
    });
  });

  describe('login method', function () {

    var res = {};
    var req = {};
    var userControllerStub;

    beforeEach(function (done) {
      res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this; },
        send: function () {},
        statusCode: null
      };
      req = {
        get: function () {
          return jwt.sign(UserA, process.env.JWT_SECRET);
        }
      };

      done();
    });

    afterEach(function (done) {
      userControllerStub.restore();
      done();
    });


    it('should authenticate user and send back user data', function (done) {

      userControllerStub = sinon.stub(userController, 'isUser', function (user) {
        return new Promise(function (resolve, reject) {
          user.toJSON = function () {
            return this;
          };
          resolve(user);
        });
      });

      req.body = UserA;

      res.send = function (data) {
        expect(res.statusCode).to.equal(200);
        expect(data.email).to.equal(UserA.email);
        expect(data.facebookId).to.equal(UserA.facebookId);
        done();
      };

      auth.login(req, res);
    });

  });

  describe('Authenticate Middleware', function () {
    var req;
    var res;

    beforeEach(function (done) {
      req = {
        get: function () {
          return jwt.sign(UserA, process.env.JWT_SECRET);
        }
      };
      res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this; },
        send: sinon.spy(),
        statusCode: 0
      };
      done();
    });

    it('should authenticate logged in user', function (done) {

      var next = function () {
        expect(res.send.called).to.equal(false);
        done();
      };

      auth.authenticate(req, res, next);
    });

    it('should reject unauthenticated user', function (done) {
      req.get = function () {
        return 'afdasfadsfasdfasdfsafa';
      };
      var next = sinon.spy();
      res.send = function () {
        expect(res.statusCode).to.equal(401);
        expect(next.called).to.equal(false);
        done();
      };

      auth.authenticate(req, res, next);
    });

  });

});
