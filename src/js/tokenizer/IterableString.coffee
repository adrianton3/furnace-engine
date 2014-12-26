define [
  'tokenizer/TokenCoords'
], (
  TokenCoords
) ->
  'use strict'

  IterableString = (str) ->
    @str = str
    @pointer = 0
    @marker = 0
    @line = 1
    @col = 1
    return

  IterableString::advance = ->
    if @str.charAt(@pointer) == '\n'
      @line++
      @col = 1
    else
      @col++
    @pointer++
    return

  IterableString::setMarker = (offset) ->
    offset = offset ? 0
    @marker = @pointer + offset
    return

  IterableString::current = ->
    @str.charAt @pointer

  IterableString::next = ->
    @str.charAt @pointer + 1

  IterableString::hasNext = ->
    @pointer < @str.length

  IterableString::getMarked = (offset) ->
    offset = offset ? 0
    @str.substring @marker, @pointer + offset

  IterableString::getCoords = ->
    new TokenCoords @line, @col

  IterableString
