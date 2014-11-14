define [
  'sound/SoundUtil'
  'sound/generations/g0/s0'
  'sound/generations/g0/s1'
#  'sound/generations/g0/s2'
#  'sound/generations/g0/s3'
#  'sound/generations/g0/s4'
], (
  SoundUtil
) ->
  'use strict'


  audioContext = new AudioContext


  synthKey = (generation, type) ->
    "g#{generation}s#{type}"


  synthForKey = (generation, type) ->
    key = synthKey CURRENT_GENERATION, type
    synths[key]


  # register synths
  synths = {}
  for i in [1...arguments.length]
    synth = arguments[i]
    key = synthKey synth.generation, synth.type
    synths[key] = synth


  getSpec = (generation, type) ->
    synth = synthForKey generation, type
    synth.spec


  CURRENT_GENERATION = 0
  getRandomParameters = (type) ->
    synth = synthForKey CURRENT_GENERATION, type

    SoundUtil.randomParameters synth.spec


  getRecorder = (duration, callback) ->
    sampleRate = 44100
    context = new OfflineAudioContext 1, sampleRate * duration, sampleRate
    context.oncomplete = (e) ->
      callback e.renderedBuffer

    context


  generate = (generation, type, parameters) ->
    synth = synthForKey generation, type

    new Promise (resolve, reject) ->
      recorder = getRecorder 1, (buffer) ->
        resolve buffer

      box = synth.build recorder, parameters

      box.destination.connect recorder.destination
      box.start 0

      recorder.startRendering()
      return


  play = (buffer, onEnded) ->
    bufferSource = audioContext.createBufferSource()
    bufferSource.buffer = buffer
    bufferSource.connect audioContext.destination
    bufferSource.start()

    bufferSource.onended = ->
      bufferSource.disconnect()
      onEnded?()


  encode = (parameters) ->
    { generation, type, spec } = synthForKey parameters[0], parameters[1]
    SoundUtil.encode generation, type, parameters, spec


  decode = ->


  {
    CURRENT_GENERATION
    getSpec
    getRandomParameters
    generate
    play
    encode
    decode
  }