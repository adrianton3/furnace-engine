define [
  'Util'
], (
  Util
) ->
  describe 'Util', ->
    describe 'getDuplicate', ->
      it 'finds the duplicate', ->
        expect(Util.getDuplicate ['b', 'a', 'c', 'a']).toEqual { value: 'a', index: 3 }

      it 'returns null if there\'s no duplicate', ->
        expect(Util.getDuplicate ['b', 'a', 'c']).toEqual { value: null, index: -1 }