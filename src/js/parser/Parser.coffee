define [
  'tokenizer/TokEnd'
  'tokenizer/TokIdentifier'
  'tokenizer/TokStr'
  'tokenizer/TokLPar'
  'tokenizer/TokRPar'
  'tokenizer/TokKeyword'
  'tokenizer/TokCommSL'
  'tokenizer/TokCommML'
  'tokenizer/TokComma'
  'tokenizer/TokSemicolon'
  'tokenizer/TokArrow'
  'tokenizer/TokNewLine'
  'tokenizer/TokAssignment'
  'tokenizer/TokenCoords'
  'parser/TokenList'
], (
  TokEnd
  TokIdentifier
  TokStr
  TokLPar
  TokRPar
  TokKeyword
  TokCommSL
  TokCommML
  TokComma
  TokSemicolon
  TokArrow
  TokNewLine
  TokAssignment
  TokenCoords
  TokenList
) ->
  'use strict'

  ERRPREF = 'Parsing exception: '

  IDENTIFIER = new TokIdentifier()
  STR = new TokStr()
  LPAR = new TokLPar()
  RPAR = new TokRPar()
  COMMA = new TokComma()
  SEMICOLON = new TokSemicolon()
  ARROW = new TokArrow()
  NEWLINE = new TokNewLine()
  ASSIGNMENT = new TokAssignment()
  END = new TokEnd()

  Parser = {}

  parse = (tokenArray) ->
    tokens = new TokenList(tokenArray)

    params = parseParams(tokens)
    colors = parseColors(tokens)
    player = parsePlayer(tokens)
    objects = parseObjects(tokens)
    sets = parseSets(tokens)
    nearRules = parseNearRules(tokens) if tokens.match('NEARRULES')
    leaveRules = parseLeaveRules(tokens) if tokens.match('LEAVERULES')
    enterRules = parseEnterRules(tokens) if tokens.match('ENTERRULES')

    # use rules must always exist
    useRules = parseUseRules(tokens)
    legend = parseLegend(tokens)
    levels = parseLevels(tokens)

    #tokens.expect(new TokEnd(), 'RDP: expression not properly terminated');
    params: params
    colors: colors
    player: player
    objects: objects
    sets: sets
    nearRules: nearRules or []
    leaveRules: leaveRules or []
    enterRules: enterRules or []
    useRules: useRules
    legend: legend
    levels: levels

  Parser.parse = parse

  chompNL = (tokens, exMessage) ->
    tokens.expect NEWLINE, exMessage
    tokens.adv() while tokens.match NEWLINE
    return

  parseParams = (tokens) ->
    tokens.expect 'PARAM', 'Specification must start with PARAM'
    chompNL tokens, 'Expected new line after PARAM'

    params = []

    until tokens.match 'COLORS'
      tokens.expect IDENTIFIER, ''
      paramName = tokens.past()
      parts = []
      params.push { name: paramName, parts: parts }
      while tokens.match IDENTIFIER
        tokens.adv()
        parts.push tokens.past()
      chompNL tokens, 'Expect new line between param declarations'

    params

  Parser.parseParams = parseParams # for debugging/testing only

  parseColors = (tokens) ->
    tokens.expect 'COLORS', 'Expected COLORS section after PARAM'
    chompNL tokens, 'Expected new line after COLORS'

    colors = []

    until tokens.match 'PLAYER'
      tokens.expect IDENTIFIER, ''
      name = tokens.past()

      rgba = false
      if tokens.match 'rgb'
        rgba = false
      else if tokens.match 'rgba'
        rgba = true
      else
        throw 'Expected either rgb or rgba'
      tokens.adv()

      tokens.expect IDENTIFIER, 'Expected red value'
      red = tokens.past()
      tokens.expect IDENTIFIER, 'Expected green value'
      green = tokens.past()
      tokens.expect IDENTIFIER, 'Expected blue value'
      blue = tokens.past()

      if rgba
        tokens.expect IDENTIFIER, 'Expected alpha value'
        alpha = tokens.past()
        colors.push { name: name, red: red, green: green, blue: blue, alpha: alpha }
      else
        colors.push { name: name, red: red, green: green, blue: blue }

      chompNL tokens, 'Expect new line between color bindings'

    colors

  Parser.parseColors = parseColors # for debugging/testing only

  parsePlayer = (tokens) ->
    tokens.expect 'PLAYER', 'Expected PLAYER section after COLORS'
    chompNL tokens, 'Expected new line after PLAYER'

    playerFrames = []

    until tokens.match 'OBJECTS'
      tokens.expect IDENTIFIER, 'Expected at least one player frame'
      playerFrameName = tokens.past()

      data = []

      chompNL tokens, 'Expected new line after player frame binding'
      until tokens.match NEWLINE
        tokens.expect IDENTIFIER, ''
        data.push tokens.past()
        tokens.expect NEWLINE, ''

      playerFrames.push { name: playerFrameName, data: data }
      chompNL tokens, 'Expected new line after player frame declaration'

    playerFrames

  Parser.parsePlayer = parsePlayer # for debugging/testing only

  parseObjects = (tokens) ->
    tokens.expect 'OBJECTS', 'Expected OBJECTS section after PLAYER'
    chompNL tokens, 'Expected new line after OBJECTS'

    objects = []

    until tokens.match('SETS')
      tokens.expect IDENTIFIER, 'Expected at least one object'
      objectName = tokens.past()

      object = name: objectName, data: []

      if tokens.match 'blocking'
        object.blocking = true
        tokens.adv()
      chompNL tokens, 'Expected new line after object name binding'

      until tokens.match NEWLINE
        tokens.expect IDENTIFIER, ''
        object.data.push tokens.past()
        tokens.expect NEWLINE, ''

      objects.push object
      chompNL tokens, 'Expected new line after object declaration'

    objects

  Parser.parseObjects = parseObjects # for debugging/testing only

  parseSets = (tokens) ->
    tokens.expect 'SETS', 'Expected SETS after OBJECTS'
    chompNL tokens, 'Expected new line after SETS'

    sets = []

    while not tokens.match('NEARRULES') and not tokens.match('LEAVERULES') and not tokens.match('ENTERRULES') and not tokens.match('USERULES')
      tokens.expect IDENTIFIER, ''
      setName = tokens.past().value
      set = name: setName
      tokens.expect ASSIGNMENT, 'Expecting assignment operator'
      tokens.expect IDENTIFIER, 'Expecting identifier after assignment'
      firstOperandOrElement = tokens.past().value
      if tokens.match('or') or tokens.match('and') or tokens.match('minus')
        operator = tokens.next().value
        tokens.expect IDENTIFIER
        secondOperand = tokens.past().value
        set.operator = operator
        set.operand1 = firstOperandOrElement
        set.operand2 = secondOperand
      else
        elements = [firstOperandOrElement]
        elements.push tokens.next().value while tokens.match(IDENTIFIER)
        set.elements = elements
      sets.push set
      chompNL tokens, 'Expected new line after set declaration'

    sets

  Parser.parseSets = parseSets # for debugging/testing only

  parseNearRules = (tokens) ->
    tokens.expect 'NEARRULES', 'Expected NEARRULES section after SETS'
    chompNL tokens, 'Expected new line after NEARRULES'

    rules = []

    while not tokens.match('LEAVERULES') and not tokens.match('ENTERRULES') and not tokens.match('USERULES')
      rule = {}
      tokens.expect IDENTIFIER, 'Expected terrain unit'
      rule.inTerrainItemName = tokens.past()
      tokens.expect ARROW, 'Expected ->'
      tokens.expect IDENTIFIER, 'Expected out terrain unit'
      rule.outTerrainItemName = tokens.past()
      while tokens.match SEMICOLON
        tokens.adv()
        if tokens.match('heal')
          tokens.adv()
          tokens.expect IDENTIFIER, 'Expected heal quantity'
          rule.heal = tokens.past()
        else if tokens.match('hurt')
          tokens.adv()
          tokens.expect IDENTIFIER, 'Expected hurt quantity'
          rule.hurt = tokens.past()
      chompNL tokens, 'Expected new line between rules'
      rules.push rule

    rules

  Parser.parseNearRules = parseNearRules # for debugging/testing only

  parseLeaveRules = (tokens) ->
    tokens.expect 'LEAVERULES', 'Expected LEAVERULES section after SETS'
    chompNL tokens, 'Expected new line after LEAVERULES'

    rules = []

    while not tokens.match('ENTERRULES') and not tokens.match('USERULES')
      rule = {}
      tokens.expect IDENTIFIER, 'Expected terrain unit'
      rule.inTerrainItemName = tokens.past()
      tokens.expect ARROW, 'Expected ->'
      tokens.expect IDENTIFIER, 'Expected out terrain unit'
      rule.outTerrainItemName = tokens.past()
      chompNL tokens, 'Expected new line between rules'
      rules.push rule
    rules

  parseEnterRules = (tokens) ->
    tokens.expect 'ENTERRULES', 'Expected ENTERRULES section after LEAVERULES'
    chompNL tokens, 'Expected new line after ENTERRULES'

    rules = []

    until tokens.match('USERULES')
      rule = {}
      tokens.expect IDENTIFIER, 'Expected terrain unit'
      rule.inTerrainItemName = tokens.past()
      tokens.expect ARROW, 'Expected ->'
      tokens.expect IDENTIFIER, 'Expected out terrain unit'
      rule.outTerrainItemName = tokens.past()
      while tokens.match SEMICOLON
        tokens.adv()
        if tokens.match('give')
          tokens.adv()
          item = {}
          tokens.expect IDENTIFIER, 'Expected give quantity'
          item.quantity = tokens.past()
          tokens.expect IDENTIFIER, 'Expected give item name'
          item.itemName = tokens.past()
          rule.give = [item]
          while tokens.match COMMA
            tokens.adv()
            item = {}
            tokens.expect IDENTIFIER, 'Expected give quantity'
            item.quantity = tokens.past()
            tokens.expect IDENTIFIER, 'Expected give item name'
            item.itemName = tokens.past()
            rule.give.push item
        else if tokens.match('heal')
          tokens.adv()
          tokens.expect IDENTIFIER, 'Expected heal quantity'
          rule.heal = tokens.past()
        else if tokens.match('hurt')
          tokens.adv()
          tokens.expect IDENTIFIER, 'Expected hurt quantity'
          rule.hurt = tokens.past()
        else if tokens.match('teleport')
          tokens.adv()
          rule.teleport = {}
          tokens.expect IDENTIFIER, 'Expected teleport level name'
          rule.teleport.levelName = tokens.past()
          tokens.expect IDENTIFIER, 'Expected teleport position X'
          rule.teleport.x = tokens.past()
          tokens.expect IDENTIFIER, 'Expected teleport position Y'
          rule.teleport.y = tokens.past()
        else if tokens.match('message')
          tokens.adv()
          tokens.expect STR, 'Expected message'
          rule.message = tokens.past()
        else if tokens.match('checkpoint')
          tokens.adv()
          rule.checkpoint = true
      chompNL tokens, 'Expected new line between rules'
      rules.push rule
    rules

  parseUseRules = (tokens) ->
    tokens.expect 'USERULES', 'Expected USERULES section after SETS'
    chompNL tokens, 'Expected new line after USERULES'
    rules = []
    until tokens.match('LEGEND')
      rule = {}
      tokens.expect IDENTIFIER, 'Expected terrain unit'
      rule.inTerrainItemName = tokens.past()
      tokens.expect IDENTIFIER, 'Expected inventory unit'
      rule.inInventoryItemName = tokens.past()
      tokens.expect ARROW, 'Expected ->'
      tokens.expect IDENTIFIER, 'Expected out terrain unit'
      rule.outTerrainItemName = tokens.past()
      while tokens.match SEMICOLON
        tokens.adv()
        if tokens.match('give')
          tokens.adv()
          item = {}
          tokens.expect IDENTIFIER, 'Expected give quantity'
          item.quantity = tokens.past()
          tokens.expect IDENTIFIER, 'Expected give item name'
          item.itemName = tokens.past()
          rule.give = [item]
          while tokens.match COMMA
            tokens.adv()
            item = {}
            tokens.expect IDENTIFIER, 'Expected give quantity'
            item.quantity = tokens.past()
            tokens.expect IDENTIFIER, 'Expected give item name'
            item.itemName = tokens.past()
            rule.give.push item
        else if tokens.match('consume')
          tokens.adv()
          rule.consume = true
        else if tokens.match('heal')
          tokens.adv()
          tokens.expect IDENTIFIER, 'Expected heal quantity'
          rule.heal = tokens.past()
        else if tokens.match('hurt')
          tokens.adv()
          tokens.expect IDENTIFIER, 'Expected hurt quantity'
          rule.hurt = tokens.past()
        else if tokens.match('teleport')
          tokens.adv()
          rule.teleport = {}
          tokens.expect IDENTIFIER, 'Expected teleport level name'
          rule.teleport.levelName = tokens.past()
          tokens.expect IDENTIFIER, 'Expected teleport position X'
          rule.teleport.x = tokens.past()
          tokens.expect IDENTIFIER, 'Expected teleport position Y'
          rule.teleport.y = tokens.past()
        else if tokens.match('message')
          tokens.adv()
          tokens.expect STR, 'Expected message'
          rule.message = tokens.past()
      chompNL tokens, 'Expected new line between rules'
      rules.push rule
    rules

  parseLegend = (tokens) ->
    tokens.expect 'LEGEND', 'Expected LEGEND section after RULES'
    chompNL tokens, 'Expected new line after LEGEND'

    legend = {}

    until tokens.match('LEVELS')
      tokens.expect IDENTIFIER, ''
      terrainChar = tokens.past().value
      throw terrainChar + ' already declared' if legend[terrainChar]
      tokens.expect IDENTIFIER, 'Expected terrain binding'
      legend[terrainChar] = tokens.past().value
      chompNL tokens, 'Expected new line'
    legend

  parseLevels = (tokens) ->
    tokens.expect 'LEVELS', 'Expected LEVELS section after LEGEND'
    chompNL tokens, 'Expected new line after LEVELS'

    levels = {}

    until tokens.match END
      tokens.expect IDENTIFIER, 'Expected at least one level'
      levelName = tokens.past().value
      throw levelName + ' already declared' if levels[levelName]
      lines = []
      chompNL tokens, 'Expected new line after level name binding'
      until tokens.match(NEWLINE)
        tokens.expect IDENTIFIER, ''
        lines.push tokens.past()
        tokens.expect NEWLINE, ''
      levels[levelName] = lines
      chompNL tokens, 'Expected new line after level declaration'
    levels

  Parser
