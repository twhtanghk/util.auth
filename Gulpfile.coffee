gulp = require 'gulp'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
coffee = require 'gulp-coffee'
gutil = require 'gulp-util'

gulp.task 'default', ['test']

gulp.task 'coffee', ->
  browserify(entries: ['./index.coffee'])
    .transform('coffeeify')
    .transform('debowerify')
    .bundle()
    .pipe(source('index.js'))
    .pipe(gulp.dest('./'))

gulp.task 'test', ['coffee'], ->
  browserify(entries: ['./test/index.coffee'])
    .transform('coffeeify')
    .transform('debowerify')
    .bundle()
    .pipe(source('index.js'))
    .pipe(gulp.dest('./test/'))