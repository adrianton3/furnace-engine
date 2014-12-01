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