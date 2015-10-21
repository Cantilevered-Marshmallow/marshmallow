var Sequelize = require('Sequelize');

var sequelize = new Sequelize(process.env.DB, process.env.DB_USER, process.env.DB_PASSWORD, {
  host: process.env.DB_SERVER,
  dialect: 'mysql',
  logging: false
});


var User = sequelize.define('user', {
  email: {type: Sequelize.STRING, unique: true},
  facebookId: {type: Sequelize.STRING, unique: true}
});

var Chat = sequelize.define('chat', {});

var UserChat = sequelize.define('user_chat', {});

Chat.belongsToMany(User, {through: UserChat });
User.belongsToMany(Chat, {through: UserChat });

sequelize.sync();
// User.sync();
// Chat.sync();


module.exports = {
  sequelize: sequelize,
  User: User,
  Chat: Chat
};
