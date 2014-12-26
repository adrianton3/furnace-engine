define ->
  'use strict'

  TokenCoords = (@line, @col) ->
    return

  TokenCoords::toString = ->
    "(line: #{@line}, col: #{@col})"

  TokenCoords
