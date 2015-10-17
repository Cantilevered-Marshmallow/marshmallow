var request = require('supertest');

/* For reference
   http://glebbahmutov.com/blog/how-to-correctly-unit-test-express-server/
*/

xdescribe('Sign up and log in', function () {
  var server;
  before(function () {
    server = require('../server');
  });

  after(function () {
    server.close();
  });

  it('should register a new user', function (done) {
    request(server).post('/signup')
      .set('Content-Type', 'application/json')
      .send({email: 'test@testing.com', oathToken: '4ecf21412412a8f0d9ec3242'})
      .expect(201, done);
  });

  it('should not register the same user twice and it should redirect registered user to login', function (done) {
    request(server).post('/signup')
      .set('Content-Type', 'application/json')
      .send({email: 'test@testing.com', oathToken: '4ecf21412412a8f0d9ec3242'})
      .expect(200, done);
  });

  it('should log in an existing user', function (done) {
    request(server).post('/login')
      .set('Content-Type', 'application/json')
      .send({email: 'test@testing.com', oathToken: '4ecf21412412a8f0d9ec3242'})
      .expect(200, done);
  });
});
