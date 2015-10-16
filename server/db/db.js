var Sequelize = require('Sequelize');

module.exports = new Sequelize('marshmallow', 'username', 'password', {
  host: 'localhost',
  dialet: 'mysql'
});
