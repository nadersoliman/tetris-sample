angular.module('tetris.models', [])


.factory('Canvas', [
    'config'

    (config) ->
      class Canvas
        @WIDTH: config.width + config.gutter*2
        @HEIGHT: config.height + config.gutter*2
        @EMPTY_CHAR: '.'

        lines: null

        constructor: ->
          @clear()

        clear: ->
          @lines = []
          for x in [0..Canvas.HEIGHT-1]
            @lines.push Array(Canvas.WIDTH+1).join(config.empty)

        toString: ->
          @lines.join '\n'

      return Canvas
])

.factory('World', [
  'config'

  (config) ->
    class World
      @EMPTY_LINE: "*#{Array(config.width - 1).join(config.empty)}*"
      @BOTTOM_LINE: Array(config.width + 1).join(config.full)

      drawTo: (canvas) ->
        canvas.clear()
        for x in [0..config.height-2]
          idx = x + config.gutter
          canvas.lines[idx] = World.EMPTY_LINE
        canvas.lines[config.height - 1 + config.gutter] = World.BOTTOM_LINE

    return World
])

.factory('Piece', [

  ()->
    class Block
      x: null
      y: null
      body: null
])

.factory('SquarePiece', [
    'Piece'

    (Piece) ->
      class Block extends Piece
        body: ['****']
])

.factory('LinePiece', [
    'Piece'

    (Piece) ->
      class Block extends Piece
        #
])

.factory('LPiece', [
    'Piece'

    (Piece) ->
      class Block extends Piece
        #
])

.factory('RLPiece', [
    'Piece'

    (Piece) ->
      class Block extends Piece
        #
])

.factory('SnakePiece', [
    'Piece'

    (Piece) ->
      class Block extends Piece
        #
])