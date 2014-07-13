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
    validateNearRules spec.nearRules, spec.sets, spec.objects
    validateLeaveRules spec.leaveRules, spec.sets, spec.objects
    validateEnterRules spec.enterRules, spec.sets, spec.objects
    validateUseRules spec.useRules, spec.sets, spec.objects
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
      firstChar = binding.name.value[0]
      if firstChar < 'A' or firstChar > 'Z'
        throw new ValidatorError binding.name, 'Set bindings must be capitalized'

    # check for referencing  undefined objects or sets
    # check for misuse of sets and elements

  Validator.validateSets = validateSets

  validateNearRules = (rulesSpec, setSpec, objectsSpec) ->
    # check for referencing undefined objects or sets

  Validator.validateNearRules = validateNearRules

  validateLeaveRules = (rulesSpec, setSpec, objectsSpec) ->
    # check for referencing undefined objects or sets

  Validator.validateLeaveRules = validateLeaveRules

  validateEnterRules = (rulesSpec, setSpec, objectsSpec) ->
    # check for referencing undefined objects or sets

  Validator.validateEnterRules = validateEnterRules

  validateUseRules = (rulesSpec, setSpec, objectsSpec) ->
    # check for referencing undefined objects or sets

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
    # check for non-rectangular levels

  Validator.validateLevels = validateLevels

  Validator
