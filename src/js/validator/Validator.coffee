define [
  'validator/ValidatorError'
  'Util'
], (
  ValidatorError
  Util
) ->
  'use strict'

  Validator = {}

  Validator.validate = (spec) ->
    validateColors spec.colors
    validatePlayer spec.player, spec.colors
    validateObjects spec.objects, spec.colors
    validateSets spec.sets, spec.objects
    if spec.nearRules.length then validateNearRules spec.nearRules, spec.objects, spec.sets
    if spec.leaveRules.length then validateLeaveRules spec.leaveRules, spec.objects, spec.sets
    if spec.enterRules.length then validateEnterRules spec.enterRules, spec.objects, spec.sets, spec.levels
    if spec.useRules.length then validateUseRules spec.useRules, spec.objects, spec.sets, spec.levels
    validateLegend spec.legend, spec.objects
    validateLevels spec.levels, spec.legend
    true

  checkCollisions = (array, valueExtractor, tokenExtractor, err) ->
    plucked = array.map valueExtractor
    maybeDuplicate = Util.getDuplicate plucked
    if maybeDuplicate.value?
      throw new ValidatorError tokenExtractor(array[maybeDuplicate.index]), err

  validateColorComponent = (component, name, min, max) ->
    if isNaN component.value
      throw new ValidatorError component, "#{name} value must be a number"
    value = +component.value
    if value < min or value > max
      throw new ValidatorError component, "#{name} value must be between #{min} and #{max}"
    true

  validateColors = (colorsSpec) ->
    checkCollisions(
      colorsSpec
      (colorSpec) -> colorSpec.name.value
      (colorSpec) -> colorSpec.name
      'Color binding already declared'
    )

    colorsSpec.forEach (color) ->
      if color.name.value.length != 1
        throw new ValidatorError color.name, 'Color bindings must have one character in length'

      validateColorComponent color.red, 'Red', 0, 255
      validateColorComponent color.green, 'Green', 0, 255
      validateColorComponent color.blue, 'Blue', 0, 255

      if color.alpha
        validateColorComponent color.alpha, 'Alpha', 0, 1
    true


  Validator.validateColors = validateColors

  validateSprites = (spritesSpec, colorsSpec) ->
    checkCollisions(
      spritesSpec
      (spriteSpec) -> spriteSpec.name.value
      (spriteSpec) -> spriteSpec.name
      'Sprite binding already declared'
    )

    # check for the same size
    width = spritesSpec[0].data[0].value.length
    height = spritesSpec[0].data.length

    spritesSpec.forEach (spriteSpec) ->
      if spriteSpec.data.length != height
        throw new ValidatorError spriteSpec.data[0], 'Sprites must be of the same size'
      else
        spriteSpec.data.forEach (line, i) ->
          if line.value.length != width
            throw new ValidatorError line, 'Sprites must be of the same size'

    colorChars = {}
    colorsSpec.forEach (colorSpec) ->
      colorChars[colorSpec.name.value] = true

    # check for undefined color bindings
    spritesSpec.forEach (spriteSpec) ->
      spriteSpec.data.forEach (line) ->
        line.value.split('').forEach (char) ->
          if not colorChars[char]
            throw new ValidatorError line, 'No color is bound to character ' + char


  validatePlayer = (playerSpec, colorsSpec) ->
    validateSprites playerSpec, colorsSpec

    spriteNames = {}
    playerSpec.forEach (frameSpec) -> spriteNames[frameSpec.name.value] = true

    ['up', 'left', 'down', 'right', 'health'].forEach (name) ->
      if not spriteNames[name]
        throw new ValidatorError null, 'Missing player frame: ' + name

  Validator.validatePlayer = validatePlayer

  validateObjects = (objectsSpec, colorsSpec) ->
    validateSprites objectsSpec, colorsSpec
    #validate animation notation

  Validator.validateObjects = validateObjects

  validateSets = (setSpec, objectsSpec) ->
    checkCollisions(
      setSpec
      (setSpec) -> setSpec.name.value
      (setSpec) -> setSpec.name
      'Set binding already declared'
    )

    setSpec.forEach (binding) ->
      if not Util.isCapitalized binding.name.value
        throw new ValidatorError binding.name, 'Set bindings must be capitalized'

    objectsSet = Util.getSet (Util.pluck objectsSpec, 'name'), 'value'

    setsDefined = {}
    setSpec.forEach (binding) ->
      setsDefined[binding.name.value] = true
      if binding.operator?
        if not Util.isCapitalized binding.operand1.value
          throw new ValidatorError binding.operand1, 'Can only perform set operations on sets'
        if not Util.isCapitalized binding.operand2.value
          throw new ValidatorError binding.operand2, 'Can only perform set operations on sets'

        if not setsDefined[binding.operand1.value]
          throw new ValidatorError binding.operand1, "Set #{binding.operand1.value} was not defined"
        if not setsDefined[binding.operand2.value]
          throw new ValidatorError binding.operand2, "Set #{binding.operand2.value} was not defined"

        if binding.operand1.value == binding.name.value or binding.operand2.value == binding.name.value
          throw new ValidatorError binding.operand1, 'Cannot reference a set in its own definition'
      else
        binding.elements.forEach (element) ->
          if Util.isCapitalized element.value
            throw new ValidatorError element, 'Elements of an enumeration must be objects'

          if not objectsSet[element.value]
            throw new ValidatorError element, "Object #{element.value} was not defined"

  Validator.validateSets = validateSets


  validateInTerrainItem = (inTerrainItemName, objectsSet, setsSet) ->
    if Util.isCapitalized inTerrainItemName.value
      unless setsSet[inTerrainItemName.value]?
        throw new ValidatorError(
          inTerrainItemName
          "Set #{inTerrainItemName.value} was not defined"
        )
    else
      unless objectsSet[inTerrainItemName.value]?
        throw new ValidatorError(
          inTerrainItemName
          "Object #{inTerrainItemName.value} was not defined"
        )

  validateInInventoryItem = (inInventoryItemName, objectsSet, setsSet) ->
    if Util.isCapitalized inInventoryItemName.value
      unless setsSet[inInventoryItemName.value]?
        throw new ValidatorError(
          inInventoryItemName
          "Set #{inInventoryItemName.value} was not defined"
        )
    else
      unless objectsSet[inInventoryItemName.value]?
        throw new ValidatorError(
          inInventoryItemName
          "Object #{inInventoryItemName.value} was not defined"
        )

  validateOutTerrainItem = (outTerrainItemName, objectsSet, extrasSet) ->
    return if extrasSet[outTerrainItemName.value]

    if Util.isCapitalized outTerrainItemName.value
      throw new ValidatorError(
        outTerrainItemName
        "Sets are not allowed in the left hand side of rules"
      )

    unless objectsSet[outTerrainItemName.value]? or outTerrainItemName.value == '_terrain'
      throw new ValidatorError(
        outTerrainItemName
        "Object #{outTerrainItemName.value} was not defined"
      )

  validateGive = (giveSpec, objectsSet, extrasSet) ->
    giveSpec.forEach (entry) ->
      if isNaN entry.quantity.value
        throw new ValidatorError(
          entry.quantity
          "Quantity must be a number"
        )

      return if extrasSet[entry.itemName.value]

      unless objectsSet[entry.itemName.value]?
        throw new ValidatorError(
          entry.itemName
          "Object #{entry.itemName.value} was not defined"
        )

  validateTeleport = (teleportSpec, levelsSet) ->
    # verify if coords are numbers
    if isNaN teleportSpec.x.value
      throw new ValidatorError(
        teleportSpec.x
        "X teleport coordinate must be a number"
      )

    if isNaN teleportSpec.y.value
      throw new ValidatorError(
        teleportSpec.y
        "Y teleport coordinate must be a number"
      )

    # verify is level exists
    unless levelsSet[teleportSpec.levelName.value]?
      throw new ValidatorError(
        teleportSpec.levelName
        "Level #{teleportSpec.levelName.value} does not exist"
      )

    # verify if coords are within level bounds
    level = levelsSet[teleportSpec.levelName.value]
    unless 0 <= +teleportSpec.x.value <= level.data[0].value.length
      throw new ValidatorError(
        teleportSpec.x
        "Teleport coordinates must be within level bounds"
      )

    unless 0 <= +teleportSpec.y.value <= level.data.length
      throw new ValidatorError(
        teleportSpec.y
        "Teleport coordinates must be within level bounds"
      )

  validateHeal = (healSpec) ->
    if isNaN healSpec.value
      throw new ValidatorError(
        healSpec
        "Heal quantity must be a number"
      )

  validateHurt = (hurtSpec) ->
    if isNaN hurtSpec.value
      throw new ValidatorError(
        hurtSpec
        "Hurt quantity must be a number"
      )

  validateNearRules = (rulesSpec, objectsSpec, setsSpec) ->
    objectsSet = Util.getSet objectsSpec.map (entry) -> entry.name.value
    setsSet = Util.getSet setsSpec.map (entry) -> entry.name.value
    extrasSet = _terrain: true

    rulesSpec.forEach (rule) ->
      validateInTerrainItem rule.inTerrainItemName, objectsSet, setsSet
      validateOutTerrainItem rule.outTerrainItemName, objectsSet, extrasSet
      if rule.heal? then validateHeal rule.heal
      if rule.hurt? then validateHurt rule.hurt

  Validator.validateNearRules = validateNearRules


  validateLeaveRules = (rulesSpec, objectsSpec, setsSpec) ->
    objectsSet = Util.getSet objectsSpec.map (entry) -> entry.name.value
    setsSet = Util.getSet setsSpec.map (entry) -> entry.name.value
    extrasSet = {}

    rulesSpec.forEach (rule) ->
      validateInTerrainItem rule.inTerrainItemName, objectsSet, setsSet
      validateOutTerrainItem rule.outTerrainItemName, objectsSet, extrasSet

  Validator.validateLeaveRules = validateLeaveRules


  validateEnterRules = (rulesSpec, objectsSpec, setsSpec, levelsSpec) ->
    objectsSet = Util.getSet objectsSpec.map (entry) -> entry.name.value
    setsSet = Util.getSet setsSpec.map (entry) -> entry.name.value
    extrasSet = '_terrain': true
    levelsSet = Util.indexBy levelsSpec, (entry) -> entry.name.value

    rulesSpec.forEach (rule) ->
      validateInTerrainItem rule.inTerrainItemName, objectsSet, setsSet
      validateOutTerrainItem rule.outTerrainItemName, objectsSet, extrasSet
      if rule.give? then validateGive rule.give, objectsSet, extrasSet
      if rule.heal? then validateHeal rule.heal
      if rule.hurt? then validateHurt rule.hurt
      if rule.teleport? then validateTeleport rule.teleport, levelsSet

  Validator.validateEnterRules = validateEnterRules


  validateUseRules = (rulesSpec, objectsSpec, setsSpec, levelsSpec) ->
    objectsSet = Util.getSet objectsSpec.map (entry) -> entry.name.value
    setsSet = Util.getSet setsSpec.map (entry) -> entry.name.value
    extrasSet = _terrain: true, _inventory: true
    levelsSet = Util.indexBy levelsSpec, (entry) -> entry.name.value

    rulesSpec.forEach (rule) ->
      validateInTerrainItem rule.inTerrainItemName, objectsSet, setsSet
      validateInInventoryItem rule.inTerrainItemName, objectsSet, setsSet
      validateOutTerrainItem rule.outTerrainItemName, objectsSet, extrasSet
      if rule.give? then validateGive rule.give, objectsSet, extrasSet
      if rule.heal? then validateHeal rule.heal
      if rule.hurt? then validateHurt rule.hurt
      if rule.teleport? then validateTeleport rule.teleport, levelsSet

  Validator.validateUseRules = validateUseRules


  validateLegend = (legendSpec, objectsSpec) ->
    checkCollisions(
      legendSpec
      (binding) -> binding.name.value
      (binding) -> binding.name
      'Terrain unit binding already declared'
    )

    inverseMapping = legendSpec.map (binding) -> binding.objectName

    checkCollisions(
      inverseMapping
      (binding) -> binding.value
      (binding) -> binding
      'Object already bound'
    )

    objectsSet = Util.getSet (Util.pluck objectsSpec, 'name'), 'value'

    legendSpec.forEach (binding) ->
      if not objectsSet[binding.objectName.value]
        throw new ValidatorError binding.objectName, 'Bound object is undefined'

    legendSpec.forEach (binding) ->
      if binding.name.value.length != 1
        throw new ValidatorError binding.name, 'Terrain bindings must have one character in length'

  Validator.validateLegend = validateLegend


  validateLevels = (levelsSpec, legendSpec) ->
    checkCollisions(
      levelsSpec
      (binding) -> binding.name.value
      (binding) -> binding.name
      'Level already declared'
    )

    terrainChars = Util.getSet (Util.pluck legendSpec, 'name'), 'value'

    levelsSpec.forEach (levelsSpec) ->
      levelWidth = levelsSpec.data[0].value.length
      levelsSpec.data.forEach (line) ->
        if line.value.length != levelWidth
          throw new ValidatorError line, 'All level lines must have the same length'

        line.value.split('').forEach (char) ->
          if not terrainChars[char]
            throw new ValidatorError line, 'No terrain unit is bound to character "' + char + '"'

  Validator.validateLevels = validateLevels


  Validator
