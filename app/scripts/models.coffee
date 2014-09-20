angular.module('tetris.models', [])

.factory('R', [
    ()->
      (char, n)->
        ###
        repeats a character n times
        ###
        if not n
          return ''
        return Array(n+1).join(char)
])


.factory('Canvas', [
    'R'
    'config'

    (R, config) ->
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
            @lines.push R(config.empty, Canvas.WIDTH)

        toString: ->
          @lines.join '\n'

      return Canvas
])

.factory('World', [
  'R'
  'config'

  (R, config) ->
    class World
      @EMPTY_LINE: R(config.empty, config.gutter) + config.full +
        R(config.empty, config.width-2) + config.full +
        R(config.empty, config.gutter)

      @BOTTOM_LINE: R(config.empty, config.gutter) + config.full +
        R(config.full, config.width-2) + config.full +
        R(config.empty, config.gutter)

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