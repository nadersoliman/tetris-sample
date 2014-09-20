'use strict'

describe "models", ->

  beforeEach ->
    module 'tetris'

    module 'tetris.models'

  describe 'World', ->

    it 'should have proper representation of the empty World elements', inject (World)->

      expect(World.ONE_LINE.length).toBe 20
      expect(World.ONE_LINE).toEqual '*                  *'

      expect(World.BOTTOM_LINE.length).toBe 20
      expect(World.BOTTOM_LINE).toEqual '********************'


  describe 'Piece', ->

    it 'should have proper representation of a generic piece', inject (Piece)->

      piece = new Piece
      expect(piece.x).toBe null
      expect(piece.y).toBe null

