define [
  'import-export/FromPng'
  'import-export/ToPng'
], (
  FromPng
  ToPng
) ->
  'use strict'

  describe 'ToPng o FromPng', ->
    it 'arrives to the initial text', (done) ->
      text = 'a"z 12\n\t{!'
      image = ToPng.encode text
      FromPng.decode image.toDataURL(), (backText) ->
        expect(backText).toEqual text
        done()