define [
  'tokenizer/IterableString'
  'tokenizer/TokEnd'
  'tokenizer/TokIdentifier'
  'tokenizer/TokStr'
  'tokenizer/TokKeyword'
  'tokenizer/TokCommSL'
  'tokenizer/TokCommML'
  'tokenizer/TokComma'
  'tokenizer/TokSemicolon'
  'tokenizer/TokArrow'
  'tokenizer/TokAssignment'
  'tokenizer/TokNewLine'
], (
  IterableString
  TokEnd
  TokIdentifier
  TokStr
  TokKeyword
  TokCommSL
  TokCommML
  TokComma
  TokSemicolon
  TokArrow
  TokAssignment
  TokNewLine
) ->
  'use strict'

  Tokenizer = {}

  Tokenizer.chop = (s) ->
    str = new IterableString(s)
    tok = []
    while str.hasNext()
      c = str.current()
      if c is "'"
        tok.push stringSingle(str)
      else if c is '"'
        tok.push stringDouble(str)
      else if c is '/'
        n = str.next()
        if n is '/'
          commentSingle str
        else if n is '*'
          commentMulti str
        else
          tok.push alphanum(str)
      else if c is '='
        tok.push new TokAssignment(str.getCoords())
        str.advance()
      else if c is ','
        tok.push new TokComma(str.getCoords())
        str.advance()
      else if c is ';'
        tok.push new TokSemicolon(str.getCoords())
        str.advance()
      else if c is '-' and str.next() is '>'
        tok.push new TokArrow(str.getCoords())
        str.advance()
        str.advance()
      else if c > ' ' and c <= '~'
        tok.push alphanum(str)
      else if c is '\n'
        tok.push new TokNewLine(str.getCoords())
        str.advance()
      else
        whitespace str
    tok.push new TokEnd(str.getCoords())
    tok

  stringSingle = (str) ->
    coords = str.getCoords()
    accumulated = []
    str.advance()
    loop
      if str.current() is '\\'
        str.advance()
        accumulated.push escape[str.current()] if escape[str.current()]
      else if str.current() is "'"
        str.advance()
        return new TokStr(accumulated.join(''), coords)
      else if str.current() is '\n' or not str.hasNext()
        ex = new Error('String not properly ended')
        ex.coords = str.getCoords()
        throw ex
      else
        accumulated.push str.current()
      str.advance()
    return

  stringDouble = (str) ->
    coords = str.getCoords()
    accumulated = []
    str.advance()
    loop
      if str.current() is '\\'
        str.advance()
        accumulated.push escape[str.current()] if escape[str.current()]
      else if str.current() is '"'
        str.advance()
        return new TokStr(accumulated.join(''), coords)
      else if str.current() is '\n' or not str.hasNext()
        ex = new Error('String not properly ended')
        ex.coords = str.getCoords()
        throw ex
      else
        accumulated.push str.current()
      str.advance()
    return

  commentSingle = (str) ->
    str.setMarker()
    str.advance()
    str.advance()
    loop
      if str.current() is '\n' or not str.hasNext()
        #str.advance();
        return
      else
        str.advance()
    return

  commentMulti = (str) ->
    str.setMarker()
    str.advance()
    str.advance()
    loop
      if str.current() is '*' and str.next() is '/'
        str.advance()
        str.advance()
        return
      else if str.hasNext()
        str.advance()
      else
        throw 'Multiline comment not properly terminated ' + str.getCoords()
    return

  alphanum = (str) ->
    coords = str.getCoords()
    str.setMarker()
    tmp = str.current()
    while tmp > ' ' and tmp <= '~' and (tmp isnt '(' and tmp isnt ')')
      str.advance()
      tmp = str.current()
    tmp = str.getMarked()
    if keywords.indexOf(tmp) isnt -1
      new TokKeyword(tmp, coords)
    else
      new TokIdentifier(tmp, coords)

  whitespace = (str) ->
    str.advance()
    return

  escape =
    '\\': '\\'
    n: '\n'
    t: '\t'
    '\'': '\''
    '\"': '\"'

  keywords = [
    'PARAM', 'COLORS', 'PLAYER', 'OBJECTS', 'SETS', 'SOUNDS', 'NEARRULES', 'LEAVERULES', 'ENTERRULES', 'USERULES', 'LEGEND', 'LEVELS'
    'rgb', 'rgba'
    'blocking'
    'or', 'and', 'minus'
    'consume', 'give', 'heal', 'hurt', 'teleport', 'message', 'checkpoint', 'sound'
  ]
  
  Tokenizer
