define [
  'tokenizer/Token'
], (
  Token
) ->
  'use strict'

  TokCommML = (@value, @coords) ->
    return

  TokCommML:: = Object.create Token::
  TokCommML::constructor = TokCommML

  TokCommML::toString = ->
    "CommML(#{@value})"

  TokCommML
