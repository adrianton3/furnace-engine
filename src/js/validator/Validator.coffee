define [
  'validator/ValidatorError'
], (
  ValidatorError
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

  validateColorComponent = (component, name, min, max) ->
    if isNaN component.value
      throw new ValidatorError component, "#{name} value must be a number"
    value = +component.value
    if value < min or value > max
      throw new ValidatorError component, "#{name} value must be between #{min} and #{max}"
    true

  validateColors = (colorsSpec) ->
    colors = {}
    colorsSpec.forEach (color) ->
      colorName = color.name.value
      if colors[colorName]
        throw new ValidatorError color.name, 'Color binding already declared'
      colors[colorName] = true

      validateColorComponent color.red, 'Red', 0, 255
      validateColorComponent color.green, 'Green', 0, 255
      validateColorComponent color.blue, 'Blue', 0, 255

      if color.alpha
        validateColorComponent color.alpha, 'Alpha', 0, 1
    true


  Validator.validateColors = validateColors

  validatePlayer = (playerSpec, colorsSpec) ->
    true


  Validator.validatePlayer = validatePlayer

  validateObjects = (objectsSpec, colorsSpec) ->
    true


  Validator.validateObjects = validateObjects
  validateSets = (setSpec, objectsSpec) ->
    true


  Validator.validateSets = validateSets

  validateNearRules = (rulesSpec, setSpec, objectsSpec) ->
    true


  Validator.validateNearRules = validateNearRules

  validateLeaveRules = (rulesSpec, setSpec, objectsSpec) ->
    true


  Validator.validateLeaveRules = validateLeaveRules

  validateEnterRules = (rulesSpec, setSpec, objectsSpec) ->
    true


  Validator.validateEnterRules = validateEnterRules

  validateUseRules = (rulesSpec, setSpec, objectsSpec) ->
    true


  Validator.validateUseRules = validateUseRules

  validateLegend = (legendSpec, objectsSpec) ->
    true


  Validator.validateLegend = validateLegend

  validateLevels = (levelsSpec, legendSpec) ->
    true


  Validator.validateLevels = validateLevels

  Validator
