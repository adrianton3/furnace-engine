define [
  'tokenizer/Tokenizer'
  'parser/Parser'
  'validator/Validator'
  'extractor/ValueExtractor'
  'import-export/ToPng'
], (
  Tokenizer
  Parser
  Validator
  ValueExtractor
  ToPng
) ->
  'use strict'

  baseUrl = 'http://madflame991.github.io/furnace-engine/src/index.html'
  tree = null
  errorLine = null
  inWorldEditor = null


  onChange = ->
    tree = parse inWorldEditor.getValue()


  setupEditors = ->
    inWorldEditor = CodeMirror.fromTextArea(document.getElementById('in'), {
      lineNumbers: true
      styleActiveLine: true
    })
    inWorldEditor.setSize 600, 400
    inWorldEditor.setOption 'theme', 'cobalt'
    inWorldEditor.on 'change', onChange
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


  setupComm = ->
    window.addEventListener(
      'message',
      (e) ->
        e.preventDefault()

        data = e.data
        if data.type == 'source'
          inWorldEditor.setValue data.source

        return
    , false)

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
  	    inWorldEditor.removeLineClass(errorLine - 1, 'background', 'line-error')
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
  	      inWorldEditor.removeLineClass(errorLine - 1, 'background', 'line-error')

        errorLine = line
        inWorldEditor.addLineClass(errorLine - 1, 'background', 'line-error')

      document.getElementById('status').classList.add('err')
      document.getElementById('status').classList.remove('ok')
      document.getElementById('status').innerHTML = ex.message || ex
      return null


  compile = ->
    emit { type: 'compile', tree }
    return


  setUrl = ->
    spec = inWorldEditor.getValue()
    encodedLevel = encodeURIComponent spec
    url = baseUrl + '?spec=' + encodedLevel

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
    setupComm()
    requestSource()

    return


  { run }