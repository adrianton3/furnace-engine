define [
  'tokenizer/Token'
], (
  Token
) ->
  'use strict'

  TokKeyword = (@value, @coords) ->
    return

  TokKeyword:: = Object.create Token::
  TokKeyword::constructor = TokKeyword

  TokKeyword::match = (that) ->
    that == @value

  TokKeyword::toString = ->
    "Keyword(#{@value})"

  TokKeyword
