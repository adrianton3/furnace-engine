define [
  'tokenizer/Tokenizer'
  'parser/TokenList'
  'parser/Parser'
  'validator/Validator',
  'test/CustomMatchers'
], (
  Tokenizer
  TokenList
  Parser
  Validator
  CustomMatchers
) ->
  describe 'Validator', ->
    chop = (str) ->
      new TokenList Tokenizer.chop str

    beforeEach ->
      jasmine.addMatchers CustomMatchers

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

      it 'throws an error if the bindings are too long', ->
        expect(-> validate '''
          COLORS
          aa rgb 11 22 33
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

      it 'throws an error if the same frame has been declared twice', ->
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

          down
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

      it 'validates a correct objects spec', ->
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

      it 'throws an error if the same object was declared twice', ->
        expect(-> validate '''
          OBJECTS
          stone
          aa
          ab

          dirt
          aa
          ba

          stone
          aa
          ba

          SETS
        ''').toThrow()

    describe 'SETS', ->
      stdObjectSpec = Parser.parseObjects chop '''
          OBJECTS

          stone
          aa
          ab

          dirt
          aa
          ac

          sand
          aa
          ad

          SETS
        '''

      validate = (setsSource) ->
        setsSpec = Parser.parseSets chop setsSource
        Validator.validateSets setsSpec, stdObjectSpec

      it 'validates a correct sets spec', ->
        expect(-> validate '''
            SETS
            A = stone dirt
            B = stone sand

            NEARRULES
          ''').not.toThrow()

      it 'throws an error if bound set is not capitalized', ->
        expect(-> validate '''
            SETS
            Aa = stone dirt
            bb = stone sand

            NEARRULES
          ''').toThrow()

      it 'throws an error if bound set was already bound', ->
        expect(-> validate '''
            SETS
            A = stone dirt
            A = stone sand

            NEARRULES
          ''').toThrow()

      it 'throws an error when referencing undefined objects', ->
        expect(-> validate '''
            SETS
            A = stone dirt
            B = sand marble

            NEARRULES
          ''').toThrowWithMessage 'Object marble was not defined'

      it 'throws an error when referencing sets in enumerations', ->
        expect(-> validate '''
            SETS
            A = stone dirt
            B = sand A

            NEARRULES
          ''').toThrowWithMessage 'Elements of an enumeration must be objects'

      it 'throws an error when referencing objects as operands', ->
        expect(-> validate '''
            SETS
            A = stone dirt
            B = A and sand

            NEARRULES
          ''').toThrowWithMessage 'Can only perform set operations on sets'

      it 'throws an error when referencing undefined sets', ->
        expect(-> validate '''
            SETS
            A = stone dirt
            B = A and C
            C = sand

            NEARRULES
          ''').toThrowWithMessage 'Set C was not defined'

      it 'throws an error when defining self-referential sets', ->
        expect(-> validate '''
            SETS
            A = stone dirt
            B = A and B

            NEARRULES
          ''').toThrowWithMessage 'Cannot reference a set in its own definition'

    # near
    # leave
    # enter
    # use

    describe 'LEGEND', ->
      stdObjectSpec = Parser.parseObjects chop '''
          OBJECTS

          stone
          aa
          ab

          dirt
          aa
          ac

          sand
          aa
          ad

          SETS
        '''

      validate = (legendSource) ->
        legendSpec = Parser.parseLegend chop legendSource
        Validator.validateLegend legendSpec, stdObjectSpec

      it 'validates a correct legend spec', ->
        expect(-> validate '''
          LEGEND
          s stone
          d dirt

          LEVELS
        ''').not.toThrow()

      it 'throws an error if the same binding is used twice', ->
        expect(-> validate '''
          LEGEND
          s stone
          d dirt
          s sand

          LEVELS
        ''').toThrow()

      it 'throws an error if the same object is bound to more than one chars', ->
        expect(-> validate '''
          LEGEND
          s stone
          d dirt
          a stone

          LEVELS
        ''').toThrow()

      it 'throws an error if bindings are too long', ->
        expect(-> validate '''
          LEGEND
          st stone
          d dirt

          LEVELS
        ''').toThrow()

      it 'throws an error if the bound object is undefined', ->
        expect(-> validate '''
          LEGEND
          m marble
          d dirt

          LEVELS
        ''').toThrow()

    # levels