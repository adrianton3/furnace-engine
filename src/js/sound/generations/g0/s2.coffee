define [
  'sound/SoundUtil'
], (
  SoundUtil
) ->
  'use strict'


  { range, options } = SoundUtil

  generation = 0
  type = 2

  spec =
    duration: range 0.05, 0.3
    oscType: options ['square', 'sawtooth']
    oscFreq: range 500, 2000
    gainEnvelope0: range 0.1, 0.9
    gainEnvelope1: range 0.1, 0.9
    lfoType: options ['square', 'sawtooth', 'triangle']


  build = (context, parameters) ->
    osc = context.createOscillator()
    osc.type = parameters.oscType
    osc.frequency.value = parameters.oscFreq

    lfo = context.createOscillator()
    lfo.type = parameters.lfoType
    lfo.frequency.value = 1

    lfoEnvelope = SoundUtil.getEnvelope context, [10, 4], parameters.duration

    lfo.connect lfoEnvelope
    lfoEnvelope.connect osc.frequency

    envelope = [
      parameters.gainEnvelope0
      parameters.gainEnvelope1
      0
    ]
    gain = context.createGain()
    SoundUtil.applyRamp gain.gain, envelope, parameters.duration

    osc.connect gain

    start = ->
      osc.start()
      lfo.start()

    { start: start, destination: gain }


  { generation, type, spec, build }