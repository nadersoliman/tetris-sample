describe "models", ->

  beforeEach ->
    module 'tetris'

    module 'tetris.models'

  R = null

  beforeEach inject ($injector) ->
    R = $injector.get('R')

  describe 'repeate', ->

    it 'should repeat charcter n times', inject (R)->

      expect(R('x', 1)).toEqual 'x'
      expect(R('x', 2)).toEqual 'xx'
      expect(R('x', 3)).toEqual 'xxx'
      expect(R('x', 0)).toEqual ''
      expect(R('x')).toEqual ''

  describe 'Canvas', ->

    it 'should have proper representation of empty Canvas class',
      inject (Canvas, config)->

        expect(Canvas.WIDTH).toBe config.width + config.gutter*2
        expect(Canvas.HEIGHT).toBe config.height + config.gutter*2

    it 'should construct empty canvas', inject (Canvas, config)->

      canvas = new Canvas
      expect(canvas.lines.length).toEqual Canvas.HEIGHT
      for line in canvas.lines
        expect(line.length).toBe Canvas.WIDTH
        expect(line).toEqual R(config.empty, Canvas.WIDTH)

    it 'should return string representation of empty canvas',
      inject (Canvas, config)->

        canvas = new Canvas
        lines = []
        for x in [0..Canvas.HEIGHT-1]
          lines.push R(config.empty, Canvas.WIDTH)

        expect(lines.length).toEqual config.height + 2*config.gutter
        canvas.refresh()
        expect(canvas.linesString).toEqual lines.join '\n'

  describe 'World', ->

    it 'should have proper representation of the empty World elements',
      inject (World, config)->

        expect(World.EMPTY_LINE.length).toBe 28
        expect(World.EMPTY_LINE).toEqual '....*..................*....'

        expect(World.BOTTOM_LINE.length).toBe 28
        expect(World.BOTTOM_LINE).toEqual '....********************....'

    it 'should be able to draw empty world 20x20 with 4 gutter',
      inject (World, Canvas, config)->

        canvas = new Canvas
        world = new World canvas
        world.clear()

        lines = canvas.lines
        expect(lines.length).toEqual config.height + 2*config.gutter
        for x in [0..config.gutter-1]
          expect(lines[x]).toEqual R(config.empty, Canvas.WIDTH)
        for x in [config.gutter..world.height+config.gutter-2]
          expect(lines[x]).toEqual World.EMPTY_LINE
        expect(lines[config.height+config.gutter-1]).toEqual World.BOTTOM_LINE
        for x in [config.gutter+world.height..Canvas.height-1]
          expect(lines[x]).toEqual R(config.empty, Canvas.WIDTH)

    it 'should add new piece if moving pieces is empty', inject (World, Canvas, Piece)->

      canvas = new Canvas
      world = new World canvas

      expect(world.movingPieces).toEqual []
      world.movePieces()
      expect(world.movingPieces).toEqual [jasmine.any Piece]

    it 'should respond with fail true', inject (World, Canvas, config)->
      canvas = new Canvas
      world = new World canvas

      expect(world.failed()).toBe false

      line = canvas.lines[2]
      line = line.substr(0, 10) + config.full + line.substr(10 + 1)
      canvas.lines[2] = line

      expect(world.failed()).toBe true

  describe 'Piece', ->

    it 'should have proper representation of a generic piece', inject (Piece)->

      piece = new Piece
      expect(piece.x).toBeGreaterThan 5
      expect(piece.x).toBeLessThan 23
      expect(piece.y).toBe 0
      expect(piece.ang).toEqual jasmine.any Number
      expect(piece.positions).toBe null

    it 'should adhere to canvas while moving sideways', inject (SquarePiece, Canvas, World) ->
      canvas = new Canvas
      world = new World canvas
      world.clear()

      piece = new SquarePiece canvas
      piece.x = 0
      piece.y = 0

      moved = piece.moveLeft()
      expect(piece.x).toBe 0
      expect(moved).toBe false

      moved = piece.moveRight()
      expect(piece.x).toBe 1
      expect(moved).toBe true

      moved = piece.moveRight()
      expect(piece.x).toBe 2
      expect(moved).toBe true

      piece.x = Canvas.WIDTH - 4
      expect(piece.x).toBe 24
      moved = piece.moveRight()
      expect(piece.x).toBe 24
      expect(moved).toBe false

      moved = piece.moveLeft()
      expect(piece.x).toBe 23
      expect(moved).toBe true

      moved = piece.moveLeft()
      expect(piece.x).toBe 22
      expect(moved).toBe true

    it 'should update angle cyclically', inject (SquarePiece, Canvas, World) ->
      canvas = new Canvas
      world = new World canvas
      world.clear()

      piece = new SquarePiece canvas

      expect(piece.ang).toBe 0

      rotated = piece.rotateLeft()
      expect(piece.ang).toBe 90
      expect(rotated).toBe true

      rotated = piece.rotateLeft()
      expect(piece.ang).toBe 180
      expect(rotated).toBe true

      rotated = piece.rotateLeft()
      expect(piece.ang).toBe 270
      expect(rotated).toBe true

      rotated = piece.rotateLeft()
      expect(piece.ang).toBe 0
      expect(rotated).toBe true

      rotated = piece.rotateRight()
      expect(piece.ang).toBe 270
      expect(rotated).toBe true

      rotated = piece.rotateRight()
      expect(piece.ang).toBe 180
      expect(rotated).toBe true

      rotated = piece.rotateRight()
      expect(piece.ang).toBe 90
      expect(rotated).toBe true

      rotated = piece.rotateRight()
      expect(piece.ang).toBe 0
      expect(rotated).toBe true

    it 'should not rotate or move, for edge cases', inject (LPiece, Canvas, World) ->
      canvas = new Canvas
      world = new World canvas
      world.clear()

      piece = new LPiece canvas
      piece.x = 4
      piece.y = 4

      moved = piece.moveRight()
      expect(moved).toBe true

      moved = piece.moveLeft()
      expect(moved).toBe true

      moved = piece.moveLeft()
      expect(moved).toBe false

      moved = piece.rotateLeft()
      expect(moved).toBe false

      moved = piece.rotateRight()
      expect(moved).toBe true


    it 'should adhere to canvas while moving down', inject (SquarePiece, Canvas, World) ->
      canvas = new Canvas
      world = new World canvas
      world.clear()

      piece = new SquarePiece canvas
      piece.x = 0
      piece.y = 0

      piece.moveDown()
      expect(piece.y).toBe 1

      piece.moveDown()
      expect(piece.y).toBe 2

      piece.y = Canvas.WIDTH - 4
      expect(piece.y).toBe 24
      piece.moveDown()
      expect(piece.y).toBe(24)


    it 'should draw to canvas', inject (LPiece, Canvas, World, R, config) ->
      canvas = new Canvas
      world = new World canvas
      world.clear()

      piece = new LPiece canvas
      piece.x = 4
      piece.y = 4
      piece.draw()

      expect(canvas.lines[4].length).toEqual 28
      expect(canvas.lines[4]).toEqual '....**' + R(config.empty, 17) + '*....'
      expect(canvas.lines[5].length).toEqual 28
      expect(canvas.lines[5]).toEqual '....**' + R(config.empty, 17) + '*....'
      expect(canvas.lines[6].length).toEqual 28
      expect(canvas.lines[6]).toEqual '....***' + R(config.empty, 16) + '*....'
      expect(canvas.lines[7].length).toEqual 28
      expect(canvas.lines[7]).toEqual '....*' + R(config.empty, 18) + '*....'

      world.clear()
      piece.moveDown()
      piece.draw()
      expect(canvas.lines[5].length).toEqual 28
      expect(canvas.lines[5]).toEqual '....**' + R(config.empty, 17) + '*....'
      expect(canvas.lines[6].length).toEqual 28
      expect(canvas.lines[6]).toEqual '....**' + R(config.empty, 17) + '*....'
      expect(canvas.lines[7].length).toEqual 28
      expect(canvas.lines[7]).toEqual '....***' + R(config.empty, 16) + '*....'
      expect(canvas.lines[8].length).toEqual 28
      expect(canvas.lines[8]).toEqual '....*' + R(config.empty, 18) + '*....'



  describe 'SquarePiece', ->

    it 'should have proper representation of a squar piece', inject (SquarePiece)->

      piece = new SquarePiece
#      expect(piece.x).toBe null
#      expect(piece.y).toBe null
#      expect(piece.body).toEqual jasmine.any Array
#      expect(piece.body.length).toBe 4
#      for x in [0..3]
#        expect(piece.body[0]).toEqual jasmine.any String
#        expect(piece.body[0].length).toBe 4

