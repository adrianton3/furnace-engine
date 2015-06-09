define [
  'tokenizer/Tokenizer'
  'parser/Parser'
  'validator/Validator'
  'extractor/ValueExtractor'
  'import-export/ToPng'
  'sound/Sound'
  'sound/SoundUtil'

  'editor/furnace-mode'
], (
  Tokenizer
  Parser
  Validator
  ValueExtractor
  ToPng
  Sound
  SoundUtil
) ->
  'use strict'


  baseUrl = 'http://adrianton3.github.io/furnace-engine/src/index.html'
  errorLine = null
  inWorldEditor = null

  onChange = ->
    parse inWorldEditor.getValue()
    return


  setupEditors = ->
    inWorldEditor = ace.edit 'in'
    inWorldEditor.getSession().setMode 'ace/mode/furnace'
    inWorldEditor.setTheme 'ace/theme/monokai'
    inWorldEditor.on 'input', onChange
    return


  playing = false
  randomSound = (type) ->
    return if playing
    playing = true

    spec = Sound.getSpec Sound.CURRENT_GENERATION, type
    parameters = Sound.getRandomParameters type
    encoded = SoundUtil.encode Sound.CURRENT_GENERATION, type, parameters, spec
    document.getElementById('sound-encoded').value = encoded

    Sound.generate Sound.CURRENT_GENERATION, type, parameters
    .then (buffer) ->
      Sound.play buffer, -> playing = false
      return
    return


  setupSoundPanel = ->
    for i in [0..4]
      do (i) ->
        sXButton = document.getElementById "s#{i}"
        sXButton.addEventListener 'click', -> randomSound i
    return


  setupGui = ->
    compileButton = document.getElementById 'compile'
    compileButton.addEventListener 'click', compile

    getUrlButton = document.getElementById 'geturl'
    getUrlButton.addEventListener 'click', setUrl

    exportAsPngButton = document.getElementById 'exportaspng'
    exportAsPngButton.addEventListener 'click', exportAsPng
    return


  requestSource = ->
    emit type: 'request-source'
    return


  compile = ->
    emit
      type: 'compile'
      source: inWorldEditor.getValue()
    return


  mainEventHandlers =
    'source': (data) ->
      inWorldEditor.setValue data.source, -1


  mainListener = (e) ->
    e.preventDefault()

    data = e.data
    if data.type?
      mainEventHandlers[data.type](data)
    return


  setupComm = ->
    window.addEventListener 'message', mainListener, false
    return


  originUrl = '*'
  emit = (data) ->
    window.opener.postMessage data, originUrl
    return


  parse = (inText) ->
    try
      tokens = Tokenizer.chop inText
      tree = Parser.parse tokens
      Validator.validate tree

      if errorLine != null
        inWorldEditor.getSession().setAnnotations []
        errorLine = null

      document.getElementById('status').classList.add 'ok'
      document.getElementById('status').classList.remove 'err'
      document.getElementById('status').innerHTML = 'OK'

      document.getElementById('compile').disabled = false
      return ValueExtractor.extract(tree)
    catch ex
      document.getElementById('compile').disabled = true

      if ex.line or ex.token
        line = ex.line or ex.token.coords.line
        if line != errorLine && errorLine != null
          inWorldEditor.getSession().setAnnotations []

        errorLine = line
        inWorldEditor.getSession().setAnnotations([
            row: errorLine - 1
            text: ex.message || ex
            type: 'error'
        ])

      document.getElementById('status').classList.add('err')
      document.getElementById('status').classList.remove('ok')
      document.getElementById('status').innerHTML = ex.message || ex
      return null


  setUrl = ->
    spec = inWorldEditor.getValue()
    encodedLevel = encodeURIComponent spec
    url = "#{baseUrl}?spec=#{encodedLevel}"

    urlTextarea = document.getElementById 'url'
    urlTextarea.value = url
    return


  exportAsPng = ->
    spec = inWorldEditor.getValue()
    canvas = ToPng.encode(spec)

    image = document.createElement 'img'
    image.src = canvas.toDataURL()
    image.id = 'exported-spec'

    existingImage = document.getElementById 'exported-spec'
    if existingImage
      existingImage.parentNode.removeChild existingImage

    urlTextarea = document.getElementById 'url'
    urlTextarea.value = 'Exported spec as image\n' +
      'To decode the image access: ' + baseUrl + '?png=_image_url_'

    container = document.getElementById 'exported-container'
    container.appendChild image
    return


  run = ->
    setupEditors()
    setupGui()
    setupSoundPanel()
    setupComm()
    requestSource()
    return


  { run }