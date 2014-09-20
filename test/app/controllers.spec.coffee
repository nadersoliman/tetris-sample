'use strict'

describe "controllers", ->

  beforeEach ->
    module 'tetris'

    module 'tetris.controllers'

  $rootScope = null
  $scope = null
  createController = null
  $controller = null

  beforeEach inject ($injector) ->
    $rootScope = $injector.get('$rootScope')
    $scope = $rootScope.$new()
    $controller = $injector.get('$controller')

    createController = (ctrl, extras) ->
      injected = extras or {}
      _.extend injected, {'$scope' : $scope }
      $controller(ctrl, injected)

  describe '$rootScope', ->

    it 'should initialize $rootScope', ->

      createController 'FirstController'

      expect($scope.zinger).toEqual 'bringer'
