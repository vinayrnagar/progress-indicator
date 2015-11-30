module.exports = (config) ->
  config.set
    files: [
      'lib/angular.js'
      'lib/angular-mocks.js'
      'lib/d3.js'
      'lib/jquery.js'
      'lib/jasmine-jquery.js'
      'compiled_for_tests/*.js'
      'app/**/*.html'
    ]

    frameworks: [ 'jasmine', 'sinon', 'jasmine-matchers' ]

    reporters: [ 'spec', 'coverage' ]

    preprocessors:
      'app/**/*.coffee': ['coffee']
      'app/*.coffee': ['coffee']
      'app/**/*.html': ['ng-html2js']
      'compiled_for_tests/!(*spec).js': ['coverage']

    port: 8089

    coverageReporter :
      type: 'html'
      dir: 'coverage/'

    ngHtml2JsPreprocessor:
      moduleName: 'templates'

    browsers: [ 'PhantomJS' ]
