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
    duration: range 0.2, 1.4
    oscType: options ['square']
    oscFreq: range 2000, 3000
    freqEnvelope0: range 100, 200
    freqEnvelope1: range 300, 400
    freqEnvelope2: range 500, 600
    freqEnvelope3: range 100, 200
    gainEnvelope0: range 0.7, 1.0
    gainEnvelope1: range 0.4, 0.8
    gainEnvelope2: range 0.1, 0.4
    gainEnvelope3: range 0.0, 0.2
    lfoType: options ['square']


  build = (context, parameters) ->
    osc = context.createOscillator()
    osc.type = parameters.oscType

    lfo = context.createOscillator()
    lfo.type = parameters.lfoType
    lfo.frequency.value = 3

    lfoEnvelope = SoundUtil.getEnvelope context, [0, 20], parameters.duration

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