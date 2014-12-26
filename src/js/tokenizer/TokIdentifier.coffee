define [
  'tokenizer/Token'
], (
  Token
) ->
  'use strict'

  TokIdentifier = (@value, @coords) ->
    return

  TokIdentifier:: = Object.create Token::
  TokIdentifier::constructor = TokIdentifier

  TokIdentifier::match = (that) ->
    that instanceof TokIdentifier

  TokIdentifier::toString = ->
    "Identifier(#{@value} #{@coords})"

  TokIdentifier
