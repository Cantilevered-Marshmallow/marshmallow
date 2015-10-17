var gulp = require('gulp');
var env = require('gulp-env');
var mocha = require('gulp-mocha');
var jshint = require('gulp-jshint');

gulp.task('linter', function() {
  return gulp.src(['db/*.js', 'user/*.js'])
             .pipe(jshint())
             .pipe(jshint.reporter('default'))
             .pipe(jshint.reporter('fail'));
});

gulp.task('set-env', function () {
  if(!process.env.TRAVIS){
    env({
      file: '.env.json'
    });
  }
});

gulp.task('dbtest', function () {
  return gulp.src(['spec/userModelSpec.js','spec/userControllerSpec.js'], {read: false})
             .pipe(mocha({reporter: 'spec'}));
});

gulp.task('test', ['set-env', 'dbtest']);

gulp.task('default', ['linter', 'set-env', 'dbtest']);
