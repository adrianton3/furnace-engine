define [
  'Util'
], (
  Util
) ->
  describe 'Util', ->
    describe 'getDuplicate', ->
      it 'finds the duplicate', ->
        expect(Util.getDuplicate ['b', 'a', 'c', 'a']).toEqual 'a'

      it 'returns null if there\'s no duplicate', ->
        expect(Util.getDuplicate ['b', 'a', 'c']).toBeNull()