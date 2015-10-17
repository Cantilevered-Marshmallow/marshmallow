var Sequelize = require('Sequelize');
var sequelize = require(__dirname + '/../db/db');

var User = sequelize.define('user', {
  email: {type: Sequelize.STRING, unique: true},
  oauthToken: {type: Sequelize.STRING, unique: true}
});

module.exports = User;
