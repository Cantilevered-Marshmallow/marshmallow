var gulp = require('gulp');
var env = require('gulp-env');
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

gulp.task('default', ['linter', 'set-env']);
