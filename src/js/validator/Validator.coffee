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
    # check for collisions
    # check for referencing undefined objects or sets

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
      (bindingSpec) -> bindingSpec.name.value
      (bindingSpec) -> bindingSpec.name
      'Terrain unit binding already declared'
    )

    inverseMapping = legendSpec.map (terrainBinding) -> terrainBinding.objectName

    checkCollisions(
      inverseMapping
      (bindingSpec) -> bindingSpec.value
      (bindingSpec) -> bindingSpec
      'Object already bound'
    )
    # check referencing undefined objects

  Validator.validateLegend = validateLegend

  validateLevels = (levelsSpec, legendSpec) ->
    # check for non-rectangular levels

  Validator.validateLevels = validateLevels

  Validator
