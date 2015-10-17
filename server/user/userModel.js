var Sequelize = require('Sequelize');
var sequelize = require(__dirname + '/../db/db');

var User = sequelize.define('user', {
  email: Sequelize.STRING,
  oauthToken: Sequelize.STRING
});

User.sync();

module.exports = User;
