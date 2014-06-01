define [
  'tokenizer/Tokenizer'
  'tokenizer/TokEnd'
  'tokenizer/TokIdentifier'
  'tokenizer/TokStr'
  'tokenizer/TokLPar'
  'tokenizer/TokRPar'
  'tokenizer/TokKeyword'
  'tokenizer/TokCommSL'
  'tokenizer/TokCommML'
  'tokenizer/TokComma'
  'tokenizer/TokSemicolon'
  'tokenizer/TokArrow'
  'tokenizer/TokAssignment'
  'tokenizer/TokNewLine'
  'tokenizer/TokenCoords'
], (
  Tokenizer
  TokEnd
  TokIdentifier
  TokStr
  TokLPar
  TokRPar
  TokKeyword
  TokCommSL
  TokCommML
  TokComma
  TokSemicolon
  TokArrow
  TokAssignment
  TokNewLine
  TokenCoords
) ->
  'use strict'

  describe 'Tokenizer', ->
    chop = Tokenizer.chop

    it 'can tokenize nothing', ->
      expect(chop '').toEqual [
        new TokEnd new TokenCoords 1, 1
      ]

    it 'can tokenize an alphanumeric', ->
      expect(chop 'asd').toEqual [
        new TokIdentifier('asd', new TokenCoords 1, 1)
        new TokEnd new TokenCoords 1, 4
      ]

    it 'can tokenize a keyword', ->
      expect(chop 'PARAM').toEqual [
        new TokKeyword('PARAM', new TokenCoords 1, 1)
        new TokEnd new TokenCoords 1, 6
      ]

    it 'can ignore whitespace', ->
      expect(chop '   \t \t\t').toEqual [
        new TokEnd new TokenCoords 1, 8
      ]

    describe 'comments', ->
      it 'can ignore single line comments', ->
        expect(chop '//PARAM').toEqual [
          new TokEnd new TokenCoords 1, 8
        ]

      it 'can ignore multi line comments', ->
        expect(chop '/*PARAM*/').toEqual [
          new TokEnd new TokenCoords 1, 10
        ]

    describe 'strings', ->
      describe 'single-quoted', ->
        it 'can tokenize an empty single-quoted string', ->
          expect(chop "''").toEqual [
            new TokStr('', new TokenCoords 1, 1)
            new TokEnd new TokenCoords 1, 3
          ]

        it 'can tokenize a single-quoted string', ->
          expect(chop "'asd'").toEqual [
            new TokStr('asd', new TokenCoords 1, 1)
            new TokEnd new TokenCoords 1, 6
          ]

      describe 'double-quoted', ->
        it 'can tokenize an empty single-quoted string', ->
          expect(chop '""').toEqual [
            new TokStr('', new TokenCoords 1, 1)
            new TokEnd new TokenCoords 1, 3
          ]

        it 'can tokenize a double-quoted string', ->
          expect(chop '"asd"').toEqual [
            new TokStr('asd', new TokenCoords 1, 1)
            new TokEnd new TokenCoords 1, 6
          ]