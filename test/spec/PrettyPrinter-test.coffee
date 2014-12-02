define [
  'prettyprinter/PrettyPrinter'
], (
  PrettyPrinter
) ->
  'use strict'

  describe 'PrettyPrinter', ->
    describe 'printParams', ->
      it 'serializes parameters', ->
        valueTree = [{ name: 'asd', parts: ['fgh', 'jkl'] }]
        serialized = PrettyPrinter.printParams valueTree
        expect serialized
        .toEqual '''
          PARAM

          asd fgh jkl
        '''

    describe 'printColors', ->
      it 'serializes colors', ->
        valueTree = [{
          name: 'a', red: '11', green: '22', blue: '33'
        }, {
          name: 'b', red: '44', green: '55', blue: '66'
        }]
        serialized = PrettyPrinter.printColors valueTree
        expect serialized
        .toEqual '''
          COLORS

          a rgb 11 22 33
          b rgb 44 55 66
        '''

    describe 'printPlayer', ->
      it 'serializes player sprites', ->
        valueTree = [{ name: 'a', data: ['123', '312', '321']}]
        serialized = PrettyPrinter.printPlayer valueTree
        expect serialized
        .toEqual '''
            PLAYER

            a
            123
            312
            321
          '''

    describe 'printObjects', ->
      it 'serializes object sprites', ->
        valueTree = [{ name: 'a', blocking: true, data: ['123', '312', '321']}]
        serialized = PrettyPrinter.printObjects valueTree
        expect serialized
        .toEqual '''
            OBJECTS

            a blocking
            123
            312
            321
          '''

    describe 'printSets', ->
      it 'serializes a set defined by enumeration', ->
        valueTree = [{ name: 'S', elements: ['stone', 'dirt', 'sand'] }]
        serialized = PrettyPrinter.printSets valueTree
        expect serialized
        .toEqual '''
            SETS

            S = stone dirt sand
          '''

      it 'serializes a set defined using other sets', ->
        valueTree = [{ name: 'S', operator: 'and', operand1: 'A', operand2: 'B' }]
        serialized = PrettyPrinter.printSets valueTree
        expect serialized
        .toEqual '''
            SETS

            S = A and B
          '''

    describe 'printSounds', ->
      it 'serializes sounds', ->
        valueTree = [{
          soundString: '001234', id: 'asd'
        }, {
          soundString: '015678', id: 'fgh'
        }]
        serialized = PrettyPrinter.printSounds valueTree
        expect serialized
        .toEqual '''
            SOUNDS

            001234 asd
            015678 fgh
          '''

    describe 'printNearRules', ->
      it 'serializes near rules', ->
        valueTree = [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
        }]
        serialized = PrettyPrinter.printNearRules valueTree
        expect serialized
        .toEqual '''
            NEARRULES

            a -> b
          '''

      it 'serializes near rules with heal', ->
        valueTree = [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
          heal: '3'
        }]
        serialized = PrettyPrinter.printNearRules valueTree
        expect serialized
        .toEqual '''
            NEARRULES

            a -> b ; heal 3
          '''

      it 'serializes near rules with hurt', ->
        valueTree = [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
          hurt: '3'
        }]
        serialized = PrettyPrinter.printNearRules valueTree
        expect serialized
        .toEqual '''
            NEARRULES

            a -> b ; hurt 3
          '''

    describe 'printLeaveRules', ->
      it 'serializes leave rules', ->
        valueTree = [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
        }]
        serialized = PrettyPrinter.printLeaveRules valueTree
        expect serialized
        .toEqual '''
            LEAVERULES

            a -> b
          '''

    describe 'printEnterRules', ->
      it 'serializes enter rules with one give item', ->
        valueTree = [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
          give: [{
            itemName: 'stone'
            quantity: '5'
          }]
        }]
        serialized = PrettyPrinter.printEnterRules valueTree
        expect serialized
        .toEqual '''
            ENTERRULES

            a -> b ; give 5 stone
          '''

      it 'serializes enter rules with teleport', ->
        valueTree = [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
          teleport:
            levelName: 'second'
            x: '10'
            y: '20'
        }]
        serialized = PrettyPrinter.printEnterRules valueTree
        expect serialized
        .toEqual '''
            ENTERRULES

            a -> b ; teleport second 10 20
          '''

      it 'serializes enter rules with a checkpoint', ->
        valueTree = [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
          checkpoint: true
        }]
        serialized = PrettyPrinter.printEnterRules valueTree
        expect serialized
        .toEqual '''
            ENTERRULES

            a -> b ; checkpoint
          '''

      it 'serializes enter rules with message', ->
        valueTree = [{
          inTerrainItemName: 'a'
          outTerrainItemName: 'b'
          message: 'ala bala portocala'
        }]
        serialized = PrettyPrinter.printEnterRules valueTree
        expect serialized
        .toEqual '''
            ENTERRULES

            a -> b ; message 'ala bala portocala'
          '''

    describe 'printUseRules', ->
      it 'serializes use rules with two give item', ->
        valueTree = [{
          inTerrainItemName: 'a'
          inInventoryItemName: 'b'
          outTerrainItemName: 'c'
          give: [
            { itemName: 'stone', quantity: '5' }
            { itemName: 'sand', quantity: '11' }
          ]
        }]
        serialized = PrettyPrinter.printUseRules valueTree
        expect serialized
        .toEqual '''
            USERULES

            a b -> c ; give 5 stone , 11 sand
          '''

      it 'serializes use rules with teleport', ->
        valueTree = [{
          inTerrainItemName: 'a'
          inInventoryItemName: 'b'
          outTerrainItemName: 'c'
          teleport:
            levelName: 'second'
            x: '10'
            y: '20'
        }]
        serialized = PrettyPrinter.printUseRules valueTree
        expect serialized
        .toEqual '''
            USERULES

            a b -> c ; teleport second 10 20
          '''

      it 'serializes use rules that consumes', ->
        valueTree = [{
          inTerrainItemName: 'a'
          inInventoryItemName: 'b'
          outTerrainItemName: 'c'
          consume: true
        }]
        serialized = PrettyPrinter.printUseRules valueTree
        expect serialized
        .toEqual '''
            USERULES

            a b -> c ; consume
          '''

      it 'serializes use rules with message', ->
        valueTree = [{
          inTerrainItemName: 'a'
          inInventoryItemName: 'b'
          outTerrainItemName: 'c'
          message: 'ala bala portocala'
        }]
        serialized = PrettyPrinter.printUseRules valueTree
        expect serialized
        .toEqual '''
            USERULES

            a b -> c ; message 'ala bala portocala'
          '''

      it 'serializes use rules with sound', ->
        valueTree = [{
          inTerrainItemName: 'a'
          inInventoryItemName: 'b'
          outTerrainItemName: 'c'
          sound: 'boing'
        }]
        serialized = PrettyPrinter.printUseRules valueTree
        expect serialized
        .toEqual '''
            USERULES

            a b -> c ; sound boing
          '''