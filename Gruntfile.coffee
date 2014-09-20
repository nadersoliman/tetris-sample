config =
  tmpDir: './.tmp'
  appDir: './app'
  buildDir: './dist'
  reloadPort: 35729
  servePort: 3333

lrSnippet = require('connect-livereload')({ port: config.reloadPort })
mountFolder = (connect, dir) ->
  return connect.static(require('path').resolve(dir))

module.exports = (grunt)->
  #load all grunt tasks
  require('matchdep').filter('grunt-*').forEach(grunt.loadNpmTasks)
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks)

  gruntConfig =
    config: config
    watch:
      coffee:
        files: ['<%= config.appDir %>/scripts/**/*.coffee']
        tasks: ['coffee:compile', 'index:local']
      livereload:
        options:
          livereload: config.reloadPort
        files: ['<%= config.appDir %>/**/*']
      html2js:
        files: ['<%= config.appDir %>/partials/**/*.html']
        tasks: ['html2js:compile', 'index:local']
      less:
        files: ['<%= config.appDir %>/styles/**/*.less']
        tasks: ['less:compile']
      index_local:
        files: ['<%= config.appDir %>/index.html',
                'vendor.config.coffee']
        tasks: ['index:server']

    coffee:
      compile:
        options:
          bare: false
          sourceMap: true
        files: [
          expand: true,
          cwd: '<%= config.appDir %>/scripts'
          src: ['**/*.coffee']
          dest: '<%= config.tmpDir %>/js'
          ext: '.js'
        ]

    html2js:
      options:
        module: 'app.templates'
        base: '<%= config.appDir %>/partials'
      compile:
        src: ['<%= config.appDir %>/partials/**/*.html'],
        dest: '<%= config.tmpDir %>/js/partials.html.js'

    less:
      compile:
        files: [
          expand: true,
          cwd: '<%= config.appDir %>/styles'
          src: ['*.less']
          dest: '<%= config.tmpDir %>/css'
          ext: '.css'
        ]

    copy:
      compile:
        files: []
      build:
        files: [
          src: '<%= config.tmpDir %>/index.html'
          dest: '<%= config.buildDir %>/index.html'
        ]

    useminPrepare:
      html: ['<%= config.buildDir %>/index.html']
      options:
        dest: '<%= config.buildDir %>'
        staging: '<%= config.buildDir %>/'

    usemin:
      html: '<%= config.buildDir %>/index.html'

    uglify:
      generated:
        options:
          sourceMap: true
          compress:
            screw_ie8 : true
          mangle:
            screw_ie8 : true

    filerev:
      source:
        files: [
          src: [
            '<%= config.buildDir %>/js/*.js'
            '<%= config.buildDir %>/css/*.css'
          ]
        ]

    clean:
      server:
        files: [
          dot: true,
          src: ['<%= config.tmpDir %>']
        ]
      build:
        files: [
          dot: true,
          src: ['<%= config.buildDir %>']
        ]

    connect:
      options:
        port: config.servePort,
        hostname: '127.0.0.1'
      livereload:
        options:
          middleware: (connect) ->
            return [
              lrSnippet
              mountFolder(connect, config.tmpDir)
              mountFolder(connect, '.')
            ]
    open:
      server:
        url: 'http://127.0.0.1:<%= config.servePort %>'

    concurrent:
      compile: [
        'coffee'
        'less'
        'copy:compile'
        'html2js'
      ]
      options:
        limit: 4
        logConcurrentOutput: true

    karma:
      unit:
        configFile: 'test/karma.unit.coffee'

  grunt.initConfig gruntConfig

  grunt.registerTask 'index'
  , """
    Task to build the index file out of development JS file for
    usemin/useminprepare and the server target to function properly.
    Instead of adding every file manually in the index.html for usemin, we
    collect them and write them automatically.
    It also supplies CDN and bundled files as per vendor.config.coffee
    The files will be resolved against ./.tmp where they are generated

    @target: can be one of build, server
    @usecdn: can be usecdn, valid only for local target, default ''
    """
  , (target, usecdn)->
    fs = require('fs')
    indexFileStr = fs.readFileSync "#{config.appDir}/index.html", 'utf8'
    vendorConfig = require './vendor.config.coffee'

    replaceTokenWith = (token, replacement) ->
      indexFileStr = indexFileStr.replace token, replacement

    putConvertedFiles = ->
      globule = require('globule')
      # order is very important here
      files = [
        '/js/app.js'
      ]

      if target not in ['build', 'server']
        throw Error("Unkown target:#{target}")

      # coffeescript files
      globule.find("#{config.appDir}/scripts/**/*.coffee").forEach (file)->
        newFile = file.replace("#{config.appDir}/scripts/", 'js/')
        if newFile not in files
          files.push newFile.replace('.coffee', '.js')

      files.push '/js/app.js'

      filesString = ''
      for file in files
        preamble = if file is files[0] then '' else '    '
        filesString += "#{preamble}<script src=\"#{file}\"></script>\n"

      replaceTokenWith /<!-- TAG_CONVERTED -->[^]+TAG_CONVERTED -->/g, filesString

    putVendorCDNFiles = ->
      filesString = ''
      for cdnObj in vendorConfig.cdn
        preamble = if cdnObj is vendorConfig.cdn[0] then '' else '    '
        if target is 'server' and usecdn is 'usecdn'
          cdnUrl = cdnObj.notmin
        else if target is 'server'
          cdnUrl = cdnObj.local
        else
          cdnUrl = cdnObj.external
        filesString += "#{preamble}<script src=\"#{cdnUrl}\"></script>\n"
      replaceTokenWith /<!-- TAG_CDN -->[^]+TAG_CDN -->/g, filesString

    putVendorBundledFiles = ->
      filesString = ''
      for bundled in vendorConfig.bundled
        preamble = if bundled is vendorConfig.bundled[0] then '' else '    '
        filesString += "#{preamble}<script src=\"../#{bundled}\"></script>\n"
      replaceTokenWith /<!-- TAG_BUNDLED -->[^]+TAG_BUNDLED -->/g, filesString

    putConvertedFiles()
    putVendorCDNFiles()
    putVendorBundledFiles()
    fs.writeFileSync "#{config.tmpDir}/index.html", indexFileStr

  grunt.registerTask 'server'
  , """Builds and run a development server"""
  , ()->
    grunt.task.run [
      'clean:server'
      'concurrent:compile'
      'index:server'
      'connect:livereload'
      'open:server'
      'watch'
    ]

  grunt.registerTask 'build'
  , """ Builds frontend to destination: #{config.buildDir},"""
  , ->
    grunt.task.run [
      'clean'
      'concurrent:compile'
      'index:build'
      'copy:build'
      'useminPrepare'
      'concat:generated'
      'cssmin:generated'
      'uglify:generated'
      'filerev'
      'usemin'
    ]

  grunt.registerTask 'unit'
  , """
    Runs Karma Unit Tests
    """
  , [
      'karma:unit'
    ]
