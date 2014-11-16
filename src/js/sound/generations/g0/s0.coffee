define [
  'sound/SoundUtil'
], (
  SoundUtil
) ->
  'use strict'


  { range, options } = SoundUtil

  generation = 0
  type = 0

  spec =
    duration: range 0.4, 1.0
    oscType: options ['square', 'sawtooth']
    oscFreq: range 200, 3000
    freqEnvelope0: range 300, 400
    freqEnvelope1: range 500, 600
    freqEnvelope2: range 300, 400
    freqEnvelope3: range 100, 200
    gainEnvelope0: range 0.6, 0.8
    gainEnvelope1: range 0.4, 0.8
    gainEnvelope2: range 0.1, 0.4
    gainEnvelope3: range 0.0, 0.2


  build = (context, parameters) ->
    osc = context.createOscillator()
    osc.type = parameters.oscType
    osc.frequency.value = parameters.oscFreq

    SoundUtil.applyRamp(
      osc.frequency
      [parameters.freqEnvelope0, parameters.freqEnvelope1, parameters.freqEnvelope2, parameters.freqEnvelope3]
      parameters.duration
    )

    gain = context.createGain()
    SoundUtil.applyRamp(
      gain.gain
      [parameters.gainEnvelope0, parameters.gainEnvelope1, parameters.gainEnvelope2, parameters.gainEnvelope3]
      parameters.duration
    )

    osc.connect gain

    start = -> osc.start()

    { start: start, destination: gain }


  { generation, type, spec, build }