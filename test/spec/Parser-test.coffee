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


    describe 'SETS', ->
      parse = (str) ->
        extract Parser.parseSets chop str

      it 'can parse no sets', ->
        expect(parse '''
            SETS
            NEARRULES
          ''').toEqual []

      it 'can parse a one element set', ->
        expect(parse '''
            SETS
            S = stone
            NEARRULES
          ''').toEqual [{
          name: 'S', elements: ['stone']
        }]

      it 'can parse a multiple element set', ->
        expect(parse '''
            SETS
            S = stone dirt sand
            NEARRULES
          ''').toEqual [{
          name: 'S', elements: ['stone', 'dirt', 'sand']
        }]

      it 'can parse a set obtained from 2 other sets', ->
        expect(parse '''
            SETS
            S = A and B
            NEARRULES
          ''').toEqual [{
          name: 'S', operator: 'and', operand1: 'A', operand2: 'B'
        }]


    describe 'SOUNDS', ->
      parse = (str) ->
        extract Parser.parseSounds chop str

      it 'can parse no terrain binding', ->
        expect(parse '''
            SOUNDS
            NEARRULES
          ''').toEqual []

      it 'can parse a terrain binding', ->
        expect(parse '''
            SOUNDS
            001234 asd
            NEARRULES
          ''').toEqual [{ soundString: '001234', id: 'asd' }]

      it 'can parse more terrain bindings', ->
        expect(parse '''
            SOUNDS
            001234 asd
            015678 fgh
            NEARRULES
          ''').toEqual [{
          soundString: '001234', id: 'asd'
        }, {
          soundString: '015678', id: 'fgh'
        }]


    describe 'NEARRULES', ->
      parse = (str) ->
        extract Parser.parseNearRules chop str

      it 'can parse no rules', ->
        expect(parse '''
            NEARRULES
            LEAVERULES
          ''').toEqual []

      it 'can parse a simple rule', ->
        expect(parse '''
            NEARRULES
            a -> b
            LEAVERULES
          ''').toEqual [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
        }]

      it 'can parse a rule with heal', ->
        expect(parse '''
            NEARRULES
            a -> b ; heal 3
            LEAVERULES
          ''').toEqual [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
          heal: '3'
        }]

      it 'can parse a rule with hurt', ->
        expect(parse '''
            NEARRULES
            a -> b ; hurt 10
            LEAVERULES
          ''').toEqual [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
          hurt: '10'
        }]


    describe 'LEAVERULES', ->
      parse = (str) ->
        extract Parser.parseLeaveRules chop str

      it 'can parse no rules', ->
        expect(parse '''
            LEAVERULES
            ENTERRULES
          ''').toEqual []

      it 'can parse a rule', ->
        expect(parse '''
            LEAVERULES
            a -> b
            ENTERRULES
          ''').toEqual [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
        }]

      it 'can parse more rules', ->
        expect(parse '''
            LEAVERULES
            a -> b
            c -> d
            ENTERRULES
          ''').toEqual [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
        }, {
          inTerrainItemName: 'c'
          outTerrainItemName: 'd'
        }]


    describe 'ENTERRULES', ->
      parse = (str) ->
        extract Parser.parseEnterRules chop str

      it 'can parse no rules', ->
        expect(parse '''
            ENTERRULES
            USERULES
          ''').toEqual []

      it 'can parse a simple rule', ->
        expect(parse '''
            ENTERRULES
            a -> b
            USERULES
          ''').toEqual [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
        }]

      it 'can parse a rule with heal', ->
        expect(parse '''
            ENTERRULES
            a -> b ; heal 3
            USERULES
          ''').toEqual [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
          heal: '3'
        }]

      it 'can parse a rule with hurt', ->
        expect(parse '''
            ENTERRULES
            a -> b ; hurt 10
            USERULES
          ''').toEqual [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
          hurt: '10'
        }]

      it 'can parse a rule with teleport', ->
        expect(parse '''
            ENTERRULES
            a -> b ; teleport second 10 20
            USERULES
          ''').toEqual [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
          teleport:
            levelName: 'second'
            x: '10'
            y: '20'
        }]

      it 'can parse a rule with message', ->
        expect(parse '''
            ENTERRULES
            a -> b ; message "ala bala portocala"
            USERULES
          ''').toEqual [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
          message: 'ala bala portocala'
        }]

      it 'can parse a rule with checkpoint', ->
        expect(parse '''
            ENTERRULES
            a -> b ; checkpoint
            USERULES
          ''').toEqual [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
          checkpoint: true
        }]

      it 'can parse a rule with one give item', ->
        expect(parse '''
            ENTERRULES
            a -> b ; give 5 stone
            USERULES
          ''').toEqual [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
          give: [{
            itemName: 'stone'
            quantity: '5'
          }]
        }]

      it 'can parse a rule with more give items', ->
        expect(parse '''
            ENTERRULES
            a -> b ; give 5 stone , 7 marble
            USERULES
          ''').toEqual [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
          give: [{
            itemName: 'stone'
            quantity: '5'
          }, {
            itemName: 'marble'
            quantity: '7'
          }]
        }]


    describe 'USERULES', ->
      parse = (str) ->
        extract Parser.parseUseRules chop str

      it 'can parse no rules', ->
        expect(parse '''
            USERULES
            LEGEND
          ''').toEqual []

      it 'can parse a simple rule', ->
        expect(parse '''
            USERULES
            a b -> c
            LEGEND
          ''').toEqual [{
          inTerrainItemName: 'a'
          inInventoryItemName: 'b'
          outTerrainItemName: 'c'
        }]

      it 'can parse a rule with heal', ->
        expect(parse '''
            USERULES
            a b -> c ; heal 3
            LEGEND
          ''').toEqual [{
          inTerrainItemName: 'a'
          inInventoryItemName: 'b'
          outTerrainItemName: 'c'
          heal: '3'
        }]

      it 'can parse a rule with hurt', ->
        expect(parse '''
            USERULES
            a b -> c ; hurt 10
            LEGEND
          ''').toEqual [{
          inTerrainItemName: 'a'
          inInventoryItemName: 'b'
          outTerrainItemName: 'c'
          hurt: '10'
        }]

      it 'can parse a rule with teleport', ->
        expect(parse '''
            USERULES
            a b -> c ; teleport second 10 20
            LEGEND
          ''').toEqual [{
          inTerrainItemName: 'a'
          inInventoryItemName: 'b'
          outTerrainItemName: 'c'
          teleport:
            levelName: 'second'
            x: '10'
            y: '20'
        }]

      it 'can parse a rule with one give item', ->
        expect(parse '''
            USERULES
            a b -> c ; give 5 stone
            LEGEND
          ''').toEqual [{
          inTerrainItemName: 'a'
          inInventoryItemName: 'b'
          outTerrainItemName: 'c'
          give: [{
            itemName: 'stone'
            quantity: '5'
          }]
        }]

      it 'can parse a rule with more give items', ->
        expect(parse '''
            USERULES
            a b -> c ; give 5 stone , 7 marble
            LEGEND
          ''').toEqual [{
          inTerrainItemName: 'a'
          inInventoryItemName: 'b'
          outTerrainItemName: 'c'
          give: [{
            itemName: 'stone'
            quantity: '5'
          }, {
            itemName: 'marble'
            quantity: '7'
          }]
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