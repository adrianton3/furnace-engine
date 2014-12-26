define [
  'tokenizer/Token'
], (
  Token
) ->
  'use strict'

  TokAssignment = (@coords) ->
    return

  TokAssignment:: = Object.create Token::
  TokAssignment::constructor = TokAssignment

  TokAssignment::match = (that) ->
    that instanceof TokAssignment

  TokAssignment::toString = ->
    'Assignment'

  TokAssignment
