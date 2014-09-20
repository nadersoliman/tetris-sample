'use strict'

describe "models", ->

  beforeEach ->
    module 'tetris'

    module 'tetris.models'

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
        expect(line).toEqual Array(Canvas.WIDTH+1).join(config.empty)

    it 'should return string representation of empty canvas',
      inject (Canvas, config)->

        canvas = new Canvas
        lines = []
        for x in [0..Canvas.HEIGHT-1]
          lines.push Array(Canvas.WIDTH+1).join config.empty

        expect(lines.length).toEqual config.height + 2*config.gutter
        canvasString = canvas.toString()
        expect(canvasString).toEqual lines.join '\n'

  describe 'World', ->

    it 'should have proper representation of the empty World elements',
      inject (World, config)->

        expect(World.EMPTY_LINE.length).toBe 20
        expect(World.EMPTY_LINE).toEqual "#{config.full}#{Array(config.width-1).join(config.empty)}#{config.full}"

        expect(World.BOTTOM_LINE.length).toBe 20
        expect(World.BOTTOM_LINE).toEqual '********************'

    it 'should be able to draw empty world 20x20 with 4 gutter',
      inject (World, Canvas)->

        canvas = new Canvas
        world = new World
        world.drawTo canvas

  describe 'Piece', ->

    it 'should have proper representation of a generic piece', inject (Piece)->

      piece = new Piece
      expect(piece.x).toBe null
      expect(piece.y).toBe null
      expect(piece.body).toBe null

