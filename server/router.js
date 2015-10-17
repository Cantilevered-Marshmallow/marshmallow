var express = require('express');
var router = express.Router();

router.use(function timeLog (req, res, next) {
  console.log('Time :', Date.now());
  next();
});

router.post('/signup', function (req, res) {

});

router.post('/login', function (req, res) {

});

module.exports = router;
