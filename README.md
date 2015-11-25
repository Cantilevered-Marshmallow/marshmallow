[![Stories in Ready](https://badge.waffle.io/Cantilevered-Marshmallow/marshmallow.svg?label=ready&title=Ready)](http://waffle.io/Cantilevered-Marshmallow/marshmallow)

[![Build Status](https://travis-ci.org/Cantilevered-Marshmallow/marshmallow.svg)](https://travis-ci.org/Cantilevered-Marshmallow/marshmallow)

# Marshmallow

![marshmallow](http://i.imgur.com/Ms6GvgR.png)

> An iOS chat app made for easy sharing of news, videos and images with your friends.

# Team

  - __Product Owner__: [Daniel O'Leary](https://github.com/dkoleary88)
  - __Scrum Master__: [Brian Leung](https://github.com/brianleungwh)
  - __Development Team Members__: [Daniel O'Leary](https://github.com/dkoleary88), [Brian Leung](https://github.com/brianleungwh), [Brandon Borders](https://github.com/camelCaseD)

# Table of Contents

1. [Requirements](#requirements)
2. [Usage](#Usage)
    * [Client](#client)
    * [Server](#server)
3. [Backend Development](#backend-development)
    * [API Endpoints](#api-endpoints)
    * [Backend Architecture](#backend-architecture)
    * [Database Schema](#databae-schema)
    * [Installing Server Dependencies](#installing-server-dependencies)
    * [Running Server tests](#running-server-side-tests)
4. [Contributing](#contributing)

# Requirements

- `Node 0.10.x`
- `NPM`
- `Xcode 7`
- `Cocoapods`
- `Docker`
- `MySQL`
- `Go`

# Usage

### Client

This is all done in the `mobile/ios/Marshmallow` directory:

1. Installing Dependencies
  ```sh
  pod install
  ```

2. Open `Marshmallow.xcworkspace` in Xcode

3. In Xcode open the file `keys.example.plist`, where it says `KEY_HERE` replace it with your Youtube API Key

4. Now you can click build in Xcode and start using the app in the simulator

### Server
Before attempting to start the server, make sure you have the trends package in your Go workspace. Find the repo [here](https://github.com/Cantilevered-Marshmallow/trends).

1. Go to the the server directory
2. Fill out environment variables in `docker-compose.yml.example`
3. Rename file `docker-compose.yml.example` to `docker-compose.yml`
4. Activate docker machine
4. Run `docker-compose up`


# Backend Development
### API Endpoints
-------------------------------------------------------------------------------
##### POST /signup
**Description**: Creates a new user<br />
**Authentication Required**: No
```
/* Request Body */
{
  “email”: STRING,
  “oauthToken”: STRING,
  “facebookId”: STRING
}
```
```
/* Response Body */
{
  "email": STRING,
  "facebookId": STRING
}
```
-------------------------------------------------------------------------------
##### POST /login
**Description**: Authenticates a client by generating a token<br />
**Authentication Required**: No
```
/* Request Body */
{
  “email”: STRING,
  “oauthToken”: STRING,
  “facebookId”: STRING
}
```
-------------------------------------------------------------------------------
##### POST /userlist
**Description**: Given a list of facebook users, filter out the ones that are not signed up with marshamallow and return the list<br />
**Authentication Required**: Yes
```
/* Request Body */
{
  “users”: [
    facebookIds (STRING) ...
  ]
}
```
```
/* Response Body */
{
  “users: [
    facebookIds (STRING) ...
  ]
}
```
-------------------------------------------------------------------------------
##### POST /chat
**Description**: Creates a new chatroom for the given users. *Needs at least two users in the users array*<br />
**Authentication Required**: Yes
```
/* Request Body */
{
  “users”: [
    facebookIds (STRING)
  ]
}
```
```
/* Response Body */
{
  “chatId”: STRING
}
```
-------------------------------------------------------------------------------
##### GET /chat
**Description**: Retrieves list of chats the user is in<br />
**Authentication Required**: Yes
```
/* Response Body */
{
  “chats”:[
    {
      chatId: STRING,
      users: [facebookIds, ..]
    },
    ...
  ]
}
```
-------------------------------------------------------------------------------
##### POST /chat/:id
**Description**: Post a message to a chat<br />
**Authentication Required**: Yes
```
/* Request Body */
{
  “text”: STRING,
  “youtubeVideoId”: STRING,
  “googleImageId”: STRING
}
```
-------------------------------------------------------------------------------
##### GET /chat/:id
**Description**: Retrieve messages in a chat<br />
**Authentication Required**: Yes
```
/* Response Body */
{
  “messages”: [
    {
      userFacebookId: STRING,
      chatId: STRING,
      text: STRING,
      createdAt: ISO8601 STRING,
      youtubeVideoId: STRING,
      googleImageId: STRING,
      redditAttachment: {
        title: STRING,
        url: STRING,
        thumbnail: STRING
      }
    }, ...
  ]
}
```
-------------------------------------------------------------------------------
##### GET /messages?timestamp=<ISO8601 time>
**Description**: Retrieve messages in all chats since time x (the `timestamp` param)<br />
**Authentication Required**: Yes
```
/* Response Body */
{
  “messages”: [
    {
      userFacebookId: STRING,
      chatId: STRING,
      text: STRING,
      createdAt: ISO8601 STRING,
      youtubeVideoId: STRING,
      googleImageId: STRING,
      redditAttachment: {
        title: STRING,
        url: STRING,
        thumbnail: STRING
      }
    }, ...
  ]
}
```
-------------------------------------------------------------------------------
##### GET /trends
**Description**: Retrieve trending links (from reddit)<br />
**Authentication Required**: Yes
```
/* Response Body */
{
  “links”: [
    {
      “url”: STRING,
      “thumbnail”: STRING,
      “title”: STRING
    }, ...
  ]
}
```
-------------------------------------------------------------------------------

### Backend Architecture
![backend structure diagram](http://i.imgur.com/egLb2Q2.png)

### Database Schema
![database schema](http://i.imgur.com/A2puG7v.png)

### Installing Server Dependencies
From within the `server` directory:

```
$ npm install
```

### Running Server-Side Tests
Before running any tests:<br />
1. Start the `mysql` server on your local machine<br />
2. Fill out the environment variables in `env.json.example`. `JWT_SECRET` can be any string.<br />
3. Rename the file `.env.json.example` to `.env.json`<br />

To run unit tests, from within the `server` directory:
```
$ gulp test
```

To run server integration tests, from within `server` directory:
```sh
$ gulp server-integration-test
```



## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

