define [
  'tokenizer/Token'
], (
  Token
) ->
  'use strict'

  TokNewLine = (@coords) ->
    return

  TokNewLine:: = Object.create Token::
  TokNewLine::constructor = TokNewLine

  TokNewLine::match = (that) ->
    that instanceof TokNewLine

  TokNewLine::toString = ->
    'TokNewLine'

  TokNewLine
