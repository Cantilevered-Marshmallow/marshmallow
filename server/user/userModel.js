var Sequelize = require('Sequelize');
var sequelize = require(__dirname + '/../db/db');

var User = sequelize.define('user', {
  email: Sequelize.STRING,
  oauth_token: Sequelize.STRING
});

User.sync();

module.exports = User;
