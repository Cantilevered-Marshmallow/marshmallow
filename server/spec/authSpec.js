var expect = require('chai').expect;
var sinon = require('sinon');
var auth = require('../auth');
var User = require('../db/db').User;

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

    it('should response to an invalid request with status code 400', function (done) {
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
          expect(statusCode).to.equal(400);
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

    it('should create a new user, amend session object on req, and send back user data', function (done) {
      req.body = UserA;

      res.send = function (data) {

        expect(res.statusCode).to.equal(201);
        expect(data.email).to.equal(UserA.email);
        expect(data.facebookId).to.equal(UserA.facebookId);

        User.findOne({where: {email: UserA.email}}).then(function (user) {
          expect(user.email).to.equal(UserA.email);
          expect(user.facebookId).to.equal(UserA.facebookId);
          done();
        });

      };

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

    it('should return an error on signup with falsified OAuth Token', function (done) {
      req.body = falseUserB;

      var sendStub = sinon.stub(res, 'send', function(data){

        expect(res.statusCode).to.equal(400);
        expect(data.email).to.not.equal(falseUserB.email);
        done();
      });

      auth.signup(req, res);
    });
  });

  describe('login method', function () {

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
        statusCode: null
      };
      req = {
        session: {}
      };

      done();
    });

    it('should authenticate user and send back user data', function (done) {

      req.body = UserA;

      res.send = function (data) {
        expect(res.statusCode).to.equal(200);
        expect(data.email).to.equal(UserA.email);
        expect(data.facebookId).to.equal(UserA.facebookId);
        expect(req.session.auth).to.equal(true);
        done();
      };

      User.create({
        email: UserA.email,
        facebookId: UserA.facebookId
      })
      .then(function () {
        auth.login(req, res);
      });

    });

  });

  describe('Authenticate Middleware', function () {
    var req;
    var res;

    beforeEach(function (done) {
      req = {
        session: {}
      };
      res = {
        status: function (statusCode) {
          this.statusCode = statusCode;
          return this; },
        send: sinon.spy(),
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
      req.session.user = UserA;
      req.session.auth = true;

      var next = function () {
        expect(res.send.called).to.equal(false);
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

  xdescribe('Logout', function () {

  });

});
