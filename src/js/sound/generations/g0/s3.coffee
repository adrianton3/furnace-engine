define [
  'sound/SoundUtil'
], (
  SoundUtil
) ->
  'use strict'


  { range, options } = SoundUtil

  generation = 0
  type = 3

  spec =
    duration: range 0.2, 0.8
    oscType: options ['square', 'sawtooth']
    freqEnvelope0: range 500, 1000
    freqEnvelope1: range 100, 1000
    freqEnvelope2: range 100, 1000
    freqEnvelope3: range 100, 200
    gainEnvelope0: range 0.0, 0.2
    gainEnvelope1: range 0.1, 0.7
    gainEnvelope2: range 0.8, 0.9
    gainEnvelope3: range 0.0, 0.2


  build = (context, parameters) ->
    osc = context.createOscillator()
    osc.type = parameters.oscType

    envelope = [
      parameters.freqEnvelope0
      parameters.freqEnvelope1
      parameters.freqEnvelope2
      parameters.freqEnvelope3
    ]
    SoundUtil.applyRamp osc.frequency, envelope, parameters.duration

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

    { start: start, destination: gain }


  { generation, type, spec, build }