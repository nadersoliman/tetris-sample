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
        canvasString = canvas.toString()
        expect(canvasString).toEqual lines.join '\n'

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
        world = new World
        world.drawTo canvas

        lines = canvas.lines
        expect(lines.length).toEqual config.height + 2*config.gutter
        for x in [0..config.gutter-1]
          expect(lines[x]).toEqual R(config.empty, Canvas.WIDTH)
        for x in [config.gutter..world.height+config.gutter-2]
          expect(lines[x]).toEqual World.EMPTY_LINE
        expect(lines[config.height+config.gutter-1]).toEqual World.BOTTOM_LINE
        for x in [config.gutter+world.height..Canvas.height-1]
          expect(lines[x]).toEqual R(config.empty, Canvas.WIDTH)

  describe 'Piece', ->

    it 'should have proper representation of a generic piece', inject (Piece)->

      piece = new Piece
      expect(piece.x).toBe null
      expect(piece.y).toBe null
      expect(piece.body).toBe null

