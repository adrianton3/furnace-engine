define [
  'tokenizer/Token'
], (
  Token
) ->
  'use strict'

  TokComma = (@coords) ->
    return

  TokComma:: = Object.create Token::
  TokComma::constructor = TokComma

  TokComma::match = (that) ->
    that instanceof TokComma

  TokComma::toString = ->
    'Comma'

  TokComma
