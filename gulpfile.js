var gulp = require('gulp');
var jshint = require('gulp-jshint');

gulp.task('linter', function() {
  return gulp.src([/* files to lint */])
             .pipe(jshint())
             .pipe(jshint.reporter('default'))
             .pipe(jshint.reporter('fail'));
});


gulp.task('default', ['linter']);
