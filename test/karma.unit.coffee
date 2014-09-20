module.exports = (karma)->
  baseKarmaFn = require './karma.base.coffee'
  baseKarmaFn karma

  karma.set
    files: karma.files.concat [
      'app/scripts/app.coffee'

      'app/**/*.coffee'
      'app/partials/**/*.html'

      # Tests
      {pattern: 'bower_components/angular-mocks/angular-mocks.js', watched:false, included:true, served:true}
      'test/**/*.spec.coffee',
    ]
    browsers: ['Chrome']
    singleRun: false
    autoWatch: true
