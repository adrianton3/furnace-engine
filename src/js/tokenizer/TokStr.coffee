define [
  'tokenizer/Token'
], (
  Token
) ->
  'use strict'

  TokStr = (@value, @coords) ->
    return

  TokStr:: = Object.create Token::
  TokStr::constructor = TokStr

  TokStr::match = (that) ->
    that instanceof TokStr

  TokStr::toString = ->
    "Str(#{@value})"

  TokStr
