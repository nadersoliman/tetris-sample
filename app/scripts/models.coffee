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

        lines: null
        linesString: ''

        constructor: ->
          @clear()

        clear: ->
          @lines = []
          for x in [0..Canvas.HEIGHT-1]
            @lines.push R(config.empty, Canvas.WIDTH)

        refresh: ->
          @linesString = @lines.join '\n'

      return Canvas
])

.factory('World', [
  'R'
  'config'
  'SquarePiece'
  'LinePiece'
  'LPiece'
  'RLPiece'
  'SnakePiece'

  (R, config, SquarePiece, LinePiece, LPiece, RLPiece, SnakePiece) ->
    class World
      @EMPTY_LINE: R(config.empty, config.gutter) + config.full +
        R(config.empty, config.width-2) + config.full +
        R(config.empty, config.gutter)

      @BOTTOM_LINE: R(config.empty, config.gutter) + config.full +
        R(config.full, config.width-2) + config.full +
        R(config.empty, config.gutter)

      movingPieces: []
      restedPieces: []
      actionsQue: []

      constructor: (@canvas)->
        #

      movePieces: ->
        stillMoving = []
        for piece in @movingPieces
          moved = piece.moveDown()
          if moved
            stillMoving.push piece
          else
            @restedPieces.push piece
        @movingPieces = stillMoving
        if @movingPieces.length is 0
          @addNewPiece()

      addNewPiece: ->
        candidatesPieces = [SquarePiece, LinePiece, LPiece, RLPiece, SnakePiece]
        candidateIndex = _.random(0, candidatesPieces.length-1)
        candidate = candidatesPieces[candidateIndex]
        @movingPieces.push new candidate(@canvas)

      clear: ->
        ###
        Draws an empty world
        ###
        @canvas.clear()
        for x in [0..config.height-2]
          idx = x + config.gutter
          @canvas.lines[idx] = World.EMPTY_LINE
        @canvas.lines[config.height - 1 + config.gutter] = World.BOTTOM_LINE

      drawReseted: ->
        for piece in @restedPieces
          piece.draw @canvas

      drawMoving: ->
        for piece in @movingPieces
          piece.draw()

      enqueAction: (action)->
        @actionsQue.push action

      failed: ->
        allPixels = []
        for x in [0..config.gutter-1]
          allPixels = allPixels.concat(@canvas.lines[x].split '')
        empty = _.all allPixels, (p)-> p is config.empty
        return not empty

      cycle: ->
        @clear()
        @drawReseted()
        failed = @failed()
        while @actionsQue.length > 0
          action = @actionsQue.pop()
          #console.log 'applying action', action
          if @movingPieces.length > 0
            @movingPieces[0][action]()
        @movePieces()
        @drawMoving()
        # draw rested again, in case one piece has became rested while
        # drawing moving
        @drawReseted()
        @canvas.refresh()
        return failed

    return World
])

.factory('Piece', [
  'R'
  'config'
  'Canvas'

  (R, config, Canvas) ->
    class Piece
      x: 0
      y: 0
      ang: 0
      positions: null

      constructor: (@canvas) ->
        @x = _.random(config.gutter + 1, Canvas.WIDTH - config.gutter - 5)

      moveRight: ->
        newX = @x + 1
        if newX + 4 < Canvas.WIDTH
          if @_canMove(newX, @y, @positions[@ang])
            @x = newX
            return true
        return false

      moveLeft: ->
        newX = @x - 1
        if newX >= 0
          if @_canMove(newX, @y, @positions[@ang])
            @x = newX
            return true
        return false

      moveDown: ->
        newY = @y + 1
        if newY + 4 < Canvas.HEIGHT
          if @_canMove(@x, newY, @positions[@ang])
            @y = newY
            return true
        return false

      rotateLeft: ->
        newAng = @ang + 90
        if newAng > 270
          newAng = 0
        if @_canMove(@x, @y, @positions[newAng])
          @ang = newAng
          return true
        return false

      rotateRight: ->
        newAng = @ang - 90
        if newAng < 0
          newAng = 270
        if @_canMove(@x, @y, @positions[newAng])
          @ang = newAng
          return true
        return false

      _canMove: (newX, newY, position) ->
        for dy in [0..3]
          canvasLine = @canvas.lines[dy + newY]
          for dx in [0..3]
            if position[dy][dx] is config.full and canvasLine[dx + newX] is config.full
              return false
        return true

      draw: ->
        position = @positions[@ang]
        for dy in [0..3]
          for dx in [0..3]
            if position[dy][dx] is config.full
              canvasLine = @canvas.lines[@y + dy]
              xIndex = @x + dx
              @canvas.lines[@y + dy] = canvasLine.substr(0, xIndex) +
                position[dy][dx] + canvasLine.substr(xIndex + 1)




    return Piece
])

.factory('SquarePiece', [
  'Piece'
  'R'
  'config'

  (Piece, R, C) ->
    class SquarePiece extends Piece
      name: 'Square'

      constructor: ->
        super
        super
        box = [
          [C.empty, C.empty, C.empty, C.empty].join('')
          [C.empty, C.full, C.full, C.empty].join('')
          [C.empty, C.full, C.full, C.empty].join('')
          [C.empty, C.empty, C.empty, C.empty].join('')
        ]

        @positions =
          0: box
          90: box
          180: box
          270: box


    return SquarePiece
])

