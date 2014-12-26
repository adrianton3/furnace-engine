define [
  "tokenizer/Token"
], (
  Token
) ->
  'use strict'

  TokCommSL = (@value, @coords) ->
    return

  TokCommSL:: = Object.create Token::
  TokCommSL::constructor = TokCommSL

  TokCommSL::toString = ->
    "CommSL(#{@value})"

  TokCommSL
