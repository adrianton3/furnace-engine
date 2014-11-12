define [], ->
  'use strict'


  GENERATION = '0'
  SYMBOLS = '0123456789ABCDEF'.split ''
  BASE = SYMBOLS.length
  INVERSE = new Map()
  SYMBOLS.forEach (char, index) -> INVERSE.set(char, index)


  range = (min, max) ->
    delta = max - min
    random: ->
      num = Math.floor Math.random() * BASE
      num * delta / BASE
    encode: (value) ->
      index = Math.floor (value - min) / delta * BASE
      SYMBOLS[index]
    decode: (string) ->
      num = INVERSE.get string
      num * (max - min) / BASE


  options = (options) ->
    random: ->
      Math.floor Math.random() * options.length
    encode: (value) ->
      index = options.indexOf value
      SYMBOLS[index]
    decode: (string) ->
      num = INVERSE.get string
      options[num]


  randomParameters = (spec) ->
    parameters = {}

    keys = Object.keys spec
    keys.forEach (key) ->
      parameters[key] = spec[key].random()

    parameters


  encode = (generation, type, parameters, spec) ->
    string = GENERATION
    string += type

    keys = Object.keys spec
    keys.sort()

    keys.forEach (key) ->
      encodedParameter = spec[key].encode parameters[key]
      string += encodedParameter

    string

  decode = (string, spec) ->
    if string[0] != GENERATION
      throw 'Generation mismatch'

    parameters = {}

    keys = Object.keys spec
    keys.sort()

    keys.forEach (key, index) ->
      decodedParameter = spec[key].decode string[index + 2]
      parameters[key] = decodedParameter

    parameters


  applyRamp = (parameter, values, duration) ->
    parameter.setValueAtTime values[0], 0.0

    step = duration / (values.length - 1)
    for i in [1...values.length]
      parameter.linearRampToValueAtTime values[i], step * i

    return


  getEnvelope = (context, values, duration) ->
    envelope = context.createGain()
    envelope.gain.setValueAtTime values[0], 0.0

    step = duration / (values.length - 1)
    for i in [1...values.length]
      envelope.gain.linearRampToValueAtTime values[i], step * i

    envelope


  {
    range
    options
    randomParameters
    encode
    decode
    applyRamp
    getEnvelope
  }