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

gulp.task('dbtest', function () {
  return gulp.src(['spec/userModelSpec.js','spec/userControllerSpec.js','spec/authSpec.js'], {read: false})
             .pipe(mocha({reporter: 'spec'}));
});

gulp.task('auth-test', function () {
  return gulp.src(['spec/authSpec.js'], {read: false})
             .pipe(mocha({reporter: 'spec'}));
});



gulp.task('server-test', function () {
  return gulp.src(['spec/serverSpec.js'], {read: false})
             .pipe(mocha({reporter: 'spec'}));
});

gulp.task('test', ['set-env', 'dbtest', 'server-test']);

gulp.task('authTest', ['set-env', 'auth-test']);

gulp.task('start-server', ['set-env', 'nodemon']);

gulp.task('default', ['linter']);