.factory('LinePiece', [
  'Piece'
  'R'
  'config'

  (Piece, R, C) ->
    class LinePiece extends Piece
      name: 'Line'

      constructor: ->
        super
        horizontal = [
          [C.empty, C.empty, C.empty, C.empty].join('')
          [C.full, C.full, C.full, C.full].join('')
          [C.empty, C.empty, C.empty, C.empty].join('')
          [C.empty, C.empty, C.empty, C.empty].join('')
        ]
        vertical = [
          [C.full, C.empty, C.empty, C.empty].join('')
          [C.full, C.empty, C.empty, C.empty].join('')
          [C.full, C.empty, C.empty, C.empty].join('')
          [C.full, C.empty, C.empty, C.empty].join('')
        ]
        @positions =
          0: horizontal
          90: vertical
          180: horizontal
          270: vertical


    return LinePiece
])

.factory('LPiece', [
  'Piece'
  'R'
  'config'

  (Piece, R, C) ->
    class LPiece extends Piece
      name: 'L Shape'

      constructor: ->
        super

        @positions =
          0: [
            [C.empty, C.full, C.empty, C.empty].join('')
            [C.empty, C.full, C.empty, C.empty].join('')
            [C.empty, C.full, C.full, C.empty].join('')
            [C.empty, C.empty, C.empty, C.empty].join('')
          ]
          90: [
            [C.empty, C.empty, C.empty, C.empty].join('')
            [C.empty, C.empty, C.full, C.empty].join('')
            [C.full, C.full, C.full, C.empty].join('')
            [C.empty, C.empty, C.empty, C.empty].join('')
          ]
          180: [
            [C.empty, C.full, C.full, C.empty].join('')
            [C.empty, C.empty, C.full, C.empty].join('')
            [C.empty, C.empty, C.full, C.empty].join('')
            [C.empty, C.empty, C.empty, C.empty].join('')
          ]
          270: [
            [C.empty, C.empty, C.empty, C.empty].join('')
            [C.empty, C.full, C.full, C.full].join('')
            [C.empty, C.full, C.empty, C.empty].join('')
            [C.empty, C.empty, C.empty, C.empty].join('')
          ]

    return LPiece
])

.factory('RLPiece', [
  'Piece'
  'R'
  'config'

  (Piece, R, C) ->
    class RLPiece extends Piece
      name: 'Reversed L Shape'

      constructor: ->
        super

        @positions =
          0: [
            [C.empty, C.empty, C.full, C.empty].join('')
            [C.empty, C.empty, C.full, C.empty].join('')
            [C.empty, C.full, C.full, C.empty].join('')
            [C.empty, C.empty, C.empty, C.empty].join('')
          ]
          90: [
            [C.empty, C.empty, C.empty, C.empty].join('')
            [C.full, C.full, C.full, C.empty].join('')
            [C.empty, C.empty, C.full, C.empty].join('')
            [C.empty, C.empty, C.empty, C.empty].join('')
          ]
          180: [
            [C.empty, C.full, C.full, C.empty].join('')
            [C.empty, C.full, C.empty, C.empty].join('')
            [C.empty, C.full, C.empty, C.empty].join('')
            [C.empty, C.empty, C.empty, C.empty].join('')
          ]
          270: [
            [C.empty, C.empty, C.empty, C.empty].join('')
            [C.empty, C.empty, C.full, C.empty].join('')
            [C.full, C.full, C.full, C.empty].join('')
            [C.empty, C.empty, C.empty, C.empty].join('')
          ]

    return RLPiece
])

.factory('SnakePiece', [
  'Piece'
  'R'
  'config'

  (Piece, R, C) ->
    class SnakePiece extends Piece
      name: 'Snake Shape'

      constructor: ->
        super

        @positions =
          0: [
            [C.empty, C.empty, C.full, C.empty].join('')
            [C.empty, C.full, C.full, C.empty].join('')
            [C.empty, C.full, C.empty, C.empty].join('')
            [C.empty, C.empty, C.empty, C.empty].join('')
          ]
          90: [
            [C.empty, C.empty, C.empty, C.empty].join('')
            [C.empty, C.full, C.full, C.empty].join('')
            [C.empty, C.empty, C.full, C.full].join('')
            [C.empty, C.empty, C.empty, C.empty].join('')
          ]
          180: [
            [C.empty, C.empty, C.full, C.empty].join('')
            [C.empty, C.full, C.full, C.empty].join('')
            [C.empty, C.full, C.empty, C.empty].join('')
            [C.empty, C.empty, C.empty, C.empty].join('')
          ]
          270: [
            [C.empty, C.empty, C.empty, C.empty].join('')
            [C.empty, C.full, C.full, C.empty].join('')
            [C.empty, C.empty, C.full, C.full].join('')
            [C.empty, C.empty, C.empty, C.empty].join('')
          ]

    return SnakePiece
])