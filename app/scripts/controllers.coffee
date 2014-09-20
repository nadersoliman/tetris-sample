angular.module('tetris.controllers', ['tetris.models'])

.controller('TetrisController', [
    'World'
    'Canvas'
    '$timeout'

    (World, Canvas, $timeout)->

      @world = new World
      @canvas = new Canvas
      @redraw = ->
        @world.drawTo @canvas
        me = @
        $timeout ->
          me.redraw()
        , 500

      @redraw()

      return @


])
