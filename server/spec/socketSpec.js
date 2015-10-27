var request = require('supertest');
var sinon = require('sinon');
var auth = require('../auth');
var io = require('socket.io-client');

var url = 'http://localhost:8080'
var request = request(url);

var BradSmith = {
  email: "cantilevered.marshmallow@gmail.com",
  oauthToken: "CAABlq42VOg0BAPDz6Yw5Kc68CMXHSArMiIJfrO2U5czOZC8yFxbdUYfOaXjiX0ZB1TziPpuKjK4AmNboilObJfvijODZAYw6xsabYRB5WBxTfdddm5okDreDDk2nTvMhEZCQqHtbK3snPbyDbSTA9lzpC8g6PMOGDcR4aGEzzVTkDo0uonIzKwZCDpvsjhE2wI9BLNkHaZCPS40PCxZAo9vNjKjWSBUqrMALo5eZBoWZBkgZDZD",
  facebookId: "118724648484592"
};

var PeterParker = {
  email: "cantilevered.marshmallowed@gmail.com",
  oauthToken: "CAABlq42VOg0BAIjAi3ZAcymPFZAuutxpSlfb1ZCVzgS6xB9JAgt84EqKDrRJHZCFj4EaO6xxEA6EHC5dwV14MmGuyicJ7nfRcTNImI2xiW9eutCTOaQSsJndrLsJqkq71ewvn73ygkJ33T9TsRuKYeyYvZCbeGOSFiS12fr5XhKqOJhfOXK7MWcPEyp0FlsRVqcUzlG0fKNP40rFFfzF7hNdAOCrFWh7ZApHJag31gxQZDZD",
  facebookId: "102400480121838"
};

var client1;
var client2;

describe('', function () {

  it('should register BradSmith and authenticate a jwt token', function (done) {
    request.post('/signup')
      .set('Content-Type', 'application/json')
      .send(BradSmith)
      .expect(function (res) {
        if (typeof res.body !== 'object') {
          throw new Error("Missing response body");
        }
        if (!res.body.hasOwnProperty('token')) {
          throw new Error("No jwt token returned");
        }
        BradSmith.token = res.body.token;
        client1 = io.connect(url, {query: "token=" + BradSmith.token});
      })
      .expect(201, done);
  });

  it('should register PeterParker and authenticate a jwt token', function (done) {
    request.post('/signup')
      .set('Content-Type', 'application/json')
      .send(PeterParker)
      .expect(function (res) {
        if (typeof res.body !== 'object') {
          throw new Error("Missing response body");
        }
        if (!res.body.hasOwnProperty('token')) {
          throw new Error("No jwt token returned");
        }
        PeterParker.token = res.body.token;
        client2 = io.connect(url, {query: "token=" + PeterParker.token});
      })
      .expect(201, done);
  });
  







});
