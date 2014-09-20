'use strict'

describe "app", ->

  beforeEach ->
    module 'tetris'

  $rootScope = null
  $scope = null

  beforeEach inject ($injector) ->
    $rootScope = $injector.get('$rootScope')
    $scope = $rootScope.$new()

  describe '$rootScope', ->

    it 'should initialize $rootScope', ->

      expect($scope.hello).toEqual 'world'
