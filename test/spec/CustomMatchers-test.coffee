define [
  'test/CustomMatchers'
], (
  CustomMatchers
) ->
  describe 'CustomMatchers', ->
    beforeEach ->
      jasmine.addMatchers CustomMatchers

    describe 'toThrowWithMessage', ->
      it 'passes for the expected exception', ->
        fun = () -> throw { message: 'asd' }
        expect(fun).toThrowWithMessage 'asd'

      it 'rejects for an exception with a different message', ->
        fun = () -> throw { message: 'asd' }
        expect(fun).not.toThrowWithMessage 'fgh'

      it 'rejects for an exception with no message', ->
        fun = () -> throw { memo: 'asd' }
        expect(fun).not.toThrowWithMessage 'asd'

      it 'rejects for no exception', ->
        fun = () -> 'asd'
        expect(fun).not.toThrowWithMessage 'asd'