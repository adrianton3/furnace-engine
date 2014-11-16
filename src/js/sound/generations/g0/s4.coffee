define [
  'sound/SoundUtil'
], (
  SoundUtil
) ->
  'use strict'


  { range, options } = SoundUtil

  generation = 0
  type = 4

  spec =
    duration: range 0.2, 0.6
    gainEnvelope0: range 0.7, 1.0
    gainEnvelope1: range 0.4, 0.8
    gainEnvelope2: range 0.1, 0.4
    gainEnvelope3: range 0.0, 0.2


  build = (context, parameters) ->
    bufferSize = parameters.duration * context.sampleRate
    noiseBuffer = context.createBuffer 1, bufferSize, context.sampleRate
    output = noiseBuffer.getChannelData 0

    b0 = 0
    b1 = 0
    b2 = 0
    b3 = 0
    b4 = 0
    b5 = 0
    b6 = 0
    for i in [0...bufferSize]
      white = Math.random() * 2 - 1
      b0 = 0.99886 * b0 + white * 0.0555179
      b1 = 0.99332 * b1 + white * 0.0750759
      b2 = 0.96900 * b2 + white * 0.1538520
      b3 = 0.86650 * b3 + white * 0.3104856
      b4 = 0.55000 * b4 + white * 0.5329522
      b5 = -0.7616 * b5 - white * 0.0168980
      output[i] = b0 + b1 + b2 + b3 + b4 + b5 + b6 + white * 0.5362
      output[i] *= 0.11
      b6 = white * 0.115926

    whiteNoise = context.createBufferSource()
    whiteNoise.buffer = noiseBuffer
    whiteNoise.loop = true


    gain = context.createGain()
    SoundUtil.applyRamp(
      gain.gain
      [1.0, parameters.gainEnvelope0, parameters.gainEnvelope1, parameters.gainEnvelope2, parameters.gainEnvelope3]
      parameters.duration
    )

    whiteNoise.connect gain

    start = -> whiteNoise.start()

    { start: start, destination: gain }


  { generation, type, spec, build }