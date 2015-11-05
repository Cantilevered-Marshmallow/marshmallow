var Sequelize = require('sequelize');


/* Establish connection with mysql */
var sequelize = new Sequelize(process.env.DB, process.env.DB_USER, process.env.DB_PASSWORD, {
  host: process.env.MYSQL_PORT_3306_TCP_ADDR,
  dialect: 'mysql',
  logging: false,
  port: 3306
});

/* Define user table */
var User = sequelize.define('user', {
  email: {type: Sequelize.STRING, unique: true},
  facebookId: {type: Sequelize.STRING, unique: true, primaryKey: true}
});

/* Define chat table */
var Chat = sequelize.define('chat', {});


/* Define message table */
var Message = sequelize.define('message', {
  text: Sequelize.STRING,
  youtubeVideoId: Sequelize.STRING,
  googleImageId: Sequelize.STRING
});


/* Define RedditAttachment table */
var RedditAttachment = sequelize.define('redditAttachment', {
  title: Sequelize.STRING,
  url: Sequelize.STRING,
  thumbnail: Sequelize.STRING
});


/* Define user_chat join table */
var UserChat = sequelize.define('user_chat', {});


/* Define relationship between tables */
Chat.belongsToMany(User, {through: UserChat });
User.belongsToMany(Chat, {through: UserChat });
Chat.hasMany(Message);
Message.belongsTo(User);
Message.belongsTo(Chat);
Message.belongsTo(RedditAttachment);

sequelize.sync();

module.exports = {
  sequelize: sequelize,
  User: User,
  Chat: Chat,
  Message: Message,
  RedditAttachment: RedditAttachment
};
