define [
  'tokenizer/Token'
], (
  Token
) ->
  'use strict'

  TokEnd = (@coords) ->
    return

  TokEnd:: = Object.create Token::
  TokEnd::constructor = TokEnd

  TokEnd::match = (that) ->
    that instanceof TokEnd

  TokEnd::toString = ->
    'END'

  TokEnd
