var gulp = require('gulp');
var env = require('gulp-env');
var mocha = require('gulp-mocha');
var jshint = require('gulp-jshint');
var nodemon = require('gulp-nodemon');


gulp.task('linter', function() {
  return gulp.src(['db/*.js', 'user/*.js'])
             .pipe(jshint())
             .pipe(jshint.reporter('default'))
             .pipe(jshint.reporter('fail'));
});

gulp.task('nodemon', function () {
  nodemon({
    script: 'server.js'
  });
});

gulp.task('set-env', function () {
  if(!process.env.TRAVIS){
    env({
      file: '.env.json'
    });
  }
});

gulp.task('user-test', function () {
  return gulp.src(['spec/userModelSpec.js','spec/userControllerSpec.js','spec/authSpec.js'], {read: false})
             .pipe(mocha({reporter: 'spec'}));
});

gulp.task('controller-test', function () {
  return gulp.src(['spec/userControllerSpec.js'], {read: false})
             .pipe(mocha({reporter: 'spec'}));
});

gulp.task('server-test', function () {
  return gulp.src(['spec/serverSpec.js'], {read: false})
             .pipe(mocha({reporter: 'spec'}));
});

<<<<<<< f7aa5ea4deed75ce0dc149690e09199bf8c31856
gulp.task('test', ['set-env', 'user-test', 'server-test']);
=======
gulp.task('test', ['set-env', 'db:drop', 'db:create', 'dbtest', 'server-test']);
>>>>>>> Fix tests in serverSpec.

gulp.task('start', ['set-env', 'nodemon']);

gulp.task('default', ['linter']);
