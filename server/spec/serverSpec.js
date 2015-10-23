var request = require('supertest');
var sinon = require('sinon');
var auth = require('../auth');

/* For reference
   http://glebbahmutov.com/blog/how-to-correctly-unit-test-express-server/
*/

var server;

var BradSmith = {
  email: "cantilevered.marshmallow@gmail.com",
  oauthToken: "CAABlq42VOg0BAPDz6Yw5Kc68CMXHSArMiIJfrO2U5czOZC8yFxbdUYfOaXjiX0ZB1TziPpuKjK4AmNboilObJfvijODZAYw6xsabYRB5WBxTfdddm5okDreDDk2nTvMhEZCQqHtbK3snPbyDbSTA9lzpC8g6PMOGDcR4aGEzzVTkDo0uonIzKwZCDpvsjhE2wI9BLNkHaZCPS40PCxZAo9vNjKjWSBUqrMALo5eZBoWZBkgZDZD",
  facebookId: "118724648484592"
};

var PeterParker = {
  email: "cantilevered.marshmallowed@gmail.com",
  oauthToken: "CAABlq42VOg0BAIjAi3ZAcymPFZAuutxpSlfb1ZCVzgS6xB9JAgt84EqKDrRJHZCFj4EaO6xxEA6EHC5dwV14MmGuyicJ7nfRcTNImI2xiW9eutCTOaQSsJndrLsJqkq71ewvn73ygkJ33T9TsRuKYeyYvZCbeGOSFiS12fr5XhKqOJhfOXK7MWcPEyp0FlsRVqcUzlG0fKNP40rFFfzF7hNdAOCrFWh7ZApHJag31gxQZDZD",
  facebookId: "102400480121838"
};


describe('Sign up and log in', function () {
  before(function (done) {
    server = require('../server');
    done();
  });

  after(function (done) {
    server.close();
    done();
  });

  it('should register a new user and authenticate a new session', function (done) {
    request(server).post('/signup')
      .set('Content-Type', 'application/json')
      .send(BradSmith)
      .expect(function (res) {
        if (typeof res.body !== 'object') {
          throw new Error("Missing response body");
        }
      })
      .expect(201, done);
  });

  it('should register another new user and authenticate a new session', function (done) {
    request(server).post('/signup')
      .set('Content-Type', 'application/json')
      .send(PeterParker)
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
      .send(BradSmith)
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
      .send(BradSmith)
      .expect(function (res) {
        if (typeof res.body !== 'object') {
          throw new Error("Missing response body");
        }
      })
      .expect(200, done);
  });

});

describe('GET and POST to /chat and /chat:id', function () {


  var agent1;
  var agent2;

  before(function (done) {
    server = require('../server');

    // Brad Smith
    agent1 = request.agent(server);
    // Peter Parker
    agent2 = request.agent(server);

    done();
  });

  after(function (done) {
    server.close();
    done();
  });

  it('should log in Brad Smith', function (done) {

    // Brad Smith logs in
    agent1
      .post('/login')
      .send(BradSmith)
      .expect(200, done);

  });

  it('should log in Peter Parker', function (done) {

    // Peter Parker logs in
    agent2
      .post('/login')
      .send(PeterParker)
      .expect(200, done);
  });

  it('BradSmith should have PeterParker under contacts', function (done) {

    // All of Brad Smith's friends ID's.
    // First one is Peter Parker
    var postBody = {users: ['102400480121838', '102400480133338', '103400480121838']}

    agent1
      .post('/userlist')
      .send(postBody)
      .expect(function (res) {
        if (!res.body.hasOwnProperty('users')) {
          throw new Error('Did not get filtered list back');
        }
        if (!Array.isArray(res.body.users) || res.body.users.length !== 1) {
          throw new Error('Incorrect filtered list sent back');
        }
      })
      .expect(200, done);
  });

  it('should create a new chat room for list of users', function (done) {

    var users = { users: ['118724648484592', '102400480121838'] };

    // Brad Smith creates chat room with Peter Parker
    agent1
      .post('/chat')
      .send(users)
      .expect(function (res) {
        if (!res.body.hasOwnProperty('chatId')) {
          throw new Error('Failed to create a new chat room');
        }
      })
      .expect(201, done);
  });

  it('should not create a new chat room for a list of less than two users', function (done) {
    var users = { users: ['5253463547456458'] };
    
    agent1
      .post('/chat')
      .send(users)
      .expect(400, done);

  });

  it('should retrieve all chat room id\'s is associated with a user', function (done) {
    agent2
      .get('/chat')
      .expect(function (res) {
        // Peter Parker (agent2) only belongs to one chat room, which is with Brad Smith.
        if (!Array.isArray(res.body.chats) || res.body.chats.length !== 1) {
          throw new Error('Failed to get chats that a specific user is in');
        }
      })
      .expect(200, done);
  });

  it('should accept a chat message', function (done) {
    var msg = { text: 'Hey Peter! How\'s it going'};

    // DB only has one chat room that has id: 1
    agent1
      .post('/chat/1')
      .send(msg)
      .expect(201, done);
  });

  it('shoud retrieve all messages for given a chat room id', function (done) {

    agent2
      .get('/chat/1')
      .expect(function (res) {
        if (!res.body.hasOwnProperty('messages')) {
          throw new Error('Failed to retrieve messages for a specific chat room');
        }
      })
      .expect(200, done);
  });

});


