define [], ->
  'use strict'

  PrettyPrinter = {}

  print = (spec) ->
    [
      printParams spec.params
      printColors spec.colors
      printPlayer spec.player
      printObjects spec.objects
      printSets spec.sets
      printSounds spec.sounds
      printNearRules spec.nearRules
      printLeaveRules spec.leaveRules
      printEnterRules spec.enterRules
      printUseRules spec.useRules
      printLegend spec.legend
      printLevels spec.levels
    ].join '\n'

  PrettyPrinter.print = print


  printParams = (spec) ->
    'PARAM\n\n' + spec.map(({ name, parts }) ->
      name + ' ' + parts.join ' '
    ).join '\n'

  PrettyPrinter.printParams = printParams


  printColors = (spec) ->
    'COLORS\n\n' + spec.map(({ name, red, green, blue }) ->
      "#{name} rgb #{red} #{green} #{blue}"
    ).join '\n'

  PrettyPrinter.printColors = printColors


  printPlayer = (spec) ->
    'PLAYER\n\n' + spec.map(({ name, data }) ->
      name + '\n' + data.join '\n'
    ).join '\n'

  PrettyPrinter.printPlayer = printPlayer


  printObjects = (spec) ->
    'OBJECTS\n\n' + spec.map(({ name, blocking, data }) ->
      name + (if blocking then ' blocking' else '') + '\n' + data.join '\n'
    ).join '\n'

  PrettyPrinter.printObjects = printObjects


  printSets = (spec) ->
    'SETS\n\n' +
    spec.map(({ name, elements, operator, operand1, operand2 }) ->
      name + ' = ' +
        if elements then elements.join ' '
        else "#{operand1} #{operator} #{operand2}"
    ).join '\n'

  PrettyPrinter.printSets = printSets


  printSounds = (spec) ->
    str = 'LEGEND\n\n'
    for key of spec
      str += key + ' ' + spec[key] + '\n'
    str


  printNearRules = (spec) ->
    str = 'NEARRULES\n\n'
    spec.forEach (rule) ->
      str += rule.inTerrainItemName.s + ' -> ' + rule.outTerrainItemName.s + ';'
      str += ' heal ' + rule.heal.s + ' ;'  if rule.heal
      str += ' hurt ' + rule.hurt.s + ' ;'  if rule.hurt
      str += '\n'
      return

    str


  printLeaveRules = (spec) ->
    str = 'LEAVERULES\n\n'
    spec.forEach (rule) ->
      str += rule.inTerrainItemName.s + ' -> ' + rule.outTerrainItemName.s + ';\n'
      return

    str


  printEnterRules = (spec) ->
    str = 'ENTERRULES\n\n'
    spec.forEach (rule) ->
      str += rule.inTerrainItemName.s + ' -> ' + rule.outTerrainItemName.s + ';'
      if rule.give
        giveStr = rule.give.map((item) ->
          item.quantity.s + ' ' + item.itemName.s
        ).join(' , ')
        str += ' ' + giveStr + ' ;'
      str += ' heal ' + rule.heal.s + ' ;'  if rule.heal
      str += ' hurt ' + rule.hurt.s + ' ;'  if rule.hurt
      str += ' teleport ' + rule.teleport.levelName + ' ' + rule.teleport.x + ' ' + rule.teleport.y + ';'  if rule.teleport
      str += ' message \'' + rule.message + '\' ;'  if rule.message
      str += '\n'
      return

    str


  printUseRules = (spec) ->
    str = 'USERULES\n\n'
    spec.forEach (rule) ->
      str += rule.inTerrainItemName.s + ' ' + rule.inInventoryItemName.s + ' -> ' + rule.outTerrainItemName.s + ';'
      if rule.give
        giveStr = rule.give.map((item) ->
          item.quantity.s + ' ' + item.itemName.s
        ).join(' , ')
        str += ' ' + giveStr + ' ;'
      str += ' consume ;'  if rule.consume
      str += ' heal ' + rule.heal.s + ' ;'  if rule.heal
      str += ' hurt ' + rule.hurt.s + ' ;'  if rule.hurt
      str += ' teleport ' + rule.teleport.levelName + ' ' + rule.teleport.x + ' ' + rule.teleport.y + ';'  if rule.teleport
      str += ' message \'' + rule.message + '\' ;'  if rule.message
      str += '\n'
      return

    str


  printLegend = (spec) ->
    str = 'LEGEND\n\n'
    for key of spec
      str += key + ' ' + spec[key] + '\n'
    str


  printLevels = (spec) ->
    str = 'LEVELS\n\n'
    for key of spec
      data = spec[key].map((identifier) ->
        identifier.s
      ).join('\n')
      str += key + '\n' + data + '\n\n'
    str


  PrettyPrinter
