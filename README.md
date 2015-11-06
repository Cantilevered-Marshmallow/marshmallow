[![Stories in Ready](https://badge.waffle.io/Cantilevered-Marshmallow/marshmallow.svg?label=ready&title=Ready)](http://waffle.io/Cantilevered-Marshmallow/marshmallow)

[![Build Status](https://travis-ci.org/Cantilevered-Marshmallow/marshmallow.svg)](https://travis-ci.org/Cantilevered-Marshmallow/marshmallow)

# Marshmallow
  
![marshmallow](https://ieicecreamwrites.files.wordpress.com/2009/12/img_2878.jpg)

> An iOS chat app made for easy sharing of news, videos and images with your friends.

## Team

  - __Product Owner__: Daniel O'Leary
  - __Scrum Master__: Brian Leung
  - __Development Team Members__: Daniel O'Leary, Brian Leung, Brandon Borders

## Table of Contents

1. [Usage](#Usage)
    * [Client](#client)
    * [Server](#server)
2. [Requirements](#requirements)
3. [Development](#development)
    * [Client](#client-development)
        * [Installing Client Dependencies](#installing-client-dependencies)
        * [Tasks](#tasks)
    * [Server](#server-development)
        * [API Endpoints](#api-endpoints)
        * [Installing Server Dependencies](#installing-server-dependencies)
        * [Running tests](#running-server-side-tests)
4. [Team](#team)
5. [Contributing](#contributing)

## Usage

#### Client
{instructions on how to run client on local machine}
#### Server
Before attempting to start the server, make sure you have the trends package in your Go workspace. Find the repo [here](https://github.com/Cantilevered-Marshmallow/trends).

1. Go to the the server directory
2. Fill out environment variables in `docker-compose.yml.example`
3. Rename file `docker-compose.yml.example` to `docker-compose.yml`
4. Activate docker machine
4. Run `docker-compose up` 

## Requirements

- `Node 0.10.x`
- `Xcode 7`
- `Cocoapods`
- `Docker`
- `mysql`
- `Go`

## Development

### Client

#### Installing Dependencies

From within the `mobile/ios/Marshmallow` directory:

```sh
pod install
```

### Server
#### API Endpoints
-------------------------------------------------------------------------------
##### POST /signup
Description: Creates a new user
Authentication Required: No
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
Description: Authenticates a client by generating a token
Authentication Required: No
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
Description: Given a list of facebook users, filter out the ones that are not signed up with marshamallow and return the list
Authentication Required: Yes
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
Description: Creates a new chatroom for the given users. *Needs at least two users in the users array*
Authentication Required: Yes
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
Description: Retrieves list of chats the user is in
Authentication Required: Yes
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
Description: Post a message to a chat
Authentication Required: Yes
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
Description: Retrieve messages in a chat
Authentication Required: Yes
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
Description: Retrieve messages in all chats since time x (the `timestamp` param)
Authentication Required: Yes
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
Description: Retrieve trending links (from reddit)
Authentication Required: Yes
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

#### Installing Server Dependencies 
From within the `server` directory:

```sh
npm install
```

#### Running Server-Side Tests
Before running any tests:
1. Start the `mysql` server on your local machine
2. Fill out the environment variables in `env.json.example`. `JWT_SECRET` can be any string.
3. Rename the file `.env.json.example` to `.env.json`

To run unit tests, from within the `server` directory:
```sh
gulp test
```

To run server integration tests, from within `server` directory:
```sh
gulp server-integration-test
```



## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.
