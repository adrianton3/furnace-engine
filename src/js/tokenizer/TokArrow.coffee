define [
  'tokenizer/Token'
], (
  Token
) ->
  'use strict'

  TokArrow = (@coords) ->
    return

  TokArrow:: = Object.create Token::
  TokArrow::constructor = TokArrow

  TokArrow::match = (that) ->
    that instanceof TokArrow

  TokArrow::toString = ->
    'Arrow'

  TokArrow