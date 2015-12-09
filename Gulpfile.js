var browserify, coffee, gulp, gutil, source;

gulp = require('gulp');

browserify = require('browserify');

source = require('vinyl-source-stream');

coffee = require('gulp-coffee');

gutil = require('gulp-util');

gulp.task('default', ['test']);

gulp.task('coffee', function() {
  return gulp.src('./*.coffee').pipe(coffee({
    bare: true
  }).on('error', gutil.log)).pipe(gulp.dest('./'));
});

gulp.task('test', ['coffee'], function() {
  browserify({
    entries: ['./test/io.coffee']
  }).transform('coffeeify').transform('debowerify').bundle().pipe(source('io.js')).pipe(gulp.dest('./test/'));
  return browserify({
    entries: ['./test/rest.coffee']
  }).transform('coffeeify').transform('debowerify').bundle().pipe(source('rest.js')).pipe(gulp.dest('./test/'));
});
