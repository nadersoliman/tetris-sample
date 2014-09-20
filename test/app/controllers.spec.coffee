describe "tetris.controllers", ->

  beforeEach ->
    module 'tetris'

    module 'tetris.models'
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

  describe 'TetrisController', ->

    it 'should initialize $scope', inject (World, Canvas)->

      createController 'TetrisController as tetris'

      expect($scope.tetris.world).toEqual jasmine.any World
      expect($scope.tetris.canvas).toEqual jasmine.any Canvas
