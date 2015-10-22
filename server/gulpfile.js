var gulp = require('gulp');
var env = require('gulp-env');
var mocha = require('gulp-mocha');
var jshint = require('gulp-jshint');
var nodemon = require('gulp-nodemon');
var dbCredentials = require('./.env.json');
var dbTask = require('gulp-db')({
  host: dbCredentials.DB_SERVER,
  user: dbCredentials.DB_USER,
  password: dbCredentials.DB_PASSWORD,
  dialect: 'mysql'
});


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
  return gulp.src(['spec/userControllerSpec.js','spec/authSpec.js'], {read: false})
             .pipe(mocha({reporter: 'spec'}));
});

gulp.task('chat-test', function () {
  return gulp.src(['spec/chatControllerSpec.js'], {read: false})
             .pipe(mocha({reporter: 'spec'}));
});

gulp.task('db:drop', dbTask.drop(dbCredentials.DB));

gulp.task('db:create', dbTask.create(dbCredentials.DB));

// gulp.task('db:drop', function (cb) {
//   dbTask.drop(dbCredentials.DB);
//   cb();
// });

// gulp.task('db:create', ['db:drop'], function (cb) {
//   dbTask.create(dbCredentials.DB);
//   cb();
// });

gulp.task('server-test', function () {
  return gulp.src(['spec/serverSpec.js'], {read: false})
             .pipe(mocha({reporter: 'spec'}));
});


gulp.task('server-integration-test', ['db:drop', 'db:create', 'set-env', 'server-test']);

gulp.task('local-test', ['set-env', 'chat-test']);

gulp.task('start', ['set-env', 'nodemon']);

gulp.task('default', ['linter']);
