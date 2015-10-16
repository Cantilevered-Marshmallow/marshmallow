var Sequelize = require('sequelize');
var sequelize = new Sequelize('mysql://');
var model = require('../user/userModel')(sequelize);
var userController = require('../user/userController')(sequelize);

describe('User Controller', function () {

  var newUser = { email: 'test@testing.com', oauthToken: '4ecf21412412a8f0d9ec3242' };
  beforeEach(function (done) {
    sequelize.sync({force: true}).success(function () {
      done();
    });
  });

  it('should create user', function (done) {
    var req = { body: newUser };
    userController.create(req, mock);
  });
});
