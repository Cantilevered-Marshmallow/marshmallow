var request = require('request');

module.exports = {

  getTrends: function () {
    return new Promise (function (resolve, reject) {
      request('http://' + process.env.TRENDS_PORT_5555_TCP_ADDR + ':5555/trends', function (err, _, body) {
        if (err) {
          reject(err);
        }

        body = JSON.parse(body);
        var links = body.Links;
        links = links.map(function (link) {
          var newLink = {};
          for (var k in link) {
            newLink[k.toLowerCase()] = link[k];
          }
          return newLink;
        });

        resolve(links);
      });
    });
  }

};
