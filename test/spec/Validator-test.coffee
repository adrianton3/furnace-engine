define [
  'tokenizer/Tokenizer'
  'parser/TokenList'
  'parser/Parser'
  'validator/Validator'
], (
  Tokenizer
  TokenList
  Parser
  Validator
) ->
  describe 'Validator', ->
    chop = (str) ->
      new TokenList Tokenizer.chop str

    describe 'COLOR', ->
      validate = (str) ->
        Validator.validateColors Parser.parseColors chop str

      it 'validates a correct color spec', ->
        expect(validate '''
          COLORS
          a rgb 11 22 33
          PLAYER
        ''').toBeTruthy()

      it 'throws an error if components are not numbers', ->
        expect(-> validate '''
          COLORS
          a rgb 111 2ab cde
          PLAYER
        ''').toThrow()

      it 'throws an error if the ranges are not right', ->
        expect(-> validate '''
          COLORS
          a rgb 111 222 333
          PLAYER
        ''').toThrow()

      it 'throws an error if the range for the alpha channel is not right', ->
        expect(-> validate '''
          COLORS
          a rgb 11 22 33 2
          PLAYER
        ''').toThrow()

    describe 'PLAYER', ->
      getColorsSpec = (str) -> Parser.parseColors chop str

      stdColorsSpec = getColorsSpec '''
        COLORS
        a rgb 11 22 33
        b rgb 44 55 66
        PLAYER
      '''

      validate = (str) ->
        Validator.validatePlayer (Parser.parsePlayer chop str), stdColorsSpec

      it 'validates a correct player spec', ->
        expect(-> validate '''
          PLAYER
          up
          aa
          ab

          left
          aa
          ba

          down
          aa
          aa

          right
          aa
          aa

          health
          aa
          aa

          OBJECTS
        ''').not.toThrow()

      it 'throws an error if not all the required frames are defined', ->
        expect(-> validate '''
          PLAYER
          up
          aa
          ab

          left
          aa
          ba

          OBJECTS
        ''').toThrow()

      it 'throws an error if the frames are of different sizes', ->
        expect(-> validate '''
          PLAYER
          up
          aa
          ab

          left
          aa
          baa

          down
          aa
          aa

          right
          aa
          aa

          health
          aa
          aa

          OBJECTS
        ''').toThrow()

      it 'throws an error if the frames use undefined colors', ->
        expect(-> validate '''
          PLAYER
          up
          aa
          ab

          left
          aa
          ba

          down
          aa
          ac

          right
          aa
          aa

          health
          aa
          aa

          OBJECTS
        ''').toThrow()

    describe 'OBJECTS', ->
      getColorsSpec = (str) -> Parser.parseColors chop str

      stdColorsSpec = getColorsSpec '''
        COLORS
        a rgb 11 22 33
        b rgb 44 55 66
        PLAYER
      '''

      validate = (str) ->
        Validator.validateObjects (Parser.parseObjects chop str), stdColorsSpec

      it 'validates a correct player spec', ->
        expect(-> validate '''
          OBJECTS
          stone
          aa
          ab

          dirt
          aa
          ba

          SETS
        ''').not.toThrow()

      it 'throws an error if the frames are of different sizes', ->
        expect(-> validate '''
          OBJECTS
          stone
          aa
          ab

          dirt
          aa
          baa

          SETS
        ''').toThrow()

      it 'throws an error if the frames use undefined colors', ->
        expect(-> validate '''
          OBJECTS
          stone
          aa
          ab

          dirt
          aa
          bc

          SETS
        ''').toThrow()