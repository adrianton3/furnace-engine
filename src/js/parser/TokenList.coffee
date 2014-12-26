define [
  'ParserError'
], (
  ParserError
) ->
  'use strict'

  TokenList = (token) ->
    @token = token
    @pointer = 0
    return

  TokenList::match = (token) ->
    @token[@pointer].match token

  TokenList::expect = (token, exMessage) ->
    if @match token
      @adv()
    else
      throw new ParserError(
        exMessage
        @cur().coords.line
        @cur().coords.col
      )
    return

  TokenList::adv = ->
    if @pointer >= @token.length
      throw new Error 'TokenList: You\'ve not enough tokens!'
    @pointer++
    return

  TokenList::next = ->
    @adv()
    @token[@pointer - 1]

  TokenList::cur = ->
    @token[@pointer]

  TokenList::past = ->
    @token[@pointer - 1]

  TokenList
