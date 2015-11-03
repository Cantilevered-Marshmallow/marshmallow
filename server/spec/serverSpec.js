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
        BradSmith.token = res.body.token;
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
        PeterParker.token = res.body.token;
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

  var timeStamp;

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
      .expect(function (res) {
        BradSmith.token = res.body.token;
      })
      .expect(200, done);
  });

  it('should log in Peter Parker', function (done) {

    // Peter Parker logs in
    agent2
      .post('/login')
      .send(PeterParker)
      .expect(function (res) {
        PeterParker.token = res.body.token;
      })
      .expect(200, done);
  });

  it('BradSmith should have PeterParker under contacts', function (done) {

    // All of Brad Smith's friends ID's.
    // First one is Peter Parker
    var postBody = {users: ['102400480121838', '102400480133338', '103400480121838']};

    agent1
      .post('/userlist')
      .set({token: BradSmith.token})
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
      .set({token: BradSmith.token})
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
      .set({token: BradSmith.token})
      .send(users)
      .expect(400, done);

  });

  it('should retrieve all chat room id\'s is associated with a user', function (done) {
    agent2
      .get('/chat')
      .set('token', PeterParker.token)
      .expect(function (res) {
        // Peter Parker (agent2) only belongs to one chat room, which is with Brad Smith.
        if (!Array.isArray(res.body.chats) || res.body.chats.length !== 1) {
          throw new Error('Failed to get chats that a specific user is in');
        }
      })
      .expect(200, done);
  });

  it('Each chat in the response of GET /chat should return a list of users engaged in the chat', function (done) {
    agent2
      .get('/chat')
      .set('token', PeterParker.token)
      .expect(function (res) {
        if (res.body.chats[0].users.length !== 2) {
          throw new Error('Wrong userlist returned');
        }
      })
      .expect(200, done);
  });


  it('should accept a chat message', function (done) {
    var msg = { text: 'Hey Peter! How\'s it going'};

    // DB only has one chat room that has id: 1
    agent1
      .post('/chat/1')
      .set({token: BradSmith.token})
      .send(msg)
      .expect(201, done);
  });

  it('shoud retrieve all messages for given a chat room id', function (done) {

    agent2
      .get('/chat/1')
      .set('token', PeterParker.token)
      .expect(function (res) {
        if (!res.body.hasOwnProperty('messages')) {
          throw new Error('Failed to retrieve messages for a specific chat room');
        }
        if (res.body.messages[0].chatId !== 1) {
         throw new Error('Wrong chat room');
        }
        if (res.body.messages[0].text !== 'Hey Peter! How\'s it going') {
          throw new Error('Wrong message retrieved');
        }
      })
      .expect(200, done);
  });

  it('PeterParker sends three messages to BradSmith', function (done) {
    var msg1 = { text: 'Hey Brad. I\'m doing good' };
    var msg2 = { text: 'How you been?' };
    var msg3 = { text: 'Haven\'t seen you around for a while' };
    timeStamp = new Date().toISOString();
    sinon.useFakeTimers(Date.now()).tick(5000);

    agent2
      .post('/chat/1')
      .set('token', PeterParker.token)
      .send(msg1)
      .expect(201)
      .end(function () {
        agent2
          .post('/chat/1')
          .set('token', PeterParker.token)
          .send(msg2)
          .expect(201)
          .end(function () {
            agent2
              .post('/chat/1')
              .set('token', PeterParker.token)
              .send(msg3)
              .expect(201, done);
          });
      });
  });

  it('BradSmith should retrieve all messages from chat room 1', function (done) {
    agent1
      .get('/messages?timestamp=' + timeStamp)
      .set('token', BradSmith.token)
      .expect(function (res) {
        if (!res.body.hasOwnProperty('messages')) {
          throw new Error('Failed to retrieve messages given timestamp');
        }
        if (res.body.messages.length !== 3) {
          throw new Error('BradSmith should receieve exactly three messages');
        }
      })
      .expect(200, done);
  });
});


