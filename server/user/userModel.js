var Sequelize = require('Sequelize');
var sequelize = require(__dirname + '/../db/db');

var User = sequelize.define('user', {
  email: {type: Sequelize.STRING, unique: true},
  facebookId: {type: Sequelize.INTEGER, unique: true}
});

module.exports = User;
