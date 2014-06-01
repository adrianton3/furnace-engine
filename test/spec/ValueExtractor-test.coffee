define [
  'extractor/ValueExtractor'
  'tokenizer/TokIdentifier'
], (
  ValueExtractor
  TokIdentifier
) ->
  'use strict'

  describe 'ValueExtractor', ->
    extract = ValueExtractor.extract

    it 'extracts the value of a Token', ->
      expect(extract new TokIdentifier 'asd' ).toEqual 'asd'

    it 'extracts the value of an array of Tokens', ->
      expect(extract [
        new TokIdentifier 'asd'
        new TokIdentifier 'fgh'
      ]).toEqual [
        'asd'
        'fgh'
      ]

    it 'extracts the value of a map of Tokens', ->
      expect(extract
        'a': new TokIdentifier 'asd'
        's': new TokIdentifier 'fgh'
      ).toEqual
        'a': 'asd'
        's': 'fgh'