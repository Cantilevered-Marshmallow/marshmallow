var request = require('supertest');
var sinon = require('sinon');
var auth = require('../auth');
// var User = require('../user/userModel');

/* For reference
   http://glebbahmutov.com/blog/how-to-correctly-unit-test-express-server/
*/

describe('Sign up and log in', function () {
  var server;
  var user;
  before(function (done) {
    server = require('../server');
    // fake user
    user = {
      email: "cantilevered.marshmallow@gmail.com",
      oauthToken: "CAABlq42VOg0BAPDz6Yw5Kc68CMXHSArMiIJfrO2U5czOZC8yFxbdUYfOaXjiX0ZB1TziPpuKjK4AmNboilObJfvijODZAYw6xsabYRB5WBxTfdddm5okDreDDk2nTvMhEZCQqHtbK3snPbyDbSTA9lzpC8g6PMOGDcR4aGEzzVTkDo0uonIzKwZCDpvsjhE2wI9BLNkHaZCPS40PCxZAo9vNjKjWSBUqrMALo5eZBoWZBkgZDZD",
      facebookId: "118724648484592"
    };
    
    done();
  });

  after(function (done) {
    server.close();
    done();
  });

  it('should register a new user and authenticate a new session', function (done) {
    request(server).post('/signup')
      .set('Content-Type', 'application/json')
      .send(user)
      .expect(function (res) {
        if (typeof res.body !== 'object') {
          throw new Error("Missing response body");
        }
      })
      .expect(201, done);
  });

  it('should not register the same user twice and it should redirect registered user to login', function (done) {
    request(server).post('/signup')
      .set('Content-Type', 'application/json')
      .send(user)
      .expect(function (res) {
        if (typeof res.body !== 'object') {
          throw new Error("Missing response body");
        }
      })
      .expect(200, done);
  });

  it('should log in an existing user', function (done) {
    request(server).post('/login')
      .set('Content-Type', 'application/json')
      .send(user)
      .expect(function (res) {
        if (typeof res.body !== 'object') {
          throw new Error("Missing response body");
        }
      })
      .expect(200, done);
  });
});
