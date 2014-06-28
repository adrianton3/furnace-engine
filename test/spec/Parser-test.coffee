define [
  'tokenizer/Tokenizer'
  'parser/TokenList'
  'parser/Parser'
  'extractor/ValueExtractor'
], (
  Tokenizer
  TokenList
  Parser
  ValueExtractor
) ->
  'use strict'

  describe 'Parser', ->
    chop = (str) -> new TokenList Tokenizer.chop str
    extract = ValueExtractor.extract

    describe 'PARAM', ->
      parse = (str) ->
        extract Parser.parseParams chop str

      it 'can parse no parameters', ->
        expect(parse '''
            PARAM
            COLORS
          ''').toEqual []

      it 'can parse a parameter with no parts', ->
        expect(parse '''
            PARAM
            asd
            COLORS
          ''').toEqual [{ name: 'asd', parts: [] }]

      it 'can parse a parameter with a part', ->
        expect(parse '''
            PARAM
            asd fgh
            COLORS
          ''').toEqual [{ name: 'asd', parts: ['fgh'] }]

      it 'can parse a parameter with more parts', ->
        expect(parse '''
            PARAM
            asd fgh jkl
            COLORS
          ''').toEqual [{ name: 'asd', parts: ['fgh', 'jkl'] }]

      it 'can parse more parameter with more parts', ->
        expect(parse '''
            PARAM
            qwe rty uio
            asd fgh jkl
            COLORS
          ''').toEqual([{
              name: 'qwe'
              parts: ['rty', 'uio']
            }, {
              name: 'asd'
              parts: ['fgh', 'jkl']
            }])

    describe 'COLORS', ->
      parse = (str) ->
        extract Parser.parseColors chop str

      it 'can parse no color binding', ->
        expect(parse '''
            COLORS
            PLAYER
          ''').toEqual []

      it 'can parse a color binding', ->
        expect(parse '''
            COLORS
            a rgb 11 22 33
            PLAYER
          ''').toEqual [{ name: 'a', red: '11', green: '22', blue: '33' }]

      it 'can parse more color bindings', ->
        expect(parse '''
            COLORS
            a rgb 11 22 33
            b rgb 44 55 66
            PLAYER
          ''').toEqual [{
            name: 'a', red: '11', green: '22', blue: '33'
          }, {
            name: 'b', red: '44', green: '55', blue: '66'
          }]

      it 'can parse an rgba color binding', ->
        expect(parse '''
            COLORS
            a rgba 11 22 33 44
            PLAYER
          ''').toEqual [{ name: 'a', red: '11', green: '22', blue: '33', alpha: '44' }]

    describe 'PLAYER', ->
      parse = (str) ->
        extract Parser.parsePlayer chop str

      it 'can parse no sprites', ->
        expect(parse '''
            PLAYER
            OBJECTS
          ''').toEqual []

      it 'can parse a player sprite', ->
        expect(parse '''
            PLAYER
            a
            123
            312
            321

            OBJECTS
          ''').toEqual [{ name: 'a', data: ['123', '312', '321']}]

      it 'can parse more player sprites', ->
        expect(parse '''
            PLAYER
            a
            123
            312
            321

            b
            456
            645
            564

            OBJECTS
          ''').toEqual [{
            name: 'a', data: ['123', '312', '321']
          }, {
            name: 'b', data: ['456', '645', '564']
          }]

    describe 'OBJECTS', ->
      parse = (str) ->
        extract Parser.parseObjects chop str

      it 'can parse no objects', ->
        expect(parse '''
            OBJECTS
            SETS
          ''').toEqual []

      it 'can parse an object', ->
        expect(parse '''
            OBJECTS
            a
            123
            312
            321

            SETS
          ''').toEqual [{ name: 'a', data: ['123', '312', '321']}]

      it 'can parse a blocking object', ->
        expect(parse '''
            OBJECTS
            a blocking
            123
            312
            321

            SETS
          ''').toEqual [{ name: 'a', blocking: true, data: ['123', '312', '321']}]

      it 'can parse more sprites', ->
        expect(parse '''
            OBJECTS
            a blocking
            123
            312
            321

            b
            456
            645
            564

            SETS
          ''').toEqual [{
          name: 'a', blocking: true, data: ['123', '312', '321']
        }, {
          name: 'b', data: ['456', '645', '564']
        }]

    describe 'LEGEND', ->
      parse = (str) ->
        extract Parser.parseLegend chop str

      it 'can parse no terrain binding', ->
        expect(parse '''
            LEGEND
            LEVELS
          ''').toEqual []

      it 'can parse a terrain binding', ->
        expect(parse '''
            LEGEND
            a asd
            LEVELS
          ''').toEqual [{ name: 'a', objectName: 'asd' }]

      it 'can parse more terrain bindings', ->
        expect(parse '''
            LEGEND
            a asd
            b fgh
            LEVELS
          ''').toEqual [{
            name: 'a', objectName: 'asd'
          }, {
            name: 'b', objectName: 'fgh'
          }]

    describe 'LEVELS', ->
      parse = (str) ->
        extract Parser.parseLevels chop str

      it 'can parse no levels', ->
        expect(parse '''
            LEVELS

          ''').toEqual []

      it 'can parse a level', ->
        expect(parse '''
            LEVELS
            a
            123
            312
            321
          ''').toEqual [{ name: 'a', data: ['123', '312', '321']}]

      it 'can parse more levels', ->
        expect(parse '''
            LEVELS
            a
            123
            312
            321

            b
            456
            645
            564
          ''').toEqual [{
          name: 'a', data: ['123', '312', '321']
        }, {
          name: 'b', data: ['456', '645', '564']
        }]