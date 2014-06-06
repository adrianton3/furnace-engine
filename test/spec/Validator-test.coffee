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