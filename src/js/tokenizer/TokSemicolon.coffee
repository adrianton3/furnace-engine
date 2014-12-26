define [
  'tokenizer/Token'
], (
  Token
) ->
  'use strict'

  TokSemicolon = (@coords) ->
    return

  TokSemicolon:: = Object.create Token::
  TokSemicolon::constructor = TokSemicolon

  TokSemicolon::match = (that) ->
    that instanceof TokSemicolon

  TokSemicolon::toString = ->
    'Semicolon'

  TokSemicolon
