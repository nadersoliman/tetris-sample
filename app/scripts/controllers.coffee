angular.module('tetris.controllers', ['tetris.models'])

.controller('TetrisController', [
    'World'
    'Canvas'
    '$timeout'
    'LPiece'

    (World, Canvas, $timeout, LPiece)->

      @canvas = new Canvas
      @world = new World @canvas

      @redraw = ->
        @world.cycle()
        me = @
        $timeout ->
          me.redraw()
        , 500

      @keyDown = ($event)->
        if $event.keyCode in [65, 97]
          @world.enqueAction 'moveLeft'

        if $event.keyCode in [68, 100]
          @world.enqueAction 'moveRight'

        if $event.keyCode in [87, 119]
          @world.enqueAction 'rotateLeft'

        if $event.keyCode in [83, 115]
          @world.enqueAction 'rotateRight'

        #console.log $event

      @redraw()

      return @
])
