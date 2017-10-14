define [
  'sound/SoundUtil'
], (
  SoundUtil
) ->
  'use strict'


  { range, options } = SoundUtil

  generation = 0
  type = 1

  spec =
    duration: range 0.4, 0.8
    oscType: options ['square']
    oscFreq: range 100, 3000
    gainEnvelope0: range 0.6, 0.8
    gainEnvelope1: range 0.5, 0.6
    gainEnvelope2: range 0.1, 0.4
    gainEnvelope3: range 0.0, 0.2
    lfoType: options ['square', 'sawtooth']
    lfoFreq: range 1.0, 8.0
    lfoEnvelope0: range 0.0, 20.0
    lfoEnvelope1: range 0.0, 20.0


  build = (context, parameters) ->
    osc = context.createOscillator()
    osc.type = parameters.oscType
    osc.frequency.value = parameters.oscFreq

    lfo = context.createOscillator()
    lfo.type = parameters.lfoType
    lfo.frequency.value = parameters.lfoFreq

    envelope = [
      parameters.lfoEnvelope0
      parameters.lfoEnvelope1
    ]
    lfoEnvelope = SoundUtil.getEnvelope context, envelope, parameters.duration

    lfo.connect lfoEnvelope
    lfoEnvelope.connect osc.frequency

    envelope = [
      parameters.gainEnvelope0
      parameters.gainEnvelope1
      parameters.gainEnvelope2
      parameters.gainEnvelope3
    ]
    gain = context.createGain()
    SoundUtil.applyRamp gain.gain, envelope, parameters.duration

    osc.connect gain

    start = ->
      osc.start()
      lfo.start()

    { start: start, destination: gain }


  { generation, type, spec, build }