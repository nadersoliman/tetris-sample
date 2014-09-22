angular.module('tetris.controllers', ['tetris.models'])

.factory('BaseController', [
    ()->

      class BaseController

        constructor: (@$scope) ->
          @baseMessage = 'I am the base'

      return BaseController
])

.controller('TetrisController', [
    '$scope'
    'World'
    'Canvas'
    '$timeout'
    'LPiece'
    'BaseController'

    ($scope, World, Canvas, $timeout, LPiece, BaseController)->

      class TetrisController extends BaseController

        constructor: ($scope) ->
          super($scope)
          @canvas = new Canvas
          @world = new World @canvas
          @redraw()

        redraw: ->
          failed = @world.cycle()
          if not failed
            me = @
            $timeout ->
              me.redraw()
            , 700
          else
            @message = 'Well Done, Game Over !'

        keyDown: ($event)->
          if $event.keyCode in [65, 97, 37]
            @world.enqueAction 'moveLeft'
            $event.preventDefault()

          if $event.keyCode in [68, 100, 39]
            @world.enqueAction 'moveRight'
            $event.preventDefault()

          if $event.keyCode in [87, 119, 38]
            @world.enqueAction 'rotateLeft'
            $event.preventDefault()

          if $event.keyCode in [83, 115, 40]
            @world.enqueAction 'rotateRight'
            $event.preventDefault()

          #console.log $event


      return new TetrisController($scope)
])
