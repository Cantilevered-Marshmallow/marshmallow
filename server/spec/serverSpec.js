var request = require('supertest');
var sinon = require('sinon');
var auth = require('../auth');

/* For reference
   http://glebbahmutov.com/blog/how-to-correctly-unit-test-express-server/
*/

describe('Sign up and log in', function () {
  var server;
  var fakeFacebookServer;
  var user;
  before(function () {
    server = require('../server');
    // fake user
    user = {
      email: "cantilevered.marshmallow@gmail.com",
      oauthToken: "1234",
      facebookId: "24680"
    };
    // fake facebook response
    facebookJSONresponse = {
      name: "Brad Smith",
      id: "24680"
    };
    // fake facebook server
    fakeFacebookServer = sinon.fakeServer.create();
    fakeFacebookServer.respondWith("GET", "https://graph.facebook.com/me?access_token=1234",
                        [200, { "Content-Type": "application/json" }, JSON.stringify(facebookJSONresponse)]);
    fakeFacebookServer.respondImmediately = true;
  });

  after(function () {
    server.close();
    fakeFacebookServer.restore();
  });

  it('should register a new user and authenticate a new session', function (done) {
    request(server).post('/signup')
      .set('Content-Type', 'application/json')
      .send(user)
      .expect(201, done);
  });

  xit('should not register the same user twice and it should redirect registered user to login', function (done) {
    request(server).post('/signup')
      .set('Content-Type', 'application/json')
      .send({email: 'test@testing.com', oathToken: '4ecf21412412a8f0d9ec3242'})
      .expect(200, done);
  });

  xit('should log in an existing user', function (done) {
    request(server).post('/login')
      .set('Content-Type', 'application/json')
      .send({email: 'test@testing.com', oathToken: '4ecf21412412a8f0d9ec3242'})
      .expect(200, done);
  });
});
