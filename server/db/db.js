var Sequelize = require('sequelize');

var sequelize = new Sequelize(process.env.DB, process.env.DB_USER, process.env.DB_PASSWORD, {
  host: process.env.MYSQL_PORT_3306_TCP_ADDR,
  dialect: 'mysql',
  logging: false,
  port: 3306
});


var User = sequelize.define('user', {
  email: {type: Sequelize.STRING, unique: true},
  facebookId: {type: Sequelize.STRING, unique: true, primaryKey: true}
});

var Chat = sequelize.define('chat', {});

var Message = sequelize.define('message', {
  text: Sequelize.STRING,
  youtubeVideoId: Sequelize.STRING,
  googleImageId: Sequelize.STRING
});

var UserChat = sequelize.define('user_chat', {});

Chat.belongsToMany(User, {through: UserChat });
User.belongsToMany(Chat, {through: UserChat });

Chat.hasMany(Message);
Message.belongsTo(User);
Message.belongsTo(Chat);

sequelize.sync();

module.exports = {
  sequelize: sequelize,
  User: User,
  Chat: Chat,
  Message: Message
};
