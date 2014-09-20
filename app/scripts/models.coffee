angular.module('tetris.models', [])

.factory('World', [

    () ->
      class World
        @WIDTH: 20
        @HEIGHT: 20
        @ONE_LINE: "*#{Array(World.WIDTH-1).join(' ')}*"
        @BOTTOM_LINE: Array(World.WIDTH+1).join('*')

        draw: ->
          return
      return World
])

.factory('Piece', [

  ()->
    class Block
      x: null
      y: null

])

.factory('PieceBlock', [
    'Piece'

    (Piece) ->
      class Block extends Piece
        #
])