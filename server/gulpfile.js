var gulp = require('gulp');
var env = require('gulp-env');
var mocha = require('gulp-mocha');
var jshint = require('gulp-jshint');
var nodemon = require('gulp-nodemon');
var istanbul = require('gulp-istanbul');

var dbCredentials;
if (process.env.TRAVIS) {
  dbCredentials = process.env;
} else {
  dbCredentials = require('./.env.json');
}
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

gulp.task('pre-test', ['db:drop', 'db:create'], function () {
  return gulp.src(['*/**/*.js', '*.js', '!spec/**/*', '!node_modules/**/*', '!coverage/**/*', '!gulpfile.js'])
    .pipe(istanbul())
    .pipe(istanbul.hookRequire());
});

gulp.task('test', ['pre-test', 'set-env'], function () {
  return gulp.src(['spec/*.js','!spec/serverSpec.js'], {read: false})
    .pipe(mocha({reporter: 'spec'}))
    .pipe(istanbul.writeReports())
    // Enforce a coverage of at least 90%
    .pipe(istanbul.enforceThresholds({ thresholds: { global: 90 } }));
});

gulp.task('db:drop', dbTask.drop(dbCredentials.DB));

gulp.task('db:create', dbTask.create(dbCredentials.DB));

gulp.task('server-test', function () {
  return gulp.src(['spec/serverSpec.js'], {read: false})
             .pipe(mocha({reporter: 'spec'}));
});


gulp.task('server-integration-test', ['db:drop', 'db:create', 'set-env', 'server-test']);

gulp.task('start', ['set-env', 'nodemon']);

gulp.task('default', ['linter']);
