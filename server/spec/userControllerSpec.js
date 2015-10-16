var userController = require('../user/userController');

describe('User Controller', function () {

  var newUser = { email: 'test@testing.com', oauthToken: '4ecf21412412a8f0d9ec3242' };
  var falseUserA = { email: 'test@testing.com', oauthToken: 'fakefake' };
  var falseUserB = { email: 'fake@fake.com', oauthToken: '4ecf21412412a8f0d9ec3242' };

  it('should a create new user', function (done) {
    userController.registerNewUser(newUser)
      .then(function (user) {
        expect(user.email).to.equal(newUser.email);
        expect(user.oauthToken).to.equal(newUser.oauthToken);
        done();
      })
      .catch(function (err) {
        throw new Error(err);
      });
  });

  it('should find an existing user', function (done) {
    userController.isUser(newUser)
      .then(function (user) {
        expect(user.email).to.equal(newUser.email);
        expect(user.oauthToken).to.equal(newUser.oauthToken);
        done();
      })
      .catch(function (err) {
        throw new Error(err);
      });
  });

  it('should not find a non-existant user', function (done) {
    userController.isUser(falseUserA)
      .then(function (user) {
        expect(user).to.equal(undefined);
      })
      .catch(function (err) {
        throw new Error(err);
      });
    userController.isUser(falseUserB)
      .then(function (user) {
        expect(user).to.equal(undefined);
        done();
      })
      .catch(function (err) {
        throw new Error(err);
      });
  });
});
